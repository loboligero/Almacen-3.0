unit usuario;

interface

uses  Winapi.Windows, System.Types;

function GetLoginName: string;
function GetCurrentSessionId: DWORD;

implementation




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


function ProcessIdToSessionId(dwProcessId: DWORD; pSessionId: DWORD): BOOL; stdcall; external 'kernel32.dll';

function GetSessionIdfromProccessId(const processId: DWORD; var sessionId: DWORD): boolean;
begin
    result:=ProcessIdToSessionId(processId, DWORD(@sessionId));
end;

function GetCurrentSessionId: DWORD;
begin
    if not GetSessionIdfromProccessId(GetCurrentProcessId,result) then
        result:=0;
end;


end.
