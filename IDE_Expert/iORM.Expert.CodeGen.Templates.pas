{***************************************************************************}
{                                                                           }
{           iORM - (interfaced ORM)                                         }
{                                                                           }
{           Copyright (C) 2016 Maurizio Del Magno                           }
{                                                                           }
{           mauriziodm@levantesw.it                                         }
{           mauriziodelmagno@gmail.com                                      }
{           https://github.com/mauriziodm/iORM.git                          }
{                                                                           }
{***************************************************************************}
{                                                                           }
{                      Delphi MVC Framework                                 }
{                                                                           }
{     Copyright (c) 2010-2015 Daniele Teti and the DMVCFramework Team       }
{                                                                           }
{           https://github.com/danieleteti/delphimvcframework               }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{  This IDE expert is based off of the one included with the DUnitX         }
{  project.  Original source by Robert Love.  Adapted by Nick Hodges.       }
{                                                                           }
{  The DUnitX project is run by Vincent Parrett and can be found at:        }
{                                                                           }
{            https://github.com/VSoftTechnologies/DUnitX                    }
{***************************************************************************}

unit iORM.Expert.CodeGen.Templates;

interface

resourcestring

 { Delphi template code }
//0 - project name
//1 - http/s port
 sIORMDMVCDPR = 'program %0:s;' + sLineBreak +
sLineBreak +
' {$APPTYPE CONSOLE}' + sLineBreak  +
'' + sLineBreak +
'uses' + sLineBreak +
'  System.SysUtils,' + sLineBreak +
'  Winapi.Windows,' + sLineBreak +
'  Winapi.ShellAPI,' + sLineBreak +
'  Web.WebReq,' + sLineBreak +
'  Web.WebBroker,' + sLineBreak +
'  IdHTTPWebBrokerBridge;' + sLineBreak +
'' + sLineBreak +
'{$R *.res}' + sLineBreak +
sLineBreak +
'procedure RunServer(APort: Integer);' + sLineBreak +
'var' + sLineBreak +
'  LInputRecord: TInputRecord;' + sLineBreak +
'  LEvent: DWord;' + sLineBreak +
'  LHandle: THandle;' + sLineBreak +
'  LServer: TIdHTTPWebBrokerBridge;' + sLineBreak +
'begin' + sLineBreak +
'  Writeln(''** DMVCFramework Server **'');' + sLineBreak +
'  Writeln(Format(''Starting HTTP Server on port %%d'', [APort]));' + sLineBreak +
'  LServer := TIdHTTPWebBrokerBridge.Create(nil);' + sLineBreak +
'  try' + sLineBreak +
'    LServer.DefaultPort := APort;' + sLineBreak +
'    LServer.Active := True;' + sLineBreak +
'    ShellExecute(0, ''open'', pChar(''http://localhost:'' + inttostr(APort) + ''/test''), nil, nil, SW_SHOWMAXIMIZED);' + sLineBreak +
'    Writeln(''Press ESC to stop the server'');' + sLineBreak +
'    LHandle := GetStdHandle(STD_INPUT_HANDLE);' + sLineBreak +
'    while True do' + sLineBreak +
'    begin' + sLineBreak +
'      Win32Check(ReadConsoleInput(LHandle, LInputRecord, 1, LEvent));' + sLineBreak +
'      if (LInputRecord.EventType = KEY_EVENT) and' + sLineBreak +
'        LInputRecord.Event.KeyEvent.bKeyDown and' + sLineBreak +
'        (LInputRecord.Event.KeyEvent.wVirtualKeyCode = VK_ESCAPE) then' + sLineBreak +
'        break;' + sLineBreak +
'    end;' + sLineBreak +
'  finally' + sLineBreak +
'    LServer.Free;' + sLineBreak +
'  end;' + sLineBreak +
'end;' + sLineBreak +
sLineBreak +
'begin' + sLineBreak +
'  ReportMemoryLeaksOnShutdown := True;' + sLineBreak +
'  try' + sLineBreak +
'    if WebRequestHandler <> nil then' + sLineBreak +
'      WebRequestHandler.WebModuleClass := WebModuleClass;' + sLineBreak +
'    WebRequestHandlerProc.MaxConnections := 1024;' + sLineBreak +
'    RunServer(%1:d);' + sLineBreak +
'  except' + sLineBreak +
'    on E: Exception do' + sLineBreak +
'      Writeln(E.ClassName, '': '', E.Message);' + sLineBreak +
'  end;' + sLineBreak +
'end.' + sLineBreak;


 sDefaultWebModuleName = 'TMyWebModule';
 sDefaultServerPort = '8080';


 // 0 = unit name
 // 1 = webmodule classname
 sIORMDMVCWebModuleUnit =
'unit %0:s;' + sLineBreak +
'' + sLineBreak +
'interface' + sLineBreak +
sLineBreak +
'uses System.SysUtils,' + sLineBreak +
'     System.Classes,' + sLineBreak +
'     Web.HTTPApp,' + sLineBreak +
'     MVCFramework;' + sLineBreak +
sLineBreak +
'type' + sLineBreak +
'  %1:s = class(TWebModule)' + sLineBreak +
'    procedure WebModuleCreate(Sender: TObject);' + sLineBreak +
'    procedure WebModuleDestroy(Sender: TObject);' + sLineBreak +
'  private' + sLineBreak +
'    FMVC: TMVCEngine;' + sLineBreak +
'  public' + sLineBreak +
'    { Public declarations }' + sLineBreak +
'  end;' + sLineBreak +
sLineBreak +
'var' + sLineBreak +
'  WebModuleClass: TComponentClass = %1:s;' + sLineBreak +
sLineBreak +
'implementation' + sLineBreak +
sLineBreak +
'{$R *.dfm}' + sLineBreak +
sLineBreak +

//'uses %2:s, MVCFramework.Commons;' + sLineBreak +
'uses iORM.REST.DMVC.Controller, MVCFramework.Commons;' + sLineBreak +

sLineBreak +
'procedure %1:s.WebModuleCreate(Sender: TObject);' + sLineBreak +
'begin' + sLineBreak +
'  FMVC := TMVCEngine.Create(Self,' + sLineBreak +
'    procedure(Config: TMVCConfig)' + sLineBreak +
'    begin' + sLineBreak +
'      //enable static files' + sLineBreak +
'      Config[TMVCConfigKey.DocumentRoot] := ExtractFilePath(GetModuleName(HInstance)) + ''\www'';' + sLineBreak +
'      // session timeout (0 means session cookie)' + sLineBreak +
'      Config[TMVCConfigKey.SessionTimeout] := ''0'';' + sLineBreak +
'      //default content-type' + sLineBreak +
'      Config[TMVCConfigKey.DefaultContentType] := TMVCConstants.DEFAULT_CONTENT_TYPE;' + sLineBreak +
'      //default content charset' + sLineBreak +
'      Config[TMVCConfigKey.DefaultContentCharset] := TMVCConstants.DEFAULT_CONTENT_CHARSET;' + sLineBreak +
'      //unhandled actions are permitted?' + sLineBreak +
'      Config[TMVCConfigKey.AllowUnhandledAction] := ''false'';' + sLineBreak +
'      //default view file extension' + sLineBreak +
'      Config[TMVCConfigKey.DefaultViewFileExtension] := ''html'';' + sLineBreak +
'      //view path' + sLineBreak +
'      Config[TMVCConfigKey.ViewPath] := ''templates'';'  +sLineBreak +
'      //Enable STOMP messaging controller' + sLineBreak +
'      Config[TMVCConfigKey.Messaging] := ''false'';' + sLineBreak +
'      //Enable Server Signature in response' + sLineBreak +
'      Config[TMVCConfigKey.ExposeServerSignature] := ''true'';' + sLineBreak +
'    end);' + sLineBreak +

//'  FMVC.AddController(%3:s);' + sLineBreak +
'  FMVC.AddController(TioDMVCController);' + sLineBreak +

'end;' + sLineBreak +
sLineBreak +
'procedure %1:s.WebModuleDestroy(Sender: TObject);' + sLineBreak +
'begin' + sLineBreak +
'  FMVC.Free;' + sLineBreak +
'end;' + sLineBreak +
sLineBreak +
'end.' + sLineBreak;


sIORMDMVCWebModuleDFM =
'object %0:s: %1:s' + sLineBreak +
'  OldCreateOrder = False' + sLineBreak +
'  OnCreate = WebModuleCreate' + sLineBreak +
'  OnDestroy = WebModuleDestroy' + sLineBreak +
'  Height = 230' + sLineBreak +
'  Width = 415' + sLineBreak +
'end';

implementation

end.
