unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  Vcl.Grids,Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus, System.UITypes,
  System.Actions, Vcl.ActnList, FireDAC.Stan.Param, Stock;


type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    DateTimePicker1: TDateTimePicker;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    MainMenu1: TMainMenu;
    Configuracion1: TMenuItem;
    Impresora1: TMenuItem;
    StatusBar1: TStatusBar;
    Salir1: TMenuItem;
    DiseoEtiquetas1: TMenuItem;
    ListadodeAgencia1: TMenuItem;
    Edit1: TEdit;
    ActionList1: TActionList;
    Asterisco: TAction;
    Timer2: TTimer;
    DiseoListado1: TMenuItem;
    Shape1: TShape;
    Shape2: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Shape3: TShape;
    Label4: TLabel;
    Shape4: TShape;
    Shape5: TShape;
    Label5: TLabel;
    Stock1: TMenuItem;
    Expediciones1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure Impresora1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure DiseoEtiquetas1Click(Sender: TObject);
    procedure ListadodeAgencia1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure DiseoListado1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Stock1Click(Sender: TObject);
    procedure Expediciones1Click(Sender: TObject);
  private
    { Private declarations }

    procedure ConectarDatos;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ErrorConexion : integer = 0;

implementation

{$R *.dfm}

uses Envio, impresoras, PassWord, cadenas, ficherosIni, Logging, Datos,
  BultosPesos, Expediciones;


procedure Tform1.ConectarDatos;
begin
  if ErrorConexion < 3 then
  begin
    if DM.IcgConnection.Connected then
    begin
      ErrorConexion := 0;
      if DM.DataSource1.DataSet.Active then
        DM.Refrescar(DM.Datasource1.DataSet)
      else
      begin
        DM.FDQAlbaranes.ParamByName('FECHA').Value := datetostr(DateTimePicker1.Date);
        DM.DataSource1.DataSet.Open;
        DM.DataSource5.DataSet.Open;
      end;
      StatusBar1.Panels[3].Text := 'Conectado';
    end
    else
      try
        DM.IcgConnection.Open;
        StatusBar1.Panels[3].Text := 'Conectado';
        DM.FDQAlbaranes.ParamByName('FECHA').Value := datetostr(DateTimePicker1.Date);
        DM.DataSource1.DataSet.Open;
        DM.DataSource5.DataSet.Open;
      except
        inc(ErrorConexion);
        StatusBar1.Panels[3].Text := 'Error de Red:'+inttostr(ErrorConexion);
      end;
  end
  else
  begin
    Exception.Create('ERROR AL CONECTAR A BD');
    if MessageDlg('ERROR AL CONECTAR A BD' +#13+
                  'Compruebe su conexión de red o internet'+#13+
                  'El programa se va a cerrar' , mtInformation,[mbOK], 0) = mrOk then
      Application.Terminate;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := true;
  Screen.MenuFont.Size := 10;
  DateTimePicker1.Date := now();
  ConectarDatos;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = '*' then
  begin
    Edit1.Enabled := true;
    Edit1.SetFocus;
  end;
  if key = #13 then
  begin
    key := #0;
    Perform(WM_NEXTDLGCTL,0,0);
  end;
end;

procedure TForm1.DateTimePicker1Change(Sender: TObject);
begin
  DM.FDQAlbaranes.ParamByName('FECHA').Value := datetostr(DateTimePicker1.Date);
  DM.Refrescar(DM.DataSource1.DataSet);
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
begin
  if DM.Datasource1.DataSet.RecordCount>0 then
  begin
    Timer2.Enabled := false;
    Form2.Fecha := datetostr(DateTimePicker1.Date);
    Form2.ShowModal;
    Timer2.Enabled := true;
  end;
end;

procedure TForm1.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
 var
   grid : TDBGrid;
   CodAgencia : integer;
begin
   grid := sender as TDBGrid;

   if grid.DataSource.DataSet.RecordCount>0 then
   begin
     CodAgencia := grid.DataSource.DataSet.fieldbyname('CODTRANSPORTE').Asinteger;

     if True then

     case CodAgencia of
        0 : // Sin asignar agencia
            grid.Canvas.Brush.Color := clred; // Rojo
            // Nuestros medios
        3 : grid.Canvas.Brush.Color := $000080FF; // Naranja oscuro
            // Sus medios
        6 : grid.Canvas.Brush.Color := $00A000A0  // Morado
     else
       // Dependiendo de la agencia, le va asignando tonos de verde
       // A aquellas líneas que ya están impresas las etiquetas.
       if (grid.DataSource.DataSet.fieldbyname('IMPRESO').AsString = 'T') then
         grid.Canvas.Brush.Color := 256*((11*CodAgencia) mod 256)*((2*CodAgencia) mod 256)
       else
       // A aquellas que no se han impreso les asigna color azul oscuro
         grid.Canvas.Brush.Color := clBlue;
       end;

     grid.DefaultDrawColumnCell(Rect, DataCol, Column, State) ;
  end;
end;


procedure TForm1.DiseoEtiquetas1Click(Sender: TObject);
begin
  if (PasswordDlg.ShowModal = mrok) and (PasswordDlg.Password.Text ='almacen') then
  begin
    DM.frxReport1.LoadFromFile(ExtractFilePath(Application.ExeName)+'report\etiqueta.fr3');
    DM.frxReport1.DesignReport();
  end;
end;

procedure TForm1.DiseoListado1Click(Sender: TObject);
begin
if (PasswordDlg.ShowModal = mrok) and (PasswordDlg.Password.Text ='almacen') then
  begin
    DM.frxReport1.LoadFromFile(ExtractFilePath(Application.ExeName)+'report\listado.fr3');
    DM.frxReport1.DesignReport();
  end;
end;


procedure TForm1.Expediciones1Click(Sender: TObject);

begin
  FrmExpediciones.showmodal;

end;

function GetLoginName: string;
var
buffer: array[0..255] of char;
size: dword;
begin
size := 256;
if GetUserName(buffer, size) then
Result := buffer
else
Result := ''
end;


procedure TForm1.FormActivate(Sender: TObject);
begin
  StatusBar1.Panels[1].Text:= MyFileIni.Datos.Campos[1];
  StatusBar1.Panels[2].Text:= MyFileIni.Datos.Campos[2];
  StatusBar1.Panels[4].Text:= GetLoginName;


  //Edit1.Height := 0;
  //Edit1.Width := 0;
end;


procedure TForm1.Impresora1Click(Sender: TObject);

begin
  if (PasswordDlg.ShowModal = mrok) and (PasswordDlg.Password.Text ='almacen') then
  begin
    ListImpresoras.ComboBox1.Text := MyFileIni.Datos.Campos[1];
    ListImpresoras.ComboBox2.Text := MyFileIni.Datos.Campos[2];

    if (ListImpresoras.ShowModal = mrok) then
    begin
      StatusBar1.Panels[1].Text:= ListImpresoras.ImpInforme;
      MyFileIni.Datos.Campos[1] := ListImpresoras.ImpInforme;
      StatusBar1.Panels[2].Text:= ListImpresoras.ImpEtiq;
      MyFileIni.Datos.Campos[2] := ListImpresoras.ImpEtiq;
      MyFileIni.Escribir;
    end;
  end;
end;

procedure TForm1.ListadodeAgencia1Click(Sender: TObject);
begin

    if (Form3.ShowModal = mrok) then
    begin
      DM.frxReport1.LoadFromFile(ExtractFilePath(Application.ExeName)+'report\listado.fr3');
      DM.frxReport1.PrintOptions.ShowDialog := False;
      DM.frxReport1.PrintOptions.Printer := MyFileIni.Datos.Campos[1];
      DM.frxReport1.PrintOptions.Copies  := 2;
      DM.FDQListaAgencia.ParamByName('FECHA').Value := datetostr(DateTimePicker1.Date);
      DM.FDQListaAgencia.ParamByName('AGENCIA').Value := MyFileIni.Datos.Campos[3];

      DM.DataSource4.DataSet.Close;
      DM.DataSource4.DataSet.Open;

      DM.frxReport1.ShowReport;
    end;
end;


procedure TForm1.Salir1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.Stock1Click(Sender: TObject);
begin
  Form4.Show;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  ConectarDatos;
  Timer1.Enabled := true;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
Var cadena : string;
begin
  if Pos('*',Edit1.Text)>0 then
  begin
    Cadena := Edit1.Text;
    Edit1.Text := '';
    Edit1.Enabled := false;
    if DM.PosicionaRegistro(Cadena) then
    begin
      Timer2.Enabled := false;
      Form2.ShowModal;
      Timer2.Enabled := true;
    end;
  end;
end;

end.
