unit GuitarChordBox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  GuitarChordBoxCoordinates;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1Paint(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  gcb: TGuitarChordBoxCoOrds;

implementation

{$R *.lfm}

{ TForm1 }


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

procedure TForm1.FormCreate(Sender: TObject);
begin
   gcb := TGuitarChordBoxCoOrds.Create();
   //gcb.stringLines(clientRect);
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
  gcb.CanvasSize := Panel1.ClientRect;//ClientRect;
  label1.Caption := IntToStr(gcb.CanvasSize.Bottom);//.ToString());
     gcb.stringLines(clientRect);
     gcb.fretLines(clientRect);
     Label1.Caption := BoolToStr(gcb.verifyCanvasRect(Form1.ClientRect));
     Label2.Caption := IntToStr(clientRect.Width);
     Label3.Caption := IntToStr(clientRect.Height);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  gcb.Free;
end;

begin
    //gcb.stringLines(Tform1.clientRect);

end.
