using Almacen.CSharp.Data;
using Almacen.CSharp.Helpers;

namespace Almacen.CSharp.Forms;

public partial class FormBultosPesos : Form
{
    private DataModule _dm;
    private string _serie;
    private string _numero;
    private int _numPartida;
    private string _bultos = "";
    private string _pesoBruto = "";

    public FormBultosPesos(DataModule dm, string serie, string numero, int numPartida)
    {
        InitializeComponent();
        _dm = dm;
        _serie = serie;
        _numero = numero;
        _numPartida = numPartida;
        this.Text = "Bultos y Pesos";
    }

    private void FormBultosPesos_Load(object sender, EventArgs e)
    {
        try
        {
            ActualizarDatos();
        }
        catch (Exception ex)
        {
            LoggerHelper.LogError($"Error en FormBultosPesos_Load: {ex.Message}");
            MessageBox.Show("Error: " + ex.Message);
        }
    }

    private void ActualizarDatos()
    {
        try
        {
            DataTable dt = _dm.ObtenerBultosPeso(_serie, _numero, _numPartida);
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                textBoxNumBultos.Text = row[\"NUMBULTOS\"].ToString();
                textBoxPeso.Text = row[\"PESOBRUTO\"].ToString();
                textBoxNombre.Text = row[\"NOMBRE\"].ToString();
                textBoxDireccion.Text = row[\"DIRECCION\"].ToString();
                textBoxCodPostal.Text = row[\"CODPOSTAL\"].ToString();
                textBoxPoblacion.Text = row[\"POBLACION\"].ToString();
                textBoxProvincia.Text = row[\"PROVINCIA\"].ToString();

                _bultos = textBoxNumBultos.Text;
                _pesoBruto = textBoxPeso.Text;
            }
        }
        catch (Exception ex)
        {
            LoggerHelper.LogError($"Error actualizando datos: {ex.Message}");
        }
    }

    private void buttonGuardar_Click(object sender, EventArgs e)
    {
        try
        {
            if (!StringHelper.TryParseDouble(textBoxPeso.Text, out double peso))
            {
                MessageBox.Show("El peso debe ser un número válido");
                return;
            }

            if (!int.TryParse(textBoxNumBultos.Text, out int numBultos))
            {
                MessageBox.Show("El número de bultos debe ser un número entero");
                return;
            }

            if (_dm.ActualizarBultosPeso(_serie, _numero, _numPartida, numBultos, (decimal)peso))
            {
                MessageBox.Show("Datos guardados correctamente");
                _bultos = textBoxNumBultos.Text;
                _pesoBruto = textBoxPeso.Text;
            }
            else
            {
                MessageBox.Show("Error al guardar los datos");
            }
        }
        catch (Exception ex)
        {
            LoggerHelper.LogError($"Error guardando datos: {ex.Message}");
            MessageBox.Show("Error: " + ex.Message);
        }
    }

    private void buttonCancelar_Click(object sender, EventArgs e)
    {
        this.Close();
    }

    private void InitializeComponent()
    {
        // TextBox para número de bultos
        this.textBoxNumBultos = new TextBox();
        this.textBoxNumBultos.Location = new Point(10, 30);
        this.textBoxNumBultos.Size = new Size(200, 20);

        // TextBox para peso
        this.textBoxPeso = new TextBox();
        this.textBoxPeso.Location = new Point(10, 60);
        this.textBoxPeso.Size = new Size(200, 20);

        // TextBox para nombre
        this.textBoxNombre = new TextBox();
        this.textBoxNombre.Location = new Point(10, 90);
        this.textBoxNombre.Size = new Size(300, 20);
        this.textBoxNombre.ReadOnly = true;

        // TextBox para dirección
        this.textBoxDireccion = new TextBox();
        this.textBoxDireccion.Location = new Point(10, 120);
        this.textBoxDireccion.Size = new Size(400, 20);
        this.textBoxDireccion.ReadOnly = true;

        // TextBox para código postal
        this.textBoxCodPostal = new TextBox();
        this.textBoxCodPostal.Location = new Point(10, 150);
        this.textBoxCodPostal.Size = new Size(100, 20);
        this.textBoxCodPostal.ReadOnly = true;

        // TextBox para población
        this.textBoxPoblacion = new TextBox();
        this.textBoxPoblacion.Location = new Point(120, 150);
        this.textBoxPoblacion.Size = new Size(200, 20);
        this.textBoxPoblacion.ReadOnly = true;

        // TextBox para provincia
        this.textBoxProvincia = new TextBox();
        this.textBoxProvincia.Location = new Point(330, 150);
        this.textBoxProvincia.Size = new Size(150, 20);
        this.textBoxProvincia.ReadOnly = true;

        // Botones
        this.buttonGuardar = new Button();
        this.buttonGuardar.Text = "Guardar";
        this.buttonGuardar.Location = new Point(10, 200);
        this.buttonGuardar.Size = new Size(75, 23);
        this.buttonGuardar.Click += new EventHandler(this.buttonGuardar_Click);

        this.buttonCancelar = new Button();
        this.buttonCancelar.Text = "Cancelar";
        this.buttonCancelar.Location = new Point(95, 200);
        this.buttonCancelar.Size = new Size(75, 23);
        this.buttonCancelar.Click += new EventHandler(this.buttonCancelar_Click);

        // Labels
        Label labelBultos = new Label();
        labelBultos.Text = "Número de Bultos:";
        labelBultos.Location = new Point(10, 10);

        Label labelPeso = new Label();
        labelPeso.Text = "Peso Bruto:";
        labelPeso.Location = new Point(10, 40);

        // Agregar controles al formulario
        this.Controls.Add(labelBultos);
        this.Controls.Add(this.textBoxNumBultos);
        this.Controls.Add(labelPeso);
        this.Controls.Add(this.textBoxPeso);
        this.Controls.Add(new Label { Text = "Nombre:", Location = new Point(10, 70) });
        this.Controls.Add(this.textBoxNombre);
        this.Controls.Add(new Label { Text = "Dirección:", Location = new Point(10, 100) });
        this.Controls.Add(this.textBoxDireccion);
        this.Controls.Add(new Label { Text = "Código Postal:", Location = new Point(10, 130) });
        this.Controls.Add(this.textBoxCodPostal);
        this.Controls.Add(new Label { Text = "Población:", Location = new Point(120, 130) });
        this.Controls.Add(this.textBoxPoblacion);
        this.Controls.Add(new Label { Text = "Provincia:", Location = new Point(330, 130) });
        this.Controls.Add(this.textBoxProvincia);
        this.Controls.Add(this.buttonGuardar);
        this.Controls.Add(this.buttonCancelar);

        // Configurar formulario
        this.ClientSize = new Size(500, 250);
        this.FormBorderStyle = FormBorderStyle.FixedDialog;
        this.MaximizeBox = false;
        this.MinimizeBox = false;
        this.StartPosition = FormStartPosition.CenterParent;
    }

    private TextBox textBoxNumBultos;
    private TextBox textBoxPeso;
    private TextBox textBoxNombre;
    private TextBox textBoxDireccion;
    private TextBox textBoxCodPostal;
    private TextBox textBoxPoblacion;
    private TextBox textBoxProvincia;
    private Button buttonGuardar;
    private Button buttonCancelar;
}
