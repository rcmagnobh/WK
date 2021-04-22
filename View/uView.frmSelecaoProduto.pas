unit uView.frmSelecaoProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uView.frmBase, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, uClasses.Produto, uClasses.ItemPedido;

type
  TfrmSelecaoProduto = class(TfrmBase)
    pnlControle: TPanel;
    pnlDetalhe: TPanel;
    Button1: TButton;
    Button2: TButton;
    pnlProduto: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FItem: TItemPedido;
    FProduto: TProduto;
    procedure ReceberProduto(aProduto: TProduto);
    procedure ExibirDados;
    procedure QuantidadeValidate(Valor: String);
    procedure UnitarioValidate(Valor: String);
    procedure AtualizarTotal;
    procedure HabilitarTrocaItem;

    { Private declarations }
  public
    property Item: TItemPedido Read FItem Write FItem;
    { Public declarations }
  end;

var
  frmSelecaoProduto: TfrmSelecaoProduto;

implementation

uses
  uView.frmPesqProduto,
  uComum.Lib.Lib;

{$R *.dfm}
{ TfrmSelecaoProduto }

procedure TfrmSelecaoProduto.AtualizarTotal;
begin
  Edit5.Text := FormatarDecimal(Item.Total);
end;

procedure TfrmSelecaoProduto.Button2Click(Sender: TObject);
Var
  Produto: Integer;

begin
  inherited;
  Produto := 0;

  if  TryStrToInt(Edit1.Text, Produto) then
    Item.Produto.Codigo := Produto;

  if Item.Validar then
    ModalResult := mrOk
  else begin
    ShowMessage('Item inválido. Verifique se foi inserido produto, quantidade e valor unitário.');
  end;
end;

procedure TfrmSelecaoProduto.Edit3Exit(Sender: TObject);
begin
  inherited;
  UnitarioValidate(Edit3.Text);
end;

procedure TfrmSelecaoProduto.Edit4Exit(Sender: TObject);
begin
  inherited;
  QuantidadeValidate(Edit4.Text);
end;

procedure TfrmSelecaoProduto.ExibirDados;
begin
  with Item.Produto do
  begin
    Edit1.Text := IntToStr(Codigo);
    Edit2.Text := Descricao;
    Edit3.Text := FormatarDecimal(Item.Produto.Preco);
    Edit4.Text := FormatarDecimal(Item.Quantidade);
    Edit5.Text := FormatarDecimal(Item.Total);
  end;
end;

procedure TfrmSelecaoProduto.FormShow(Sender: TObject);
begin
  inherited;
  HabilitarTrocaItem;
  if Item.Item > 0 then
  begin
    ReceberProduto(Item.Produto);
    QuantidadeValidate(FloatToStr(Item.Quantidade));
    UnitarioValidate(FloatToStr(Item.Unitario));
     AtualizarTotal;
  end;

end;

procedure TfrmSelecaoProduto.HabilitarTrocaItem;
begin
  SpeedButton1.Enabled := Item.Item <= 0;
end;

procedure TfrmSelecaoProduto.QuantidadeValidate(Valor: String);
Var
  V:Double;
  s: String;
begin
  s:= Valor;
  if ValidaeFormataStringToFloat(s) then
  begin
    v := StrToFloat(Valor);
    Item.Quantidade := v;
    Edit4.Text := s;
    AtualizarTotal;
  end
  else begin
    edit4.SetFocus;
  end;
end;

procedure TfrmSelecaoProduto.ReceberProduto(aProduto: TProduto);
begin
  Item.Produto.Codigo := aProduto.Codigo;
  Item.Produto.Descricao := aProduto.Descricao;
  Item.Produto.Preco := aProduto.Preco;
  Item.Unitario := aProduto.Preco;
  ExibirDados;
end;

procedure TfrmSelecaoProduto.SpeedButton1Click(Sender: TObject);
Var
  Teste: Boolean;
begin
  inherited;
  Try
    frmPesqProduto := TfrmPesqProduto.Create(self);
    frmPesqProduto.RetornarProduto := ReceberProduto;
    frmPesqProduto.ShowModal;
    frmPesqProduto.Close;
  Finally
    if Assigned(frmPesqProduto) then
      FreeAndNil(frmPesqProduto);
  End;
end;

procedure TfrmSelecaoProduto.UnitarioValidate(Valor: String);
Var
  v: Double;
  s: String;
begin
  s:= Valor;
  if ValidaeFormataStringToFloat(s) then
  begin
    v := StrToFloat(Valor);
    Item.Unitario := v;
    Edit3.Text := s;
    AtualizarTotal;
  end
  else begin
    edit3.SetFocus;
  end;
end;

end.
