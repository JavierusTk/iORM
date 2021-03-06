unit FormStart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm,
  iORM.MVVM.Components.ViewContextProvider, uniGUIBaseClasses, uniPanel,
  uniRadioGroup, iORM.AbstractionLayer.Framework.VCL;

type
  TStartForm = class(TUniForm)
    VCProvider: TioViewContextProvider;
    PanelTools: TUniPanel;
    ioVCL1: TioVCL;
    procedure VCProviderRequest(const Sender: TObject;
      out ResultViewContext: TComponent);
    procedure VCProviderRelease(const Sender: TObject; const AView,
      AViewContext: TComponent);
    procedure UniFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function StartForm: TStartForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, FormVC, iORM, Model.Interfaces;

function StartForm: TStartForm;
begin
  Result := TStartForm(UniMainModule.GetFormInstance(TStartForm));
end;

procedure TStartForm.UniFormCreate(Sender: TObject);
begin
  io.Show<IBase>(Self);
end;

procedure TStartForm.VCProviderRelease(const Sender: TObject;
  const AView, AViewContext: TComponent);
begin
  AViewContext.Free;
end;

procedure TStartForm.VCProviderRequest(const Sender: TObject;
  out ResultViewContext: TComponent);
begin
  ResultViewContext := TVCForm.Create(uniGUIApplication.UniApplication);
end;

initialization
  RegisterAppFormClass(TStartForm);

end.
