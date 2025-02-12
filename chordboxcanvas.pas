unit ChordBoxCanvas;

//{$mode ObjFPC}{$H+}
{$MODE DELPHI}
interface

uses
  Classes, SysUtils, Graphics, Types, lazutils, GuitarChordBoxCoordinates, ChordData,
  GuitarCBTypes;

type

  { TChordBoxCanvas }

  TChordBoxCanvas = class(TGuitarChordBoxCoOrds)
  private
    mPenWidth: integer;
    mManualPenWidth: integer;
    mAutoPenWidth: boolean;
    procedure drawLines(aCanvas: TCanvas; const aLinePoints: array of TstrRec);
    procedure drawXShape(aCanvas: TCanvas; const aPoint: Tpoint);
    procedure drawOShape(aCanvas: TCanvas; const aPoint: Tpoint);
    procedure DrawTriShape(aCanvas: TCanvas; const aPoint: Tpoint);
    procedure DrawChordDataMarkers(aCanvas: TCanvas);
    procedure setautoPen(AValue: boolean);
    procedure setFifthStringFinger(AValue: TfretNumber);
    procedure setFirstStringFinger(AValue: TfretNumber);
    procedure setFourthStringFinger(AValue: TfretNumber);
    procedure setMChordData(AValue: TChordData);
    procedure setSecondStringFinger(AValue: TfretNumber);
    procedure setSixthStringFinger(AValue: TfretNumber);
    procedure setThirdStringFinger(AValue: TfretNumber);
  protected
    property MarkerRect: Trect read aMarkerRect;       //protected
    property FretTextRect: Trect read aFretTextRect;  //protected
    property FretPoints: TfrtPnts read aFretPoints;    //protected
    property StringPoints: TstrPnts read aStringPoints;  //protected
  public
    constructor Create(const cParentRect: Trect); overload;
    constructor Create(const cParentRect: Trect; aChordData: TChordData); overload;
    procedure addMarker(aPoint: Tpoint; aCanvas: TCanvas; txtLbl: string;
      aMarkerShape: TmarkerShape = msCircle);
    function DrawOnCanvas(aCanvas: TCanvas): boolean;//@TODO move --see notes
    //procedure DrawChordData(aChordData: TChordData);
    property ChordBoxTextRect: Trect read aChordTextRect;  //protected
    property AutoPenWidth: boolean read mAutoPenWidth write setautoPen default True;
    property ManualPenWidth: integer read mManualPenWidth
      write mManualPenWidth default 1;
    property FingerPoints: TchrdDtPnts read aFingerPoints;
    property ChordData: TChordData read mChordData write mChordData;
  published
    //untested probably delete later!
    property SixthStringFinger: TfretNumber write setSixthStringFinger;
    property FifthStringFinger: TfretNumber write setFifthStringFinger;
    property FourthStringFinger: TfretNumber write setFourthStringFinger;
    property ThirdStringFinger: TfretNumber write setThirdStringFinger;
    property SecondStringFinger: TfretNumber write setSecondStringFinger;
    property FirstStringFinger: TfretNumber write setFirstStringFinger;

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
    aCanvas.MoveTo(aLinePoints[counter].start.x, aLinePoints[counter].start.y);
    aCanvas.LineTo(aLinePoints[counter].finish.x,
      aLinePoints[counter].finish.y);
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
  aCanvas.MoveTo(markDot.left, markDot.bottom);
  aCanvas.LineTo(markDot.BottomRight.x, markDot.BottomRight.y);
  aCanvas.MoveTo(markDot.centerpoint.x, markDot.top);
  aCanvas.LineTo(markDot.BottomRight.x, markDot.BottomRight.y);
  aCanvas.MoveTo(markDot.left, markDot.bottom);
  aCanvas.LineTo(markDot.centerpoint.x, markDot.top);
  {$ENDIF}
  {$IFDEF FPC}
  aCanvas.Line(Point(markDot.Left, markDot.Bottom), markDot.BottomRight);
  aCanvas.Line(Point(markDot.CenterPoint.X, markDot.Top), markDot.BottomRight);
  aCanvas.Line(Point(markDot.Left, markDot.Bottom),
    Point(markdot.centerpoint.x, markdot.top));
      aCanvas.FloodFill(aPoint.x+4, apoint.y+4, clBlack, TFillStyle.fsBorder);
  {$ENDIF}
end;


procedure TChordBoxCanvas.DrawChordDataMarkers(aCanvas: TCanvas);
var
  counter: TGuitarStrings;
begin
  with mChordData do
  begin

    for counter := TGuitarStrings(1) to TGuitarStrings(6) do
      // SixthStrng to FirstStrng do
      addMarker(MarkerData[counter].Location, aCanvas,
        MarkerData[counter].Text, MarkerData[Counter].Shape);
  end;
end;

procedure TChordBoxCanvas.setautoPen(AValue: boolean);
begin
  if mAutoPenWidth = AValue then Exit;
  mAutoPenWidth := AValue;
end;


procedure TChordBoxCanvas.setMChordData(AValue: TChordData);
begin
  //if mChordData=AValue then Exit;
  mChordData := AValue;
  generate();
end;


//@TODO Strings Move to GuitarChordBoxCoordinates!
procedure TChordBoxCanvas.setSixthStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[sixthString].Location :=
    aFingerPoints[Ord(SixthStrng), Ord(AValue)];
end;

procedure TChordBoxCanvas.setFifthStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[fifthString].Location :=
    aFingerPoints[Ord(fifthStrng), Ord(AValue)];
end;

procedure TChordBoxCanvas.setFourthStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[fourthString].Location :=
    aFingerPoints[Ord(fourthStrng), Ord(AValue)];
end;

procedure TChordBoxCanvas.setThirdStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[thirdString].Location :=
    aFingerPoints[Ord(thirdStrng), Ord(AValue)];
end;

procedure TChordBoxCanvas.setSecondStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[secondString].Location :=
    aFingerPoints[Ord(secondStrng), Ord(AValue)];
end;

procedure TChordBoxCanvas.setFirstStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[firstString].Location :=
    aFingerPoints[Ord(firstStrng), Ord(AValue)];
end;

procedure TChordBoxCanvas.drawXShape(aCanvas: TCanvas; const aPoint: Tpoint);
const
  cRatio = 0.68;
var
  markDot: Trect;
  oldPen: integer;
begin
  oldPen := aCanvas.Pen.Width;
  markDot := Bounds(0, 0, Round(aMarkerRect.Width * cRatio),
    Round(aMarkerRect.Height * cRatio));
  moveRectCenter(markDot, aPoint);
  {$IFDEF FPC}
  aCanvas.Pen.Width := Round (aCanvas.Width / 32);
  aCanvas.Line(markDot.TopLeft, markDot.BottomRight);
  aCanvas.Line(Point(markDot.Right, markDot.Top),
    Point(markDot.Left, markDot.Bottom));
  aCanvas.Pen.Width := oldPen;
  {$ENDIF}

  {$IFDEF DCC}
   with aCanvas do
  begin
    MoveTo(markDot.TopLeft.x, markDot.TopLeft.Y);
    LineTo(markDot.BottomRight.x, markdot.bottomright.y);
    MoveTo(markDot.right, markdot.top);
    LineTo(markDot.bottom, markDot.left);
  end;
  {$ENDIF}

end;

procedure TChordBoxCanvas.drawOShape(aCanvas: TCanvas; const aPoint: Tpoint);
var
  markDot: Trect;
  oldPen: integer;
begin
  oldPen := aCanvas.Pen.Width;
  aCanvas.Pen.Width := Round(aCanvas.Width / 42);
  markDot := Trect.Create(aMarkerRect);
  moveRectCenter(markDot, aPoint);
  aCanvas.Brush.Style := bsClear;
  aCanvas.Ellipse(markDot);
  aCanvas.Pen.Width := oldPen;
end;

constructor TChordBoxCanvas.Create(const cParentRect: Trect);
begin
  inherited;
  if mAutoPenWidth then
    mPenWidth := Round(cParentRect.Width * 0.005)
  else
    mPenWidth := mManualPenWidth;
end;

constructor TChordBoxCanvas.Create(const cParentRect: Trect; aChordData: TChordData);
begin
  if mAutoPenWidth then
    mPenWidth := Round(cParentRect.Width * 0.005)
  else
    mPenWidth := mManualPenWidth;
  if mChordData = nil then
    mChordData := aChordData;
  generate;
end;

procedure TChordBoxCanvas.addMarker(aPoint: Tpoint; aCanvas: TCanvas;
  txtLbl: string; aMarkerShape: TmarkerShape = msCircle);
//@TODO add method to not draw chord points with (0,0)
//      This method will likely replace other similar overloaded method.
var
  DotSize: Trect;
  {$IFDEF FPC}
  textLook: TTextStyle;
  {$ENDIF}
begin
  DotSize.Create(MarkerRect);
  moveRectCenter(DotSize, aPoint);
  Normalize(DotSize);
  aCanvas.Brush.Style := bsSolid;
  aCanvas.Brush.Color := clBlack;
  //@TODO Determine Marker Shape to Draw
  case aMarkerShape of
    msCircle:
      aCanvas.Ellipse(DotSize);
    msSquare:
      aCanvas.Rectangle(DotSize);
    msTriangle:
      DrawTriShape(aCanvas, aPoint);
    msStarSolid:
      aCanvas.Chord(10, 10, 20, 20, 30, 30, 40, 50);
    msCircleEmpty:
      drawOShape(aCanvas, aPoint);
      {
      begin
      aCanvas.Brush.Style := bsClear;
      aCanvas.Pen.Width := mPenWidth * 3;
      aCanvas.Ellipse(DotSize);
    end;
    }
    msMuted:
      drawXShape(aCanvas, aPoint);
  end;
  {
  if aMarkerShape = msCircle then
    aCanvas.Ellipse(DotSize);
  if a
  }
  aCanvas.Brush.Style := bsClear;
  {$IFDEF FPC}
  textLook := aCanvas.TextStyle;
  textLook.Alignment := taCenter;
  textLook.Layout := tlCenter;
  {$ENDIF}
  aCanvas.Font.Color := clLime;

  aCanvas.Font.Bold := True;
  {$IFDEF DCC}
    aCanvas.TextRect(DotSize,
      (DotSize.left + round(0.5 * aCanvas.TextWidth(txtLbl))), DotSize.top,
      txtLbl); // DELPHI
  {$ENDIF}
  // acanvas.font.Italic := True;
  //temp for debug line below
  // txtLbl := format('(%d,%d)%s', [Dotsize.CenterPoint.X,
  //  DotSize.CenterPoint.Y, txtLbl]);
  {$IFDEF FPC}
  aCanvas.TextRect(DotSize, 0, 0, txtLbl, textLook); //Placeholder   'F𝄰♭♮'
  {$ENDIF}
  {$IFDEF DCC}
    aCanvas.TextRect(DotSize,
      (DotSize.left + round(0.5 * aCanvas.TextWidth(txtLbl))), DotSize.top,
      txtLbl); // DELPHI
  {$ENDIF}
end;

{
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

  aCanvas.TextRect(DotSize, 0, 0, txtLbl, textLook); //Placeholder   'F𝄰♭♮';
end;
  }

function TChordBoxCanvas.DrawOnCanvas(aCanvas: TCanvas): boolean;
var
  {$IFDEF FPC}
  textStyle: TTextStyle;
  {$ENDIF}
  {$IFDEF DCC}
  tempArray : array of TlinePoints;
  {$ENDIF}
begin

  //@TODO setup to use mChordData to draw chord box
  if mAutoPenWidth then
    mPenWidth := Round(aCanvas.Width * 0.005)
  else
    aCanvas.Pen.Width := mPenWidth;

  aCanvas.Brush.Style := bsClear;
  aCanvas.Rectangle(aChordBoxRect);

  {$IFDEF FPC}
  drawLines(aCanvas, aStringPoints[2..5]);
  drawLines(aCanvas, aFretPoints[1..3]);
  {$ENDIF}

  {$IFDEF DCC}
  //@TODO needs Delphi Testing
  //pass string lines
  SetLength(tempArray, 4);
  tempArray[0] := aStringPoints[2];
  tempArray[1] := aStringPoints[3];
  tempArray[2] := aStringPoints[4];
  tempArray[3] := aStringPoints[5];
  drawLines(aCanvas, tempArray);
  //pass fretlines
  SetLength(tempArray,3);
  tempArray[0] := aFretPoints[1];
  tempArray[1] := aFretPoints[2];
  tempArray[2] := aFretPoints[3];
  drawLines(aCanvas, tempArray);
  {$ENDIF}

  aCanvas.Brush.Style := bsSolid;
  aCanvas.Brush.Color := clBlack;
  aCanvas.Rectangle(NutRect(aChordBoxRect));
  aCanvas.Brush.Style := bsClear;

  textStyle.Alignment := taCenter;
  textStyle.Layout := tlCenter;

  aCanvas.Font.Size := Round(aCanvas.Width / 10);
  aCanvas.Font.Color := clBlue;
  {$IFDEF DCC}
  //this still doesnt work as good as it should!
  aCanvas.Font.Size := round(aCanvas.ClipRect.Width / 8);
  aCanvas.TextRect(aChordTextRect, aChordTextRect.left +
    (round((aCanvas.TextWidth(mChordData.name)) / 2)),
    aChordTextRect.top + round(aCanvas.TextHeight(mChordData.name) / 3),
    mChordData.name); // DELPHI
  {$ENDIF}
  {$IFDEF FPC}
  aCanvas.TextRect(aChordTextRect, 0, 0, mChordData.Name, textStyle);
  aCanvas.Font.Size := Round(aCanvas.Width / 20);//18;
  {$ENDIF}

  if mChordData.StartingFret > 0 then
    aCanvas.TextRect(aFretTextRect, 0, 0, IntToStr(mChordData.StartingFret), textStyle);

  DrawChordDataMarkers(aCanvas);

  Result := True;
end;

 {
procedure TChordBoxCanvas.DrawChordData(aChordData: TChordData);
begin
  //@TODO Draw all strings in ChordData
end;
  }

end.
