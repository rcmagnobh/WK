unit uClases.DAO.PedidoDAO;

interface
uses
  uClasses.Pedido,
  uClasses.DAO.BaseDAO;

Type
  TCallBackItem = procedure(Id, Produto: Integer;Descricao: String;Quantidade, Unitario: Double) of object;

  TPedidoDAO = class(TBaseDAO<TPedido>)
  Strict Private
    function SqlDelete: String;override;
    function SqlUpDate: String;override;
    function SqlInsert: String;override;
    function SqlSelect: String;override;
    function SqlSqlectPedido: String;
    function SqlDeleteItem: String;
    function SqlDeleteItens: String;
    function SqlInsertItem: String;
    function SqlUpdateItem: String;
  private
    FEnviarItem: TCallBackItem;
    function ExecInsert: Boolean;
    function ExecDelete: Boolean;
    function ExecDeleteItem(Const ID: Integer): Boolean;
    function ExecUpdate: Boolean;
    function ExecSelect: Boolean;
    function ExecInserirItens: Boolean;
    function ExcluirItens: Boolean;
    function ExcluirItensLixeira: Boolean;
    function ExecUpdateItens: Boolean;
  public
    property EnviarItem: TCallBackItem Read FEnviarItem Write FEnviarItem;
    function ObterProximoNumeroPedido: Integer;
    function Inserir: Boolean;
    function Excluir: Boolean;
    function Update: Boolean;
    function Recuperar: Boolean;
    function PequisarPedidos(Out LstPedido: TPedidos): Boolean;
  end;
Const
  ZEROREGISTRO: Integer = 0;
implementation
uses
  Data.DB,
  System.SysUtils,
  uComum.Lib.Lib,
  uComum.Lib.TratamentoExcecao,
  uHelpers.DS.HelpersDS,
  uComum.Types.Types,
  uHelpers.DS.BuscaParametros;



{ TITemPedidoDAO }

function TPedidoDAO.Excluir: Boolean;
Var
  Ret: Boolean;
  Falha: Boolean;
begin
  Try
    FAtivarTransacao := True;
    IniciarTransacao;
    Falha := Not ExcluirItens;  //fazendo a exclusão dos itens antes de excluir o pedido
    if Not Falha then
      Falha := Not ExecDelete;  //Exclusão do cabeçalho
  Finally
    if SqlQuery.Active then
      SqlQuery.Close;
    EncerrarTransacao(Falha);
    FAtivarTransacao := False;
    Result := Not Falha;
  End;
end;

function TPedidoDAO.ExcluirItens: Boolean;
Var
  Sql: String;
  Falha: Boolean;
  Msg:String;
begin
  Msg := EmptyStr;

  Try
    Sql := SqlDeleteItens;
    Falha := Not AtribuirInstrucaoSegSql(Sql);

    if Not Falha then
    begin
      SqlQuery.DefinirParametro(Msg,'NUMEROPEDIDO',Owner.Numero, ftInteger);
    end;
    Try
      if Not Falha then
      begin
        Falha :=  (SqlQuery.ExecSQL <= ZEROREGISTRO);
      end;
        if Falha then
          raise EExecucaoScriptSql.Create('Falha ao excluir item do pedido.');
    Except
      On E: Exception do
      begin
        TratamentoExcecao(e);
      end;
    end;
  Finally
    LstIParametros.Clear;
    if SqlQuery.Active then
      SqlQuery.Close;
    Result := Not Falha;
  End;
end;

function TPedidoDAO.ExcluirItensLixeira: Boolean;
Var
  Erros: SmallInt;
  I: Integer;
begin
  Erros := 0;
  for i := 0 to Owner.ListaExclusao.Count -1 do
  begin
    if Not ExecDeleteItem(Owner.ListaExclusao[i].id) then
      Erros := Erros +1;
  end;
  Result := (Erros = 0);
end;

function TPedidoDAO.ExecDelete: Boolean;
Const
  PRM_NUMERO: String = 'NUMERO';
Var
  Sql, SqlItens: String;
  Falha: Boolean;
  Msg: String;
begin
  Msg := EmptyStr;
  Falha := False;
  Sql := SqlDelete;
  SqlItens := SqlDelete;
  Try
    Try
      if Not Falha then
      begin
        Falha := Not AtribuirInstrucaoSegSql(Sql);
      end;
      if Not Falha then
      begin
        SqlQuery.DefinirParametro(Msg,PRM_NUMERO,Owner.Numero, ftInteger);
      end;

      if Not Falha then
      begin
        Falha := (SqlQuery.ExecSQL <= ZEROREGISTRO);
        if Falha then
        begin
          raise EExecucaoScriptSql.Create('Nenhum registro excluído.');
        end;
      end;
    Except
      On e: exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    End;
  Finally
    if SqlQuery.Active then
      SqlQuery.Close;
    Result := Not Falha;
  End;
end;

function TPedidoDAO.ExecDeleteItem(const ID: Integer): Boolean;
Const
  PRM_ID: String = 'ID';
  PRM_NUMEROPEDIDO: String = 'NUMEROPEDIDO';
Var
  Sql: String;
  Falha: Boolean;
  Msg: String;
begin
  Falha := False;
  Try
    Sql := SqlDeleteItem;
    Falha := not AtribuirInstrucaoSegSql(Sql);

    if Not Falha then
    begin
      SqlQuery.DefinirParametro(Msg,PRM_ID,ID,ftInteger);
      SqlQuery.DefinirParametro(Msg,PRM_NUMEROPEDIDO, Owner.Numero,ftInteger);
    end;

    Try
      if Not Falha then
      begin
        Falha := (SqlQuery.ExecSQL <= ZEROREGISTRO)
      end;
      if Falha then
        raise EFalhaPesquisa.Create('Falha eo excluir o pedido.');
    Except
      On E: Exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    End;
  Finally
    if SqlQuery.Active then
      SqlQuery.Close;
    Result := (Not Falha);
  End;
end;

function TPedidoDAO.ExecInsert: Boolean;
{$Region 'parametros da query'}
CONST
  PRM_NUMERO: String = 'NUMERO';
  PRM_CLIENTE: STring = 'CLIENTE';
  PRM_EMISSAO: String = 'EMISSAO';
  PRM_TOTAL: String = 'TOTAL';
{$Endregion}
Var
  Sql: String;
  Falha: Boolean;
  Msg: String;
begin
  Falha := False;
  Sql := EmptyStr;
  Sql := SqlInsert;

  Falha := Not AtribuirInstrucaoSegSql(Sql);

  Try
    Try
      if Not Falha then
      begin
        //atribuiindo parâmetros
        SqlQuery.DefinirParametro(Msg,PRM_NUMERO,Owner.Numero, ftInteger);
        SqlQuery.DefinirParametro(Msg,PRM_CLIENTE,Owner.Cliente.Codigo,ftInteger);
        SqlQuery.DefinirParametro(Msg,PRM_EMISSAO,FormatDateTime(MASCARADATA,Owner.Data),ftString);
        SqlQuery.DefinirParametro(Msg,PRM_TOTAL,Arredondar(Owner.Total),ftFloat);
      end;

      if Not Falha then
        Falha := (SqlQuery.ExecSQL <= ZEROREGISTRO);
      if Falha then
         raise  EExecucaoScriptSql.Create('Não foi possível inserir o pedido.');
    Except
      On E: Exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    End;
  finally
    LstIParametros.Clear;
    if SqlQuery.Active then
      SqlQuery.Close;
    Result := Not Falha;
  End;
end;

function TPedidoDAO.ExecSelect: Boolean;
{$Region 'ìndices dos campos'}
Const
  CPO_NUMERO: Integer = 0;
  CPO_EMISSAO: Integer = 1;
  CPO_CLIENTE: Integer = 2;
  CPO_NOMECLIENTE: Integer = 3;
  CPO_CIDADE: Integer = 4;
  CPO_UF: Integer = 5;
  CPO_VALORTOTAL: Integer = 6;
  CPO_PRODID: Integer = 7;
  CPO_PRODCODIGO: Integer = 8;
  CPO_PRODDESCRICAO: Integer = 9;
  CPO_PRODUNITARIO: Integer = 10;
  CPO_PRODQUANTIDADE: Integer = 11;
{$Endregion}
Var
  Falha: Boolean;
  Sql: String;
  Msg: String;
begin
  Try
    Falha := False;
    Sql := SqlSqlectPedido;
    Falha := Not AtribuirInstrucaoSegSql(Sql);
    if Not Falha then
    begin
      SqlQuery.DefinirParametro(Msg,'NUMERO',Owner.Numero,ftInteger);
    end;
    Owner.LimparListaItens;
    if Not Falha then
    begin
      Try
        SqlQuery.Open;
        if SqlQuery.Active then
        begin
          if Not SqlQuery.IsEmpty then
          begin
            SqlQuery.First;
            with Owner do
            begin
              //otendo os dados do cabeçalho do pedido
              Data := SqlQuery.Fields[CPO_EMISSAO].AsDateTime;
              Cliente.Codigo  := SqlQuery.Fields[CPO_CLIENTE].AsInteger;
              Cliente.Nome    := SqlQuery.Fields[CPO_NOMECLIENTE].AsString;
              Cliente.Cidade  := SqlQuery.Fields[CPO_CIDADE].AsString;
              Cliente.UF      := SqlQuery.Fields[CPO_UF].AsString;
            end;
            //preenchendo itens
            while Not SqlQuery.Eof do
            begin
              EnviarItem(SqlQuery.Fields[CPO_PRODID].AsInteger,
                         SqlQuery.Fields[CPO_PRODCODIGO].AsInteger,
                         SqlQuery.Fields[CPO_PRODDESCRICAO].AsString,
                         SqlQuery.Fields[CPO_PRODQUANTIDADE].AsFloat,
                         SqlQuery.Fields[CPO_PRODUNITARIO].AsFloat);
              SqlQuery.Next;
            end;
          end
          else begin
            raise ERegistroNaoLocalizado.Create('Pedido não localizado.');
          end;
        end
        else begin
          raise EDAOFalhaSql.Create('Falha ao executar a consulta do pedido.');
        end;
      Except
        on E: Exception do
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

function TPedidoDAO.ExecUpdate: Boolean;
Const
  PRM_NUMERO: String = 'NUMERO';
Var
  Sql, SqlItens: String;
  Falha: Boolean;
  Msg: String;
  I: Integer;
  Erros: SmallInt;
begin
  Msg := EmptyStr;
  Falha := False;
  Erros := 0;
  Try
{$Region 'PEDIDOS GERAIS'}
    Sql := SqlUpDate;
    Try
      Falha := Not AtribuirInstrucaoSegSql(Sql);

      if Not Falha then
      begin
        SqlQuery.DefinirParametro(Msg,'NUMERO',Owner.Numero, ftInteger);
        SqlQuery.DefinirParametro(Msg,'CODIGO_CLI',Owner.Cliente.Codigo, ftInteger);
        SqlQuery.DefinirParametro(Msg,'EMISSAO',FormatarDataToString(Owner.Data),ftString);
        SqlQuery.DefinirParametro(Msg,'TOTAL',Arredondar(Owner.Total),ftFloat);
        SqlQuery.DefinirParametro(Msg,'NUMORIGEM',Owner.Numero,ftInteger);
      end;

      if Not Falha then
      begin
        Falha := Not SqlQuery.ExecSQL > 0;

        if Falha then
          raise EExecucaoScriptSql.Create('Falha ao tentar atualizar pedido.');
      end;
    Except
      On E: Exception do
      begin
        TratamentoExcecao(e);
      end;
    End;
{$Endregion}
    Falha := (Erros > 0);
  Finally
    if SqlQuery.Active then
      SqlQuery.Close;
    Result := Not Falha;
  End;
end;

function TPedidoDAO.ExecUpdateItens: Boolean;
Var
  Sql: String;
  Falha: Boolean;
  I: Integer;
  Msg: String;
begin
  Falha := False;
  Sql := SqlUpdateItem;
  Try
    Try
      for I := 0 to Owner.ListaItens.Count -1 do
      begin
        if Owner.ListaItens[i].id <=0 then
          Continue;

        Falha := Not AtribuirInstrucaoSegSql(Sql);
        with Owner.ListaItens[i] do
        begin
          if Not Falha then
          begin
            SqlQuery.DefinirParametro(Msg,'NUMEROPEDIDO',Owner.Numero, ftInteger);
            SqlQuery.DefinirParametro(Msg,'PRODUTO',Produto.Codigo, ftInteger);
            SqlQuery.DefinirParametro(Msg,'QUANTIDADE',Arredondar(Quantidade),ftFloat);
            SqlQuery.DefinirParametro(Msg,'UNITARIO',Arredondar(Unitario),ftFloat);
            SqlQuery.DefinirParametro(Msg,'TOTAL',Total,ftFloat);
            SqlQuery.DefinirParametro(Msg,'ID',id, ftInteger);
          end;
        end;

        if Not Falha then
        begin
          Falha := (SqlQuery.ExecSQL <= ZEROREGISTRO);
        end;

        if Falha then
        begin
          raise EExecucaoScriptSql.Create('Falha ao tentar atualizar pedido.');
        end;
      end;
    Except
      On E: Exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    End;
  Finally
    Result := Not Falha;
  End;
end;

function TPedidoDAO.Inserir: Boolean;
Var
  Falha: Boolean;
  NumeroPv: Integer;
begin
  Falha := False;
  Try
    NumeroPv := ObterProximoNumeroPedido;
    Owner.Numero := NumeroPv;
    FAtivarTransacao := True;
    IniciarTransacao;
    Falha := Not ExecInsert;
    if Not Falha then
    begin
      Falha := Not ExecInserirItens;
    end;
  Finally
    if Falha then
      Owner.Numero := -1;   //voltando o pedido para numeração nula
    EncerrarTransacao(Falha);
    FAtivarTransacao := False;
    Result := (Falha = False);
  End;
end;

function TPedidoDAO.ExecInserirItens: Boolean;
{$Region 'parametros da query'}
CONST
  PRM_NUMERO: String = 'NUMEROPEDIDO';
  PRM_PRODUTO: STring = 'CODIGOPRODUTO';
  PRM_QUANTIDADE: String = 'QUANTIDADE';
  PRM_UNITARIO: String = 'UNITARIO';
  PRM_TOTAL: String = 'TOTAL';
{$Endregion}
Var
  Sql: String;
  Falha: Boolean;
  Msg: String;
  i: Integer;
  Erros: SmallInt;
  NumeroPedido: integer;
begin
  NumeroPedido:= Owner.Numero;
  Erros := 0;
  Falha := False;
  Sql := EmptyStr;
  Sql := SqlInsertItem;
  Try
    Try
      for I := 0 to Owner.ListaItens.Count -1 do
      begin
        if Owner.ListaItens[i].id > 0 then
          Continue;

        Falha := Not AtribuirInstrucaoSegSql(Sql);
        if Not Falha then
        begin
          With Owner.ListaItens[i] do
          begin
            //atribuiindo parâmetros
            SqlQuery.DefinirParametro(Msg,PRM_NUMERO,NumeroPedido,ftInteger);
            SqlQuery.DefinirParametro(Msg,PRM_PRODUTO,Produto.Codigo,ftInteger);
            SqlQuery.DefinirParametro(Msg,PRM_QUANTIDADE,Arredondar(Quantidade),ftFloat);
            SqlQuery.DefinirParametro(Msg,PRM_UNITARIO,Arredondar(Unitario),ftFloat);
            SqlQuery.DefinirParametro(Msg,PRM_TOTAL,Arredondar(Total),ftFloat);
          end;
        end;

        if Not Falha then
        begin
          Falha := (SqlQuery.ExecSQL <= ZEROREGISTRO);
        end;

        if Falha then
        begin
           Erros := Erros + 1;
        end;
      end;

      Falha := (Erros <> ZEROREGISTRO);
      if Falha then
        raise  EExecucaoScriptSql.Create('Não foi possível inserir o pedido.');
    Except
      On E: Exception do
      begin
        Falha := True;
        Erros := Erros +1;
        TratamentoExcecao(e);
      end;
    end;
  Finally
    LstIParametros.Clear;
    if SqlQuery.Active then
      SqlQuery.Close;
    Result := Not Falha;
  End;
end;

function TPedidoDAO.ObterProximoNumeroPedido: Integer;
CONST
  SQL: String = 'SELECT (MAX(A.NUMERO)+1) AS PROXIMO FROM PEDIDOS_DADOS_GERAIS A';
  CPO_PROXIMONUMERO: Integer = 0;
Var
  Falha: Boolean;
  Ret: Integer;
begin
  Ret := -1;
  Try
    Falha :=  AtribuirInstrucaoSegSql(SQL);
    Falha := ExcecutarConsulta(procedure(Out Retorno: Boolean)
                               begin
                                  SqlQuery.Open;

                                  if SqlQuery.Active then
                                  begin
                                    Ret := SqlQuery.Fields[CPO_PROXIMONUMERO].AsInteger;
                                  end
                                  else begin
                                    raise EFalhaPesquisa.Create('Falha ao obter próximo número do pedido.');
                                  end;
                               end
                              );

  Finally
    Result := Ret;
  End;
end;

function TPedidoDAO.PequisarPedidos(out LstPedido: TPedidos): Boolean;
{$Region 'ìndices dos campos'}
Const
  CPO_NUMERO: Integer = 0;
  CPO_EMISSAO: Integer = 1;
  CPO_CLIENTE: Integer = 2;
  CPO_NOMECLIENTE: Integer = 3;
  CPO_CIDADE: Integer = 4;
  CPO_UF: Integer = 5;
  CPO_VALORTOTAL: Integer = 6;
  CPO_PRODID: Integer = 7;
  CPO_PRODCODIGO: Integer = 8;
  CPO_PRODDESCRICAO: Integer = 9;
  CPO_PRODUNITARIO: Integer = 10;
  CPO_PRODQUANTIDADE: Integer = 11;
{$Endregion}
{$Region 'Métodos locais'}
procedure Popular(var Lista:TPedidos);
Var
  Pedido: TPedido;
  ItemMesmoPedido: Boolean;
begin
  SqlQuery.First;
  while Not SqlQuery.Eof do
  begin
    Pedido := TPedido.Create;
    Pedido.Numero := SqlQuery.Fields[CPO_NUMERO].AsInteger;
    Pedido.Data := SqlQuery.Fields[CPO_EMISSAO].AsDateTime;
    Pedido.Cliente.Codigo := SqlQuery.Fields[CPO_CLIENTE].AsInteger;
    Pedido.Cliente.Nome := SqlQuery.Fields[CPO_NOMECLIENTE].AsString;
    Pedido.Cliente.Cidade := SqlQuery.Fields[CPO_CIDADE].AsString;
    Pedido.Cliente.UF := SqlQuery.Fields[CPO_UF].AsString;

    Repeat
      Pedido.ReceberItem(SqlQuery.Fields[CPO_PRODID].AsInteger,
                         SqlQuery.Fields[CPO_PRODCODIGO].AsInteger,
                         SqlQuery.Fields[CPO_PRODDESCRICAO].AsString,
                         SqlQuery.Fields[CPO_PRODQUANTIDADE].AsFloat,
                         SqlQuery.Fields[CPO_PRODUNITARIO].AsFloat);


      SqlQuery.Next;
      ItemMesmoPedido := (Not SqlQuery.Eof) and (SqlQuery.Fields[CPO_NUMERO].AsInteger = Pedido.Numero);
    Until (Not ItemMesmoPedido);
    Lista.Add(Pedido);
  end;
end;
{$Endregion}
Var
  Sql: String;
  Falha: Boolean;
  Msg: String;
begin
  Sql := SqlSelect;
  Falha := False;
  Try
    Falha := Not AtribuirInstrucaoSegSql(Sql);
    Try
      if Not Falha then
      begin
        SqlQuery.Open;
        if SqlQuery.Active then
        begin
          if SqlQuery.Active then
          begin
            if Not SqlQuery.IsEmpty then
              Popular(LstPedido);
          end
          else begin
            raise ERegistroNaoLocalizado.Create('Não foram encontrados dados.');
          end;
        end
        else begin
          raise  EFalhaPesquisa.Create('Falha ao executar pesquisa.');
        end;
      end;
    Except
      On E: exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    end;
  Finally
    if SqlQuery.Active then
      SqlQuery.Close;
    Result := Not Falha;
  End;
end;

function TPedidoDAO.Recuperar: Boolean;
begin
  Result := ExecSelect;
end;

function TPedidoDAO.SqlDelete: String;
begin
  Result := 'DELETE FROM PEDIDOS_DADOS_GERAIS WHERE NUMERO = :NUMERO';
end;

function TPedidoDAO.SqlDeleteItem: String;
begin
  Result := 'DELETE FROM PEDIDOS_PRODUTOS WHERE ID = :ID AND NUMEROPEDIDO = :NUMEROPEDIDO';
end;

function TPedidoDAO.SqlDeleteItens: String;
begin
  Result := 'DELETE FROM PEDIDOS_PRODUTOS WHERE NUMEROPEDIDO = :NUMEROPEDIDO';
end;

function TPedidoDAO.SqlInsert: String;
Var
  Sql: TStringBuilder;
  Ret: String;
begin
  Ret := EmptyStr;
  Try
    Sql := TStringBuilder.Create;
    Sql.Append('INSERT INTO PEDIDOS_DADOS_GERAIS (NUMERO, CODIGO_CLI, EMISSAO, VALORTOTAL) VALUES (')
       .Append(' :NUMERO,')
       .Append(' :CLIENTE,')
       .Append(' STR_TO_DATE(:EMISSAO, ''%d/%m/%Y''),')
       .Append(' :TOTAL)');
    Ret := Sql.ToString;
  Finally
    if Assigned(Sql) then
      Sql.Free;
    Result :=  Ret;
  End;
end;

function TPedidoDAO.SqlInsertItem: String;
Var
  Sql: TStringBuilder;
  Ret: String;
begin
  Ret := EmptyStr;
  Try
    Sql := TStringBuilder.Create;
    Sql.Append('INSERT INTO PEDIDOS_PRODUTOS')
       .Append(' (NUMEROPEDIDO, CODIGOPRODUTO, QUANTIDADE, VALORUNITARIO, VALORTOTAL)')
       .Append(' VALUES')
       .Append(' (:NUMEROPEDIDO, :CODIGOPRODUTO, :QUANTIDADE, :UNITARIO, :TOTAL)');
    Ret := Sql.ToString;
  Finally
    if Assigned(Sql) then
      Sql.Free;
    Result :=  Ret;
  End;
end;

function TPedidoDAO.SqlSelect: String;
Var
  Sql: TStringBuilder;
  Ret: String;
begin
  Try
    Sql := TStringBuilder.Create;
    Sql.Append('SELECT')
       .Append(' NUMERO, EMISSAO, CLIENTE, NOMECLIENTE, CIDADE, UF, VALORTOTAL,')
       .Append(' PRODID, PRODCODIGO, PRODDESCRICAO, PRODUNITARIO, PRODQUANTIDADE')
       .Append(' FROM VW_PEDIDO');
    Ret := Sql.ToString;
  Finally
    if Assigned(Sql) then
      Sql.Free;
    Result := Ret;
  End;
end;

function TPedidoDAO.SqlSqlectPedido: String;
begin
  Result := SqlSelect +' WHERE NUMERO = :NUMERO';
end;

function TPedidoDAO.SqlUpDate: String;
Var
  Sql: TStringBuilder;
  Ret: String;
begin
  Try
    //RN permite alterar apenas o total. Os demais campos foram deixadoa para se um dia for necessário atualizar os demais.
    //A validação será feita no objeto.
    Sql := TStringBuilder.Create;
    Sql.Append('UPDATE PEDIDOS_DADOS_GERAIS SET')
       .Append(' NUMERO = :NUMERO,')
       .Append(' CODIGO_CLI = :CODIGO_CLI,')
       .Append(' EMISSAO = STR_TO_DATE(:EMISSAO, ''%d/%m/%Y''),')
       .Append(' VALORTOTAL = :TOTAL')
       .Append(' WHERE NUMERO = :NUMORIGEM');
    Ret := Sql.ToString;
  Finally
    if Assigned(Sql) then
      Sql.Free;
    Result := Ret;
  End;
end;

function TPedidoDAO.SqlUpdateItem: String;
{UPDATE PEDIDOS_PRODUTOS SET NUMEROPEDIDO = :NUMEROPEDIDO,
                             CODIGOPRODUTO = :PRODUTO,
                             QUANTIDADE = :QUANTIDADE,
                             VALORUNITARIO = :UNITARIO,
                             VALORTOTAL = :TOTAL
WHERE    ID = :ID
}
Var
  Sql: TStringBuilder;
  Ret: String;
begin
  Try
    Sql := TStringBuilder.Create;
    Sql.Append('UPDATE PEDIDOS_PRODUTOS SET')
       .Append(' NUMEROPEDIDO = :NUMEROPEDIDO,')
       .Append(' CODIGOPRODUTO = :PRODUTO,')
       .Append(' QUANTIDADE = :QUANTIDADE,')
       .Append(' VALORUNITARIO = :UNITARIO,')
       .Append(' VALORTOTAL = :TOTAL')
       .Append(' WHERE').Append(' ID = :ID');
    Ret := Sql.ToString;
  Finally
    if Assigned(Sql) then
      Sql.Free;
    Result := Ret;
  End;
end;

function TPedidoDAO.Update: Boolean;
Var
  Falha: Boolean;
  TemLixo: Boolean;
begin
  TemLixo := Owner.ListaExclusao.Count > 0;
  Falha := False;
  Try
    FAtivarTransacao := True;
    IniciarTransacao;
    if TemLixo then
    begin
      Falha := Not ExcluirItensLixeira;
    end;

    if Not Falha then
    begin
      Falha := Not ExecUpdate;
    end;

    if Not Falha then
    begin
      Falha := Not ExecUpdateItens;
    end;

    if Not Falha then
    begin
      Falha := Not ExecInserirItens;
    end;
    Try
      if Falha then
        raise EFilaPedidos.Create('Não foi possível atualizar o pedido. A operação será cancelada.');
    Except
      On E: Exception do
      begin
        Falha := True;
        TratamentoExcecao(e);
      end;
    End;

  Finally
    if SqlQuery.Active then
      SqlQuery.Close;
    EncerrarTransacao(Falha);
    if (Not Falha) and (TemLixo) then
    begin
      Owner.ListaExclusao.Clear;
      Owner.ListaExclusao.TrimExcess;
    end;

    FAtivarTransacao := False;
    Result := Not False;
  End;

end;

end.
