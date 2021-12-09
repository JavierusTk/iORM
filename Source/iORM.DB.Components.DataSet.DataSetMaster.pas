unit iORM.DB.Components.DataSet.DataSetMaster;

interface

uses
  iORM.DB.Components.DataSet.DataSet, iORM.LiveBindings.Interfaces,
  iORM.DB.Components.BindSourceObjState, System.Classes;

type

  TioDataSetMaster = class(TioDataSet, IioBindSourceObjStateClient)
  private
    FObjState: TioBindSourceObjStateManager;
    FOnRecordChangeAction: TioBSOnRecordChangeAction;
    function GetSourceDataSet: TioDataSet;
    procedure SetSourceDataSet(const Value: TioDataSet);
    // Added methods
    function GetObjState: TioBindSourceObjStateManager;
    function IsActive: Boolean;
  protected
    procedure DoBeforeScroll; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Where;
    // Added properties
    property ObjState: TioBindSourceObjStateManager read GetObjState;
  published
    property TypeName;
    property TypeAlias;
    property Async default False;
    property AutoLoadData default True;
//    property AutoPersist default True; // published: Master (per� cambiarlo in modo che, se true, persiste al cambio di record)
    property ViewDataType; // published: Master+Detail (si potrebbe fare una rilevazione automatica?)
    property WhereStr; // published: Master
    property OrderBy;
    property AutoRefreshOnNotification default TioAutoRefreshType.arEnabledNoReload;
    // Published properties: selectors
    property SelectorFor;
    // Published properties: paging
    property Paging;
    // Added properties
    property OnRecordChangeAction: TioBSOnRecordChangeAction read FOnRecordChangeAction write FOnRecordChangeAction default rcPersistIfChanged;
    property SourceDataSet: TioDataSet read GetSourceDataSet write SetSourceDataSet;
  end;

implementation

uses
  System.SysUtils;

{ TioDataSetMaster }

constructor TioDataSetMaster.Create(AOwner: TComponent);
begin
  inherited;
  FObjState := TioBindSourceObjStateManager.Create(Self);
  FOnRecordChangeAction := rcPersistIfChanged;
end;

destructor TioDataSetMaster.Destroy;
begin
  FObjState.Free;
  inherited;
end;

procedure TioDataSetMaster.DoBeforeScroll;
begin
  inherited;
  ObjState.NotifyRecordChange(FOnRecordChangeAction);
end;

function TioDataSetMaster.GetObjState: TioBindSourceObjStateManager;
begin
  Result := FObjState;
end;

function TioDataSetMaster.GetSourceDataSet: TioDataSet;
begin
  Result := MasterDataSet;
end;

function TioDataSetMaster.IsActive: Boolean;
begin
  Result := Active;
end;

procedure TioDataSetMaster.SetSourceDataSet(const Value: TioDataSet);
begin
  MasterDataSet := Value;
end;

end.
