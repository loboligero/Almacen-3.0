unit Stock;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, datos, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Param;

type
  TForm4 = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
var cadena: string;

begin
  case Radiogroup1.ItemIndex of
    0 : cadena := Edit1.Text+'%';
    1 : cadena :='%'+Edit1.Text+'%';
    2 : cadena := Edit1.Text;
    3 : cadena := '%'+Edit1.Text;
  end;
  DM.FDQStock.ParamByName('Referencia').Value := UpperCase(cadena);
  DM.FDQStock.ParamByName('Descatalogado').Value := 'F';
  DM.FDQStock.Close;
  DM.FDQStock.Open();
end;

end.
