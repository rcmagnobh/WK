unit uView.frmPesqCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,
  uClasses.Cliente, uComum.Types.Types, uView.frmBasePesquisa;

Type
{$SCOPEDENUMS ON}
  TOpcaoBuscaCliente = (Codigo, Nome);
{$SCOPEDENUMS OFF}

type
  TfrmPesqCliente = class(TfrmBasePesquisa)
    rgOp: TRadioGroup;
    cdsDadosCODIGO: TIntegerField;
    cdsDadosCIDADE: TStringField;
    cdsDadosUF: TStringField;
    cdsDadosNOME: TStringField;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FIncluirDadosTeste: Boolean;
    FEventoRetornaCliente: TRetornarCliente;
    { Private declarations }
  protected
    procedure Localizar; override;
    procedure PesquisarClientes;
    procedure InserirClienteDs(Cliente: TCliente);
  public
    property EventoRetornarCliente: TRetornarCliente Read FEventoRetornaCliente Write FEventoRetornaCliente;
    { Public declarations }
  end;

var
  frmPesqCliente: TfrmPesqCliente;

implementation

uses
  uComum.Lib.Lib,
  uHelpers.DS.HelpersDS,
  uComum.Lib.TratamentoExcecao;

Const
  NOME_CPO_CODIGO: String = 'CODIGO';
  NOME_CPO_NOME: String = 'NOME';


{$R *.dfm}
{ TfrmPesqCliente }

procedure TfrmPesqCliente.Button1Click(Sender: TObject);
Var
  acliente: TCliente;
begin
  Try
    aCliente := TCliente.Create;
    aCliente.Codigo := cdsDadosCODIGO.AsInteger;
    aCliente.Nome := cdsDadosNOME.AsString;
    aCliente.Cidade := cdsDadosCIDADE.AsString;
    aCliente.UF := cdsDadosUF.AsString;
    EventoRetornarCliente(acliente);
  Finally
    if Assigned(acliente) then
      acliente.Free;
    ModalResult := mrOk;
  End;
end;

procedure TfrmPesqCliente.FormShow(Sender: TObject);
begin
  inherited;
  PesquisarClientes;
end;

procedure TfrmPesqCliente.InserirClienteDs(Cliente: TCliente);
begin
  cdsDados.Append;
  cdsDadosCODIGO.AsInteger := Cliente.Codigo;
  cdsDadosNOME.AsString := Cliente.Nome;
  cdsDadosCIDADE.AsString := Cliente.Cidade;
  cdsDadosUF.AsString := Cliente.UF;
  cdsDados.Post;
end;

procedure TfrmPesqCliente.Localizar;
Var
  OP: TOpcaoBuscaCliente;
  ValorProcurado: String;
  iValorProducado: Integer;
  Valor: Variant;
  Continua: Boolean;
  Campo: String;
  Locate: TLocateOptions;
begin
  inherited;
  ValorProcurado := edtValorProcurado.Text;
  OP := TOpcaoBuscaCliente(rgOp.ItemIndex);
  Try
    Locate := [];
    case OP of
      TOpcaoBuscaCliente.Codigo:
        begin
          Campo := NOME_CPO_CODIGO;
          Continua := TryStrToInt(ValorProcurado, iValorProducado) and (iValorProducado > 0);
          if Continua then
            Valor := iValorProducado
          else
            Valor := ValorProcurado;
        end;
      TOpcaoBuscaCliente.Nome:
        begin
          Campo := NOME_CPO_NOME;
          Continua := Length(Trim(ValorProcurado)) > 0;
          Locate := [loPartialKey];
          Valor := ValorProcurado;
        end;
    end;
    if Continua then
    begin
      if Not cdsDados.Locate(Campo, Valor, Locate) then
      begin
        raise ERegistroNaoLocalizado.Create(Format('Não localizado o valor [%s] no campo %s',[VarToStr(Valor),
                                                                                              Campo]));
      end;
    end
    else begin
        raise EValorInvalido.Create(Format('O tipo de dado pesquisado [%s] é incompatível com tipo de dado  do campo %s',[VarToStr(Valor),
                                                                                              Campo]));

    end;
  Except
    on e: exception do
    begin
      TratamentoExcecao(e);
    end;
  end;
end;
procedure TfrmPesqCliente.PesquisarClientes;
Var
  Clientes: TClientes;
  Cliente: TCliente;
begin
  Try
    Clientes := TClientes.Create;
    if TCliente.ObterListaClientes(Clientes) then
    begin
      cdsDados.DisableControls;
      cdsDados.EmptyDataSet;
      for Cliente in Clientes do
      begin
        InserirClienteDs(cliente);
      end;
    End;
  Finally
    if Assigned(Clientes) then
      Clientes.Free;
    cdsDados.First;
    cdsDados.EnableControls;
  end;
end;

end.
