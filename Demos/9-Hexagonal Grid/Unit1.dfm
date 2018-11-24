object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'JvSpriteEngine - Hexagonal Grid'
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
    Left = 480
    Top = 606
    Width = 105
    Height = 25
    Caption = 'Set Sprite Cell XY'
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
    OnMouseMove = JvTheater1MouseMove
    ClickSprites = True
    ClickSpritesPrecise = True
    CollisionPrecisePixel = False
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 591
    Top = 608
    Width = 50
    Height = 21
    NumbersOnly = True
    TabOrder = 2
    Text = '20'
  end
  object Edit2: TEdit
    Left = 647
    Top = 609
    Width = 50
    Height = 21
    NumbersOnly = True
    TabOrder = 3
    Text = '18'
  end
  object Panel1: TPanel
    Left = 16
    Top = 606
    Width = 137
    Height = 51
    TabOrder = 4
    object Label1: TLabel
      Left = 15
      Top = 0
      Width = 28
      Height = 13
      Caption = 'CellsX'
    end
    object Label2: TLabel
      Left = 87
      Top = 0
      Width = 28
      Height = 13
      Caption = 'CellsY'
    end
    object Edit3: TEdit
      Left = 1
      Top = 19
      Width = 50
      Height = 21
      NumbersOnly = True
      TabOrder = 0
      Text = '30'
    end
    object Edit4: TEdit
      Left = 72
      Top = 19
      Width = 50
      Height = 21
      NumbersOnly = True
      TabOrder = 1
      Text = '40'
    end
  end
  object Panel2: TPanel
    Left = 176
    Top = 606
    Width = 249
    Height = 51
    TabOrder = 5
    object Label3: TLabel
      Left = 15
      Top = 0
      Width = 50
      Height = 13
      Caption = 'Hex Width'
    end
    object Label4: TLabel
      Left = 87
      Top = 0
      Width = 53
      Height = 13
      Caption = 'Hex Height'
    end
    object Label5: TLabel
      Left = 167
      Top = 0
      Width = 77
      Height = 13
      Caption = 'Hex Small Width'
    end
    object Edit5: TEdit
      Left = 15
      Top = 19
      Width = 50
      Height = 21
      NumbersOnly = True
      TabOrder = 0
      Text = '40'
    end
    object Edit6: TEdit
      Left = 88
      Top = 19
      Width = 50
      Height = 21
      NumbersOnly = True
      TabOrder = 1
      Text = '30'
    end
    object Edit7: TEdit
      Left = 178
      Top = 19
      Width = 50
      Height = 21
      NumbersOnly = True
      TabOrder = 2
      Text = '20'
    end
  end
  object Memo1: TMemo
    Left = 728
    Top = 606
    Width = 185
    Height = 99
    Lines.Strings = (
      '')
    TabOrder = 6
  end
end
