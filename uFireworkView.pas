unit uFireworkView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFireworkModel, uFireworkController,
  Vcl.ExtCtrls, uTypes, System.Math, uHelpers,
  System.Generics.Defaults, System.Generics.Collections, Vcl.AppEvnts;

type
  TBallPatern = (BP_Red, BP_Green, BP_Blue, BP_White, BP_LGBT);

  TfmFireworkView = class(TForm)
    TimerBallController: TTimer;
    TimerNewBall: TTimer;
    TimerShowFPS: TTimer;
    ApplicationEvents1: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerBallControllerTimer(Sender: TObject);
    procedure TimerNewBallTimer(Sender: TObject);
    procedure TimerShowFPSTimer(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    FFPS: Integer;
    FBallController: TBallController;
    FBallList: TObjectList<TBall>;
    procedure CreateBall(APos: TPos; APartCount: Integer; ABallPatern: TBallPatern);
    procedure Draw;
  public
  end;

var
  fmFireworkView: TfmFireworkView;

implementation

{$R *.dfm}

procedure TfmFireworkView.FormCreate(Sender: TObject);
begin
  Randomize;

  FBallList := TObjectList<TBall>.Create;

  FBallController := TBallController.Create;
  FBallController.Friction := 0.02;
  FBallController.Gravity := 0.1;

  FFPS := 0;
end;

procedure TfmFireworkView.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FBallList);
  FreeAndNil(FBallController);
end;

procedure TfmFireworkView.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  Draw;
end;

procedure TfmFireworkView.CreateBall(APos: TPos; APartCount: Integer; ABallPatern: TBallPatern);
var
  Particle: TParticle;
  iBall: Integer;
  i: Integer;
  Color: TRGB;
  Speed: Single;
begin
  iBall := FBallList.Add(TBall.Create(APos));

  for i := 1 to APartCount do
  begin
    case ABallPatern of
      BP_White : begin
        Particle := TParticle.Create(
          TPos.Create(0, 0),
          TRGB.Create(RandomRange(200, 255), RandomRange(200, 255), RandomRange(200, 255))
        );

        Particle.ExpansionRate := 0.5;
        Particle.MaxSize := 20;
        Particle.LifeTime := 100 + Random(50);
      end;

      BP_Red, BP_Green, BP_Blue, BP_LGBT: begin
        if i < APartCount / 10 then
        begin
          Particle := TParticle.Create(
            TPos.Create(0, 0),
            TRGB.Create(150, 150, 150)
          );
        end
        else
        begin
          case ABallPatern of
            BP_Red: Color := TRGB.Create(RandomRange(200, 255), 100, 100);
            BP_Green: Color := TRGB.Create(100, RandomRange(200, 255), 100);
            BP_Blue: Color := TRGB.Create(100, 100, RandomRange(200, 255));
            BP_LGBT: Color := TRGB.Create(RandomRange(100, 255), RandomRange(100, 255), RandomRange(100, 255));
          end;
          Particle := TParticle.Create(
            TPos.Create(0, 0),
            Color
          );
        end;

        Particle.ExpansionRate := 0.1;
        Particle.MaxSize := 10;
        Particle.LifeTime := 70 + Random(30);
      end;
    end;

    Particle.Velocity.X := Random - 0.5;
    Particle.Velocity.Y := Random - 0.5;
    Particle.Velocity.Normalize;
    Speed := RandomRange(500, 1000) / 100;
    Particle.Velocity.X.Mult(Speed);
    Particle.Velocity.Y.Mult(Speed);

    FBallList[iBall].AddParticle(Particle);
  end;
end;

procedure TfmFireworkView.Draw;
  procedure RGBColors(Bitmap: TBitmap; AR, AG, AB: Integer);
    function Limit(AValue: Integer): Byte;
    begin
      if AValue < 0 then
        Result := 0
      else
      if AValue > 255 then
        Result := 255
      else
        Result := AValue;
    end;

  var
    x, y: Integer;
    Dest: pRGBTriple;
  begin
    for y := 0 to Bitmap.Height - 1 do
    begin
      Dest := Bitmap.ScanLine[y];
      for x := 0 to Bitmap.Width - 1 do
      begin
        with Dest^ do
        begin
          if (rgbtBlue <> 0) or (rgbtGreen <> 0) or (rgbtRed <> 0) then
          begin
            rgbtBlue := Limit(rgbtBlue + AB);
            rgbtGreen := Limit(rgbtGreen + AG);
            rgbtRed := Limit(rgbtRed + AR);
          end;
        end;
        Inc(Dest);
      end;
    end;
  end;

var
  i: Integer;
  Ball: TBall;
  Particle: TParticle;
  ScreenBMP: TBitmap;
  BallLife: Boolean;
begin
  ScreenBMP := TBitmap.Create;
  try
    ScreenBMP.Width := Self.ClientWidth;
    ScreenBMP.Height := Self.ClientHeight;
    ScreenBMP.PixelFormat := pf24bit;

    ScreenBMP.Canvas.Brush.Color := clBlack;
    ScreenBMP.Canvas.Pen.Color := clBlack;
    ScreenBMP.Canvas.FillRect(
      Rect(
        0,
        0,
        ScreenBMP.Width,
        ScreenBMP.Height
      )
    );

    ScreenBMP.Canvas.CopyRect(ScreenBMP.Canvas.ClipRect, Self.Canvas, Self.Canvas.ClipRect);
//    if FFPS mod 5 = 0 then
      RGBColors(ScreenBMP, -10, -10, -10);

    for i := FBallList.Count - 1 downto 0 do
    begin
      Ball := FBallList[i];
      BallLife.False;
      for Particle in Ball.ParticlesList do
      begin
        if Particle.Visible then
        begin
          BallLife.True;

          ScreenBMP.Canvas.Brush.Color := Particle.Color.ToColor;
          ScreenBMP.Canvas.Pen.Color := Particle.Color.ToColor;
          ScreenBMP.Canvas.Ellipse(
            Rect(
              Round(Ball.Pos.X + Particle.Pos.X - (Particle.Size / 2)),
              Round(Ball.Pos.Y + Particle.Pos.Y - (Particle.Size / 2)),
              Round(Ball.Pos.X + Particle.Pos.X + (Particle.Size / 2)),
              Round(Ball.Pos.Y + Particle.Pos.Y + (Particle.Size / 2))
            )
          );
        end;
      end;

      if not BallLife then
        FBallList.Delete(i);
    end;

    Self.Canvas.CopyRect(Self.Canvas.ClipRect, ScreenBMP.Canvas, ScreenBMP.Canvas.ClipRect);

    FFPS.Inc;
  finally
    FreeAndNil(ScreenBMP);
  end;
end;

procedure TfmFireworkView.TimerBallControllerTimer(Sender: TObject);
var
  Ball: TBall;
begin
  TimerBallController.Enabled.False;
  try
  for Ball in FBallList do
    FBallController.Step(Ball);
  finally
    TimerBallController.Enabled.True;
  end;
end;

procedure TfmFireworkView.TimerShowFPSTimer(Sender: TObject);
begin
  Self.Caption := 'FPS ' + FFPS.ToString;
  FFPS := 0;
end;

procedure TfmFireworkView.TimerNewBallTimer(Sender: TObject);
begin
  TimerNewBall.Interval := RandomRange(300, 2000);

  CreateBall(
    TPos.Create(
      RandomRange(100, Self.ClientWidth - 100),
      RandomRange(100, Self.ClientHeight - 300)
    ),
    RandomRange(100, 300),
    TBallPatern(RandomRange(0, 5))
  );
end;

end.
