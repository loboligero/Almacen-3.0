unit BultosPesos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Dateutils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls, Data.DB, Vcl.ExtCtrls, System.Actions, Vcl.ActnList,
  Vcl.Imaging.pngimage, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, frxClass,
  Vcl.ComCtrls, FireDAC.Stan.Param, FireDAC.Comp.DataSet, System.UITypes;

type

  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    //Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label3: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    ENumBultos: TEdit;
    EPeso: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    BtEtiquetasLara: TButton;
    BotonSalir: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Panel1: TPanel;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    StatusBar1: TStatusBar;
    Edit11: TEdit;
    Timer1: TTimer;
    BtEtiquetasCliente: TButton;
    Edit9: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    EAlto: TEdit;
    EAncho: TEdit;
    ELargo: TEdit;
    procedure BtEtiquetasLaraClick(Sender: TObject);
    procedure ENumBultosKeyPress(Sender: TObject; var Key: Char);
    procedure EPesoKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure BotonSalirClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RadioButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

    Bultos    : string;
    PesoBruto : string;
    //Alto      : string;
    //Ancho     : string;
    //Largo     : string;

    { Private declarations }
    procedure ActualizaDatos;

    // ConfirmarGrabar indica si confirmamos a priori o no la grabación
    function ComprobarDatosModificados(confirmarGrabar, imprimir: boolean):integer;

  public
    { Public declarations }
    Fecha : string;

  end;

  TConjuntoChar = set of Ansichar;

const
  CARAC_NO_IMPRIMIBLES  = [#0..#32]; //Podrías sacar el #32 que es la barra espaciadora
  NUMEROS = ['0'..'9']; //Conjunto de los caracteres que quieras permitir
  DECIMAL = [',','.'];

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses cadenas, Datos, Envio, ficherosIni, impresoras, Logging, PassWord,
  Principal;


function MyStrToFloat(const S: String): Extended;
const
  Komma: TFormatSettings = (DecimalSeparator: ',');
  Dot: TFormatSettings = (DecimalSeparator: '.');
begin
  if not TryStrToFloat(S, Result, Komma) then
    Result := StrToFloat(S, Dot);
end;

function ComprobarDouble(var cadena: String):integer;
var x : double;
    resultado : integer;

begin
  resultado := 0;
  x := 0;
  try
  {
    if DecimalSeparator = ',' then
       cadena := StringReplace(cadena,'.',',',[rfReplaceAll]);
    else
       cadena := StringReplace(cadena,',','.',[rfReplaceAll]);

    x := strtofloat(cadena);
   }

   x := MyStrToFloat(cadena);
    //if not TryStrToFloat(cadena, x, (DecimalSeparator: ',')) then
    //  x := StrToFloat(cadena, (DecimalSeparator: '.'));

  except
    on exception do
    begin
      showmessage('Error al introducir el dato: '+floattostr(x));
      resultado := -1;
    end;
  end;
  result := resultado;

end;

// Comprueba si hemos modificado el número de bultos o el peso de ellos.
// Y nos indica si queremos grabarlos
function TForm2.ComprobarDatosModificados(confirmarGrabar, imprimir: boolean):integer;
var resultado: integer;
    CodTransporte : integer;
    NombreAgencia : string;
    Mensaje : string;
    CambiarAgencia : integer;

// FactorVolumen : integer;
//    PesoBascula, PesoVolumetrico : Double;


begin
  resultado := 0;
  CambiarAgencia := 0;
  if (Bultos<>ENumBultos.Text) or (PesoBruto<>EPeso.Text) or imprimir then
  begin
    Application.NormalizeTopMosts;
    if not ConfirmarGrabar then
      // Indicar que los datos son distintos.
      resultado := Application.MessageBox('Se han modificado datos. ¿Desea grabarlos?', 'Grabar datos', MB_OKCANCEL)
    else
      resultado := IDOK;
    Application.RestoreTopMosts;

    if resultado = IDOK then
    begin
      Application.NormalizeTopMosts;
      // Comprobamos si hemos metido calculo de peso por volumen
      // Si es así, calculamos el volumen y el peso dependiendo de
      // agencia de transportes el factor volumen
      // TXT : 225
      // Envialia: 167
      // GLS: 167

      //Alto := EAlto.Text;
      //Ancho:= EAncho.Text;
      //Largo:= ELargo.Text;
      (*
      if (ComprobarDouble(Largo) = 0) and
         (ComprobarDouble(Alto) = 0) and
         (ComprobarDouble(Ancho) = 0)  then
      begin

            // La entrada de volumen es correcta
            // entonces calculamos el PesoVolumetrico
            if DM.DataSource1.DataSet.fieldbyname('EMPRESAENVIO').Value ='TXT' then
              FactorVolumen := 225;
            if DM.DataSource1.DataSet.fieldbyname('EMPRESAENVIO').Value ='ENVIALIA' then
              FactorVolumen := 167;
            if DM.DataSource1.DataSet.fieldbyname('EMPRESAENVIO').Value ='GLS' then
              FactorVolumen := 167;

            PesoVolumetrico := ( MyStrToFloat(ELargo.Text)*
                            MyStrToFloat(EAlto.Text)*
                            MyStrToFloat(EAncho.Text)*
                            FactorVolumen
                          )/1000000;
      end;
      *)

      // Comprobamos que el peso es correcto
//      if ComprobarDouble(PesoBruto) = 0 then
//        PesoBascula := MyStrToFloat(PesoBruto);

      // Comprobamos por donde es más barato enviar el paquete
      // -----------------------------------------------------


      // -----------------------------------------------------

      //Si todo ha ido correcto grabaremos o PesoBascula o PesoVolumetrico
      PesoBruto := EPeso.Text;


      if ComprobarDouble(PesoBruto) = 0 then
      begin
        Bultos := ENumBultos.Text;
        // Actualizamos la base de datos si existen los registros en EtiquetasEnvio
        // y EtiquetasEnvioCab
        DM.FDQuery3.ParamByName('NUMSERIE').VALUE := DM.DataSource1.DataSet.fieldbyname('SERIE').Value;
        DM.FDQuery3.ParamByName('NUMALBARAN').VALUE := DM.DataSource1.DataSet.fieldbyname('NUMERO').Value;
        DM.FDQuery3.ParamByName('NUMBULTOS').VALUE := strtoint(Bultos);
        // Depende de si es volumétrico o por peso se pondrá uno u otro
        DM.FDQuery3.ParamByName('PESOBRUTO').VALUE := MyStrToFloat(EPeso.Text);

        DM.FDQuery3.ParamByName('TIPOPORTES').VALUE := DM.DataSource1.DataSet.fieldbyname('TIPOPORTES').Value;


        //*********************************************************************
        //*********************************************************************
        // Comprobamos si la agencia que tiene el albarán es la más idonea
        //*********************************************************************
        //*********************************************************************

        DM.FDQMejorAgencia.ParamByName('CODPOSTAL').Value := DM.DataSource1.DataSet.fieldbyname('CODPOSTAL').Value;;
        DM.FDQMejorAgencia.ParamByName('PESO').Value := MyStrToFloat(EPeso.Text);
        DM.FDQMejorAgencia.ParamByName('CODPAIS').Value := DM.DataSource1.DataSet.fieldbyname('CODPAIS').Value;
        DM.FDQMejorAgencia.Close;
        DM.FDQMejorAgencia.Open;

        NombreAgencia := DM.DataSource1.DataSet.fieldbyname('EMPRESAENVIO').Value;
        CodTransporte := DM.DataSource1.DataSet.fieldbyname('CODTRANSPORTE').Value;

        if (DM.FDQMejorAgencia.RecordCount>0) and  (DM.FDQMejorAgencia.FieldByName('AGENCIA').AsString <> NombreAgencia) then
        begin
          Mensaje :=  'La Agencia ' +
              DM.FDQMejorAgencia.FieldByName('AGENCIA').AsString +
              ' es más barata que '+NombreAgencia+ '. ¿Desea cambiarla?';

          with Application do
          begin
            NormalizeTopMosts;
            CambiarAgencia := MessageBox(PChar(Mensaje), 'Mejor Agencia',MB_YESNOCANCEL);
            If  CambiarAgencia = IDYES then
            begin
              NombreAgencia := DM.FDQMejorAgencia.FieldByName('AGENCIA').AsString;
              CodTransporte := DM.FDQMejorAgencia.FieldByName('CODIGO').AsInteger;
            end;

            RestoreTopMosts;
          end;
        end;

        //*********************************************************************
        //*********************************************************************
        //*********************************************************************


        DM.FDQuery3.ParamByName('CODTRANSPORTE').VALUE := CodTransporte;
        DM.FDQuery3.ParamByName('EMPRESAENVIO').VALUE := NombreAgencia;

        DM.FDQuery3.ParamByName('DIRECCION').VALUE := DM.DataSource1.DataSet.fieldbyname('DIRECCION').Value;
        DM.FDQuery3.ParamByName('POBLACION').VALUE := DM.DataSource1.DataSet.fieldbyname('POBLACION').Value;
        DM.FDQuery3.ParamByName('PROVINCIA').VALUE := DM.DataSource1.DataSet.fieldbyname('PROVINCIA').Value;
        DM.FDQuery3.ParamByName('CODPOSTAL').VALUE := DM.DataSource1.DataSet.fieldbyname('CODPOSTAL').Value;

        if imprimir and (CambiarAgencia<>IDCANCEL) then
          DM.FDQuery3.ParamByName('IMPRESO').VALUE := 'T'
        else
          if (DM.Datasource1.DataSet.fieldbyname('IMPRESO').Value <> null) then
            DM.FDQuery3.ParamByName('IMPRESO').VALUE := DM.DataSource1.DataSet.fieldbyname('IMPRESO').Value
          else
            DM.FDQuery3.ParamByName('IMPRESO').VALUE := 'F';

        DM.FDQuery3.ParamByName('NOMBRECOMERCIAL').VALUE := DM.DataSource1.DataSet.fieldbyname('NOMBRECOMERCIAL').Value;
        DM.FDQuery3.ParamByName('DIRECCION2').VALUE := DM.DataSource1.DataSet.fieldbyname('DIRECCION2').Value;
        DM.FDQuery3.ParamByName('CODPAIS').VALUE := DM.DataSource1.DataSet.fieldbyname('CODPAIS').Value;
        DM.FDQuery3.ParamByName('PAIS').VALUE := DM.DataSource1.DataSet.fieldbyname('PAIS').Value;
        DM.FDQuery3.ParamByName('TELEFONO').VALUE := DM.DataSource1.DataSet.fieldbyname('TELEFONO').Value;
        DM.FDQuery3.ParamByName('FAX').VALUE := DM.DataSource1.DataSet.fieldbyname('FAX').Value;
        DM.FDQuery3.ParamByName('EMAIL').VALUE := DM.DataSource1.DataSet.fieldbyname('EMAIL').Value;
        DM.FDQuery3.ParamByName('PERSONACONTACTO').VALUE := DM.DataSource1.DataSet.fieldbyname('PERSONACONTACTO').Value;
        if DM.DataSource1.DataSet.fieldbyname('NUMPARTIDA').Value = null then
          DM.FDQuery3.ParamByName('NUMPARTIDA').VALUE := 1
        else
          DM.FDQuery3.ParamByName('NUMPARTIDA').VALUE := DM.DataSource1.DataSet.fieldbyname('NUMPARTIDA').Value;


        DM.FDQuery3.ExecSQL;

        //ActualizaDatos;
        resultado := 0;
      end
      else
        resultado := -1;
      Application.RestoreTopMosts;
    end
    else
      resultado := -1;

  end;
  if CambiarAgencia = IDCANCEL then
  begin
    resultado := 2;
  end;
  result := resultado;
end;

procedure TForm2.ActualizaDatos;
begin
  Edit1.Text := DM.Datasource1.DataSet.fieldbyname('SERIE').AsString + '-' +
                DM.Datasource1.DataSet.fieldbyname('NUMERO').AsString;
  If (DM.Datasource1.DataSet.fieldbyname('NUMPARTIDA').AsString) <> '' then
     Edit1.Text := Edit1.Text + '-' + DM.Datasource1.DataSet.fieldbyname('NUMPARTIDA').AsString;
  Edit3.Text := DM.Datasource1.DataSet.fieldbyname('NOMBRE').AsString;
  Edit4.Text := DM.Datasource1.DataSet.fieldbyname('NOMBRECOMERCIAL').AsString;
  Edit5.Text := DM.Datasource1.DataSet.fieldbyname('DIRECCION').AsString;
  Edit6.Text := DM.Datasource1.DataSet.fieldbyname('CODPOSTAL').AsString;
  Edit7.Text := DM.Datasource1.DataSet.fieldbyname('POBLACION').AsString;
  Edit8.Text := DM.Datasource1.DataSet.fieldbyname('PROVINCIA').AsString;
  Edit9.Text := DM.Datasource1.DataSet.fieldbyname('EMPRESAENVIO').AsString;

  DM.FDQBultosPeso.ParamByName('NUMSERIE').VALUE := DM.Datasource1.DataSet.fieldbyname('SERIE').Value;
  DM.FDQBultosPeso.ParamByName('NUMALBARAN').VALUE := DM.Datasource1.DataSet.fieldbyname('NUMERO').Value;
  DM.FDQBultosPeso.ParamByName('N').Value := DM.Datasource1.DataSet.fieldbyname('N').Value;
  if DM.Datasource1.DataSet.fieldbyname('NUMPARTIDA').Value = null then
    DM.FDQBultosPeso.ParamByName('NUMPARTIDA').VALUE := 1
  else
    DM.FDQBultosPeso.ParamByName('NUMPARTIDA').VALUE := DM.Datasource1.DataSet.fieldbyname('NUMPARTIDA').Value;


  DM.Refrescar(DM.Datasource2.DataSet);

  ENumBultos.Text := DM.Datasource2.DataSet.fieldbyname('NUMBULTOS').AsString;
  EPeso.Text := DM.Datasource2.DataSet.fieldbyname('PESOBRUTO').AsString;

  if ENumBultos.Text = Emptystr then
    ENumBultos.Text := '1';

  Bultos := ENumBultos.Text;
  PesoBruto := EPeso.Text;
  ENumBultos.SetFocus;

end;


procedure TForm2.BtEtiquetasLaraClick(Sender: TObject);
var
  Memo: TfrxMemoView;
  vcb : integer;
  Boton : TButton;
  posicion : Integer;
  CabeceraCSV : string;
  LineaCSV : string;
  FicheroCSV : TStringList;
  codRetorno,
  LPRODUCTO : string;
  NombreAgencia : string;
//  Mensaje : string;
  EtiquetaAgencia : boolean;

begin
  EtiquetaAgencia := false;

  // Debemos comprobar que los datos son correctos
  // Si son correctos, grabamos los datos e imprimimos
  Boton := TButton(Sender);


  if ComprobarDatosModificados(true,RadioButton1.Checked) = 0 then
  begin
    // Si el valor del peso es correcto entonces imprimimos las etiquetas
    posicion := DM.DataSource1.DataSet.RecNo;
    DM.Datasource1.DataSet.Refresh;
    DM.DataSource1.DataSet.RecNo := posicion;

    with DM.FDQEtiqueta do
    begin

      DM.FDQEtiqueta.ParamByName('SERIE').VALUE := DM.Datasource1.DataSet.fieldbyname('SERIE').Value;
      DM.FDQEtiqueta.ParamByName('NUMALBARAN').VALUE := DM.Datasource1.DataSet.fieldbyname('NUMERO').Value;
      DM.FDQEtiqueta.ParamByName('N').Value := DM.Datasource1.DataSet.fieldbyname('N').Value;
      DM.FDQEtiqueta.ParamByName('NUMPARTIDA').VALUE := DM.Datasource1.DataSet.fieldbyname('NUMPARTIDA').Value;
      DM.FDQEtiqueta.Close;
      DM.FDQEtiqueta.Open;


      if (Boton.Name = 'BtEtiquetasLara') then
      begin

        NombreAgencia := FieldByName('EMPRESAENVIO').Value;


        //*****************************************************************
        //*****************************************************************
        if (NombreAgencia = 'GLS') then
        begin
          // Si la Agencia de transportes es GLS, entonces generamos CSV
          CabeceraCSV := 'Referencia;Fecha;Nombre;Direccion;Poblacion;Codigo postal;Telefono;' +
                         'Peso;Bultos;Servicio;Horario;Observaciones;E-mail;Pais;Contacto;Rembolso;Retorno';


          if FieldByName('CODMANIPULACION').AsString = '1' then
            codRetorno := '1'
          else
            codRetorno := '0';

          LineaCSV := FieldByName('SERIE').Value+'-'+
                      FieldByName('NUMERO').AsString+'-'+
                      // En vez de poner el número de partida solamente, generamos
                      // un número aleatorio para añadírselo y evitar números de
                      // envíos repetidos
                      FieldByName('NUMPARTIDA').AsString+
                      inttostr(Random(100))+';'+
                      FieldByName('FECHAENVIO').AsString+';';
          if FieldByName('NOMBRECOMERCIAL').Value = '' then
             LineaCSV := LineaCSV + '"'+FieldByName('NOMBRE').Value+'";'
          else
             LineaCSV := LineaCSV + '"'+FieldByName('NOMBRECOMERCIAL').Value+'-'+FieldByName('NOMBRE').Value+'";';

             LineaCSV := LineaCSV + '"'+FieldByName('DIRECCION').Value+' '+
                      FieldByName('DIRECCION2').Value+'";'+
                      '"'+FieldByName('POBLACION').Value+'";'+
                      FieldByName('CODPOSTAL').Value+';'+
                      FieldByName('TELEFONO').Value+';'+
                      FieldByName('PESOBRUTO').AsString+';'+
                      FieldByName('NUMBULTOS').AsString+';';
             if FieldByName('CODPAIS').Value = 'ES' then
                LineaCSV := LineaCSV+'1;3;' // servicio = 1 ; horario = 3
             else // Servicio para Portugal
             if FieldByName('CODPAIS').Value = 'PT' then
                LineaCSV := LineaCSV+'74;3;'; // servicio = 74 ; horario = 3
             LineaCSV := LineaCSV + '"'+FieldByName('OBSERVACIONES').Value+'";'+
                      '"'+FieldByName('EMAIL').Value+'";' +
                      FieldByName('CODPAIS').Value+';'+
                      '"'+FieldByName('PERSONACONTACTO').Value+'";'+
                      FieldByName('IMPORTECR').AsString+';'+
                      codRetorno;

          EtiquetaAgencia := true;
        end;

        //*****************************************************************
        //*****************************************************************

        if (NombreAgencia = 'REDUR') then
        begin
          // Si la Agencia de transportes es REDUR, entonces generamos CSV
          CabeceraCSV := 'REFERENCIA;TIPO_DE_SERVICIO;MAIL;NOMBRE;NOMBRECOMERCIAL;TELEFONO;NUMBULTOS;PESO;'+
                        'DIRECCION;POBLACION;PROVINCIA;PAIS;CPOSTAL;'+
                        'OBSERVACIONES;PERSONACONTACTO;REEMBOLSO;LPRODUCTO';



          IF TRIM(FieldByName('CODEMBALAJE').AsString)='' THEN
            LPRODUCTO := '001'
          ELSE
            LPRODUCTO := '0'+FieldByName('CODEMBALAJE').AsString;

          LineaCSV := FieldByName('SERIE').Value+'-'+
                      FieldByName('NUMERO').AsString+'-'+
                      // En vez de poner el número de partida solamente, generamos
                      // un número aleatorio para añadírselo y evitar números de
                      // envíos repetidos
                      FieldByName('NUMPARTIDA').AsString+
                      inttostr(Random(100))+';'+
                      'U;"'+ // Este es el tipo de envío
                      FieldByName('EMAIL').Value+'";"' ;
          LineaCSV := LineaCSV +copy(FieldByName('NOMBRE').Value,0,34)+'";"';

          LineaCSV := LineaCSV + Copy(FieldByName('NOMBRECOMERCIAL').Value,0,34)+'";"'+
                      FieldByName('TELEFONO').Value+'";'+
                      FieldByName('NUMBULTOS').AsString+';'+
                      FieldByName('PESOBRUTO').AsString+';"'+
                      FieldByName('DIRECCION').Value+' '+
                      FieldByName('DIRECCION2').Value+'";"'+

                      FieldByName('POBLACION').Value+'";"'+
                      FieldByName('PROVINCIA').Value+'";"'+
                      FieldByName('CODPAIS').Value+'";'+
                      FieldByName('CODPOSTAL').Value+';"'+
                      FieldByName('OBSERVACIONES').Value+'";"'+
                      FieldByName('PERSONACONTACTO').Value+'";'+
                      FieldByName('IMPORTECR').AsString+';"'+
                      LPRODUCTO+'";';

          EtiquetaAgencia := true;
        end;

        //*****************************************************************
        //*****************************************************************

        if (NombreAgencia = 'TXT') then
        begin
          // Si la Agencia de transportes es REDUR, entonces generamos CSV
          CabeceraCSV := 'REFERENCIA;TIPO_DE_SERVICIO;MAIL;NOMBRE;NOMBRECOMERCIAL;NUMBULTOS;PESO;'+
                        'DIRECCION;POBLACION;PROVINCIA;PAIS;CPOSTAL;'+
                        'OBSERVACIONES;REEMBOLSO;TELEFONO';


          LineaCSV := FieldByName('SERIE').Value+'-'+
                      FieldByName('NUMERO').AsString+'-'+
                      // En vez de poner el número de partida solamente, generamos
                      // un número aleatorio para añadírselo y evitar números de
                      // envíos repetidos
                      FieldByName('NUMPARTIDA').AsString+
                      inttostr(Random(100))+';'+
                      '1;"'+ // Este es el tipo de envío
                      FieldByName('EMAIL').Value+'";"' ;
          LineaCSV := LineaCSV +copy(FieldByName('NOMBRE').Value,0,50)+'";"';
          LineaCSV := LineaCSV + Copy(FieldByName('NOMBRECOMERCIAL').Value,0,100)+'";'+

                      FieldByName('NUMBULTOS').AsString+';'+
                      FieldByName('PESOBRUTO').AsString+';"'+
                      FieldByName('DIRECCION').Value+' - '+
                      FieldByName('DIRECCION2').Value+'";"'+

                      FieldByName('POBLACION').Value+'";"'+
                      FieldByName('PROVINCIA').Value+'";"'+
                      FieldByName('CODPAIS').Value+'";'+
                      FieldByName('CODPOSTAL').Value+';"'+
                      FieldByName('OBSERVACIONES').Value+'";"'+
                      //FieldByName('PERSONACONTACTO').Value+'";'+
                      FieldByName('IMPORTECR').AsString+'";'+
                      FieldByName('TELEFONO').Value+';';


          EtiquetaAgencia := true;
        end;

        //*****************************************************************
        //*****************************************************************

           (*
              if (NombreAgencia = 'ENVIALIA') then
              begin
                // Si la Agencia de transportes es Envialia, entonces generamos CSV
                CabeceraCSV := 'REFERENCIA;MAIL;NOMBRE;NOMBRECOMERCIAL;TELEFONO;NUMBULTOS;PESO;'+
                              'TIPO_DE_SERVICIO;DIRECCION;POBLACION;PROVINCIA;PAIS;CPOSTAL;'+
                              'OBSERVACIONES;PERSONACONTACTO;REEMBOLSO;RETORNO';

                if FieldByName('CODMANIPULACION').AsString = '1' then
                  codRetorno := 'S'
                else
                  codRetorno := 'N';

                LineaCSV := FieldByName('SERIE').Value+'-'+
                            FieldByName('NUMERO').AsString+'-'+
                            FieldByName('NUMPARTIDA').AsString+';"'+

                            FieldByName('EMAIL').Value+'";"' ;
                if FieldByName('NOMBRECOMERCIAL').Value = '' then
                   LineaCSV := LineaCSV + FieldByName('NOMBRE').Value+'";"'
                else
                   LineaCSV := LineaCSV + FieldByName('NOMBRECOMERCIAL').Value+'-'+FieldByName('NOMBRE').Value+'";"';

                   LineaCSV := LineaCSV + FieldByName('NOMBRECOMERCIAL').Value+'";"'+
                            FieldByName('TELEFONO').Value+'";'+
                            FieldByName('NUMBULTOS').AsString+';'+
                            FieldByName('PESOBRUTO').AsString+';'+
                            '24;"'+ // Este es el tipo de envío
                            FieldByName('DIRECCION').Value+' '+
                            FieldByName('DIRECCION2').Value+'";"'+

                            FieldByName('POBLACION').Value+'";"'+
                            FieldByName('PROVINCIA').Value+'";"'+
                            FieldByName('PAIS').Value+'";'+
                            FieldByName('CODPOSTAL').Value+';"'+
                            FieldByName('OBSERVACIONES').Value+'";"'+
                            FieldByName('PERSONACONTACTO').Value+'";'+
                            FieldByName('IMPORTECR').AsString+';"'+
                            codRetorno+'";';


                EtiquetaAgencia := true;
              end
              else
            *)

        //*****************************************************************
        //*****************************************************************

        // Si la agencia es de la que tenemos acuerdo para imprimir sus etiquetas

        if EtiquetaAgencia = true then
        begin
          FicheroCSV:= TStringlist.create;
          try
            FicheroCSV.Add(CabeceraCSV);
            FicheroCSV.Add(LineaCSV);

            FicheroCSV.SaveToFile(ExtractFilePath(Application.ExeName)+NombreAgencia+'\Etiquetas'+
            '-'+IntToStr(Hourof(Now)*10000+MinuteOf(Now)*100+SecondOf(Now))+'.csv',TEncoding.UTF8);

          finally
            FicheroCSV.Free
          end;
        end;

        //*****************************************************************
        //*****************************************************************

      end;

    end;

    // En caso de que no sea una de las agencias con las que tenemos acuerdo
    // para generar fichero CSV, entonces imprimimos las etiquetas de LARA
    // O si hemos pulsado el botón de etiqueta cliente imprime la otra

    if (EtiquetaAgencia = false) then
    begin
      if (Boton.Name = 'BtEtiquetasLara')  then
        DM.frxReport1.LoadFromFile(ExtractFilePath(Application.ExeName)+'report\etiqueta.fr3')
      else
        DM.frxReport1.LoadFromFile(ExtractFilePath(Application.ExeName)+'report\etiquetaCliente.fr3');

      DM.frxReport1.PrintOptions.ShowDialog := False;
      DM.frxReport1.PrintOptions.Printer := MyFileIni.Datos.Campos[2];

      for vcb := 1 to strtoint(Bultos) do
      begin
        Memo := DM.frxReport1.FindObject('Memo45') as TfrxMemoView;
        Memo.Text := inttostr(vcb)+'/'+Bultos;
        DM.frxReport1.PrepareReport(True);
        if RadioButton1.Checked then
          DM.frxReport1.Print
        else
          DM.frxReport1.ShowReport;
      end;
    end;

  end;
end;

procedure TForm2.BotonSalirClick(Sender: TObject);
var posicion : Integer;
begin
  // Debemos comprobar que los datos son correctos
  // Antes de cerrar la ventana
  ComprobarDatosModificados(false,false);
  posicion := DM.DataSource1.DataSet.RecNo;
  DM.Datasource1.DataSet.Refresh;
  DM.DataSource1.DataSet.RecNo := posicion;

end;

Procedure TeclasValidas(caracteres : TConjuntoChar; var Key: Char);
begin
  // Si la tecla no está dentro del conjunto de caracteres la anula
  if NOT(CharInSet(Key,caracteres)) then
    Key:=#0;
end;

procedure TForm2.EPesoKeyPress(Sender: TObject; var Key: Char);
begin
  TeclasValidas(CARAC_NO_IMPRIMIBLES+NUMEROS+DECIMAL, Key);
end;

procedure TForm2.ENumBultosKeyPress(Sender: TObject; var Key: Char);
begin
  TeclasValidas(CARAC_NO_IMPRIMIBLES+NUMEROS, Key);
end;

procedure TForm2.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key = '*' then
  begin
    Edit11.Enabled := true;
    Edit11.SetFocus;
  end;
  if key = #13 then
  begin
    key := #0;
    Perform(WM_NEXTDLGCTL,0,0);
  end;

end;

procedure TForm2.FormShow(Sender: TObject);
begin
  ActualizaDatos;
  StatusBar1.Panels[1].Text := MyFileIni.Datos.Campos[1];
  StatusBar1.Panels[2].Text := MyFileIni.Datos.Campos[2];
end;

procedure TForm2.Image1Click(Sender: TObject);
begin
  ComprobarDatosModificados(false,false);
  DM.Datasource1.DataSet.First;
  ActualizaDatos;
end;

procedure TForm2.Image2Click(Sender: TObject);
begin
  ComprobarDatosModificados(false,false);
  DM.Datasource1.DataSet.Prior;
  ActualizaDatos;
end;

procedure TForm2.Image3Click(Sender: TObject);
begin
  ComprobarDatosModificados(false,false);
  DM.Datasource1.DataSet.Next;
  ActualizaDatos;
end;

procedure TForm2.Image4Click(Sender: TObject);
begin
  ComprobarDatosModificados(false,false);
  DM.Datasource1.DataSet.Last;
  ActualizaDatos;
end;


procedure TForm2.RadioButton1Click(Sender: TObject);
begin
  ENumBultos.SetFocus;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
Var cadena : string;
begin
  if Pos('*',Edit11.Text)>0 then
  begin
    Cadena := Edit11.Text;
    Edit11.Text := '';
    Edit11.Enabled := false;
    if not DM.PosicionaRegistro(Cadena) then
      MessageDlg('No se encuentra el registro', mtInformation,
      [mbOk], 0, mbOk)
    else
      ActualizaDatos;
  end;
end;

end.
