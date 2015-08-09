program guiinfo;

uses
  Vcl.Forms,
  UfrmGUIInfo in 'UfrmGUIInfo.pas' {GUIThreadInfoForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := False;
  Application.CreateForm(TGUIThreadInfoForm, GUIThreadInfoForm);
  Application.Run;
end.
