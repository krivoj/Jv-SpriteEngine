unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Generics.Collections ,Generics.Defaults, JvSpriteEngine ;

type
  TForm1 = class(TForm)
    JvTheater1: TJvTheater;
    procedure FormCreate(Sender: TObject);
    procedure JvTheater1SpriteClick(Sender: TObject; lstSprite: TObjectList<JvSpriteEngine.TJvSprite>; Button: TMouseButton;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  Background: TJvSprite;
begin

  Background:= JvTheater1.CreateSprite('..\..\..\!media\back1.bmp','background',{framesX}1,{framesY}1,{Delay}0,{X}0,{Y}0,{transparent}false,{Priority}0);
  Background.Position := Point( Background.FrameWidth div 2 , Background.FrameHeight div 2 );

  JvTheater1.Active := True;

  JvTheater1.CreateSprite('..\..\..\!media\arrow1.bmp','arrow1',{framesX}1,{framesY}1,{Delay}0,{X}100,{Y}560,{transparent}false,{Priority}1);
  JvTheater1.CreateSprite('..\..\..\!media\arrow2.bmp','arrow2',{framesX}1,{framesY}1,{Delay}0,{X}134,{Y}560,{transparent}false,{Priority}1);
  JvTheater1.CreateSprite('..\..\..\!media\arrow3.bmp','arrow3',{framesX}1,{framesY}1,{Delay}0,{X}134,{Y}524,{transparent}false,{Priority}1);
  JvTheater1.CreateSprite('..\..\..\!media\arrow4.bmp','arrow4',{framesX}1,{framesY}1,{Delay}0,{X}100,{Y}524,{transparent}false,{Priority}1);
  JvTheater1.CreateSprite('..\..\..\!media\arrow5.bmp','arrow5',{framesX}1,{framesY}1,{Delay}0,{X}66,{Y}524,{transparent}false,{Priority}1);
  JvTheater1.CreateSprite('..\..\..\!media\arrow6.bmp','arrow6',{framesX}1,{framesY}1,{Delay}0,{X}66,{Y}560,{transparent}false,{Priority}1);

  JvTheater1.CreateSprite('..\..\..\!media\gabriel_IDLE.1.bmp','gabriel',{framesX}15,{framesY}1,{Delay}5,{X}200,{Y}200,{transparent}true,{Priority}1);
  JvTheater1.CreateSprite('..\..\..\!media\shahira_IDLE.1.bmp','shahira',{framesX}15,{framesY}1,{Delay}5,{X}300,{Y}300,{transparent}true,{Priority}1);



end;
procedure TForm1.JvTheater1SpriteClick(Sender: TObject; lstSprite: TObjectList<JvSpriteEngine.TJvSprite>; Button: TMouseButton;
  Shift: TShiftState);
var
  SpriteGabriel, SpriteShahira: TJvSprite;
begin
   SpriteGabriel:= JvTheater1.FindSprite('gabriel');
   SpriteShahira:= JvTheater1.FindSprite('shahira');

    if lstSprite[0].Guid = 'arrow1' then begin
      SpriteGabriel.ChangeBitmap('..\..\..\!media\gabriel_IDLE.1.bmp',{framesX}15,{framesY}1,{Delay}5);
      SpriteShahira.ChangeBitmap('..\..\..\!media\shahira_IDLE.1.bmp',{framesX}15,{framesY}1,{Delay}5);
    end
    else if lstSprite[0].Guid = 'arrow2' then begin
      SpriteGabriel.ChangeBitmap('..\..\..\!media\gabriel_IDLE.2.bmp',{framesX}15,{framesY}1,{Delay}5);
      SpriteShahira.ChangeBitmap('..\..\..\!media\shahira_IDLE.2.bmp',{framesX}15,{framesY}1,{Delay}5);
    end
    else if lstSprite[0].Guid = 'arrow3' then begin
      SpriteGabriel.ChangeBitmap('..\..\..\!media\gabriel_IDLE.3.bmp',{framesX}15,{framesY}1,{Delay}5);
      SpriteShahira.ChangeBitmap('..\..\..\!media\shahira_IDLE.3.bmp',{framesX}15,{framesY}1,{Delay}5);
    end
    else if lstSprite[0].Guid = 'arrow4' then begin
      SpriteGabriel.ChangeBitmap('..\..\..\!media\gabriel_IDLE.4.bmp',{framesX}15,{framesY}1,{Delay}5);
      SpriteShahira.ChangeBitmap('..\..\..\!media\shahira_IDLE.4.bmp',{framesX}15,{framesY}1,{Delay}5);
    end
    else if lstSprite[0].Guid = 'arrow5' then begin
      SpriteGabriel.ChangeBitmap('..\..\..\!media\gabriel_IDLE.5.bmp',{framesX}15,{framesY}1,{Delay}5);
      SpriteShahira.ChangeBitmap('..\..\..\!media\shahira_IDLE.5.bmp',{framesX}15,{framesY}1,{Delay}5);
    end
    else if lstSprite[0].Guid = 'arrow6' then begin
      SpriteGabriel.ChangeBitmap('..\..\..\!media\gabriel_IDLE.6.bmp',{framesX}15,{framesY}1,{Delay}5);
      SpriteShahira.ChangeBitmap('..\..\..\!media\shahira_IDLE.6.bmp',{framesX}15,{framesY}1,{Delay}5);
    end


end;


end.
