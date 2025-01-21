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
   // procedure Panel1Paint(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  gcb: TGuitarChordBoxCoOrds;

implementation

{$R *.lfm}

{ TForm1 }

{
procedure TForm1.Panel1Paint(Sender: TObject);
begin
  with panel1 do
  begin
    canvas.Brush.Style := bsDiagCross;
    canvas.Brush.Color := clBlue;
    canvas.Pen.Color := clLime;
    canvas.RoundRect(ClientRect, 60, 60);
  end;
end;
 }
procedure TForm1.FormCreate(Sender: TObject);
//var constrainForm : TConstraintSize;
begin
  //constrainForm.Size :=300;
  gcb := TGuitarChordBoxCoOrds.Create();
  //Form1.ConstrainedResize:=constrainForm;
  //gcb.stringLines(clientRect);
end;


procedure TForm1.FormPaint(Sender: TObject);
const
  shrinkRatio  = -0.925;
var
  tempRect: Trect;
begin
  Label2.Caption := IntToStr(clientRect.Width);
  Label3.Caption := IntToStr(clientRect.Height);
  //Form1.Height := Round(Form1.Width * 1.1);
  canvas.Pen.Width := Round(Form1.Width * 0.005);
  //seems to be good pen / width ratio!//5;
  tempRect := clientRect;
  InflateRect(tempRect,round(tempRect.width * shrinkRatio ),
    round(tempRect.Height * shrinkRatio ));// -50, -50);//change with ratio, not static

 // Label5.Caption := format('After Inflation tempRect Center ( %d, %d )', [temprect.CenterPoint.X ,
  //temprect.centerpoint.y]);

  Normalize(tempRect); //@TODO YAY Normalize works properly..sometimes drawin has issue ? !
  //@TODO needs Centered rec here !
  //  Label1.Caption := format('After Normalization tempRect Center ( %d, %d )', [temprect.CenterPoint.X ,
 // temprect.centerpoint.y]);

  // tempRect.Height := Round(tempRect.Width * 1);
  //make sure ratio of Trect is good
  drawMultiLines(canvas, (gcb.stringLines(tempRect)));
  canvas.brush.style := bsClear;
   canvas.Rectangle(tempRect);
  drawMultiLines(Canvas, gcb.fretLines(tempRect));

  canvas.brush.Style := bsSOlid;
  canvas.brush.color := clBlack ;
  canvas.Rectangle(gcb.NutRect(tempRect));
  canvas.brush.style := bsClear;
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
  //gcb.stringLines(Tform1.clientRect);

end.
