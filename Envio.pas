unit Envio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, datos, Vcl.StdCtrls, Vcl.DBCtrls, ficherosini,
  Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DBLookupComboBox1: TDBLookupComboBox;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  MyFileIni.Datos.Campos[3] := DBLookupComboBox1.Text;
  MyFileIni.Escribir;
  Close;
  ModalResult := mrok;
end;

procedure TForm3.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    Perform(WM_NEXTDLGCTL,0,0);
  end;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  if DM.FDQAgencias.Active then
    DM.FDQAgencias.Refresh
  else
    DM.FDQAgencias.ExecSQL;

//  if MyFileIni.Datos.Campos[3]<>'' then
  begin
    DM.FDQAgencias.Locate('NOMBRE',MyFileIni.Datos.Campos[3]);
    DBLookupComboBox1.KeyValue := MyFileIni.Datos.Campos[3];
  end;
end;

end.
