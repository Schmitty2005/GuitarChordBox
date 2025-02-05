unit ChordData;

{$MODE DELPHI}

interface

uses
  Classes, SysUtils, Types;

type
  TMarkerShape = (Circle, CircleEmpty, Square, SquareEmpty,
    Triangle, TriangleEmpty, StarSolid);

  TGuitarStrings = (SixthString = 1, FifthString, FourthString, ThirdString,
    SecondString, FirstString);

  TFretNumber = (OpenString, FirstFret, SecondFret, ThirdFret, FourthFret, Muted);

  TMarkerDataRec = record
    Location: Tpoint;
    Shape: TmarkerShape;
    Text: string;
  end;

  TMarkerData = class
  private
    mLabel: string;
    mString: TGuitarStrings;
    mFret: TFretNumber;
    mShape: TMarkerShape;
  public
    Location: Tpoint;
  published
    property Text: string read mLabel write mLabel;
    property StringNumber: TGuitarStrings read mString write mString;
    property FretPosition: TFretNumber read mFret write mFret;
    property Shape: TMarkerShape read mShape write mShape;
  end;

  TMarkerDataStrings = array [TGuitarStrings] of TMarkerDataRec; //For Compatibility


  { TChordData }

  TChordData = class

  private
    mChordText: string;
    mStartFret: byte;
    fSixthString: TMarkerData;
    fFifthString: TMarkerData;
    fFourthString: TMarkerData;
    fThirdString: TMarkerData;
    fSecondString: TMarkerData;
    fFirstString: TMarkerData;
  public
    MarkerData: TMarkerDataStrings;
    constructor Create();
    constructor Create(aChordName: string; StartFret: byte); overload;
    destructor Destroy (); override;
  published
    property Name: string read mChordText write mChordText;
    property StartingFret: byte read mStartFret write mStartFret;
    property SixthString: TMarkerData read fSixthString write fSixthString;
    property FifthString: TMarkerData read fFifthString write fFifthString;
    property FourthString: TMarkerData read fFourthString write fFourthString;
    property ThirdString: TMarkerData read fThirdString write fThirdString;
    property SecondString: TMarkerData read fSecondString write fSecondString;
    property FirstString: TMarkerData read fFirstString write fFirstString;
  end;

implementation

{ TChordData }

constructor TChordData.Create();
  //@TODO Also needs destructor!
begin
  mChordText := 'Empty';
  SixthString := TMarkerData.Create();
  FifthString := TMarkerData.Create();
  FourthString := TMarkerData.Create();
  ThirdString := TMarkerData.Create();
  SecondString := TMarkerData.Create();
  FirstString := TMarkerData.Create();
  fSixthString := TMarkerData.Create();
  fFifthString := TMarkerData.Create();
  fFourthString := TMarkerData.Create();
  fThirdString := TMarkerData.Create();
  fSecondString := TMarkerData.Create();
  fFirstString := TMarkerData.Create();
end;

constructor TChordData.Create(aChordName: string; StartFret: byte); overload;
begin
  mChordText := aChordName;
  mStartFret := StartFret;
end;

destructor TChordData.Destroy();
begin
     SixthString.Free;
  FifthString.Free;
  FourthString.Free;
  ThirdString.Free;
  SecondString.Free;
  FirstString.Free;
  fSixthString.Free;
  fFifthString.Free;
  fFourthString.Free;
  fThirdString.Free;
  fSecondString.Free;
  fFirstString.Free;

  inherited Destroy();
end;

end.
