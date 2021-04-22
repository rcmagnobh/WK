unit uHelpers.DS.BuscaParametros;

interface
uses
  DB,
  DataSnap.DBClient,
  System.SysUtils,
  uComum.Types.Types,
  Data.SqlExpr,
  System.Generics.Collections, System.Classes;

{$Region 'Tipo Customizados'}
Type
{$SCOPEDENUMS ON}
  TTipoBuscaParametro = (Indice, Nome);
{$SCOPEDENUMS OFF}
{$Endregion}
Type
{$Region 'Prototipagem de interfaces'}
  IBaseBuscaParametro = Interface;
  IBParamNome = Interface;
  IBParamIndice = Interface;
{$Endregion}
{$Region 'Interfaces'}
  IBaseBuscaParametro = Interface
  ['{DDA241FC-E81F-4DB3-AAFA-4037AA78DC62}']
    function Valor(Const Value: Variant):IBaseBuscaParametro ;overload;
    function Valor: Variant;overload;
    function TipoDado(Const Value: TFieldType):IBaseBuscaParametro;overload;
    function TipoDado: TFieldType;overload;
    function TipoParametro(Const Value: TParamType):IBaseBuscaParametro;overload;
    function TipoParametro: TParamType;overload;
    function Falha: Boolean;overload;
    function Falha(Const Value: Boolean):IBaseBuscaParametro;overload;
    function TipoBusca: TTipoBuscaParametro;
  End;

  IBParamNome = Interface(IBaseBuscaParametro)
  ['{5328258F-9656-4288-B149-BA4A2B577991}']
    function Parametro(Const Value: String):IBParamNome;overload;
    function Parametro: String;overload;
  End;

  IBParamIndice = Interface(IBaseBuscaParametro)
  ['{F859E30F-B3F7-422A-A5CF-B63D8DBD3037}']
    function Parametro(Const Value: Integer):IBParamIndice;overload;
    function Parametro: Integer;overload;
  End;
{$Endregion}
{$Region 'Declaração de classes'}
  TBaseBuscaParametro = class(TInterfacedObject, IBaseBuscaParametro)
  Private
    FValor: Variant;
    FTipoDado: TFieldType;
    FTipoParametro: TParamType;
    FFalha: Boolean;
    FTipoBusca: TTipoBuscaParametro;
  public
    Constructor Create(Const TipoBusca: TTipoBuscaParametro; Const TipoParamentro: TParamType = ptInput);
    function Valor(Const Value: Variant):IBaseBuscaParametro ;overload;
    function Valor: Variant;overload;
    function TipoDado(Const Value: TFieldType):IBaseBuscaParametro;overload;
    function TipoDado: TFieldType;overload;
    function TipoParametro(Const Value: TParamType):IBaseBuscaParametro;overload;
    function TipoParametro: TParamType;overload;
    function Falha: Boolean;overload;
    function Falha(Const Value: Boolean):IBaseBuscaParametro;overload;
    function TipoBusca: TTipoBuscaParametro;
  end;

  TBIndice = class(TBaseBuscaParametro,IBParamIndice)
  Private
    FParametro: Integer;
  public
    Constructor Create(Const TipoParamentro: TParamType = ptInput);
    function Parametro(Const Value: Integer):IBParamIndice;overload;
    function Parametro: Integer;overload;
  end;

  TBNome = class(TBaseBuscaParametro,IBParamNome)
  Private
    FParametro: String;
  public
    Constructor Create(Const TipoParamentro: TParamType = ptInput);
    function Parametro(Const Value: String):IBParamNome;overload;
    function Parametro: String;overload;
  end;
{$Endregion}
{$Region 'Tipos de dados'}
Type
  TListaIBParam = TinterfaceList;
{$Endregion}

implementation

{ TBIndice }

constructor TBIndice.Create(const TipoParamentro: TParamType);
begin
  inherited Create(TTipoBuscaParametro.Indice,TipoParametro);
end;
function TBIndice.Parametro(const Value: Integer): IBParamIndice;
begin
  Result := IBParamIndice(Self);
  self.FParametro := Value;
end;

function TBIndice.Parametro: Integer;
begin
  Result := FParametro;
end;

{ TBNome }
constructor TBNome.Create(const TipoParamentro: TParamType);
begin
  Inherited Create(TTipoBuscaParametro.Nome, TipoParamentro)
end;
function TBNome.Parametro(const Value: String): IBParamNome;
begin
  Result := Self;
  FParametro := Value;
end;

function TBNome.Parametro: String;
begin
  Result := FParametro;
end;
{ TBaseBuscaParametro }

constructor TBaseBuscaParametro.Create(Const TipoBusca: TTipoBuscaParametro; const TipoParamentro: TParamType);
begin
  FTipoBusca := TipoBusca;
  FTipoParametro := TipoParamentro;
end;

function TBaseBuscaParametro.Falha(const Value: Boolean): IBaseBuscaParametro;
begin
  Result := Self;
  FFalha := Value;
end;

function TBaseBuscaParametro.Falha: Boolean;
begin
  Result := FFalha;
end;

function TBaseBuscaParametro.TipoBusca: TTipoBuscaParametro;
begin
  Result := FTipoBusca;
end;

function TBaseBuscaParametro.TipoDado: TFieldType;
begin
  Result := FTipoDado;
end;

function TBaseBuscaParametro.TipoDado(
  const Value: TFieldType): IBaseBuscaParametro;
begin
  Result := Self;
  FTipoDado := Value;
end;

function TBaseBuscaParametro.TipoParametro: TParamType;
begin
  Result := FTipoParametro;
end;

function TBaseBuscaParametro.TipoParametro(
  const Value: TParamType): IBaseBuscaParametro;
begin
  Result := Self;
  FTipoParametro := Value;
end;

function TBaseBuscaParametro.Valor: Variant;
begin
  Result := FValor;
end;

function TBaseBuscaParametro.Valor(const Value: Variant): IBaseBuscaParametro;
begin
  Result := Self;
  FValor := Value
end;

end.
