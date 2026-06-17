unit cadenas;



interface

uses system.classes,system.sysutils;

   Function CadenaCaracterDelante(Cadena : String; caracter:Char ;tam : Integer):String;
   Function StrToExtended(Cadena : String):Extended;
   Function CerosComasXEspacios(Cadena : String):string;
   Function NormalizaComaDecimales(Cadena : String): string;
   Function RealToStrInt(valor : real; longitud : integer): string;
   Function FloatToStrNDecimales(valor : real; decimales : integer): string;
   Function CustomStrToFloat(S: string): Extended;
   procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);

implementation

uses math, strutils;
// *****************************************************************
// Funciones con cadenas
// *****************************************************************

// Genera una cadena de N caracteres rellenando lo que falta con un caracter delante
Function CadenaCaracterDelante(Cadena : String; caracter:Char ;tam : Integer):String;
var
   Saux: String;
   vcb:  integer;

begin
  For vcb:=1 to tam-Length(cadena) do
  begin
    Saux := Saux + caracter;
  end;
  Result := Concat(Saux,Cadena);
end;


// El tipo Extended es un número en coma flotante que va de-hasta:
// 3.37e-4932 .. 1.18e+4932
Function StrToExtended(Cadena : String):extended;
var total : extended;
    vcb, longitud:  integer;

begin
   total := 0;
   longitud := length(cadena);
   for vcb:=longitud downto 1 do
      total :=  total+strtoint(cadena[vcb])*power(10,longitud-vcb);
   result:= total;
end;

// Reemplaza los ceros y las comas por espacios
Function CerosComasXEspacios(Cadena : String): string;
var
   vcb : integer;
begin
   vcb := 1;
   while ((Cadena[vcb]='0') or (Cadena[vcb]=',')) do
   begin
      Cadena[vcb] :=' ';
      vcb:=vcb+1;
   end;
   result := Cadena;
end;

// Reemplaza la coma por el punto
Function NormalizaComaDecimales(Cadena : String): string;
begin
  Result := AnsiReplaceStr(Cadena,',','.');
end;


Function RealToStrInt(valor : real; longitud : integer): string;
begin
  Result := CadenaCaracterDelante(Inttostr(Trunc(valor)),' ', longitud);
end;

Function FloatToStrNDecimales(valor : real; decimales : integer): string;
begin
  result := FloatToStrF(valor,ffnumber,20,decimales);
end;


Function ReemplazaCadena(S: string; c : string; R : string) : string;
var
  cadena: string;
begin
  cadena := S;
  while Pos(c, cadena) > 0 do
   cadena := AnsiReplaceStr(cadena, c, R);

  result := cadena;

end;

Function CustomStrToFloat(S: string): Extended;
var
    // Sin separador de miles (S Without Thousand Separator)
  SWTS : string;
begin
  SWTS := S;
  SWTS := ReemplazaCadena(SWTS,FormatSettings.ThousandSeparator,'');
  Result := StrToFloat(SWTS)
end;


// Divide una cadena en varias a partir de un separador
procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requere D2006 o superior.
   ListOfStrings.DelimitedText   := Str;
end;


end.
