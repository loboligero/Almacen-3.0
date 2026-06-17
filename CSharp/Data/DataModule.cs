using System.Data.SqlClient;
using Almacen.CSharp.Config;
using Almacen.CSharp.Helpers;

namespace Almacen.CSharp.Data;

/// <summary>
/// DataModule - Gestiona conexión a BD y consultas principales
/// Equivalente a Datos.pas en Delphi
/// </summary>
public class DataModule : IDisposable
{
    private SqlConnection _connection;
    private readonly string _connectionString;

    public DataModule(string usuario, string password, string baseDatos = "AlmacenDB")
    {
        _connectionString = ConnectionConfig.SqlServerConnection.GetConnectionString(usuario, password, baseDatos);
        _connection = new SqlConnection(_connectionString);
    }

    /// <summary>
    /// Abre la conexión a la base de datos
    /// </summary>
    public bool Conectar()
    {
        try
        {
            if (_connection.State == System.Data.ConnectionState.Closed)
            {
                _connection.Open();
            }
            return true;
        }
        catch (SqlException ex)
        {
            LoggerHelper.LogError($"Error al conectar a BD: {ex.Message}");
            return false;
        }
    }

    /// <summary>
    /// Cierra la conexión
    /// </summary>
    public void Desconectar()
    {
        if (_connection?.State == System.Data.ConnectionState.Open)
        {
            _connection.Close();
        }
    }

    /// <summary>
    /// Obtiene albaranes por fecha
    /// </summary>
    public DataTable ObtenerAlbaranes(DateTime fecha)
    {
        DataTable dt = new DataTable();
        try
        {
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerAlbaranesPorFecha", _connection))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FECHA", fecha.Date);

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }
            }
        }
        catch (SqlException ex)
        {
            LoggerHelper.LogError($"Error al obtener albaranes: {ex.Message}");
        }
        return dt;
    }

    /// <summary>
    /// Obtiene información de bultos y peso
    /// </summary>
    public DataTable ObtenerBultosPeso(string serie, string numero, int numPartida)
    {
        DataTable dt = new DataTable();
        try
        {
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerBultosPeso", _connection))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@SERIE", serie);
                cmd.Parameters.AddWithValue("@NUMERO", numero);
                cmd.Parameters.AddWithValue("@NUMPARTIDA", numPartida);

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }
            }
        }
        catch (SqlException ex)
        {
            LoggerHelper.LogError($"Error al obtener bultos/peso: {ex.Message}");
        }
        return dt;
    }

    /// <summary>
    /// Actualiza bultos y peso
    /// </summary>
    public bool ActualizarBultosPeso(string serie, string numero, int numPartida, int numBultos, decimal pesoBruto)
    {
        try
        {
            using (SqlCommand cmd = new SqlCommand("sp_ActualizarBultosPeso", _connection))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@SERIE", serie);
                cmd.Parameters.AddWithValue("@NUMERO", numero);
                cmd.Parameters.AddWithValue("@NUMPARTIDA", numPartida);
                cmd.Parameters.AddWithValue("@NUMBULTOS", numBultos);
                cmd.Parameters.AddWithValue("@PESOBRUTO", pesoBruto);

                cmd.ExecuteNonQuery();
                return true;
            }
        }
        catch (SqlException ex)
        {
            LoggerHelper.LogError($"Error al actualizar bultos/peso: {ex.Message}");
            return false;
        }
    }

    /// <summary>
    /// Obtiene etiquetas para impresión
    /// </summary>
    public DataTable ObtenerEtiquetas(string serie, string numero, int numPartida)
    {
        DataTable dt = new DataTable();
        try
        {
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerEtiquetas", _connection))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@SERIE", serie);
                cmd.Parameters.AddWithValue("@NUMERO", numero);
                cmd.Parameters.AddWithValue("@NUMPARTIDA", numPartida);

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }
            }
        }
        catch (SqlException ex)
        {
            LoggerHelper.LogError($"Error al obtener etiquetas: {ex.Message}");
        }
        return dt;
    }

    /// <summary>
    /// Obtiene mejor agencia según criterios
    /// </summary>
    public DataTable ObtenerMejorAgencia(string codPostal, decimal peso, string codPais)
    {
        DataTable dt = new DataTable();
        try
        {
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerMejorAgencia", _connection))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CODPOSTAL", codPostal);
                cmd.Parameters.AddWithValue("@PESO", peso);
                cmd.Parameters.AddWithValue("@CODPAIS", codPais);

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }
            }
        }
        catch (SqlException ex)
        {
            LoggerHelper.LogError($"Error al obtener mejor agencia: {ex.Message}");
        }
        return dt;
    }

    public void Dispose()
    {
        _connection?.Dispose();
    }
}
