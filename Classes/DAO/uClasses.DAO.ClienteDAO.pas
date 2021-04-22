unit uClasses.DAO.ClienteDAO;

interface

uses
  uClasses.Cliente,
  uClasses.DAO.BaseDAO;

Type
  TClienteDAO = class(TBaseDAO<TCliente>)
  private
    function SqlSelect: String;override;
    function SqlSelectCliente: String;
  public
    function ObterListaClientes(Out Lista: tclientes): Boolean;
    function Recupear: Boolean;
  end;

implementation

uses
  System.SysUtils,
  uComum.Lib.TratamentoExcecao, DB;

{ TClienteDAO }

function TClienteDAO.ObterListaClientes(out Lista: tclientes): Boolean;
Const
  CPO_CODIGO: Integer = 0;
  CPO_NOME: Integer = 1;
  CPO_CIDADE: Integer = 2;
  CPO_UF: Integer = 3;
{$Region 'Popular lista'}
procedure PopularLista(Var Lst: TClientes);
Var
  Cliente: TCliente;
begin
  SqlQuery.First;
  while Not SqlQuery.Eof do
  begin
    Cliente := TCliente.Create;
    Cliente.Codigo := SqlQuery.Fields[CPO_CODIGO].AsInteger;
    Cliente.Nome := SqlQuery.Fields[CPO_NOME].AsString;
    Cliente.Cidade := SqlQuery.Fields[CPO_CIDADE].AsString;
    Cliente.UF := SqlQuery.Fields[CPO_UF].AsString;
    Lst.Add(Cliente);
    SqlQuery.Next;
  end;
end;
{$Endregion}
Var
  Sql: String;
  Falha : boolean;
begin
  Try
    Lista.Clear;
    Sql := SqlSelect;
    Falha := Not AtribuirInstrucaoSegSql(Sql);

    if Not Falha then
    begin
      Try
        SqlQuery.Open;
        if SqlQuery.Active then
        begin
          if Not SqlQuery.IsEmpty then
          begin
            PopularLista(Lista);
          end
          else begin
            raise Exception.Create('Nenhum registro encontrado');
          end;
        end
        else begin
          raise EExecucaoScriptSql.Create('Falha ao executar scprit.');
        end;
      Except
        On E: Exception do
        begin
          Falha := True;
          TratamentoExcecao(e);
        end;
      End;
    end;
  Finally
    if SqlQuery.Active then
      SqlQuery.Close;
    Result := Not Falha;
  End;
end;

function TClienteDAO.Recupear: Boolean;
Const
  CPO_CODIGO: Integer = 0;
  CPO_NOME: Integer = 1;
  CPO_CIDADE: Integer = 2;
  CPO_UF: Integer = 3;
Var
  Sql: String;
  Falha: Boolean;
  Msg: String;
begin
  Falha := False;
  Sql := EmptyStr;
  Try
    Sql := SqlSelectCliente;
    Falha := Not AtribuirInstrucaoSegSql(Sql);
    if Not falha then
    begin
      LstIParametros.Clear;
      AdicionarParametroQuery('CODIGO',Owner.Codigo,ftInteger);
      Falha := Not AplicarParametros(Msg);
    end;
    Try
      SqlQuery.Open;
      if SqlQuery.Active then
      begin
        if Not SqlQuery.IsEmpty then
        begin
          with Owner do
          begin
            Codigo := SqlQuery.Fields[CPO_CODIGO].AsInteger;
            Nome := SqlQuery.Fields[CPO_NOME].AsString;
            Cidade := SqlQuery.Fields[CPO_CIDADE].AsString;
            UF := SqlQuery.Fields[CPO_UF].AsString;
          end;
        end
        else begin
          raise EFalhaPesquisa.Create('Registro não localizado.');
        end;
      end
      else begin
        raise EFalhaPesquisa.Create('Falha ao pesquisar cliente.');
      end;
    Except
      On E: Exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    End;
  Finally
    LstIParametros.Clear;
    if SqlQuery.Active then
      SqlQuery.Close;
    Result := Falha;
  End;
end;

function TClienteDAO.SqlSelect: String;
begin
  Result := 'SELECT CODIGO, NOME, CIDADE, UF FROM CLIENTES';
end;

function TClienteDAO.SqlSelectCliente: String;
Var
  Sql: TStringBuilder;
  Ret: String;
begin
  Try
    Ret := EmptyStr;
    Sql := TStringBuilder.Create;
    Sql.Append(SqlSelect).Append(' WHERE CODIGO = :CODIGO');
    Ret := Sql.ToString;
  Finally
    if Assigned(Sql) then
      Sql.Free;
    Result := Ret;
  End;
end;

end.
