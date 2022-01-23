program Firework;

uses
  Vcl.Forms,
  uFireworkView in 'uFireworkView.pas' {fmFireworkView},
  uFireworkModel in 'uFireworkModel.pas',
  uTypes in 'uTypes.pas',
  uHelpers in 'uHelpers.pas',
  uFireworkController in 'uFireworkController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmFireworkView, fmFireworkView);
  Application.Run;
end.
