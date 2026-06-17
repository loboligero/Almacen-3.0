unit Logging;

interface

uses

  SysUtils, DateUtils, winApi.Windows;

type

  // tipos de eventos de log
  TtipoEventoLog = ( elInfo, elWarning, elError );

  // niveles debug
  TnivelDebug = ( dbgError,     // solo errores
                  dbgFull);     // todo lo que pille

  TLogger = class(TObject)
    constructor Create(logdir: string; name: string);
    procedure log(tipo: TtipoEventoLog; mess: string);
    function name(): string;
  private
    _hoy: integer;
    _name: string;
    _logdir: string;
  public
    loglevel: TnivelDebug;
  end;

var
  logger: TLogger;

implementation

constructor TLogger.Create(logdir: string; name: string);
begin
  inherited Create();
  if (Length(name)>0) then
    _name := name
  else
    _name := ClassName();
  if Length(logdir) = 0 then
    _logdir := GetEnvironmentVariable('SystemDrive') + '\Temp'
  else
    _logdir := logdir;
  loglevel := dbgFull;
  _hoy := 0;
end;

function TLogger.name(): string;
begin
  Result := _name;
end;

procedure TLogger.log(tipo: TtipoEventoLog; mess: string);
var
  lf: TextFile;
  path,line: string;
  hnd: THandle;
  ahora: TDateTime;
begin
  if (tipo = elInfo) and (loglevel = dbgError) then
    exit;
  ahora := Now();

  if not DirectoryExists(_logdir) then
    if not CreateDir(_logdir) then
      raise Exception.Create('No puedo crear la carpeta:'+ #13 + _logdir);

  path := _logdir+'\'+_name+'-dia-'+inttostr(DayOf(ahora))+inttostr(MinuteOf(ahora))+'.log';

  if not FileExists(path) then begin
    hnd := FileCreate(path);
    if hnd <> INVALID_HANDLE_VALUE then
      FileClose(hnd);
  end;

  AssignFile(lf,path);
  if (_hoy>0) and (_hoy<>DayOf(ahora)) then
    Rewrite(lf)     // machaca
  else
    Append(lf);
  _hoy := DayOf(ahora);

  line := TimeToStr(ahora) + ', ' + ': ';
  case tipo of
    elInfo: line := line + 'INFO, ';
    elWarning: line := line + 'WARNING, ';
    elError: line := line + 'ERROR, ';
  end;
  line := line + mess;
  WriteLn(lf,line);
  CloseFile(lf);
end;

end.
