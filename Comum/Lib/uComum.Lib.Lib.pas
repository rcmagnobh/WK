unit uComum.Lib.Lib;

interface

uses
  uComum.Types.Types;
function FormatarDecimal(Valor: Double): String;
function Arredondar(Valor: Double; CasaDecimais:Integer = 2): Double;
function FormatarEArrendondarDecimal(Valor: Double; CasasDecimais: Integer = 2): String;
function RandomFrom(Const ArrayStrings: TArrayStrings):String;
function FormatarDataToString(aDateTime: TDateTime): String;
function ValidaeFormataStringToFloat(Var Valor: String; Notifica: Boolean = false): Boolean;
function ValidaStringToInteger(Var Valor: String; Notifica: Boolean = false): Boolean;
function ValidaeFormataStringToDateTime(Var Valor: String; Notifica: Boolean = false): Boolean;
procedure ExibirMensagem(Titulo, Mensagem: String; MB_Icone: Cardinal);
procedure LevantarExcecaoPedido(Const Msg: String);
implementation

uses
  Math,
  System.SysUtils,
  uComum.Lib.TratamentoExcecao, Winapi.Windows, Vcl.Forms;

function FormatarDecimal(Valor: Double): String;
begin
  Result := FormatFloat(MASCARADECIMAL, Valor);
end;
function RandomFrom(Const ArrayStrings: TArrayStrings):String;
Var
  Tamanho: Integer;
begin
  Tamanho := Length(ArrayStrings);
  Result := ArrayStrings[Random(Tamanho)];
end;
function FormatarDataToString(aDateTime: TDateTime): String;
begin
  Result := FormatDateTime(MASCARADATA, aDateTime);
end;
function ValidaeFormataStringToFloat(Var Valor: String; Notifica: Boolean = false): Boolean;
Var
  s: String;
  Aux: Double;
  Msg: String;
  Ret: Boolean;
begin
  Ret := False;
  Msg := EmptyStr;
  Aux := 0;
  s := Valor;
  s := StringReplace(Valor,'.','',[rfReplaceAll]);
  Try
    Ret := TryStrToFloat(s, Aux);
    if Not Ret then
    begin
      Msg := Valor+' não é um valor válido. Preencher com formato semelhante: 1.234,00';
      if Notifica then
        raise EValorInvalido.Create(Msg);
    end
    else begin
      Valor := FormatFloat(MASCARAMOEDA,Aux);
    end;
  Except
    on e: Exception do
    begin
      TratamentoExcecao(e);
    end;
  End;
  Result := Ret;
end;
function ValidaStringToInteger(Var Valor: String; Notifica: Boolean = false): Boolean;
Var
  s: String;
  Aux: Integer;
  Msg: String;
  Ret: Boolean;
begin
  Ret := False;
  Msg := EmptyStr;
  Aux := 0;
  s := Valor;
  s := StringReplace(Valor,'.','',[rfReplaceAll]);
  Try
    Ret := TryStrToInt(s, Aux);
    if Not Ret then
    begin
      Msg := Valor+' não corresponde a um número inteiro.';
      if Notifica then
        raise EValorInvalido.Create(Msg);
    end;
  Except
    on e: Exception do
    begin
      TratamentoExcecao(e);
    end;
  End;
  Result := Ret;
end;
function ValidaeFormataStringToDateTime(Var Valor: String; Notifica: Boolean = false): Boolean;
Var
  s: String;
  Aux: TDateTime;
  Msg: String;
  Ret: Boolean;
begin
  Ret := False;
  Msg := EmptyStr;
  Aux := 0;
  s := Valor;
  Try
    Ret := TryStrToDateTime(s, Aux);
    if Not Ret then
    begin
      Msg := Valor+' não é uma data válida.';
      if Notifica then
        raise EValorInvalido.Create(Msg);
    end
    else begin
      Valor := FormatDateTime(MASCARADATA,Aux);
    end;
  Except
    on e: Exception do
    begin
      TratamentoExcecao(e);
    end;
  End;
  Result := Ret;
end;
procedure ExibirMensagem(Titulo, Mensagem: String; MB_Icone: Cardinal);
begin
  MessageBox(Application.handle,pWideChar(Mensagem),Pwidechar(Titulo), MB_Icone);
end;

function FormatarEArrendondarDecimal(Valor: Double; CasasDecimais: Integer = 2):String;
Var
  v: Double;
begin
  v := Valor;
  v := Arredondar(v,CasasDecimais);
  Result := FormatarDecimal(v);
end;
function Arredondar(Valor: Double; CasaDecimais:Integer = 2):Double;
begin
  Result := RoundTo(Valor,-CasaDecimais)
end;
procedure LevantarExcecaoPedido(Const Msg: String);
begin
  Try
    raise EFilaPedidos.Create(Msg);
  Except
    On E: Exception do
    begin
      TratamentoExcecaoFilaPedidos(EFilaPedidos(e));
    end;
  End;
end;
end.
