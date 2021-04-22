unit uClasses.Types.AtributosCustomizados;

interface

uses
  Data.DB;

Type
{$SCOPEDENUMS ON}
  TTipoDado = TFieldType;
{$SCOPEDENUMS OFF}

Const
  TDVALIDOS = [TTipoDado.ftstring .. TTipoDado.ftWord,
    TTipoDado.ftBoolean .. TTipoDado.ftCurrency,
    TTipoDado.ftDate .. TTipoDado.ftDateTime, TTipoDado.ftMemo,
    TTipoDado.ftLargeint, TTipoDado.ftVariant, TTipoDado.ftWideMemo,
    TTipoDado.ftLongWord, TTipoDado.ftShortint, TTipoDado.ftByte,
    TTipoDado.ftExtended, TTipoDado.ftSingle, TTipoDado.ftUnknown];

  TDSTRING = [TTipoDado.ftstring, TTipoDado.ftMemo, TTipoDado.ftWideString, TTipoDado.ftWideMemo];

  TDINTEIRO = [TTipoDado.ftByte, TTipoDado.ftInteger, TTipoDado.ftLargeint,
    TTipoDado.ftLongWord, TTipoDado.ftSmallint, TTipoDado.ftShortint,
    TTipoDado.ftWord];

  TDFLOAT = [TTipoDado.ftByte, TTipoDado.ftInteger, TTipoDado.ftLargeint,
    TTipoDado.ftLongWord, TTipoDado.ftSmallint, TTipoDado.ftShortint,
    TTipoDado.ftWord, TTipoDado.ftFloat, TTipoDado.ftExtended,
    TTipoDado.ftSingle];

  TDCURRENCY = [TTipoDado.ftByte, TTipoDado.ftInteger, TTipoDado.ftLargeint,
    TTipoDado.ftLongWord, TTipoDado.ftSmallint, TTipoDado.ftShortint,
    TTipoDado.ftWord, TTipoDado.ftFloat, TTipoDado.ftExtended,
    TTipoDado.ftSingle, TTipoDado.ftCurrency];

  TDBOOLEANO = [TTipoDado.ftBoolean];
  TDVARIANT = [TTipoDado.ftVariant];
  TDINDEFINIDO = [TTipoDado.ftUnknown];
Type
  TObrigatorio = class(TCustomAttribute);
  TChvPrimaria = class(TObrigatorio);
  TChvEstrangeira = class(TObrigatorio);

Type
  TNomeEntidade = class(TCustomAttribute)
  Private
    FNome: String;
  public
    Constructor Create(Const Value: String);
    property Nome: String Read FNome;
  end;

  TNomeCampo = class(TCustomAttribute)
  Private
    FNome: String;
  public
    Constructor Create(Const Value: String);
    property Nome: String Read FNome;
  end;

  TCTipoDado = class(TCustomAttribute)
  Private
    FValue: TTipoDado;
    procedure SetValue(const Value: TTipoDado);
  Public
    Constructor Create(Const Value: TTipoDado);
    property Value: TTipoDado read FValue write SetValue;
  end;

Const
  CAOBRIGATORIO: String = 'TObrigatorio';
  CACHVPRIMARIA: String = 'TChvPrimaria';
  CACHVESTRANGEIRA: String = 'TChvEstrangeira';
  CANOMEENTIDADE: String = 'TNomeEntidade';
  CANOMECAMPO: String = 'TNomeCampo';
  CATIPODADO: String = 'TCTipoDado';

implementation

{ TNomeEntidade }

constructor TNomeEntidade.Create(Const Value: String);
begin
  FNome := Value;
end;

{ TNomeCampo }

constructor TNomeCampo.Create(Const Value: String);
begin
  FNome := Value;
end;

{ TCTipoDado }

constructor TCTipoDado.Create(const Value: TTipoDado);
begin
  FValue := Value;
end;

procedure TCTipoDado.SetValue(const Value: TTipoDado);
begin
  FValue := Value;
end;

end.
