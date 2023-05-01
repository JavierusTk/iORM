unit iORM.MVVM.VMAction;

interface

uses
  System.Classes, System.Generics.Collections, iORM.MVVM.Interfaces, iORM.LiveBindings.Interfaces,
  iORM.CommonTypes, iORM.LiveBindings.BSPersistence, iORM.StdActions.Interfaces;

type

  // =================================================================================================
  // BEGIN: MVVM BASE VIEW MODEL ACTION
  // =================================================================================================

  TioVMActionCustom = class (TComponent, IioVMAction)
  strict private
    FBindedViewActionsContainer: TList<IioViewAction>;
    FCaption: String;
    FEnabled: Boolean;
    FVisible: Boolean;
    FOnExecute: TNotifyEvent;
    FOnUpdate: TNotifyEvent;
    function Get_Version: String;
    procedure _InternalExecute; virtual;
    procedure _InternalUpdate; virtual;
  strict protected
    procedure _InternalExecuteStdAction; virtual;
    procedure _InternalUpdateStdAction; virtual;
    procedure _UpdateOriginal;
    procedure _ExecuteOriginal;
    procedure BindViewAction(const AViewAction: IioViewAction);
    procedure UnbindViewAction(const AViewAction: IioViewAction);
    procedure UnbindAllViewActions;
    // Caption property
    procedure SetCaption(const Value: String);
    function GetCaption: String;
    property Caption: String read GetCaption write SetCaption;
    // Enabled property
    procedure SetEnabled(const Value: Boolean);
    function GetEnabled: Boolean;
    property Enabled: Boolean read GetEnabled write SetEnabled default True;
    // Name property
    procedure SetName(const Value: TComponentName); reintroduce;
    function GetName: TComponentName;
    property Name: TComponentName read GetName write SetName;
    // Owner
    function GetOwnerComponent: TComponent;
    property Owner: TComponent read GetOwnerComponent;
    // Visible property
    procedure SetVisible(const Value: Boolean);
    function GetVisible: Boolean;
    property Visible: Boolean read GetVisible write SetVisible default True;
    // Events
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
    property OnUpdate: TNotifyEvent read FOnUpdate write FOnUpdate;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function HandlesTarget(Target: TObject): Boolean; virtual;
    function Execute: Boolean; virtual;
    function Update: Boolean; virtual;
  published
    property _Version: String read Get_Version;
  end;

  TioVMAction = class(TioVMActionCustom)
  public
    property Owner: TComponent read GetOwnerComponent;
  published
    // Properties
    property Caption;
    property Enabled;
    property Name;
    property Visible;
    // Events
    property OnExecute;
    property OnUpdate;
  end;

  // =================================================================================================
  // END: MVVM BASE VIEW MODEL ACTION
  // =================================================================================================

  // =================================================================================================
  // BEGIN: MVVM STANDARD VMACTIONS FOR BIND SOURCES
  // =================================================================================================

  // Base class for all BindSource standard actions
  TioVMActionBSCustom<T: IioStdActionTargetBindSource> = class(TioVMActionCustom)
  strict private
    FTargetBindSource: T;
    function Get_Version: String;
    procedure SetTargetBindSource(const Value: T);
  strict protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property TargetBindSource: T read FTargetBindSource write SetTargetBindSource;
  public
    constructor Create(AOwner: TComponent); override;
    function HandlesTarget(Target: TObject): Boolean; override;
    property Owner: TComponent read GetOwnerComponent;
    function Execute: Boolean; override;
    function Update: Boolean; override;
  published
    property Caption;
    property Enabled;
    property Name;
    property Visible;
    property _Version: String read Get_Version;
    // Events
    property OnExecute;
    property OnUpdate;
  end;

  // SelectCurrent action to make a selection for a Selector BindSource
  TioVMActionBSSelectCurrent = class(TioVMActionBSCustom<IioStdActionTargetBindSource>)
  strict private
    FSelectionType: TioSelectionType;
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property SelectionType: TioSelectionType read FSelectionType write FSelectionType default stAppend;
  end;

  // Paging NextPage action
  TioVMActionBSNextPage = class(TioVMActionBSCustom<IioStdActionTargetMasterBindSource>)
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
    property TargetBindSource;
  end;

  // Paging PreviousPage action
  TioVMActionBSPrevPage = class(TioVMActionBSCustom<IioStdActionTargetMasterBindSource>)
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
    property TargetBindSource;
  end;

  // WhereBuild
  TioVMActionWhereBuild = class(TioVMActionBSCustom<IioStdActionTargetMasterBindSource>)
  strict private
    FWhereAutoExecuteOnTargetBS: Boolean;
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property WhereAutoExecuteOnTargetBS: Boolean read FWhereAutoExecuteOnTargetBS write FWhereAutoExecuteOnTargetBS default True;
    property TargetBindSource;
  end;

  // WhereClear
  TioVMActionWhereClear = class(TioVMActionBSCustom<IioStdActionTargetMasterBindSource>)
  strict private
    FWhereAutoExecuteOnTargetBS: Boolean;
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property WhereAutoExecuteOnTargetBS: Boolean read FWhereAutoExecuteOnTargetBS write FWhereAutoExecuteOnTargetBS default True;
    property TargetBindSource;
  end;

  // =================================================================================================
  // END: MVVM STANDARD VMACTIONS FOR BIND SOURCES
  // =================================================================================================

  // =================================================================================================
  // BEGIN: MVVM STANDARD ACTIONS FOR BIND SOURCES WITH PERSISTENCE PROPERTY (MASTER BIND SOURCES ONLY)
  // =================================================================================================

  // Base class for all BinsDourceObjState standard actions
  TioVMActionBSPersistenceCustom = class(TioVMActionCustom)
  strict private
    FClearAfterExecute: Boolean;
    FDisableIfChangesDoesNotExists: Boolean;
    FDisableIfChangesExists: Boolean;
    FDisableIfSaved: Boolean;
    FRaiseIfChangesDoesNotExists: Boolean;
    FRaiseIfChangesExists: Boolean;
    FRaiseIfRevertPointSaved: Boolean;
    FRaiseIfRevertPointNotSaved: Boolean;
    FTargetBindSource: IioBSPersistenceClient;
    function Get_Version: String;
    procedure SetTargetBindSource(const Value: IioBSPersistenceClient);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property ClearAfterExecute: Boolean read FClearAfterExecute write FClearAfterExecute default True;
    property DisableIfChangesDoesNotExists: Boolean read FDisableIfChangesDoesNotExists write FDisableIfChangesDoesNotExists default False;
    property DisableIfChangesExists: Boolean read FDisableIfChangesExists write FDisableIfChangesExists default False;
    property DisableIfSaved: Boolean read FDisableIfSaved write FDisableIfSaved default False;
    property RaiseIfChangesDoesNotExists: Boolean read FRaiseIfChangesDoesNotExists write FRaiseIfChangesDoesNotExists default False;
    property RaiseIfChangesExists: Boolean read FRaiseIfChangesExists write FRaiseIfChangesExists default True;
    property RaiseIfRevertPointSaved: Boolean read FRaiseIfRevertPointSaved write FRaiseIfRevertPointSaved default False;
    property RaiseIfRevertPointNotSaved: Boolean read FRaiseIfRevertPointNotSaved write FRaiseIfRevertPointNotSaved default False;
    property TargetBindSource: IioBSPersistenceClient read FTargetBindSource write SetTargetBindSource;
  public
    constructor Create(AOwner: TComponent); override;
    function HandlesTarget(Target: TObject): Boolean; override;
    function Execute: Boolean; override;
    function Update: Boolean; override;
  published
    property _Version: String read Get_Version;
  end;

  TioVMActionBSPersistenceSaveRevertPoint = class(TioVMActionBSPersistenceCustom)
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
    property TargetBindSource;
  end;

  TioVMActionBSPersistenceClear = class(TioVMActionBSPersistenceCustom)
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
    property DisableIfChangesExists;
    property RaiseIfChangesExists;
    property TargetBindSource;
  end;

  TioVMActionBSPersistencePersist = class(TioVMActionBSPersistenceCustom)
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
//    property ClearAfterExecute; // Eliminata perch� poteva interferire con TioVMActionBSCloseQuery
    property DisableIfChangesDoesNotExists;
    property RaiseIfChangesDoesNotExists;
    property TargetBindSource;
  end;

  TioVMActionBSPersistenceRevert = class(TioVMActionBSPersistenceCustom)
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
//    property ClearAfterExecute; // Eliminata perch� poteva interferire con TioVMActionBSCloseQuery
    property DisableIfChangesDoesNotExists;
    property RaiseIfChangesDoesNotExists;
    property RaiseIfRevertPointNotSaved;
    property TargetBindSource;
  end;

  TioVMActionBSPersistenceRevertOrDelete = class(TioVMActionBSPersistenceCustom)
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
//    property ClearAfterExecute; // Eliminata perch� poteva interferire con TioVMActionBSCloseQuery
    property DisableIfChangesDoesNotExists;
    property RaiseIfChangesDoesNotExists;
    property RaiseIfRevertPointNotSaved;
    property TargetBindSource;
  end;

  TioVMActionBSPersistenceDelete = class(TioVMActionBSPersistenceCustom)
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
    property DisableIfChangesExists;
    property DisableIfSaved;
    property RaiseIfChangesExists default False;
    property RaiseIfRevertPointSaved;
    property TargetBindSource;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TioVMActionBSPersistenceReload = class(TioVMActionBSPersistenceCustom)
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
    property DisableIfChangesExists;
    property DisableIfSaved;
    property RaiseIfChangesExists default False;
    property RaiseIfRevertPointSaved;
    property TargetBindSource;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TioVMActionBSPersistenceAppend = class(TioVMActionBSPersistenceCustom)
  private
    FOnNewInstanceAsObject: TioStdActionNewInstanceAsObjectEvent;
    FOnNewInstanceAsInterface: TioStdActionNewInstanceAsInterfaceEvent;
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
    property DisableIfChangesExists;
    property DisableIfSaved;
    property RaiseIfChangesExists default False;
    property RaiseIfRevertPointSaved;
    property TargetBindSource;
    // events
    property OnNewInstanceAsObject: TioStdActionNewInstanceAsObjectEvent read FOnNewInstanceAsObject write FOnNewInstanceAsObject;
    property OnNewInstanceAsInterface: TioStdActionNewInstanceAsInterfaceEvent read FOnNewInstanceAsInterface write FOnNewInstanceAsInterface;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TioVMActionBSPersistenceInsert = class(TioVMActionBSPersistenceCustom)
  private
    FOnNewInstanceAsObject: TioStdActionNewInstanceAsObjectEvent;
    FOnNewInstanceAsInterface: TioStdActionNewInstanceAsInterfaceEvent;
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
  published
    property DisableIfChangesExists;
    property DisableIfSaved;
    property RaiseIfChangesExists default False;
    property RaiseIfRevertPointSaved;
    property TargetBindSource;
    // events
    property OnNewInstanceAsObject: TioStdActionNewInstanceAsObjectEvent read FOnNewInstanceAsObject write FOnNewInstanceAsObject;
    property OnNewInstanceAsInterface: TioStdActionNewInstanceAsInterfaceEvent read FOnNewInstanceAsInterface write FOnNewInstanceAsInterface;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TioVMActionBSCloseQuery = class(TioVMActionBSPersistenceCustom, IioBSCloseQueryAction, IioBSCloseQueryVMAction)
  strict private
    FExecuting, FExecutingEventHandler: Boolean;
    FInjectVMEventHandler: Boolean;
    FInjectViewEventHandler: Boolean;
    FInternalExecutionMode: TioCloseQueryActionExecutionMode;
    FOnCloseQuery: TCloseQueryEvent;
    FOnConfirmationRequest: TioBSCloseQueryConfirmationRequestEvent;
    FOnEditingAction: TioBSCloseQueryOnEditingAction;
    FOnExecuteAction: TioBSCloseQueryOnExecuteAction;
    FOnUpdateScope: TioBSCloseQueryActionUpdateScope;
    [weak]
    FParentCloseQueryAction: IioBSCloseQueryAction;
    procedure _InjectEventHandlerOnViewModel(const AViewModelAsTComponent: TComponent); // TComponent to avoid circular reference
    procedure _InjectEventHandlerOnView(const AView: TComponent);
    function _CanClose: Boolean;
    function _IsChildOf(const ATargetQueryAction: IioBSCloseQueryAction): Boolean;
    // InternalExecutionMode
    function GetInternalExecutionMode: TioCloseQueryActionExecutionMode;
    procedure SetInternalExecutionMode(const Value: TioCloseQueryActionExecutionMode);
    // ParentCloseQueryAction
    function GetParentCloseQueryAction: IioBSCloseQueryAction;
    procedure SetParentCloseQueryAction(const Value: IioBSCloseQueryAction);
  strict protected
    procedure _InternalExecuteStdAction; override;
    procedure _InternalUpdateStdAction; override;
    function DoOnConfirmationRequest: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
    function Executing: Boolean;
    function Update: Boolean; override;
    property InternalExecutionMode: TioCloseQueryActionExecutionMode read GetInternalExecutionMode write SetInternalExecutionMode;
    property ParentCloseQueryAction: IioBSCloseQueryAction read GetParentCloseQueryAction write SetParentCloseQueryAction;
  published
    procedure _OnCloseQueryEventHandler(Sender: TObject; var CanClose: Boolean); // Must be published
    property InjectViewEventHandler: Boolean read FInjectViewEventHandler write FInjectViewEventHandler default True;
    property InjectVMEventHandler: Boolean read FInjectVMEventHandler write FInjectVMEventHandler default True;
    property OnEditingAction: TioBSCloseQueryOnEditingAction read FOnEditingAction write FOnEditingAction default eaDisable;
    property OnExecuteAction: TioBSCloseQueryOnExecuteAction read FOnExecuteAction write FOnExecuteAction default eaClose;
    property OnUpdateScope: TioBSCloseQueryActionUpdateScope read FOnUpdateScope write FOnUpdateScope default usLocal;
    property TargetBindSource;
    // Events
    property OnCloseQuery: TCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;
    property OnConfirmationRequest: TioBSCloseQueryConfirmationRequestEvent read FOnConfirmationRequest write FOnConfirmationRequest;
  end;

  // =================================================================================================
  // END: MVVM STANDARD ACTIONS FOR BIND SOURCES WITH PERSISTENCE PROPERTY (MASTER BIND SOURCES ONLY)
  // =================================================================================================

  // =================================================================================================
  // BEGIN: MVVM STANDARD ACTIONS TO SHOW AN OBJECT
  // =================================================================================================

  // ShowCurrent action to show the current object of the BS
//  TioShowAction = class(TioVMActionCustom)
//  strict private
//    FEntityTypeName: String;
//    FFromBS: IioStdActionTargetBindSource;
//    FParentCloseQueryAction: IioBSCloseQueryAction;
//    FShowBy: TioShowBy;
//    FSelectorForBS: IioStdActionTargetBindSource;
//    FViewTypeName: String;
//    FVMTypeName: String;
//    FVVMTypeAlias: String;
//    FViewContext: TComponent;
//    FViewContextBy: TioViewContextBy;
//    FViewContextProvider: TioViewContextProvider;
//    FViewContextProviderName: String;
//    function Get_Version: String;
//    procedure SetFromBS(const Value: IioStdActionTargetBindSource);
//    procedure SetParentCloseQueryAction(const Value: IioBSCloseQueryAction);
//    procedure SetSelectorForBS(const Value: IioStdActionTargetBindSource);
//    procedure SetViewContext(const Value: TComponent);
//    procedure SetViewContextProvider(const Value: TioViewContextProvider);
//  strict protected
//    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
//  public
//    constructor Create(AOwner: TComponent); override;
//    function HandlesTarget(Target: TObject): Boolean; override;
//    procedure ExecuteTarget(Target: TObject); override;
//    procedure UpdateTarget (Target: TObject); override;
//  published
//    property EntityTypeName: String read FEntityTypeName write FEntityTypeName;
//    property FromBS: IioStdActionTargetBindSource read FFromBS write SetFromBS;
//    property ParentCloseQueryAction: IioBSCloseQueryAction read FParentCloseQueryAction write SetParentCloseQueryAction;
//    property ShowBy: TioShowBy read FShowBy write FShowBy;
//    property SelectorForBS: IioStdActionTargetBindSource read FSelectorForBS write SetSelectorForBS;
//    property ViewTypeName: String read FViewTypeName write FViewTypeName;
//    property VMTypeName: String read FVMTypeName write FVMTypeName;
//    property VVMTypeAlias: String read FVVMTypeAlias write FVVMTypeAlias;
//    property ViewContext: TComponent read FViewContext write SetViewContext;
//    property ViewContextBy: TioViewContextBy read FViewContextBy write FViewContextBy;
//    property ViewContextProvider: TioViewContextProvider read FViewContextProvider write SetViewContextProvider;
//    property ViewContextProviderName: String read FViewContextProviderName write FViewContextProviderName;
//    property _Version: String read Get_Version;
//  end;

  // =================================================================================================
  // END: MVVM STANDARD ACTIONS TO SHOW AN OBJECT
  // =================================================================================================

implementation

uses
  System.SysUtils, iORM.Utilities, iORM.Exceptions, iORM, System.Rtti,
  iORM.RttiContext.Factory, iORM.StdActions.CloseQueryActionRegister;

{ TioVMActionCustom }

constructor TioVMActionCustom.Create(AOwner: TComponent);
begin
  inherited;
  FEnabled := True;
  FVisible := True;
  FBindedViewActionsContainer := TList<IioViewAction>.Create;
  // Solleva una eccezione se non siamo su un ViewModel
  if not Supports(Owner, IioViewModel) then
    raise EioException.Create(ClassName, 'Create', Format('Component "%s" can only be used on class "TioViewModel" or its descendants.', [ClassName]));
end;

destructor TioVMActionCustom.Destroy;
begin
  UnbindAllViewActions;
  FBindedViewActionsContainer.Free;
  inherited;
end;

function TioVMActionCustom.Execute: Boolean;
begin
  _ExecuteOriginal;
  Result := False;
end;

function TioVMActionCustom.Update: Boolean;
begin
  _UpdateOriginal;
  Result := False;
end;

function TioVMActionCustom.GetCaption: String;
begin
  Result := FCaption;
end;

function TioVMActionCustom.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

function TioVMActionCustom.GetName: TComponentName;
begin
  Result := inherited Name;
end;

function TioVMActionCustom.GetOwnerComponent: TComponent;
begin
  Result := inherited Owner;
end;

function TioVMActionCustom.GetVisible: Boolean;
begin
  Result := FVisible;
end;

function TioVMActionCustom.Get_Version: String;
begin
  Result := io.Version;
end;

function TioVMActionCustom.HandlesTarget(Target: TObject): Boolean;
begin
  Result := False;
end;

procedure TioVMActionCustom._ExecuteOriginal;
var
  LViewAction: IioViewAction;
begin
   // Execute the ViewAction.onBeforeExecute event
  for LViewAction in FBindedViewActionsContainer do
    LViewAction.DoBeforeExecute;
  // Execute the VMAction.onExecute event if assigned (or a standard action)
  _InternalExecute;
  // Execute the ViewAction.onAfterExecute event
  for LViewAction in FBindedViewActionsContainer do
    LViewAction.DoAfterExecute;
end;

procedure TioVMActionCustom._InternalExecute;
begin
  // Execute the VMAction.onExecute event if assigned
  if Assigned(FOnExecute) then
    FOnExecute(Self)
  else
    _InternalExecuteStdAction;
end;

procedure TioVMActionCustom._InternalExecuteStdAction;
begin
  // Nothing to do here
end;

procedure TioVMActionCustom._InternalUpdate;
begin
  // Execute the VMAction.onExecute event if assigned
  if Assigned(FOnUpdate) then
    FOnUpdate(Self)
  else
    _InternalUpdateStdAction;
end;

procedure TioVMActionCustom._InternalUpdateStdAction;
begin
  // Nothing to do here
end;

procedure TioVMActionCustom._UpdateOriginal;
var
  LViewAction: IioViewAction;
begin
  // Execute the ViewAction.onBeforeUpdate event
  for LViewAction in FBindedViewActionsContainer do
    LViewAction.DoBeforeUpdate;
  // Execute the VMAction.onUpdate event if assigned (or a standard action)
  _InternalUpdate;
  // Execute the ViewAction.onAfterUpdatee event ia assigned or standard action
  for LViewAction in FBindedViewActionsContainer do
    LViewAction.DoAfterUpdate;
end;

procedure TioVMActionCustom.BindViewAction(const AViewAction: IioViewAction);
begin
  FBindedViewActionsContainer.Add(AViewAction);
  AViewAction.VMAction := Self;
  // Propagate Caption/Enabled/Visible to the new registered ViewAction if linked
  if AViewAction.CaptionLinkedToVMAction then
    AViewAction.Caption := FCaption;
  if AViewAction.EnabledLinkedToVMAction then
    AViewAction.Enabled := FEnabled;
  if AViewAction.VisibleLinkedToVMAction then
    AViewAction.Visible := FVisible;
end;

procedure TioVMActionCustom.UnbindViewAction(const AViewAction: IioViewAction);
begin
  FBindedViewActionsContainer.Remove(AViewAction);
  AViewAction.VMAction := nil;
end;

procedure TioVMActionCustom.UnbindAllViewActions;
var
  I: Integer;
begin
  for I := FBindedViewActionsContainer.Count-1 downto 0 do
    UnbindViewAction(FBindedViewActionsContainer[I]);
end;

procedure TioVMActionCustom.SetCaption(const Value: String);
var
  LViewAction: IioViewAction;
begin
  if Value <> FCaption then
  begin
    FCaption := Value;
    for LViewAction in FBindedViewActionsContainer do
      if LViewAction.CaptionLinkedToVMAction then
        LViewAction.Caption := Value;
  end;
end;

procedure TioVMActionCustom.SetEnabled(const Value: Boolean);
var
  LViewAction: IioViewAction;
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    for LViewAction in FBindedViewActionsContainer do
      if LViewAction.EnabledLinkedToVMAction then
        LViewAction.Enabled := Value;
  end;
end;

procedure TioVMActionCustom.SetName(const Value: TComponentName);
begin
  inherited SetName(Value);
end;

procedure TioVMActionCustom.SetVisible(const Value: Boolean);
var
  LViewAction: IioViewAction;
begin
  if Value <> FVisible then
  begin
    FVisible := Value;
    for LViewAction in FBindedViewActionsContainer do
      if LViewAction.VisibleLinkedToVMAction then
        LViewAction.Visible := Value;
  end;
end;

{ TioBSStdVMAction<T> }

constructor TioVMActionBSCustom<T>.Create(AOwner: TComponent);
begin
  inherited;
  FTargetBindSource := nil;
end;

function TioVMActionBSCustom<T>.Execute: Boolean;
begin
  Result := False;
  if Assigned(FTargetBindSource) then
    inherited;
end;

function TioVMActionBSCustom<T>.Get_Version: String;
begin
  Result := io.Version;
end;

function TioVMActionBSCustom<T>.HandlesTarget(Target: TObject): Boolean;
begin
  Result := Assigned(Target) and Supports(FTargetBindSource, TioUtilities.TypeInfoToGUID(TypeInfo(T))) and FTargetBindSource.isActive;
end;

procedure TioVMActionBSCustom<T>.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = (FTargetBindSource as TComponent)) then
    TargetBindSource := nil;
end;

procedure TioVMActionBSCustom<T>.SetTargetBindSource(const Value: T);
begin
  if @Value <> @FTargetBindSource then
  begin
    FTargetBindSource := Value;
    if Value <> nil then
      (Value as TComponent).FreeNotification(Self);
  end;
end;

function TioVMActionBSCustom<T>.Update: Boolean;
begin
  Result := False;
  if Assigned(FTargetBindSource) then
    inherited
  else
    Enabled := False;
end;

{ TioBSSelectCurrentVMAction }

constructor TioVMActionBSSelectCurrent.Create(AOwner: TComponent);
begin
  inherited;
  FSelectionType := stAppend;
end;

procedure TioVMActionBSSelectCurrent._InternalExecuteStdAction;
begin
  inherited;
  TargetBindSource.SelectCurrent(FSelectionType);
end;

procedure TioVMActionBSSelectCurrent._InternalUpdateStdAction;
begin
  inherited;
  Enabled := TargetBindSource.CanDoSelection;
end;

{ TioBSNextPage }

procedure TioVMActionBSNextPage._InternalExecuteStdAction;
begin
  inherited;
  TargetBindSource.Paging.NextPage;
end;

procedure TioVMActionBSNextPage._InternalUpdateStdAction;
begin
  inherited;
  Enabled := TargetBindSource.IsActive and TargetBindSource.Paging.Enabled and not TargetBindSource.Paging.IsLastPage;
end;

{ TioBSPrevPage }

procedure TioVMActionBSPrevPage._InternalExecuteStdAction;
begin
  inherited;
  TargetBindSource.Paging.PrevPage;
end;

procedure TioVMActionBSPrevPage._InternalUpdateStdAction;
begin
  inherited;
  Enabled := TargetBindSource.IsActive and TargetBindSource.Paging.Enabled and not TargetBindSource.Paging.IsFirstPage;
end;

{ TioVMActionBSPersistenceCustom }

constructor TioVMActionBSPersistenceCustom.Create(AOwner: TComponent);
begin
  inherited;
  FClearAfterExecute := True;
  FDisableIfChangesDoesNotExists := False;
  FDisableIfChangesExists := False;
  FDisableIfSaved := False;
  FRaiseIfChangesDoesNotExists := False;
  FRaiseIfChangesExists := True;
  FRaiseIfRevertPointSaved := False;
  FRaiseIfRevertPointNotSaved := False;
end;

function TioVMActionBSPersistenceCustom.Execute: Boolean;
begin
  Result := False;
  if Assigned(FTargetBindSource) then
    inherited;
end;

function TioVMActionBSPersistenceCustom.Get_Version: String;
begin
  Result := io.Version;
end;

function TioVMActionBSPersistenceCustom.HandlesTarget(Target: TObject): Boolean;
begin
  Result := Assigned(Target) and Supports(FTargetBindSource, IioBSPersistenceClient) and FTargetBindSource.isActive;
end;

procedure TioVMActionBSPersistenceCustom.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = (FTargetBindSource as TComponent)) then
    TargetBindSource := nil;
end;

procedure TioVMActionBSPersistenceCustom.SetTargetBindSource(const Value: IioBSPersistenceClient);
begin
  if Value <> FTargetBindSource then
  begin
    FTargetBindSource := Value;
    if Value <> nil then
      (Value as TComponent).FreeNotification(Self);
  end;
end;

function TioVMActionBSPersistenceCustom.Update: Boolean;
begin
  Result := False;
  if Assigned(FTargetBindSource) then
    inherited
  else
    Enabled := False;
end;

{ TioVMActionBSPersistenceSaveRevertPoint }

procedure TioVMActionBSPersistenceSaveRevertPoint._InternalExecuteStdAction;
begin
  TargetBindSource.Persistence.SaveRevertPoint(True);
end;

procedure TioVMActionBSPersistenceSaveRevertPoint._InternalUpdateStdAction;
begin
  Enabled := Assigned(TargetBindSource) and TargetBindSource.Persistence.CanSaveRevertPoint;
end;

{ TioVMActionBSPersistenceClear }

procedure TioVMActionBSPersistenceClear._InternalExecuteStdAction;
begin
  TargetBindSource.Persistence.Clear(RaiseIfChangesExists);
end;

procedure TioVMActionBSPersistenceClear._InternalUpdateStdAction;
begin
  Enabled := Assigned(TargetBindSource) and TargetBindSource.Persistence.CanClear;
  Enabled := Enabled and ((not DisableIfChangesExists) or not TargetBindSource.Persistence.IsChanged);
end;

{ TioBSPersistencePersist }

procedure TioVMActionBSPersistencePersist._InternalExecuteStdAction;
begin
  TargetBindSource.Refresh(True); // Otherwise, in some cases, an outdated value persisted
  TargetBindSource.Persistence.Persist(RaiseIfChangesDoesNotExists, ClearAfterExecute);
end;

procedure TioVMActionBSPersistencePersist._InternalUpdateStdAction;
begin
  Enabled := Assigned(TargetBindSource) and TargetBindSource.Persistence.CanPersist;
  Enabled := Enabled and ((not DisableIfChangesDoesNotExists) or TargetBindSource.Persistence.IsChanged);
end;

{ TioVMActionBSPersistenceRevert }

procedure TioVMActionBSPersistenceRevert._InternalExecuteStdAction;
begin
  TargetBindSource.Persistence.Revert(RaiseIfRevertPointNotSaved, RaiseIfChangesDoesNotExists, ClearAfterExecute);
end;

procedure TioVMActionBSPersistenceRevert._InternalUpdateStdAction;
begin
  Enabled := Assigned(TargetBindSource) and TargetBindSource.Persistence.CanRevert;
  Enabled := Enabled and ((not DisableIfChangesDoesNotExists) or TargetBindSource.Persistence.IsChanged);
end;

{ TioVMActionBSPersistenceRevertOrDelete }

procedure TioVMActionBSPersistenceRevertOrDelete._InternalExecuteStdAction;
begin
  TargetBindSource.Persistence.RevertOrDelete(RaiseIfRevertPointNotSaved, RaiseIfChangesDoesNotExists, ClearAfterExecute);
end;

procedure TioVMActionBSPersistenceRevertOrDelete._InternalUpdateStdAction;
begin
//  Enabled := Assigned(TargetBindSource) and TargetBindSource.Persistence.CanRevertOrDelete;
//  Enabled := Enabled and ((not DisableIfChangesDoesNotExists) or TargetBindSource.Persistence.IsChanged or TargetBindSource.Persistence.IsInserting);
end;

{ TioVMActionBSPersistenceDelete }

constructor TioVMActionBSPersistenceDelete.Create(AOwner: TComponent);
begin
  inherited;
  RaiseIfChangesExists := False;
end;

procedure TioVMActionBSPersistenceDelete._InternalExecuteStdAction;
begin
  TargetBindSource.Persistence.Delete(RaiseIfRevertPointSaved, RaiseIfChangesExists);
end;

procedure TioVMActionBSPersistenceDelete._InternalUpdateStdAction;
begin
  Enabled := Assigned(TargetBindSource) and TargetBindSource.Persistence.CanDelete;
  Enabled := Enabled and ((not DisableIfChangesExists) or not TargetBindSource.Persistence.IsChanged);
  Enabled := Enabled and ((not DisableIfSaved) or not TargetBindSource.Persistence.IsSavedRevertPoint);
end;

{ TioVMActionBSPersistenceReload }

constructor TioVMActionBSPersistenceReload.Create(AOwner: TComponent);
begin
  inherited;
  RaiseIfChangesExists := False;
end;

procedure TioVMActionBSPersistenceReload._InternalExecuteStdAction;
begin
  TargetBindSource.Persistence.Reload(RaiseIfRevertPointSaved, RaiseIfChangesExists);
end;

procedure TioVMActionBSPersistenceReload._InternalUpdateStdAction;
begin
  inherited;
  Enabled := Assigned(TargetBindSource) and TargetBindSource.Persistence.CanReload;
  Enabled := Enabled and ((not DisableIfChangesExists) or not TargetBindSource.Persistence.IsChanged);
  Enabled := Enabled and ((not DisableIfSaved) or not TargetBindSource.Persistence.IsSavedRevertPoint);
end;

{ TioVMActionBSPersistenceAppend }

constructor TioVMActionBSPersistenceAppend.Create(AOwner: TComponent);
begin
  inherited;
  RaiseIfChangesExists := False;
end;

procedure TioVMActionBSPersistenceAppend._InternalExecuteStdAction;
var
  LNewInstanceAsObject: TObject;
  LNewInstanceAsInterface: IInterface;
begin
  inherited;
  // New instance as object (OnNewInstanceAsObject event handler)
  if Assigned(FOnNewInstanceAsObject) then
  begin
    FOnNewInstanceAsObject(Self, LNewInstanceAsObject);
    if LNewInstanceAsObject <> nil then
    begin
      TargetBindSource.Persistence.Append(LNewInstanceAsObject, RaiseIfRevertPointSaved, RaiseIfChangesExists);
      Exit;
    end
    else
      raise EioException.Create(Self.ClassName, '_InternalExecuteStdAction', 'Invalid new instance (nil)');
  end;
  // New instance as Interface (OnNewInstanceAsInterface event handler)
  if Assigned(FOnNewInstanceAsInterface) then
  begin
    FOnNewInstanceAsInterface(Self, LNewInstanceAsInterface);
    if LNewInstanceAsInterface <> nil then
    begin
      TargetBindSource.Persistence.Append(LNewInstanceAsInterface, RaiseIfRevertPointSaved, RaiseIfChangesExists);
      Exit;
    end
    else
      raise EioException.Create(Self.ClassName, '_InternalExecuteStdAction', 'Invalid new instance (nil)');
  end;
  // New instance not provided (created by the ABSAdapter itself)
  TargetBindSource.Persistence.Append(RaiseIfRevertPointSaved, RaiseIfChangesExists);
end;

procedure TioVMActionBSPersistenceAppend._InternalUpdateStdAction;
begin
  inherited;
  Enabled := Assigned(TargetBindSource) and TargetBindSource.Persistence.CanInsert;
  Enabled := Enabled and ((not DisableIfChangesExists) or not TargetBindSource.Persistence.IsChanged);
  Enabled := Enabled and ((not DisableIfSaved) or not TargetBindSource.Persistence.IsSavedRevertPoint);
end;

{ TioVMActionBSPersistenceInsert }

constructor TioVMActionBSPersistenceInsert.Create(AOwner: TComponent);
begin
  inherited;
  RaiseIfChangesExists := False;
end;

procedure TioVMActionBSPersistenceInsert._InternalExecuteStdAction;
var
  LNewInstanceAsObject: TObject;
  LNewInstanceAsInterface: IInterface;
begin
  inherited;
  // New instance as object (OnNewInstanceAsObject event handler)
  if Assigned(FOnNewInstanceAsObject) then
  begin
    FOnNewInstanceAsObject(Self, LNewInstanceAsObject);
    if LNewInstanceAsObject <> nil then
    begin
      TargetBindSource.Persistence.Insert(LNewInstanceAsObject, RaiseIfRevertPointSaved, RaiseIfChangesExists);
      Exit;
    end
    else
      raise EioException.Create(Self.ClassName, '_InternalExecuteStdAction', 'Invalid new instance (nil)');
  end;
  // New instance as Interface (OnNewInstanceAsInterface event handler)
  if Assigned(FOnNewInstanceAsInterface) then
  begin
    FOnNewInstanceAsInterface(Self, LNewInstanceAsInterface);
    if LNewInstanceAsInterface <> nil then
    begin
      TargetBindSource.Persistence.Insert(LNewInstanceAsInterface, RaiseIfRevertPointSaved, RaiseIfChangesExists);
      Exit;
    end
    else
      raise EioException.Create(Self.ClassName, '_InternalExecuteStdAction', 'Invalid new instance (nil)');
  end;
  // New instance not provided (created by the ABSAdapter itself)
  TargetBindSource.Persistence.Insert(RaiseIfRevertPointSaved, RaiseIfChangesExists);
end;

procedure TioVMActionBSPersistenceInsert._InternalUpdateStdAction;
begin
  inherited;
  Enabled := Assigned(TargetBindSource) and TargetBindSource.Persistence.CanInsert;
  Enabled := Enabled and ((not DisableIfChangesExists) or not TargetBindSource.Persistence.IsChanged);
  Enabled := Enabled and ((not DisableIfSaved) or not TargetBindSource.Persistence.IsSavedRevertPoint);
end;

{ TioVMActionBSCloseQuery }

constructor TioVMActionBSCloseQuery.Create(AOwner: TComponent);
begin
  inherited;
  FExecuting := False;
  FExecutingEventHandler := False;
  FInjectViewEventHandler := True;
  FInjectVMEventHandler := True;
  FInternalExecutionMode := emActive;
  FOnEditingAction := eaDisable;
  FOnExecuteAction := eaClose;
  FOnUpdateScope := usLocal;
  TioBSCloseQueryActionRegister.RegisterAction(Self as IioBSCloseQueryAction);
end;

destructor TioVMActionBSCloseQuery.Destroy;
begin
  TioBSCloseQueryActionRegister.UnregisterAction(Self as IioBSCloseQueryAction);
  inherited;
end;

function TioVMActionBSCloseQuery.DoOnConfirmationRequest: Boolean;
begin
  Result := True;
  if Assigned(FOnConfirmationRequest) then
    FOnConfirmationRequest(Self, Result);
end;

procedure TioVMActionBSCloseQuery.SetInternalExecutionMode(const Value: TioCloseQueryActionExecutionMode);
begin
  FInternalExecutionMode := Value;
end;

procedure TioVMActionBSCloseQuery.SetParentCloseQueryAction(const Value: IioBSCloseQueryAction);
begin
  FParentCloseQueryAction := Value;
end;

function TioVMActionBSCloseQuery.Execute: Boolean;
begin
  _ExecuteOriginal;  // Ritorna all'implementazione originale
  Result := False;
end;

function TioVMActionBSCloseQuery.Executing: Boolean;
begin
  Result := FExecuting;
end;

function TioVMActionBSCloseQuery.GetInternalExecutionMode: TioCloseQueryActionExecutionMode;
begin
  Result := FInternalExecutionMode;
end;

function TioVMActionBSCloseQuery.GetParentCloseQueryAction: IioBSCloseQueryAction;
begin
  Result := FParentCloseQueryAction;
end;

function TioVMActionBSCloseQuery._IsChildOf(const ATargetQueryAction: IioBSCloseQueryAction): Boolean;
begin
  Result := TioBSCloseQueryCommonBehaviour.IsChildOf(Self, ATargetQueryAction);
end;

function TioVMActionBSCloseQuery.Update: Boolean;
begin
  _UpdateOriginal;  // Ritorna all'implementazione originale
  Result := False;
end;

procedure TioVMActionBSCloseQuery._InjectEventHandlerOnView(const AView: TComponent);
var
  LEventHandlerToInject: TMethod;
begin
  // On runtime only and only if enabled
  if (csDesigning in ComponentState) or not FInjectViewEventHandler then
    Exit;
  // Set the TMethod Code and Data for the event handloer to be assigned to the View/ViewContext
  LEventHandlerToInject.Code := ClassType.MethodAddress('_OnCloseQueryEventHandler');
  LEventHandlerToInject.Data := Self;
  TioBSCloseQueryCommonBehaviour.InjectOnCloseQueryEventHandler(AView, LEventHandlerToInject, False);
end;

procedure TioVMActionBSCloseQuery._InjectEventHandlerOnViewModel(const AViewModelAsTComponent: TComponent);
var
  LEventHandlerToInject: TMethod;
begin
  // On runtime only and only if enabled
  if (csDesigning in ComponentState) or not FInjectVMEventHandler then
    Exit;
  // Set the TMethod Code and Data for the event handloer to be assigned to the View/ViewContext
  LEventHandlerToInject.Code := ClassType.MethodAddress('_OnCloseQueryEventHandler');
  LEventHandlerToInject.Data := Self;
  TioBSCloseQueryCommonBehaviour.InjectOnCloseQueryEventHandler(AViewModelAsTComponent, LEventHandlerToInject, True);
end;

function TioVMActionBSCloseQuery._CanClose: Boolean;
begin
  Result := (TargetBindSource = nil) or TargetBindSource.Persistence.IsEmpty or TargetBindSource.Persistence.CanSaveRevertPoint or (FOnEditingAction <> eaDisable);
  // Se � il caso interroga anche le ChildCQA
  if FOnUpdateScope in [usGlobal, usDisableIfChilds] then
    Result := Result and TioBSCloseQueryActionRegister.CanClose(Self, FOnUpdateScope = usDisableIfChilds);
  // se c'� un event handler per l'evento OnCloseQuery lascia a lui l'ultima parola
  if Assigned(FOnCloseQuery) then
    FOnCloseQuery(Self, Result);
end;

procedure TioVMActionBSCloseQuery._InternalUpdateStdAction;
begin
  Enabled := _CanClose;
end;

procedure TioVMActionBSCloseQuery._InternalExecuteStdAction;
var
  LViewModel: IioViewModelInternal;
begin
  FExecuting := True;
  try
    // NB: DoOnConfirmationRequest richiede eventuale conferma all'utente ma solo se � in modalit� attiva
    //      cio� � la prima BSCloseQueryAction della catena di esecuzione delle CloseQueryActions. HO
    //      fatto in questo modo sia perch� altrimenti ci sarebbero potute essere varie richieste di conferma
    //      sia perch� altrimenti avevo un AV error.
    if _CanClose and ((FInternalExecutionMode = emPassive) or DoOnConfirmationRequest) then
    begin
      // Se � il caso fa l'Execute anche sulle ChildCQA
      // NB: Le esegue sempre a partire da quella creata pi� recentemente (child) e andando all'indietro
      //      quindi esegue prima le ChildCQA e poi se stessa
      if FOnUpdateScope in [usGlobal] then
        TioBSCloseQueryActionRegister.Execute(Self);
      // In base a come impostata esegue l'azione
      if (FOnEditingAction = eaAutoPersist) and TargetBindSource.Persistence.CanPersist then
        TargetBindSource.Persistence.Persist;
      if (FOnEditingAction = eaAutoRevert) and TargetBindSource.Persistence.CanRevert then
        TargetBindSource.Persistence.Revert;
      if Supports(Owner, IioViewModelInternal, LViewModel) then
      begin
        if not FExecutingEventHandler then
        begin
          case FOnExecuteAction of
            eaClose:
              LViewModel.Close;
            eaTerminateApplication:
              io.TerminateApplication;
          end;
        end;
      end
      else
        raise EioException.Create(ClassName, '_InternalExecuteStdAction', 'Owner does not implement the "IioViewModelInternal" interface.');
    end;
  finally
    FExecuting := False;
  end;
end;

procedure TioVMActionBSCloseQuery._OnCloseQueryEventHandler(Sender: TObject; var CanClose: Boolean);
begin
  FExecutingEventHandler := True;
  try
    CanClose := _CanClose;
    if CanClose and not FExecuting then
      _InternalExecuteStdAction;
  finally
    FExecutingEventHandler := False;
  end;
end;

{ TioVMActionWhereBuild }

constructor TioVMActionWhereBuild.Create(AOwner: TComponent);
begin
  inherited;
  FWhereAutoExecuteOnTargetBS := True;
end;

procedure TioVMActionWhereBuild._InternalExecuteStdAction;
begin
  inherited;
  TargetBindSource.WhereBuild(FWhereAutoExecuteOnTargetBS);
end;

procedure TioVMActionWhereBuild._InternalUpdateStdAction;
begin
  inherited;
  Enabled := TargetBindSource.isActive;
end;

{ TioVMActionWhereClear }

constructor TioVMActionWhereClear.Create(AOwner: TComponent);
begin
  inherited;
  FWhereAutoExecuteOnTargetBS := False;
end;

procedure TioVMActionWhereClear._InternalExecuteStdAction;
begin
  inherited;
  TargetBindSource.WhereClear(FWhereAutoExecuteOnTargetBS);
end;

procedure TioVMActionWhereClear._InternalUpdateStdAction;
begin
  inherited;
  Enabled := TargetBindSource.isActive;
end;

end.
