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
    procedure drawLines(aCanvas: TCanvas; const aLinePoints: array of TstrRec);
  public
    procedure addMarker(aPoint: Tpoint; aCanvas: TCanvas; txtLbl: string;
      pxSize: integer = 50);
    procedure addMarker(aString: TGuitarStrings; aFret: TFretNumber;
      aCanvas: TCanvas; txtLbl: string); overload;
    function DrawOnCanvas(aCanvas: TCanvas): boolean;//@TODO move --see notes
    function getMarkerRect(): TRect;
  end;

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

procedure TChordBoxCanvas.drawLines(aCanvas: TCanvas;
  const aLinePoints: array of TstrRec);
var
  counter: integer;
begin
  counter := Low(aLinePoints);
  repeat
    aCanvas.Line(aLinePoints[counter].start, aLinePoints[counter].finish);
    Inc(counter);
  until counter > high(aLinePoints);
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
  //moveRectCenter(DotSize, POINT(30, 300));//@TODO Point is placeholder
  moveRectCenter(DotSize, aFingerPoints[Ord(aString), Ord(aFret)]);
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
  {
  //temp for debug line below
  txtLbl := format('(%d,%d)%s', [Dotsize.CenterPoint.X,
    DotSize.CenterPoint.Y, txtLbl]);
    }
  aCanvas.TextRect(DotSize, 0, 0, txtLbl, textLook); //Placeholder   'F𝄰♭♮';
end;

function TChordBoxCanvas.DrawOnCanvas(aCanvas: TCanvas): boolean;
begin
  aCanvas.Pen.Width := Round(aCanvas.Width * 0.005);

  aCanvas.Brush.Style := bsClear;
  aCanvas.Rectangle(aChordBoxRect);
  //drawMultiLines(aCanvas, aStringPoints);
  //drawMultiLines(aCanvas, aFretPoints);
  drawLines(aCanvas, aStringPoints[2..5]);
  drawLines(aCanvas, aFretPoints[1..3]);
  aCanvas.Brush.Style := bsSolid;
  aCanvas.Brush.Color := clBlack;
  aCanvas.Rectangle(NutRect(aChordBoxRect));
  aCanvas.Brush.Style := bsClear;

  //@TODO Finish function
  Result := False;
  //need a Type for coordinates
  //TEMP.......
  aCanvas.Rectangle(aChordTextRect);
  aCanvas.Rectangle(aFretTextRect);
  normalize(aMarkerRect);
  aCanvas.Rectangle(aMarkerRect);
  //...........

end;


end.
