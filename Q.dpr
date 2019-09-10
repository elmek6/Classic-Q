program Q;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  global in 'global.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
