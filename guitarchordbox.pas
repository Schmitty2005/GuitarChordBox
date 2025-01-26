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
    procedure Panel1Click(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;
  gcb: TGuitarChordBoxCoOrds;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  gcb := TGuitarChordBoxCoOrds.Create();
end;


procedure TForm1.FormPaint(Sender: TObject);
const
  shrinkRatio =-0.85;// -0.925;
var
  tempRect: Trect;
begin
  Label2.Caption := IntToStr(clientRect.Width);
  Label3.Caption := IntToStr(clientRect.Height);
  //Form1.Height := Round(Form1.Width * 1.1);
  canvas.Pen.Width := Round(Form1.Width * 0.005);
  //seems to be good pen / width ratio!//5;
  tempRect := clientRect;
  InflateRect(tempRect, round(tempRect.Width * shrinkRatio),
    round((tempRect.Height *  shrinkRatio)));// -50, -50);//change with ratio, not static


  Normalize(tempRect);
  //@TODO Normalize works properly..sometimes drawin has issue ? !

  drawMultiLines(canvas, (gcb.stringLines(tempRect)));
  canvas.brush.style := bsClear;
  canvas.Rectangle(tempRect);
  drawMultiLines(Canvas, gcb.fretLines(tempRect));

  canvas.brush.Style := bsSOlid;
  canvas.brush.color := clBlack;
  canvas.Rectangle(gcb.NutRect(tempRect));
  canvas.brush.style := bsClear;

  gcb.fingerMarker(tempRect);

 // addMarker(Point(34,434), Canvas, 'D');
 addMarker (gcb.getFretMarkerPoint(1,1), canvas, '1F');
 addMarker (gcb.getFretMarkerPoint(2,1), canvas, 'A#');
 addMarker (gcb.getFretMarkerPoint(3,1), canvas, 'D#');
 addMarker (gcb.getFretMarkerPoint(4,1), canvas, 'G#');
 addMarker (gcb.getFretMarkerPoint(5,1), canvas, 'C');
 addMarker (gcb.getFretMarkerPoint(6,1), canvas, '2F');
  addMarker (gcb.getFretMarkerPoint(2,2), canvas,'G');
  //Form1.Invalidate;
  //Form1.Refresh;
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
{
var
  tempRect: Trect;
begin
  gcb.CanvasSize := Panel1.ClientRect;//ClientRect;
  label1.Caption := IntToStr(gcb.CanvasSize.Bottom);//.ToString());
  Label1.Caption := BoolToStr(gcb.verifyCanvasRect(Form1.ClientRect));
  Label2.Caption := IntToStr(clientRect.Width);
  Label3.Caption := IntToStr(clientRect.Height);

  // Form1.Height := Round(Form1.Width *1.1);
  canvas.Pen.Width := Round(Form1.Width * 0.005);
  //seems to be good pen / width ratio!//5;
  tempRect := clientRect;
  InflateRect(tempRect, -20, -20);
  gcb.stringLines(tempRect);
  gcb.fretLines(tempRect);

  drawMultiLines(canvas, (gcb.stringLines(tempRect)));
  canvas.brush.style := bsClear;
  //canvas.Rectangle(tempRect);
  drawMultiLines(Canvas, gcb.fretLines(tempRect));
  // Form1.Invalidate;
  //Form1.Refresh;
  }
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  gcb.Free;
end;

begin

end.
