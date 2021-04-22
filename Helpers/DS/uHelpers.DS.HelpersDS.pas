unit uHelpers.DS.HelpersDS;

interface

uses
  DB,
  DataSnap.DBClient,
  System.SysUtils,
  uComum.Types.Types,
  Data.SqlExpr,
  uHelpers.DS.BuscaParametros;


Type

  TDataSetHelper = class helper for TDataSet
  public
    procedure PercorrerDs(Procedimento: TProcComRetorno);overload;
    procedure Inserir(aProc: TProc);
  end;

  TClientDataSetHelper = class helper for TClientDataSet
  public
    procedure DefinirParametro(AParametro: TParam; AValor: Variant;
      ATipoAtributo: tfieldtype; ATipoParametro: TParamType = ptInput);
      overload;
    function DefinirParametro(Out Msg: String; ANomeParametro: String; AValor: Variant;
      ATipoAtributo: tfieldtype; ATipoParametro: TParamType = ptInput)
      : Boolean; overload;
    function DefinirParametro(Out Msg: String; IndiceParametro: Integer; AValor: Variant;
      ATipoAtributo: tfieldtype; ATipoParametro: TParamType = ptInput)
      : Boolean; overload;
    function DefinirParametro(Out Msg: String; ListaParametros: TListaIBParam):Boolean;overload;
  end;

  TCustomSqlDataSetHelper = class helper for TCustomSQLDataSet
  public
    procedure DefinirParametro(AParametro: TParam; AValor: Variant;
      ATipoAtributo: tfieldtype; ATipoParametro: TParamType = ptInput);
      overload;
    function DefinirParametro(Out Msg: String; ANomeParametro: String; AValor: Variant;
      ATipoAtributo: tfieldtype; ATipoParametro: TParamType = ptInput)
      : Boolean; overload;
    function DefinirParametro(Out Msg: String; IndiceParametro: Integer; AValor: Variant;
      ATipoAtributo: tfieldtype; ATipoParametro: TParamType = ptInput)
      : Boolean; overload;
    function DefinirParametro(Out Msg: String; ListaParametros: TListaIBParam):Boolean;overload;
  end;

implementation

uses
  System.Classes,
  uComum.Lib.TratamentoExcecao;

{ TClientDataSetHelper }

procedure TClientDataSetHelper.DefinirParametro(AParametro: TParam; AValor: Variant;
  ATipoAtributo: tfieldtype; ATipoParametro: TParamType);
begin
  with AParametro do
  begin
    ParamType := ATipoParametro;
    DataType := ATipoAtributo;
    Value := AValor;
  end;
end;

function TClientDataSetHelper.DefinirParametro( Out Msg: String; ANomeParametro: String;
  AValor: Variant; ATipoAtributo: tfieldtype;
  ATipoParametro: TParamType): Boolean;
Var
  Parametro: TParam;
  Ret: Boolean;
begin
  //Ret(result) retorna ANomeParametro foi encontrado
  Msg := EmptyStr;
  with self do
  begin
    Parametro := Params.FindParam(ANomeParametro);
    Ret := Assigned(Parametro);
    if Ret then
    begin
      //Definindo dados do prâmetro
      Self.DefinirParametro(Parametro,AValor,ATipoAtributo, ATipoParametro);
    end;
  end;

   //definindo mensagem quando parâmetor não localizado.
  if Not Ret then
  begin
    Msg := Format('Não foi localizado o parâmetro de nome %s',[ANomeParametro]);
  end;

  Result := Ret;
end;

function TClientDataSetHelper.DefinirParametro( Out Msg: String; IndiceParametro: Integer;
  AValor: Variant; ATipoAtributo: tfieldtype;
  ATipoParametro: TParamType): Boolean;
Var
  Parametro: TParam;
  Ret: Boolean;
begin
  //Ret retorna o resultado (result) se o índice passado no parâmetro é válido
  Msg := EmptyStr;
  with self do
  begin
    Ret := (IndiceParametro >= 0) and (IndiceParametro < Params.Count);
    if Ret then
    begin
      Parametro := Params[IndiceParametro];
      //Definindo dados do prâmetro
      Self.DefinirParametro(Parametro,AValor,ATipoAtributo, ATipoParametro);
    end;
  end;

   //definindo mensagem quando parâmetor não localizado.
  if Not Ret then
  begin
    Msg := Format('Não foi localizado o parâmetro de índice %d',[indiceParametro]);
  end;

  Result := Ret;
end;

function TClientDataSetHelper.DefinirParametro(out Msg: String;
  ListaParametros: TListaIBParam): Boolean;
Var
  i: Integer;
  Item: IBaseBuscaParametro;
  Falha: Boolean;
  AuxMsg: String;
  RetMsg: TStringList;
  Valor: Variant;
  Tipo: TFieldType;
  TipoPar: TParamType;
  TipoBusca: TTipoBuscaParametro;
  IndiceParametro: Integer;
  Nomeparametro: String;
begin
  RetMsg := TStringList.Create;
  Falha := False;
  Try
    for i := 0 to ListaParametros.Count -1 do
    begin
      AuxMsg := EmptyStr;
      item := ListaParametros[i] as IBaseBuscaParametro;
      IndiceParametro := -1;
      Nomeparametro := EmptyStr;
      Valor := item.Valor;
      Tipo := Item.TipoDado;
      TipoPar := Item.TipoParametro;
      TipoBusca := Item.TipoBusca;

      case TipoBusca of
        TTipoBuscaParametro.Indice:
          begin
            IndiceParametro := IBParamIndice(Item).Parametro;
            if Not (Self.DefinirParametro(AuxMsg,IndiceParametro,Valor,Tipo,TipoPar)) then
            begin
              Falha := True;
              RetMsg.Add(AuxMsg);
            end;
          end;
        TTipoBuscaParametro.Nome:
          begin
            Nomeparametro := IBParamNome(Item).Parametro;
            if Not (Self.DefinirParametro(AuxMsg,Nomeparametro,Valor,Tipo,TipoPar)) then
            begin
              Falha := True;
              RetMsg.Add(AuxMsg);
            end;
          end ;
      end;
    end;
  Finally
    if Assigned(RetMsg) then
    begin
      Msg := RetMsg.Text;
      RetMsg.Free;
    end;
    Result := Not Falha;
  End;
end;

{ TDataSetHelper }

procedure TDataSetHelper.Inserir(aProc: TProc);
begin
  with self do
  begin
    Append;
    aProc;
    Post;
  end;
end;

procedure TDataSetHelper.PercorrerDs(Procedimento: TProcComRetorno);
var
  Reg: TBookmark;
  ForcarSaidaLoop: Boolean;
begin
  if Not Self.IsEmpty then
  begin
    Try
      //obtendo posicao atual do ds
      Reg := Self.Bookmark;
      //Desabilitando controles
      Self.DisableControls;
      With self do
      begin
        First;
        while Not Eof do
        begin
          ForcarSaidaLoop := False;
          Procedimento(ForcarSaidaLoop);

          if ForcarSaidaLoop then
            Break;

          Next;
        end;
      end;
    Finally
      Self.EnableControls;
      if Assigned(Reg) then
      begin
        if Not ForcarSaidaLoop then
        begin
          //retornando para posição inicial
          if Self.BookmarkValid(Reg) then
            Self.GotoBookmark(Reg);
        end;
        Self.FreeBookmark(Reg);
      end;
    End;
  end;
end;

{ TCustomSqlDataSetHelper }

procedure TCustomSqlDataSetHelper.DefinirParametro(AParametro: TParam;
  AValor: Variant; ATipoAtributo: tfieldtype; ATipoParametro: TParamType);
begin
  with AParametro do
  begin
    ParamType := ATipoParametro;
    DataType := ATipoAtributo;
    Value := AValor;
  end;
end;

function TCustomSqlDataSetHelper.DefinirParametro(out Msg: String;
  ANomeParametro: String; AValor: Variant; ATipoAtributo: tfieldtype;
  ATipoParametro: TParamType): Boolean;
Var
  Parametro: TParam;
  Ret: Boolean;
begin
  //Ret(result) retorna ANomeParametro foi encontrado
  Msg := EmptyStr;
  with self do
  begin
    Parametro := Params.FindParam(ANomeParametro);
    Ret := Assigned(Parametro);
    if Ret then
    begin
      //Definindo dados do prâmetro
      Self.DefinirParametro(Parametro,AValor,ATipoAtributo, ATipoParametro);
    end;
  end;

   //definindo mensagem quando parâmetor não localizado.
  if Not Ret then
  begin
    Msg := Format('Não foi localizado o parâmetro de nome %s',[ANomeParametro]);
  end;

  Result := Ret;
end;

function TCustomSqlDataSetHelper.DefinirParametro(out Msg: String;
  IndiceParametro: Integer; AValor: Variant; ATipoAtributo: tfieldtype;
  ATipoParametro: TParamType): Boolean;
Var
  Parametro: TParam;
  Ret: Boolean;
begin
  //Ret retorna o resultado (result) se o índice passado no parâmetro é válido
  Msg := EmptyStr;
  with self do
  begin
    Ret := (IndiceParametro >= 0) and (IndiceParametro < Params.Count);
    if Ret then
    begin
      Parametro := Params[IndiceParametro];
      //Definindo dados do prâmetro
      Self.DefinirParametro(Parametro,AValor,ATipoAtributo, ATipoParametro);
    end;
  end;

   //definindo mensagem quando parâmetor não localizado.
  if Not Ret then
  begin
    Msg := Format('Não foi localizado o parâmetro de índice %d',[indiceParametro]);
  end;

  Result := Ret;

end;
function TCustomSqlDataSetHelper.DefinirParametro(out Msg: String;
  ListaParametros: TListaIBParam): Boolean;
Var
  i: Integer;
  Item: IBaseBuscaParametro;
  Falha: Boolean;
  AuxMsg: String;
  RetMsg: TStringList;
  Valor: Variant;
  Tipo: TFieldType;
  TipoPar: TParamType;
  TipoBusca: TTipoBuscaParametro;
  IndiceParametro: Integer;
  Nomeparametro: String;
begin
  RetMsg := TStringList.Create;
  Falha := False;
  Try
    Try
      for i := 0 to ListaParametros.Count -1 do
      begin
        AuxMsg := EmptyStr;
        item := ListaParametros[i] as IBaseBuscaParametro;
        IndiceParametro := -1;
        Nomeparametro := EmptyStr;
        Valor := item.Valor;
        Tipo := Item.TipoDado;
        TipoPar := Item.TipoParametro;
        TipoBusca := Item.TipoBusca;

        case TipoBusca of
          TTipoBuscaParametro.Indice:
            begin
              IndiceParametro := IBParamIndice(Item).Parametro;
              if Not (Self.DefinirParametro(AuxMsg,IndiceParametro,Valor,Tipo,TipoPar)) then
              begin
                Falha := True;
                RetMsg.Add(AuxMsg);
              end;
            end;
          TTipoBuscaParametro.Nome:
            begin
              Nomeparametro := IBParamNome(Item).Parametro;
              if Not (Self.DefinirParametro(AuxMsg,Nomeparametro,Valor,Tipo,TipoPar)) then
              begin
                Falha := True;
                RetMsg.Add(AuxMsg);
              end;
            end ;
        end;
      end;
      if Falha then
        raise  EParametroNaoLocalizado.Create(RetMsg.Text);
    Except
      On E: Exception do
      begin
        TratamentoExcecao(e);
      end;
    End;
  Finally
    if Assigned(RetMsg) then
    begin
      Msg := RetMsg.Text;
      RetMsg.Free;
    end;
    Result := Not Falha;
  End;
end;

end.

