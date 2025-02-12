unit FMX_ChordBox;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMXGuitarChordBoxCoordinates,
  FMXChordData, FMXChordBoxCanvas, ChordCollection;

type
  TForm6 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;
  gcb: TGuitarChordBoxCoOrds;
  tcd: TChordData;
  cbc: TChordBoxCanvas;
  cc : TChordCollection;

implementation

{$R *.fmx}

procedure TForm6.FormActivate(Sender: TObject);
begin
  tcd := TChordData.Create();

  cbc := TChordBoxCanvas.Create;
  cbc.ChordData := TChordData.Create;

  // cbc := TChordBoxCanvas.Create(Trect.Create(0, 0, 300, 300));
  tcd.StartingFret := 5;
  cbc.ChordData := tcd;
  cbc.ParentCanvasRect := TRectF.Create(Form6.ClientRect); // Form4.ClientRect;
  // cbc := TChordBoxCanvas.Create(Form4.ClientRect);
  // cbc.ChordData := tcd;

  // gcb.ChordDataInput(tcd);
  // gcb.ChordData := tcd;
  // gcb.ParentCanvasRect := Trect.Create(0, 0, 300, 300); // Form4.ClientRect;
  // gcb.fretLines(Form4.ClientRect);

  // Form4.canvas.Rectangle(gcb.NutRect(Form4.ClientRect));

end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  tcd := TChordData.Create;
  tcd.Name := 'G/A Maj7';
end;

procedure TForm6.FormPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  tcd.StartingFret := 0;
  with tcd.SixthString do
  begin
    text := 'F';
    FretPosition := FirstFret;
  end;

  tcd.Name := 'G/EMaj7';

  with tcd do
  begin
    FifthString.text := 'C';
    FifthString.FretPosition := ThirdFret;
    FourthString.text := 'F#';
    FourthString.FretPosition := FourthFret;
    ThirdString.FretPosition := SecondFret;
    ThirdString.text := 'A';
    SecondString.FretPosition := FirstFret;
    SecondString.text := 'C';
    FirstString.FretPosition := ThirdFret;
    FirstString.text := 'F';
    // tcd.StartingFret := 3; //@TODO Fix Delphi Fret Number
  end;

  cbc.AutoPenWidth := true; // False;
  cbc.ManualPenWidth := 5;
  var
  R := Form6.ClientRect;

  cbc.ParentCanvasRect := TRectF.Create(Form6.ClientRect);

  cbc.DrawOnCanvas(Form6.Canvas);
end;

end.
