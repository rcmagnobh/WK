unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, uClasses.ListaPedidos,
  uClasses.Pedido, uComum.Types.Types, Vcl.Mask, uClasses.Cliente,
  uClasses.interfaces,
  Vcl.ActnList, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ImgList, uView.frmBase,
  Vcl.DBCtrls, System.ImageList, System.Actions;

Type
  RAlturaCatPanelGroup = record
    FParent: TCategoryPanelGroup;
    FcpnlControle: TCategoryPanel;
    FCpnlListaPedidos: TCategoryPanel;
    procedure Renderizar;
  end;

type
  TfrmMain = class(TfrmBase, uClasses.interfaces.IObservador)
    pnlMain: TPanel;
    pnltopo: TPanel;
    pnlEsquerda: TPanel;
    pnlRodape: TPanel;
    cdsPedidos: TClientDataSet;
    Button2: TButton;
    cdsItensPedido: TClientDataSet;
    dtsItenspedido: TDataSource;
    dtsPedidos: TDataSource;
    cdsPedidosPedido: TIntegerField;
    cdsPedidosCliente: TIntegerField;
    cdsPedidosEmissao: TDateField;
    cdsItensPedidoId: TIntegerField;
    cdsItensPedidoItem: TIntegerField;
    cdsItensPedidoProduto: TIntegerField;
    cdsItensPedidoDescricao: TStringField;
    cdsItensPedidoQuantidade: TFloatField;
    cdsItensPedidoUnitario: TFloatField;
    cdsItensPedidoTotal: TFloatField;
    pnlCentral: TPanel;
    pnlItemPedidos: TPanel;
    Label9: TLabel;
    DBGrid2: TDBGrid;
    pnlPedidosDados: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    edtPedidoNumero: TEdit;
    edtCliente: TEdit;
    edtNomeCliente: TEdit;
    Label1: TLabel;
    pnlresumopedido: TPanel;
    edtTotal: TEdit;
    Label12: TLabel;
    btnInserirProduto: TButton;
    SpeedButton1: TSpeedButton;
    medtEmissao: TMaskEdit;
    ActionList1: TActionList;
    ImageList1: TImageList;
    acPrimeiroReg: TAction;
    acAnteriorReg: TAction;
    acProximoReg: TAction;
    acUltimoReg: TAction;
    Panel1: TPanel;
    btnEditarItem: TButton;
    btnRemoverItem: TButton;
    alRemoverItem: TAction;
    alPesquisarUmPedido: TAction;
    alEditarItem: TAction;
    alNovoItem: TAction;
    alTodos: TAction;
    btnNovo: TButton;
    btnCancelar: TButton;
    Button1: TButton;
    btnPesquisarPedido: TButton;
    btnApagar: TButton;
    btnSalvar: TButton;
    btnEditar: TButton;
    ToolBar1: TToolBar;
    tbtnPrimeiro: TToolButton;
    tbtnAnterior: TToolButton;
    tbtnProximo: TToolButton;
    tbtnUltimo: TToolButton;
    DBGrid1: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure cdsPedidosBeforeScroll(DataSet: TDataSet);
    procedure cdsPedidosNewRecord(DataSet: TDataSet);
    procedure cdsPedidosAfterScroll(DataSet: TDataSet);
    procedure btnEditarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure acAnteriorRegExecute(Sender: TObject);
    procedure acPrimeiroRegExecute(Sender: TObject);
    procedure acProximoRegExecute(Sender: TObject);
    procedure acUltimoRegExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cpnlControlesCollapse(Sender: TObject);
    procedure cpnlControlesExpand(Sender: TObject);
    procedure cpnlListaCollapse(Sender: TObject);
    procedure cpnlListaExpand(Sender: TObject);
    procedure cdsPedidosAfterPost(DataSet: TDataSet);
    procedure cdsPedidosAfterCancel(DataSet: TDataSet);
    procedure ToolButton1Click(Sender: TObject);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure alRemoverItemExecute(Sender: TObject);
    procedure alPesquisarUmPedidoExecute(Sender: TObject);
    procedure alEditarItemExecute(Sender: TObject);
    procedure alNovoItemExecute(Sender: TObject);
    procedure alTodosExecute(Sender: TObject);
  Strict Private
    procedure RenderizarMenu;
    procedure HabilitarControlesPedido(const Status: TSituacaoListaPedidos);
  private
    FInserirItem: Boolean;
    FListaPedidos: TListaPedidos;
    procedure ExibirPedido(oPedido: TPedido);
    procedure ExibirItensPedido(oPedido: TPedido);
    procedure ReceberCliente(oCliente: TCliente);
    procedure LimparTelaPedidoDestaque;
    procedure ConfigurarTela; override;
    procedure CriarDsTemporarios;
    procedure InserirNovoPedido;
    procedure ReceberItem(Const Id, Item, Produto: Integer; Descricao: String;
      Unitario, Quantidade, Total: Double);
    procedure EditarPedido;
    procedure CancelarPedido;
    procedure HabilitarConformeStatusFilaPedidos(Const Status
      : TSituacaoListaPedidos);
    procedure IncluirPedidoGrid(Pedido: TPedido);
    procedure PesquisarTodosPedidos;
    procedure PesquisarPedido;
    procedure ExcluirUmPedido;

    { Private declarations }
  public
    procedure ReceberNoficicacao(const Value: INotificacaoLista);
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uView.frmSelecaoProduto,
  uView.frmPesqCliente,
  uView.frmPesqProduto,
  uHelpers.DS.HelpersDS,
  uComum.Lib.TratamentoExcecao,
  uComum.Lib.Lib,
  uClasses.ItemPedido;

{$R *.dfm}
{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FInserirItem := False;
  inherited;
  FListaPedidos := TListaPedidos.Create;
  FListaPedidos.AdicionarObservador(Self);
  FListaPedidos.EventoEnviarPedido := ExibirPedido;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  inherited;
  FListaPedidos.Free;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  inherited;
  RenderizarMenu;
end;

procedure TfrmMain.acAnteriorRegExecute(Sender: TObject);
begin
  inherited;
  if FListaPedidos.Navegar(TNavegacaoListaPedidos.Anterior) then
    cdsPedidos.Prior;
end;

procedure TfrmMain.acPrimeiroRegExecute(Sender: TObject);
begin
  inherited;
  if FListaPedidos.Navegar(TNavegacaoListaPedidos.Primeiro) then
    cdsPedidos.First;
end;

procedure TfrmMain.acProximoRegExecute(Sender: TObject);
begin
  inherited;
  if FListaPedidos.Navegar(TNavegacaoListaPedidos.Proximo) then
    cdsPedidos.Next;
end;

procedure TfrmMain.acUltimoRegExecute(Sender: TObject);
begin
  inherited;
  if FListaPedidos.Navegar(TNavegacaoListaPedidos.Ultimo) then
    cdsPedidos.Last;
end;

procedure TfrmMain.alEditarItemExecute(Sender: TObject);
Var
  Indice: Integer;
  Item: TItemPedido;
begin
  inherited;
  if Not cdsItensPedido.IsEmpty then
  begin
    Indice := FListaPedidos.GetPedidoDestaque.ObterIndiceDoItem
      (cdsItensPedidoItem.AsInteger);
    Item := FListaPedidos.GetPedidoDestaque.ObterItemDeIndice(Indice);
    if Assigned(Item) then
    begin
      if FListaPedidos.GetPedidoDestaque.EditarItem(Item) then
      begin
        FListaPedidos.EventoEnviarPedido(FListaPedidos.GetPedidoDestaque);
      end;
    end;
  end;
end;

procedure TfrmMain.alNovoItemExecute(Sender: TObject);
Var
  i: Integer;
begin
  if FListaPedidos.GetPedidoDestaque.AdicionarNovoItem then
  begin
    FListaPedidos.EventoEnviarPedido(FListaPedidos.GetPedidoDestaque);
  end;
end;

procedure TfrmMain.alPesquisarUmPedidoExecute(Sender: TObject);
begin
  inherited;
  PesquisarPedido
end;

procedure TfrmMain.alRemoverItemExecute(Sender: TObject);
begin
  inherited;
  if Not cdsItensPedido.IsEmpty then
  begin
    if MessageDlg('Confirma a exclusão do item?',mtConfirmation,[mbYes, mbNo], MB_ICONQUESTION) = mrYes then
    begin
      if FListaPedidos.GetPedidoDestaque.DescartarItem
        (cdsItensPedidoItem.AsInteger) then
        FListaPedidos.EventoEnviarPedido(FListaPedidos.GetPedidoDestaque);
    end;
  end;
end;

procedure TfrmMain.alTodosExecute(Sender: TObject);
begin
  inherited;
  PesquisarTodosPedidos;
end;

procedure TfrmMain.btnApagarClick(Sender: TObject);
Var
  I: Integer;
begin
  inherited;
  ExcluirUmPedido;
end;

procedure TfrmMain.btnCancelarClick(Sender: TObject);
begin
  inherited;
  CancelarPedido;
end;

procedure TfrmMain.btnEditarClick(Sender: TObject);
begin
  inherited;
  EditarPedido;
end;

procedure TfrmMain.btnNovoClick(Sender: TObject);
begin
  inherited;
  InserirNovoPedido;
end;

procedure TfrmMain.btnSalvarClick(Sender: TObject);
Var
  Status: TSituacaoListaPedidos;
  Pedido: TPedido;
  Inserindo: Boolean;
begin
  inherited;
  Status := FListaPedidos.Status;
  Inserindo := Status = TAcaoLista.Insercao;
  Try
    if Not(Status in TMODOEDICAO) then
    begin
      if Status = TAcaoLista.Vazia then
        FListaPedidos.CriarExcecaoFilaVazia
          ('Inicie um pedido antes de continuar.')
      else
        FListaPedidos.CriarExcecaoFilaNaoModoEdicao;
    end;
    Pedido := FListaPedidos.GetPedidoDestaque;
    Pedido.Data := StrToDateTime(medtEmissao.Text);
    if FListaPedidos.Salvar then
    begin
      if Status = TAcaoLista.Insercao then
      begin
        FInserirItem := Inserindo;
        IncluirPedidoGrid(Pedido);
        FListaPedidos.FocarPedido(FListaPedidos.ObterIndice(Pedido));
      end;
    end
  Except
    On E: Exception do
    Begin
      TratamentoExcecaoFilaPedidos(EFilaPedidosSituacao(E));
    End;
  End;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.CancelarPedido;
begin
  Try
    if Not(FListaPedidos.Status in TSTATUSPERMITECANCELAR) then
    begin
      raise EFilaPedidosSituacao.Create
        ('Pedido não está em edição ou inserção.');
    end;
    FListaPedidos.Cancelar;
  Except
    on E: Exception do
    begin
      TratamentoExcecaoFilaPedidos(EFilaPedidosSituacao(E));
    end;
  End;
end;

procedure TfrmMain.cdsPedidosAfterCancel(DataSet: TDataSet);
begin
  inherited;
  FInserirItem := False;
end;

procedure TfrmMain.cdsPedidosAfterPost(DataSet: TDataSet);
begin
  inherited;
  FInserirItem := False;

end;

procedure TfrmMain.cdsPedidosAfterScroll(DataSet: TDataSet);
Var
  Focar: Boolean;
  NumeroPedidoFoco: Integer;
  Status: TSituacaoListaPedidos;
begin
  inherited;
  Status := FListaPedidos.Status;

  if Status in TMODOEDICAO  then
  begin
    LevantarExcecaoPedido('Cancele ou altere o pedido antes de continuar.');
  end
  else begin
    FListaPedidos.FocarPedido(FListaPedidos.ObterIndice(cdsPedidosPedido.AsInteger));
  end;
end;

procedure TfrmMain.cdsPedidosBeforeScroll(DataSet: TDataSet);
Var
  Abortar: Boolean;
  Status: TSituacaoListaPedidos;
begin
  inherited;
end;

procedure TfrmMain.cdsPedidosNewRecord(DataSet: TDataSet);
Var
  Status: TSituacaoListaPedidos;
begin
  inherited;
  if Not FInserirItem then
  begin
    Status := FListaPedidos.Status;
    if (Not(Status = TAcaoLista.Insercao)) then
      Abort;
  end;
end;

procedure TfrmMain.ConfigurarTela;
begin
  inherited ConfigurarTela;
  RenderizarMenu;
  HabilitarConformeStatusFilaPedidos(FListaPedidos.Status);
  CriarDsTemporarios;
end;

procedure TfrmMain.cpnlControlesCollapse(Sender: TObject);
begin
  inherited;
  RenderizarMenu;
end;

procedure TfrmMain.cpnlControlesExpand(Sender: TObject);
begin
  inherited;
  RenderizarMenu;
end;

procedure TfrmMain.cpnlListaCollapse(Sender: TObject);
begin
  inherited;
  RenderizarMenu;
end;

procedure TfrmMain.cpnlListaExpand(Sender: TObject);
begin
  inherited;
  RenderizarMenu;
end;

procedure TfrmMain.CriarDsTemporarios;
begin
  if cdsPedidos.Active then
    cdsPedidos.EmptyDataSet
  else
    cdsPedidos.CreateDataSet;

  if cdsItensPedido.Active then
    cdsItensPedido.EmptyDataSet
  else
    cdsItensPedido.CreateDataSet;
end;

procedure TfrmMain.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  Status: TSituacaoListaPedidos;
begin
  inherited;
  if FListaPedidos.Pedidos.Count > 0 then
  begin
    Status := FListaPedidos.Status;
    if Status in TMODOEDICAO then
    begin
      if Key = VK_DELETE then
      begin
        alRemoverItem.Execute;
      end
      else if key = VK_RETURN then
      begin
        if Not cdsItensPedido.IsEmpty then
        begin
          alEditarItem.Execute;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.EditarPedido;
Var
  Status: TSituacaoListaPedidos;
begin
  Status := FListaPedidos.Status;
  Try
    if FListaPedidos.PermiteAcaoCrud(TOpCrud.Atualizar) then
      FListaPedidos.Editar
  Except
    On E: Exception do
    begin
      TratamentoExcecaoFilaPedidos(EFilaPedidos(E));
    end;
  End;
end;

procedure TfrmMain.ExcluirUmPedido;
Var
  s: String;
  Numero: Integer;
  Continua: Boolean;
  aPedido: TPedido;
  Indice: Integer;
  PedidoExiste: boolean;
begin
  PedidoExiste := False;
  Continua := False;
  Numero := 0;;
  s := EmptyStr;
  Repeat
    s:= InputBox('Exclusão de pedido','Qual o número do pedido que você deseja excluir?','');
    Continua := Not TryStrToInt(s,Numero);
    if Continua then
    begin
      Continua := MessageDlg('Número informado inválido. Deseja informar outro pedido?',mtInformation,[mbYes,mbNo],MB_ICONQUESTION) = mrYes;
    end;
  Until Not Continua;
  if Numero > 0 then
  begin
    Try
      Indice := FListaPedidos.ObterIndice(Numero);
      if Indice >= 0 then
      begin
        FListaPedidos.RemoverEExcluir(Indice);
        PedidoExiste := True;

      end
      else begin
        aPedido := TPedido.Create;
        aPedido.Numero := Numero;
        PedidoExiste := aPedido.Recuperar;
      end;
      if PedidoExiste then
      begin
        aPedido.Excluir;
        if cdsPedidos.Locate('PEDIDO',Numero,[]) then
        begin
          cdsPedidos.Delete;
        end;
        cdsPedidos.First;
        FListaPedidos.SetPedidoDestaque(FListaPedidos.Pedido[0]);
      end;
    Finally
      if Assigned(aPedido) then
        aPedido.Free;
    end;
  end;
end;

procedure TfrmMain.ExibirItensPedido(oPedido: TPedido);
var
  i: Integer;
begin
  cdsItensPedido.EmptyDataSet;
  for i := 0 to oPedido.ListaItens.Count - 1 do
  begin
    with oPedido.ListaItens[i] do
    begin
      ReceberItem(0, Item, Produto.Codigo, Produto.Descricao, Unitario,
        Quantidade, Total);
    end;
  end;
end;

procedure TfrmMain.ExibirPedido(oPedido: TPedido);
CONST
  MASCARANOVOPEDIDO: String = '0000000';

begin
  if Assigned(oPedido) then
  begin
    if (FListaPedidos.Status = TAcaoLista.Insercao) then
    begin
      LimparTelaPedidoDestaque;
      edtPedidoNumero.Text := MASCARANOVOPEDIDO;
      medtEmissao.Text := FormatarDataToString(Now);
      ExibirItensPedido(oPedido);
      edtCliente.Text := IntTostr(oPedido.Cliente.Codigo);
      edtNomeCliente.Text := oPedido.Cliente.Nome;
      edtTotal.Text := FormatarDecimal(0);
    end
    else
    begin
      edtPedidoNumero.Text := IntToStr(oPedido.Numero);
      edtCliente.Text := IntToStr(oPedido.Cliente.Codigo);
      medtEmissao.Text := FormatarDataToString(oPedido.Data);
      edtNomeCliente.Text := oPedido.Cliente.Nome;
      ExibirItensPedido(oPedido);
    end;
    edtTotal.Text := FormatarDecimal(oPedido.Total);
  end
  else
  begin
    LimparTelaPedidoDestaque;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  ConfigurarTela;
end;

procedure TfrmMain.HabilitarConformeStatusFilaPedidos
  (const Status: TSituacaoListaPedidos);
begin
  btnApagar.Visible := Not (Status in TMODOEDICAO);
  btnPesquisarPedido.Visible := Not (Status in TMODOEDICAO);
end;

procedure TfrmMain.HabilitarControlesPedido(const Status
  : TSituacaoListaPedidos);
Var
  Habilitar: Boolean;
begin
  Habilitar := Status in TMODOEDICAO;
  SpeedButton1.Enabled := Status = TAcaoLista.Insercao;
  btnEditarItem.Visible := Habilitar;
  btnRemoverItem.Visible := Habilitar;
  btnInserirProduto.Visible := Habilitar;
end;

procedure TfrmMain.IncluirPedidoGrid(Pedido: TPedido);
begin
  FInserirItem := True;
  cdsPedidos.Append;
  cdsPedidosPedido.AsInteger := Pedido.Numero;
  cdsPedidosCliente.AsInteger := Pedido.Cliente.Codigo;
  cdsPedidosEmissao.AsDateTime := Pedido.Data;
  cdsPedidos.Post;

end;

procedure TfrmMain.InserirNovoPedido;
begin
  Try
    if Not(FListaPedidos.Status in TSTATUSPERMITEINCLUIR) then
    begin
      FListaPedidos.CriarExcecaoFilaPedidosSituacao;
    end
    else
    begin
      FListaPedidos.NovoPedido;
    end;
  Except
    on E: Exception do
    begin
      TratamentoExcecaoFilaPedidos(EFilaPedidosSituacao(E));
    end;
  End;
end;

procedure TfrmMain.LimparTelaPedidoDestaque;
begin
  edtPedidoNumero.Text := EmptyStr;
  medtEmissao.Text := EmptyStr;
  edtCliente.Text := EmptyStr;
  edtNomeCliente.Text := EmptyStr;
  if cdsItensPedido.Active then
    cdsItensPedido.EmptyDataSet;
  edtTotal.Text := FormatarDecimal(0);
end;

procedure TfrmMain.PesquisarTodosPedidos;
var
  i: Integer;
begin
  if FListaPedidos.RecuperarTodosPedidos then
  begin
    cdsPedidos.EmptyDataSet;
    for i := 0 to FListaPedidos.Pedidos.Count - 1 do
    begin
      FInserirItem := true;
      IncluirPedidoGrid(FListaPedidos.Pedidos[i]);
    end;
    cdsPedidos.First;
    FListaPedidos.SetPedidoDestaque(FListaPedidos.Pedido[0]);
  end;
end;

procedure TfrmMain.PesquisarPedido;
Var
  s: String;
  Numero: Integer;
  Continua: Boolean;
  aPedido: TPedido;
begin
  Continua := False;
  Numero := 0;;
  s := EmptyStr;
  Repeat
    s:= InputBox('Pesquisar pedido','Informe o número do pedido','');
    Continua := Not TryStrToInt(s,Numero);
    if Continua then
    begin
      Continua := MessageDlg('Número informado inválido. Deseja informar outro pedido?',mtInformation,[mbYes,mbNo],MB_ICONQUESTION) = mrYes;
    end;
  Until Not Continua;
  if Numero > 0 then
  begin

    if Not cdsPedidos.Locate('PEDIDO',Numero,[]) then
    begin
      aPedido := TPedido.Create;
      aPedido.Numero := Numero;

      if aPedido.Recuperar then
      begin
        if  FListaPedidos.Adicionar(aPedido) then
        begin
          FListaPedidos.SetPedidoDestaque(aPedido);
          IncluirPedidoGrid(aPedido);
          FListaPedidos.FocarPedido(FListaPedidos.ObterIndice(aPedido));
        end;
      end
      else begin
        aPedido.Free;
      end;
    end;
  end;

end;

procedure TfrmMain.ReceberCliente(oCliente: TCliente);
Var
  aPedido: TPedido;
begin
  aPedido := FListaPedidos.GetPedidoDestaque;
  aPedido.Cliente.Codigo := oCliente.Codigo;
  aPedido.Cliente.Nome := oCliente.Nome;
  aPedido.Cliente.Cidade := oCliente.Cidade;
  aPedido.Cliente.UF := oCliente.UF;
  edtCliente.Text := IntToStr(aPedido.Cliente.Codigo);
  edtNomeCliente.Text := aPedido.Cliente.Nome;
end;

procedure TfrmMain.ReceberItem(const Id, Item, Produto: Integer;
Descricao: String; Unitario, Quantidade, Total: Double);
begin
  cdsItensPedido.Inserir(
    procedure
    begin
      cdsItensPedidoItem.AsInteger := Item;
      cdsItensPedidoProduto.AsInteger := Produto;
      cdsItensPedidoDescricao.AsString := Descricao;
      cdsItensPedidoUnitario.AsFloat := Unitario;
      cdsItensPedidoQuantidade.AsFloat := Quantidade;
      cdsItensPedidoTotal.AsFloat := Total;
    end);

end;

procedure TfrmMain.ReceberNoficicacao(const Value: INotificacaoLista);
Const
  PEDIDONULO: Integer = -1;
Var
  StatusFila: TSituacaoListaPedidos;
begin
  StatusFila := TSituacaoListaPedidos(Value.GetOrdSituacao);
  case StatusFila of
    TAcaoLista.Vazia:
      Begin
      end;
    TAcaoLista.Navegacao:
      Begin

      end;
    TAcaoLista.Insercao:
      begin
      end;
    TAcaoLista.Edicao:
      begin
      end;
  end;
  HabilitarConformeStatusFilaPedidos(StatusFila);
  HabilitarControlesPedido(StatusFila);
end;

procedure TfrmMain.RenderizarMenu;
Var
  Menu: RAlturaCatPanelGroup;
begin
//  Menu.FParent := CategoryPanelGroup1;
//  Menu.FcpnlControle := cpnlControles;
//  Menu.FCpnlListaPedidos := cpnlLista;
//  Menu.Renderizar;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  Try
    frmPesqCliente := TfrmPesqCliente.Create(Self);
    frmPesqCliente.EventoRetornarCliente := ReceberCliente;
    frmPesqCliente.ShowModal;
    frmPesqCliente.Close;
  Finally
    if Assigned(frmPesqCliente) then
      frmPesqCliente.Close;
  End;
end;

procedure TfrmMain.ToolButton1Click(Sender: TObject);
begin
  inherited;
  PesquisarPedido
end;

{ RAlturaCatPanelGroup }

procedure RAlturaCatPanelGroup.Renderizar;
Var
  AreaBase: Integer;
begin
  AreaBase := FParent.Height;
  FCpnlListaPedidos.Height := ((AreaBase - FcpnlControle.Height) - 1);
end;

initialization

if DebugHook <> 0 then
begin
  ReportMemoryLeaksOnShutdown := true;
end;

end.
