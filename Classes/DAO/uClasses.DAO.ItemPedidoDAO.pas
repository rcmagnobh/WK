unit uClasses.DAO.ItemPedidoDAO;

interface
uses
  uClasses.ItemPedido,
  uClasses.DAO.BaseDAO;

Type
  TITemPedidoDAO = class(TBaseDAO<TItemPedido>)
  Strict Private
    function StrCamposPadrao: String;
    function SqlDelete: String;override;
    function SqlUpDate: String;override;
    function SqlInsert: String;override;
    function SqlSelect: String;override;
  Private
    procedure ObterDadosDeSqlQuery;
  public
    function GetSqlPadrao: String;
    function Excluir: Boolean;
    function Atualizar: Boolean;
    function Recuperar: Boolean;
    function Inserir: Boolean;
  end;

implementation

uses
  Data.DB,
  Vcl.Dialogs,
  uHelpers.DS.HelpersDS, uHelpers.DS.BuscaParametros,
  uComum.Lib.TratamentoExcecao, System.SysUtils;

{ TITemPedidoDAO }

{$REGION 'CONSTANTES DEFINIDAS PARA TRABALHAR COM ESTUTURA PADRÃO SQL AUXILIANDO NA IDENTIFICACAO DOS CAMPOS'}
{ATRIBUTOS DA ENTIDADE - ID, NUMEROPEDIDO, CODIGOPRODUTO, QUANTIDADE, VALORUNITARIO, VALORTOTAL}
CONST
  CPO_ID: Integer = 0;
  CPO_NUMEROPEDIDO: Integer = 1;
  CPO_PRODUTO: Integer = 2;
  CPO_QUANTIDADE: Integer = 3;
  CPO_UNITARIO: integer = 4;
  CPO_TOTAL: Integer = 5;

  PRM_ID: String = 'ID';
  PRM_NUMEROPEDIDO: String = 'NUMEROPEDIDO';
  PRM_PRODUTO: String = 'CODIGOPRODUTO';
  PRM_QUANTIDADE: String = 'QUANTIDADE';
  PRM_UNITARIO: String = 'VALORUNITARIO';
  PRM_TOTAL: String = 'VALORTOTAL';
{$ENDREGION}

function TITemPedidoDAO.Inserir: Boolean;
Var
  Sql: String;
  Falha: Boolean;
  LstParametros: TListaIBParam;
  BPIndice: IBParamIndice;
  Msg: String;
begin
  Try
    Try
      Sql := SqlInsert;
      Falha :=  Not AtribuirInstrucaoSegSql(Sql);

      if Falha then
        raise EDAOFalhaSql.Create(Sql);

      LstParametros := TListaIBParam.Create;
      BPIndice := TBIndice.Create;
      BPIndice.Parametro(CPO_NUMEROPEDIDO).Valor(Self.Owner.Pedido).TipoDado(ftInteger);
      LstParametros.Add(BPIndice);

      BPIndice := TBIndice.Create;
      BPIndice.Parametro(CPO_PRODUTO).Valor(Self.Owner.Produto.Codigo).TipoDado(ftInteger);
      LstParametros.Add(BPIndice);

      BPIndice := TBIndice.Create;
      BPIndice.Parametro(CPO_QUANTIDADE).Valor(Self.Owner.Quantidade).TipoDado(ftFloat);
      LstParametros.Add(BPIndice);

      BPIndice := TBIndice.Create;
      BPIndice.Parametro(CPO_UNITARIO).Valor(Self.Owner.Unitario).TipoDado(ftFloat);
      LstParametros.Add(BPIndice);

      BPIndice := TBIndice.Create;
      BPIndice.Parametro(CPO_TOTAL).Valor(Self.Owner.Total).TipoDado(ftFloat);
      LstParametros.Add(BPIndice);

      Falha := Self.SqlQuery.DefinirParametro(Msg, LstParametros);

      if Falha then
      begin
        raise EParametroNaoLocalizado.Create(Msg);
      end
      else  begin
        Self.ExcecutarConsulta(procedure(Out Retorno: Boolean)
                               begin
                                Falha := Self.SqlQuery.ExecSQL > 0;
                               end);
        if Falha then
          raise EExecucaoScriptSql.Create('Não registro foi inserido.');
      end;
    except
      On E: exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    End;
  Finally
    if Assigned(LstParametros) then
    begin
      LstParametros.Clear;
      LstParametros.Free
    end;
    Result := Not Falha;
  End;
end;

procedure TITemPedidoDAO.ObterDadosDeSqlQuery;
begin
  with Owner do
  begin
    id :=  Sqlquery.Fields[CPO_ID].AsInteger;
    Pedido := Sqlquery.Fields[CPO_NUMEROPEDIDO].AsInteger;
    Produto.Codigo := SqlQuery.Fields[CPO_PRODUTO].AsInteger;
    Quantidade := SqlQuery.Fields[CPO_QUANTIDADE].AsFloat;
    Unitario := SqlQuery.Fields[CPO_UNITARIO].AsFloat;
  end;
end;

function TITemPedidoDAO.Excluir: Boolean;
Var
  Sql: String;
  Falha: Boolean;
  LstParametros: TListaIBParam;
  BPPNome: IBParamNome;
  Msg: String;
begin
  Try
    Try
      Sql := SqlDelete;
      Falha :=  Not AtribuirInstrucaoSegSql(Sql);

      if Falha then
        raise EDAOFalhaSql.Create(Sql);

      LstParametros := TListaIBParam.Create;
      BPPNome := TBNome.Create;
      BPPNome.Parametro(PRM_ID).Valor(Self.Owner.id).TipoDado(ftInteger);
      LstParametros.Add(BPPNome);

      Falha := Self.SqlQuery.DefinirParametro(Msg, LstParametros);

      if Falha then
      begin
        raise EParametroNaoLocalizado.Create(Msg);
      end
      else  begin
        Self.ExcecutarConsulta(procedure(Out Retorno: Boolean)
                               begin
                                Retorno := Self.SqlQuery.ExecSQL > 0;
                                falha := Retorno;
                               end);
        if Falha then
          raise EExecucaoScriptSql.Create('Falha na Exclusão. Nenhum registro afetado.');
      end;
    except
      On E: exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    End;
  Finally
    if Assigned(LstParametros) then
    begin
      LstParametros.Clear;
      LstParametros.Free
    end;
    Result := Not Falha;
  End;
end;

function TITemPedidoDAO.GetSqlPadrao: String;
begin
  Result :=  'SELECT '+ StrCamposPadrao;
end;

function TITemPedidoDAO.Recuperar: Boolean;
Var
  Sql: String;
  Falha: Boolean;
  LstParametros: TListaIBParam;
  BPPNome: IBParamNome;
  Msg: String;
begin
  Try
    Try
      Sql := SqlSelect;
      Falha :=  Not AtribuirInstrucaoSegSql(Sql);

      if Falha then
        raise EDAOFalhaSql.Create(Sql);

      LstParametros := TListaIBParam.Create;
      BPPNome := TBNome.Create;
      BPPNome.Parametro(PRM_ID).Valor(Self.Owner.id).TipoDado(ftInteger);
      LstParametros.Add(BPPNome);

      Falha := Self.SqlQuery.DefinirParametro(Msg, LstParametros);

      if Falha then
      begin
        raise EParametroNaoLocalizado.Create(Msg);
      end
      else  begin
        Self.ExcecutarConsulta(procedure(Out Retorno: Boolean)
                               begin
                                Self.SqlQuery.Open;
                                if Self.SqlQuery.Active then
                                begin
                                  ObterDadosDeSqlQuery;
                                end;
                               end);
        if Falha then
          raise EExecucaoScriptSql.Create('Falha na Exclusão. Nenhum registro afetado.');
      end;
    except
      On E: exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    End;
  Finally
    if Assigned(LstParametros) then
    begin
      LstParametros.Clear;
      LstParametros.Free
    end;
    Result := Not Falha;
  End;
end;

function TITemPedidoDAO.Atualizar: Boolean;
Var
  Sql: String;
  Falha: Boolean;
  LstParametros: TListaIBParam;
  BPPNome: IBParamNome;
  Msg: String;
begin
  Try
    Try
      Sql := SqlUpDate;
      Falha :=  Not AtribuirInstrucaoSegSql(Sql);

      if Falha then
        raise EDAOFalhaSql.Create(Sql);

      LstParametros := TListaIBParam.Create;
      BPPNome := TBNome.Create;
      BPPNome.Parametro(PRM_QUANTIDADE).Valor(Self.Owner.Quantidade).TipoDado(ftFloat);
      LstParametros.Add(BPPNome);

      BPPNome := TBNome.Create;
      BPPNome.Parametro(PRM_UNITARIO).Valor(Self.Owner.Unitario).TipoDado(ftFloat);
      LstParametros.Add(BPPNome);

      BPPNome := TBNome.Create;
      BPPNome.Parametro(PRM_TOTAL).Valor(Self.Owner.Total).TipoDado(ftFloat);
      LstParametros.Add(BPPNome);

      BPPNome := TBNome.Create;
      BPPNome.Parametro(PRM_ID).Valor(Self.Owner.id).TipoDado(ftInteger);
      LstParametros.Add(BPPNome);

      Falha := Self.SqlQuery.DefinirParametro(Msg, LstParametros);

      if Falha then
      begin
        raise EParametroNaoLocalizado.Create(Msg);
      end
      else  begin
        Self.ExcecutarConsulta(procedure(Out Retorno: Boolean)
                               begin
                                Retorno := (Self.SqlQuery.ExecSQL > 0);
                               end);
        if Falha then
          raise EExecucaoScriptSql.Create('Falha na Exclusão. Nenhum registro afetado.');
      end;
    except
      On E: exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    End;
  Finally
    if Assigned(LstParametros) then
    begin
      LstParametros.Clear;
      LstParametros.Free
    end;
    Result := Not Falha;
  End;
end;

function TITemPedidoDAO.SqlDelete: String;
begin
  Result := 'DELETE FROM PEDIDOS_PRODUTOS WHERE ID = %s';
end;

function TITemPedidoDAO.SqlInsert: String;
begin
 Result := 'INSERT INTO PEDIDOS_PRODUTOS (NUMEROPEDIDO, CODIGOPRODUTO, QUANTIDADE, VALORUNITARIO, VALORTOTAL) VALUES (:NUMEROPEDIDO, :CODIGOPRODUTO, :QUANTIDADE, :VALORUNITARIO, :VALORTOTAL)';
end;

function TITemPedidoDAO.SqlSelect: String;
begin
  Result := 'SELECT ID, NUMEROPEDIDO, CODIGOPRODUTO, QUANTIDADE, VALORUNITARIO, VALORTOTAL FROM PEDIDOS_PRODUTOS WHERE ID = :ID';
end;

function TITemPedidoDAO.SqlUpDate: String;
begin
  Result := 'UPDATE PEDIDOS_PRODUTOS SET QUANTIDADE = :QUANTIDADE, VALORUNITARIO = :VALORUNITARIO, VALORTOTAL = :VALORTOTAL WHERE ID = :ID';
end;

function TITemPedidoDAO.StrCamposPadrao: String;
begin
  Result := 'ID, NUMEROPEDIDO, CODIGOPRODUTO, QUANTIDADE, VALORUNITARIO, VALORTOTAL';
end;

end.
