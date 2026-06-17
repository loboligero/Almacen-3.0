using System.Runtime.InteropServices;
using System.Text;

namespace Almacen.CSharp.Helpers;

/// <summary>
/// Lectura/escritura de archivos INI
/// Equivalente a ficherosIni.pas en Delphi
/// </summary>
public class IniFileHelper
{
    private readonly string _filePath;

    [DllImport("kernel32", CharSet = CharSet.Unicode)]
    private static extern long WritePrivateProfileString(string section, string key, string value, string filePath);

    [DllImport("kernel32", CharSet = CharSet.Unicode)]
    private static extern int GetPrivateProfileString(string section, string key, string @default, StringBuilder retVal, int size, string filePath);

    public IniFileHelper(string filePath)
    {
        _filePath = filePath;
        if (!File.Exists(_filePath))
        {
            File.Create(_filePath).Dispose();
        }
    }

    public string Leer(string seccion, string clave, string valorPorDefecto = "")
    {
        StringBuilder sb = new StringBuilder(255);
        GetPrivateProfileString(seccion, clave, valorPorDefecto, sb, 255, _filePath);
        return sb.ToString();
    }

    public void Escribir(string seccion, string clave, string valor)
    {
        WritePrivateProfileString(seccion, clave, valor, _filePath);
    }

    public int LeerInt(string seccion, string clave, int valorPorDefecto = 0)
    {
        string valor = Leer(seccion, clave, valorPorDefecto.ToString());
        return int.TryParse(valor, out int resultado) ? resultado : valorPorDefecto;
    }

    public void EscribirInt(string seccion, string clave, int valor)
    {
        Escribir(seccion, clave, valor.ToString());
    }
}
