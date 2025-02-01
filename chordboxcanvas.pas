unit ChordBoxCanvas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Types, GuitarChordBoxCoordinates;

type

  TmarkerShape = (msCircle, msSquare, msTriangle, msStar);

  { TChordBoxCanvas }

  TChordBoxCanvas = class(TGuitarChordBoxCoOrds)
  private
    mPenWidth : Integer; //not Implemented yet
    procedure drawLines(aCanvas: TCanvas; const aLinePoints: array of TstrRec);
    procedure drawXShape(aCanvas: TCanvas; const aPoint: Tpoint);
    procedure drawOShape(aCanvas: TCanvas; const aPoint: Tpoint);
    //procedure DrawTriShape(aCanvas: TCanvas; const aPoint: Tpoint);
  public
    constructor create(ParentRect : Trect);overload;
    procedure DrawTriShape(aCanvas: TCanvas; const aPoint: Tpoint);
    //procedure drawXShape(aCanvas: TCanvas; const aPoint: Tpoint);
    //procedure drawOShape(aCanvas: TCanvas; const aPoint: Tpoint);
    procedure addMarker(aPoint: Tpoint; aCanvas: TCanvas; txtLbl: string); overload;
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

procedure Normalize(var aRect: Trect);inline;
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

procedure TChordBoxCanvas.DrawTriShape(aCanvas: TCanvas; const aPoint: Tpoint);
var
  markDot: Trect;
begin
  markDot := Trect.Create(aMarkerRect);
  moveRectCenter(markDot, aPoint);
  aCanvas.Line(Point(markDot.Left, markDot.Bottom), markDot.BottomRight);
  aCanvas.Line(Point(markDot.CenterPoint.X, markDot.Top), markDot.BottomRight);
  aCanvas.Line(Point(markDot.Left, markDot.Bottom),
    Point(markdot.centerpoint.x, markdot.top));
end;

procedure TChordBoxCanvas.drawXShape(aCanvas: TCanvas; const aPoint: Tpoint);
var
  markDot: Trect;
begin
  markDot := Trect.Create(aMarkerRect);
  moveRectCenter(markDot, aPoint);
  aCanvas.Line(markDot.TopLeft, markDot.BottomRight);
  aCanvas.Line(Point(markDot.Right, markDot.Top),
    Point(markDot.Left, markDot.Bottom));
end;

procedure TChordBoxCanvas.drawOShape(aCanvas: TCanvas; const aPoint: Tpoint);
var
  markDot: Trect;
begin
  markDot := Trect.Create(aMarkerRect);
  moveRectCenter(markDot, aPoint);
  aCanvas.Brush.Style := bsClear;
  aCanvas.Ellipse(markDot);
end;

constructor TChordBoxCanvas.create(ParentRect: Trect);
begin
  inherited;
  mPenWidth:= Round(ParentRect.Width * 0.005);
end;

function TChordBoxCanvas.getMarkerRect: TRect;
begin
  Result := inherited MarkerRect;
end;

procedure TChordBoxCanvas.addMarker(aPoint: Tpoint; aCanvas: TCanvas;
  txtLbl: string); overload;
//@TODO Remove and replace body of method with short call to other addMarker
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
var
  DotSize: Trect;
  textLook: TTextStyle;
begin
  DotSize.Create(MarkerRect);
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
  //@TODO Need Method to calculat PX to Font PT size
  aCanvas.Font.Size := Round (aCanvas.Width / 20);//12;
  acanvas.font.Italic := True;
  {
  //temp for debug line below
  txtLbl := format('(%d,%d)%s', [Dotsize.CenterPoint.X,
    DotSize.CenterPoint.Y, txtLbl]);
    }
  aCanvas.TextRect(DotSize, 0, 0, txtLbl, textLook); //Placeholder   'F𝄰♭♮';
end;

function TChordBoxCanvas.DrawOnCanvas(aCanvas: TCanvas): boolean;
var
  textStyle: TTextStyle;
begin
  mPenWidth := Round(aCanvas.Width * 0.005);
  aCanvas.Pen.Width := mPenWidth;

  aCanvas.Brush.Style := bsClear;
  aCanvas.Rectangle(aChordBoxRect);

  drawLines(aCanvas, aStringPoints[2..5]);
  drawLines(aCanvas, aFretPoints[1..3]);

  aCanvas.Brush.Style := bsSolid;
  aCanvas.Brush.Color := clBlack;
  aCanvas.Rectangle(NutRect(aChordBoxRect));
  aCanvas.Brush.Style := bsClear;

  //@TODO Finish function


  textStyle.Alignment := taCenter;
  textStyle.Layout := tlCenter;

  aCanvas.Font.Size := Round (aCanvas.Width / 10) ;
  //32;//@TODO Set Size with Ratio
  {To convert pixels (px) to font size (usually measured in points, pt), you can
  use the formula: 1 pixel = approximately 0.75 points; meaning to convert
  pixels to points, multiply the pixel value by 0.75.}

  aCanvas.Font.Color := clBlue;
  aCanvas.TextRect(aChordTextRect, 0, 0, ChordText, textStyle);
  aCanvas.Font.Size := Round (aCanvas.Width / 20) ;//18;

  if StartFret > 0 then
    aCanvas.TextRect(aFretTextRect, 0, 0, IntToStr(StartFret), textStyle);

   Result := False;

  {TEMP FOR TESTING}

  //drawXShape(aCanvas, Point(100, 100));
  {================}

end;


end.
