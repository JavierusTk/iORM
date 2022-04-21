unit View.Dataset.Grid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Data.DB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  iORM.Attributes, Model, iORM.MVVM.ViewModelBridge, iORM.DB.DataSet.Base, iORM.MVVM.ModelDataSet;

type

  [diViewFor(TArticle, 'DatasetGrid')]
  TViewDatasetGrid = class(TFrame)
    ViewPanelTop: TPanel;
    LabelTitle: TLabel;
    VMBridge: TioViewModelBridge;
    MDSArticles: TioModelDataSet;
    DSArticles: TDataSource;
    MDSArticlesID: TIntegerField;
    MDSArticlesDescription: TStringField;
    MDSArticlesPrice: TCurrencyField;
    [ioBindAction('acPrevPage')]
    ButtonPreviousPage: TSpeedButton;
    [ioBindAction('acNextPage')]
    ButtonNextPage: TSpeedButton;
    DBGrid1: TDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TFrameDatasetBase }

constructor TViewDatasetGrid.Create(AOwner: TComponent);
begin
  inherited;
  MDSArticles.Open;
end;

end.
