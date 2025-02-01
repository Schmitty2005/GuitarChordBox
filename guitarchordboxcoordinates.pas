
unit GuitarChordBoxCoordinates;
{$IFDEF FPC}
{$mode DELPHI}
{$ENDIF}

interface

//@TODO ChordBox Rect needs to be moved to lower half of Parent rect to
//      make room for Muted Strings display and  Chord name text.
//@TODO Graphics is only used for TCanvas on Draw Function remove after testing
//      Types should be added and Graphics removed when finished.
uses
  Classes, SysUtils, Graphics;

type

  TChordSettings = record
    Placeholder: integer;
  end;

  TstrRec = record
    start: Tpoint;
    finish: Tpoint;
  end;

  TlinePoints = array of TstrRec;

  TstrPnts = array [1..6] of TstrRec;

  TfrtPnts = array [0..4] of TstrRec; //changed to 0..4 instead of 1..4 for
  //open  or muted markers

  TchrdDtPnts = array [1..6, 1..5] of
    Tpoint;//changed last array from [1..4] to [1..5] 1-29-25

  TMutedOpenPnts = array [1..6] of Tpoint;

  TGuitarStrings = (SixthStrng = 1, FifthStrng, FourthStrng, ThirdStrng,
    SecondStrng, FirstStrng);

  TFretNumber = (OpenString, FirstFret, SecondFret, ThirdFret, FourthFret);

  TChordData = record
    parentRect: Trect;
    chordBoxRect: Trect;
    fretPoints: TfrtPnts;
    strngPoints: TstrPnts;
    mutedPoints: TMutedOpenPnts;
  end;

  //@TODO make a record to encompass all of the points!

  { TGuitarChordBoxCoOrds }

  TGuitarChordBoxCoOrds = class
  private
    procedure calcChordTextRect;
    procedure calcFretTextRect;
  protected
    aStartFret: single;
    aParentRect: Trect;
    aChordBoxRect: Trect;
    aNutRect: Trect;// Not Implemented and needs to  be set in function!
    aFingerPoints: TchrdDtPnts;
    aFretPoints: TfrtPnts;
    aStringPoints: TstrPnts;
    aMuteOpenPoints: TMutedOpenPnts;
    aMarkerRect: TRect;
    aChordTextRect: Trect;//@TODO implement
    aFretTextRect: Trect; //@TODO implement

    function getCanvasRect: Trect;
    function getMarkerRect: Trect;  //may not be needed
    function GridRectFromParent(aRect: Trect): Trect; //private
    procedure setCanvasRect(aRect: Trect);
    procedure fingerMarkerCalc(aRect: Trect); //private
    function NutRect(aRect: Trect): Trect;    //change to proc to set class aNutRect
    function verifyCanvasRect(aRect: Trect): boolean; //private if used
    function stringLines(aRect: Trect): TstrPnts;  //private
    function fretLines(aRect: Trect): TfrtPnts;     //private
  public
    procedure generate();
    constructor Create();
    constructor Create(fParentRect: Trect); overload;
    function getFretMarkerPoint(gString: integer; gFret: integer): Tpoint;
    function getFretMarkerPoint(gString: TGuitarStrings;
      gFret: TFretNumber): Tpoint; overload;
    property ParentCanvasRect: TRect read getCanvasRect write setCanvasRect;
    property MarkerRect: Trect read getMarkerRect;
    procedure muteOpenMarker(aRect: Trect); //@TODO probably no longer needed
    function DrawOnCanvas(aCanvas: TCanvas): boolean;//@TODO move to ChordBoxCanvas Class
  end;


implementation

uses Types;

const
  cShrinkRatio = -0.925;
  cTopMoveRatio = 0.33;
  cBottomMoveRatio = 0.111;
  cSideMoveRatio = 0.15;
  cMarkerYRatio = 0.222; //@TODO this ratio is untested

  //This is TEMP............................


function centeredRect(const ARect: TRect; const bRect: TRect): TRect;
  //@TODO check if this even works correctly
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


procedure drawLine(aCanvas: Tcanvas; aStrRec: TstrRec); inline;
begin
  aCanvas.Line(astrRec.start, aStrRec.finish);
end;


procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: array of TstrRec);
  overload;
//untested!
var
  counter: integer;
begin
  counter := Low(aLinePoints);
  repeat
    drawline(aCanvas, aLinePoints[counter]);
    Inc(counter);
  until counter > high(aLinePoints);
end;

//@TODO These were reworked and should be copied over to ChordBoxCanvas
procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TstrPnts);
  overload; inline;
var
  counter: integer;
begin
  for counter := (low(aLinePoints) + 1) to (high(aLinePoints) - 1) do
    drawline(aCanvas, aLinePoints[counter]);
end;

procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TfrtPnts);
  overload; inline;
var
  counter: integer;
begin
  for counter := (low(aLinePoints) + 1) to (high(aLinePoints) - 1) do
    drawline(aCanvas, aLinePoints[counter]);
end;

// Above is temp for testing
//........................................

constructor TGuitarChordBoxCoOrds.Create();
begin
  aChordBoxRect := Trect.Create(0, 0, 0, 0);
  aStartFret := 0;
  //@TODO create real function later
end;

constructor TGuitarChordBoxCoOrds.Create(fParentRect: Trect); overload;
begin
  aParentRect := fParentRect;
  aStartFret := 0;
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
    (aParentRect.Height * cBottomMoveRatio) / 2);
  aChordTextRect.Bottom := aParentRect.Top +
    Round(1.8 * (aParentRect.Height * cBottomMoveRatio));
end;

procedure TGuitarChordBoxCoOrds.calcFretTextRect;
begin
  //TEMP
  aFretTextRect.Left := aParentRect.Left;
  aFretTextRect.Top := aChordBoxRect.Top;
  aFretTextRect.Bottom := aFretPoints[1].start.Y;
  aFretTextRect.Right := aChordBoxRect.Left;
end;

function TGuitarChordBoxCoOrds.getCanvasRect: Trect;
begin
  Result := aParentRect;
end;

function TGuitarChordBoxCoOrds.getMarkerRect: Trect;
begin
  Result := aMarkerRect;
end;

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
  rec.start := Point(30, 30);
  rec.finish := Point(80, 30); //@TODO check when this changes
  calcOutput[0] := rec;//(Point(30,30));// , Point (80,30));
  //@TODO add case for count = 0 to muted . open
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

function TGuitarChordBoxCoOrds.verifyCanvasRect(aRect: Trect): boolean;
const
  rectRatio = 1;
  //should possibly use a ratio of 1:1 !
begin
  if aRect.Height >= (Round(aRect.Width * rectRatio)) then Result := True
  else
    Result := False;
end;

function TGuitarChordBoxCoOrds.GridRectFromParent(aRect: Trect): Trect;
  //@TODO change to procedure that modifies class variable for chord box rect
begin
  //if verifyCanvasRect(aRect) and InflateRect(aRect, -5, -5) then
  begin
    aRect.Top := aRect.Top + Round(aParentRect.Height * cTopMoveRatio);
    aRect.Bottom := aRect.Bottom - Round(aParentRect.Height * cBottomMoveRatio);
    aRect.Left := aRect.Left + Round(aParentRect.Width * cSideMoveRatio);
    aRect.Right := aRect.Right - Round(aParentRect.Width * cSideMoveRatio);
    Result := aRect;
  end;
  aChordBoxRect := aRect;
end;

procedure TGuitarChordBoxCoOrds.muteOpenMarker(aRect: Trect);
//@TODO may be able to remove aRect : Trect later
//must be called after string coordinates created
var
  gstring: integer;
begin
  gString := 1;
  while gString <= 6 do
  begin
    aMuteOpenPoints[gString] :=
      Point(aStringPoints[gString].start.X, aChordBoxRect.Top - 12);
    //@TODO 12 is simply a placeholder for testing!
    //      It should be based on proper ratio  & spacing from nut rect
    Inc(gString);
  end;
end;

procedure TGuitarChordBoxCoOrds.fingerMarkerCalc(aRect: Trect);
//@TODO fix miscalc on high e / Sixth String
//@TODO Need to add open  / muted string in [0] of array
var
  SpacingAdjust: longint;
  gString, fPos: integer;
begin
  gString := 1;
  fPos := 1;
  SpacingAdjust := round(0.5 * ((aFretPoints[2].start.Y) - (aFretPoints[1].start.Y)));
  //@TODO check spacing for accuracy of fret versus array location
  repeat
    while fPos <= 5 do
    begin  //@TODO This is possibly going out of bounds
      aFingerPoints[gString, fPos] :=
        Point(aStringPoints[Gstring].start.X, (aFretPoints[fPos].start.Y) -
        SpacingAdjust);
      Inc(fPos);
    end;
    fPos := 1;
    Inc(gString);
  until gString > 6;
end;

procedure TGuitarChordBoxCoOrds.generate();
begin
  //@TODO add normalize here for aChordBoxRect!
  //normalize(aParentRect);
  if not aParentRect.IsEmpty then
  begin
    aChordBoxRect := GridRectFromParent(aParentRect);
    aStringPoints := stringLines(aChordBoxRect);
    aFretPoints := fretlines(aChordBoxRect);
    fingerMarkerCalc(aChordBoxRect);
    calcChordTextRect;
    calcFretTextRect;
  end;
  // NOTE : Rect size needed first, then strings , frets, and finally
  //        finger position markers last!
  //        add check for fret start.  If > 0 then don't draw guitar nut.
end;


function TGuitarChordBoxCoOrds.NutRect(aRect: Trect): Trect;
begin
  if aStartFret <> 0 then
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


function TGuitarChordBoxCoOrds.DrawOnCanvas(aCanvas: TCanvas): boolean;
begin
  aCanvas.Pen.Width := Round(aCanvas.Width * 0.005);

  aCanvas.Brush.Style := bsClear;
  aCanvas.Rectangle(aChordBoxRect);
  drawMultiLines(aCanvas, aStringPoints);
  drawMultiLines(aCanvas, aFretPoints);

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

//@TODO add function for fret number point and remove nut drawing for chords
//that start on higher frets

//@TODO add method for chord name placement
//@TODO add method for string note / tuning placement

end.
