unit uClasses.DAO.ConexaoDB.DMConexaoDB;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Data.DBXMySQL,
  Data.SqlExpr, Data.FMTBcd;

type
  TDMConexaoDB = class(TDataModule)
    SQLConnection1: TSQLConnection;
  private
    { Private declarations }
  public
    function Conectar(Habilitar: Boolean): Boolean;
    function GetConnection: TSQLConnection;
    function Conectado: Boolean;
    class Function New(Out Sucesso: Boolean): TDMConexaoDB;
    { Public declarations }
  end;

var
  DMConexaoDB: TDMConexaoDB;

implementation
uses
  uComum.Lib.TratamentoExcecao, Vcl.Dialogs;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDataModule1 }

function TDMConexaoDB.Conectado: Boolean;
begin
  Result := Self.SQLConnection1.Connected;
end;

function TDMConexaoDB.Conectar(Habilitar: Boolean): Boolean;
begin
  Try
    Try
      SQLConnection1.Connected := Habilitar;
    Except
      On e: Exception do
      begin
        TratamentoExcecao(e);
      end;
    End;
  Finally
    Result := SQLConnection1.Connected;
  End;
end;

function TDMConexaoDB.GetConnection: TSQLConnection;
begin
  Result := SQLConnection1;
end;

class function TDMConexaoDB.New(out Sucesso: Boolean): TDMConexaoDB;
Var
  Ret: TDMConexaoDB;
begin
  Sucesso := False;
  Try
    Try
      Ret := TDMConexaoDB.Create(nil);
      Sucesso := Ret.Conectar(True);
    Except
      on E: Exception do
      begin
        TratamentoExcecao(e);
      end;
    End;
  Finally
    Result := Ret;
  End;
end;

end.
