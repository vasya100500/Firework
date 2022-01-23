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
    Particle.Pos.X.Inc(Particle.Velocity.X);
    Particle.Pos.Y.Inc(Particle.Velocity.Y);
    Particle.Velocity.X.Inc(-Particle.Velocity.X * FFriction * Particle.Size);
    Particle.Velocity.Y.Inc(-Particle.Velocity.Y * FFriction * Particle.Size);
    Particle.Velocity.Y.Inc(FGravity);
    Particle.Size.Inc(Particle.ExpansionRate, Particle.Size <= Particle.MaxSize);
    Particle.LifeTime.Dec(1);

    if Particle.LifeTime = 0 then
      Particle.Visible.False;
  end;
end;

end.
