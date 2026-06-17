unit impresoras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Printers;

type
  TListImpresoras = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure SalirOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ImpInforme : string;
    ImpEtiq : string;
  end;

var
  ListImpresoras: TListImpresoras;

implementation

{$R *.dfm}

procedure TListImpresoras.SalirOkClick(Sender: TObject);
begin
  ImpInforme := Combobox1.Items[ComboBox1.ItemIndex];
  ImpEtiq := Combobox2.Items[ComboBox2.ItemIndex];
  Close;
  ModalResult := mrok;
end;

procedure TListImpresoras.FormShow(Sender: TObject);
begin
  ComboBox1.Items.AddStrings(Printer.Printers);
  ComboBox2.Items.AddStrings(Printer.Printers);
end;

end.
