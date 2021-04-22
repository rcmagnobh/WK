unit uClasses.DAO.ProdutoDAO;

interface

uses
  uClasses.Produto,
  Data.SqlExpr,
  uClasses.DAO.ConexaoDB.DMConexaoDB;

Type
  TProdutoDAO = class
  Private
    FDMConexao: TDMConexaoDB;
    FSqlQuery: TSQLDataSet;
    FProduto: TProduto;
    FConectado: Boolean;
    function Conectar:Boolean;
    function ObterSelectSqlPadrao: String;
  public
    Constructor Create(Produto: TProduto);
    Destructor Destroy; override;
    function Pesquisar: Boolean;
    function PesquisarPaginada(Const Limite, Pular: Integer; var Lista: TListaProdutos):Boolean;
  end;

implementation

uses
  System.SysUtils,
  uHelpers.DS.HelpersDS,
  Data.DB,
  uComum.Lib.TratamentoExcecao;

const
  CPO_CODIGO: Integer = 0;
  CPO_DESCRICAO: Integer = 1;
  CPO_PRECOVENDA: Integer = 2;

{ TProdutoDAO }

function TProdutoDAO.Conectar: Boolean;
Var
  Ret: Boolean;
begin
  Ret := False;
  Try
    Ret := FDMConexao.GetConnection.Connected;
    if Ret then
    begin
      Try
        if FSqlQuery.Active then
          FSqlQuery.Close;
        FSqlQuery.SQLConnection := FDMConexao.SQLConnection1;
      Except
        On e: Exception do
        begin
          TratamentoExcecao(e);
          Ret := False;
        end;
      End;
    end;
  Finally
    Result := Ret;
  End;
end;

constructor TProdutoDAO.Create(Produto: TProduto);
Var
  Sucesso: Boolean;
begin
  FProduto := Produto;
  FDMConexao := TDMConexaoDB.New(Sucesso);
  FSqlQuery := TSQLDataSet.Create(nil);
  FConectado :=  Conectar;
end;

destructor TProdutoDAO.Destroy;
begin
  if FSqlQuery.Active then
    FSqlQuery.Close;
  FSqlQuery.Free;
  FDMConexao.Free;
  inherited;
end;

function TProdutoDAO.ObterSelectSqlPadrao: String;
Var
  s: TStringBuilder;
  Ret: String;
begin
  Try
    s := TStringBuilder.Create;
    s.Append('SELECT CODIGO, DESCRICAO, PRECOVENDA FROM PRODUTOS ');
    Ret := s.ToString;
  Finally
    if Assigned(s) then
      FreeAndNil(s);
    Result := Ret;
  End;
end;

function TProdutoDAO.Pesquisar: Boolean;
{$REGION 'método local'}
  function ObterSql: String;
  Var
    s: TStringBuilder;
    Ret: String;
  begin
    Ret := EmptyStr;
    Try
      s := TStringBuilder.Create;
      s.Append(ObterSelectSqlPadrao)
       .Append('WHERE CODIGO = :CODIGO');
      Ret := s.ToString;
    Finally
      if Assigned(s) then
        FreeAndNil(s);
      Result := Ret;
    End;
  end;
{$ENDREGION}
Const
  PRM_CODIGO: Integer = 0;
Var
  Ret: Boolean;
  Sql: String;
  Msg: String;
begin
  Ret := False;
  Try
    Try
      Sql := ObterSql;
      if FSqlQuery.Active then
        FSqlQuery.Close;
      FSqlQuery.CommandType := ctQuery;
      FSqlQuery.CommandText := EmptyStr;
      FSqlQuery.CommandText := Sql;
      if Not  FSqlQuery.DefinirParametro(Msg,PRM_CODIGO,FProduto.Codigo,ftInteger)then
      begin
        raise EParametroNaoLocalizado.Create(Msg);
      end;
      FSqlQuery.Open;
      Ret :=  Assigned(FSqlQuery) and (Not FSqlQuery.IsEmpty);
      if Ret then
      begin
        FProduto.Codigo := FSqlQuery.Fields[CPO_CODIGO].AsInteger;
        FProduto.Descricao := FSqlQuery.Fields[CPO_DESCRICAO].AsString;
        FProduto.Preco := FSqlQuery.Fields[CPO_PRECOVENDA].AsFloat;
      end
      else begin
        raise ERegistroNaoLocalizado.Create(Format('Produto [%d] não foi localizado.',[fproduto.Codigo]));
      end;
    Except
      On e: Exception do
      begin
        TratamentoExcecao(e);
        exit(False);
      end;
    end;
  Finally
    if FSqlQuery.Active then
      FSqlQuery.Close;
    Result := Ret;
  End;
end;

function TProdutoDAO.PesquisarPaginada(Const Limite, Pular: Integer; var Lista: TListaProdutos):Boolean;
{$Region 'Métodos locais'}
function ObterSql(Const Paginada: Boolean): String;
Var
  s: TStringBuilder;
  Ret: String;
begin
  Ret := EmptyStr;
  Try
    s := TStringBuilder.Create;
    s.Append(ObterSelectSqlPadrao);
    if Paginada then
    begin
      s.Append(' LIMIT %s,%s');
      Ret := Format(s.ToString,[IntToStr(Pular), IntTostr(Limite)]);
    end
    else begin
      Ret := s.ToString;
    end;
  Finally
    if Assigned(s) then
      FreeAndNil(s);
    Result := Ret;
  End;
end;

procedure PopularLista;
Var
  Produto: TProduto;
begin
  FSqlQuery.First;
  while Not FSqlQuery.Eof do
  begin
    Produto := TProduto.Create;
    Produto.Codigo := FsqlQuery.Fields[CPO_CODIGO].AsInteger;
    Produto.Descricao := FSqlQuery.Fields[CPO_DESCRICAO].AsString;
    Produto.Preco := FSqlQuery.Fields[CPO_PRECOVENDA].AsFloat;
    Lista.Add(Produto);
    FSqlQuery.Next;
  end;
end;
{$Endregion}
Var
  Paginada: Boolean;
  Sql: String;
  Ret: Boolean;
begin
{$Region 'Inicializando'}
  Ret := False;
  Paginada := (Limite > 0);
  Sql := ObterSql(Paginada);

  if FSqlQuery.Active then
    FSqlQuery.Close;
  FSqlQuery.CommandType := ctQuery;
  FSqlQuery.CommandText := EmptyStr;
  FSqlQuery.CommandText := Sql;
{$Endregion}
  Try
{$Region 'Executando consulta e populando lista'}
    Try
      FSqlQuery.Open;
      Ret := Not FSqlQuery.IsEmpty;
      if Ret then
      begin
        PopularLista;
      end
      else begin
        raise ERegistroNaoLocalizado.Create('');
      end;
    Except
      on e: exception do
      begin
        TratamentoExcecao(e);
      end;
    end;
{$Endregion}
  Finally
{$Region 'Concluíndo'}
    if FSqlQuery.Active then
      FSqlQuery.Close;
    Result := Ret;
{$Endregion}
  end;
end;

end.
