unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,math,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DSE_theater, Vcl.ExtCtrls, Vcl.StdCtrls, Generics.Collections ,Generics.Defaults, DSE_Bitmap,
  DSE_ThreadTimer;

type
  TForm1 = class(TForm)
    SE_Theater1: SE_Theater;
    SE_Background: SE_Engine;
    SE_Characters: SE_Engine;
    Panel1: TPanel;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Panel2: TPanel;
    Label2: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Edit2: TEdit;
    SE_ThreadTimer1: SE_ThreadTimer;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure SE_Theater1TheaterMouseMove(Sender: TObject; VisibleX, VisibleY, VirtualX, VirtualY: Integer; Shift: TShiftState);
    procedure SE_ThreadTimer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SE_CharactersSpriteDestinationReached(ASprite: SE_Sprite);
  private
    { Private declarations }
    function GetIsoDirection (X1,Y1,X2,Y2:integer): integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  gabriel,shahira: SE_BITMAP;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  Background: SE_Sprite;
begin

  SE_Theater1.VirtualWidth := 1920;
  SE_Theater1.VirtualHeight := 1200;
  SE_Theater1.Width := 1024;
  SE_Theater1.Height := 600;

  SE_Background.Priority := 0;
  SE_Characters.Priority := 1;


  Background:= SE_Background.CreateSprite('..\..\..\!media\back1.bmp','background',{framesX}1,{framesY}1,{Delay}0,{X}0,{Y}0,{transparent}false);
  Background.Position := Point( Background.FrameWidth div 2 , Background.FrameHeight div 2 );

  SE_Theater1.Active := True;

  gabriel :=  SE_BITMAP.Create ( '..\..\..\!media\gabriel_WALK.bmp');
  shahira :=  SE_BITMAP.Create ( '..\..\..\!media\shahira_WALK.bmp');

  SE_Characters.CreateSprite(gabriel.Bitmap ,'gabriel',{framesX}15,{framesY}6,{Delay}7,{X}100,{Y}100,{transparent}true);
  SE_Characters.CreateSprite(shahira.Bitmap,'shahira',{framesX}15,{framesY}6,{Delay}7,{X}200,{Y}100,{transparent}true);
  gabriel.Free;
  shahira.Free;

  Randomize;

end;




function TForm1.GetIsoDirection (X1,Y1,X2,Y2:integer): integer;
begin

  if (X2 = X1) and (Y2 = Y1) then Result:=1;

  if (X2 = X1) and (Y2 < Y1) then Result:=4;
  if (X2 = X1) and (Y2 > Y1) then Result:=1;

  if (X2 < X1) and (Y2 < Y1) then Result:=5;
  if (X2 > X1) and (Y2 < Y1) then Result:=3;

  if (X2 > X1) and (Y2 > Y1) then Result:=2;
  if (X2 < X1) and (Y2 > Y1) then Result:=6;

  if (X2 > X1) and (Y2 = Y1) then Result:=3;
  if (X2 < X1) and (Y2 = Y1) then Result:=5;


end;

procedure TForm1.SE_CharactersSpriteDestinationReached(ASprite: SE_Sprite);
begin
  ShowMessage( ASprite.Guid + ' reached destination point.');
end;

procedure TForm1.SE_Theater1TheaterMouseMove(Sender: TObject; VisibleX, VisibleY, VirtualX, VirtualY: Integer; Shift: TShiftState);
var
  SpriteGabriel, SpriteShahira: SE_Sprite;
begin

   SpriteGabriel:= SE_Characters.FindSprite('gabriel');
   SpriteShahira:= SE_Characters.FindSprite('shahira');

   SpriteGabriel.MoverData.Destination := Point(VirtualX, VirtualY);
   SpriteShahira.MoverData.Destination := Point(VirtualX, VirtualY);
   SpriteGabriel.NotifyDestinationReached := True;
   SpriteShahira.NotifyDestinationReached := True;

   SpriteGabriel.MoverData.Speed := 2.0;
   SpriteShahira.MoverData.Speed := 2.0;

end;

procedure TForm1.SE_ThreadTimer1Timer(Sender: TObject);
var
  SpriteGabriel, SpriteShahira: SE_Sprite;
begin

   SpriteGabriel:= SE_Characters.FindSprite('gabriel');
   SpriteShahira:= SE_Characters.FindSprite('shahira');
   SpriteGabriel.FrameY :=  GetIsoDirection ( SpriteGabriel.Position.X, SpriteGabriel.Position.Y,
                                              SpriteGabriel.MoverData.Destination.X,SpriteGabriel.MoverData.Destination.Y);
   SpriteShahira.FrameY :=  GetIsoDirection ( SpriteShahira.Position.X, SpriteShahira.Position.Y,
                                              SpriteShahira.MoverData.Destination.X,SpriteShahira.MoverData.Destination.Y);

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  SpriteGabriel, SpriteShahira: SE_Sprite;
begin

   SpriteGabriel:= SE_Characters.FindSprite('gabriel');
   SpriteShahira:= SE_Characters.FindSprite('shahira');
   SpriteGabriel.PositionX := 100;
   SpriteGabriel.PositionY := randomrange ( 50,580);
   SpriteShahira.PositionX := 1000;
   SpriteShahira.PositionY := randomrange ( 50,580);


end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  SE_Theater1.MousePan := checkBox1.Checked ;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  SE_Theater1.MouseScroll := checkBox2.Checked ;

end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  SE_Theater1.MouseWheelZoom  :=  checkBox3.Checked ;
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  SE_Theater1.MouseWheelInvert  := checkBox4.Checked ;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  SE_Theater1.MouseScrollRate  := StrToFloatDef ( edit1.Text ,0 );

end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  SE_Theater1.MouseWheelValue  := StrToIntDef ( edit2.Text ,0 );

end;

end.
