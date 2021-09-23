unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.Forms, FMX.Dialogs, FMX.TabControl, FMX.StdCtrls,
  System.Actions, FMX.ActnList, FMX.Gestures, FMX.Edit, FMX.ListView.Types, Data.Bind.GenData, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.ObjectScope,
  iORM.LiveBindings.PrototypeBindSource, FMX.ListView, Fmx.Bind.GenData,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, Interfaces, iORM.DB.Components.ConnectionDef;

type
  TMainForm = class(TForm)
    TabControl1: TTabControl;
    Main: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    ToolBar3: TToolBar;
    lblTitle3: TLabel;
    ToolBar4: TToolBar;
    lblTitle4: TLabel;
    GestureManager1: TGestureManager;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button10: TButton;
    Button11: TButton;
    ButtonSQLDestination: TButton;
    SQLDestination2: TButton;
    LoadSingleByProperty: TButton;
    ButtonAddIndex: TButton;
    ButtonDropIndex: TButton;
    btPersonDemo: TButton;
    btImmediateLoad: TButton;
    btLazyLoad: TButton;
    btShowInfo: TButton;
    RESTConn: TioRESTConnectionDef;
    procedure TabControl1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure ButtonSQLDestinationClick(Sender: TObject);
    procedure ButtonAddIndexClick(Sender: TObject);
    procedure SQLDestination2Click(Sender: TObject);
    procedure ButtonDropIndexClick(Sender: TObject);
    procedure LoadSingleByPropertyClick(Sender: TObject);
    procedure btPersonDemoClick(Sender: TObject);
    procedure btImmediateLoadClick(Sender: TObject);
    procedure btLazyLoadClick(Sender: TObject);
    procedure btShowInfoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  GlobalPerson: IPerson;

implementation

uses
  Model, iORM, System.Generics.Collections, iORM.Containers.List,
  iORM.Containers.Interfaces, iORM.LiveBindings.InterfaceListBindSourceAdapter,
  iORM.Utilities, iORM.LiveBindings.Interfaces,
  iORM.Where.Interfaces, iORM.Where, FireDAC.Comp.Client,
  iORM.DB.Interfaces;

{$R *.fmx}

procedure TMainForm.btImmediateLoadClick(Sender: TObject);
begin
  GlobalPerson := io.Load<IPerson>.ByID(1).ToObject;
end;

procedure TMainForm.btLazyLoadClick(Sender: TObject);
begin
  GlobalPerson := io.Load<IPerson>.Lazy.ByID(1).ToObject;
end;

procedure TMainForm.btPersonDemoClick(Sender: TObject);
var
  LPerson: IPerson;
  LCustomer: ICustomer;
begin
  LCustomer := io.di.Locate<ICustomer>.Get;
  LCustomer.FirstName := 'Paolo';
  LCustomer.LastName := 'Rossi';
  LCustomer.FidelityCardCode := '1234567890';
  LCustomer.Phones.Add(   TPhoneNumber.Create('Home', '02/1234567', LCustomer.ID)   );
  LCustomer.Phones.Add(   TPhoneNumber.Create('Mobile', '333/28176876', LCustomer.ID)   );
  io.Persist(LCustomer);

  LCustomer := nil;

  LPerson := io.Load<IPerson>._Where._Property('FirstName')._EqualTo('Paolo').
    _And._Property('LastName')._EqualTo('Rossi').ToObject;
  LPerson.FirstName := 'Paolone';
  io.Persist(LPerson);

  io.RefTo<IPhoneNumber>._Where._Property('PersonID')._EqualTo(LPerson.ID).Delete;

  io.Delete(LPerson);
end;

procedure TMainForm.btShowInfoClick(Sender: TObject);
begin
  ShowMessage(GlobalPerson.ID.ToString + ' - ' + GlobalPerson.FullName + ' (' + GlobalPerson.ClassNameProp + ') ' + GlobalPerson.Phones.Count.ToString + ' Numbers');
end;

procedure TMainForm.Button10Click(Sender: TObject);
var
  AList: IioList<IPerson>;
begin
  AList := io.Load<IPerson>._Where
  ._Property('ID')._GreaterThan(10)
  .AddDetail('Phones', '[TPhoneNumber.PhoneType] = ''Home''')
  .ToInterfacedList;
  ShowMessage(AList.Count.ToString + ' IPerson');
end;

procedure TMainForm.Button11Click(Sender: TObject);
var
  AList: IioList<IPerson>;
  LWhere: IioWhere<IPerson>;
  DetailWhere: IioWhere;
begin
  // Create the master where condition
  LWhere := io.Where<IPerson>._Property('ID')._GreaterThan(10);
  // Create the detail where condition
  DetailWhere := io.Where('[TPhoneNumber.PhoneType] = ''Home''');
  // Add the detail where condition to the master where condition
  LWhere.Details.AddOrUpdate('Phones', DetailWhere);

  AList := io.Load<IPerson>._Where(LWhere).ToInterfacedList;
  ShowMessage(AList.Count.ToString + ' IPerson');

end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  APerson: TPerson;
begin
  APerson := io.Load<TPerson>.ByID(Edit1.Text.ToInteger).ToObject;
  ShowMessage(APerson.ID.ToString + ' - ' + APerson.FullName + ' (' + APerson.ClassNameProp + ') ' + APerson.Phones.Count.ToString + ' Numbers');
  APerson.Free;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  LPerson: IPerson;
begin
  LPerson := io.Load<IPerson>.ByID(Edit1.Text.ToInteger).ToObject;
  ShowMessage(LPerson.ID.ToString + ' - ' + LPerson.FullName + ' (' + LPerson.ClassNameProp + ') ' + LPerson.Phones.Count.ToString + ' Numbers');
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  AList: TObjectList<TPerson>;
begin
  AList := io.Load<TPerson>
    ._Where
    ._Property('ID')._GreaterThan(10)
    .ToGenericList.OfType<TObjectList<TPerson>>;
  ShowMessage(AList.Count.ToString + ' IPerson');
  AList.Free;
end;

procedure TMainForm.Button4Click(Sender: TObject);
var
  AList: TioInterfacedList<IPerson>;
begin
  AList := TioInterfacedList<IPerson>.Create;
  io.Load<IPerson>.ToList(AList);
  ShowMessage(AList.Count.ToString + ' IPerson');
  AList.Free;
end;

procedure TMainForm.Button5Click(Sender: TObject);
var
  AList: IioList<IPerson>;
begin
  AList := io.Load<IPerson>._OrderBy('[Self.FirstName] DESC').ToInterfacedList;
  ShowMessage(AList.Count.ToString + ' IPerson');
end;

procedure TMainForm.Button6Click(Sender: TObject);
var
  AList: IioList<ICustomer>;
begin
  AList := io.Load<ICustomer>.ToInterfacedList;
  ShowMessage(AList.Count.ToString + ' ICustomer');
end;

procedure TMainForm.Button7Click(Sender: TObject);
var
  AList: IioList<IPerson>;
begin
  AList := io.Load<IPerson>('Customer').ToInterfacedList;
  ShowMessage(AList.Count.ToString + ' IPerson (as Customer)');
end;

procedure TMainForm.ButtonAddIndexClick(Sender: TObject);
begin
  io.RefTo<IPerson>.CreateIndex('[IPerson]_MyIndex', '[IPerson.FirstName]');
end;

procedure TMainForm.ButtonDropIndexClick(Sender: TObject);
begin
  io.RefTo('IPerson').DropIndex('[IPerson]_MyIndex');
end;

procedure TMainForm.ButtonSQLDestinationClick(Sender: TObject);
var
  LQry: TFDMemTable;
begin
  LQry := io.SQL('SELECT [.ID], [.FirstName] FROM [Self] WHERE [.ID] > 10').SelfClass(TPerson).ToMemTable;
  LQry.Open;
  try
    ShowMessage(LQry.RecordCount.ToString + ' records');
  finally
    LQry.Free;
  end;
end;

procedure TMainForm.LoadSingleByPropertyClick(Sender: TObject);
var
  APerson: IPerson;
begin
  APerson := io.Load<TPerson>._Where._PropertyEqualsTo('FirstName', 'Maurizio').ToObject;
  ShowMessage(APerson.ID.ToString + ' - ' + APerson.FullName + ' (' + APerson.ClassNameProp + ') ' + APerson.Phones.Count.ToString + ' Numbers');
end;

procedure TMainForm.SQLDestination2Click(Sender: TObject);
var
  LMemTable: TFDMemTable;
begin
  LMemTable := io.Load<IPerson>.ToMemTable;
  try
    ShowMessage(LMemTable.RecordCount.ToString + ' records');
  finally
    LMemTable.Free;
  end;
end;

procedure TMainForm.TabControl1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
{$IFDEF ANDROID}
  case EventInfo.GestureID of
    sgiLeft:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount-1] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex+1];
      Handled := True;
    end;

    sgiRight:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex-1];
      Handled := True;
    end;
  end;
{$ENDIF}
end;

end.
