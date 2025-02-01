unit GuitarChordBox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Types, GuitarChordBoxCoordinates, ChordBoxCanvas;

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

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  cbCanvasTester := TChordBoxCanvas.Create();
end;


procedure TForm1.FormPaint(Sender: TObject);
begin
  Label2.Caption :='Client Width : ' + IntToStr(clientRect.Width);
  Label3.Caption :='Client Heigth: ' + IntToStr(clientRect.Height);
  // Label1.Caption := format('Parent Canvs Left: %d, Rigth : %d, Top: %d, Bottom: %d',
  //  [cbc.ParentCanvasRect.Left, cbc.ParentCanvasRect.Right,
  //  cbc.ParentCanvasRect.Top, cbc.ParentCanvasRect.Bottom]);
  cbCanvasTester.ParentCanvasRect := Form1.ClientRect;
  cbCanvasTester.StartFret := 5;
  cbCanvasTester.ChordText := 'GMaj7';
  cbCanvasTester.DrawOnCanvas(Form1.Canvas);
  cbCanvasTester.addMarker(FifthStrng, FirstFret, Form1.Canvas, 'A#');
  cbCanvasTester.addMarker(SixthStrng, FourthFret, Form1.Canvas, 'Ab');
  //cbCanvasTester.addMarker(secondStrng, ThirdFret, Form1.Canvas,
  //  format('s:%df:%d', [Ord(secondStrng), Ord(ThirdFret)]));

  //cbCanvasTester.addMarker(FourthStrng, OpenString, Form1.Canvas,
  //  format('s:%df:%d', [Ord(FourthStrng), Ord(OpenString)]));
  cbCanvasTester.addMarker(SixthStrng, OpenString, Form1.Canvas, 'o6');
  //cbCanvasTester.addMarker(FifthStrng, OpenString, Form1.Canvas, 'o5');
  //cbCanvasTester.addMarker(FourthStrng, OpenString, Form1.Canvas, 'o4');
  //cbCanvasTester.addMarker(ThirdStrng, OpenString, Form1.Canvas, 'o3');
  //cbCanvasTester.addMarker(SecondStrng, OpenString, Form1.Canvas, 'o2');
  cbCanvasTester.addMarker(FirstStrng, OpenString, Form1.Canvas, 'o1');
  ;
  //cbCanvasTester.DrawOnCanvas(Form1.Canvas);
    //cbCanvasTester.drawXShape(Form1.Canvas, Point(300,300));
    //cbCanvasTester.DrawOShape(Form1.Canvas, Point(200,200));
    cbCanvasTester.DrawTriShape(Form1.Canvas, Point(100,250));
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
