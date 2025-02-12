program FMXChordBoxProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX_ChordBox in 'FMX_ChordBox.pas' {Form6},
  FMXChordBoxCanvas in 'FMXChordBoxCanvas.pas',
  FMXChordData in 'FMXChordData.pas',
  FMXGuitarChordBoxCoordinates in 'FMXGuitarChordBoxCoordinates.pas',
  ChordCollection in 'ChordCollection.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.
