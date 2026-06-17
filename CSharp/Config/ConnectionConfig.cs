namespace Almacen.CSharp.Config;

public class ConnectionConfig
{
    /// <summary>
    /// Configuración de conexión a SQL Server
    /// </summary>
    public static class SqlServerConnection
    {
        // Servidor: 146.59.144.192
        // Autenticación: SQL Server
        
        public static string GetConnectionString(string usuario, string password, string baseDatos = "AlmacenDB")
        {
            return $"Server=146.59.144.192;Database={baseDatos};User Id={usuario};Password={password};TrustServerCertificate=True;";
        }

        // Ejemplo de uso en appsettings.json o configuración
        public static readonly string DefaultServer = "146.59.144.192";
        public static readonly int DefaultPort = 1433;
        public static readonly bool UseEncryption = true;
    }
}
