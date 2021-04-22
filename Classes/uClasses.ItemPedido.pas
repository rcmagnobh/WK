unit uClasses.ItemPedido;

interface
uses
  uClasses.Produto,
  System.Generics.Collections,
  uClasses.Types.AtributosCustomizados;

type
  TItemPedido = class;

  TCBItem = procedure(ItemPedido:TItemPedido) of object;

  [TNomeEntidade('PEDIDOS_ITENS')]
  TItemPedido = class
  private
    Fid: Integer;
    FItem: Integer;
    FPedido: Integer;
    FProduto: TProduto;
    FQuantidade: Double;
    FUnitario: Double;
    function GetTotal: Double;

  public
    constructor Create;
    destructor Destroy;override;

    [TNomeCampo('ID'),TCTipoDado(TTipoDado.ftInteger), TChvPrimaria]
    property id: Integer Read Fid Write Fid;
    Property Item: Integer Read FItem Write FItem;
    [TNomeCampo('NUMERO'), TCTipoDado(TTipoDado.ftInteger), TChvPrimaria]
    property Pedido: Integer Read FPedido Write FPedido;
//    [TChvPrimaria,TNomeCampo('PRODUTO'), TCTipoDado(TTipoDado.ftInteger)]
    property Produto: TProduto Read FProduto Write FProduto;
    property Quantidade: Double Read FQuantidade Write FQuantidade;
    property Unitario: Double Read FUnitario Write FUnitario;
    property Total: Double Read GetTotal;
    function Validar: Boolean;
  end;
  TItensPedido = TObjectList<TItemPedido>;
implementation

{ TItemPedido }

constructor TItemPedido.Create;
begin
  FProduto := TProduto.Create;
  FQuantidade := 1;
  FUnitario := 0;
  Fid := 0;
end;

destructor TItemPedido.Destroy;
begin
  FProduto.Free;
  inherited;
end;

function TItemPedido.GetTotal: Double;
begin
  Result :=  FQuantidade * FUnitario;
end;

function TItemPedido.Validar: Boolean;
Var
  TemQtd, TemProduto, TemValor: Boolean;
begin
  TemQtd := FQuantidade > 0;
  TemProduto := FProduto.Codigo > 0;
  TemValor := Unitario > 0;
  Result := TemQtd and TemProduto  and TemValor;
end;

end.
