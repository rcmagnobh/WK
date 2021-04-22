unit uClasses.DAO.BaseDAO;

interface

uses
  Data.SqlExpr,
  Data.DB,
  uComum.Types.Types,
  System.Rtti,
  System.Classes,
  uClasses.Types.AtributosCustomizados,
  uClasses.DAO.RTTI.CampoRtti,
  uClasses.DAO.ConexaoDB.DMConexaoDB,
  uHelpers.DS.BuscaParametros,
  Data.DBXCommon;

Type
  TBaseDAO<T:class> = class
  Private
    FConexao: TDMConexaoDB;
    FSqlQuery: TSQLDataSet;
    FOwner: T;
    FTransacao: TDBXTransaction;
  private
    FLstIParametros: TInterfaceList;
    function ObterNomeEntidade(Const Atributo: TNomeEntidade): String;
    function ValidarTipoAtributo(Const Atributo: TCustomAttribute; TipoProcurado: TClass): Boolean;
    function ProblemaSql(Const Value: String):Boolean;
  protected
    FAtivarTransacao: Boolean;
    function ObterSqlExclusao: String;
    function ObterValorStrSql(const prop: TRttiProperty; Campo: TCampoRtti): String;
    function IdentificarCampo(Const Prop: TRttiProperty): TCampoRtti;
    function SqlDelete: String;virtual;abstract;
    function SqlUpDate: String;virtual;abstract;
    function SqlInsert: String;virtual;abstract;
    function SqlSelect: String;virtual;abstract;
    procedure IniciarTransacao;
    procedure CancelarTransacao;
    procedure ConfirmarTransacao;
    procedure EncerrarTransacao(Const Falha: Boolean);
  Public
    Constructor Create(Owner: T);
    destructor Destroy;override;
    property SqlQuery: TSQLDataSet Read FSqlQuery Write FSqlQuery;
    property Owner: T Read FOwner;
    property LstIParametros: TInterfaceList read FLstIParametros Write  FLstIParametros;
    function AtribuirInstrucaoSql(Const Value: String; TipoDs: TPSCommandType): Boolean;
    function NovoParametroNome: TBNome;
    function NovoParametroIndice: TBIndice;
    function AplicarParametros(Out Msg: String): Boolean;
    procedure AdicionarParametroQuery(Indice: Integer; Valor: Variant; TipoDado: TFieldType; TipoParametro: TParamType = ptInput);overload;
    procedure AdicionarParametroQuery(NomeParametro: String; Valor: Variant; TipoDado: TFieldType; TipoParametro: TParamType = ptInput);overload;
    function AtribuirInstrucaoSegSql(Const Value: String; TipoDs: TPSCommandType = ctQuery): Boolean;
    function ExcecutarConsulta(Processo: TProcComRetorno):Boolean;virtual;
    procedure DesativarDS;
  end;

implementation

uses
  System.SysUtils,
  uComum.Lib.TratamentoExcecao,
  System.Variants,
  uHelpers.DS.HelpersDS;

{ TBaseDAO }
procedure TBaseDAO<T>.CancelarTransacao;
begin
  if Assigned(FTransacao) then
    FConexao.SQLConnection1.RollbackFreeAndNil(FTransacao);
end;

procedure TBaseDAO<T>.EncerrarTransacao(const Falha: Boolean);
begin
  if Falha then
    CancelarTransacao
  else
    ConfirmarTransacao;
end;

procedure TBaseDAO<T>.ConfirmarTransacao;
begin
  if Assigned(FTransacao) then
    FConexao.SQLConnection1.CommitFreeAndNil(FTransacao);
end;

constructor TBaseDAO<T>.Create(Owner: T);
begin
  FOwner := Owner;
  FConexao := TDMConexaoDB.Create(nil);
  FSqlQuery := TSQLDataSet.Create(nil);
  FConexao.Conectar(true);
  FSqlQuery.SQLConnection := FConexao.GetConnection;
  FLstIParametros := TInterfaceList.Create;
  FTransacao := nil;
end;

destructor TBaseDAO<T>.Destroy;
begin
  FLstIParametros.Clear;
  if FSqlQuery.Active then
    FSqlQuery.Close;
  FSqlQuery.Free;
  if Assigned(FTransacao) then
    FTransacao.Free;
  FConexao.Conectar(False);
  FConexao.Free;
  FLstIParametros.Free;
  inherited;
end;
procedure TBaseDAO<T>.AdicionarParametroQuery(Indice: Integer; Valor: Variant;
  TipoDado: TFieldType; TipoParametro: TParamType);
begin
  NovoParametroIndice.Parametro(Indice).Valor(Valor).TipoDado(TipoDado).TipoParametro(TipoParametro);
end;

procedure TBaseDAO<T>.AdicionarParametroQuery(NomeParametro: String;
  Valor: Variant; TipoDado: TFieldType; TipoParametro: TParamType);
begin
  NovoParametroNome.Parametro(NomeParametro).Valor(Valor).TipoDado(TipoDado).TipoParametro(TipoParametro);
end;

function TBaseDAO<T>.AplicarParametros(Out Msg: String): Boolean;
begin
  Result := SqlQuery.DefinirParametro(Msg,LstIParametros);
end;

function TBaseDAO<T>.AtribuirInstrucaoSegSql(const Value: String;
  TipoDs: TPSCommandType): Boolean;
Var
  ProblemaSql: Boolean;
begin
  ProblemaSql := Length(Trim(Value)) < 10;
  Try
    if ProblemaSql then
      raise EDAOFalhaSql.Create(Format('Instrução mal formada [%s]',[Value]));
    DesativarDS;
    AtribuirInstrucaoSql(Value,TipoDs);
    Result := True;
  Except
    On E: Exception do
    begin
      Exit(False);
    end;
  End;
end;

function TBaseDAO<T>.AtribuirInstrucaoSql(Const Value: String; TipoDs: TPSCommandType): Boolean;
begin
  Self.SqlQuery.CommandType := TipoDs;
  Self.SqlQuery.CommandText := EmptyStr;
  Self.SqlQuery.CommandText := Value;
end;

procedure TBaseDAO<T>.DesativarDS;
begin
  if Self.FSqlQuery.Active then
    Self.FSqlQuery.Close;
end;

function TBaseDAO<T>.ExcecutarConsulta(Processo: TProcComRetorno): Boolean;
Var
  Ret: Boolean;
begin
  Try
    Try
      if FAtivarTransacao then
        IniciarTransacao;
      //chamada do método anônimo
      Processo(Ret);
      if FAtivarTransacao then
        ConfirmarTransacao;
    Except
      On e: Exception do
      begin
        Ret := False;
        TratamentoExcecao(e);
        if FAtivarTransacao then
          CancelarTransacao;
      end;
    end;
  Finally
    if FSqlQuery.Active then
      FSqlQuery.Close;
    Result := Ret;
  End;
end;

function TBaseDAO<T>.IdentificarCampo(const Prop: TRttiProperty): TCampoRtti;
begin
  Result := TCampoRtti.Create(Prop);
end;

procedure TBaseDAO<T>.IniciarTransacao;
begin
  if FAtivarTransacao then  
    FTransacao := FConexao.SQLConnection1.BeginTransaction;
end;

function TBaseDAO<T>.NovoParametroIndice: TBIndice;
Var
  Parametro: TBIndice;
begin
  Parametro := TBIndice.Create;
  Result  := Parametro;
  FLstIParametros.Add(Parametro);
end;

function TBaseDAO<T>.NovoParametroNome: TBNome;
Var
  Parametro: TBNome;
begin
  Parametro := TBNome.Create;
  Result  := Parametro;
  FLstIParametros.Add(Parametro);
end;

function TBaseDAO<T>.ObterNomeEntidade(const Atributo: TNomeEntidade): String;
begin
  Result := Atributo.Nome;
end;

function TBaseDAO<T>.ObterSqlExclusao: String;
Var
  Ctx: TRttiContext;
  Ctyp: TRttiType;
  CProp: TRttiProperty;
  Atb: TCustomAttribute;
  Sql, Instrucao, Condicao: TStringBuilder;
  Entidade: String;
  Ret: String;
  Continua: Boolean;
  Campo: TCampoRtti;
  cField: TRttiField;
  s: String;
begin
  Sql := TStringBuilder.Create;
  Instrucao := TStringBuilder.Create;
  Condicao := TStringBuilder.Create;
  Ret := EmptyStr;
  Try
    Entidade := EmptyStr;

    Ctx := TRttiContext.Create;
    Ctyp := Ctx.GetType(TObject(FOwner).ClassType);

    //Obtendo o nome da entidade
    for Atb in Ctyp.GetAttributes do
    begin
      if Atb.ClassNameIs(CANOMEENTIDADE) then
      begin
         Entidade := TNomeEntidade(Atb).Nome;
         Break;
      end;
    end;

    //Avaliando se continua: se não houver nome da entidade a operação deve ser cancelada.
    Continua  := Length(Trim(Entidade)) > 0;

    //Montar SQL
    if Continua then
    begin
      Instrucao.Clear;
      Instrucao.Append('DELETE FROM ').Append(Entidade);
      Condicao.Clear;
      for cField in Ctyp.GetFields do
      begin
        cField.GetValue(TObject(FOwner).ClassType).ToString;
        Campo := Nil;
        Campo := IdentificarCampo(CProp);


        if Campo.Valido then
        begin
          if Campo.ChvPrimaria or Campo.ChvEstrangeira then
          begin
            Condicao.Append(campo.Nome).Append(' = ');
            if (Campo.TipoDado in TDSTRING) or (Campo.TipoDado in TDVARIANT) then
            begin
              Condicao.Append(Quotedstr(ObterValorStrSql(CProp,Campo)));
            end
            else begin
              Condicao.Append(ObterValorStrSql(CProp,Campo));
            end;
            Condicao.Append(' AND ');
          end;
        end;
      end;
      //REMOVENDO AND
      Condicao.Remove(Condicao.Length -5,5);

      Sql.Clear;
      Sql.Append(Instrucao.ToString).Append(' WHERE ').Append(Condicao.ToString);
      Ret := Sql.ToString
    end;
  Finally
    if Assigned(Campo) then
      Campo.Free;
    if Assigned(Sql) then
      Sql.Free;
    if Assigned(Instrucao) then
      Instrucao.Free;
    if Assigned(Condicao) then
      Condicao.Free;
    Result := Ret;
  End;
end;

function TBaseDAO<T>.ObterValorStrSql(const prop: TRttiProperty;
  Campo: TCampoRtti): String;
Var
  Ret: String;
  s: String;
  ACurrency: Currency;
  ADouble: Double;
  AInteger: Integer;
  ABoolean: Boolean;
begin
  S := prop.GetValue(TObject(FOwner).ClassType).ToString;
  Ret := EmptyStr;
  if Campo.TipoDado in TDSTRING then
  begin
    Ret := prop.GetValue(TObject(FOwner).ClassType).ToString;
  end
  else if Campo.TipoDado in TDINTEIRO then
  begin
    Ret :=  IntToStr(prop.GetValue(TObject(FOwner).ClassType).AsInteger);
  end
  else if Campo.TipoDado in TDFLOAT then
  begin
    if TryStrToFloat(s,ADouble) then
      Ret := s;
  end
  else if Campo.TipoDado in TDCURRENCY then
  begin
    if TryStrToCurr(s,ACurrency) then
      Ret := s;
  end
  else if Campo.TipoDado in TDBOOLEANO then
  begin
    if TryStrToBool(s,ABoolean) then
      Ret := s;
  end
  else if Campo.TipoDado in TDVARIANT then
  begin
      Ret := VarToStrDef(s,'');
  end;
  Result := Ret;
end;

function TBaseDAO<T>.ProblemaSql(const Value: String): Boolean;
Var
  s: String;
begin
  s := StringReplace(Value,'DELETE FROM ',' ',[rfIgnoreCase]);
  S := StringReplace(s,'UPDATE ',' ',[rfIgnoreCase, rfReplaceAll]);
  s := StringReplace(s,'INSERT INTO ',' ',[rfIgnoreCase]);
  s := StringReplace(s,'SELECT ',' ',[rfIgnoreCase, rfReplaceAll]);
  s := StringReplace(s,' FROM ',' ',[rfIgnoreCase, rfReplaceAll]);
end;

function TBaseDAO<T>.ValidarTipoAtributo(const Atributo: TCustomAttribute;  TipoProcurado: TClass): Boolean;
begin
  Result := Atributo is TipoProcurado;
end;

end.
