using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using iText.Kernel.Colors;
using Almacen.CSharp.Helpers;

namespace Almacen.CSharp.Reports;

/// <summary>
/// Generador de reportes PDF con iText7
/// Equivalente a manejo de FastReport en Delphi
/// </summary>
public static class ReporteHelper
{
    public static bool GenerarReporteEtiquetas(DataTable datos, string rutaSalida, string nombreReporte = "etiqueta")
    {
        try
        {
            using (PdfWriter writer = new PdfWriter(rutaSalida))
            using (PdfDocument pdf = new PdfDocument(writer))
            using (Document document = new Document(pdf))
            {
                // Añadir contenido al PDF
                foreach (DataRow row in datos.Rows)
                {
                    Paragraph p = new Paragraph($"Serie: {row[\"SERIE\"]}")
                        .SetFontSize(12)
                        .SetFontColor(ColorConstants.BLACK);
                    document.Add(p);

                    Paragraph p2 = new Paragraph($"Número: {row[\"NUMERO\"]}")
                        .SetFontSize(12);
                    document.Add(p2);

                    Paragraph p3 = new Paragraph($"Destino: {row[\"NOMBRE\"]}")
                        .SetFontSize(12);
                    document.Add(p3);

                    document.Add(new Paragraph("\n")); // Salto de línea
                }
            }
            return true;
        }
        catch (Exception ex)
        {
            LoggerHelper.LogError($"Error generando reporte: {ex.Message}");
            return false;
        }
    }

    public static bool GenerarReporteListado(DataTable datos, string rutaSalida)
    {
        try
        {
            using (PdfWriter writer = new PdfWriter(rutaSalida))
            using (PdfDocument pdf = new PdfDocument(writer))
            using (Document document = new Document(pdf))
            {
                // Título
                Paragraph titulo = new Paragraph("LISTADO DE AGENCIA")
                    .SetFontSize(16)
                    .SetBold()
                    .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER);
                document.Add(titulo);

                // Tabla
                Table table = new Table(new float[] { 1, 2, 3, 1 });
                table.AddHeaderCell("Serie");
                table.AddHeaderCell("Número");
                table.AddHeaderCell("Destino");
                table.AddHeaderCell("Peso");

                foreach (DataRow row in datos.Rows)
                {
                    table.AddCell(row[\"SERIE\"].ToString());
                    table.AddCell(row[\"NUMERO\"].ToString());
                    table.AddCell(row[\"NOMBRE\"].ToString());
                    table.AddCell(row[\"PESOBRUTO\"].ToString());
                }

                document.Add(table);
            }
            return true;
        }
        catch (Exception ex)
        {
            LoggerHelper.LogError($"Error generando listado: {ex.Message}");
            return false;
        }
    }
}
