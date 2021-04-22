unit uClasses.Interfaces;

interface

Type
  //prototipagem
  INotificacaoLista = Interface;
  IObservador = Interface;
  ISujeito = Interface;

  //Interfaces
  INotificacaoLista = Interface
  ['{1E36CC54-B36D-4442-B52D-22F33262B9E0}']
    function GetMensagem: String;
    function GetOrdSituacao: SmallInt;
  End;

  IObservador = Interface
  ['{99185040-8F43-4439-9F2B-1801BD40926A}']
    procedure ReceberNoficicacao(Const Value: INotificacaoLista);
  End;

  ISujeito = Interface
  ['{98C146D8-8270-4854-8271-D671554D25C3}']
    procedure AdicionarObservador(Const Value: IObservador);
    procedure RemoverObservador(Const Value: IObservador);
    procedure EmitirNotificacao(Const Notificacao: INotificacaoLista);
  End;



implementation

end.
