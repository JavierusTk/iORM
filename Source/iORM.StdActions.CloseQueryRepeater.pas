unit iORM.StdActions.CloseQueryRepeater;

interface

uses
  iORM.CommonTypes, System.Classes;

const
  RECURSIVE_ONE_LEVEL = 1;
  RECURSIVE_UNLIMITED = 0;

type

  TioCloseQueryRepeater = class (TComponent)
  private
    FScope: TioBSCloseQueryRepeaterScope;
    procedure _InjectEventHandler;
    function _CanCloseView(const AView: TComponent; const AMaxLevel: Integer; const ALevel: Integer = 0): Boolean;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    procedure _OnCloseQueryEventHandler(Sender: TObject; var CanClose: Boolean); // Must be published
    // properties
    property Scope: TioBSCloseQueryRepeaterScope read FScope write FScope default rsFirstLevelChilds;
  end;


implementation

uses
  iORM.StdActions.Interfaces, iORM.MVVM.ViewModelBridge, System.SysUtils;

{ TioCloseQueryRepeater }

constructor TioCloseQueryRepeater.Create(AOwner: TComponent);
begin
  inherited;
  FScope := rsFirstLevelChilds;
end;

procedure TioCloseQueryRepeater.Loaded;
begin
  inherited;
  _InjectEventHandler;
end;

function TioCloseQueryRepeater._CanCloseView(const AView: TComponent; const AMaxLevel, ALevel: Integer): Boolean;
var
  I: Integer;
  LBSCloseQueryAction: IioBSCloseQueryAction;
begin
  Result := True;

  // Primo ciclo per cercare un VMBridge o una CloseQueryAction
  for I := 0 to AView.ComponentCount - 1 do
  begin
    // Se il componente � un ViewModelBridge
    if AView.Components[I] is TioViewModelBridge then
    begin
      if not TioViewModelBridge(AView.Components[I]).ViewModel._CanClose then
        Exit(False);
    end
    else
    // Se il componente � una CloseQueryAction
    if Supports(AView.Components[I], IioBSCloseQueryAction, LBSCloseQueryAction) then
    begin
      if not LBSCloseQueryAction._CanClose then
        Exit(False);
    end;
  end;

  // Prosegue ricorsivamente nei childs se non ha raggionto il livello di annidamento massimo oppure se � illimitato
  if (ALevel < AMaxLevel) or (AMaxLevel = RECURSIVE_UNLIMITED) then
    for I := 0 to AView.ComponentCount - 1 do
      if AView.Components[I].ComponentCount > 0 then
        if not _CanCloseView(AView.Components[I], AMaxLevel, ALevel+1) then
          Exit(False);
end;

procedure TioCloseQueryRepeater._InjectEventHandler;
var
  LEventHandlerToInject: TMethod;
begin
  // On runtime only
  if (csDesigning in ComponentState) then
    Exit;
  // Set the TMethod Code and Data for the event handloer to be assigned to the View/ViewContext
  LEventHandlerToInject.Code := ClassType.MethodAddress('_OnCloseQueryEventHandler');
  LEventHandlerToInject.Data := Self;
  TioBSCloseQueryCommonBehaviour.InjectOnCloseQueryEventHandler(Owner, LEventHandlerToInject, False);
end;

procedure TioCloseQueryRepeater._OnCloseQueryEventHandler(Sender: TObject; var CanClose: Boolean);
begin
  case FScope of
    rsFirstLevelChilds:
      CanClose := _CanCloseView(Owner, RECURSIVE_ONE_LEVEL);
    rsDeepChilds:
      CanClose := _CanCloseView(Owner, RECURSIVE_UNLIMITED);
  end;
end;

end.
