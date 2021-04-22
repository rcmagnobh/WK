unit uClasses.DAO.RTTI.CampoRtti;

interface
uses
  uClasses.Types.AtributosCustomizados,
  System.Rtti;


Type
  TCampoRtti = Class
  Private
    FNome: String;
    FObrigatorio: Boolean;
    FChvPrimaria: Boolean;
    FChvEstrangeira: Boolean;
    FTipoDado: TTipoDado;
    FOwner: TRttiProperty;
    procedure IdentificarAtributos;
    procedure Processar;
    procedure Inicializar;
    function TipoDadoValido: Boolean;
  Public
    Constructor Create(Const Owner: TRttiProperty);
    Property Nome: String Read FNome;
    Property Obrigatorio: Boolean Read FObrigatorio;
    Property ChvPrimaria: Boolean Read FChvPrimaria;
    Property ChvEstrangeira: Boolean Read FChvEstrangeira;
    Property TipoDado: TTipoDado Read FTipoDado;
    function Valido: Boolean;
  End;

implementation

uses
  System.SysUtils;

{ TCampoRtti }

procedure TCampoRtti.IdentificarAtributos;
Var
  Atb:  TCustomAttribute;
begin
  for Atb in FOwner.GetAttributes do
  begin
    if Atb.ClassNameIs(CANOMECAMPO) then
    begin
      FNome := TNomeCampo(Atb).Nome;
    end
    else if Atb.ClassNameIs(CATIPODADO) then
    begin
      FTipoDado := TCTipoDado(Atb).Value;
    end
    else if Atb.ClassNameIs(CACHVPRIMARIA) then
    begin
      FChvPrimaria := True;
    end
    else if Atb.ClassNameIs(CACHVESTRANGEIRA) then
    begin
      FChvEstrangeira := True
    end
    else if Atb.ClassNameIs(CAOBRIGATORIO) then
    begin
      FObrigatorio := True;
    end;
  end;
  if Not FObrigatorio then
  begin
    FObrigatorio := (FChvPrimaria or  FChvEstrangeira);
  end;
end;

constructor TCampoRtti.Create(const Owner: TRttiProperty);
begin
  FOwner := Owner;
  Inicializar;
  Processar;
end;

procedure TCampoRtti.Inicializar;
begin
  FNome:= EmptyStr;
  FObrigatorio:= False;
  FChvPrimaria:= False;
  FChvEstrangeira:= False;
  FTipoDado:= TtipoDado.ftUnknown;
end;

procedure TCampoRtti.Processar;
begin
  IdentificarAtributos;
end;

function TCampoRtti.TipoDadoValido: Boolean;
begin
  Result := (FTipoDado in TDVALIDOS) AND (Not (FTipoDado in TDINDEFINIDO));
end;

function TCampoRtti.Valido: Boolean;
Var
  NomeValido: Boolean;
begin
  NomeValido := Length(Trim(FNome)) > 1;
  Result := (NomeValido and TipoDadoValido);
end;

end.
