program Cave;

uses
  Vcl.Forms,
  Uppale in 'Uppale.pas' {FPpale},
  UProtocol in 'UProtocol.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPpale, FPpale);
  Application.CreateForm(TFPpale, FPpale);
  Application.Run;
end.
