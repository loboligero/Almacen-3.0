namespace Almacen.CSharp;

static class Program
{
    /// <summary>
    /// Punto de entrada principal de la aplicación.
    /// </summary>
    [STAThread]
    static void Main()
    {
        ApplicationConfiguration.Initialize();
        Application.Run(new FormPrincipal());
    }
}