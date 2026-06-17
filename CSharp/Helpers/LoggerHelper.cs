namespace Almacen.CSharp.Helpers;

/// <summary>
/// Logger para registrar eventos y errores
/// Equivalente a Logging.pas en Delphi
/// </summary>
public static class LoggerHelper
{
    private static readonly string LogPath = Path.Combine(Application.StartupPath, "logs");

    static LoggerHelper()
    {
        if (!Directory.Exists(LogPath))
        {
            Directory.CreateDirectory(LogPath);
        }
    }

    public static void LogError(string mensaje)
    {
        Log("ERROR", mensaje);
    }

    public static void LogInfo(string mensaje)
    {
        Log("INFO", mensaje);
    }

    public static void LogWarning(string mensaje)
    {
        Log("WARNING", mensaje);
    }

    private static void Log(string tipo, string mensaje)
    {
        try
        {
            string archivo = Path.Combine(LogPath, $"log_{DateTime.Now:yyyy-MM-dd}.txt");
            string linea = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] [{tipo}] {mensaje}";
            
            File.AppendAllText(archivo, linea + Environment.NewLine);
        }
        catch
        {
            // Silenciar errores de logging
        }
    }
}
