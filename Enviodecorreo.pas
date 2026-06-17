unit Enviodecorreo;

interface


uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, IdMessage, IdAttachment, IdBaseComponent,
  IdEMailAddress, IdGlobal, IdAttachmentFile, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdText;

type
  TEnvioCorreo = class(TObject)
    constructor Create(
        NomFichero : String;
        cHost : String;
        cPort : integer;
        cUserName : String;
        cPassWord : String;
        NomImagen : String;
        cSubject : String
    );

    destructor Destroy; override;

    //Create('texto.html','lara.plesk.trevenque.es',465,     +
    //       'soporte@laragranada.es','sd34_!aX#',           +
    //       'Encabezamiento2021.jpg','Su pedido ha sido enviado);

    procedure CargarFichero(NomFichero : String);
    function EnviarCorreo(NomCliente,NumPedido,
                          NumTracking,URLAgencia,
                          dName, dAdress : String):String;
    // EnviarCorreo('Nombre del Cliente','VE0-54333', '2525412565', +
    //                'URLAgencia','Francisco López Bolivar',          +
    //                'franciscolopezbolivar@gmail.com');

  private
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdSMTP1: TIdSMTP;
    Fichero : TStringList;
    UserName : String;
    NombreImagen : String;
    Asunto : String;
  end;


implementation


constructor TEnvioCorreo.Create(
        NomFichero : String;
        cHost : String;
        cPort : integer;
        cUserName : String;
        cPassWord : String;
        NomImagen : String;
        cSubject : String
    );
begin
  inherited Create();

  NombreImagen := NomImagen;
  Asunto := cSubject;
  UserName := cUserName;
  IdSSLIOHandlerSocketOpenSSL1 := TIdSSLIOHandlerSocketOpenSSL.Create;
  IdSMTP1 := TIdSMTP.Create(nil);

  With IdSSLIOHandlerSocketOpenSSL1 do
  begin
    MaxLineAction := maException;
    SSLOptions.Method := sslvTLSv1;
    SSLOptions.Mode := sslmUnassigned;
    SSLOptions.VerifyMode := [];
    SSLOptions.VerifyDepth := 0;
  end;
//SETTING SMTP COMPONENT DATA //
  with IdSMTP1 do
  begin
    //Host := 'lara.plesk.trevenque.es';
    //Port := 465;
    //Username := 'soporte@laragranada.es';
    //Password := 'sd34_!aX#';
    Host := cHost;
    Port := cPort;
    Username := cUserName;
    Password := cPassWord;
    IOHandler := IdSSLIOHandlerSocketOpenSSL1;
    AuthType := satDefault;
    UseTLS := utUseExplicitTLS;
  end;

  Fichero := TStringList.Create;
  Fichero.LoadFromFile(NomFichero);

end;

destructor TEnvioCorreo.Destroy;
begin
  Fichero.Free;
  IdSMTP1.Free;
  IdSSLIOHandlerSocketOpenSSL1.Free;
  inherited Destroy;
end;



procedure TEnvioCorreo.CargarFichero(NomFichero : String);
begin
  Fichero.LoadFromFile(NomFichero);
end;


function TEnvioCorreo.EnviarCorreo(NomCliente,NumPedido,
                                   NumTracking,URLAgencia,
                                   dName,dAdress : String):String;
var
//  Attachmentfile: TIdAttachmentFile;
  lImagePart : TIdAttachment;

  lMessage: TIdMessage;
  lTextPart: TIdText;

  TextoHTML : TStringList;
  Mensaje :String;

begin
  TextoHTML := TStringList.Create;
  //TextoHTML.Text := Fichero.Text;
  TextoHTML.Text := Fichero.Text.Replace('{Cliente}',NomCliente);
  TextoHTML.Text := TextoHTML.Text.Replace('{NumPedido}',NumPedido);
  TextoHTML.Text := TextoHTML.Text.Replace('{Tracking}',NumTracking);
  TextoHTML.Text := TextoHTML.Text.Replace('{Seguimiento}',URLAgencia);

  //TextoHTML.Text := Fichero.Text.Replace('{Cliente}','Nombre del Cliente');
  //TextoHTML.Text := TextoHTML.Text.Replace('{NumPedido}','VE0-54333');
  //TextoHTML.Text := TextoHTML.Text.Replace('{Tracking}','2525412565');
  //TextoHTML.Text := TextoHTML.Text.Replace('{Seguimiento}','Direccion Agencia');


// IO HANDLER SETTINGS //

  // ... some code here to initialize your SMTP server.
  // It could be done somewhere as well

  lMessage := TIdMessage.Create();
  with lMessage do
  begin
    From.Address := UserName;
    Subject := Asunto;
    Body.Clear;
  end;


  // add recipient list //

  with lMessage.Recipients.Add do
  begin
    Name := dName;
    Address := dAdress;
  end;
(*
  with lMessage.Recipients.Add do
  begin
    Name := 'Francisco López';
    Address := 'franciscolopezbolivar@gmail.com';
  end;
  // add CC list //
  with IdMessage1.CCList.Add do
  begin
    Name := 'Promociones Lara';
    Address := 'promociones@laragranada.es'; // please change email address as required //
  end;

  //add BCC list //
  with IdMessage1.BCCList.Add do
  begin
    Name := 'Francisco Lopez';
    Address := 'franciscolopezbolivar@gmail.com'; // please change email address as required //
  end;
*)


  (*
  // Añadir fichero adjunto
  Attachmentfile := TIdAttachmentFile.Create(lMessage.MessageParts,'requisitos.txt');
  *)


  lTextPart := TIdText.Create(lMessage.MessageParts);
  with lTextPart do
  begin
    ContentType := 'text/html';
    Body.Text :=  TextoHTML.Text;
  end;


  // Inserta imagen en el HTML
  // Para ello debe estar el código en el HTML ver archivo texto.html
  // Si no, lo inserta como una imagen adjunta

  lImagePart := TIdAttachmentFile.Create(lMessage.MessageParts,NombreImagen);
  with lImagePart do
  begin
    ContentType := 'image/jpeg';   // Puede o no estar
    ContentDisposition := 'inline';
    ContentID := NombreImagen;
  end;


(*
  //Inserta texto plano

  lTextPart := TIdText.Create(IdMessage1.MessageParts);
  with lTextPart do
  begin
    Body.Text := 'Texto Plano';
    ContentType := 'text/plain';
    ParentPart := 0;
  end;
*)

  lMessage.ContentType := 'multipart/related; type="multipart/alternative"';
  lMessage.Priority := mpNormal;

  TRY
    IdSMTP1.Connect();
    IdSMTP1.Send(lMessage);
    Mensaje := 'Email enviado';
    IdSMTP1.Disconnect();
  except on e:Exception do
    begin
      Mensaje := e.Message;
      IdSMTP1.Disconnect();
    end;
  END;

  lTextPart.Free;
  lMessage.Free;

 // lImagePart.Free
//  AttachmentFile.Free;

  result := Mensaje;
end;


end.
