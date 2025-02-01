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
  Label2.Caption := IntToStr(clientRect.Width);
  Label3.Caption := IntToStr(clientRect.Height);
  // Label1.Caption := format('Parent Canvs Left: %d, Rigth : %d, Top: %d, Bottom: %d',
  //  [cbc.ParentCanvasRect.Left, cbc.ParentCanvasRect.Right,
  //  cbc.ParentCanvasRect.Top, cbc.ParentCanvasRect.Bottom]);
  cbCanvasTester.ParentCanvasRect := Form1.ClientRect;
  cbCanvasTester.DrawOnCanvas(Form1.Canvas);
  cbCanvasTester.addMarker(FifthStrng, FirstFret, Form1.Canvas, 'A#');
  cbCanvasTester.addMarker(SixthStrng, FourthFret, Form1.Canvas, 'Ab');
  cbCanvasTester.addMarker(secondStrng, ThirdFret, Form1.Canvas,
    format('s:%df:%d', [Ord(secondStrng), Ord(ThirdFret)]));
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
