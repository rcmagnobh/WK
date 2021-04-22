program PDVTeste;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uClasses.Pedido in 'Classes\uClasses.Pedido.pas',
  uClasses.ItemPedido in 'Classes\uClasses.ItemPedido.pas',
  uClasses.Produto in 'Classes\uClasses.Produto.pas',
  uClasses.Cliente in 'Classes\uClasses.Cliente.pas',
  uClasses.DAO.ProdutoDAO in 'Classes\DAO\uClasses.DAO.ProdutoDAO.pas',
  uView.frmBase in 'View\uView.frmBase.pas' {frmBase},
  uView.frmBasePesquisa in 'View\uView.frmBasePesquisa.pas' {frmBasePesquisa},
  uClasses.ListaPedidos in 'Classes\uClasses.ListaPedidos.pas',
  uClasses.Interfaces in 'Classes\uClasses.Interfaces.pas',
  uClasses.NotificacaoLista in 'Classes\uClasses.NotificacaoLista.pas',
  Vcl.Dialogs,
  uClasses.DAO.ConexaoDB.DMConexaoDB in 'Classes\DAO\ConexaoBD\uClasses.DAO.ConexaoDB.DMConexaoDB.pas' {DMConexaoDB: TDataModule},
  uClasses.DAO.BaseDAO in 'Classes\DAO\uClasses.DAO.BaseDAO.pas',
  uClasses.Types.AtributosCustomizados in 'Classes\Types\uClasses.Types.AtributosCustomizados.pas',
  uClasses.DAO.RTTI.CampoRtti in 'Classes\DAO\RTTI\uClasses.DAO.RTTI.CampoRtti.pas',
  uClasses.DAO.ItemPedidoDAO in 'Classes\DAO\uClasses.DAO.ItemPedidoDAO.pas',
  uHelpers.DS.HelpersDS in 'Helpers\DS\uHelpers.DS.HelpersDS.pas',
  uClases.DAO.PedidoDAO in 'Classes\DAO\uClases.DAO.PedidoDAO.pas',
  uView.frmSelecaoProduto in 'View\uView.frmSelecaoProduto.pas' {frmSelecaoProduto},
  uView.frmPesqProduto in 'View\uView.frmPesqProduto.pas' {frmPesqProduto},
  uView.frmPesqCliente in 'View\uView.frmPesqCliente.pas' {frmPesqCliente},
  uComum.Types.Interfaces in 'Comum\Types\uComum.Types.Interfaces.pas',
  uComum.Types.Types in 'Comum\Types\uComum.Types.Types.pas',
  uComum.Lib.Lib in 'Comum\Lib\uComum.Lib.Lib.pas',
  uComum.Lib.TratamentoExcecao in 'Comum\Lib\uComum.Lib.TratamentoExcecao.pas',
  uHelpers.DS.BuscaParametros in 'Helpers\DS\uHelpers.DS.BuscaParametros.pas',
  uClasses.DAO.ClienteDAO in 'Classes\DAO\uClasses.DAO.ClienteDAO.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  //Aviso sistema em modo Debug
{$IFDEF DEBUG}
    ShowMessage('Projeto compilado em modo de depuração, sua operação pode ser mais lenta.');
{$ENDIF}


  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSelecaoProduto, frmSelecaoProduto);
  Application.CreateForm(TfrmPesqProduto, frmPesqProduto);
  Application.CreateForm(TfrmPesqCliente, frmPesqCliente);
  Application.Run;
end.
