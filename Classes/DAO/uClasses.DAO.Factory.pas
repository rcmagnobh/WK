unit uClasses.DAO.Factory;

interface
uses
  uClasses.DAO.ConexaoDB.DMConexaoDB;
Type
  TFactoryDAO = class
  public
    Class function NewConexaoDB(Out Sucesso: Boolean): TDMConexaoDB;
  end;

implementation

uses
  System.SysUtils,
  uComum.Lib.TratamentoExcecao;

{ TFactoryDAO }

class function TFactoryDAO.NewConexaoDB(out Sucesso: Boolean): TDMConexaoDB;
begin
end;

end.
