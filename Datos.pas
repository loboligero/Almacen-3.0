unit Datos;

interface

uses
  System.Classes,Dialogs, System.SysUtils, System.Variants, Data.DBXMSSQL, Data.DB, Data.SqlExpr,
  Data.FMTBcd, Datasnap.DBClient, Datasnap.Provider, frxClass, frxDBSet,
  frxDesgn, forms, logging, cadenas, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  frxBarcode, FireDAC.VCLUI.Async, FireDAC.Comp.UI, FireDAC.Phys.ODBCBase;

type
  TDM = class(TDataModule)
    frxDBDataset1: TfrxDBDataset;
    frxDesigner1: TfrxDesigner;
    frxDBDataset2: TfrxDBDataset;
    IcgConnection: TFDConnection;
    FDQAlbaranes: TFDQuery;
    DataSource1: TDataSource;
    DataSource4: TDataSource;
    FDQBultosPeso: TFDQuery;
    DataSource2: TDataSource;
    FDQuery3: TFDQuery;
    DataSource3: TDataSource;
    FDQListaAgencia: TFDQuery;
    FDQAgencias: TFDQuery;
    DataSource5: TDataSource;
    FDQEtiqueta: TFDQuery;
    DataSource6: TDataSource;
    FDQStock: TFDQuery;
    DataSource8: TDataSource;
    frxReport1: TfrxReport;
    DataSource7: TDataSource;
    DataSource10: TDataSource;
    FDQuery6: TFDQuery;
    frxBarCodeObject1: TfrxBarCodeObject;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDGUIxAsyncExecuteDialog1: TFDGUIxAsyncExecuteDialog;
    FDQMejorAgencia: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Refrescar(MiDataSet: TDataSet);
    function PosicionaRegistro(datos : string): boolean;


  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.Refrescar(MiDataSet: TDataSet);
var RegActual : integer;
begin
  try
    if MiDataSet.Active then
    begin
      if MiDataSet.RecordCount>0 then
        RegActual := MiDataSet.RecNo
      else
        RegActual := 1;

      MiDataSet.Close;
      MiDataSet.Open;
      if MiDataSet.RecordCount>=RegActual then
        MiDataSet.RecNo := RegActual
      else
      if MiDataSet.RecordCount>0 then
        MiDataSet.RecNo := 1;
    end
    else
      MiDataSet.Open;

  except
    on e : exception do
    begin
      ShowMessage ('Clase de error: ' + e.ClassName + chr(13) + chr(13) +
          'Mensaje del error: ' + e.Message);
      logger.log(elError, 'Clase de error: ' + e.ClassName + ' ---- ' +
          'Mensaje del error: ' + e.Message);
    end;
  end;
end;


function TDM.PosicionaRegistro(datos : string):boolean;
var
  OutPutList: TStringList;
  resultado : boolean;

begin
  resultado := false;
  OutPutList := TStringList.Create;
  // Analizar el código de barras
  // Elimina todos los asteriscos de la entrada de datos
  datos := StringReplace(datos,'*','',[rfReplaceAll]);
  try
    Split('-', datos, OutPutList);
    if (Datasource1.DataSet.Locate('SERIE;NUMERO',VarArrayOf([OutPutList[0], OutPutList[1]]), [loPartialKey])) then
      resultado := true;
  finally
    OutPutList.Free;
  end;

  result := resultado;
end;



end.
