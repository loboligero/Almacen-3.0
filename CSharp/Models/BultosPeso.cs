namespace Almacen.CSharp.Models;

/// <summary>
/// Modelo de datos para Bultos y Pesos
/// </summary>
public class BultosPeso
{
    public string Serie { get; set; }
    public string Numero { get; set; }
    public int NumBultos { get; set; }
    public decimal PesoBruto { get; set; }
    public decimal Alto { get; set; }
    public decimal Ancho { get; set; }
    public decimal Largo { get; set; }
    public string TipoPortes { get; set; }
    public int NumPartida { get; set; }
}
