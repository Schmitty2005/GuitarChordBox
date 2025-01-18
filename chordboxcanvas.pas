unit ChordBoxCanvas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, GuitarChordBoxCoordinates;

type
  TChordBoxCanvas = class(TGuitarChordBoxCoOrds)
  private
    placeholder: boolean;
  public
    function DrawOnCanvas(aCanvas: TCanvas): boolean;
  end;

procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TlinePoints);
procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TstrPnts); overload;
procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TfrtPnts); overload;



implementation

function drawLine(aCanvas: Tcanvas; aStrRec: TstrRec): boolean; inline;
begin
  aCanvas.Line(astrRec.start, aStrRec.finish);
  result := True; /// change to procedure later ?
end;

procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TlinePoints);
var
  fPoints: TstrRec;
begin
  for fPoints in aLinePoints do
    drawline(aCanvas, fPoints);
end;

procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TstrPnts); overload;
var
  fPoints: TstrRec;
begin
  for fPoints in aLinePoints do
    drawline(aCanvas, fPoints);
end;

procedure drawMultiLines(aCanvas: TCanvas; const aLinePoints: TfrtPnts); overload;
var
  fPoints: TstrRec;
begin
  for fPoints in aLinePoints do
    drawline(aCanvas, fPoints);
end;

function TChordBoxCanvas.DrawOnCanvas(aCanvas: TCanvas): boolean;
begin
  //need a Type for coordinates
end;



end.
