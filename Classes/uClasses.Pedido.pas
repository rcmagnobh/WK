unit uClasses.Pedido;

interface

uses
  uClasses.Cliente,
  uClasses.ItemPedido, System.Generics.Collections;


type
  TPedido = class;//protipagem
  TPedidos = TObjectList<TPedido>;
  TPedido = class
  Private
    FNumero: Integer;
    FData: TDateTime;
    FCliente: TCliente;
    FListaItens: TItensPedido;
    FListaExclusao: TItensPedido;
    FContagemItem: Integer;
    function GetTotal: Double;
    function InserirPedido:Boolean;
    function ValidarIndice(Const Indice: Integer): Boolean;
    procedure AdicionarItemLixeira(Item: TItemPedido);
    procedure RefazNumeracaoItem;
  Public
    Constructor Create;
    Destructor Destroy;override;
    Property Numero: Integer Read FNumero Write FNumero;
    Property Data: TDateTime Read FData Write FData;
    Property Cliente: TCliente Read FCliente Write FCliente;
    property Total: Double Read GetTotal;
    Property ListaItens: TItensPedido Read FListaItens Write FListaItens;
    Property ListaExclusao: TItensPedido Read FListaExclusao Write FListaExclusao;
    procedure InserirItem(aItem: TItemPedido);
    procedure LimparListaItens;
    function RemoverItem(aItem: TItemPedido): TItemPedido;
    procedure LimparCliente;
    procedure ReceberItem(Id, Produto: Integer; Descricao: String;Quantidade, Unitario: Double);
    function Excluir: Boolean;
    function Atualizar:Boolean;
    function Salvar: Boolean;
    function DescartarItem(Item: Integer): Boolean;
    function EditarItem(Item: TItemPedido): Boolean;
    function AdicionarNovoItem:Boolean;
    function ObterIndiceDoItem(Const Item: Integer): Integer;
    function ObterItemDeIndice(Const Indice: Integer):TItemPedido;
    function PedidoENovo: Boolean;
    function Recuperar: Boolean;
    class function RecuperarTodosPedidos(Out LstPedido: TPedidos): Boolean;
  end;

Const
  INDICENULO: Integer = -1;

implementation

uses
  System.SysUtils,
  uClases.DAO.PedidoDAO,
  uComum.Lib.TratamentoExcecao,
  uComum.Lib.Lib, uView.frmSelecaoProduto, System.UITypes;

{ TPedido }

procedure TPedido.AdicionarItemLixeira(Item: TItemPedido);
begin
  FListaExclusao.Add(Item);
end;

function TPedido.AdicionarNovoItem: Boolean;
Var
  Item: TItemPedido;
  Incluir: Boolean;
begin
  Try
    Item := TItemPedido.Create;
    Item.Item := -1;
    Item.Pedido := FNumero;
    Incluir := EditarItem(Item);
    if Incluir then
      InserirItem(Item);
  Finally
    if Not Incluir then
      Item.Free;
    Result := Incluir;
  End;

end;

function TPedido.Atualizar: Boolean;
Var
  DAO: TPedidoDAO;
  Ret: Boolean;
begin
  Try
    Ret := False;
    DAO := TPedidoDAO.Create(self);
    Ret := DAO.Update;
  Finally
    if Assigned(DAO) then
      DAO.Free;
    Result := Ret;
  End;
end;

constructor TPedido.Create;
begin
  FListaItens := TItensPedido.Create;
  FListaExclusao := TItensPedido.Create;
  FCliente := TCliente.Create;
  FContagemItem:= 0;
end;

function TPedido.DescartarItem(Item: Integer): Boolean;
Var
  Ret: Boolean;
  Indice: Integer;
  ItemEncontrado: Boolean;
begin
  Ret := False;
  Indice := ObterIndiceDoItem(Item);
  ItemEncontrado := (Indice <> INDICENULO);
  if ItemEncontrado then
  begin
    AdicionarItemLixeira(RemoverItem(ObterItemDeIndice(Indice)));
    Ret := True;
    RefazNumeracaoItem;
  end;
  Result := Ret;
end;

destructor TPedido.Destroy;
begin
  FListaExclusao.Clear;
  FListaItens.Clear;
  if Assigned(FListaExclusao) then
    FreeAndNil(FListaExclusao);
  if Assigned(FListaItens) then
    FreeAndNil(FListaItens);
  FCliente.Free;
  inherited;
end;

function TPedido.EditarItem(Item: TItemPedido): Boolean;
Var
  Ret: Boolean;
begin
  Try
    Ret := False;
    frmSelecaoProduto := TfrmSelecaoProduto.Create(nil);
    frmSelecaoProduto.Item := item;
    Ret := (frmSelecaoProduto.ShowModal = mrOk);
    frmSelecaoProduto.Close;
  Finally
    if Assigned(frmSelecaoProduto) then
      FreeAndNil(frmSelecaoProduto);
    Result := Ret;
  End;
end;

function TPedido.Excluir: Boolean;
Var
  Dao: TPedidoDAO;
  Ret: Boolean;
begin
  Try
    Dao := TPedidoDAO.Create(Self);
    Ret := Dao.Excluir;
  Finally
    if Assigned(Dao) then
      Dao.Free;
    Result := Ret;
  End;
end;

function TPedido.GetTotal: Double;
Var
  Ret: Double;
  i: Integer;
begin
  Ret := 0;
  for i := 0 to FListaItens.Count -1 do
  begin
    Ret := Ret + FListaItens[i].Total;
  end;
  Result := Ret;
end;

procedure TPedido.InserirItem(aItem: TItemPedido);
begin
  if FListaItens.IndexOf(aItem) = -1 then
  begin
    Inc(FContagemItem);
    aItem.Item := FContagemItem;
    FListaItens.Add(aItem);
  end;
end;

function TPedido.InserirPedido: Boolean;
Var
  DAO: TPedidoDAO;
  Ret: Boolean;
begin
  Try
    Ret := False;
    DAO := TPedidoDAO.Create(Self);
    DAO.EnviarItem := ReceberItem;
    Ret := DAO.Inserir;
  Finally
    DAO.Free;
    Result := Ret;
  End;
end;

procedure TPedido.LimparCliente;
begin
  if Assigned(FCliente) then
    FreeAndNil(FCliente);
end;

procedure TPedido.LimparListaItens;
begin
  FListaItens.Clear;
  FContagemItem := 0;
end;

function TPedido.ObterIndiceDoItem(Const Item: Integer): Integer;
Var
  TemItem, Encontrou: Boolean;
  Ret: Integer;
  I: Integer;

begin
  Ret := INDICENULO;
  TemItem := FListaItens.Count > 0;
  if TemItem then
  begin
    for I := 0 to FListaItens.Count -1 do
    begin
      Encontrou := (Item = FListaItens[i].Item);
      if Encontrou then
      begin
        Ret := i;
        Break;
      end;
    end;
  end;
  Result := Ret;
end;

function TPedido.ObterItemDeIndice(const Indice: Integer): TItemPedido;

begin
  if ValidarIndice(Indice) then
  begin
    Result := FListaItens[Indice];
  end
  else begin
    Result := nil;
  end;
end;

function TPedido.PedidoENovo: Boolean;
begin
  Result := Self.Numero <=0;
end;

procedure TPedido.ReceberItem(Id, Produto: Integer; Descricao: String;
  Quantidade, Unitario: Double);
Var
  Item: TItemPedido;
begin
  Item := TItemPedido.Create;
  Item.id := Id;
  Item.Item := -1;
  Item.Pedido := Self.Numero;
  Item.Produto.Codigo := Produto;
  Item.Produto.Descricao := Descricao;
  Item.Produto.Preco := Unitario;
  Item.Unitario := Unitario;
  Item.Quantidade := Quantidade;
  InserirItem(Item);
end;

function TPedido.Recuperar: Boolean;
Var
  Dao: TPedidoDAO;
  Ret: Boolean;
begin
  Ret := False;
  Try
    Dao := TPedidoDAO.Create(Self);
    Dao.EnviarItem := ReceberItem;
    Ret := Dao.Recuperar;
  Finally
    if Assigned(DAO) then
      DAO.Free;
    Result := Ret;
  End;
end;

class function TPedido.RecuperarTodosPedidos(out LstPedido: TPedidos): Boolean;
Var
  DAO: TPedidoDAO;
  Pedido: TPedido;
  Ret: Boolean;
begin
  Ret := False;
  Try
    Pedido := TPedido.Create;
    Dao := TPedidoDAO.Create(Pedido);
    Ret := DAO.PequisarPedidos(LstPedido);
  Finally
    if Assigned(DAO) then
      DAO.Free;
    if Assigned(Pedido) then
      Pedido.Free;
    Result := Ret;
  End;
end;

procedure TPedido.RefazNumeracaoItem;
Var
  Contador: Integer;
  Item: TItemPedido;
begin
  Contador := 0;
  FListaItens.TrimExcess;
  for Contador := 0 to FListaItens.Count -1 do
  begin
    FListaItens[Contador].Item := (Contador+1);
  end;
  FContagemItem := FListaItens.Count;
end;

function TPedido.RemoverItem(aItem: TItemPedido): TItemPedido;
begin
  Result := FListaItens.Extract(aItem)
end;

function TPedido.Salvar: Boolean;
Var
  DAO: TPedidoDAO;
  Ret: Boolean;
  TemItem: Boolean;
  TemCliente: Boolean;
begin
  Ret := False;
  TemItem := FListaItens.Count > 0;
  TemCliente := Self.Cliente.Codigo > 0;
  if (Not TemItem) or (Not TemCliente) then
  begin
    LevantarExcecaoPedido('O pedido deve no mínimo 1 item e informado o código do cliente.');
    Exit(False);
  end;
  Try
    if Self.PedidoENovo then
    begin
      Ret := InserirPedido
    end
    else begin
      Ret := Atualizar;
    end;
  Finally
    if Ret then
    begin
      Self.Recuperar;
    end;
    Result := Ret;
  End;
end;

function TPedido.ValidarIndice(const Indice: Integer): Boolean;
begin
  Result := (FListaItens.Count > 0) and ((Indice >=0) and (Indice < FListaItens.Count));
end;

end.
