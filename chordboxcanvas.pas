unit ChordBoxCanvas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Types, GuitarChordBoxCoordinates;

type

  { TChordBoxCanvas }

  TChordBoxCanvas = class(TGuitarChordBoxCoOrds)
  private
    placeholder: boolean;
  public
    procedure addMarker(aPoint: Tpoint; aCanvas: TCanvas; txtLbl: string;
      pxSize: integer = 50);
    procedure addMarker(aString: TGuitarStrings; aFret: TFretNumber;
      aCanvas: TCanvas; txtLbl: string); overload;
    function DrawOnCanvas(aCanvas: TCanvas): boolean;//@TODO move --see notes
    function getMarkerRect(): TRect;
  end;

procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TlinePoints);
procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TstrPnts); overload;
procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TfrtPnts); overload;
procedure Normalize(var aRect: Trect);
function centeredRect(const ARect: TRect; const bRect: TRect): TRect;
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

//@TODO make these functions private class functions later
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

procedure drawLine(aCanvas: Tcanvas; aStrRec: TstrRec); inline;
begin
  aCanvas.Line(astrRec.start, aStrRec.finish);
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

function TChordBoxCanvas.getMarkerRect: TRect;
begin
  Result := inherited MarkerRect;
end;

procedure TChordBoxCanvas.addMarker(aPoint: Tpoint; aCanvas: TCanvas;
  txtLbl: string; pxSize: integer = 50);
var
  DotSize: Trect;
  textLook: TTextStyle;
begin
  DotSize.Create(MarkerRect);
  //DotSize.Create(Bounds(0,0, pxSize, pxSize));
  moveRectCenter(DotSize, aPoint);
  Normalize(DotSize);
  aCanvas.Brush.Style := bsSolid;
  aCanvas.Ellipse(DotSize);
  aCanvas.Brush.Style := bsClear;
  textLook := aCanvas.TextStyle;
  textLook.Alignment := taCenter;
  textLook.Layout := tlCenter;
  aCanvas.Font.Color := clLime;
  aCanvas.Font.Bold := True;
  aCanvas.Font.Size := 8;//@TODO Need Method to calculat PX to Font PT size
  acanvas.font.Italic := True;
  //temp for debug line below
  txtLbl := format('(%d,%d)%s', [Dotsize.CenterPoint.X,
    DotSize.CenterPoint.Y, txtLbl]);
  aCanvas.TextRect(DotSize, 0, 0, txtLbl, textLook); //Placeholder   'F𝄰♭♮'
end;

procedure TChordBoxCanvas.addMarker(aString: TGuitarStrings;
  aFret: TFretNumber; aCanvas: TCanvas; txtLbl: string);
//@TODO Needs inherited function to get marker point from TGstrngs and TFrtnum;
var
  DotSize: Trect;
  textLook: TTextStyle;
begin
  DotSize.Create(MarkerRect);
  //DotSize.Create(Bounds(0,0, pxSize, pxSize));
  moveRectCenter(DotSize, POINT(12, 12));//@TODO Point is placeholder
  Normalize(DotSize);
  aCanvas.Brush.Style := bsSolid;
  aCanvas.Ellipse(DotSize);
  aCanvas.Brush.Style := bsClear;
  textLook := aCanvas.TextStyle;
  textLook.Alignment := taCenter;
  textLook.Layout := tlCenter;
  aCanvas.Font.Color := clLime;
  aCanvas.Font.Bold := True;
  aCanvas.Font.Size := 8;//@TODO Need Method to calculat PX to Font PT size
  acanvas.font.Italic := True;
  //temp for debug line below
  txtLbl := format('(%d,%d)%s', [Dotsize.CenterPoint.X,
    DotSize.CenterPoint.Y, txtLbl]);
  aCanvas.TextRect(DotSize, 0, 0, txtLbl, textLook); //Placeholder   'F𝄰♭♮'
end;

function TChordBoxCanvas.DrawOnCanvas(aCanvas: TCanvas): boolean;
begin
  //@TODO remeber to set pen width according to dimensions of canvas!
  //      1.  Move from GuitarChordBoxCoOrds Class later!
end;


end.
