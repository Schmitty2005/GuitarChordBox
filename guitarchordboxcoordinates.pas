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


  TGuitarChordBoxCoOrds = class
  private
    blIsYCoOrd: boolean;
    function getCanvasRect: Trect;
    procedure setCanvasRect(aRect: Trect);
    function isReveresedY(): boolean;
    procedure setReversedYCoords(setY: boolean);
    //function getCanvasX : Double;
    //procedure setCanvasX (xCoords: Double);
    //function getCanvasY : Double;
    //procedure setCanvasY (YCoords : Double);

  public
    //property CanvasX : Double  read getCanvasX write setCanvasX;
    //property CanvasY : Double read getCanvasY   write setCanvasY;
    property CanvasSize: TRect read getCanvasRect write setCanvasRect;
    property reverseYCoOrds: boolean read isReveresedY write setReversedYCoords;
  end;




implementation



function TGuitarChordBoxCoOrdsisReveresedY: boolean;
begin
  Result := True;
end;

function TGuitarChordBoxCoOrds.getCanvasRect: Trect;
begin
  ;
  Result := CanvasSize;
end;

procedure TGuitarChordBoxCoOrds.setCanvasRect(aRect: Trect);
begin
  CanvasSize := aRect;
end;

procedure TGuitarChordBoxCoOrds.setReversedYCoords(setY: boolean);
begin
  blisycoord := not blIsYCoOrd;
end;

function TGuitarChordBoxCoOrds.isReveresedY: boolean;
begin
  Result := blIsYCoOrd;
end;

//uses Classes;;

{
constructor TGuitarChordBoxCoOrds.Create;
begin
  inherited;
end;
 }



end.
