unit GuitarChordBoxCoordinates;

{$mode DELPHI}


interface

uses
  Classes, SysUtils;

type
  TFrettedStrings = record
    placeholder: integer;
  end;

  TChordSettings = record
    Placeholder: integer;
  end;

  TstrRec = record
    top: Tpoint;  //change to start and end instead of top and bottom
    bottom: Tpoint;
  end;

  TstrPnts = array [1..6] of TstrRec;
  TfrtPnts = array [1..4] of TstrRec;


  TGuitarChordBoxCoOrds = class
  private
    blIsYCoOrd: boolean;
    constructor Create();
    function getCanvasRect: Trect;
    procedure setCanvasRect(aRect: Trect);
    function isReveresedY(): boolean;
    procedure setReversedYCoords(setY: boolean);
    //function getCanvasX : Double;
    //procedure setCanvasX (xCoords: Double);
    //function getCanvasY : Double;
    //procedure setCanvasY (YCoords : Double);

  public
    function verifyCanvasRect(aRect: Trect): boolean;
    function stringLines(aRect: Trect): TstrPnts; //chnage to private
    function fretLines(aRect: Trect): TfrtPnts; //chnage to private
    //property CanvasX : Double  read getCanvasX write setCanvasX;
    //property CanvasY : Double read getCanvasY   write setCanvasY;
    property CanvasSize: TRect read getCanvasRect write setCanvasRect;
    property reverseYCoOrds: boolean read isReveresedY write setReversedYCoords;
  end;




implementation

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
  output := default(TstrPnts);
  Count := 0;
  output := default(TstrPnts);
  while Count <= 5 do
  begin
    rec.top := Point(aRect.Top, aRect.left + (spcing * Count));
    rec.bottom := Point(aRect.Bottom, aRect.left + (spcing * Count));
    output[low(output) + Count] := rec;
    Inc(Count);
  end;
  Result := output;

end;

function TGuitarChordBoxCoOrds.fretLines(aRect: Trect): TfrtPnts;
var
  output: TfrtPnts;
  Count: integer;
  rec: TstrRec;
  spcing: longint;
begin
  spcing := Round(aRect.Width / 4);
  Count := 1;
  output := default(TfrtPnts);
  while Count <= 4 do
  begin
    rec.top := Point(aRect.Left, aRect.top + (Count * spcing));
    rec.bottom := Point(aRect.right, aRect.top + (Count * spcing));
    output[1 + (Count - 1)] := rec;
    Inc(Count);
  end;
  Result := output;

end;

function TGuitarChordBoxCoOrds.verifyCanvasRect(aRect: Trect): boolean;
const
  rectRatio = 1.3;// Temp suggested window ratio of 1 : 1.3 !
  //should possibly use a ratio of 1:1 !
begin
  if aRect.Height >= (Round(aRect.Width * rectRatio)) then Result := True
  else
    Result := False;
end;

//uses Classes;;

{
constructor TGuitarChordBoxCoOrds.Create;
begin
  inherited;
end;
 }



end.
