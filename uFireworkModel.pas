unit uFireworkModel;

interface

uses
  System.UITypes, System.SysUtils, System.Types,
  System.Generics.Defaults, System.Generics.Collections,
  uTypes, uHelpers;

type
  TParticle = class
  private
    FSize: Single;
    FMaxSize: Single;
    FColor: TRGB;
    FPos: TPos;
    FVelocity: TVector2d;
    FExpansionRate: Single;
    FLifeTime: Integer;
    FVisible: Boolean;
  public
    constructor Create(APos: TPos; AColor: TRGB; ASize: Single = 1);
    property Size: Single read FSize write FSize;
    property MaxSize: Single read FMaxSize write FMaxSize;
    property Color: TRGB read FColor write FColor;
    property Pos: TPos read FPos write FPos;
    property Velocity: TVector2d read FVelocity write FVelocity;
    property ExpansionRate: Single read FExpansionRate write FExpansionRate; // скорость увеличения размера частицы
    property LifeTime: Integer read FLifeTime write FLifeTime; // Время жизни в тиках обработки
    property Visible: Boolean read FVisible write FVisible;
  end;

  TBall = class
  private
    FPos: TPos;
    FDistance: Single;
    FParticlesList: TObjectList<TParticle>;
  public
    constructor Create(APos: TPos);
    destructor Destroy; override;
    function AddParticle(AParticle: TParticle): Integer;
    procedure AddParticleMass(AParticle: TParticle; ACount: Integer = 1);
    property Pos: TPos read FPos write FPos;
    property Distance: Single read FDistance write FDistance;
    property ParticlesList: TObjectList<TParticle> read FParticlesList;
  end;

implementation

constructor TParticle.Create(APos: TPos; AColor: TRGB; ASize: Single);
begin
  FPos := APos;
  FColor := AColor;
  FSize := ASize;
  FMaxSize := 10;
  FVelocity := TVector2d.Create(0, 0);
  FPos := TPos.Create(0, 0);
  FExpansionRate := 0;
  FLifeTime := 0;
  FVisible.True;
end;

function TBall.AddParticle(AParticle: TParticle): Integer;
begin
  Result := FParticlesList.Add(AParticle);
end;

procedure TBall.AddParticleMass(AParticle: TParticle; ACount: Integer);
var
  i: Integer;
begin
  AddParticle(AParticle);

  for i := 2 to ACount do
  begin
    AddParticle(TParticle.Create(AParticle.Pos, AParticle.Color, AParticle.Size));
  end;
end;

constructor TBall.Create(APos: TPos);
begin
  FPos := APos;
  FDistance := 1;
  FParticlesList := TObjectList<TParticle>.Create;
end;

destructor TBall.Destroy;
begin
  FreeAndNil(FParticlesList);
  inherited;
end;


end.
