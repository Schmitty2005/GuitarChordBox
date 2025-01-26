unit ChordBoxCanvas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Types, GuitarChordBoxCoordinates;

type
  TChordBoxCanvas = class(TGuitarChordBoxCoOrds)
  private
    placeholder: boolean;
  public
    function DrawOnCanvas(aCanvas: TCanvas): boolean;
  end;

procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TlinePoints);
procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TstrPnts); overload;
procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TfrtPnts); overload;
procedure Normalize(var aRect: Trect);
function centeredRect(const ARect: TRect; const bRect: TRect): TRect;
procedure addMarker(aPoint: Tpoint; aCanvas: TCanvas; txtLbl : String ; pxSize : Integer = 50);
procedure moveRectCenter(var aRect: Trect; aNewCenter: Tpoint); inline;


implementation

function centeredRect(const ARect: TRect; const bRect: TRect): TRect;
var
  aCenter: TPoint;
  outerSize, innerSize: TSize;
  xNew, yNew: longint;
begin
  outerSize := Size(ARect);
  innerSize := Size(bRect);

  if innerSize.cx > outerSize.cx then
    innerSize.cx := outerSize.cx;

  if innerSize.cy > outerSize.cy then
    innerSize.cy := outerSize.cy;

  aCenter := centerpoint(ARect);
  xNew := aCenter.x - round(innerSize.cx div 2);
  yNew := aCenter.y - round(innerSize.cy div 2);
  Result := bounds(xNew, yNew, innerSize.cx, innerSize.cy);
end;


procedure moveRectCenter(var aRect: Trect; aNewCenter: Tpoint); inline;
//@TODO maybe rename RectCentered ?? Like Delphi .
var
  newX, newY: longint;
  newRect: Trect;
begin
  newX := aNewCenter.x - round((aRect.Width / 2));
  newY := aNewCenter.y - (round(arect.Height / 2));
  newRect.TopLeft := Point(newX, newY);
  newX := aNewCenter.x + round((aRect.Width / 2));
  newY := aNewCenter.y + (round(arect.Height / 2));
  newRect.BottomRight := point(newX, newY);
  aRect := newRect;
end;

procedure Normalize(var aRect: Trect);
var
  replRect: Trect;
begin
  //@TODO need to have centerpoint moved!
  if aRect.top > aRect.bottom then
  begin
    with aRect do
    begin
      top := top xor bottom;
      bottom := top xor bottom;
      top := top xor bottom;
    end;
  end;

  if aRect.left > aRect.right then
  begin
    with aRect do
    begin
      left := left xor right;
      right := left xor right;
      left := left xor right;
    end;
  end;
  replRect := aRect;
  aRect := centeredRect(replRect, aRect);

end;

function drawLine(aCanvas: Tcanvas; aStrRec: TstrRec): boolean; inline;
begin
  aCanvas.Line(astrRec.start, aStrRec.finish);
  Result := True; /// change to procedure later ?
end;

procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TlinePoints);
var
  fPoints: TstrRec;
begin
  for fPoints in aLinePoints do
    drawline(aCanvas, fPoints);
end;

procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TstrPnts); overload;
var
  fPoints: TstrRec;
begin
  for fPoints in aLinePoints do
    drawline(aCanvas, fPoints);
end;

procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TfrtPnts); overload;
var
  fPoints: TstrRec;
begin
  for fPoints in aLinePoints do
    drawline(aCanvas, fPoints);
end;

procedure addMarker(aPoint: Tpoint; aCanvas: TCanvas; txtLbl : String ; pxSize : Integer = 50);
var
  DotSize: Trect;
  textLook: TTextStyle;
begin
  DotSize.Create(0, 0, pxSize, pxSize);
  moveRectCenter(DotSize, aPoint);
  aCanvas.Brush.Style := bsSolid;
  aCanvas.Ellipse(DotSize);
  aCanvas.Brush.Style := bsClear;
  textLook := aCanvas.TextStyle;
  textLook.Alignment := taCenter;
  textLook.Layout:= tlCenter;
  aCanvas.Font.Color := clLime;
  aCanvas.Font.Bold := True;
  aCanvas.Font.Size := 18;
  acanvas.font.Italic := True;
  aCanvas.TextRect(DotSize,0,0, txtLbl, textLook ); //Placeholder   'F𝄰♭♮'
end;

function TChordBoxCanvas.DrawOnCanvas(aCanvas: TCanvas): boolean;
begin
  Result := False;
  //need a Type for coordinates
end;



end.
