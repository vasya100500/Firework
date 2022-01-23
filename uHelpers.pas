unit uHelpers;

interface

uses
  System.SysUtils;

type
  TSingleHelper = record helper for Single
  private
  public
    function Add(AValue: Single): Single; overload;
    function Add(AValue: Single; ACondition: Boolean): Single; overload;
    function Mult(AValue: Single): Single;
  end;

  TIntegerHelper = record helper for Integer
  private
  public
    function Inc(AValue: Integer = 1): Integer;
    function Dec(AValue: Integer = 1): Integer;
    function ToString: string;
  end;

  TBooleanHelper = record helper for Boolean
  private
  public
    function False: Boolean;
    function True: Boolean;
  end;

implementation

{ TSingleHelper }

function TSingleHelper.Add(AValue: Single): Single;
begin
  Self := Self + AValue;
  Result := Self;
end;

function TSingleHelper.Add(AValue: Single; ACondition: Boolean): Single;
begin
  if ACondition then
    Result := Add(AValue)
  else
    Result := Self;
end;

function TSingleHelper.Mult(AValue: Single): Single;
begin
  Self := Self * AValue;
  Result := Self;
end;

{ TIntegerHelper }

function TIntegerHelper.Inc(AValue: Integer = 1): Integer;
begin
  Self := Self + AValue;
  Result := Self;
end;

function TIntegerHelper.ToString: string;
begin
  Result := IntToStr(Self);
end;

function TIntegerHelper.Dec(AValue: Integer = 1): Integer;
begin
  Self := Self - AValue;
  Result := Self;
end;

{ TBooleanHelper }

function TBooleanHelper.False: Boolean;
begin
  Self := System.False;
  Result := Self;
end;

function TBooleanHelper.True: Boolean;
begin
  Self := System.True;
  Result := Self;
end;

end.
