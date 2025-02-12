program DelphiChordBox;

uses
  Vcl.Forms,
  Unit4 in 'Unit4.pas' {Form4},
  GuitarChordBoxCoordinates in 'GuitarChordBoxCoordinates.pas',
  ChordData in 'ChordData.pas',
  ChordBoxCanvas in 'ChordBoxCanvas.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
