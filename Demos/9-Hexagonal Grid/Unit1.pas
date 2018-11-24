unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,math,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Generics.Collections ,Generics.Defaults,
  JvSpriteEngine;

  type  TPointArray7 = array[0..6] of TPoint;

  type THexCellSize = record
    Width : Integer;
    Height : Integer;
    SmallWidth : Integer;
  end;

type
  TForm1 = class(TForm)
    Button1: TButton;
    JvTheater1: TJvTheater;
    Edit1: TEdit;
    Edit2: TEdit;
    Panel1: TPanel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label5: TLabel;
    Edit7: TEdit;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure JvTheater1BeforeRender(Sender: TObject; VirtualBitmap: TBitmap);
    procedure Button1Click(Sender: TObject);
    procedure JvTheater1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    function GetIsoDirection (X1,Y1,X2,Y2:integer): integer;
    procedure DrawHexCell(  VirtualBitmap: TBitmap; AOffSet : TPoint; AHexCellSize : THexCellSize; ACol, ARow : Integer );
    function GetHexDrawPoint( AHexCellSize : THexCellSize; ACol, ARow : Integer ) : TPoint;
    function GetHexCellPoints( AOffSet : TPoint; AHexCellSize : THexCellSize; ACol, ARow : Integer ):TpointArray7;
    procedure UnMap(const DisplayX: Integer; const DisplayY: Integer; out WorldX: Single;  out WorldY: Single);
    procedure Map(const WorldX: Single; const WorldY: Single; const Center: boolean; out DisplayX: Integer; out DisplayY: Integer);
    procedure DrawGrid  ( VirtualBitmap:TBitmap ) ;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  gabriel,shahira: Tbitmap;
  AHexCellSize: THexCellSize;
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
  DrawGrid  ( VirtualBitmap );


  // ISO Priority
  SpriteGabriel:= JvTheater1.FindSprite('gabriel');
  SpriteShahira:= JvTheater1.FindSprite('shahira');

  SpriteTree:= JvTheater1.FindSprite('tree');
  SpriteGabriel.Priority := SpriteGabriel.Position.Y;
  SpriteShahira.Priority := SpriteShahira.Position.Y;
  SpriteTree.Priority := SpriteTree.Position.Y + 170;

end;

procedure TForm1.JvTheater1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  CellX, CellY: Single;
begin
  UnMap(  X, Y, CellX, CellY );
  Memo1.Lines.Add( 'MouseMove Cells: '  +  IntToStr( Trunc (CellX)) + '.' + IntToStr(Trunc(CellY)) );

  if Memo1.Lines.Count > 100 then
    memo1.Lines.Clear;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  SpriteGabriel: Tjvsprite;
  X,Y: Integer;
  Value: TPoint;
begin

  Value.X := StrToIntDef( Edit1.Text,0 );
  Value.Y := StrToIntDef( Edit2.Text,0 );

  SpriteGabriel:= JvTheater1.FindSprite('gabriel');
  Map( Trunc(Value.X), Trunc(Value.Y), true, X, Y  );

  SpriteGabriel.Position := Point (X,Y);

end;

procedure TForm1.DrawHexCell( VirtualBitmap: TBitmap; AOffSet : TPoint; AHexCellSize : THexCellSize; ACol, ARow : Integer );
var
  LPoint : TPoint;
  LXOffset : Integer;
begin
  { *************
    *   1---2
    *  /     \
    * 6       3
    *  \     /
    *   5---4
    ************* }

  LXOffset := ( AHexCellSize.Width - AHexCellSize.SmallWidth ) div 2;

  // Move to point 1
  LPoint := GetHexDrawPoint( AHexCellSize, ACol, ARow );
  LPoint.Offset( AOffSet );
  VirtualBitmap.Canvas.MoveTo( LPoint.X, LPoint.Y );

  VirtualBitmap.Canvas.Brush.Style := bsSolid;

  // Line to point 2
  LPoint.Offset( AHexCellSize.SmallWidth, 0 );
  VirtualBitmap.Canvas.LineTo( LPoint.X, LPoint.Y );

  // Line to point 3
  LPoint.Offset( LXOffset, AHexCellSize.Height div 2 );
  VirtualBitmap.Canvas.LineTo( LPoint.X, LPoint.Y );
  // Line to point 4
  LPoint.Offset( -LXOffset, AHexCellSize.Height div 2 );
  VirtualBitmap.Canvas.LineTo( LPoint.X, LPoint.Y );
  // Line to point 5
  LPoint.Offset( -AHexCellSize.SmallWidth, 0 );
  VirtualBitmap.Canvas.LineTo( LPoint.X, LPoint.Y );
  // Line to point 6
  LPoint.Offset( -LXOffset, -AHexCellSize.Height div 2 );
  VirtualBitmap.Canvas.LineTo( LPoint.X, LPoint.Y );
  // Line to point 1
  LPoint.Offset( LXOffset, -AHexCellSize.Height div 2 );
  VirtualBitmap.Canvas.LineTo( LPoint.X, LPoint.Y );
end;
function TForm1.GetHexDrawPoint( AHexCellSize : THexCellSize; ACol, ARow : Integer ) : TPoint;
begin
  Result.X := ( ( AHexCellSize.Width - AHexCellSize.SmallWidth ) div 2 + AHexCellSize.SmallWidth ) * ACol;
  Result.Y := AHexCellSize.Height * ARow + ( AHexCellSize.Height div 2 ) * ( ACol mod 2 );
end;

function TForm1.GetHexCellPoints( AOffSet : TPoint; AHexCellSize : THexCellSize; ACol, ARow : Integer ):TpointArray7;
var
  LPoint : TPoint;
  LXOffset : Integer;
begin
  LXOffset := ( AHexCellSize.Width - AHexCellSize.SmallWidth ) div 2;

  // Move to point 1
  LPoint := GetHexDrawPoint( AHexCellSize, ACol, ARow );
  LPoint.Offset( AOffSet );
  Result[0]:=Lpoint;
  // Line to point 2
  LPoint.Offset( AHexCellSize.SmallWidth, 0 );
  Result[1]:=Lpoint;
  // Line to point 3
  LPoint.Offset( LXOffset, AHexCellSize.Height div 2 );
  Result[2]:=Lpoint;
  // Line to point 4
  LPoint.Offset( -LXOffset, AHexCellSize.Height div 2 );
  Result[3]:=Lpoint;
  // Line to point 5
  LPoint.Offset( -AHexCellSize.SmallWidth, 0 );
  Result[4]:=Lpoint;
  // Line to point 6
  LPoint.Offset( -LXOffset, -AHexCellSize.Height div 2 );
  Result[5]:=Lpoint;
  // Line to point 1
  LPoint.Offset( LXOffset, -AHexCellSize.Height div 2 );
  Result[6]:=Lpoint;


end;

procedure TForm1.UnMap(const DisplayX: Integer; const DisplayY: Integer; out WorldX: Single;  out WorldY: Single);
var
  PtPoly: TpointArray7;
  x,y: integer;
  PolyHandle: HRGN;
  inside: boolean;

begin
  AHexCellSize.Width := StrToIntDef(Edit5.text,0);
  AHexCellSize.Height := StrToIntDef(Edit6.text,0);
  AHexCellSize.SmallWidth := StrToIntDef(Edit7.text,0);


    inside:= false;
    for x := 0 to  StrToIntDef(Edit3.text,0) -1 do begin
      for y := 0 to StrToIntDef(Edit4.text,0)-1 do begin

        PtPoly := GetHexCellPoints( Point(0,0), AHexCellSize , x, y  );

        PolyHandle := CreatePolygonRgn(PtPoly[0],length(Ptpoly),Winding);
        inside     := PtInRegion(PolyHandle,DisplayX,DisplayY);
        DeleteObject(PolyHandle);
        if inside then begin
          worldX:=X;
          worldY:=Y;
          exit;
        end;

      end;
    end;

    if not Inside then begin
      WorldX := -1;
      WorldY := -1;

    end;

end;

procedure TForm1.Map(const WorldX: Single; const WorldY: Single; const Center: boolean; out DisplayX: Integer; out DisplayY: Integer);

begin
  AHexCellSize.Width := StrToIntDef(Edit5.text,0);
  AHexCellSize.Height := StrToIntDef(Edit6.text,0);
  AHexCellSize.SmallWidth := StrToIntDef(Edit7.text,0);


    if Center then begin
      DisplayX:= GethexDrawPoint ( aHexCellSize, round(WorldX), round(WorldY)).x    +  (aHexCellSize.SmallWidth div 2);
      DisplayY:= GethexDrawPoint ( aHexCellSize, round(WorldX), round(WorldY)).y    +  (aHexCellSize.Height  div 2);
    end
    else begin
      DisplayX:= GethexDrawPoint ( aHexCellSize, round(WorldX), round(WorldY)).x ;
      DisplayY:= GethexDrawPoint ( aHexCellSize, round(WorldX), round(WorldY)).y ;
    end;
end;
procedure TForm1.DrawGrid  ( VirtualBitmap:TBitmap ) ;
var
  x,y: Integer;
  AHexCellSize: THexCellSize;

begin

  AHexCellSize.Width := StrToIntDef(Edit5.text,0);
  AHexCellSize.Height := StrToIntDef(Edit6.text,0);
  AHexCellSize.SmallWidth := StrToIntDef(Edit7.text,0);

  VirtualBitmap.Canvas.Pen.Style:= psSolid;
  VirtualBitmap.Canvas.pen.Color:= ClSilver;

  for y:= 0 to StrToIntDef(Edit4.text,0) -1 do
    for x := 0 to StrToIntDef(Edit3.text,0) -1 - 1 do
      DrawHexCell( VirtualBitmap, Point(0,0), AHexCellSize, x, y );
end;

end.
