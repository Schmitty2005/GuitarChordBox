unit ChordData;

{$MODE DELPHI}

interface

uses
  Classes, SysUtils, Types;

type
  TMarkerShape = (Circle, CircleEmpty, Square, SquareEmpty,
    Triangle, TriangleEmpty, StarSolid);

  TMarkerData = class
  private
    mLabel: string;
    mLocation: Tpoint;
    mShape: TMarkerShape;
  published
    property ShapeText: string read mLabel write mLabel;
    property Xlocation: longint read mLocation.x write mLocation.x;
    property Ylocation: longint read mLocation.y write mLocation.y;
    property Shape: TMarkerShape read mShape write mShape;
  end;

  TChordData = class
  type
    TStrings = (sixth = 1, fifth, fourth, third, second, First);
  private
    mChordText: string;
    mStartFret: byte;
  public
    SixthString: TMarkerData;
    FifthString: TMarkerData;
    FourthString: TMarkerData;
    ThirdString: TMarkerData;
    SecondString: TMarkerData;
    FirstString: TMarkerData;
  published
    property ChordText: string read mChordText write mChordText;
    property StartFret: byte read mStartFret write mStartFret;
  end;

implementation

end.
