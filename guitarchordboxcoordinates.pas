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
    top: Tpoint;
    bottom: Tpoint;
  end;

  TstrPnts = array [1..6] of TstrRec;


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
    function stringPoints(aRect: Trect): TstrPnts;
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

function TGuitarChordBoxCoOrds.stringPoints(aRect: Trect): TstrPnts;
var
  output: TstrPnts;
  Count: integer;
  pnt: Tpoint;
  rec: TstrRec;
  spcing: longint;
begin
  pnt := Point(0, 0);
  //output := (pnt,pnt,pnt,pnt,pnt,pnt);
  spcing := Round(aRect.Width / 5);
  Count := 0;

  while Count <= 5 do
  begin
    pnt.Y := aRect.top;
    pnt.X := aRect.left + (spcing * Count);
    rec.top := pnt;

    pnt.Y := aRect.bottom;
    pnt.X := aRect.left + (spcing * Count);
    rec.bottom := pnt;

    output[Count] := rec;
    Inc(Count);
  end;
  Result := output;

end;

//uses Classes;;

{
constructor TGuitarChordBoxCoOrds.Create;
begin
  inherited;
end;
 }



end.
