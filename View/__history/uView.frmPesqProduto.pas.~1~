unit uView.frmPesqProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uView.frmBasePesquisa, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, uComum.Types.Types, uClasses.Produto;

Type
{$SCOPEDENUMS ON}
  TOpcaoBuscaProduto = (Produto, Descricao);
{$SCOPEDENUMS OFF}

type
  TfrmPesqProduto = class(TfrmBasePesquisa)
    rdOp: TRadioGroup;
    cdsDadosPRODUTO: TIntegerField;
    cdsDadosDESCRICAO: TStringField;
    cdsDadosPRECO: TFloatField;
    procedure Button1Click(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FIncluirDadosTeste: Boolean;
    FRetornarProduto: TRetornaProduto;
    procedure ConfigurarCDS; override;
    procedure PesquisarProdutos;
    procedure InserirProdutosDeLista(Lista: TListaProdutos);
    { Private declarations }
  protected
    procedure Localizar; override;
  public
    property RetornarProduto: TRetornaProduto Read FRetornarProduto Write FRetornarProduto;
    { Public declarations }
  end;

var
  frmPesqProduto: TfrmPesqProduto;

implementation

uses
  uComum.Lib.lib,
  uComum.Lib.TratamentoExcecao,
  uHelpers.DS.HelpersDS;

Const
  NOME_CPO_PRODUTO: String = 'PRODUTO';
  NOME_CPO_DESCRICAO: String = 'DESCRICAO';
  NOME_CPO_PRECO: String = 'PRECO';

{$R *.dfm}

procedure TfrmPesqProduto.btnLocalizarClick(Sender: TObject);
begin
  inherited;
  Localizar;
end;

procedure TfrmPesqProduto.Button1Click(Sender: TObject);
Var
  aProduto: TProduto;
begin
  inherited;
  Try
    aProduto := TProduto.Create;
    aProduto.Codigo := cdsDadosPRODUTO.AsInteger;
    aProduto.Descricao := cdsDadosDESCRICAO.AsString;
    aProduto.Preco := cdsDadosPRECO.AsFloat;
    RetornarProduto(aProduto);
  Finally
    if Assigned(aProduto) then
      FreeAndNil(aProduto);
    ModalResult := mrOk
  end;
end;

procedure TfrmPesqProduto.ConfigurarCDS;
begin
  inherited;
end;

procedure TfrmPesqProduto.FormShow(Sender: TObject);
begin
  inherited;
  PesquisarProdutos;
end;

procedure TfrmPesqProduto.InserirProdutosDeLista(Lista: TListaProdutos);
Var
  Produto: TProduto;
  ProcInserir: TProc;
begin
{$Region 'Definição do método inserir}
  ProcInserir :=  procedure
                  begin
                    cdsDadosPRODUTO.AsInteger := Produto.Codigo;
                    cdsDadosDESCRICAO.AsString := Produto.Descricao;
                    cdsDadosPRECO.AsFloat := Produto.Preco;
                  end;
{$Endregion}
  for Produto in Lista do
  begin
    Inserir(ProcInserir);
  end;
  cdsDados.First;
end;

procedure TfrmPesqProduto.Localizar;
Var
  OP: TOpcaoBuscaProduto;
  ValorProcurado: String;
  iValorProducado: Integer;
  Valor: Variant;
  Continua: Boolean;
  Campo: String;
  Locate: TLocateOptions;
begin
  inherited;
  ValorProcurado := edtValorProcurado.Text;
  OP := TOpcaoBuscaProduto(rdOp.ItemIndex);
  Try
    // inicializando  conjunto
    Locate := [];
    case OP of
      TOpcaoBuscaProduto.Produto:
        begin
          Campo := NOME_CPO_PRODUTO;
          Continua := TryStrToInt(ValorProcurado, iValorProducado) and (iValorProducado > 0);
          if Continua then
            Valor := iValorProducado
          else
            Valor := ValorProcurado;
        end;
      TOpcaoBuscaProduto.Descricao:
        begin
          Campo := NOME_CPO_DESCRICAO;
          Continua := Length(Trim(ValorProcurado)) > 0;
          Locate := [loPartialKey, loCaseInsensitive];
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
        raise ERegistroNaoLocalizado.Create(Format('O tipo de dado pesquisado [%s] é incompatível com tipo de dado  do campo %s',[VarToStr(Valor),
                                                                                              Campo]));

    end;
  Except
    on e: exception do
    begin
      TratamentoExcecao(e);
    end;
  end;
end;
procedure TfrmPesqProduto.PesquisarProdutos;
Const
  NENHUM: Integer = 0;
Var
  Lista: TListaProdutos;
begin
  Try
    Lista := TListaProdutos.Create;
    if TProduto.ObterListaProdutosPaginada(NENHUM,NENHUM,Lista) then
    begin
      InserirProdutosDeLista(Lista);
    end;
  Finally
    if Assigned(Lista) then
    begin
      Lista.Clear;
      FreeAndNil(Lista);
    end;
  End;
end;

end.
