program Cave;

uses
  Vcl.Forms,
  Uppale in 'Uppale.pas' {FPpale};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPpale, FPpale);
  Application.Run;
end.
