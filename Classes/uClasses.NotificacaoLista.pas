unit uClasses.NotificacaoLista;

interface

uses
  uClasses.Interfaces,
  uClasses.ListaPedidos;

Type
  TNotificacaoLista = class(TInterfacedObject, INotificacaoLista)
  Private
    FStatus: TSituacaoListaPedidos;
    FMsg: String;
  public
    procedure SetStatus(Const Value: TSituacaoListaPedidos);
    procedure SetMsg(Const Value: String);
    function GetMensagem: String;
    function GetOrdSituacao: SmallInt;
  end;

implementation

{ TNotificacaoLista }

function TNotificacaoLista.GetMensagem: String;
begin
  Result := FMsg;
end;

function TNotificacaoLista.GetOrdSituacao: SmallInt;
begin
  Result := Ord(FStatus);
end;

procedure TNotificacaoLista.SetMsg(const Value: String);
begin
  FMsg := Value;
end;

procedure TNotificacaoLista.SetStatus(const Value: TSituacaoListaPedidos);
begin
  FStatus := Value;
end;

end.
