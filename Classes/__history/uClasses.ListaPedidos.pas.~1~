unit uClasses.ListaPedidos;

interface

uses
  uClasses.Pedido,
  uComum.Types.Types,
  uComum.Types.Interfaces,
  uClasses.Interfaces;

Type

{$SCOPEDENUMS ON}
//tipos de exceções comuns à fila de pedidos
  TExcecaoFila = (Vazia, Navegacao, SituacaoFila, ModoEdicao, NaoModoEdicao, LimiteFila);
{$SCOPEDENUMS OFF}

{
Tipos relacionados a estado e navecação pela lista
  TAcaoLista > TSituacaoListaPedidos
  TAçãoLista especifica o que a lista pode fazer.  TSituacaoListaPedidos é faixa/subfaixa de TAcaoLista***
  TNavegacaoFila
}

{$SCOPEDENUMS ON}
  TAcaoLista = (Vazia, Navegacao, Insercao, Edicao, Salvar, Cancelar);
{$SCOPEDENUMS OFF}

{$SCOPEDENUMS ON}
  TSituacaoListaPedidos = TAcaoLista.Vazia..TAcaoLista.Edicao;
{$SCOPEDENUMS OFF}

{$SCOPEDENUMS ON}
  TNavegacaoListaPedidos = (Primeiro, Anterior, Proximo, Ultimo);
{$SCOPEDENUMS OFF}
  TSetStatus = set of TSituacaoListaPedidos;

Const
  TMODOEDICAO = [TAcaoLista.Insercao..TAcaoLista.Edicao];
  TSTATUSPERMITENAVEGAR = [TAcaoLista.Navegacao];
  TSTATUSPERMITEATUALIZAR = [TAcaoLista.Navegacao];
  TSTATUSPERMITERECUPERAR = [TAcaoLista.Vazia..TAcaoLista.Navegacao];
  TSTATUSPERMITEAPAGAR = [TAcaoLista.Navegacao];
  TSTATUSPERMITEINCLUIR = [TAcaoLista.Vazia..TAcaoLista.Navegacao];
  TSTATUSPERMITECANCELAR = [TAcaoLista.Insercao..TAcaoLista.Edicao];
  TSTATUSPERMITESALVAR = [TAcaoLista.Insercao, TAcaoLista.Edicao];
  TSITUACAOPERMITIDAPARAVAZIO = [TAcaoLista.Insercao];
  TSITUACAOPERMITIDAPARANAVEGAR = [TAcaoLista.Navegacao..TAcaoLista.Edicao];
  TSITUACAOPERMITIDAPARAEDITAR = [TAcaoLista.Salvar..TAcaoLista.Cancelar];
  TSITUACAOPERMITIDAPARAINSERCAO = [TAcaoLista.Salvar..TAcaoLista.Cancelar];

Type
  TListaPedidos = class;
  TEnviarPedido = procedure(oPedido: TPedido) of object;

  TListaPedidos = class(TInterfacedObject, ISujeito)
  Private
    FObjPedidoDestaque: TPedido;
    FPedidos: TPedidos;
    FEventoEnviarPedido: TEnviarPedido;
    FPedidoDestaque: Integer;
    FStatus: TSituacaoListaPedidos;
    FListaObservadores: TListaObervadores;
    function GetPedido(Index: Integer): TPedido;
    procedure SetPedido(Index: Integer; const Value: TPedido);
    function IndiceValido(Indice: Integer): Boolean;
    function GetStatus: TSituacaoListaPedidos;
    function AvaliarStatus: TSituacaoListaPedidos;
    procedure SetStatus(Const Value: TSituacaoListaPedidos);
{$Region 'Métodos para tratamento de exceção - privados'}
    //Métodos de exceção
    function DefinirMsgExcecao(Const Msg, MsgPadrao: String):String;
    procedure CriarExcecaoFila(Const TipoExcecao: TExcecaoFila; MsgCustomizada: String = '');
{$Endregion}
  Public
{$Region 'Construtores e Destrutores públicos'}
    Constructor Create;
    Destructor Destroy; override;
{$Endregion}
{$Region 'Propertys'}
    property Pedidos: TPedidos Read FPedidos Write FPedidos;
    property Status: TSituacaoListaPedidos Read GetStatus Default TAcaoLista.Vazia;
    property Pedido[Index: Integer]: TPedido read GetPedido write SetPedido;
    property EventoEnviarPedido: TEnviarPedido Read FEventoEnviarPedido
      Write FEventoEnviarPedido;
{$Endregion}
{$Region 'Métdos Gerais - públicos'}
    function Adicionar(aPedido: TPedido): Boolean;
    function NovoPedido: TPedido;
    function Remover(Indice: Integer): TPedido;
    function ExcluirPedido(aPedido: TPedido): Boolean;
    function RemoverEExcluir(Indice: Integer): Boolean;
    function ObterIndice(aPedido: TPedido): Integer; overload;
    function ObterIndice(NumeroPedido: Integer): Integer; overload;
    function GetPedidoDestaque: TPedido;
    function Navegar(Sentido: TNavegacaoListaPedidos): Boolean;
    function PermiteAcaoCrud(Acao: TOpCrud):Boolean;
    function ConsultarSituacoesPermitidasParaStatusAtual: TSetStatus;
    procedure FocarPedido(Indice:Integer);
    procedure SetPedidoDestaque(Const Value: TPedido);
    procedure Cancelar;
    procedure Editar;
    function Salvar:Boolean;
    function RecuperarTodosPedidos:Boolean;
    function Apagar:Boolean;
{$EndRegion}
{$Region 'Métodos para tratamento de exceção - públicos'}
    //Métodos de exceção
    procedure CriarExcecaoFilaVazia(MsgCustomizada: String = '');
    procedure CriarExcecaoFilaNaoModoEdicao(MsgCustomizada: String = '');
    procedure CriarExcecaoFilaModoEdicao(MsgCustomizada: String = '');
    procedure CriarExcecaoFilaSentidoNavegacao(Sentido: TNavegacaoListaPedidos);
    procedure CriarExcecaoFilaPedidosSituacao(MsgCustomizada: String = '');
    procedure CriarExcecaoFilaPedidosApagar(MsgCustomizada: String = '');
    procedure CriarExcecaoEdicaoNaoPermitida(MsgCustomizada: String = '');
    procedure AdicionarObservador(const Value: IObservador);
    procedure EmitirNotificacao(const Notificacao: INotificacaoLista);
    procedure RemoverObservador(Const Value: IObservador);
{$Endregion}
    Const
      NUMEROPEDIDONOVO: ShortInt = -1;
      PEDIDONULO: ShortInt = -1;
  end;

implementation

uses
  System.SysUtils,
  uComum.Lib.TratamentoExcecao, uClasses.NotificacaoLista;

{ TListaPedidos }

constructor TListaPedidos.Create;
begin
  FPedidos := TPedidos.Create;
  FListaObservadores := TListaObervadores.Create;
end;

destructor TListaPedidos.Destroy;
begin
  FPedidos.Clear;
  FPedidos.Free;
  FListaObservadores.Clear;
  FListaObservadores.Free;
  inherited;
end;

function TListaPedidos.PermiteAcaoCrud(Acao: TOpCrud): Boolean;
Var
  StatusFila: TSituacaoListaPedidos;
begin
  StatusFila := GetStatus;
  Try
    case Acao of
      TOpCrud.Criar:
        Begin
          If Not (StatusFila in TSTATUSPERMITEINCLUIR) then
          begin
            CriarExcecaoFilaModoEdicao;
          end;
        end;
      TOpCrud.Recuperar:
        Begin
          If Not (StatusFila in TSTATUSPERMITERECUPERAR) then
          begin
            CriarExcecaoFilaModoEdicao;
          end;
        End ;
      TOpCrud.Atualizar:
        begin
          If Not (StatusFila in TSTATUSPERMITEATUALIZAR) then
          begin
            if StatusFila = TAcaoLista.Vazia then
              CriarExcecaoFilaVazia
            else
              CriarExcecaoFilaPedidosSituacao;
          end;
        end;
      TOpCrud.Apagar:
        Begin
          if Not (StatusFila in TSTATUSPERMITEAPAGAR) then
          begin
            if StatusFila = TAcaoLista.Vazia then
              CriarExcecaoFilaVazia('Não há registro para remover.')
            else if StatusFila in TMODOEDICAO then
              CriarExcecaoFilaModoEdicao;

          {DONE -oDaniel -cAplicar: Criar exceção para modo apagar}
          end;
        end;
    end;
    Result := True;
  Except
    On E: Exception do
    begin
      TratamentoExcecaoFilaPedidos(EFilaPedidosSituacao(e));
      Result := False;
    end;
  End;
end;

function TListaPedidos.Apagar:Boolean;
Var
  Indice: Integer;

begin
  Indice := ObterIndice(FObjPedidoDestaque);
  if  RemoverEExcluir(Indice) then
  begin
    if FPedidos.Count > 0 then
      SetPedidoDestaque(FPedidos[0])
    else
      SetPedidoDestaque(nil);
    Result := True;
  end
  else begin
    Result := False;
  end;
end;

function TListaPedidos.AvaliarStatus: TSituacaoListaPedidos;
Var
  Ret: TSituacaoListaPedidos;
  Pedido: TPedido;
begin
  { 1º avaliar se lista está vazia;
    2º avaliar se lista está em edição;
    3º avaliar se inserção (número = -1); e
    4º navegação }
  Ret := FStatus;
  if FPedidos.Count = 0 then
  begin
    Ret := TAcaoLista.Vazia;
  end
  else
  begin
    // avaliar se não está marcado com edição, se tiver, permanece o estado
    if Not(Ret = TAcaoLista.Edicao) then
    begin
      Pedido := Self.GetPedidoDestaque;
      if (Pedido.Numero = -1) then
      begin
        // Inserção = PedidoDestaque tiver número igual a -1
        Ret := TAcaoLista.Insercao;
      end
      else
      begin
        Ret := TAcaoLista.Navegacao;
      end;
    end;
  end;
  Result := Ret;
end;

procedure TListaPedidos.Cancelar;
Var
  Status: TSituacaoListaPedidos;
begin
  Status := GetStatus;
  case Status of
    TAcaoLista.Insercao:
      begin
        FPedidos.Remove(Pedido[FPedidoDestaque]);
        if FPedidos.Count > 0 then
          SetPedidoDestaque(FPedidos.Last)
        else
          SetPedidoDestaque(nil);
        SetStatus(AvaliarStatus);
        EventoEnviarPedido(Pedido[FPedidoDestaque]);
      end;
    TAcaoLista.Edicao:
      begin
        SetStatus(TAcaoLista.Navegacao);
        FObjPedidoDestaque.Recuperar;
        EventoEnviarPedido(FObjPedidoDestaque);
        { DONE -oDaniel -cDesenvolver:criar médoto para buscar um pedido }
      end;
  end;
end;

function TListaPedidos.ConsultarSituacoesPermitidasParaStatusAtual: TSetStatus;
Var
  StatusLista: TSituacaoListaPedidos;
  Ret: TSetStatus;
begin
  StatusLista := GetStatus;
  Ret := []; //inicializando conjunto
  case StatusLista of
    TAcaoLista.Vazia: Ret := TSITUACAOPERMITIDAPARAVAZIO ;
    TAcaoLista.Navegacao: Ret := TSITUACAOPERMITIDAPARANAVEGAR;
    TAcaoLista.Insercao: Ret := TSITUACAOPERMITIDAPARAINSERCAO;
    TAcaoLista.Edicao: Ret := TSITUACAOPERMITIDAPARAEDITAR;
  end;
end;

procedure TListaPedidos.CriarExcecaoEdicaoNaoPermitida(MsgCustomizada: String);
begin

end;

procedure TListaPedidos.CriarExcecaoFila(const TipoExcecao: TExcecaoFila;
  MsgCustomizada: String);
CONST
  MFILAVAZIA: String = 'Não há registros. Insira ou localiza um pedido.';
  MSALVARCANCELAR: String = 'Salve ou cancele a operação atual.';
Var
  Msg: String;
begin
  case TipoExcecao of
    TExcecaoFila.Vazia:
      begin
        Raise EFilaVazia.Create(DefinirMsgExcecao(MsgCustomizada,MFILAVAZIA));
      end;
    TExcecaoFila.ModoEdicao:
      begin
        raise EFilaPedidosSituacao.Create(DefinirMsgExcecao(MsgCustomizada,MSALVARCANCELAR));
      end;
    TExcecaoFila.SituacaoFila:
      begin
        raise EFilaPedidosSituacao.Create(DefinirMsgExcecao(MsgCustomizada, MSALVARCANCELAR));
      end;
    TExcecaoFila.Navegacao:
      begin
        raise EFilaPedidos.Create(MsgCustomizada);
      end;
    TExcecaoFila.LimiteFila:
      begin
        raise EFilaPedidos.Create(MsgCustomizada);
      end;
  end;
end;

procedure TListaPedidos.CriarExcecaoFilaModoEdicao(MsgCustomizada: String);
begin
  CriarExcecaoFila(TExcecaoFila.ModoEdicao,MsgCustomizada);
end;

procedure TListaPedidos.CriarExcecaoFilaNaoModoEdicao(MsgCustomizada: String);
begin
  CriarExcecaoFila(TExcecaoFila.Vazia,MsgCustomizada);
end;

procedure TListaPedidos.CriarExcecaoFilaPedidosApagar(MsgCustomizada: String);
begin
  CriarExcecaoFila(TExcecaoFila.SituacaoFila,MsgCustomizada);
end;

procedure TListaPedidos.CriarExcecaoFilaPedidosSituacao(MsgCustomizada: String);
begin
  CriarExcecaoFila(TExcecaoFila.SituacaoFila,MsgCustomizada);
end;

procedure TListaPedidos.CriarExcecaoFilaSentidoNavegacao(
  Sentido: TNavegacaoListaPedidos);
CONST
  MSGPRIMEIROREG: String = 'Fila está no primeiro registro.';
  MSGULTIMOREG: String = 'Fila está no último registro.';
begin
  case Sentido of
    TNavegacaoListaPedidos.Primeiro:
      Begin
        CriarExcecaoFila(TExcecaoFila.LimiteFila,MSGPRIMEIROREG);
      end;
    TNavegacaoListaPedidos.Ultimo:
      Begin
        CriarExcecaoFila(TExcecaoFila.LimiteFila,MSGULTIMOREG)
      end ;
  end;
end;

procedure TListaPedidos.CriarExcecaoFilaVazia(MsgCustomizada: String);
begin
  CriarExcecaoFila(TExcecaoFila.Vazia,MsgCustomizada);
end;

function TListaPedidos.DefinirMsgExcecao(const Msg, MsgPadrao: String): String;
Var
  TemMsgCustomizada: Boolean;
  Ret: String;
begin
  TemMsgCustomizada := Length(Msg) > 0;
  if TemMsgCustomizada then
    Ret := Msg
  else
    Ret := MsgPadrao;
  Result := Ret;
end;

procedure TListaPedidos.Editar;
begin
  SetStatus(TAcaoLista.Edicao);
end;

function TListaPedidos.ExcluirPedido(aPedido: TPedido): Boolean;
begin
  Result := aPedido.Excluir;
end;

procedure TListaPedidos.FocarPedido(Indice: Integer);
begin
  FPedidoDestaque := Indice;
  if IndiceValido(Indice) then
    SetPedidoDestaque(FPedidos[FPedidoDestaque])
  else
    EventoEnviarPedido(Pedido[FPedidoDestaque]);
end;

function TListaPedidos.GetPedido(Index: Integer): TPedido;
Var
  Ret: TPedido;
begin
  Ret := nil;
  if IndiceValido(Index) then
    Ret := FPedidos[Index];
  Result := Ret;
end;

function TListaPedidos.GetPedidoDestaque: TPedido;
begin
  Result := FObjPedidoDestaque;
end;

function TListaPedidos.GetStatus: TSituacaoListaPedidos;
begin
  SetStatus(AvaliarStatus);
  // Avaliando situação toda vez que é verificado o status.
  Result := FStatus;
end;

function TListaPedidos.IndiceValido(Indice: Integer): Boolean;
begin
  Result := (Indice >= 0) and (Indice < FPedidos.Count);
end;

function TListaPedidos.Navegar(Sentido: TNavegacaoListaPedidos): Boolean;
Var
  Status: TSituacaoListaPedidos;
  PosInicial, PosicaoFinal, PosIntermediaria: Boolean;
  Ret: Boolean;
  IndiceDestino: Integer;
begin
{$Region 'Inicilizando variáveis'}
  IndiceDestino := -1;
  PosInicial := FPedidoDestaque = 0;
  PosicaoFinal := FPedidoDestaque = (FPedidos.Count -1);
  PosIntermediaria := Not (PosInicial or PosicaoFinal);
  IndiceDestino := -1;
  Ret := False;
  Status := GetStatus;
{$Endregion}
  Try
{$Region 'Verificando se status permite navegação'}
    case Status of
      TAcaoLista.Vazia:
        Begin
          CriarExcecaoFilaVazia;
        End;
    else
      begin
        if Status in TMODOEDICAO then
        begin
          CriarExcecaoFilaModoEdicao;
        end;
      end;
    end;
{$Endregion}
{$Region 'Avaliando destino e navegando'}
     case Sentido of
       TNavegacaoListaPedidos.Primeiro:
        Begin
          if (PosInicial) then //primeiro pedido
          begin
            CriarExcecaoFilaSentidoNavegacao(TNavegacaoListaPedidos.Primeiro);
          end
          else begin
            IndiceDestino := 0;
          end;
        End;
       TNavegacaoListaPedidos.Anterior:
        Begin
          if Not (PosIntermediaria) then //primeiro pedido
          begin
            CriarExcecaoFilaSentidoNavegacao(TNavegacaoListaPedidos.Primeiro);
          end
          else begin
            IndiceDestino := FPedidoDestaque -1;
          end;
        End;
       TNavegacaoListaPedidos.Proximo:
        Begin
          if Not (PosIntermediaria) then //primeiro pedido
          begin
            CriarExcecaoFilaSentidoNavegacao(TNavegacaoListaPedidos.Ultimo);
          end
          else begin
            IndiceDestino := FPedidoDestaque -1;
          end;
        end;
       TNavegacaoListaPedidos.Ultimo:
        begin
          if (PosicaoFinal) then //último pedido
          begin
            CriarExcecaoFilaSentidoNavegacao(TNavegacaoListaPedidos.Ultimo);
          end
          else begin
            IndiceDestino := (FPedidos.Count -1);
          end;
        end ;
     end;
{$Endregion}
     Ret := True;
  Except
{$Region 'Exceções'}
    on E: Exception do
    begin
      if e is EFilaPedidosSituacao then
        TratamentoExcecaoFilaPedidos(EFilaPedidosSituacao(e))
      else if e is EFilaVazia then
        TratamentoExcecaoFilaPedidos(EFilaVazia(e))
      else if e is ELimiteFila then
        TratamentoExcecaoFilaPedidos(ELimiteFila(e))
      else
        TratamentoExcecao(e);
      Exit(Ret);
    end;
{$Endregion}
  End;
  Result := Ret;
  FocarPedido(IndiceDestino);
end;

function TListaPedidos.NovoPedido: TPedido;
Var
  aPedido: TPedido;
begin
  aPedido := TPedido.Create;
  aPedido.Numero := NUMEROPEDIDONOVO;
  FObjPedidoDestaque := aPedido;
  FPedidos.Add(aPedido);
  FPedidoDestaque := ObterIndice(aPedido);
  EventoEnviarPedido(aPedido);
end;

function TListaPedidos.ObterIndice(NumeroPedido: Integer): Integer;
Var
  I, Ret: Integer;
  Encontrado: Boolean;
begin
  Ret := -1;
  for I := 0 to FPedidos.Count - 1 do
  begin
    Encontrado := FPedidos[I].Numero = NumeroPedido;
    if Encontrado then
    begin
      Ret := I;
      Break;
    end;
  end;
  Result := Ret;
end;

function TListaPedidos.RecuperarTodosPedidos: Boolean;
begin
  FPedidos.Clear;
  Result := TPedido.RecuperarTodosPedidos(FPedidos);
  FPedidos.TrimExcess;
  SetPedidoDestaque(FPedidos[0]);
end;

function TListaPedidos.Remover(Indice: Integer): TPedido;
Var
  Ret: TPedido;
begin
  Ret := nil;
  Ret := GetPedido(Indice);
  if Not Assigned(Ret) then
  begin
    Exit(Ret);
  end;
  Result := FPedidos.Extract(Ret);
  FPedidos.TrimExcess;
end;

function TListaPedidos.RemoverEExcluir(Indice: Integer): Boolean;
Var
  Ret: Boolean;
  Pedido: TPedido;
begin
  Try
    Ret := False;
    Pedido := Pedidos[Indice];

    if Pedido.Excluir then
    begin
      Ret := True;
      Pedido := Remover(Indice);
    end;
  Finally
    if Assigned(Pedido) then
      Pedido.Free;
    Result := Ret;
  End;
end;

procedure TListaPedidos.AdicionarObservador(const Value: IObservador);
begin
  if FListaObservadores.IndexOf(Value) = -1 then
    FListaObservadores.Add(Value);
end;
procedure TListaPedidos.EmitirNotificacao(const Notificacao: INotificacaoLista);
Var
  aObservador: IObservador;
begin
  for aObservador in FListaObservadores do
  begin
    aObservador.ReceberNoficicacao(Notificacao);
  end;
end;
procedure TListaPedidos.RemoverObservador(Const Value: IObservador);
Var
  Indice: Integer;
begin
  Indice := FListaObservadores.IndexOf(Value);
  if (Indice >= 0) then
    FListaObservadores.Remove(Value);
end;

function TListaPedidos.Salvar:Boolean;
Var
  Ret: Boolean;
  PedidoAtual: Integer;
  Status: TSituacaoListaPedidos;
begin
  Status := GetStatus;
  Ret := FObjPedidoDestaque.Salvar;
  if Ret then
    SetStatus(TAcaoLista.Navegacao)
  else
    SetStatus(Status);
{DONE -oDaniel -cListaPedido: implementar método para Salvar}
  Result  := Ret;
end;

procedure TListaPedidos.SetPedido(Index: Integer; const Value: TPedido);
begin
  if IndiceValido(Index) then
    FPedidos[Index] := Value;
end;

procedure TListaPedidos.SetPedidoDestaque(const Value: TPedido);
begin
  FObjPedidoDestaque := Value;
  FPedidoDestaque := ObterIndice(Value);
  FEventoEnviarPedido(Value);
end;

procedure TListaPedidos.SetStatus(const Value: TSituacaoListaPedidos);
Var
  Notificacao: INotificacaoLista;
begin
  FStatus := Value;
  Notificacao := TNotificacaoLista.Create;
  TNotificacaoLista(Notificacao).SetStatus(FStatus);
  TNotificacaoLista(Notificacao).SetMsg('');
  Self.EmitirNotificacao(Notificacao);
end;

function TListaPedidos.ObterIndice(aPedido: TPedido): Integer;
begin
  Result := FPedidos.IndexOf(aPedido);
end;

function TListaPedidos.Adicionar(aPedido: TPedido): Boolean;
Var
  Incluir: Boolean;
begin
  Incluir := FPedidos.IndexOf(aPedido) = -1;
  if Incluir then
    FPedidos.Add(aPedido);
  Result := Incluir;
end;

end.
