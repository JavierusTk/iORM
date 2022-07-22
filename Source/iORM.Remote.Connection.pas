{***************************************************************************}
{                                                                           }
{           iORM - (interfaced ORM)                                         }
{                                                                           }
{           Copyright (C) 2015-2016 Maurizio Del Magno                      }
{                                                                           }
{           mauriziodm@levantesw.it                                         }
{           mauriziodelmagno@gmail.com                                      }
{           https://github.com/mauriziodm/iORM.git                          }
{                                                                           }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  This file is part of iORM (Interfaced Object Relational Mapper).         }
{                                                                           }
{  Licensed under the GNU Lesser General Public License, Version 3;         }
{  you may not use this file except in compliance with the License.         }
{                                                                           }
{  iORM is free software: you can redistribute it and/or modify             }
{  it under the terms of the GNU Lesser General Public License as published }
{  by the Free Software Foundation, either version 3 of the License, or     }
{  (at your option) any later version.                                      }
{                                                                           }
{  iORM is distributed in the hope that it will be useful,                  }
{  but WITHOUT ANY WARRANTY; without even the implied warranty of           }
{  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            }
{  GNU Lesser General Public License for more details.                      }
{                                                                           }
{  You should have received a copy of the GNU Lesser General Public License }
{  along with iORM.  If not, see <http://www.gnu.org/licenses/>.            }
{                                                                           }
{***************************************************************************}





unit iORM.Remote.Connection;

interface

uses
  iORM.DB.Connection, iORM.DB.Interfaces, REST.Client, iORM.Remote.Interfaces;

type

  // This is the specialized class for remote connections
  TioConnectionRemote = class(TioConnectionBase, IioConnectionRemote)
  strict private
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FRemoteRequestBody: IioRemoteRequestBody;
    FRemoteResponseBody: IioRemoteResponseBody;
    procedure Execute(const AResource:String);
  strict protected
    procedure DoStartTransaction; override;
    procedure DoCommitTransaction; override;
    procedure DoRollbackTransaction; override;
  public
    constructor Create(const AConnectionInfo:TioConnectionInfo);
    destructor Destroy; override;
    function AsRemoteConnection: IioConnectionRemote; override;
    function InTransaction: Boolean; override;
    // ioRequestBody property
    function GetRequestBody:IioRemoteRequestBody;
    // ioResponseBody property
    function GetResponseBody:IioRemoteResponseBody;
  end;

implementation

uses
  iORM.Remote.Factory, REST.Types, IPPeerClient, System.JSON;

{ TioConnectionRemote }

function TioConnectionRemote.AsRemoteConnection: IioConnectionRemote;
begin
  inherited;
  Result := Self;
end;

constructor TioConnectionRemote.Create(const AConnectionInfo: TioConnectionInfo);
begin
  inherited Create(AConnectionInfo);
  // Create the RESTClient
  FRESTClient := TRESTClient.Create(AConnectionInfo.BaseURL);
  // Create the RESTResponse
  FRESTResponse := TRESTResponse.Create(nil);
  // Create & et the RESTRequest
  FRESTRequest := TRESTRequest.Create(nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Method := TRESTRequestMethod.rmPUT;
  FRESTRequest.Response := FRESTResponse;
  // create request body (not the response body)
  FRemoteRequestBody := TioRemoteFactory.NewRequestBody(False);
end;

destructor TioConnectionRemote.Destroy;
begin
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
  inherited;
end;

procedure TioConnectionRemote.DoCommitTransaction;
begin
  inherited;
  // Nothing
end;

procedure TioConnectionRemote.DoRollbackTransaction;
begin
  inherited;
  // Nothing
end;

procedure TioConnectionRemote.DoStartTransaction;
begin
  inherited;
  // Nothing
end;

procedure TioConnectionRemote.Execute(const AResource:String);
var
  RequestBodyJSONObject: TJSONObject;
begin
  // Set the requesta & execute it
  FRESTRequest.Resource := AResource;
  FRESTRequest.ClearBody;
  RequestBodyJSONObject := FRemoteRequestBody.ToJSONObject;
  try
    FRESTRequest.AddBody(RequestBodyJSONObject);
    FRESTRequest.Execute;
  finally
    RequestBodyJSONObject.Free;
  end;
  // Create and set the ioRESTResponseBody
  FRemoteResponseBody := TioRemoteFactory.NewResponseBody(FRESTResponse.Content, False);
end;

function TioConnectionRemote.GetRequestBody: IioRemoteRequestBody;
begin
  Result := FRemoteRequestBody;
end;

function TioConnectionRemote.GetResponseBody: IioRemoteResponseBody;
begin
  Result := FRemoteResponseBody;
end;


function TioConnectionRemote.InTransaction: Boolean;
begin
  inherited;
  Result := False;
end;

end.
