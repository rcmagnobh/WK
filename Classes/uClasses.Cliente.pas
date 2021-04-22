unit uClasses.Cliente;

interface
uses
  system.Generics.Collections;
type
  TCliente = class;//prototipagem
  TRetornarCliente = procedure(oCliente: TCliente) of object;
  TClientes = TObjectList<TCliente>;
  TCliente = class
  Private
    FCodigo: Integer;
    FNome: String;
    FCidade: String;
    FUF: String;
  Public
    Property Codigo: Integer Read FCodigo Write FCodigo;
    Property Nome: String Read FNome Write FNome;
    Property Cidade: String Read FCidade Write FCidade;
    Property UF: String Read FUF Write FUF;
    Class function Pesquisar(Codigo:Integer; out oCliente: TCliente): Boolean;
    Class function ObterListaClientes(Out Lista: TClientes):Boolean;
    function Recuperar: Boolean;
  end;

implementation
uses
  uClasses.DAO.ClienteDAO;
{ TCliente }

class function TCliente.ObterListaClientes(out Lista: TClientes): Boolean;
Var
  Cliente: TCliente;
  DAO: TClienteDAO;
  Ret: Boolean;
begin
  Ret := False;
  Try
    Cliente := TCliente.Create;
    DAO := TClienteDAO.Create(Cliente);
    Ret := DAO.ObterListaClientes(Lista);
  Finally
    if Assigned(Cliente) then
      Cliente.Free;
    if Assigned(DAO) then
      DAO.Free;
    Result := Ret;
  End;
end;

class function TCliente.Pesquisar(Codigo: Integer;
  out oCliente: TCliente): Boolean;
Var
  DAO: TClienteDAO;
  Ret: Boolean;
begin
  Ret := False;
  Try
    DAO := TClienteDAO.Create(oCliente);
  Finally
    if Assigned(DAO) then
      DAO.Free;
    Result := Ret;
  End;
end;

function TCliente.Recuperar: Boolean;
Var
  DAO: TClienteDAO;
  Ret: Boolean;
begin
  Try
    DAO := TClienteDAO.Create(self);
    Ret := DAO.Recupear;
  Finally
    if Assigned(DAO) then
      DAO.Free;
    Result := Ret;
  End;
end;

end.
