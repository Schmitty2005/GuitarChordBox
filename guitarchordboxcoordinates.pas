unit GuitarChordBoxCoordinates;

{$mode DELPHI}


interface

uses
  Classes, SysUtils, Graphics; //Graphics is only used for TCanvas on Draw Function


type
  TFrettedStrings = record
    placeholder: integer;
  end;

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
  TchrdDtPnts = array [1..6, 1..4] of TstrRec;

  TGuitarChordBoxCoOrds = class
  private
    aFingerPoints : TchrdDtPnts;
    aFretPoints : TfrtPnts;
    aStringPoints : TstrPnts;
    blIsYCoOrd: boolean;
    constructor Create();
    function getCanvasRect: Trect;
    function GridRectFromParent(aRect: Trect): Trect;
    procedure setCanvasRect(aRect: Trect);
    function isReveresedY(): boolean;
    procedure setReversedYCoords(setY: boolean);
    procedure fingerMarker(aRect : Trect);
  public
    procedure generate();
    //possibly private functions later
    function verifyCanvasRect(aRect: Trect): boolean;
    function stringLines(aRect: Trect): TstrPnts; //chnage to private
    function fretLines(aRect: Trect): TfrtPnts; //chnage to private
    property CanvasSize: TRect read getCanvasRect write setCanvasRect;
    property reverseYCoOrds: boolean read isReveresedY write setReversedYCoords;
  end;




implementation

uses Types;

constructor TGuitarChordBoxCoOrds.Create();
begin
  CanvasSize := Trect.Create(0, 0, 0, 0);
end;

function TGuitarChordBoxCoOrdsisReveresedY: boolean;
begin
  Result := True;
end;

function TGuitarChordBoxCoOrds.getCanvasRect: Trect;
begin
   result:= Rect(0,0,0,0);//placeholder
end;

procedure TGuitarChordBoxCoOrds.setCanvasRect(aRect: Trect);
begin

end;

procedure TGuitarChordBoxCoOrds.setReversedYCoords(setY: boolean);
begin
  blisycoord := not blIsYCoOrd;
end;

function TGuitarChordBoxCoOrds.isReveresedY: boolean;
begin
  Result := blIsYCoOrd;
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
    rec.start := Point(aRect.Left + (spcing * Count), (aRect.Top)+1);
    rec.finish := Point(aRect.Left + (spcing * Count), (aRect.Bottom)-1);
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
end;


procedure TGuitarChordBoxCoOrds.fingerMarker(aRect : Trect);
var
  tmpPoint : TstrRec;
begin
  for tmpPoint in aStringPoints do
  begin
    //get x from aStringPoints for each string;
  end;

  for tmpPoint in aFretPoints do
  begin
    // get Y for each fret, subtract 1/2 of spacing !
  end;
end;

//uses Classes;;
procedure TGuitarChordBoxCoOrds.generate();
begin

end;



{
constructor TGuitarChordBoxCoOrds.Create;
begin
  inherited;
end;
 }



end.
