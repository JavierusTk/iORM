{ *************************************************************************** }
{ }
{ iORM - (interfaced ORM) }
{ }
{ Copyright (C) 2015-2016 Maurizio Del Magno }
{ }
{ mauriziodm@levantesw.it }
{ mauriziodelmagno@gmail.com }
{ https://github.com/mauriziodm/iORM.git }
{ }
{ }
{ *************************************************************************** }
{ }
{ This file is part of iORM (Interfaced Object Relational Mapper). }
{ }
{ Licensed under the GNU Lesser General Public License, Version 3; }
{ you may not use this file except in compliance with the License. }
{ }
{ iORM is free software: you can redistribute it and/or modify }
{ it under the terms of the GNU Lesser General Public License as published }
{ by the Free Software Foundation, either version 3 of the License, or }
{ (at your option) any later version. }
{ }
{ iORM is distributed in the hope that it will be useful, }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the }
{ GNU Lesser General Public License for more details. }
{ }
{ You should have received a copy of the GNU Lesser General Public License }
{ along with iORM.  If not, see <http://www.gnu.org/licenses/>. }
{ }
{ *************************************************************************** }

unit iORM.LiveBindings.ActiveObjectBindSourceAdapter;

interface

uses
  Data.Bind.ObjectScope, iORM.CommonTypes, System.Classes, System.Generics.Collections,
  iORM.Context.Properties.Interfaces, iORM.LiveBindings.Interfaces,
  iORM.LiveBindings.Notification, iORM.Where.Interfaces, iORM.MVVM.Interfaces,
  System.Rtti;

const
  VIEW_DATA_TYPE = TioViewDataType.dtSingle;

type

  TioActiveObjectBindSourceAdapter = class(TObjectBindSourceAdapter, IioContainedBindSourceAdapter, IioActiveBindSourceAdapter,
    IioNaturalBindSourceAdapterSource)
  private
    FAsync: Boolean;
    FWhere: IioWhere;
    FWhereDetailsFromDetailAdapters: Boolean;
    // FClassRef: TioClassRef;
    FTypeName, FTypeAlias: String; // NB: TypeAlias has no effect in this adapter (only used by interfaced BSA)
    FLocalOwnsObject: Boolean;
    FAutoLoadData: Boolean;
    FReloading: Boolean;
    FMasterProperty: IioProperty;
    FMasterAdaptersContainer: IioDetailBindSourceAdaptersContainer;
    FDetailAdaptersContainer: IioDetailBindSourceAdaptersContainer;
    FBindSource: IioNotifiableBindSource;
    // FNaturalBSA_MasterBindSourceAdapter: IioActiveBindSourceAdapter;  *** NB: Code presente (commented) in the unit body ***
    FDataSetLinkContainer: IioBSAToDataSetLinkContainer;
    FBSPersistenceDeleting: Boolean;
    // TypeName
    procedure SetTypeName(const AValue: String);
    function GetTypeName: String;
    // TypeAlias
    procedure SetTypeAlias(const AValue: String);
    function GetTypeAlias: String;
    // Async property
    function GetIoAsync: Boolean;
    procedure SetIoAsync(const Value: Boolean);
    // AutoPost property
    procedure SetioAutoPost(const Value: Boolean);
    function GetioAutoPost: Boolean;
    // WhereStr property
    procedure SetIoWhere(const Value: IioWhere);
    function GetIoWhere: IioWhere;
    // ioWhereDetailsFromDetailAdapters property
    function GetioWhereDetailsFromDetailAdapters: Boolean;
    procedure SetioWhereDetailsFromDetailAdapters(const Value: Boolean);
    // ioViewDataType
    function GetIoViewDataType: TioViewDataType;
    // ioOwnsObjects
    function GetOwnsObjects: Boolean;
    // State
    function GetState: TBindSourceAdapterState;
    // Fields
    function GetFields: TList<TBindSourceAdapterField>;
    // ItemIndex
    function GetItemIndex: Integer;
    procedure SetItemIndex(const Value: Integer);
    // Items
    function GetItems(const AIndex: Integer): TObject;
    procedure SetItems(const AIndex: Integer; const Value: TObject);
    // AutoLoadData
    procedure SetAutoLoadData(const Value: Boolean);
    function GetAutoLoadData: Boolean;
    // Reloading
    function GetReloading: Boolean;
    procedure SetReloading(const Value: Boolean);
    // BSPersistenceDeleting
    function GetBSPersistenceDeleting: Boolean;
    procedure SetBSPersistenceDeleting(const Value: Boolean);
  protected
    function SupportsNestedFields: Boolean; override;
    procedure AddFields; override;
    function GetCanActivate: Boolean; override;
    // =========================================================================
    // Part for the support of the IioNotifiableBindSource interfaces (Added by iORM)
    // because is not implementing IInterface (NB: RefCount DISABLED)
    function QueryInterface(const IID: TGUID; out Obj): HResult; reintroduce; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
{$IFDEF AUTOREFCOUNT}
    function __ObjAddRef: Integer; override;
    function __ObjRelease: Integer; override;
{$ENDIF}
    // =========================================================================
    procedure DoBeforeOpen; override;
    procedure DoBeforeEdit; override;
    procedure DoBeforeDelete; override;
    procedure DoAfterPost; override;
    procedure DoAfterPostFields(AFields: TArray<TBindSourceAdapterField>); override;
    procedure DoAfterDelete; override;
    procedure DoAfterScroll; override;
    procedure DoBeforeSelection(var ASelected: TObject; var ASelectionType: TioSelectionType);
    procedure DoSelection(var ASelected: TObject; var ASelectionType: TioSelectionType; var ADone: Boolean);
    procedure DoAfterSelection(var ASelected: TObject; var ASelectionType: TioSelectionType);
    procedure SetObjStatus(AObjStatus: TioObjStatus);
    function UseObjStatus: Boolean;
    function GetBaseObjectClassName: String;
    // Generic parameter must be <IInterface> (for interfaced list such as IioList<IInterface>) or
    // <TObject> (for non interfaced list such as TList<IInterface>)
    procedure InternalSetDataObject(const ADataObject: TObject; const AOwnsObject: Boolean = True); overload;
    procedure InternalSetDataObject(const ADataObject: IInterface; const AOwnsObject: Boolean = False); overload;
  public
    constructor Create(AClassRef: TioClassRef; AWhere: IioWhere; AOwner: TComponent; ADataObject: TObject; AutoLoadData: Boolean;
      AOwnsObject: Boolean = True); overload;
    destructor Destroy; override;
    function MasterAdaptersContainer:IioDetailBindSourceAdaptersContainer;
    procedure SetMasterAdaptersContainer(AMasterAdaptersContainer: IioDetailBindSourceAdaptersContainer);
    procedure SetMasterProperty(AMasterProperty: IioProperty);
    procedure SetBindSource(ANotifiableBindSource: IioNotifiableBindSource);
    function GetBindSource: IioNotifiableBindSource;
    function HasBindSource: boolean;
    procedure ExtractDetailObject(AMasterObj: TObject);
    procedure PersistCurrent;
    procedure PersistAll;
    function NewDetailBindSourceAdapter(const AOwner: TComponent; const AMasterPropertyName: String; const AWhere: IioWhere): IioActiveBindSourceAdapter;
    function NewNaturalObjectBindSourceAdapter(const AOwner: TComponent): IioActiveBindSourceAdapter;
    function GetDetailBindSourceAdapterByMasterPropertyName(const AMasterPropertyName: String): IioActiveBindSourceAdapter;
    function GetMasterBindSourceAdapter: IioActiveBindSourceAdapter;
    function DetailAdaptersContainer: IioDetailBindSourceAdaptersContainer;
    procedure Append(AObject: TObject); reintroduce; overload;
    procedure Append(AObject: IInterface); reintroduce; overload;
    procedure Insert(AObject: TObject); reintroduce; overload;
    procedure Insert(AObject: IInterface); reintroduce; overload;
    function Notify(const Sender: TObject; const [Ref] ANotification: TioBSNotification): Boolean;
    procedure Refresh(const ANotify: Boolean = True); reintroduce; overload;
    procedure Reload;
    procedure LoadPage;
    function DataObject: TObject;
    procedure SetDataObject(const ADataObject: TObject; const AOwnsObject: Boolean = True); overload;
    procedure SetDataObject(const ADataObject: IInterface; const AOwnsObject: Boolean = False); overload;
    procedure ClearDataObject;
    function GetCurrentOID: Integer;
    function HasMasterBSA: Boolean;
    function IsInterfaceBSA: Boolean;
    function GetMasterPropertyName: String;
    function GetDataSetLinkContainer: IioBSAToDataSetLinkContainer;
    procedure DeleteListViewItem(const AItemIndex: Integer; const ADelayMilliseconds: Integer = 100);
    function AsTBindSourceAdapter: TBindSourceAdapter;
    procedure ReceiveSelection(ASelected: TObject; ASelectionType: TioSelectionType); overload;
    procedure ReceiveSelection(ASelected: IInterface; ASelectionType: TioSelectionType); overload;
    function AsActiveBindSourceAdapter: IioActiveBindSourceAdapter;
  end;

implementation

uses
  iORM, System.SysUtils,
  iORM.LiveBindings.Factory, iORM.Context.Map.Interfaces,
  iORM.Where.Factory, iORM.Exceptions, iORM.LiveBindings.CommonBSAPersistence,
  iORM.LiveBindings.CommonBSABehavior, iORM.Context.Container,
  iORM.Context.Factory;

{ TioActiveListBindSourceAdapter<T> }

{$IFDEF AUTOREFCOUNT}

function TioActiveObjectBindSourceAdapter.__ObjAddRef: Integer;
begin
  // Nothing (event the "inherited")
end;

function TioActiveObjectBindSourceAdapter.__ObjRelease: Integer;
begin
  // Nothing (event the "inherited")
end;
{$ENDIF}

procedure TioActiveObjectBindSourceAdapter.Append(AObject: TObject);
begin
  Assert(False);
end;

procedure TioActiveObjectBindSourceAdapter.AddFields;
var
  LType: TRttiType;
  LIntf: IGetMemberObject;
begin
  // inherited; // NB: Don't inherit from ancestor
  LType := GetObjectType;
  LIntf := TBindSourceAdapterGetMemberObject.Create(Self);
//  AddFieldsToList(LType, Self, Self.Fields, LIntf); // Original code
//  AddPropertiesToList(LType, Self, Self.Fields, LIntf); // Original code
  TioCommonBSABehavior.AddFields(LType, Self, LIntf, ''); // To support iORM nested fields on child objects
end;

procedure TioActiveObjectBindSourceAdapter.Append(AObject: IInterface);
begin
  raise EioException.Create(Self.ClassName, 'Append', 'This ActiveBindSourceAdapter is for class referenced instances only.');
end;

function TioActiveObjectBindSourceAdapter.AsActiveBindSourceAdapter: IioActiveBindSourceAdapter;
begin
  Result := Self as IioActiveBindSourceAdapter;
end;

function TioActiveObjectBindSourceAdapter.AsTBindSourceAdapter: TBindSourceAdapter;
begin
  Result := Self as TBindSourceAdapter;
end;

procedure TioActiveObjectBindSourceAdapter.ClearDataObject;
begin
  Self.InternalSetDataObject(nil, False);
end;

constructor TioActiveObjectBindSourceAdapter.Create(AClassRef: TioClassRef; AWhere: IioWhere; AOwner: TComponent; ADataObject: TObject;
  AutoLoadData: Boolean; AOwnsObject: Boolean);
begin
  FAutoLoadData := AutoLoadData;
  FAsync := False;
  FReloading := False;
  FBSPersistenceDeleting := False;

  // If the AObject is assigned the set the BaseRttiType from this instance (most accurate) else resolve the TypeName
  // AObject is always a TObject by generic constraint
  if Assigned(ADataObject) then
    AClassRef := ADataObject.ClassType;
  inherited Create(AOwner, ADataObject, AClassRef, AOwnsObject);

  FLocalOwnsObject := AOwnsObject;
  FWhere := AWhere;
  FWhereDetailsFromDetailAdapters := False;
  FTypeName := AClassRef.ClassName;
  FTypeAlias := ''; // NB: TypeAlias has no effect in this adapter (only used by interfaced BSA)
  FDataSetLinkContainer := TioLiveBindingsFactory.BSAToDataSetLinkContainer;
  // Set Master & Details adapters reference
  FMasterAdaptersContainer := nil;
  FDetailAdaptersContainer := TioLiveBindingsFactory.DetailAdaptersContainer(Self);
end;

procedure TioActiveObjectBindSourceAdapter.DeleteListViewItem(const AItemIndex, ADelayMilliseconds: Integer);
begin
  raise EioException.Create(Self.ClassName, 'DeleteListViewItem', 'Method not available in ObjectBindSourceAdapters.');
end;

destructor TioActiveObjectBindSourceAdapter.Destroy;
begin
  // Detach itself from MasterAdapterContainer (if it's contained)
  if Assigned(FMasterAdaptersContainer) then
    FMasterAdaptersContainer.RemoveBindSourceAdapter(Self);
  // Free the DetailAdaptersContainer
  FDetailAdaptersContainer.Free;
  inherited;
end;

function TioActiveObjectBindSourceAdapter.DetailAdaptersContainer: IioDetailBindSourceAdaptersContainer;
begin
  Result := FDetailAdaptersContainer;
end;

procedure TioActiveObjectBindSourceAdapter.DoAfterPost;
begin
  inherited;
  TioCommonBSAPersistence.Post(Self);
end;

procedure TioActiveObjectBindSourceAdapter.DoAfterPostFields(AFields: TArray<TBindSourceAdapterField>);
begin
  inherited;
  TioCommonBSAPersistence.Post(Self);
end;

procedure TioActiveObjectBindSourceAdapter.DoAfterScroll;
begin
  inherited;
  TioCommonBSAPersistence.AfterScroll(Self);
end;

procedure TioActiveObjectBindSourceAdapter.DoAfterSelection(var ASelected: TObject; var ASelectionType: TioSelectionType);
begin
  if Assigned(FBindSource) then
    FBindSource.DoAfterSelection(ASelected, ASelectionType);
end;

procedure TioActiveObjectBindSourceAdapter.DoBeforeDelete;
begin
  inherited;
  TioCommonBSAPersistence.BeforeDelete(Self);
end;

procedure TioActiveObjectBindSourceAdapter.DoAfterDelete;
begin
  inherited;
  DoAfterScroll; // Mauri 11/01/2022: Aggiunto perch� altrimenti iin alcuni casi particolari dava errori
  TioCommonBSAPersistence.AfterDelete(Self);
end;

procedure TioActiveObjectBindSourceAdapter.DoBeforeEdit;
begin
  inherited;
  TioCommonBSAPersistence.BeforeEdit(Self);
end;

procedure TioActiveObjectBindSourceAdapter.DoBeforeOpen;
begin
  inherited;
  TioCommonBSAPersistence.Load(Self);
end;

procedure TioActiveObjectBindSourceAdapter.DoBeforeSelection(var ASelected: TObject; var ASelectionType: TioSelectionType);
begin
  if Assigned(FBindSource) then
    FBindSource.DoBeforeSelection(ASelected, ASelectionType);
end;

procedure TioActiveObjectBindSourceAdapter.DoSelection(var ASelected: TObject; var ASelectionType: TioSelectionType;
  var ADone: Boolean);
begin
  if Assigned(FBindSource) then
    FBindSource.DoSelection(ASelected, ASelectionType, ADone);
end;

procedure TioActiveObjectBindSourceAdapter.ExtractDetailObject(AMasterObj: TObject);
var
  LDetailObj: TObject;
  AValue: TValue;
begin
  LDetailObj := nil;
  // Check parameter, if the MasterObject is not assigned
  // then close the BSA
  if not Assigned(AMasterObj) then
  begin
    Self.InternalSetDataObject(LDetailObj, False); // 2� parameter false ABSOLUTELY!!!!!!!
    Exit;
  end;
  // Extract master property value
  AValue := FMasterProperty.GetValue(AMasterObj);
  // if not empty extract the detail object
  if not AValue.IsEmpty then
    if FMasterProperty.IsInterface then
      raise EioException.Create(Self.ClassName, 'ExtractDetailObject', 'Master property (in the master object) is an interface type.')
    else
      LDetailObj := AValue.AsObject;
  // Set it to the Adapter itself
  Self.InternalSetDataObject(LDetailObj, False); // 2� parameter false ABSOLUTELY!!!!!!!
end;
// procedure TioActiveObjectBindSourceAdapter.ExtractDetailObject(
// AMasterObj: TObject);
// var
// ADetailObj: TObject;
// AValue: TValue;
// begin
// ADetailObj := nil;
// // Check parameter, if the MasterObject is not assigned
// //  then close the BSA
// if not Assigned(AMasterObj) then
// begin
// Self.SetDataObject(nil, False);  // 2� parameter false ABSOLUTELY!!!!!!!
// Exit;
// end;
// // Extract master property value
// AValue := FMasterProperty.GetValue(AMasterObj);
// // if not empty extract the detail object
// if not AValue.IsEmpty then
// if FMasterProperty.IsInterface then
// ADetailObj := TObject(AValue.AsInterface)
// else
// ADetailObj := AValue.AsObject;
// // Set it to the Adapter itself
// Self.SetDataObject(ADetailObj, False);  // 2� parameter false ABSOLUTELY!!!!!!!
// end;

function TioActiveObjectBindSourceAdapter.GetAutoLoadData: Boolean;
begin
  Result := FAutoLoadData;
end;

function TioActiveObjectBindSourceAdapter.GetBaseObjectClassName: String;
begin
  Result := FTypeName;
end;

function TioActiveObjectBindSourceAdapter.GetBindSource: IioNotifiableBindSource;
begin
  Result := FBindSource;
end;

function TioActiveObjectBindSourceAdapter.GetBSPersistenceDeleting: Boolean;
begin
  Result := FBSPersistenceDeleting;
end;

function TioActiveObjectBindSourceAdapter.GetCanActivate: Boolean;
begin
  // Riportato allo stato originale della classe capostipite perch�
  // altrimenti e non veniva espressamente impostato il DataObject
  // con un SetDataObject e quindi l'oggetto si sarebbe dovuto caricare
  // dal DB (ORM) in realt� l'adapter non si attivava mai perch�
  // questa funzione avrebbe ritornato sempre False visto che il DataObject
  // era = a nil. IN questo modo invece funziona.
  Result := True;
end;

function TioActiveObjectBindSourceAdapter.GetCurrentOID: Integer;
begin
  Result := TioMapContainer.GetMap(Current.ClassName).GetProperties.GetIdProperty.GetValue(Self.Current).AsInteger;
end;

function TioActiveObjectBindSourceAdapter.DataObject: TObject;
begin
  Result := TObjectBindSourceAdapter(Self).DataObject;
end;

function TioActiveObjectBindSourceAdapter.GetDataSetLinkContainer: IioBSAToDataSetLinkContainer;
begin
  Result := FDataSetLinkContainer;
end;

function TioActiveObjectBindSourceAdapter.GetDetailBindSourceAdapterByMasterPropertyName(const AMasterPropertyName: String)
  : IioActiveBindSourceAdapter;
begin
  Result := FDetailAdaptersContainer.GetBindSourceAdapterByMasterPropertyName(AMasterPropertyName);
end;

function TioActiveObjectBindSourceAdapter.GetFields: TList<TBindSourceAdapterField>;
begin
  Result := Self.Fields;
end;

function TioActiveObjectBindSourceAdapter.GetIoAsync: Boolean;
begin
  Result := FAsync;
end;

function TioActiveObjectBindSourceAdapter.NewDetailBindSourceAdapter(const AOwner: TComponent; const AMasterPropertyName: String; const AWhere: IioWhere): IioActiveBindSourceAdapter;
begin
  // Return the requested DetailBindSourceAdapter and set the current master object
  Result := FDetailAdaptersContainer.NewBindSourceAdapter(AOwner, FTypeName, AMasterPropertyName, AWhere);
  FDetailAdaptersContainer.SetMasterObject(Current);
end;

function TioActiveObjectBindSourceAdapter.GetioAutoPost: Boolean;
begin
  Result := Self.AutoPost;
end;

function TioActiveObjectBindSourceAdapter.GetIoViewDataType: TioViewDataType;
begin
  Result := VIEW_DATA_TYPE;
end;

function TioActiveObjectBindSourceAdapter.GetIoWhere: IioWhere;
begin
  Result := FWhere;
  // Fill the WhereDetails from the DetailAdapters container if enabled
  // NB: Create it if not assigned
  if FWhereDetailsFromDetailAdapters then
  begin
    if not Assigned(FWhere) then
      FWhere := TioWhereFactory.NewWhere;
    FDetailAdaptersContainer.FillWhereDetails(FWhere.Details);
  end;
end;

function TioActiveObjectBindSourceAdapter.GetioWhereDetailsFromDetailAdapters: Boolean;
begin
  Result := FWhereDetailsFromDetailAdapters;
end;

function TioActiveObjectBindSourceAdapter.GetItemIndex: Integer;
begin
  Result := inherited ItemIndex;
end;

function TioActiveObjectBindSourceAdapter.GetItems(const AIndex: Integer): TObject;
begin
  Result := DataObject;
end;

function TioActiveObjectBindSourceAdapter.GetMasterBindSourceAdapter: IioActiveBindSourceAdapter;
begin
  Result := nil;
  if Self.HasMasterBSA then
    Result := FMasterAdaptersContainer.GetMasterBindSourceAdapter;
end;

function TioActiveObjectBindSourceAdapter.GetMasterPropertyName: String;
begin
  Result := FMasterProperty.GetName;
end;

function TioActiveObjectBindSourceAdapter.GetOwnsObjects: Boolean;
begin
  Result := FLocalOwnsObject;
end;

function TioActiveObjectBindSourceAdapter.GetReloading: Boolean;
begin
  Result := FReloading;
end;

function TioActiveObjectBindSourceAdapter.GetState: TBindSourceAdapterState;
begin
  Result := Self.State;
end;

function TioActiveObjectBindSourceAdapter.GetTypeAlias: String;
begin
  Result := FTypeAlias;
end;

function TioActiveObjectBindSourceAdapter.GetTypeName: String;
begin
  Result := FTypeName;
end;

function TioActiveObjectBindSourceAdapter.NewNaturalObjectBindSourceAdapter(const AOwner: TComponent): IioActiveBindSourceAdapter;
begin
  Result := TioLiveBindingsFactory.NaturalObjectBindSourceAdapter(AOwner, Self);
end;

procedure TioActiveObjectBindSourceAdapter.Insert(AObject: TObject);
begin
  Assert(False);
end;

procedure TioActiveObjectBindSourceAdapter.Insert(AObject: IInterface);
begin
  raise EioException.Create(Self.ClassName, 'Append', 'This ActiveBindSourceAdapter is for class referenced instances only.');
end;

function TioActiveObjectBindSourceAdapter.HasBindSource: boolean;
begin
  Result := Assigned(FBindSource);
end;

function TioActiveObjectBindSourceAdapter.HasMasterBSA: Boolean;
begin
  Result := Assigned(FMasterProperty);
end;

function TioActiveObjectBindSourceAdapter.IsInterfaceBSA: Boolean;
begin
  Result := False;
end;

procedure TioActiveObjectBindSourceAdapter.LoadPage;
begin
  raise EioException.Create(Self.ClassName, 'LoadPage', 'Method not available in ObjectBindSourceAdapters.');
end;

function TioActiveObjectBindSourceAdapter.MasterAdaptersContainer: IioDetailBindSourceAdaptersContainer;
begin
  Result := FMasterAdaptersContainer;
end;

function TioActiveObjectBindSourceAdapter.Notify(const Sender: TObject; const [Ref] ANotification: TioBSNotification): Boolean;
begin
  TioCommonBSABehavior.Notify(Sender, Self, ANotification);
  Result := ANotification.Response;
end;

procedure TioActiveObjectBindSourceAdapter.PersistAll;
begin
  TioCommonBSAPersistence.PersistAll(Self);
end;

procedure TioActiveObjectBindSourceAdapter.PersistCurrent;
begin
  TioCommonBSAPersistence.PersistCurrent(Self);
end;

function TioActiveObjectBindSourceAdapter.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  // RefCount disabled
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

procedure TioActiveObjectBindSourceAdapter.ReceiveSelection(ASelected: TObject; ASelectionType: TioSelectionType);
var
  LDone: Boolean;
begin
  LDone := False;
  DoBeforeSelection(ASelected, ASelectionType);
  DoSelection(ASelected, ASelectionType, LDone);
  if not LDone then
    Self.SetDataObject(ASelected);
  DoAfterSelection(ASelected, ASelectionType);
end;

procedure TioActiveObjectBindSourceAdapter.ReceiveSelection(ASelected: IInterface; ASelectionType: TioSelectionType);
begin
  // Questo ActiveBindSourceAdapter funziona solo con gli oggetti (no interfacce)
  // quindi chiama l'altra versione di metodo pi� adatta. IN questo modo
  // � possibile gestire la selezione anche se il selettore non � concorde
  ReceiveSelection(ASelected as TObject, ASelectionType);
end;

procedure TioActiveObjectBindSourceAdapter.Refresh(const ANotify: Boolean = True);
begin
  TioCommonBSAPersistence.Refresh(Self, ANotify);
end;

procedure TioActiveObjectBindSourceAdapter.Reload;
begin
  TioCommonBSAPersistence.Reload(Self);
end;

procedure TioActiveObjectBindSourceAdapter.SetAutoLoadData(const Value: Boolean);
begin
  FAutoLoadData := Value;
end;

procedure TioActiveObjectBindSourceAdapter.SetBindSource(ANotifiableBindSource: IioNotifiableBindSource);
begin
  FBindSource := ANotifiableBindSource;
end;

procedure TioActiveObjectBindSourceAdapter.SetBSPersistenceDeleting(const Value: Boolean);
begin
  FBSPersistenceDeleting := Value;
end;

procedure TioActiveObjectBindSourceAdapter.SetDataObject(const ADataObject: TObject; const AOwnsObject: Boolean);
begin
  if Self.HasMasterBSA then
    TioCommonBSABehavior.InternalSetDataObjectAsDetail<TObject>(Self, ADataObject)
  else
    InternalSetDataObject(ADataObject, AOwnsObject);
end;

procedure TioActiveObjectBindSourceAdapter.SetDataObject(const ADataObject: IInterface; const AOwnsObject: Boolean);
begin
  raise EioException.Create(Self.ClassName, 'SetDataObject',
    'This ActiveBindSourceAdapter is for class referenced instances only (not interfaced).');
end;

procedure TioActiveObjectBindSourceAdapter.InternalSetDataObject(const ADataObject: IInterface; const AOwnsObject: Boolean);
begin
  raise EioException.Create(Self.ClassName, 'InternalSetDataObject',
    'This ActiveBindSourceAdapter is for class referenced instances only (not interfaced).');
end;

procedure TioActiveObjectBindSourceAdapter.InternalSetDataObject(const ADataObject: TObject; const AOwnsObject: Boolean);
var
  LPrecAutoLoadData: Boolean;
begin
  // Disable the adapter
  Self.First; // Bug
  Self.Active := False;
  // AObj is assigned then set it as DataObject
  // else set DataObject to nil and set MasterObject to nil
  // to disable all Details adapters also
  if Assigned(ADataObject) then
  begin
    // Set the provided DataObject
    inherited SetDataObject(ADataObject, AOwnsObject);
    // Prior to reactivate the adapter force the "AutoLoadData" property to False to prevent double values
    // then restore the original value of the "AutoLoadData" property.
    LPrecAutoLoadData := FAutoLoadData;
    try
      FAutoLoadData := False;
      Self.Active := True;
    finally
      FAutoLoadData := LPrecAutoLoadData;
    end;
  end
  else
  begin
    inherited SetDataObject(nil, AOwnsObject);
    Self.FDetailAdaptersContainer.SetMasterObject(nil);
  end;
  // DataSet synchro
  Self.GetDataSetLinkContainer.Refresh;
end;

procedure TioActiveObjectBindSourceAdapter.SetIoAsync(const Value: Boolean);
begin
  FAsync := Value;
end;

procedure TioActiveObjectBindSourceAdapter.SetioAutoPost(const Value: Boolean);
begin
  Self.AutoPost := Value;
end;

procedure TioActiveObjectBindSourceAdapter.SetIoWhere(const Value: IioWhere);
begin
  FWhere := Value;
end;

procedure TioActiveObjectBindSourceAdapter.SetioWhereDetailsFromDetailAdapters(const Value: Boolean);
begin
  FWhereDetailsFromDetailAdapters := Value;
end;

procedure TioActiveObjectBindSourceAdapter.SetItemIndex(const Value: Integer);
begin
  inherited ItemIndex := Value;
end;

procedure TioActiveObjectBindSourceAdapter.SetItems(const AIndex: Integer; const Value: TObject);
begin
  InternalSetDataObject(Value);
end;

procedure TioActiveObjectBindSourceAdapter.SetMasterAdaptersContainer(AMasterAdaptersContainer: IioDetailBindSourceAdaptersContainer);
begin
  FMasterAdaptersContainer := AMasterAdaptersContainer;
end;

procedure TioActiveObjectBindSourceAdapter.SetMasterProperty(AMasterProperty: IioProperty);
begin
  FMasterProperty := AMasterProperty;
end;

procedure TioActiveObjectBindSourceAdapter.SetObjStatus(AObjStatus: TioObjStatus);
begin
  TioContextFactory.Context(Self.Current.ClassName, nil, Self.Current).ObjStatus := AObjStatus;
end;

procedure TioActiveObjectBindSourceAdapter.SetReloading(const Value: Boolean);
begin
  FReloading := Value;
end;

procedure TioActiveObjectBindSourceAdapter.SetTypeAlias(const AValue: String);
begin
  FTypeAlias := AValue;
end;

procedure TioActiveObjectBindSourceAdapter.SetTypeName(const AValue: String);
begin
  FTypeName := AValue;
end;

function TioActiveObjectBindSourceAdapter.SupportsNestedFields: Boolean;
begin
  // Disable support for NestedFields because iORM implements its own way of managing them
  //  in the unit "iORM.LiveBindings.CommonBSABehavior" with relative changes also in the ActivebindSourceAdapters
  Result := False;
end;

function TioActiveObjectBindSourceAdapter.UseObjStatus: Boolean;
begin
  Result := TioContextFactory.Context(Self.Current.ClassName, nil, Self.Current).ObjStatusExist;
end;

function TioActiveObjectBindSourceAdapter._AddRef: Integer;
begin
  // Nothing, the interfaces support is intended only as LazyLoadable support flag
  Result := -1;
end;

function TioActiveObjectBindSourceAdapter._Release: Integer;
begin
  // Nothing, the interfaces support is intended only as LazyLoadable support flag
  Result := -1;
end;

end.
