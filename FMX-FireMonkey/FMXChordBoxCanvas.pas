unit FMXChordBoxCanvas;

interface

uses
  Classes, SysUtils, FMX.Graphics, FMX.Types, FMX.Controls, system.UITypes,
  Types, FMXGuitarChordBoxCoordinates, FMXChordData;

type

  TmarkerShape = (msCircle, msSquare, msTriangle, msStar);

  { TChordBoxCanvas }

  TChordBoxCanvas = class(TGuitarChordBoxCoOrds)
  private
    mPenWidth: integer;
    mManualPenWidth: integer;
    mAutoPenWidth: boolean;
    procedure drawLines(aCanvas: TCanvas; const aLinePoints: array of TstrRec);
    procedure drawXShape(aCanvas: TCanvas; const aPoint: TpointF);
    procedure drawOShape(aCanvas: TCanvas; const aPoint: TpointF);
    procedure DrawTriShape(aCanvas: TCanvas; const aPoint: TpointF);
    procedure DrawChordDataMarkers(aCanvas: TCanvas);
    procedure setautoPen(AValue: boolean);
    procedure setFifthStringFinger(AValue: TfretNumber);
    procedure setFirstStringFinger(AValue: TfretNumber);
    procedure setFourthStringFinger(AValue: TfretNumber);
    procedure setMChordData(AValue: TChordData);
    procedure setSecondStringFinger(AValue: TfretNumber);
    procedure setSixthStringFinger(AValue: TfretNumber);
    procedure setThirdStringFinger(AValue: TfretNumber);
  public
    constructor Create(const cParentRect: TrectF); overload;
    constructor Create(const cParentRect: TrectF;
      aChordData: TChordData); overload;
    // procedure DrawTriShape(aCanvas: TCanvas; const aPoint: Tpoint);
    procedure addMarker(aPoint: TpointF; aCanvas: TCanvas;
      txtLbl: string); overload;
    function DrawOnCanvas(aCanvas: TCanvas): boolean; // @TODO move --see notes
    procedure DrawChordData(aChordData: TChordData);
    property ChordBoxTextRect: TrectF read aChordTextRect; // protected
    property AutoPenWidth: boolean read mAutoPenWidth write setautoPen
      default True;
    property ManualPenWidth: integer read mManualPenWidth write mManualPenWidth
      default 1;
    property MarkerRect: TrectF read aMarkerRect; // protected
    property FretTextRect: TrectF read aFretTextRect; // protected
    property FretPoints: TfrtPnts read aFretPoints; // protected
    property StringPoints: TstrPnts read aStringPoints; // protected
    property FingerPoints: TchrdDtPnts read aFingerPoints;
    property ChordData: TChordData read mChordData write mChordData;
  published
    // untested probably delete later!
    property SixthStringFinger: TfretNumber write setSixthStringFinger;
    property FifthStringFinger: TfretNumber write setFifthStringFinger;
    property FourthStringFinger: TfretNumber write setFourthStringFinger;
    property ThirdStringFinger: TfretNumber write setThirdStringFinger;
    property SecondStringFinger: TfretNumber write setSecondStringFinger;
    property FirstStringFinger: TfretNumber write setFirstStringFinger;

  end;

procedure moveRectCenter(var aRect: TrectF; aNewCenter: TpointF); inline;

implementation

procedure moveRectCenter(var aRect: TrectF; aNewCenter: TpointF); inline;
var
  newX, newY: single;
  newRect: TrectF;
begin
  newX := aNewCenter.x - aRect.Width / 2.0;
  newY := aNewCenter.y - ((aRect.Height / 2));
  newRect.TopLeft := PointF(newX, newY);
  newX := aNewCenter.x + ((aRect.Width / 2));
  newY := aNewCenter.y + ((aRect.Height / 2));
  newRect.BottomRight := PointF(newX, newY);
  aRect := newRect;
end;

procedure TChordBoxCanvas.drawLines(aCanvas: TCanvas;
  const aLinePoints: array of TstrRec);
var
  counter: integer;
begin
  counter := Low(aLinePoints);
  repeat

{$IFDEF DCC}
{$IFDEF dcc}
    aCanvas.Stroke.Color := TAlphaColorRec.Black;
    aCanvas.Fill.Color := TAlphaColorRec.Black;

    aCanvas.DrawLine(aLinePoints[counter].start,
      aLinePoints[counter].finish, 1);
{$ENDIF}
{$ENDIF}
    Inc(counter);

  until counter > high(aLinePoints);
end;

procedure TChordBoxCanvas.DrawTriShape(aCanvas: TCanvas; const aPoint: TpointF);
var
  markDot: TrectF;
begin
  markDot := TrectF.Create(aMarkerRect);
  moveRectCenter(markDot, aPoint);
end;

procedure TChordBoxCanvas.DrawChordDataMarkers(aCanvas: TCanvas);
var
  counter: TGuitarStrings;
begin
  with mChordData do
  begin
    for counter := TGuitarStrings(1) to TGuitarStrings(6) do
      addMarker(MarkerData[counter].Location, aCanvas,
        MarkerData[counter].Text);
  end;
end;

procedure TChordBoxCanvas.setautoPen(AValue: boolean);
begin
  if mAutoPenWidth = AValue then
    Exit;
  mAutoPenWidth := AValue;
end;

procedure TChordBoxCanvas.setMChordData(AValue: TChordData);
begin
  // if mChordData=AValue then Exit;
  mChordData := AValue;
  generate();
end;

// @TODO Strings Move to GuitarChordBoxCoordinates!
procedure TChordBoxCanvas.setSixthStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[sixthString].Location := aFingerPoints[Ord(SixthStrng),
    Ord(AValue)];
end;

procedure TChordBoxCanvas.setFifthStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[fifthString].Location := aFingerPoints[Ord(fifthStrng),
    Ord(AValue)];
end;

procedure TChordBoxCanvas.setFourthStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[fourthString].Location :=
    aFingerPoints[Ord(fourthStrng), Ord(AValue)];
end;

procedure TChordBoxCanvas.setThirdStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[thirdString].Location := aFingerPoints[Ord(thirdStrng),
    Ord(AValue)];
end;

procedure TChordBoxCanvas.setSecondStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[secondString].Location :=
    aFingerPoints[Ord(secondStrng), Ord(AValue)];
end;

procedure TChordBoxCanvas.setFirstStringFinger(AValue: TfretNumber);
begin
  mChordData.MarkerData[firstString].Location := aFingerPoints[Ord(firstStrng),
    Ord(AValue)];
end;

procedure TChordBoxCanvas.drawXShape(aCanvas: TCanvas; const aPoint: TpointF);
var
  markDot: TrectF;
begin
  markDot := TrectF.Create(aMarkerRect);
  moveRectCenter(markDot, aPoint);

end;

procedure TChordBoxCanvas.drawOShape(aCanvas: TCanvas; const aPoint: TpointF);

var
  markDot: TrectF;
begin
  {
    markDot := Trect.Create(aMarkerRect);
    moveRectCenter(markDot, aPoint);
    aCanvas.Brush.Style := bsClear;
    aCanvas.Ellipse(markDot);
  }
end;

constructor TChordBoxCanvas.Create(const cParentRect: TrectF);
begin
  inherited;
  if mAutoPenWidth then
    mPenWidth := round(cParentRect.Width * 0.005)
  else
    mPenWidth := mManualPenWidth;
end;

constructor TChordBoxCanvas.Create(const cParentRect: TrectF;
  aChordData: TChordData);
begin
  if mAutoPenWidth then
    mPenWidth := round(cParentRect.Width * 0.005)
  else
    mPenWidth := mManualPenWidth;
  mChordData := aChordData;
  generate;
end;

procedure TChordBoxCanvas.addMarker(aPoint: TpointF; aCanvas: TCanvas;
  txtLbl: string);
var
  DotSize: TrectF;
begin
  DotSize.Create(MarkerRect);
  moveRectCenter(DotSize, aPoint);
  NormalizeRect(DotSize);
  aCanvas.Fill.Color := TAlphaColorRec.Black;
  aCanvas.FillEllipse(DotSize, 0.95);
  aCanvas.Stroke.Color := TAlphaColorRec.Red;
  aCanvas.Fill.Color := TAlphaColorRec.Lime;
  aCanvas.Stroke.Thickness := 1;
  aCanvas.Fill.Kind := TBrushKind.Solid;
  aCanvas.Stroke.Kind := TBrushKind.Solid;
  aCanvas.Font.Size := aChordBoxRect.Width / 7;
  aCanvas.FillText(DotSize, txtLbl, True, 1, [], TTextAlign.Center,
    TTextAlign.Center);
end;

function TChordBoxCanvas.DrawOnCanvas(aCanvas: TCanvas): boolean;
var
  tempArray: array of TstrRec;

begin
  aCanvas.Stroke.DefaultColor := TAlphaColorRec.Black;

  if mAutoPenWidth then
    mPenWidth := round(aCanvas.Width * 0.02) // Seems based on DPI
  else
    aCanvas.Stroke.Thickness := 1; // mPenWidth;

  aCanvas.Stroke.Kind := TBrushKind.Solid;

  aCanvas.Font.Size := aChordBoxRect.Width / 4;
  aCanvas.Fill.Color := TAlphaColorRec.Blue;
  aCanvas.FillText(aChordTextRect, ChordData.Name, false, 1, [],
    TTextAlign.Center, TTextAlign.Center);
  aCanvas.DrawRect(aChordBoxRect, 1);
  aCanvas.Fill.Color := TAlphaColorRec.Black;
  aCanvas.FillRect(NutRect(aChordBoxRect), 1);
  // Draw Nut if StartFret is zero
  if mChordData.StartingFret > 0 then
    aCanvas.FillText(aFretTextRect, IntToStr(mChordData.StartingFret), false, 1,
      [], TTextAlign.Center);

  SetLength(tempArray, 4);
  tempArray[0] := aStringPoints[2];
  tempArray[1] := aStringPoints[3];
  tempArray[2] := aStringPoints[4];
  tempArray[3] := aStringPoints[5];
  drawLines(aCanvas, tempArray);
  // pass fretlines
  SetLength(tempArray, 3);
  tempArray[0] := aFretPoints[1];
  tempArray[1] := aFretPoints[2];
  tempArray[2] := aFretPoints[3];
  drawLines(aCanvas, tempArray);

  DrawChordDataMarkers(aCanvas);

  Result := false;
end;

procedure TChordBoxCanvas.DrawChordData(aChordData: TChordData);
begin
  // @TODO Draw all strings in ChordData
end;

end.
