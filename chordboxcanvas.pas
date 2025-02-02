unit ChordBoxCanvas;

//{$mode ObjFPC}{$H+}
{$MODE DELPHI}
interface

uses
  Classes, SysUtils, Graphics, Types, GuitarChordBoxCoordinates;

type

  TmarkerShape = (msCircle, msSquare, msTriangle, msStar);

  { TChordBoxCanvas }

  TChordBoxCanvas = class(TGuitarChordBoxCoOrds)
  private
    mPenWidth: integer; //not Implemented yet
    procedure drawLines(aCanvas: TCanvas; const aLinePoints: array of TstrRec);
    procedure drawXShape(aCanvas: TCanvas; const aPoint: Tpoint);
    procedure drawOShape(aCanvas: TCanvas; const aPoint: Tpoint);
    procedure DrawTriShape(aCanvas: TCanvas; const aPoint: Tpoint);
    //@TODO Check for normalization on aMarkerRect
    procedure DrawChordDataMarkers(aCanvas: TCanvas);
  public
    constructor Create(const cParentRect: Trect); overload;
    //procedure DrawTriShape(aCanvas: TCanvas; const aPoint: Tpoint);
    procedure addMarker(aPoint: Tpoint; aCanvas: TCanvas; txtLbl: string); overload;
    procedure addMarker(aString: TGuitarStrings; aFret: TFretNumber;
      aCanvas: TCanvas; txtLbl: string); overload;
    function DrawOnCanvas(aCanvas: TCanvas): boolean;//@TODO move --see notes
    property ChordBoxTextRect: Trect read aChordTextRect;
    property MarkerRect: Trect read aMarkerRect;
    property FretTextRect: Trect read aFretTextRect;
    property FretPoints: TfrtPnts read aFretPoints;
    property StringPoints: TstrPnts read aStringPoints;
    property FingerPoints: TchrdDtPnts read aFingerPoints;
    property ChordData: TChordData read mChordData write mChordData;
  end;

{$IFDEF FPC}
procedure Normalize(var aRect: Trect);
function centeredRect(const ARect: TRect; const bRect: TRect): TRect;
{$ENDIF}
procedure moveRectCenter(var aRect: Trect; aNewCenter: Tpoint); inline;


implementation

{$IFDEF FPC}
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
end;{$ENDIF}

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

{$IFDEF FPC}
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
{$ENDIF}

procedure TChordBoxCanvas.drawLines(aCanvas: TCanvas;
  const aLinePoints: array of TstrRec);
var
  counter: integer;
begin
  counter := Low(aLinePoints);
  repeat
    {$IFDEF FPC}
    aCanvas.Line(aLinePoints[counter].start, aLinePoints[counter].finish);
    {$ENDIF}
    {$IFDEF DCC}
    aCanvas.MoveTo(aLinePoints[counter].start);
    aCanvas.DrawTo(aLinePOints[counter].finish);
    {$ENDIF}
    Inc(counter);

  until counter > high(aLinePoints);
end;

procedure TChordBoxCanvas.DrawTriShape(aCanvas: TCanvas; const aPoint: Tpoint);
var
  markDot: Trect;
begin
  markDot := Trect.Create(aMarkerRect);
  moveRectCenter(markDot, aPoint);
  {$IFDEF DCC}
  aCanvas.MoveTo(Point(markDot.Left, markDot.Bottom));
  aCanvas.DrawTo(markDot.BottomRight);
  aCanvas.MoveTo(Point(markDot.CenterPoint.X, markDot.Top));
  aCanvas.LineTo(markDot.BottomRight);
  aCanvas.MoveTo(Point(markDot.Left, markDot.Bottom));
  aCanvas.LineTo(Point(markdot.centerpoint.x, markdot.top));
  {$ENDIF}
  {$IFDEF FPC}
  aCanvas.Line(Point(markDot.Left, markDot.Bottom), markDot.BottomRight);
  aCanvas.Line(Point(markDot.CenterPoint.X, markDot.Top), markDot.BottomRight);
  aCanvas.Line(Point(markDot.Left, markDot.Bottom),
    Point(markdot.centerpoint.x, markdot.top));
  {$ENDIF}
end;

procedure TChordBoxCanvas.DrawChordDataMarkers(aCanvas: TCanvas);
var
   counter : TGuitarStrings ;
begin
  //@TODO Implement from DrawCanvas
  with mChordData do
  begin
    for counter := SixthStrng to FirstStrng do
     addMarker(MarkerData[counter].Location, aCanvas,MarkerData[counter].Text);
  end;
end;

procedure TChordBoxCanvas.drawXShape(aCanvas: TCanvas; const aPoint: Tpoint);
var
  markDot: Trect;
begin
  markDot := Trect.Create(aMarkerRect);
  moveRectCenter(markDot, aPoint);
  {$IFDEF FPC}
  aCanvas.Line(markDot.TopLeft, markDot.BottomRight);
  aCanvas.Line(Point(markDot.Right, markDot.Top),
    Point(markDot.Left, markDot.Bottom));
  {$ENDIF}

  {$IFDEF DCC}
  with aCanvas do
  begin
    MoveTo(markDot.TopLeft);
    LineTo(markDot.BottomRight);
    MoveTo(markDot.Right);
    LineTo(markDot.Bottom);
  end;
  {$ENDIF}

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

constructor TChordBoxCanvas.Create(const cParentRect: Trect);
begin
  inherited;
  mPenWidth := Round(cParentRect.Width * 0.005);
end;

procedure TChordBoxCanvas.addMarker(aPoint: Tpoint; aCanvas: TCanvas;
  txtLbl: string); overload;
//@TODO add method to not draw chord points with (0,0)
//      This method will likely replace other similar overloaded method.
var
  DotSize: Trect;
  textLook: TTextStyle;
begin
  DotSize.Create(MarkerRect);
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
   aCanvas.Font.Size := Round(aCanvas.Width / 20);
  acanvas.font.Italic := True;
  //temp for debug line below
 // txtLbl := format('(%d,%d)%s', [Dotsize.CenterPoint.X,
  //  DotSize.CenterPoint.Y, txtLbl]);
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
  aCanvas.Font.Size := Round(aCanvas.Width / 20);//12;
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

  //@TODO setup to use mChordData to draw chord box
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

  aCanvas.Font.Size := Round(aCanvas.Width / 10);
  aCanvas.Font.Color := clBlue;
  aCanvas.TextRect(aChordTextRect, 0, 0, mChordData.Name, textStyle);
  aCanvas.Font.Size := Round(aCanvas.Width / 20);//18;

  if mChordData.StartingFret > 0 then
    aCanvas.TextRect(aFretTextRect, 0, 0, IntToStr(mChordData.StartingFret), textStyle);

  //@TODO Draw fingerDots from mChordData
    DrawChordDataMarkers(aCanvas);

  Result := False;

  {TEMP FOR TESTING}

  //drawXShape(aCanvas, Point(100, 100));
  {================}

end;


end.
