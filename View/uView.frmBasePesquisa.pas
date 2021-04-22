unit uView.frmBasePesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Data.DB, Datasnap.DBClient,uComum.Types.Types, uView.frmBase;

type
  TProcConfirmar = reference to procedure(Out Confirmado: Boolean);
  TfrmBasePesquisa = class(TfrmBase)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    edtValorProcurado: TEdit;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    cdsDados: TClientDataSet;
    dtsDados: TDataSource;
    btnLocalizar: TButton;
    procedure edtValorProcuradoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure edtValorProcuradoKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
  private
    procedure ConfigurarTela;override;
  protected
    procedure Inserir(aProc: TProc);
    procedure Confirmar(aProc: TProcConfirmar);
    procedure ConfigurarCDS;virtual;
    procedure Localizar;virtual;abstract;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBasePesquisa: TfrmBasePesquisa;

implementation

{$R *.dfm}

{ TfrmBasePesquisa }

procedure TfrmBasePesquisa.ConfigurarCDS;
begin
  if cdsDados.Active then
    cdsDados.Close;
  cdsDados.CreateDataSet;
end;

procedure TfrmBasePesquisa.ConfigurarTela;
begin
  inherited ConfigurarTela;
  ConfigurarCDS;
end;

procedure TfrmBasePesquisa.Confirmar(aProc: TProcConfirmar);
Var
  Confirmado: Boolean;
begin
  Confirmado := False;
  aProc(Confirmado);
  if Confirmado then
  begin
    Self.ModalResult := mrOk;
  end
  else begin
    Self.ModalResult := mrCancel;
  end;
end;

procedure TfrmBasePesquisa.edtValorProcuradoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
  begin
    Localizar;
  end;
end;

procedure TfrmBasePesquisa.edtValorProcuradoKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0);
  end;
end;

procedure TfrmBasePesquisa.FormCreate(Sender: TObject);
begin
  inherited;
  ConfigurarCDS;
end;

procedure TfrmBasePesquisa.FormDestroy(Sender: TObject);
begin
  inherited;
  cdsDados.EmptyDataSet;
end;

procedure TfrmBasePesquisa.Inserir(aProc: TProc);
begin
  cdsDados.Append;
  aProc;
  cdsDados.Post;
end;

end.
