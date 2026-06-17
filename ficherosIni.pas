unit ficherosIni;

interface

uses
  inifiles, SysUtils, forms, vcl.printers;

type

  TarrayIni = array [1..7] of string;

  TRegistroIni = class
    Campos    : TarrayIni;
    fichero   : String;
  end;

  TMyFileIni = class
    Datos : TRegistroIni;

    procedure Leer;
    procedure Escribir;
    procedure AsignaValores(valores : TRegistroIni);

    constructor Create;
    destructor Free;
  end;


  Var
    MyFileIni : TMyFileIni;

  Const
    Seccion  : TarrayIni = ('CONFIG','','','','','','');

    Variables: TarrayIni = ('PRN_REPORT','PRN_LABEL','AGENCIA','','','','');

    Valores  : TarrayIni = ('','','','','','','');

implementation

constructor TMyFileIni.Create;
var Buffer : array [0..1000] of char;
begin
    Inherited;
    Datos := TRegistroIni.Create;

    StrLCopy(Buffer,PChar(Application.Exename),length(Application.Exename)-3);
    Datos.fichero := Buffer+'ini'
end;

destructor TMyFileIni.Free;
begin
  Datos.Free;
end;

procedure TMyFileIni.Leer;
var vcb : integer;
begin
  with Datos do
  begin
    with TIniFile.Create(fichero) do
    try
      for vcb:=1 to length(Campos) do
        Campos[vcb] := ReadString(Seccion[1],Variables[vcb],Valores[vcb]);
    finally
      Free;
    end;
  end;
end;


procedure TMyFileIni.Escribir;
var vcb : integer;
begin
  with Datos do
  begin
    with TIniFile.Create(fichero) do
    try
      for vcb:=1 to length(Campos) do
        WriteString(Seccion[1],Variables[vcb],Campos[vcb]);
    finally
      Free;
    end;

  end;
end;


procedure TMyFileIni.AsignaValores(valores : TRegistroIni);
var vcb : integer;
begin
  with Datos do
  begin
    for vcb:=1 to length(Campos) do
      Campos[vcb] := valores.Campos[vcb];
  end;
  Escribir;
end;


begin
  MyFileIni := TMyFileIni.Create;
  if not FileExists(MyFileIni.Datos.fichero) then
  begin
    MyFileIni.Datos.Campos := Valores;
    if (Printer.PrinterIndex > 0) then
    begin
      if (MyFileIni.Datos.Campos[1] = '') then
        MyFileIni.Datos.Campos[1] := Printer.Printers [Printer.PrinterIndex];
      if (MyFileIni.Datos.Campos[2] = '') then
        MyFileIni.Datos.Campos[2] := Printer.Printers [Printer.PrinterIndex];
    end;
    MyFileIni.Escribir;
  end
  else
    MyFileIni.Leer;
end.
