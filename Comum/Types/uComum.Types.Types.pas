unit uComum.Types.Types;

interface

uses
  System.SysUtils;

Type
{$SCOPEDENUMS ON}
  TOpCrud = (Criar, Recuperar, Atualizar, Apagar);
{$SCOPEDENUMS OFF}
Type
  TArrayStrings = array of string;
  TProcComRetorno = reference to procedure (Out aBoolean: Boolean);
  TProcCdsLocation = reference to procedure (Out aBoolean: Boolean; NomeCampo: String; aValue: Variant);
Const
  MASCARADECIMAL: String = '#0.00';
  MASCARAMOEDA: String = '#,###,###,##0.00';
  MASCARADATA: String = 'dd/mm/yyyy';
implementation



end.
