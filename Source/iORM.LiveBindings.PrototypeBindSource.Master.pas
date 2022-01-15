unit iORM.LiveBindings.PrototypeBindSource.Master;

interface

uses
  iORM.LiveBindings.BSPersistence, iORM.LiveBindings.PrototypeBindSource.Custom,
  System.Classes, iORM.LiveBindings.Interfaces, Data.Bind.Components;

type

  TioPrototypeBindSourceMaster = class(TioPrototypeBindSourceCustom, IioBSPersistenceClient)
  private
    FObjState: TioBSPersistence;
    FOnEditAction: TioBSOnEditAction;
    FOnRecordChangeAction: TioBSOnRecordChangeAction;
    // SourcePrototypeBindSource
    function GetSourcePBS: TioPrototypeBindSourceCustom;
    procedure SetSourcePBS(const Value: TioPrototypeBindSourceCustom);
    // Added methods
    function GetPersistence: TioBSPersistence;
    // OnEditAction property
    function GetOnEditAction: TioBSOnEditAction;
    procedure SetOnEditAction(const Value: TioBSOnEditAction);
    // OnRecordChangeAction property
    function GetOnRecordChangeAction: TioBSOnRecordChangeAction;
    procedure SetOnRecordChangeAction(const Value: TioBSOnRecordChangeAction);
    // procedure DoBeforeOpen; // In TioDataSetMaster is DoBeforeOpen but here is SetActive
  protected
    function IsMasterBS: boolean; override;
    function IsDetailBS: boolean; override;
    procedure SetActive(const Value: Boolean); override; // In TioDataSetMaster is DoBeforeOpen but here is SetActive
//    procedure DoBeforeScroll; override;
    procedure PosChanging(ABindComp: TBasicBindComponent); override; // In TioDataSetMaster is DoBeforeScroll but here is PosChanging
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Where;
    property ItemCount;
    // Added properties
    property Persistence: TioBSPersistence read GetPersistence;
  published
    // properties redeclared from TioCustomPrototypeBindSource
    property AutoActivate;
//    property AutoEdit;
//    property AutoPost;
//    property RecordCount;
//    property FieldDefs;
//    property ScopeMappings;
//    property OnCreateAdapter;
    // properties redeclared from TioCUstomPrototypeBindSource
    property TypeName;
    property TypeAlias;
    property Async default False;
    property AutoLoadData default True;
    property ViewDataType; // published: Master+Detail (si potrebbe fare una rilevazione automatica?)
    property WhereStr; // published: Master
    property OrderBy;
    property AutoRefreshOnNotification default TioAutoRefreshType.arEnabledNoReload;
    // Published properties: selectors
    property SelectorFor;
    // Published properties: paging
    property Paging;
    // Added properties
    property OnEditAction: TioBSOnEditAction read GetOnEditAction write SetOnEditAction default eSaveRevertPoint;
    property OnRecordChangeAction: TioBSOnRecordChangeAction read GetOnRecordChangeAction write SetOnRecordChangeAction default rcPersistIfChanged;
    property SourcePBS: TioPrototypeBindSourceCustom read GetSourcePBS write SetSourcePBS;
    // Published Events: selectors
    property OnBeforeSelectionObject;
    property OnSelectionObject;
    property OnAfterSelectionObject;
    property OnBeforeSelectionInterface;
    property OnSelectionInterface;
    property OnAfterSelectionInterface;
    // Published properties: selectors
    property OnReceiveSelectionCloneObject;
    property OnReceiveSelectionFreeObject;
  end;

implementation

uses
  System.SysUtils;

{ TioPrototypeBindSourceMaster }

constructor TioPrototypeBindSourceMaster.Create(AOwner: TComponent);
begin
  inherited;
  FObjState := TioBSPersistence.Create(Self);
  FOnEditAction := eSaveRevertPoint;
  FOnRecordChangeAction := rcPersistIfChanged;
end;

destructor TioPrototypeBindSourceMaster.Destroy;
begin
  FObjState.Free;
  inherited;
end;

function TioPrototypeBindSourceMaster.GetPersistence: TioBSPersistence;
begin
  Result := FObjState;
end;

function TioPrototypeBindSourceMaster.GetOnEditAction: TioBSOnEditAction;
begin
  Result := FOnEditAction;
end;

function TioPrototypeBindSourceMaster.GetOnRecordChangeAction: TioBSOnRecordChangeAction;
begin
  Result := FOnRecordChangeAction;
end;

function TioPrototypeBindSourceMaster.GetSourcePBS: TioPrototypeBindSourceCustom;
begin
  Result := MasterBindSource;
end;

function TioPrototypeBindSourceMaster.IsDetailBS: boolean;
begin
  // Do not inherit
  Result := False;
end;

function TioPrototypeBindSourceMaster.IsMasterBS: boolean;
begin
  // Do not inherit
  Result := True;
end;

procedure TioPrototypeBindSourceMaster.PosChanging(ABindComp: TBasicBindComponent);
begin
  inherited;
  Persistence.NotifyBeforeScroll;
end;

procedure TioPrototypeBindSourceMaster.SetActive(const Value: Boolean);
begin
  inherited;
  Persistence.Clear(False);
end;

procedure TioPrototypeBindSourceMaster.SetOnEditAction(const Value: TioBSOnEditAction);
begin
  FOnEditAction := Value;
end;

procedure TioPrototypeBindSourceMaster.SetOnRecordChangeAction(const Value: TioBSOnRecordChangeAction);
begin
  FOnRecordChangeAction := Value;
end;

procedure TioPrototypeBindSourceMaster.SetSourcePBS(const Value: TioPrototypeBindSourceCustom);
begin
  MasterBindSource := Value;
end;

end.