unit GuitarChordBox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Types, GuitarChordBoxCoordinates, ChordBoxCanvas, ChordData,
  GuitarCBTypes, BGRABitmap, ChordBoxCanvasBGRA;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
   // procedure Image1Paint(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;
  gcb, testBox, testFail, cbc: TGuitarChordBoxCoOrds;
  cbCanvasTester: TChordBoxCanvasBGRA;//Changed from TChordBoxCanvas


  TestChord: TChordData;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  TestChord := TChordData.Create();
  //TestChord.StartingFret :=1;
  TestChord.FifthString.Text := 'ROOT';
  TestChord.FifthString.StringNumber := SixthString;
  cbCanvasTester := TChordBoxCanvasBGRA.Create();
  // TestChord.Name:='AMaj7';
  //TestChord.StartingFret:=5;
  cbCanvasTester.ChordData := TestChord;
  //TestChord.MarkerData[(SixthString)].Text := 'TEST';
  //TestChord.MarkerData[(SixthString)].Location := Point(150,150);// aFretPoints(ord(SixthStrng), ord(FirstFret));// Point(300,300);
end;


procedure TForm1.FormPaint(Sender: TObject);
var
  image: TBGRABitmap;
  sty : TTextStyle;
begin
  image := TBGRABitmap.Create(canvas.Width, canvas.Height);
  Label2.Caption := 'Client Width : ' + IntToStr(clientRect.Width);
  Label3.Caption := 'Client Heigth: ' + IntToStr(clientRect.Height);
  // Label1.Caption := format('Parent Canvs Left: %d, Rigth : %d, Top: %d, Bottom: %d',
  //  [cbc.ParentCanvasRect.Left, cbc.ParentCanvasRect.Right,
  //  cbc.ParentCanvasRect.Top, cbc.ParentCanvasRect.Bottom]);
  cbCanvasTester.ParentCanvasRect := Form1.ClientRect;
  //cbCanvasTester.ParentCanvasRect := Image1.ClientRect;
  //cbCanvasTester.ParentCanvasRect := ;
  //cbCanvasTester.StartFret := 0;
  //cbCanvasTester.ChordText := 'GMaj7';
  // TestChord.StartingFret:=0;
  // TestChord.Name := 'FMin7';
 {
  //Testing of Markers
  TestChord.FifthString.Text := 'C5';
  TestChord.FifthString.FretPosition:=FirstFret; //@TODO No Method to Draw yet
  TestChord.SixthString.FretPosition:=FourthFret;
  TestChord.SixthString.Text := '6';
  TestChord.SixthString.Shape := msTriangle;
  TestChord.FifthString.Shape := msSquare;
 // cbCanvasTester.ChordData := TestChord;
  //TestChord.MarkerData[FifthString];

  }
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

  cbCanvasTester.Create(Form1.ClientRect, TestChord);
  cbCanvasTester.AutoPenWidth := True;

  //TestChord.MarkerData[FifthString].Text:='C#';
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
     {
      cbCanvasTester.generate();
      TestChord.FifthString.FretPosition:=FirstFret;
      TestChord.FifthString.Text := 'Root';
      TestChord.FifthString.Shape:= msSquare;
      TestChord.ThirdString.Shape := msMuted;//@TODO Not Created yet!
      TestChord.FourthString.FretPosition := OpenString;
      TestChord.FourthString.Text:='O';
      TestChord.SecondString.FretPosition:= ThirdFret;
      TestChord.SecondString.Text := 'D';
      }
  TestChord.ezDataEntry('CMaj', 0, 0, 'X', 3, 'C', 2, 'E', 0, 'G', 1, 'C', 0, 'E');


  //TestChord.FifthString.Location := cbCanvasTester.getFretMarkerPoint(5,1);
  cbCanvasTester.generate();
  //cbCanvasTester.create(Form1.ClientRect, TestChord);
  //Image1.Canvas.Brush.Style := bsSolid;
  //Image1.Canvas.Brush.Color := clWhite;
  //Image1.Canvas.Clear;


  Image.Canvas.Brush.Style := bsSolid;
  Image.Canvas.Brush.Color := clWhite;
  Image.Canvas.Clear;

  cbCanvasTester.DrawOnCanvas(image.CanvasBGRA);

  {
  with image.CanvasBGRA  do
  begin
    Brush.Style:= bsSolid;
    Brush.Color:= clLime;
    Pen.COlor := clRed;
    Pen.Width:= 8;
    Ellipse(10,10,80,80);
    Pen.Width:=12;
    Brush.Color := clYellow;
    Pen.Color:= clBlue;
    FillRect(100,100,400,400);
    Rectangle(70,80,300,300,true);
   font.Height:=34;
   sty.Alignment := taCenter;
    TextRect(ClientRect, 40,40,'Hello BGRA BitMap',sty);
  end;
  }
  image.Draw(Form1.Canvas , ClientRect, False);

  //image.D
 // cbCanvasTester.DrawOnCanvas(Image1.Canvas);

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
    image.free;
end;

{
procedure TForm1.Image1Paint(Sender: TObject);
begin

  cbCanvasTester.DrawOnCanvas(Canvas);
end;
 }

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
