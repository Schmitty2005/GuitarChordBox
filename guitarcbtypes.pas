unit GuitarCBTypes;

{$mode DELPHI}

interface

uses
  Classes, SysUtils;

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

  // TmarkerShape = (msCircle, msSquare, msTriangle, msStar);
  TMarkerShape = (msCircle, msCircleEmpty, msMuted, msSquare, msSquareEmpty,
    msTriangle, msTriangleEmpty, msStarSolid);

  TGuitarStringsCO = (SixthStrng = 1, FifthStrng, FourthStrng, ThirdStrng,
    SecondStrng, FirstStrng);

  TFretNumber = (OpenString, FirstFret, SecondFret, ThirdFret, FourthFret, Muted);

 // TMarkerShape = (msCircle, msCircleEmpty, msSquare, msSquareEmpty,
  //  msTriangle, msTriangleEmpty, msStarSolid);

  TGuitarStrings = (SixthString = 1, FifthString, FourthString, ThirdString,
   SecondString, FirstString);

  //TFretNumber = (OpenString, FirstFret, SecondFret, ThirdFret, FourthFret, Muted);

  TMarkerDataRec = record
    Location: Tpoint;
    Shape: TmarkerShape;
    Fret : TFretNumber;
    Text: string;
  end;

implementation

end.
