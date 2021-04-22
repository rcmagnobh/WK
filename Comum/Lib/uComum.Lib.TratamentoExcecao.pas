unit uComum.Lib.TratamentoExcecao;

interface

uses
  System.SysUtils, uComum.Lib.Lib;

Type
{$Region 'Exce��es gerais'}
  EValorInvalido = class(Exception);
{$Endregion}
{$Region 'Exce��es DAO/Banco de dados'}
  EFalhaPesquisa = class(Exception);
  EDAOFalhaSql = class(Exception);
  ERegistroNaoLocalizado = class(Exception);
  EParametroNaoLocalizado = class(Exception);
  EExecucaoScriptSql = class(Exception);
{$Endregion}
{$Region 'Tipos de exce��es da fila'}
  EFilaPedidos = class(Exception);
  EFilaVazia = class(EFilaPedidos);
  ELimiteFila = class(EFilaPedidos);
  EFilaPedidosSituacao = class(EFilaPedidos);
{$EndRegion}

procedure TratamentoExcecao(e: Exception);
procedure TratamentoExcecaoFilaPedidos(EFila: EFilaPedidos);

implementation

uses
  Vcl.Dialogs, Winapi.Windows;

procedure TratamentoExcecaoFilaPedidos(EFila: EFilaPedidos);
Var
  Titulo: String;
  Msg: String;
  Icone: Cardinal;
begin
  Icone := MB_ICONINFORMATION;
  if (EFila is EFilaPedidosSituacao) then
  begin
    Titulo := 'Falha de fila de pedidos';
    Icone := MB_ICONINFORMATION;
    Msg := 'A situa��o atual n�o permite a opera��o.'
  end
  else if (EFila is EFilaVazia) then
  begin
    Titulo := 'Fila vazia';
    Icone := MB_ICONINFORMATION;
    Msg := 'Opera��o n�o permitida.'
  end
  else if (EFila is ELimiteFila) then
  begin
    Titulo := 'Limite da fila';
    Icone := MB_ICONINFORMATION;
    Msg := 'Opera��o n�o permitida porque excedeu os limites da fila de pedidos.'
  end
  else
  begin
    Titulo := 'Exce��o na Fila de Pedidos';
    Msg := 'Exce��o n�o identificada. ' + EFila.Message;
  end;
  Msg := Msg + sLineBreak+EFila.Message+sLineBreak+EFila.ClassName;
  ExibirMensagem(Titulo, Msg, Icone);
end;

procedure TratamentoExcecao(e: Exception);
Var
  Titulo: String;
  Msg: String;
  Icone: Cardinal;
begin
  Icone := MB_ICONINFORMATION;
  if (e is EFilaPedidos) then
  begin
    TratamentoExcecaoFilaPedidos(EFilaPedidos(e));
  end
  else if (e is EFalhaPesquisa) then
  begin
    Titulo := 'Falha';
    Icone := MB_ICONINFORMATION;
    Msg := 'Ocorreu uma falhao ao executar sua pesquisa.'
  end
  else if (e is EValorInvalido) then
  begin
    Titulo := 'Informa��o';
    Icone := MB_ICONINFORMATION;
    Msg := 'Valor inserido � inv�lido.';
  end
  else if (e is ERegistroNaoLocalizado) then
  begin
    Titulo := 'Informa��o';
    Icone := MB_ICONINFORMATION;
    Msg := 'Registro n�o localizado.';
  end
  else if (e is EDAOFalhaSql) then
  begin
    Titulo := 'Falha';
    Icone := MB_ICONINFORMATION;
    Msg := 'Falha de instru��o SQL. Contate o Administrador do Sistema.';
  end
  else if (e is EExecucaoScriptSql) then
  begin
    Titulo := 'Falha';
    Icone := MB_ICONINFORMATION;
    Msg := 'Falha de instru��o SQL. Contate o Administrador do Sistema.';
  end
  else  begin
    Titulo := 'Exce��o';
    Icone := MB_ICONERROR;
    Msg := 'Exce��o n�o identificada. ' + e.Message;
  end;
  Msg := Msg + sLineBreak+e.Message;
  ExibirMensagem(Titulo, Msg, Icone);
end;
end.
