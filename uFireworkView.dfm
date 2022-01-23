object fmFireworkView: TfmFireworkView
  Left = 0
  Top = 0
  Caption = 'Fireworks'
  ClientHeight = 800
  ClientWidth = 1200
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TimerBallController: TTimer
    Interval = 20
    OnTimer = TimerBallControllerTimer
    Left = 112
    Top = 72
  end
  object TimerNewBall: TTimer
    Interval = 100
    OnTimer = TimerNewBallTimer
    Left = 208
    Top = 72
  end
  object TimerShowFPS: TTimer
    OnTimer = TimerShowFPSTimer
    Left = 296
    Top = 72
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 112
    Top = 160
  end
end
