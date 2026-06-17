namespace Almacen.CSharp.Helpers;

/// <summary>
/// Funciones auxiliares para cadenas
/// Equivalente a cadenas.pas en Delphi
/// </summary>
public static class StringHelper
{
    /// <summary>
    /// Convierte string a double con soporte para ',' y '.'
    /// </summary>
    public static bool TryParseDouble(string texto, out double resultado)
    {
        resultado = 0;
        if (string.IsNullOrWhiteSpace(texto))
            return false;

        // Reemplaza coma por punto si es necesario
        string normalizado = texto.Replace(',', '.');

        return double.TryParse(normalizado, System.Globalization.CultureInfo.InvariantCulture, out resultado);
    }

    /// <summary>
    /// Convierte string a double o lanza excepción
    /// </summary>
    public static double ParseDouble(string texto)
    {
        if (TryParseDouble(texto, out double resultado))
            return resultado;
        
        throw new FormatException($"No se puede convertir '{texto}' a double");
    }

    /// <summary>
    /// Limpia caracteres no imprimibles
    /// </summary>
    public static string LimpiarCaracteres(string texto, bool permitirEspacios = false)
    {
        if (string.IsNullOrEmpty(texto))
            return texto;

        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        foreach (char c in texto)
        {
            if (char.IsControl(c) && c != ' ')
                continue;
            if (!permitirEspacios && c == ' ' && sb.Length == 0)
                continue;
            sb.Append(c);
        }
        return sb.ToString();
    }

    /// <summary>
    /// Trunca string a longitud máxima
    /// </summary>
    public static string Truncar(string texto, int longitud)
    {
        if (string.IsNullOrEmpty(texto))
            return texto;
        
        return texto.Length > longitud ? texto.Substring(0, longitud) : texto;
    }
}
