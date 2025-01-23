
unit GuitarChordBoxCoordinates;
{$mode DELPHI}
interface

//@TODO Graphics is only used for TCanvas on Draw Function remove after testing
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

  TfrtPnts = array [1..4] of TstrRec;

  TchrdDtPnts = array [1..6, 1..4] of Tpoint;

  TGuitarChordBoxCoOrds = class
  private
    aParentRect: Trect;
    aChordBoxRect: Trect;
    aFingerPoints: TchrdDtPnts;
    aFretPoints: TfrtPnts;
    aStringPoints: TstrPnts;
    blIsYCoOrd: boolean;
    function getCanvasRect: Trect;
    function GridRectFromParent(aRect: Trect): Trect;
    procedure setCanvasRect(aRect: Trect);
    // procedure fingerMarker(aRect: Trect);
  public
    procedure generate();
    constructor Create();
    //@TODO most will be private functions later
    function verifyCanvasRect(aRect: Trect): boolean;
    function stringLines(aRect: Trect): TstrPnts; //chnage to private
    function fretLines(aRect: Trect): TfrtPnts; //chnage to private
    property ParentCanvasRect: TRect read getCanvasRect write setCanvasRect;
    property reverseYCoOrds: boolean read isReveresedY write setReversedYCoords;
    function NutRect(aRect: Trect): Trect;
    procedure fingerMarker(aRect: Trect);
  end;


implementation

uses Types;

const
  shrinkRatio = -0.925; //ratio to shrink parent and get chord RECT

constructor TGuitarChordBoxCoOrds.Create();
begin
  aChordBoxRect := Trect.Create(0, 0, 0, 0);
  //@TODO create real function later
end;

function TGuitarChordBoxCoOrds.getCanvasRect: Trect;
begin
  Result := aParentRect;
end;

procedure TGuitarChordBoxCoOrds.setCanvasRect(aRect: Trect);
begin
  aParentRect := aRect;
  //@TODO run routine to recalc all points after change
end;

function TGuitarChordBoxCoOrds.stringLines(aRect: Trect): TstrPnts;
var
  output: TstrPnts;
  Count: integer;
  rec: TstrRec;
  spcing: longint;
begin
  spcing := Round(aRect.Width / 5);
  Count := 1;
  output := default(TstrPnts);
  while Count <= 4 do
  begin
    rec.start := Point(aRect.Left + (spcing * Count), (aRect.Top) + 1);
    rec.finish := Point(aRect.Left + (spcing * Count), (aRect.Bottom) - 1);
    output[low(output) + Count] := rec;
    Inc(Count);
  end;
  aStringPoints := output;
  Result := output;
end;

function TGuitarChordBoxCoOrds.fretLines(aRect: Trect): TfrtPnts;
var
  output: TfrtPnts;
  Count: integer;
  rec: TstrRec;
  spcing: longint;
begin
  spcing := Round(aRect.Height / 4);
  Count := 1;
  output := default(TfrtPnts);
  while Count <= 3 do
  begin
    rec.start := Point(aRect.Left, aRect.top + (Count * spcing) + 1);
    rec.finish := Point(aRect.right - 1, aRect.top + (Count * spcing) + 1);
    output[1 + (Count - 1)] := rec;
    Inc(Count);
  end;
  aFretPoints := output;
  Result := output;
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
begin
  if verifyCanvasRect(aRect) and InflateRect(aRect, -5, -5) then Result := aRect;
  //@TODO add method to increase top space on chord box for chord name and other
  //text needed
end;


procedure TGuitarChordBoxCoOrds.fingerMarker(aRect: Trect);
var
  tmpStrRect: TstrRec;
  tmpFrtRect: TstrRec;
  XofString: longint;
  YofFret: longint;
  SpacingAdjust: longint;
  gString, fPos: integer;
begin
  gString := 1;
  fPos := 1;
  SpacingAdjust := round(0.5 * ((aFretPoints[2].start.Y) - (aFretPoints[1].start.Y)));
  //@TODO Still need spacing Adjustment to place Y point between frets
  repeat
    while fPos <= 5 do
    begin
      aFingerPoints[gString, fPos] :=
        Point(aStringPoints[Gstring].start.X, aFretPoints[fPos].start.Y);
      Inc(fPos);
    end;
    fPos := 1;
    Inc(gString);
  until gString >= 6;
end;

procedure TGuitarChordBoxCoOrds.generate();
begin
  //
  //@@TODO chain functions to generate all coordinates needed.
  //
  // NOTE : Rect size needed first, then strings , frets, and finally
  //        finger position markers last!
  //        add check for fret start.  If > 0 then don't draw guitar nut.
end;


function TGuitarChordBoxCoOrds.NutRect(aRect: Trect): Trect;
begin
  Result.Bottom := arect.Top;
  Result.Left := aRect.Left;
  Result.Right := aRect.Right;
  Result.Top := Round(aRect.Height * 0.0325);
end;

//@TODO add function for fret number point and remove nut drawing for chords
//that start on higher frets

//@TODO add method for chord name placement
//@TODO add method for string note / tuning placement

end.
