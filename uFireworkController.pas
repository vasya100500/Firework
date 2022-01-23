unit uFireworkController;

interface

uses
  System.UITypes, System.SysUtils, System.Types,
  System.Generics.Defaults, System.Generics.Collections,
  uTypes, uHelpers, uFireworkModel;

type
  TBallController = class
  private
    FFriction: Single;
    FGravity: Single;
  public
    procedure Step(ABall: TBall);

    property Friction: Single read FFriction write FFriction;
    property Gravity: Single read FGravity write FGravity;
  end;

implementation

procedure TBallController.Step(ABall: TBall);
var
  Particle: TParticle;
begin
  for Particle in ABall.ParticlesList do
  begin
    Particle.Pos.X.Add(Particle.Velocity.X);
    Particle.Pos.Y.Add(Particle.Velocity.Y);
    Particle.Velocity.X.Add(-Particle.Velocity.X * FFriction * Particle.Size);
    Particle.Velocity.Y.Add(-Particle.Velocity.Y * FFriction * Particle.Size);
    Particle.Velocity.Y.Add(FGravity);
    Particle.Size.Add(Particle.ExpansionRate, Particle.Size <= Particle.MaxSize);
    Particle.LifeTime.Dec(1);

    if Particle.LifeTime = 0 then
      Particle.Visible.False;
  end;
end;

end.
