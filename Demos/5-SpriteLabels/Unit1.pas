unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,math,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Generics.Collections ,Generics.Defaults,
  JvSpriteEngine;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    JvTheater1: TJvTheater;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure JvTheater1SpriteDestinationReached(Sender: TObject; ASprite: TJvSprite);
    procedure JvTheater1BeforeRender(Sender: TObject; VirtualBitmap: TBitmap);
  private
    { Private declarations }
    function GetIsoDirection (X1,Y1,X2,Y2:integer): integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  gabriel,shahira: Tbitmap;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  Background,SpriteTree: Tjvsprite;
begin

  Background:= JvTheater1.CreateSprite('..\..\..\!media\back1.bmp','background',{framesX}1,{framesY}1,{Delay}0,{X}0,{Y}0,{transparent}false,{Priority}0);
  Background.Position := Point( Background.FrameWidth div 2 , Background.FrameHeight div 2 );

  JvTheater1.Active := True;

  gabriel := TBitmap.Create;
  gabriel.LoadFromFile( '..\..\..\!media\gabriel_WALK.bmp');

  shahira := TBitmap.Create;
  shahira.LoadFromFile( '..\..\..\!media\shahira_WALK.bmp');

  JvTheater1.CreateSprite(gabriel ,'gabriel',{framesX}15,{framesY}6,{Delay}7,{X}100,{Y}100,{transparent}true,{Priority}1);
  JvTheater1.CreateSprite(shahira,'shahira',{framesX}15,{framesY}6,{Delay}7,{X}200,{Y}100,{transparent}true,{Priority}1);

  SpriteTree := JvTheater1.CreateSprite('..\..\..\!media\tree.bmp','tree',{framesX}2,{framesY}1,{Delay}5,{X}250,{Y}250,{transparent}true,{Priority}2);

  gabriel.Free;
  shahira.Free;

  Randomize;

end;
function TForm1.GetIsoDirection (X1,Y1,X2,Y2:integer): integer;
begin

  if (X2 = X1) and (Y2 = Y1) then Result:=1

  else if (X2 = X1) and (Y2 < Y1) then Result:=4
  else if (X2 = X1) and (Y2 > Y1) then Result:=1

  else if (X2 < X1) and (Y2 < Y1) then Result:=5
  else if (X2 > X1) and (Y2 < Y1) then Result:=3

  else if (X2 > X1) and (Y2 > Y1) then Result:=2
  else if (X2 < X1) and (Y2 > Y1) then Result:=6

  else if (X2 > X1) and (Y2 = Y1) then Result:=3
  else if (X2 < X1) and (Y2 = Y1) then Result:=5;


end;

procedure TForm1.JvTheater1BeforeRender(Sender: TObject; VirtualBitmap: TBitmap);
var
  SpriteGabriel,SpriteShahira,SpriteTree: Tjvsprite;
  I: Integer;
begin

   SpriteGabriel:= JvTheater1.FindSprite('gabriel');
   SpriteShahira:= JvTheater1.FindSprite('shahira');
  if SpriteGabriel.MoverData.MovePath.Count > 0 then begin
    VirtualBitmap.Canvas.Pen.Color := clSilver;

    VirtualBitmap.Canvas.MoveTo( SpriteGabriel.MoverData.MovePath[0].X,SpriteGabriel.MoverData.MovePath[0].Y );
    for I := 1 to SpriteGabriel.MoverData.MovePath.Count -1 do begin
     VirtualBitmap.Canvas.LineTo( SpriteGabriel.MoverData.MovePath[i].X,SpriteGabriel.MoverData.MovePath[i].Y );
    end;

  end;
  if SpriteShahira.MoverData.MovePath.Count > 0 then begin
    VirtualBitmap.Canvas.Pen.Color := clRed;

    VirtualBitmap.Canvas.MoveTo( SpriteShahira.MoverData.MovePath[0].X,SpriteShahira.MoverData.MovePath[0].Y );
    for I := 1 to SpriteShahira.MoverData.MovePath.Count -1 do begin
     VirtualBitmap.Canvas.LineTo( SpriteShahira.MoverData.MovePath[i].X,SpriteShahira.MoverData.MovePath[i].Y );
    end;

  end;

  // ISO Priority
  SpriteTree:= JvTheater1.FindSprite('tree');
  SpriteGabriel.Priority := SpriteGabriel.Position.Y;
  SpriteShahira.Priority := SpriteShahira.Position.Y;
  SpriteTree.Priority := SpriteTree.Position.Y + 170;

end;

procedure TForm1.JvTheater1SpriteDestinationReached(Sender: TObject; ASprite: TJvSprite);
begin
  aSprite.MoverData.MovePath.Reverse ;
  aSprite.NotifyDestinationReached := True;
  aSprite.MoverData.UseMovePath := True;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  SpriteGabriel, SpriteShahira: Tjvsprite;
  Point,Point2,lastPoint :Tpoint;
  tmpPath: TList<TPoint>;
  I,wayPoints: Integer;
begin

   SpriteGabriel:= JvTheater1.FindSprite('gabriel');
   SpriteGabriel.PositionX := 100;
   SpriteGabriel.PositionY := 100;
   SpriteGabriel.MoverData.MovePath.Clear ;


   LastPoint := SpriteGabriel.Position;

   for WayPoints := 0 to 6 do begin
     Point.X:= randomrange ( 100,500);
     Point.Y:= randomrange ( 100,500);

     tmpPath:= TList<TPoint>.Create;
     GetLinePoints( LastPoint.X, LastPoint.Y,  Point.X, Point.Y,  tmpPath );

     for I := 0 to tmpPath.Count -1 do begin
       Point2:=tmpPath[i];
       SpriteGabriel.MoverData.MovePath.Add(Point2);
     end;
     LastPoint := Point;
     tmpPath.Free ;


   end;

   SpriteGabriel.MoverData.UseMovePath := True;
   SpriteGabriel.MoverData.Speed := 1.0;  // minimum usepath
   SpriteGabriel.MoverData.WPinterval  := 50; // delay
   SpriteGabriel.NotifyDestinationReached := True;


   SpriteShahira:= JvTheater1.FindSprite('shahira');
   SpriteShahira.PositionX := 500;
   SpriteShahira.PositionY := 100;
   SpriteShahira.MoverData.MovePath.Clear ;


   LastPoint := SpriteShahira.Position;

   for WayPoints := 0 to 6 do begin
     Point.X:= randomrange ( 100,500);
     Point.Y:= randomrange ( 100,500);

     tmpPath:= TList<TPoint>.Create;
     GetLinePoints( LastPoint.X, LastPoint.Y,  Point.X, Point.Y,  tmpPath );

     for I := 0 to tmpPath.Count -1 do begin
       Point2:=tmpPath[i];
       SpriteShahira.MoverData.MovePath.Add(Point2);
     end;
     LastPoint := Point;
     tmpPath.Free ;


   end;

   SpriteShahira.MoverData.UseMovePath := True;
   SpriteShahira.MoverData.Speed := 1.0;  // minimum usepath
   SpriteShahira.MoverData.WPinterval  := 50; // delay
   SpriteShahira.NotifyDestinationReached := True;


end;

procedure TForm1.Button2Click(Sender: TObject);
var
  SpriteGabriel, SpriteShahira: Tjvsprite;
  SpriteLabel : TjvspriteLabel;
begin

   SpriteGabriel:= JvTheater1.FindSprite('gabriel');
   SpriteShahira:= JvTheater1.FindSprite('shahira');

   SpriteGabriel.labels.Clear ;

   SpriteLabel := TjvspriteLabel.create(0,64,'Verdana',clYellow,clBlack,'Gabriel',pmCopy,True);
   SpriteGabriel.Labels.Add(SpriteLabel);

   SpriteShahira.labels.Clear ;

   SpriteLabel := TjvspriteLabel.create(0,64,'Verdana',clYellow,clBlack,'Shahira',pmCopy,True);
   SpriteShahira.Labels.Add(SpriteLabel);

end;


procedure TForm1.Timer1Timer(Sender: TObject);
var
  SpriteGabriel, SpriteShahira: Tjvsprite;
begin

   SpriteGabriel:= JvTheater1.FindSprite('gabriel');
   SpriteShahira:= JvTheater1.FindSprite('shahira');



   if SpriteGabriel.MoverData.CurWP < SpriteGabriel.MoverData.MovePath.Count -1 then begin
   SpriteGabriel.FrameY :=  GetIsoDirection ( SpriteGabriel.Position.X, SpriteGabriel.Position.Y,
                                              SpriteGabriel.MoverData.MovePath [ SpriteGabriel.MoverData.CurWP +1].X ,
                                              SpriteGabriel.MoverData.MovePath [ SpriteGabriel.MoverData.CurwP +1].Y);
   end;
   if SpriteShahira.MoverData.CurwP < SpriteShahira.MoverData.MovePath.Count -1 then begin
   SpriteShahira.FrameY :=  GetIsoDirection ( SpriteShahira.Position.X, SpriteShahira.Position.Y,
                                              SpriteShahira.MoverData.MovePath [ SpriteShahira.MoverData.CurWP +1].X ,
                                              SpriteShahira.MoverData.MovePath [ SpriteShahira.MoverData.CurwP +1].Y);
   end;

end;

end.
