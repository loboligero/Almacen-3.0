unit Expediciones;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.DBCtrls, datos, ficherosini,
  Data.DB, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, FireDac.Comp.Client, System.DateUtils,
  Vcl.Buttons, IdBaseComponent, IdMessage, Enviodecorreo, FireDAC.Stan.Param;

type
  TFrmExpediciones = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    DateTimePicker1: TDateTimePicker;
    DBLookupComboBox1: TDBLookupComboBox;
    Panel2: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Button2: TButton;
    procedure DateTimePicker1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBLookupComboBox1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmExpediciones: TFrmExpediciones;
  EnvioCorreo1 : TEnvioCorreo;

implementation

{$R *.dfm}

procedure TFrmExpediciones.BitBtn1Click(Sender: TObject);
var
  CadenaSQL : String;
  Consulta : TFDQuery;

begin
  Consulta := TFDQuery.Create(Self);
  Consulta.Connection := DM.IcgConnection;

  // if DBGrid1.DataSource.DataSet.FieldByName('NUMEXPEDICION').AsString<>'' then
  // PREPARAR PARA QUE PREGUNTE CUANDO YA TIENE UN NUMERO DE EXPEDICION

  CadenaSQL := 'UPDATE ETIQUETASENVIO SET NUMEXPEDICION ='''+Edit1.Text +
  ''' where SERIE=''' + DBGrid1.DataSource.DataSet.fieldbyName('SERIE').AsString +
  ''' and NUMERO =' + DBGrid1.DataSource.DataSet.fieldbyName('NUMERO').AsString +
  ' and N =''' + DBGrid1.DataSource.DataSet.fieldbyName('N').AsString +
  ''' and NUMPARTIDA =' + DBGrid1.DataSource.DataSet.fieldbyName('NUMPARTIDA').AsString;
  Consulta.SQL.Text := CadenaSQL;
  Consulta.ExecSQL;
  DBGrid1.DataSource.DataSet.Refresh;
  Edit1.Text := '';
end;

procedure TFrmExpediciones.Button1Click(Sender: TObject);

const AGLS : string = 'https://m.gls-spain.es/e/';
      ATXT : string = 'http://tracking.txt.es/?EXPED=@52395@uj525h00h3mzbiv@E@';

var
  Mensaje : string;
//  Agencia : string;
  URLAgencia : string;
  expedicion : string;
  posicion : Integer;
  indice : Integer;
  vcb : Integer;

begin
  // Enviar Correos.
  indice := 0;

  with DM.FDQuery6 do
  begin
    // He puesto 100 y 200 para que no actue, pero es 10 y 20
    case TButton(Sender).Tag of
      10 :  //Si pulsamos el botón de Envio del registro actual.
            indice := 1;
      200 :  //Si pulsamos el botón de Envío de todos los registros.
            begin
              indice := RecordCount;
              First;
            end;
    end;
    for vcb := 1 to indice do
    begin
      expedicion := FieldByName('NUMEXPEDICION').Text;
      expedicion.Replace(#9,'');
      if not expedicion.IsEmpty  then
      begin
        if FieldByName('EMPRESAENVIO').AsString.Contains('GLS') then
          URLAgencia := AGLS+ expedicion +
               '/'+ FieldByName('CODPOSTAL').AsString;

        if FieldByName('EMPRESAENVIO').AsString.Contains('TXT') then
        begin
          posicion := expedicion.IndexOf('/');
          URLAgencia := ATXT+expedicion.Substring(posicion+1) +
                          '@'+IntToStr(YearOf(DateTimePicker1.Date))+'@';
        end;

        Mensaje := EnvioCorreo1.EnviarCorreo(
            FieldByName('NOMBRE').AsString,
            FieldByName('SERIE').AsString+'-'+
            FieldByName('NUMERO').AsString,
            FieldByName('NUMEXPEDICION').AsString,
            URLAgencia,
            FieldByName('NOMBRE').AsString,
            //FieldByName('EMAIL').AsString);
            //'franciscolopezbolivar@gmail.com');
            'soporte@laragranada.es');
      end;
      if indice>1 then
        Next;
    end;
  end;

  ShowMessage(Mensaje);

end;


procedure TFrmExpediciones.DateTimePicker1Change(Sender: TObject);
begin
  DM.FDQuery6.ParamByName('FECHA').Value := datetostr(DateTimePicker1.Date);
  DM.FDQuery6.ParamByName('AGENCIA').Value := DBLookupComboBox1.Text;

  DM.DataSource6.DataSet.Close;
  DM.DataSource6.DataSet.Open;
end;

procedure TFrmExpediciones.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
 var
   grid : TDBGrid;
   CodAgencia : integer;
begin
   grid := sender as TDBGrid;

   if grid.DataSource.DataSet.RecordCount>0 then
   begin
     CodAgencia := grid.DataSource.DataSet.fieldbyname('CODTRANSPORTE').Asinteger;

     grid.Canvas.Brush.Color := 256*((11*CodAgencia) mod 256)*((2*CodAgencia) mod 256);

     grid.DefaultDrawColumnCell(Rect, DataCol, Column, State) ;
  end;

end;

procedure TFrmExpediciones.DBLookupComboBox1Click(Sender: TObject);
begin
  DateTimePicker1Change(Sender);

end;

procedure TFrmExpediciones.FormActivate(Sender: TObject);
begin
  DateTimePicker1.Date := now();
  DBLookupComboBox1.KeyValue := MyFileIni.Datos.Campos[3];
  DateTimePicker1Change(Sender);


  EnvioCorreo1 := TEnvioCorreo.Create('texto.html','lara.plesk.trevenque.es',465,
                          'soporte@laragranada.es','X4318da69@',
                          'Encabezamiento2021.jpg','Su pedido ha sido enviado');


end;

end.
