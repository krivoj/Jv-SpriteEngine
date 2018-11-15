object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'jvSpriteEngine - SpriteMove usepath'
  ClientHeight = 722
  ClientWidth = 1032
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 520
    Top = 616
    Width = 105
    Height = 25
    Caption = 'build random Path'
    TabOrder = 0
    OnClick = Button1Click
  end
  object JvTheater1: TJvTheater
    Left = 0
    Top = 0
    Width = 1024
    Height = 600
    AnimationInterval = 20
    CollisionDelay = 0
    ShowPerformance = False
    OnBeforeRender = JvTheater1BeforeRender
    ClickSprites = False
    ClickSpritesPrecise = False
    CollisionPrecisePixel = False
    OnSpriteDestinationReached = JvTheater1SpriteDestinationReached
    TabOrder = 1
  end
  object Timer1: TTimer
    Interval = 300
    OnTimer = Timer1Timer
    Left = 160
    Top = 656
  end
end
