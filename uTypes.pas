unit uTypes;

interface

uses
  System.UITypes, System.SysUtils, System.Types, Winapi.Windows,
  System.Generics.Defaults, System.Generics.Collections;

type
  TPos = record
  private
    FX, FY: Single;
  public
    constructor Create(AX, AY: Single);

    property X: Single read FX write FX;
    property Y: Single read FY write FY;
  end;

  TVector2d = record
  private
    FX, FY: Single;
    procedure SetX(AValue: Single);
    procedure SetY(AValue: Single);
  public
    constructor Create(AX, AY: Single);
    function Magnitude: Single;
    function Normalize: TVector2d;

    property X: Single read FX write SetX;
    property Y: Single read FY write SetY;
  end;

  TRGB = record
  private
    FR, FG, FB: Byte;
  public
    constructor Create(AR, AG, AB: Byte);
    function ToColor: TColor;

    property R: Byte read FR write FR;
    property G: Byte read FG write FG;
    property B: Byte read FB write FB;
  end;

implementation

constructor TPos.Create(AX, AY: Single);
begin
  FX := AX;
  FY := AY;
end;

constructor TVector2d.Create(AX, AY: Single);
begin
  FX := AX;
  FY := AY;
end;

constructor TRGB.Create(AR, AG, AB: Byte);
begin
  FR := AR;
  FG := AG;
  FB := AB;
end;

function TRGB.ToColor: TColor;
begin
  Result := RGB(FR, FG, FB);
end;

function TVector2d.Magnitude: Single;
begin
  Result := Sqrt(FX * FX + FY * FY);
end;

function TVector2d.Normalize: TVector2d;
var
  Magn: Single;
begin
  Magn := Magnitude;
  FX := FX / Magn;
  FY := FY / Magn;
  Result := Self;
end;

procedure TVector2d.SetX(AValue: Single);
begin
  FX := AValue;
end;

procedure TVector2d.SetY(AValue: Single);
begin
  FY := AValue;
end;

end.
