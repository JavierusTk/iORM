unit iORM.DT.Register;

interface

procedure Register;

implementation

uses
  ToolsAPI, System.Classes, iORM.Abstraction.VCL, iORM.Abstraction.FMX, iORM.DB.ConnectionDef, iORM.DB.ConnectionDef.MSSQLServer, iORM.DB.DataSet.Master,
  iORM.DB.DataSet.Detail, iORM.DB.MemTable, iORM.LiveBindings.PrototypeBindSource.Custom, iORM.LiveBindings.PrototypeBindSource.Master,
  iORM.LiveBindings.PrototypeBindSource.Detail, DesignIntf, iORM.MVVM.ModelPresenter.Master, iORM.MVVM.ModelPresenter.Detail, iORM.MVVM.ModelDataSet,
  iORM.MVVM.ModelBindSource, iORM.MVVM.ViewModelBridge, iORM.MVVM.ViewContextProvider, System.Actions, iORM.StdActions.VCL, iORM.StdActions.FMX,
  iORM.DT.ViewModel.Wizard, iORM.MVVM.ViewModel, DesignEditors, iORM.StdActions.CloseQueryRepeater,
  iORM.DT.CompAutoUses, iORM.MVVM.VMAction;

procedure Register;
begin
  // Abstraction layer components
  RegisterComponents('iORM', [TioVCL]);
  RegisterComponents('iORM', [TioFMX]);

  // Connection components
  RegisterComponents('iORM', [TioRemoteConnectionDef]);
  RegisterSelectionEditor(TioRemoteConnectionDef, TioConnectionDefSelectionEditor);
  RegisterComponents('iORM', [TioSQLiteConnectionDef]);
  RegisterSelectionEditor(TioSQLiteConnectionDef, TioConnectionDefSelectionEditor);
  RegisterComponents('iORM', [TioFirebirdConnectionDef]);
  RegisterSelectionEditor(TioFirebirdConnectionDef, TioConnectionDefSelectionEditor);
  RegisterComponents('iORM', [TioSQLServerConnectionDef]);
  RegisterSelectionEditor(TioSQLServerConnectionDef, TioConnectionDefSelectionEditor);
  RegisterComponents('iORM', [TioSQLMonitor]);

  // DataSet components
  RegisterComponents('iORM', [TioMemTable]);
  RegisterComponents('iORM', [TioDataSetMaster]);
  RegisterSelectionEditor(TioDataSetMaster, TioBindSourceSelectionEditor);
  RegisterComponents('iORM', [TioDataSetDetail]);
  RegisterSelectionEditor(TioDataSetDetail, TioBindSourceSelectionEditor);

  // LiveBindings components
  RegisterComponents('iORM', [TioPrototypeBindSourceMaster]);
  RegisterSelectionEditor(TioPrototypeBindSourceMaster, TioBindSourceSelectionEditor);
  UnlistPublishedProperty(TioPrototypeBindSourceMaster, 'AutoActivate');
  UnlistPublishedProperty(TioPrototypeBindSourceMaster, 'AutoEdit');
  UnlistPublishedProperty(TioPrototypeBindSourceMaster, 'AutoPost');
  UnlistPublishedProperty(TioPrototypeBindSourceMaster, 'RecordCount');
  UnlistPublishedProperty(TioPrototypeBindSourceMaster, 'OnCreateAdapter');
  RegisterComponents('iORM', [TioPrototypeBindSourceDetail]);
  RegisterSelectionEditor(TioPrototypeBindSourceDetail, TioBindSourceSelectionEditor);
  UnlistPublishedProperty(TioPrototypeBindSourceDetail, 'AutoActivate');
  UnlistPublishedProperty(TioPrototypeBindSourceDetail, 'AutoEdit');
  UnlistPublishedProperty(TioPrototypeBindSourceDetail, 'AutoPost');
  UnlistPublishedProperty(TioPrototypeBindSourceDetail, 'RecordCount');
  UnlistPublishedProperty(TioPrototypeBindSourceDetail, 'OnCreateAdapter');

  // MVVM components
  RegisterComponents('iORM-MVVM', [TioViewModelBridge]);
  RegisterSelectionEditor(TioViewModelBridge, TioMVVMSelectionEditor);
  RegisterComponents('iORM-MVVM', [TioViewContextProvider]);
  RegisterSelectionEditor(TioViewContextProvider, TioMVVMSelectionEditor);
  RegisterComponents('iORM-MVVM', [TioModelPresenterMaster]);
  RegisterSelectionEditor(TioModelPresenterMaster, TioBindSourceSelectionEditor);
  RegisterComponents('iORM-MVVM', [TioModelPresenterDetail]);
  RegisterSelectionEditor(TioModelPresenterDetail, TioBindSourceSelectionEditor);
  RegisterComponents('iORM-MVVM', [TioModelDataSet]);
  RegisterComponents('iORM-MVVM', [TioModelBindSource]);
  UnlistPublishedProperty(TioModelBindSource, 'AutoActivate');
  UnlistPublishedProperty(TioModelBindSource, 'AutoEdit');
  UnlistPublishedProperty(TioModelBindSource, 'AutoPost');
  UnlistPublishedProperty(TioModelBindSource, 'RecordCount');
  UnlistPublishedProperty(TioModelBindSource, 'OnCreateAdapter');

  // MVVM - VMActions
  RegisterComponents('iORM-MVVM-VMActions', [TioVMAction]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSShowOrSelect]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSCloseQuery]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSNextPage]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSPrevPage]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionWhereBuild]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionWhereClear]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSSelectCurrent]);
  RegisterSelectionEditor(TioVMActionBSSelectCurrent, TioMVVMSelectionEditor);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSPersistenceSaveRevertPoint]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSPersistenceClear]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSPersistencePersist]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSPersistenceRevert]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSPersistenceRevertOrDelete]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSPersistenceDelete]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSPersistenceReload]);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSPersistenceAppend]);
  RegisterSelectionEditor(TioVMActionBSPersistenceAppend, TioMVVMSelectionEditor);
  RegisterComponents('iORM-MVVM-VMActions', [TioVMActionBSPersistenceInsert]);
  RegisterSelectionEditor(TioVMActionBSPersistenceInsert, TioMVVMSelectionEditor);

  // VCL standard actions
  RegisterActions('iORM-BS', [iORM.StdActions.Vcl.TioBSSelectCurrent], nil);
  RegisterActions('iORM-BS', [iORM.StdActions.Vcl.TioBSShowOrSelect], nil);
  RegisterActions('iORM-BS', [iORM.StdActions.Vcl.TioBSCloseQuery], nil);
  RegisterActions('iORM-BSPaging', [iORM.StdActions.Vcl.TioBSNextPage], nil);
  RegisterActions('iORM-BSPaging', [iORM.StdActions.Vcl.TioBSPrevPage], nil);
  RegisterActions('iORM-BSWhereBuilder', [iORM.StdActions.Vcl.TioBSWhereBuild], nil);
  RegisterActions('iORM-BSWhereBuilder', [iORM.StdActions.Vcl.TioBSWhereClear], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Vcl.TioBSPersistenceAppend], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Vcl.TioBSPersistenceClear], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Vcl.TioBSPersistenceDelete], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Vcl.TioBSPersistenceInsert], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Vcl.TioBSPersistencePersist], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Vcl.TioBSPersistenceReload], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Vcl.TioBSPersistenceRevert], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Vcl.TioBSPersistenceRevertOrDelete], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Vcl.TioBSPersistenceSaveRevertPoint], nil);
  RegisterActions('iORM-MVVM', [iORM.StdActions.Vcl.TioViewAction], nil);
  UnlistPublishedProperty(iORM.StdActions.Vcl.TioViewAction, 'OnExecute');
  UnlistPublishedProperty(iORM.StdActions.Vcl.TioViewAction, 'OnUpdate');

  // FMX standard actions
  RegisterActions('iORM-BS', [iORM.StdActions.Fmx.TioBSSelectCurrent], nil);
  RegisterActions('iORM-BS', [iORM.StdActions.Fmx.TioBSShowOrSelect], nil);
  RegisterActions('iORM-BS', [iORM.StdActions.Fmx.TioBSCloseQuery], nil);
  RegisterActions('iORM-BSPaging', [iORM.StdActions.Fmx.TioBSNextPage], nil);
  RegisterActions('iORM-BSPaging', [iORM.StdActions.Fmx.TioBSPrevPage], nil);
  RegisterActions('iORM-BSWhereBuilder', [iORM.StdActions.Fmx.TioBSWhereBuild], nil);
  RegisterActions('iORM-BSWhereBuilder', [iORM.StdActions.Fmx.TioBSWhereClear], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Fmx.TioBSPersistenceAppend], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Fmx.TioBSPersistenceClear], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Fmx.TioBSPersistenceDelete], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Fmx.TioBSPersistenceInsert], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Fmx.TioBSPersistencePersist], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Fmx.TioBSPersistenceReload], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Fmx.TioBSPersistenceRevert], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Fmx.TioBSPersistenceRevertOrDelete], nil);
  RegisterActions('iORM-BSPersistence', [iORM.StdActions.Fmx.TioBSPersistenceSaveRevertPoint], nil);
  RegisterActions('iORM-MVVM', [iORM.StdActions.Fmx.TioViewAction], nil);
  UnlistPublishedProperty(iORM.StdActions.Fmx.TioViewAction, 'Text');
  UnlistPublishedProperty(iORM.StdActions.Fmx.TioViewAction, 'OnExecute');
  UnlistPublishedProperty(iORM.StdActions.Fmx.TioViewAction, 'OnUpdate');

  // StdActions common
  RegisterComponents('iORM', [TioCloseQueryRepeater]);

  // IDE Wizards
  RegisterPackageWizard(TioViewModelWizard.Create);
  RegisterCustomModule(TioViewModel, TCustomModule);
//  RegisterCustomModule(TioViewModel, TDataModuleCustomModule); // TDataModuleCustomModule is declared in "DMForm" unit
end;

end.
