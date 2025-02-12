unit FMXGuitarChordBoxCoordinates;
{$IFDEF FPC}
{$mode DELPHI}
{$ENDIF}

interface

uses
  Classes, SysUtils, System.Types, FMXChordData;

type
  TstrRec = record
    start: TpointF;
    finish: TpointF;
  end;

  TlinePoints = array of TstrRec;

  TstrPnts = array [1 .. 6] of TstrRec;

  TfrtPnts = array [0 .. 5] of TstrRec; // changed

  TchrdDtPnts = array [1 .. 6, 0 .. 4] of TpointF;

  TMutedOpenPnts = array [1 .. 6] of TpointF;

  TmarkerShape = (msCircle, msSquare, msTriangle, msStar);

  TGuitarStrings = (SixthStrng = 1, FifthStrng, FourthStrng, ThirdStrng,
    SecondStrng, FirstStrng);

  TFretNumber = (OpenString, FirstFret, SecondFret, ThirdFret,
    FourthFret, Muted);

  TGuitarChordBoxCoOrds = class
  private

    mStartFret: byte;
    mChordText: string; // not Implemented yet
    procedure calcChordTextRect;
    procedure calcFretTextRect;
    procedure fingerMarkerCalc;
    function getChordText: string;
    function getStartFret: byte;
    procedure setChordData(AValue: TChordData);
    procedure setChordText(AValue: string);
    procedure setStartFret(AValue: byte);
    function stringLines(aRect: TrectF): TstrPnts;
    function fretLines(aRect: TrectF): TfrtPnts;
    procedure GridRectFromParent(aRect: TrectF); // : Trect;

  protected
    mChordData: TChordData;
    aParentRect: TrectF;
    aChordBoxRect: TrectF;
    aNutRect: TrectF; // Not Implemented and needs to  be set in function!
    aFingerPoints: TchrdDtPnts;
    aFretPoints: TfrtPnts;
    aStringPoints: TstrPnts;
    // aMuteOpenPoints: TMutedOpenPnts;
    aMarkerRect: TrectF;
    aChordTextRect: TrectF;
    aFretTextRect: TrectF;

    function getCanvasRect: TrectF;
    // function getMarkerRect: Trect;  //may not be needed
    procedure setCanvasRect(aRect: TrectF);
    function NutRect(aRect: TrectF): TrectF;
    // change to proc to set class aNutRect
    // function verifyCanvasRect(aRect: Trect): boolean; //private if used

  public
    procedure generate();
    procedure ChordDataInput(aChordData: TChordData);
    constructor Create(); overload;
    constructor Create(const fParentRect: TrectF); overload;
    function getFretMarkerPoint(gString: integer; gFret: integer)
      : TpointF; overload;
    function getFretMarkerPoint(gString: TGuitarStrings; gFret: TFretNumber)
      : TpointF; overload;
    property ParentCanvasRect: TrectF read getCanvasRect write setCanvasRect;
    property MarkerRect: TrectF read aMarkerRect; // getMarkerRect;
    property StartFret: byte read getStartFret write setStartFret default 0;
    property ChordText: string read getChordText write setChordText;
    property ParentRect: TrectF read aParentRect write aParentRect;
    property ChordData: TChordData read mChordData write mChordData;
  end;

implementation

const
  cShrinkRatio = 0.925;
  cTopMoveRatio = 0.33;
  cBottomMoveRatio = 0.111;
  cSideMoveRatio = 0.15;
  cMarkerYRatio = 0.30;

constructor TGuitarChordBoxCoOrds.Create();
begin
  aChordBoxRect := TrectF.Create(0, 0, 0, 0);
  mStartFret := 0;
  if mChordData = nil then
    mChordData := TChordData.Create;
end;

constructor TGuitarChordBoxCoOrds.Create(const fParentRect: TrectF);

begin
  aParentRect := fParentRect;
  mStartFret := 0;
  generate();
  if mChordData = nil then
    mChordData := TChordData.Create;
end;

function TGuitarChordBoxCoOrds.getFretMarkerPoint(gString: integer;
  gFret: integer): TpointF;
begin
  Result := aFingerPoints[gString, gFret];
end;

function TGuitarChordBoxCoOrds.getFretMarkerPoint(gString: TGuitarStrings;
  gFret: TFretNumber): TpointF;
begin
  Result := aFingerPoints[Ord(gString), Ord(gFret)];
end;

procedure TGuitarChordBoxCoOrds.calcChordTextRect;
begin
  aChordTextRect.left := aChordBoxRect.left;
  aChordTextRect.right := aChordBoxRect.right;
  aChordTextRect.top := aParentRect.top +
    Round((aParentRect.Height * cBottomMoveRatio) / 4);
  aChordTextRect.bottom := aParentRect.top +
    Round(1.7 * (aParentRect.Height * cBottomMoveRatio));
end;

procedure TGuitarChordBoxCoOrds.calcFretTextRect;
begin
  aFretTextRect.left := aParentRect.left;
  aFretTextRect.top := aChordBoxRect.top;
  aFretTextRect.bottom := aFretPoints[1].start.Y;
  aFretTextRect.right := aChordBoxRect.left;
end;

function TGuitarChordBoxCoOrds.getCanvasRect: TrectF;
begin
  Result := aParentRect;
end;

procedure TGuitarChordBoxCoOrds.setCanvasRect(aRect: TrectF);
begin
  aParentRect := aRect;
  generate();
end;

function TGuitarChordBoxCoOrds.stringLines(aRect: TrectF): TstrPnts;
var
  calcOutput: TstrPnts;
  Count: integer;
  rec: TstrRec;
  spcing, calc: single;
begin
  spcing := ((aRect.Width) / 5);
  calc := (spcing * cShrinkRatio);
  aMarkerRect := TrectF.Create(0, 0, calc, calc);
  Count := 0;
  calcOutput := Default (TstrPnts);
  while Count <= 5 do
  begin
    rec.start := PointF(aRect.left + (spcing * Count), (aRect.top) + 1);
    rec.finish := PointF(aRect.left + (spcing * Count), (aRect.bottom) - 1);
    calcOutput[low(calcOutput) + (Count)] := rec;
    Inc(Count);
  end;
  aStringPoints := calcOutput;
  Result := calcOutput;
end;

function TGuitarChordBoxCoOrds.fretLines(aRect: TrectF): TfrtPnts;
var
  calcOutput: TfrtPnts;
  Count: integer;
  rec: TstrRec;
  spcing: longint;
begin
  spcing := Round(aRect.Height / 4);
  Count := 1;
  calcOutput := default (TfrtPnts);
  rec.start := PointF(aRect.left, Round(aParentRect.Height * cMarkerYRatio));

  rec.finish := PointF(aRect.right, Round(aParentRect.Height * cMarkerYRatio));

  calcOutput[0] := rec;
  while Count <= 4 do
  begin
    rec.start := PointF(aRect.left, aRect.top + (Count * spcing) + 1);
    rec.finish := PointF(aRect.right - 1, aRect.top + (Count * spcing) + 1);
    calcOutput[1 + (Count - 1)] := rec;
    Inc(Count);
  end;
  aFretPoints := calcOutput;
  Result := calcOutput;
end;

procedure TGuitarChordBoxCoOrds.GridRectFromParent(aRect: TrectF);
begin
  aRect.top := aRect.top + (aParentRect.Height * cTopMoveRatio);
  aRect.bottom := aRect.bottom - (aParentRect.Height * cBottomMoveRatio);
  aRect.left := aRect.left + (aParentRect.Width * cSideMoveRatio);
  aRect.right := aRect.right - (aParentRect.Width * cSideMoveRatio);
  aChordBoxRect := aRect;
end;

procedure TGuitarChordBoxCoOrds.fingerMarkerCalc;
var
  SpacingAdjust: single;
  gString, fPos: integer;
begin
  gString := 1;
  fPos := 0;
  SpacingAdjust :=
    (0.5 * ((aFretPoints[2].start.Y) - (aFretPoints[1].start.Y)));
  repeat
    while fPos < 5 do
    begin
      aFingerPoints[gString, fPos] := PointF(aStringPoints[gString].start.X,
        (aFretPoints[fPos].start.Y) - SpacingAdjust);
      Inc(fPos);
    end;
    fPos := 0;
    Inc(gString);
  until gString > 6;
end;

function TGuitarChordBoxCoOrds.getChordText: string;
begin
  Result := mChordText;
end;

function TGuitarChordBoxCoOrds.getStartFret: byte;
begin
  Result := mStartFret;
end;

procedure TGuitarChordBoxCoOrds.setChordData(AValue: TChordData);
begin

  mChordText := AValue.Name;
  mStartFret := AValue.StartingFret;

  AValue.MarkerData[SixthString].Location := aFingerPoints[Ord(SixthString),
    Ord(AValue.SixthString.FretPosition)];
  AValue.MarkerData[SixthString].Text := AValue.SixthString.Text;

  AValue.MarkerData[FifthString].Location := aFingerPoints[Ord(FifthString),
    Ord(AValue.FifthString.FretPosition)];
  AValue.MarkerData[FifthString].Text := AValue.FifthString.Text;

  AValue.MarkerData[FourthString].Location := aFingerPoints[Ord(FourthString),
    Ord(AValue.FourthString.FretPosition)];
  AValue.MarkerData[FourthString].Text := AValue.FourthString.Text;

  AValue.MarkerData[ThirdString].Location := aFingerPoints[Ord(ThirdString),
    Ord(AValue.ThirdString.FretPosition)];
  AValue.MarkerData[ThirdString].Text := AValue.ThirdString.Text;

  AValue.MarkerData[SecondString].Location := aFingerPoints[Ord(SecondString),
    Ord(AValue.SecondString.FretPosition)];
  AValue.MarkerData[SecondString].Text := AValue.SecondString.Text;

  AValue.MarkerData[FirstString].Location := aFingerPoints[Ord(FirstString),
    Ord(AValue.FirstString.FretPosition)];
  AValue.MarkerData[FirstString].Text := AValue.FirstString.Text;

  mChordData := AValue;
end;

procedure TGuitarChordBoxCoOrds.setChordText(AValue: string);
begin
  mChordText := AValue;
end;

procedure TGuitarChordBoxCoOrds.setStartFret(AValue: byte);
begin
  mStartFret := AValue;
end;

procedure TGuitarChordBoxCoOrds.generate();
begin
  if not aParentRect.IsEmpty then
  begin
    GridRectFromParent(aParentRect);
    aStringPoints := stringLines(aChordBoxRect);
    aFretPoints := fretLines(aChordBoxRect);
    fingerMarkerCalc;
    calcChordTextRect;
    calcFretTextRect;
    if mChordData = nil then
      mChordData := TChordData.Create; // DELPHI ADDED
    setChordData(mChordData);
  end;
  // NOTE : Rect size needed first, then strings , frets, and finally
  // finger position markers last!
  // add check for fret start.  If > 0 then don't draw guitar nut.
end;

procedure TGuitarChordBoxCoOrds.ChordDataInput(aChordData: TChordData);
begin
  // Generate Markerpoints in TchordData
  // Set Text, Starting Fret
end;

function TGuitarChordBoxCoOrds.NutRect(aRect: TrectF): TrectF;
begin
  // @TODO Needs to pull from mChordData!
  if mChordData.StartingFret <> 0 then
    Result := TrectF.Create(aChordBoxRect.left, aChordBoxRect.top,
      aChordBoxRect.right, aChordBoxRect.top)
  else
  begin
    Result.bottom := aRect.top + 1;
    Result.left := aRect.left - 1;
    Result.right := aRect.right + 1;
    Result.top := aRect.top - (Round(aRect.Height * 0.10));
  end;
end;

// @TODO add function for fret number point and remove nut drawing for chords
// that start on higher frets

// @TODO add method for chord name placement
// @TODO add method for string note / tuning placement

end.
