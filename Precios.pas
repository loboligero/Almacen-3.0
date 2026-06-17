unit Precios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, datos, Data.DB, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Stan.Param;

type
  TPreciosAgencias = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    DBGrid1: TDBGrid;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PreciosAgencias: TPreciosAgencias;

implementation

{$R *.dfm}

procedure TPreciosAgencias.Button1Click(Sender: TObject);
begin
  DM.FDQuery10.ParamByName('PESO').Value := Edit1.Text;
  DM.FDQuery10.ParamByName('CODIGOPOSTAL').Value := Edit2.Text;
  DM.FDQuery10.ParamByName('FECHA').Value := datetostr(now());
  DM.DataSource10.DataSet.Close;
  DM.DataSource10.DataSet.Open;
end;

end.
