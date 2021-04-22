unit uClasses.Produto;

interface
uses
  System.Generics.Collections;
Type
  TProduto = class;
  TRetornaProduto = procedure(aProduto: TProduto) of object;
  TListaProdutos = TObjectList<TProduto>;

  TProduto = class
  Private
    FCodigo: Integer;
    FDescricao: String;
    FPreco: Double;
  Public
    Property Codigo: Integer Read FCodigo Write FCodigo;
    Property Descricao: String Read FDescricao Write FDescricao;
    Property Preco: Double Read FPreco Write FPreco;
    Class function PesquisarProduto(Codigo:Integer): TProduto;
    Class function ObterListaProdutosPaginada(Const Pular, Limite: Integer; Var ListaProdutos: TListaProdutos):Boolean;
  end;

implementation
uses
uClasses.DAO.ProdutoDAO, Vcl.Dialogs, System.SysUtils;
{ TProduto }

class function TProduto.ObterListaProdutosPaginada(const Pular,  Limite: Integer; Var ListaProdutos: TListaProdutos):Boolean;
Var
  DAO: TProdutoDAO;
  Ret: Boolean;
begin
  Try
    Ret := False;
    DAO := TProdutoDAO.Create(Nil);
    Ret := DAO.PesquisarPaginada(Limite, Pular,ListaProdutos)
  Finally
    if Assigned(DAO) then
      FreeAndNil(DAO);
    Result := Ret;
  End;
end;

class function TProduto.PesquisarProduto(Codigo:integer): TProduto;
Var
  DAO: TProdutoDAO;
  Ret: TProduto;
begin
  Ret := Nil;
  Try
    Ret := TProduto.Create;
    Ret.Codigo := Codigo;
    Dao :=  TProdutoDAO.Create(Ret);
    if Not DAO.Pesquisar then
    begin
      Showmessage('Produto não localizado.');
      Ret.Free;
      Ret := nil;
    end;
  Finally
    DAO.Free;
    Result := Ret;
  End;
end;

end.
