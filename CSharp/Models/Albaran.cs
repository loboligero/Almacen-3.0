namespace Almacen.CSharp.Models;

/// <summary>
/// Modelo de datos para Albaranes
/// </summary>
public class Albaran
{
    public string Serie { get; set; }
    public string Numero { get; set; }
    public DateTime Fecha { get; set; }
    public string Nombre { get; set; }
    public string Direccion { get; set; }
    public string CodPostal { get; set; }
    public string Poblacion { get; set; }
    public string Provincia { get; set; }
    public string EmpresaEnvio { get; set; }
    public int CodTransporte { get; set; }
    public string Impreso { get; set; }
    public int NumPartida { get; set; }
}
