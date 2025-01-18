unit ChordBoxCanvas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics ,GuitarChordBoxCoordinates;

type
  TChordBoxCanvas = class(TGuitarChordBoxCoOrds)
  private
  placeholder : Boolean;
  public
    function DrawOnCanvas(aCanvas: TCanvas): boolean;
  end;




implementation

function TChordBoxCanvas.DrawOnCanvas(aCanvas: TCanvas): boolean;
begin

end;



end.

