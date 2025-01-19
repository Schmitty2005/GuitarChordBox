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
procedure Normalize(var aRect: Trect);


implementation

procedure Normalize(var aRect: Trect);
begin

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
      left := left xor bottom;
    end;
  end;
end;

function drawLine(aCanvas: Tcanvas; aStrRec: TstrRec): boolean; inline;
begin
  aCanvas.Line(astrRec.start, aStrRec.finish);
  Result := True; /// change to procedure later ?
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
