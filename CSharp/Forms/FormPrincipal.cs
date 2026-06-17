using Almacen.CSharp.Data;
using Almacen.CSharp.Helpers;
using Almacen.CSharp.Forms;

namespace Almacen.CSharp;

public partial class FormPrincipal : Form
{
    private DataModule _dm;
    private IniFileHelper _iniHelper;
    private int _errorConexion = 0;
    private const int MAX_INTENTOS_CONEXION = 3;

    public FormPrincipal()
    {
        InitializeComponent();
        this.Text = "Almacén 3.0 - Gestión de Etiquetas";
        this.StartPosition = FormStartPosition.CenterScreen;
    }

    private void FormPrincipal_Load(object sender, EventArgs e)
    {
        try
        {
            // Inicializar rutas
            string appPath = Application.StartupPath;
            string iniPath = Path.Combine(appPath, "config.ini");
            _iniHelper = new IniFileHelper(iniPath);

            // Leer credenciales de la configuración
            string usuario = _iniHelper.Leer("SQL", "Usuario", "sa");
            string password = _iniHelper.Leer("SQL", "Password", "");
            string baseDatos = _iniHelper.Leer("SQL", "BaseDatos", "AlmacenDB");

            // Crear DataModule
            _dm = new DataModule(usuario, password, baseDatos);

            // Inicializar UI
            dateTimePicker1.Value = DateTime.Now;
            statusBar1.Items[0].Text = "Desconectado";

            // Iniciar timers
            timer1.Start();

            ConectarDatos();
        }
        catch (Exception ex)
        {
            LoggerHelper.LogError($"Error en FormPrincipal_Load: {ex.Message}");
            MessageBox.Show("Error al inicializar la aplicación: " + ex.Message);
        }
    }

    private void ConectarDatos()
    {
        if (_errorConexion < MAX_INTENTOS_CONEXION)
        {
            if (_dm.Conectar())
            {
                _errorConexion = 0;
                statusBar1.Items[0].Text = "Conectado";
                CargarAlbaranes();
            }
            else
            {
                _errorConexion++;
                statusBar1.Items[0].Text = $"Error de Red: {_errorConexion}";
            }
        }
        else
        {
            MessageBox.Show(
                "ERROR AL CONECTAR A BD\nCompruebe su conexión de red o internet\nEl programa se va a cerrar",
                "Error de Conexión",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
            Application.Exit();
        }
    }

    private void CargarAlbaranes()
    {
        try
        {
            DataTable dt = _dm.ObtenerAlbaranes(dateTimePicker1.Value);
            dataGridView1.DataSource = dt;
        }
        catch (Exception ex)
        {
            LoggerHelper.LogError($"Error cargando albaranes: {ex.Message}");
        }
    }

    private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
    {
        CargarAlbaranes();
    }

    private void dataGridView1_DoubleClick(object sender, EventArgs e)
    {
        if (dataGridView1.SelectedRows.Count > 0)
        {
            DataGridViewRow row = dataGridView1.SelectedRows[0];
            string serie = row.Cells[\"SERIE\"].Value?.ToString() ?? "";
            string numero = row.Cells[\"NUMERO\"].Value?.ToString() ?? "";
            int numPartida = int.TryParse(row.Cells[\"NUMPARTIDA\"].Value?.ToString(), out int np) ? np : 0;

            // Abrir formulario de bultos y pesos
            FormBultosPesos formBultos = new FormBultosPesos(_dm, serie, numero, numPartida);
            formBultos.ShowDialog();
            
            CargarAlbaranes();
        }
    }

    private void timer1_Tick(object sender, EventArgs e)
    {
        timer1.Stop();
        ConectarDatos();
        timer1.Start();
    }

    private void salirToolStripMenuItem_Click(object sender, EventArgs e)
    {
        Application.Exit();
    }

    private void configPrinterasToolStripMenuItem_Click(object sender, EventArgs e)
    {
        // TODO: Implementar diálogo de configuración de impresoras
        MessageBox.Show("Configurar impresoras - A implementar");
    }

    protected override void OnFormClosed(FormClosedEventArgs e)
    {
        _dm?.Dispose();
        base.OnFormClosed(e);
    }
}
