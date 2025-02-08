
unit GuitarChordBoxCoordinates;
{$IFDEF FPC}
{$mode DELPHI}
{$ENDIF}

interface

uses
  Classes, SysUtils
  {$IFDEF DCC}
  , System.Types
  {$ENDIF}
  , ChordData;

type
  TstrRec = record
    start: Tpoint;
    finish: Tpoint;
  end;

  TlinePoints = array of TstrRec;

  TstrPnts = array [1..6] of TstrRec;

  TfrtPnts = array [0..4] of TstrRec;

  TchrdDtPnts = array [1..6, 0..4] of Tpoint;

  TMutedOpenPnts = array [1..6] of Tpoint;

  TmarkerShape = (msCircle, msSquare, msTriangle, msStar);

  TGuitarStrings = (SixthStrng = 1, FifthStrng, FourthStrng, ThirdStrng,
    SecondStrng, FirstStrng);

  TFretNumber = (OpenString, FirstFret, SecondFret, ThirdFret, FourthFret, Muted);
   {
  TMarkerData = record
    Location: Tpoint;
    Shape: TmarkerShape;
    Text: string;
  end;

  TMarkerDataStrings = array [TGuitarStrings] of TMarkerData;
    }
  {
  TChordData = record
    Name: string;
    StartingFret: integer;
    MarkerData: TMarkerDataStrings;
  end;
   }
  //@TODO make a record to encompass all of the points!

  { TGuitarChordBoxCoOrds }

  TGuitarChordBoxCoOrds = class
  private

    mStartFret: byte;
    mChordText: string;  //not Implemented yet
    procedure calcChordTextRect;
    procedure calcFretTextRect;
    procedure fingerMarkerCalc;
    function getChordText: string;
    function getStartFret: byte;
    procedure setChordData(AValue: TChordData);
    procedure setChordText(AValue: string);
    procedure setStartFret(AValue: byte);
    function stringLines(aRect: Trect): TstrPnts;
    function fretLines(aRect: Trect): TfrtPnts;
    procedure GridRectFromParent(aRect: Trect);//: Trect;

  protected
    mChordData: TChordData;
    aParentRect: Trect;
    aChordBoxRect: Trect;
    aNutRect: Trect;// Not Implemented and needs to  be set in function!
    aFingerPoints: TchrdDtPnts;
    aFretPoints: TfrtPnts;
    aStringPoints: TstrPnts;
    //aMuteOpenPoints: TMutedOpenPnts;
    aMarkerRect: TRect;
    aChordTextRect: Trect;
    aFretTextRect: Trect;

    function getCanvasRect: Trect;
    //function getMarkerRect: Trect;  //may not be needed
    procedure setCanvasRect(aRect: Trect);
    function NutRect(aRect: Trect): Trect;    //change to proc to set class aNutRect
    //function verifyCanvasRect(aRect: Trect): boolean; //private if used

  public
    procedure generate();
    procedure ChordDataInput(aChordData: TChordData);
    constructor Create();
    constructor Create(const fParentRect: Trect); overload;
    function getFretMarkerPoint(gString: integer; gFret: integer): Tpoint;
    function getFretMarkerPoint(gString: TGuitarStrings;
      gFret: TFretNumber): Tpoint; overload;
    property ParentCanvasRect: TRect read getCanvasRect write setCanvasRect;
    property MarkerRect: Trect read aMarkerRect;//getMarkerRect;
    property StartFret: byte read getStartFret write setStartFret default 0;
    property ChordText: string read getChordText write setChordText;
    property ParentRect: Trect read aParentRect write aParentRect;
    property ChordData: TChordData read mChordData write mChordData;
  end;


implementation

{$IFDEF FPC}
uses Types;
{$ENDIF}

const
  cShrinkRatio = 0.925;
  cTopMoveRatio = 0.33;
  cBottomMoveRatio = 0.111;
  cSideMoveRatio = 0.15;
  cMarkerYRatio = 0.30;

  //This is TEMP............................


function centeredRect(const ARect: TRect; const bRect: TRect): TRect;
  //@TODO check if this even works correctly
var
  // aCenter: TPoint;
  outerSize, innerSize: TSize;
  xNew, yNew: longint;
begin
  xNew := 0;
  yNew := 0;
  //outerSize := Size(ARect);
  //innerSize := Size(bRect);
  outerSize := ARect.Size;
  innerSize := bRect.Size;

  if innerSize.cx > outerSize.cx then
    innerSize.cx := outerSize.cx;

  if innerSize.cy > outerSize.cy then
    innerSize.cy := outerSize.cy;

  //aCenter := centerpoint(ARect);
  Result := bounds(xNew, yNew, innerSize.cx, innerSize.cy);
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

constructor TGuitarChordBoxCoOrds.Create();
begin
  aChordBoxRect := Trect.Create(0, 0, 0, 0);
  mStartFret := 0;
end;

constructor TGuitarChordBoxCoOrds.Create(const fParentRect: Trect); overload;
begin
  aParentRect := fParentRect;
  mStartFret := 0;
  generate();
end;

function TGuitarChordBoxCoOrds.getFretMarkerPoint(gString: integer;
  gFret: integer): Tpoint;
begin
  Result := aFingerPoints[gString, gFret];
end;

function TGuitarChordBoxCoOrds.getFretMarkerPoint(gString: TGuitarStrings;
  gFret: TFretNumber): Tpoint; overload;
  //Do not use optmization .  Use -O- option.  Last line in calling method does not
  // get the result.
begin
  Result := aFingerPoints[Ord(gString), Ord(gFret)];
end;

procedure TGuitarChordBoxCoOrds.calcChordTextRect;
begin
  aChordTextRect.Left := aChordBoxRect.Left;
  aChordTextRect.Right := aChordBoxRect.Right;
  aChordTextRect.Top := aParentRect.Top + Round(
    (aParentRect.Height * cBottomMoveRatio) / 4);
  aChordTextRect.Bottom := aParentRect.Top +
    Round(1.7 * (aParentRect.Height * cBottomMoveRatio));
end;

procedure TGuitarChordBoxCoOrds.calcFretTextRect;
begin
  aFretTextRect.Left := aParentRect.Left;
  aFretTextRect.Top := aChordBoxRect.Top;
  aFretTextRect.Bottom := aFretPoints[1].start.Y;
  aFretTextRect.Right := aChordBoxRect.Left;
end;

function TGuitarChordBoxCoOrds.getCanvasRect: Trect;
begin
  Result := aParentRect;
end;

{
function TGuitarChordBoxCoOrds.getMarkerRect: Trect;
begin
  Result := aMarkerRect;
end;
 }
procedure TGuitarChordBoxCoOrds.setCanvasRect(aRect: Trect);
begin
  aParentRect := aRect;
  generate();
end;

function TGuitarChordBoxCoOrds.stringLines(aRect: Trect): TstrPnts;
var
  calcOutput: TstrPnts;
  Count: integer;
  rec: TstrRec;
  spcing, calc: longint;  //@TODO change to floate for accuracy ?
begin
  spcing := round((aRect.Width) / 5);
  calc := round(spcing * cShrinkRatio);
  aMarkerRect := Bounds(0, 0, calc, calc);
  Count := 0;
  calcOutput := Default(TstrPnts);
  while Count <= 5 do
  begin
    rec.start := Point(aRect.Left + (spcing * Count), (aRect.Top) + 1);
    rec.finish := Point(aRect.Left + (spcing * Count), (aRect.Bottom) - 1);
    calcOutput[low(calcOutput) + (Count)] := rec;
    Inc(Count);
  end;
  //@TODO Fix String Point Calculation for last string and bottom fret
  aStringPoints := calcOutput;
  Result := calcOutput;
end;

function TGuitarChordBoxCoOrds.fretLines(aRect: Trect): TfrtPnts;
var
  calcOutput: TfrtPnts;
  Count: integer;
  rec: TstrRec;
  spcing: longint;
begin
  spcing := Round(aRect.Height / 4);
  Count := 1;
  calcOutput := default(TfrtPnts);
  rec.start := Point(aRect.Left, Round(aParentRect.Height * cMarkerYRatio));
  //150);   //@TODO 80 is a placeholder
  rec.finish := Point(aRect.Right, Round(aParentRect.Height * cMarkerYRatio));
  //@TODO check when this changes
  calcOutput[0] := rec;
  while Count <= 4 do
  begin
    rec.start := Point(aRect.Left, aRect.top + (Count * spcing) + 1);
    rec.finish := Point(aRect.right - 1, aRect.top + (Count * spcing) + 1);
    calcOutput[1 + (Count - 1)] := rec;
    Inc(Count);
  end;
  aFretPoints := calcOutput;
  Result := calcOutput;
end;
{
function TGuitarChordBoxCoOrds.verifyCanvasRect(aRect: Trect): boolean;
const
  rectRatio = 1;
  //should possibly use a ratio of 1:1 !
begin
  if aRect.Height >= (Round(aRect.Width * rectRatio)) then Result := True
  else
    Result := False;
end;
}
procedure TGuitarChordBoxCoOrds.GridRectFromParent(aRect: Trect);
begin
  aRect.Top := aRect.Top + Round(aParentRect.Height * cTopMoveRatio);
  aRect.Bottom := aRect.Bottom - Round(aParentRect.Height * cBottomMoveRatio);
  aRect.Left := aRect.Left + Round(aParentRect.Width * cSideMoveRatio);
  aRect.Right := aRect.Right - Round(aParentRect.Width * cSideMoveRatio);
  aChordBoxRect := aRect;
end;


procedure TGuitarChordBoxCoOrds.fingerMarkerCalc;
var
  SpacingAdjust: longint;
  gString, fPos: integer;
begin
  gString := 1;
  fPos := 0;
  SpacingAdjust := round(0.5 * ((aFretPoints[2].start.Y) - (aFretPoints[1].start.Y)));
  repeat
    while fPos <= 5 do
    begin
      aFingerPoints[gString, fPos] :=
        Point(aStringPoints[Gstring].start.X, (aFretPoints[fPos].start.Y) -
        SpacingAdjust);
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

  mChordText := aValue.Name;
  mStartFret := aValue.StartingFret;

  aValue.MarkerData[SixthString].Location :=
    aFingerPoints[Ord(SixthString), Ord(aValue.SixthString.FretPosition)];
  aValue.MarkerData[SixthString].Text := aValue.SixthString.Text;

  aValue.MarkerData[FifthString].Location :=
    aFingerPoints[Ord(FifthString), Ord(aValue.FifthString.FretPosition)];
  aValue.MarkerData[FifthString].Text := aValue.FifthString.Text;

  aValue.MarkerData[FourthString].Location :=
    aFingerPoints[Ord(FourthString), Ord(aValue.FourthString.FretPosition)];
  aValue.MarkerData[FourthString].Text := aValue.FourthString.Text;

  aValue.MarkerData[ThirdString].Location :=
    aFingerPoints[Ord(ThirdString), Ord(aValue.ThirdString.FretPosition)];
  aValue.MarkerData[ThirdString].Text := aValue.ThirdString.Text;

  aValue.MarkerData[SecondString].Location :=
    aFingerPoints[Ord(SecondString), Ord(aValue.SecondString.FretPosition)];
  aValue.MarkerData[SecondString].Text := aValue.SecondString.Text;

  aValue.MarkerData[FirstString].Location :=
    aFingerPoints[Ord(FirstString), Ord(aValue.FirstString.FretPosition)];
  aValue.MarkerData[FirstString].Text := aValue.FirstString.Text;

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
  //@TODO add normalize here for aChordBoxRect!
  //normalize(aParentRect);
  if not aParentRect.IsEmpty then
  begin
    GridRectFromParent(aParentRect);
    aStringPoints := stringLines(aChordBoxRect);
    aFretPoints := fretlines(aChordBoxRect);
    fingerMarkerCalc;
    calcChordTextRect;
    calcFretTextRect;
    setChordData(mChordData);
  end;
  // NOTE : Rect size needed first, then strings , frets, and finally
  //        finger position markers last!
  //        add check for fret start.  If > 0 then don't draw guitar nut.
end;

procedure TGuitarChordBoxCoOrds.ChordDataInput(aChordData: TChordData);
begin
  //Generate Markerpoints in TchordData
  //Set Text, Starting Fret
end;


function TGuitarChordBoxCoOrds.NutRect(aRect: Trect): Trect;
begin
  //@TODO Needs to pull from mChordData!
  if mChordData.StartingFret <> 0 then
    Result := Trect.Create(aChordBoxRect.Left, aChordBoxRect.Top,
      aChordBoxRect.Right, aChordBoxRect.Top)
  else
  begin
    Result.Bottom := arect.Top + 1;
    Result.Left := aRect.Left;
    Result.Right := aRect.Right;
    Result.Top := aRect.Top - (round(aRect.Height * 0.10));
  end;
end;

//@TODO add function for fret number point and remove nut drawing for chords
//that start on higher frets

//@TODO add method for chord name placement
//@TODO add method for string note / tuning placement

end.
