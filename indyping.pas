unit indyping;

interface

uses System.SysUtils, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdCmdTCPClient,vcl.dialogs, System.UITypes;

Var
  IdCmdTCPClient1: TIdCmdTCPClient;

  function Ping(host: string; puerto: word ): boolean;

implementation


function Ping(host: string; puerto: word ): boolean;
begin
  IdCmdTCPClient1.Host := host;
  IdCmdTCPClient1.Port := puerto;
  try
    if not IdCmdTCPClient1.Connected then
      IdCmdTCPClient1.Connect;
  except
    MessageDlg('Error de conexion',
    mtConfirmation, [mbYes], 0, mbYes);
  end;

  result := IdCmdTCPClient1.Connected;

end;

begin
  IdCmdTCPClient1 := TIdCmdTCPClient.Create();
end.
