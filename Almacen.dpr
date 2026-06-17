program Almacen;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  Datos in 'Datos.pas' {DM: TDataModule},
  BultosPesos in 'BultosPesos.pas' {Form2},
  Logging in 'Logging.pas',
  ficherosIni in 'ficherosIni.pas',
  PassWord in 'PassWord.pas' {PasswordDlg},
  impresoras in 'impresoras.pas' {ListImpresoras},
  cadenas in 'cadenas.pas',
  Envio in 'Envio.pas' {Form3},
  Stock in 'Stock.pas' {Form4},
  Expediciones in 'Expediciones.pas' {FrmExpediciones},
  Enviodecorreo in 'Enviodecorreo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glossy');
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TPasswordDlg, PasswordDlg);
  Application.CreateForm(TListImpresoras, ListImpresoras);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TFrmExpediciones, FrmExpediciones);
  Application.Run;
end.
