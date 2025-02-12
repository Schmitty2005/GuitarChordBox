unit ChordData;

{$MODE DELPHI}

interface

uses
  Classes, SysUtils, Types, GuitarCBTypes;

type
  {
  TMarkerShape = (msCircle, msCircleEmpty, msSquare, msSquareEmpty,
    msTriangle, msTriangleEmpty, msStarSolid);

  TGuitarStrings = (SixthString = 1, FifthString, FourthString, ThirdString,
    SecondString, FirstString);

  TFretNumber = (OpenString, FirstFret, SecondFret, ThirdFret, FourthFret, Muted);

  TMarkerDataRec = record
    Location: Tpoint;
    Shape: TmarkerShape;
    Text: string;
  end;
  }

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
    procedure setfFifthString(AValue: TMarkerData);
    procedure setfFirstString(AValue: TMarkerData);
    procedure setfFourthString(AValue: TMarkerData);
    procedure setfSecondString(AValue: TMarkerData);
    procedure setfSixthString(AValue: TMarkerData);
    procedure setfThirdString(AValue: TMarkerData);
  public
    MarkerData: TMarkerDataStrings; //@TODO This needs to get created with CoOrds
    constructor Create();
    constructor Create(aChordName: string; StartFret: byte); overload;
    destructor Destroy(); override;
    procedure ezDataEntry(ChordName: string; StartingFret: byte;
      String6Fret: byte; String6Text: string; String5Fret: byte;
      String5Text: string; String4Fret: byte; String4Text: string;
      String3Fret: byte; String3Text: string; String2Fret: byte;
      String2Text: string; String1Fret: byte; String1Text: string);
  published
    property Name: string read mChordText write mChordText;
    property StartingFret: byte read mStartFret write mStartFret;
    property SixthString: TMarkerData read fSixthString write setfSixthString;
    property FifthString: TMarkerData read fFifthString write setfFifthString;
    property FourthString: TMarkerData read fFourthString write setfFourthString;
    property ThirdString: TMarkerData read fThirdString write setfThirdString;
    property SecondString: TMarkerData read fSecondString write setfSecondString;
    property FirstString: TMarkerData read fFirstString write setfFirstString;

  end;

implementation

{ TChordData }

procedure TChordData.setfFifthString(AValue: TMarkerData);
begin
  fFifthString := AValue;
  //needs calc method to push data into MarkerData!
  //or not!  Pass TchordData to ChordCanvas to get MarkerData Generated!

end;

procedure TChordData.setfFirstString(AValue: TMarkerData);
begin
  if fFirstString = AValue then Exit;
  fFirstString := AValue;
end;

procedure TChordData.setfFourthString(AValue: TMarkerData);
begin
  if fFourthString = AValue then Exit;
  fFourthString := AValue;
end;

procedure TChordData.setfSecondString(AValue: TMarkerData);
begin
  if fSecondString = AValue then Exit;
  fSecondString := AValue;
end;

procedure TChordData.setfSixthString(AValue: TMarkerData);
begin
  if fSixthString = AValue then Exit;
  fSixthString := AValue;
end;

procedure TChordData.setfThirdString(AValue: TMarkerData);
begin
  if fThirdString = AValue then Exit;
  fThirdString := AValue;
end;

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

procedure TChordData.ezDataEntry(ChordName: string; StartingFret: byte;
  String6Fret: byte; String6Text: string; String5Fret: byte;
  String5Text: string; String4Fret: byte; String4Text: string;
  String3Fret: byte; String3Text: string; String2Fret: byte;
  String2Text: string; String1Fret: byte; String1Text: string);
begin
  //@TODO needs resolution for open and muted!
  //      maybe switch to Char type ?
  //@TODO needs function to reset all chord data!
  //      may need function added for no marker as well!

  mChordText := ChordName;
  mStartFret := StartingFret;
  fSixthString.FretPosition := TFretNumber(String6Fret);
  if String6Fret = 0 then fSixthString.Shape:= msCircleEmpty;
  if String6text = 'X' then fSixthString.Shape := msMuted
  else
    fSixthString.Text := String6Text;


  fFifthString.FretPosition := TFretNumber(String5Fret);
  if String5Fret = 0 then fFifthString.Shape:= msCircleEmpty;
  if String5text = 'X' then fFifthString.Shape := msMuted
  else
    fFifthString.Text := String5Text;

  fFourthString.FretPosition := TFretNumber(String4Fret);
  if String4Fret = 0 then fFourthString.Shape:= msCircleEmpty;
  if String4text = 'X' then fFourthString.Shape := msMuted
  else
    fFourthString.Text := String4Text;

  fThirdString.FretPosition := TFretNumber(String3Fret);
  if String3Fret = 0 then fThirdString.Shape:= msCircleEmpty;
  if String3text = 'X' then fThirdString.Shape := msMuted
  else
    fThirdString.Text := String3Text;

  fSecondString.FretPosition := TFretNumber(String2Fret);
  if String2Fret = 0 then fSecondString.Shape:= msCircleEmpty;
  if String2text = 'X' then fSecondString.Shape := msMuted
  else
    fSecondString.Text := String2Text;

  fFirstString.FretPosition := TFretNumber(String1Fret);
  if String1Fret = 0 then fFirstString.Shape:= msCircleEmpty;
  if String1text = 'X' then fFirstString.Shape := msMuted
  else
    fFirstString.Text := String1Text;
end;

end.
