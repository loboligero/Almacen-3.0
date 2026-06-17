namespace Almacen.CSharp;

partial class FormPrincipal
{
    private System.ComponentModel.IContainer components = null;
    private DataGridView dataGridView1;
    private DateTimePicker dateTimePicker1;
    private StatusStrip statusBar1;
    private MenuStrip menuStrip1;
    private ToolStripMenuItem configuracionToolStripMenuItem;
    private ToolStripMenuItem impresoras1ToolStripMenuItem;
    private ToolStripMenuItem diseñoEtiquetasToolStripMenuItem;
    private ToolStripMenuItem salirToolStripMenuItem;
    private Timer timer1;

    protected override void Dispose(bool disposing)
    {
        if (disposing && (components != null))
        {
            components.Dispose();
        }
        base.Dispose(disposing);
    }

    private void InitializeComponent()
    {
        this.components = new System.ComponentModel.Container();

        // MenuStrip
        this.menuStrip1 = new MenuStrip();
        this.configuracionToolStripMenuItem = new ToolStripMenuItem();
        this.impresoras1ToolStripMenuItem = new ToolStripMenuItem();
        this.diseñoEtiquetasToolStripMenuItem = new ToolStripMenuItem();
        this.salirToolStripMenuItem = new ToolStripMenuItem();

        this.menuStrip1.Items.AddRange(new ToolStripItem[] {
            this.configuracionToolStripMenuItem,
            this.diseñoEtiquetasToolStripMenuItem,
            this.salirToolStripMenuItem
        });

        this.configuracionToolStripMenuItem.Text = "Configuración";
        this.configuracionToolStripMenuItem.DropDownItems.Add(this.impresoras1ToolStripMenuItem);
        this.impresoras1ToolStripMenuItem.Text = "Impresoras";
        this.impresoras1ToolStripMenuItem.Click += new EventHandler(this.configPrinterasToolStripMenuItem_Click);

        this.diseñoEtiquetasToolStripMenuItem.Text = "Diseño de Etiquetas";
        this.salirToolStripMenuItem.Text = "Salir";
        this.salirToolStripMenuItem.Click += new EventHandler(this.salirToolStripMenuItem_Click);

        // DateTimePicker
        this.dateTimePicker1 = new DateTimePicker();
        this.dateTimePicker1.Location = new Point(10, 10);
        this.dateTimePicker1.Size = new Size(200, 20);
        this.dateTimePicker1.ValueChanged += new EventHandler(this.dateTimePicker1_ValueChanged);

        // DataGridView
        this.dataGridView1 = new DataGridView();
        this.dataGridView1.Dock = DockStyle.Fill;
        this.dataGridView1.Location = new Point(0, 30);
        this.dataGridView1.AllowUserToAddRows = false;
        this.dataGridView1.ReadOnly = true;
        this.dataGridView1.DoubleClick += new EventHandler(this.dataGridView1_DoubleClick);

        // StatusStrip
        this.statusBar1 = new StatusStrip();
        this.statusBar1.Items.Add(new ToolStripStatusLabel("Estado: Desconectado"));

        // Timer
        this.timer1 = new Timer(this.components);
        this.timer1.Interval = 30000; // 30 segundos
        this.timer1.Tick += new EventHandler(this.timer1_Tick);

        // FormPrincipal
        this.AutoScaleDimensions = new SizeF(7F, 15F);
        this.AutoScaleMode = AutoScaleMode.Font;
        this.ClientSize = new Size(800, 600);
        this.Controls.Add(this.dataGridView1);
        this.Controls.Add(this.dateTimePicker1);
        this.Controls.Add(this.statusBar1);
        this.MainMenuStrip = this.menuStrip1;
        this.Controls.Add(this.menuStrip1);
    }
}
