{
  ****************************************************************************
  *                                                                          *
  *           iORM - (interfaced ORM)                                        *
  *                                                                          *
  *           Copyright (C) 2015-2023 Maurizio Del Magno                     *
  *                                                                          *
  *           mauriziodm@levantesw.it                                        *
  *           mauriziodelmagno@gmail.com                                     *
  *           https://github.com/mauriziodm/iORM.git                         *
  *                                                                          *
  ****************************************************************************
  *                                                                          *
  * This file is part of iORM (Interfaced Object Relational Mapper).         *
  *                                                                          *
  * Licensed under the GNU Lesser General Public License, Version 3;         *
  *  you may not use this file except in compliance with the License.        *
  *                                                                          *
  * iORM is free software: you can redistribute it and/or modify             *
  * it under the terms of the GNU Lesser General Public License as published *
  * by the Free Software Foundation, either version 3 of the License, or     *
  * (at your option) any later version.                                      *
  *                                                                          *
  * iORM is distributed in the hope that it will be useful,                  *
  * but WITHOUT ANY WARRANTY; without even the implied warranty of           *
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            *
  * GNU Lesser General Public License for more details.                      *
  *                                                                          *
  * You should have received a copy of the GNU Lesser General Public License *
  * along with iORM.  If not, see <http://www.gnu.org/licenses/>.            *
  *                                                                          *
  ****************************************************************************
}
unit iORM.SynchroStrategy.Custom;

interface

uses
  System.Classes, iORM.Context.Interfaces, iORM.SynchroStrategy.Interfaces, iORM.Attributes, DJSON.Attributes;

type

  // This class contains and persists information on the synchronization operations that have
  //   taken place over time and is used for two things:
  //   1) on the client side as a reference
  //      to when the last synchronization was performed and at what point it has reached
  //      (e.g. which EtmTimeSlot was the last one synchronized)
  //   2) on the server side as a history of the synchronizations that occurred over time
  //      (also on the client side if desired).
  [ioEntity('SYNCHRO_LOG')]
  TioCustomSynchroStrategy_LogItem = class
  strict private
    FID: Integer;
    FSynchroLevel: TioSynchroLevel;
    FSynchroName: String;
    FSynchroStatus: TioSynchroStatus;
    FUserID: Integer;
    FUserName: String;
    // Timing
    FStart: TDateTime;
    FLoadFromClient: TDateTime;
    FPersistToServer: TDateTime;
    FReloadFromServer: TDateTime;
    FPersistToClient: TDateTime;
    FCompleted: TDateTime;
  public
    constructor Create; virtual;
    property ID: Integer read FID write FID;
    property SynchroLevel: TioSynchroLevel read FSynchroLevel write FSynchroLevel;
    property SynchroName: String read FSynchroName write FSynchroName;
    property SynchroStatus: TioSynchroStatus read FSynchroStatus write FSynchroStatus;
    property UserID: Integer read FUserID write FUserID;
    property UserName: String read FUserName write FUserName;
    // Timing
    property Start: TDateTime read FStart write FStart;
    property LoadFromClient: TDateTime read FLoadFromClient write FLoadFromClient;
    property PersistToServer: TDateTime read FPersistToServer write FPersistToServer;
    property ReloadFromServer: TDateTime read FReloadFromServer write FReloadFromServer;
    property PersistToClient: TDateTime read FPersistToClient write FPersistToClient;
    property Completed: TDateTime read FCompleted write FCompleted;
  end;

  // This class represents the payload of the synchronization operation in the sense that
  //   it is responsible for "transporting" the objects and information that must be synchronized
  //   from the client to the server and vice versa. However, this class also implements the
  //   behavioral and executive part of the synchronization through a whole series of methods
  //   that must/can be overridden in the concrete classes that will derive from it;
  //   in this way, especially if the target connection is an http connection,
  //   it will be this class (with the SynchroLogItem inside) that will be serialized and
  //   sent/received from the client to the server and vice versa and will carry out the various
  //   synchronization phases through its methods on the right side.
  // Note: In this class I wanted to use a generics so as to be able to abstract from the real
  //        SynchroLogItem class, in fact both will have to be derived (therefore changed)
  //        to create a concrete synchro strategy. But I already use a generics in the
  //        SynchroStrategy_Client<T: TioCustomSynchroStrategy_Payload> component which already
  //        has a constraint so I would then have had to use a double generics here with
  //        two different constraints and Delphi doesn't allow this or at least I haven't found
  //        a way to do it. So I decided not to use generics on the Payload class and to declare
  //        on it a whole series of virtual methods that can be overridden to create and manage
  //        different types of SynchroLogItem which however must be derived from the
  //        TioCustomSynchroStrategy_LogItem base class
  TioCustomSynchroStrategy_Payload = class abstract
  strict private
    FClassBlackList: TioSynchroStrategy_ClassList; // TList because it will be serialized by djson
    FClassWhiteList: TioSynchroStrategy_ClassList; // TList because it will be serialized by djson
    FSynchroLevel: TioSynchroLevel;
    FSynchroLogItem_Last: TioCustomSynchroStrategy_LogItem;
    FSynchroLogItem_New: TioCustomSynchroStrategy_LogItem;
    FSynchroName: String;
    FUserID: Integer;
    FUserName: String;
    [djSkip] // Non viene serializzato (in caso di connessione HTTP) in questo modo poi capisco se siamo remotizzati e quindi se devo fare lo "use" o no.
    FTargetConnectionDefName: String;
  strict protected
    // ---------- Methods to override on descendant classes ----------
    // Connection
    procedure _SwitchToTargetConnection; virtual;
    procedure _ReturnToLocalConnection; virtual;
    // SynchroLogItem
    procedure _DoLastSynchroLogItem_LoadFromClient; virtual;
    procedure _DoNewSynchroLogItem_Create; virtual;
    procedure _DoNewSynchroLogItem_Initialize; virtual;
    procedure _DoNewSynchroLogItem_SetStatus_LoadFromClient; virtual;
    procedure _DoNewSynchroLogItem_SetStatus_PersistToServer; virtual;
    procedure _DoNewSynchroLogItem_SetStatus_ReloadFromServer; virtual;
    procedure _DoNewSynchroLogItem_SetStatus_PersistToClient; virtual;
    procedure _DoNewSynchroLogItem_SetStatus_Completed; virtual;
    procedure _DoNewSynchroLogItem_Persist; virtual;
    // Payload
    procedure _DoLoadPayloadFromClient; virtual; abstract;
    procedure _DoPersistPayloadToServer; virtual; abstract;
    procedure _DoReloadPayloadFromServer; virtual; abstract;
    procedure _DoPersistPayloadToClient; virtual; abstract;
    // ---------- Methods to override on descendant classes ----------
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // ---------- Methods to be called by the persistence strategy ----------
    procedure Initialize;
    procedure LoadFromClient;
    procedure PersistAndReloadFromServer;
    procedure PersistToClient;
    procedure Finalize;
    // ---------- Methods to be called by the persistence strategy ----------
    property ClassBlackList: TioSynchroStrategy_ClassList read FClassBlackList; // TList because it will be serialized by djson
    property ClassWhiteList: TioSynchroStrategy_ClassList read FClassWhiteList; // TList because it will be serialized by djson
    property SynchroLevel: TioSynchroLevel read FSynchroLevel write FSynchroLevel;
    property SynchroName: String read FSynchroName write FSynchroName;
    property UserID: Integer read FUserID write FUserID;
    property UserName: String read FUserName write FUserName;
  end;

  TioCustomSynchroStrategy_Client<T: TioCustomSynchroStrategy_Payload, constructor> = class abstract(TComponent)//, IioSynchroStrategy_Client)
  strict private
    FClassBlackList: TioSynchroStrategy_ClassList; // TList because it will be serialized by djson
    FClassWhiteList: TioSynchroStrategy_ClassList; // TList because it will be serialized by djson
    FPayload: T;
    FSynchroLevel: TioSynchroLevel;
    FSynchroName: String;
    FTargetConnectionDef: IioSynchroStrategy_TargetConnectionDef;
    procedure SetTargetConnectionDef(const ATargetConnectionDef: IioSynchroStrategy_TargetConnectionDef);
  strict protected
    // ---------- Synchro strategy methods to override on descendant classes ----------
    function _DoGenerateLocalID(const AContext: IioContext): Integer; virtual; abstract;
    procedure _DoPayload_Initialize(const APayload: T); virtual;
    // ---------- Synchro strategy methods to override on descendant classes ----------
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoSynchronization(const ASynchroLevel: TioSynchroLevel);
    function GenerateLocalID(const AContext: IioContext): Integer;
  published
    property ClassBlackList: TioSynchroStrategy_ClassList read FClassBlackList; // TList because it will be serialized by djson
    property ClassWhiteList: TioSynchroStrategy_ClassList read FClassWhiteList; // TList because it will be serialized by djson
    property SynchroLevel: TioSynchroLevel read FSynchroLevel write FSynchroLevel default slIncremental;
    property SynchroName: String read FSynchroName write FSynchroName;
    property TargetConnectionDef: IioSynchroStrategy_TargetConnectionDef read FTargetConnectionDef write FTargetConnectionDef default nil;
  end;







  TioCustomSynchroStrategy_Server = class abstract(TComponent)//, IioSynchroStrategy_Server)
  strict private
    FPayload: TioCustomSynchroStrategy_Payload;
    function GetPayload: String;
  strict protected
    // ---------- Synchro strategy methods to override on descendant classes ----------
    procedure _DoLoadPayload; virtual; abstract;
    procedure _DoPersistPayload; virtual; abstract;
    // ---------- Synchro strategy methods to override on descendant classes ----------
  public
    constructor Create(const APayload: String);
    procedure LoadPayload;
    procedure PersistPayload;
    property Payload: String read GetPayload;
  end;


implementation

uses
  iORM, System.SysUtils, iORM.PersistenceStrategy.Factory;

{ TioCustomSynchroStrategy }

constructor TioCustomSynchroStrategy_Client<T>.Create(AOwner: TComponent);
begin
  inherited;
  FClassBlackList := TioSynchroStrategy_ClassList.Create;
  FClassWhiteList := TioSynchroStrategy_ClassList.Create;
  FSynchroLevel := TioSynchroLevel.slIncremental;
  FSynchroName := IO_STRING_NULL_VALUE;
  FTargetConnectionDef := nil;
end;

destructor TioCustomSynchroStrategy_Client<T>.Destroy;
begin
  FClassBlackList.Free;
  FClassWhiteList.Free;
  if FTargetConnectionDef <> nil then
    FTargetConnectionDef.RemoveFreeNotification(Self);
  inherited;
end;

function TioCustomSynchroStrategy_Client<T>.GenerateLocalID(const AContext: IioContext): Integer;
begin
  Result := _DoGenerateLocalID(AContext);
end;

procedure TioCustomSynchroStrategy_Client<T>.SetTargetConnectionDef(const ATargetConnectionDef: IioSynchroStrategy_TargetConnectionDef);
begin
  if ATargetConnectionDef <> FTargetConnectionDef then
  begin
    if FTargetConnectionDef <> nil then
      FTargetConnectionDef.RemoveFreeNotification(Self);

    FTargetConnectionDef := ATargetConnectionDef;

    if FTargetConnectionDef <> nil then
      FTargetConnectionDef.FreeNotification(Self);
  end;
end;

procedure TioCustomSynchroStrategy_Client<T>._DoPayload_Initialize(const APayload: T);
begin
  APayload.SynchroLevel := FSynchroLevel;
  APayload.ClassBlackList.AddRange(FClassBlackList);
  APayload.ClassWhiteList.AddRange(FClassWhiteList);
//  LPayLoad.UserID :=
//  LPayLoad.UserName :=
end;

procedure TioCustomSynchroStrategy_Client<T>.DoSynchronization(const ASynchroLevel: TioSynchroLevel);
var
  LPayload: T;
begin
  // Create the payload
  // Note: Use a local variable and not a global one for the component because
  //        the synchronization must also be possible to perform asynchronously.
  LPayload := T.Create;
  try
    // Initialize the payload
    _DoPayload_Initialize(LPayload);
    // Start the sychronization on the target connection
    io.Connections.GetConnectionDefByName();
  finally
    LPayload.Free;
  end;
end;

{ TioCustomSynchroStrategy_Server }

constructor TioCustomSynchroStrategy_Server.Create(const APayload: String);
begin
  // TODO: To be implemented
end;

function TioCustomSynchroStrategy_Server.GetPayload: String;
begin
  // TODO: To be implemented
end;

procedure TioCustomSynchroStrategy_Server.LoadPayload;
begin
  // TODO: To be implemented
end;

procedure TioCustomSynchroStrategy_Server.PersistPayload;
begin
  // TODO: To be implemented
end;

{ TioCustomSynchroStrategy_Payload }

constructor TioCustomSynchroStrategy_Payload.Create;
begin
  FClassWhiteList := TioSynchroStrategy_ClassList.Create;
  FClassBlackList := TioSynchroStrategy_ClassList.Create;
  FSynchroLogItem_Last := nil;
  FSynchroLogItem_New := nil;
  FSynchroLevel := TioSynchroLevel.slUndefined;
  FSynchroName := IO_STRING_NULL_VALUE;
  FUserID := IO_INTEGER_NULL_VALUE;
  FUserName := IO_STRING_NULL_VALUE;
end;

destructor TioCustomSynchroStrategy_Payload.Destroy;
begin
  FClassWhiteList.Free;
  FClassBlackList.Free;
  if Assigned(FSynchroLogItem_Last) then
    FSynchroLogItem_Last.Free;
  if Assigned(FSynchroLogItem_New) then
    FSynchroLogItem_New.Free;
  inherited;
end;

procedure TioCustomSynchroStrategy_Payload.Finalize;
begin
  // Set the new SynchroLogitem progress status and persist it server side,
  //  it will be persisted on the client only when the operation is completed successfully
  _DoNewSynchroLogItem_SetStatus_Completed;
  _SwitchToTargetConnection;
  try
    _DoNewSynchroLogItem_Persist;
  finally
    _ReturnToLocalConnection;
  end;
end;

procedure TioCustomSynchroStrategy_Payload.Initialize;
begin
  // Load the last SynchroLogItem from which to obtain information on the last synchronization operation performed
  _DoLastSynchroLogItem_LoadFromClient;
  // Create and initialize a new SynchroLogitem on which to store the information and status of the synchronization in progress
  _DoNewSynchroLogItem_Create;
  _DoNewSynchroLogItem_Initialize;
  // Set the new SynchroLogitem progress status and persist it to the server,
  //  it will be persisted on the client only when the operation is completed successfully
  _SwitchToTargetConnection;
  try
    _DoNewSynchroLogItem_Persist;
  finally
    _ReturnToLocalConnection;
  end;
end;

procedure TioCustomSynchroStrategy_Payload.LoadFromClient;
begin
  // Set the new SynchroLogitem progress status and persist it server side,
  //  it will be persisted on the client only when the operation is completed successfully
  _DoNewSynchroLogItem_SetStatus_LoadFromClient;
  _SwitchToTargetConnection;
  try
    _DoNewSynchroLogItem_Persist;
  finally
    _ReturnToLocalConnection;
  end;
  // Load the payload from the client
  _DoLoadPayloadFromClient;
end;

procedure TioCustomSynchroStrategy_Payload.PersistAndReloadFromServer;
begin
  // This entire part of the operation must be performed server side
  //  so swith to che server connection
  _SwitchToTargetConnection;
  try
    // Set the new SynchroLogitem progress status and persist it server side,
    //  it will be persisted on the client only when the operation is completed successfully
    _DoNewSynchroLogItem_SetStatus_PersistToServer;
    _DoNewSynchroLogItem_Persist;
    // Persist the payload to server
    _DoPersistPayloadToServer;
    // Set the new SynchroLogitem progress status and persist it server side,
    //  it will be persisted on the client only when the operation is completed successfully
    _DoNewSynchroLogItem_SetStatus_ReloadFromServer;
    _DoNewSynchroLogItem_Persist;
    // Reload payload from the server
    _DoReloadPayloadFromServer;
  finally
    _ReturnToLocalConnection;
  end;
end;

procedure TioCustomSynchroStrategy_Payload.PersistToClient;
begin
  // Set the new SynchroLogitem progress status and persist it server side,
  //  it will be persisted on the client only when the operation is completed successfully
  _DoNewSynchroLogItem_SetStatus_PersistToClient;
  _SwitchToTargetConnection;
  try
    _DoNewSynchroLogItem_Persist;
  finally
    _ReturnToLocalConnection;
  end;
  // Persist the payload to the client
  _DoPersistPayloadToClient;
end;

procedure TioCustomSynchroStrategy_Payload._DoNewSynchroLogItem_Create;
begin
  // Create a new instance as current SynchroLogItem of the right classs
  FSynchroLogItem_New := TioCustomSynchroStrategy_LogItem.Create;
end;

procedure TioCustomSynchroStrategy_Payload._DoNewSynchroLogItem_Initialize;
begin
  // Initialize the new SynchroLogItem after its creation
  FSynchroLogItem_New.SynchroStatus := TioSynchroStatus.ssInitialization;
  FSynchroLogItem_New.Start := Now;
  FSynchroLogItem_New.SynchroLevel := FSynchroLevel;
end;

procedure TioCustomSynchroStrategy_Payload._DoLastSynchroLogItem_LoadFromClient;
var
  LWhere: IioWhere;
begin
  // Load last SynchroLogItem from the local client connection as current new SynchroLogItem using the right class
//  ----- old code -----
//  LWhere := io.Where('SynchroStatus', coEquals, TioSynchroStatus.ssCompleted);
//  LWhere._And('ID = SELECT MAX(SUB.ID) FROM [TioCustomSynchroStrategy_LogItem] SUB WHERE SUB.SYNCHROSTATUS = SYNCHROSTATUS AND SUB.SYNCHRONAME = SYNCHRONAME');
//  ----- old code -----
  LWhere := io.Where('ID = SELECT MAX(SUB.ID) FROM [TioCustomSynchroStrategy_LogItem] SUB WHERE SUB.SYNCHRONAME = SYNCHRONAME');
  FSynchroLogItem_Last := io.LoadObject<TioCustomSynchroStrategy_LogItem>(LWhere);
end;

procedure TioCustomSynchroStrategy_Payload._DoNewSynchroLogItem_Persist;
begin
  // Persist the new SynchroLogItem
  io.PersistObject(FSynchroLogItem_New);
end;

procedure TioCustomSynchroStrategy_Payload._DoNewSynchroLogItem_SetStatus_Completed;
begin
  // Set the new SynchroLogitem progress status
  FSynchroLogItem_New.SynchroStatus := TioSynchroStatus.ssCompleted;
  FSynchroLogItem_New.Completed := Now;
end;

procedure TioCustomSynchroStrategy_Payload._DoNewSynchroLogItem_SetStatus_LoadFromClient;
begin
  // Set the new SynchroLogitem progress status
  FSynchroLogItem_New.SynchroStatus := TioSynchroStatus.ssLoadFromClient;
  FSynchroLogItem_New.LoadFromClient := Now;
end;

procedure TioCustomSynchroStrategy_Payload._DoNewSynchroLogItem_SetStatus_PersistToClient;
begin
  // Set the new SynchroLogitem progress status
  FSynchroLogItem_New.SynchroStatus := TioSynchroStatus.ssPersistToClient;
  FSynchroLogItem_New.PersistToClient := Now;
end;

procedure TioCustomSynchroStrategy_Payload._DoNewSynchroLogItem_SetStatus_PersistToServer;
begin
  // Set the new SynchroLogitem progress status
  FSynchroLogItem_New.SynchroStatus := TioSynchroStatus.ssPersistToServer;
  FSynchroLogItem_New.PersistToServer := Now;
end;

procedure TioCustomSynchroStrategy_Payload._DoNewSynchroLogItem_SetStatus_ReloadFromServer;
begin
  // Set the new SynchroLogitem progress status
  FSynchroLogItem_New.SynchroStatus := TioSynchroStatus.ssReloadFromServer;
  FSynchroLogItem_New.ReloadFromServer := Now;
end;

procedure TioCustomSynchroStrategy_Payload._ReturnToLocalConnection;
begin
  // If you are synchronizing with an http connection as the target and we are running on the client side
  //  (FTargetConnectionDefName is not empty) or the target connection is a normal non-http connection
  //  (so all the synchronization steps are performed on the client side) then select the connection specified
  //  precisely by the FTargetConnectionDefName field so that the object is persisted on this connection
  //  (normally it would persist on the local default connection, the normal client connection).
  //  If, however, you are synchronizing with an http connection as the target and we are running
  //  on the server side (FTargetConnectionDefName is empty) then it does not select any connection
  //  in particular but lets each object be loaded/persisted normally as set on the server.
  // Note: If FTargetConnectionDefName is empty then it means that we are on the server side of the synchronization,
  //        this is because the FTargetConnectionDefName field is set not to be serialized by DJSON so when synchronization
  //        is being done towards an HTTP connection (target) and the payload is passed to the server FTargetConnectionDefName
  //        becomes empty (while on the client side it is always valued).
  if not FTargetConnectionDefName.IsEmpty then
    io.Connections.ThreadUseClear;
end;

procedure TioCustomSynchroStrategy_Payload._SwitchToTargetConnection;
begin
  // If you are synchronizing with an http connection as the target and we are running on the client side
  //  (FTargetConnectionDefName is not empty) or the target connection is a normal non-http connection
  //  (so all the synchronization steps are performed on the client side) then select the connection specified
  //  precisely by the FTargetConnectionDefName field so that the object is persisted on this connection
  //  (normally it would persist on the local default connection, the normal client connection).
  //  If, however, you are synchronizing with an http connection as the target and we are running
  //  on the server side (FTargetConnectionDefName is empty) then it does not select any connection
  //  in particular but lets each object be loaded/persisted normally as set on the server.
  // Note: If FTargetConnectionDefName is empty then it means that we are on the server side of the synchronization,
  //        this is because the FTargetConnectionDefName field is set not to be serialized by DJSON so when synchronization
  //        is being done towards an HTTP connection (target) and the payload is passed to the server FTargetConnectionDefName
  //        becomes empty (while on the client side it is always valued).
  if not FTargetConnectionDefName.IsEmpty then
    io.Connections.ThreadUseConnection(FTargetConnectionDefName);
end;

{ TioCustomSynchroStrategy_LogItem }

constructor TioCustomSynchroStrategy_LogItem.Create;
begin
  FID := IO_INTEGER_NULL_VALUE;
  FSynchroName := IO_STRING_NULL_VALUE;
  FUserID := IO_INTEGER_NULL_VALUE;
  FUserName := IO_STRING_NULL_VALUE;
  FSynchroLevel := TioSynchroLevel.slUndefined;
  FSynchroStatus := TioSynchroStatus.ssInitialization;
  // Timing
  FStart := IO_DATETIME_NULL_VALUE;
  FLoadFromClient := IO_DATETIME_NULL_VALUE;
  FPersistToServer := IO_DATETIME_NULL_VALUE;
  FReloadFromServer := IO_DATETIME_NULL_VALUE;
  FPersistToClient := IO_DATETIME_NULL_VALUE;
  FCompleted := IO_DATETIME_NULL_VALUE;
end;

end.
