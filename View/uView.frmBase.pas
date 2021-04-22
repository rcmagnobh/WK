unit uView.frmBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, uComum.Types.Types;

type
  TfrmBase = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  protected
  public
    procedure DesabilitarCaptionPanels;
    procedure LimparEdits;
    procedure ConfigurarTela;virtual;
    procedure DesabilitarSomEnter(Var Key: Char);
    procedure DesabilitarSomEnterDeEdits;
    procedure EditKeyPress(Sender: TObject; var Key: Char);

    { Public declarations }
  end;

var
  frmBase: TfrmBase;

implementation

uses
  Vcl.StdCtrls;

{$R *.dfm}

{ TfrmBase }

procedure TfrmBase.ConfigurarTela;
begin
  DesabilitarCaptionPanels;
  DesabilitarSomEnterDeEdits;
  LimparEdits;
end;

procedure TfrmBase.DesabilitarCaptionPanels;
Var
  i: Integer;
begin
  for i := 0 to Self.ComponentCount -1 do
  begin
    if Components[i] is TPanel then
    begin
      TPanel(Components[i]).ShowCaption := False;
    end;
  end;

end;

procedure TfrmBase.DesabilitarSomEnter(Var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0);
  end;
end;

procedure TfrmBase.DesabilitarSomEnterDeEdits;
var
  i: Integer;
begin
  for i := 0 to Self.ComponentCount -1 do
  begin
    if Self.Components[i] is TEdit then
      TEdit(Self.Components[i]).OnKeyPress := EditKeyPress;
  end;

end;

procedure TfrmBase.EditKeyPress(Sender: TObject; var Key: Char);
begin
  DesabilitarSomEnter(Key);
end;

procedure TfrmBase.FormKeyPress(Sender: TObject; var Key: Char);
begin
  DesabilitarSomEnter(Key);
end;

procedure TfrmBase.FormShow(Sender: TObject);
begin
  ConfigurarTela;
end;

procedure TfrmBase.LimparEdits;
Var
  i : Integer;
begin
  for i := 0 to Self.ComponentCount -1 do
  begin
    if Self.Components[i] is TEdit then
      TEdit(Self.Components[i]).Text := EmptyStr;
  end;
end;

end.
