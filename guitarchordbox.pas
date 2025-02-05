unit GuitarChordBox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Types, GuitarChordBoxCoordinates, ChordBoxCanvas, ChordData;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;
  gcb, testBox, testFail, cbc: TGuitarChordBoxCoOrds;
  cbCanvasTester: TChordBoxCanvas;

  TestChord : TChordData;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  TestChord := TChordData.Create();
  TestChord.StartingFret :=1;
  TestChord.FifthString.Text:='A';
  TestChord.FifthString.StringNumber := SixthString;
  cbCanvasTester := TChordBoxCanvas.Create();
  TestChord.Name:='AMaj7';
  TestChord.StartingFret:=5;
  TestChord.MarkerData[(SixthString)].Text := 'TEST';
  TestChord.MarkerData[(SixthString)].Location := Point(150,150);// aFretPoints(ord(SixthStrng), ord(FirstFret));// Point(300,300);
end;


procedure TForm1.FormPaint(Sender: TObject);
begin
  Label2.Caption := 'Client Width : ' + IntToStr(clientRect.Width);
  Label3.Caption := 'Client Heigth: ' + IntToStr(clientRect.Height);
  // Label1.Caption := format('Parent Canvs Left: %d, Rigth : %d, Top: %d, Bottom: %d',
  //  [cbc.ParentCanvasRect.Left, cbc.ParentCanvasRect.Right,
  //  cbc.ParentCanvasRect.Top, cbc.ParentCanvasRect.Bottom]);
  cbCanvasTester.ParentCanvasRect := Form1.ClientRect;
  cbCanvasTester.StartFret := 0;
  //cbCanvasTester.ChordText := 'GMaj7';
  TestChord.StartingFret:=0;
    TestChord.Name := 'DMin7';

  TestChord.FifthString.Text := 'C5';
  TestChord.FifthString.FretPosition:=FirstFret; //@TODO No Method to Draw yet
  TestChord.SixthString.FretPosition:=FourthFret;
  TestChord.SixthString.Text := '6';
  cbCanvasTester.ChordData := TestChord;
  //TestChord.MarkerData[FifthString];


  {
  TestChord.MarkerData[SixthStrng].Location := cbCanvasTester.FingerPoints [ord (SixthStrng),ord( FourthFret)];
  TestChord.MarkerData[SixthStrng].Text:='64';
  TestChord.MarkerData[FirstStrng].Text := '11';
  TestChord.MarkerData[FirstStrng].Location := cbCanvasTester.FingerPoints[ord(FirstStrng), ord(FirstFret)];
  cbCanvasTester.ChordData := TestChord;

  with TestChord.MarkerData [FifthStrng] do
  begin
    Text :='53';
    Location := cbCanvasTester.FingerPoints[ord(FifthStrng), ord(ThirdFret)];
  end;

   with TestChord.MarkerData [FourthStrng] do
  begin
    Text :='4o';
    Location := cbCanvasTester.FingerPoints[ord(FourthStrng), ord(OpenString)];
  end;

    with TestChord.MarkerData [ThirdStrng] do
  begin
    Text :='31';
    Location := cbCanvasTester.FingerPoints[ord(ThirdStrng), ord(FirstFret)];
  end;

     with TestChord.MarkerData [SecondStrng] do
  begin
    Text :='22';
        Location := cbCanvasTester.FingerPoints[ord(SecondStrng), ord(SecondFret)];
  end;
   }
    cbCanvasTester.create(Form1.ClientRect, TestChord);
     cbCanvasTester.AutoPenWidth:=false;

     TestChord.MarkerData[FifthString].Text:='C#';
     {
     with TestChord do begin
       MarkerData[FourthString].Text :='A';
       MarkerData[ThirdString].Text := 'G';
     end;
     cbCanvasTester.ChordData := TestChord;
     with cbCanvasTester do
     begin
       SixthStringFinger := FourthFret;
       FifthStringFinger:= ThirdFret;
       FourthStringFinger:= SecondFret;
       ThirdStringFinger:= OpenString;
       SecondStringFinger:= FirstFret;
       FirstStringFinger:= OpenString;
     end;
    //SixthStringFinger := FourthFret;
     }

     cbCanvasTester.generate();
     //cbCanvasTester.create(Form1.ClientRect, TestChord);

  cbCanvasTester.DrawOnCanvas(Form1.Canvas);

 // cbCanvasTester.addMarker(FifthStrng, FirstFret, Form1.Canvas, 'A#');
 // cbCanvasTester.addMarker(SixthStrng, FourthFret, Form1.Canvas, 'Ab');
  //cbCanvasTester.addMarker(secondStrng, ThirdFret, Form1.Canvas,
  //  format('s:%df:%d', [Ord(secondStrng), Ord(ThirdFret)]));

  //cbCanvasTester.addMarker(FourthStrng, OpenString, Form1.Canvas,
  //  format('s:%df:%d', [Ord(FourthStrng), Ord(OpenString)]));
  //cbCanvasTester.addMarker(SixthStrng, OpenString, Form1.Canvas, 'o6');
  //cbCanvasTester.addMarker(FifthStrng, OpenString, Form1.Canvas, 'o5');
  //cbCanvasTester.addMarker(FourthStrng, OpenString, Form1.Canvas, 'o4');
  //cbCanvasTester.addMarker(ThirdStrng, OpenString, Form1.Canvas, 'o3');
  //cbCanvasTester.addMarker(SecondStrng, OpenString, Form1.Canvas, 'o2');
 // cbCanvasTester.addMarker(FirstStrng, OpenString, Form1.Canvas, 'o1');

  //cbCanvasTester.DrawOnCanvas(Form1.Canvas);
  //cbCanvasTester.drawXShape(Form1.Canvas, Point(300,300));
  //cbCanvasTester.DrawOShape(Form1.Canvas, Point(200,200));
 // cbCanvasTester.DrawTriShape(Form1.Canvas, Point(100, 250));
  {Test Chord Text Box}

  // Label1.Caption := 'Start Fret: ' + IntToStr(cbCanvasTester.StartFret);

  {===================}

end;


procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  gcb.Free;
  testBox.Free;
  testFail.Free;
  cbc.Free;
  cbCanvasTester.Free;

end;

begin

end.
