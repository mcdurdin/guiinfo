unit UfrmGUIInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TGUIThreadInfoForm = class(TForm)
    lblFocus: TLabel;
    lblActive: TLabel;
    tmrUpdateLabels: TTimer;
    lblCapture: TLabel;
    lblFocusHandle: TLabel;
    lblActiveHandle: TLabel;
    lblCaptureHandle: TLabel;
    lblFocusClass: TLabel;
    lblActiveClass: TLabel;
    lblCaptureClass: TLabel;
    lblThread: TLabel;
    lblThreadName: TLabel;
    lblForeground: TLabel;
    lblForegroundHandle: TLabel;
    lblForegroundClass: TLabel;
    lblThreadHandle: TLabel;
    lblStatus: TLabel;
    procedure tmrUpdateLabelsTimer(Sender: TObject);
    procedure lblForegroundMouseEnter(Sender: TObject);
    procedure lblMouseLeave(Sender: TObject);
    procedure lblActiveMouseEnter(Sender: TObject);
    procedure lblFocusMouseEnter(Sender: TObject);
    procedure lblCaptureMouseEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FForegroundWindow: THandle;
    fgti: TGUIThreadInfo;
    FProcessName: string;
    FForegroundThreadID: Cardinal;
    FHighlightedWindow: THandle;
    FHighlightRect: TRect;
    FHighlightedLabel: TLabel;
    procedure UpdateStatus;
    procedure HighlightWindow(Sender: TObject; AHandle: THandle);
    procedure ClearHighlight;
    procedure DrawHighlightRect;
    procedure SetWindowInfo(ANewHandle, AOldHandle: THandle; lblHandle,
      lblClass: TLabel);
    function ReduceToBlack(c: TColor): TColor;
    procedure WMUser(var Message: TMessage); message WM_USER;
  end;

var
  GUIThreadInfoForm: TGUIThreadInfoForm;

implementation

uses
  System.Math,
  Winapi.psapi;

{$R *.dfm}

procedure TGUIThreadInfoForm.HighlightWindow(Sender: TObject; AHandle: THandle);
var
  r: TRect;
begin
  ClearHighlight;

  if AHandle > 0 then
  begin
    FHighlightedLabel := Sender as TLabel;
    FHighlightedLabel.Font.Color := clRed;
    FHighlightedWindow := AHandle;
    if GetWindowRect(AHandle, r) then
    begin
      FHighlightRect := r;
      DrawHighlightRect;
    end;
  end;
end;

procedure TGUIThreadInfoForm.DrawHighlightRect;
var
  lb: TLogBrush;
  dc: HDC;
  oldpen, pen: HPEN;
  oldrop: Integer;
  r: TRect;
begin
  if (FHighlightRect.Left = 0) and (FHighlightRect.Right = 0) then
    Exit;

  r := FHighlightRect;
  r.Left := Max(2, r.Left);
  r.Top := Max(2, r.Top);
  r.Right := Min(Screen.Width - 2, r.Right);
  r.Bottom := Min(Screen.Height - 2, r.Bottom);

  dc := GetDC(0);

  try
    FillChar(lb, sizeof(TLogBrush), 0);
    pen := CreatePen(PS_SOLID, 5, RGB($FF,0,0)); // PS_GEOMETRIC, 4, lb, 0, nil);
    oldpen := SelectObject(dc, pen);
    oldrop := SetROP2(dc, R2_XORPEN);
    SelectObject(dc, GetStockObject(NULL_BRUSH));
    Rectangle(dc, r.Left, r.Top, r.Right, r.Bottom);
    SetROP2(dc, oldrop);
    SelectObject(dc, oldpen);
  finally
    ReleaseDC(0, dc);
  end;
end;

procedure TGUIThreadInfoForm.FormCreate(Sender: TObject);
begin
  fgti.hwndActive := MAXINT;
  fgti.hwndFocus := MAXINT;
  fgti.hwndCapture := MAXINT;
  FForegroundThreadID := MAXINT;
  FForegroundWindow := MAXINT;

  PostMessage(Handle, WM_USER, 0, 0);
end;

procedure TGUIThreadInfoForm.WMUser(var Message: TMessage);
begin
  ShowWindow(Handle, SW_SHOWNOACTIVATE);
  Visible := True;
end;

procedure TGUIThreadInfoForm.ClearHighlight;
begin
  if Assigned(FHighlightedLabel) then
    FHighlightedLabel.Font.Color := clBlack;

  DrawHighlightRect;

  FHighlightedLabel := nil;
  FillChar(FHighlightRect, Sizeof(TRect), 0);
end;

procedure TGUIThreadInfoForm.lblActiveMouseEnter(Sender: TObject);
begin
  HighlightWindow(Sender, fgti.hwndActive);
end;

procedure TGUIThreadInfoForm.lblCaptureMouseEnter(Sender: TObject);
begin
  HighlightWindow(Sender, fgti.hwndCapture);
end;

procedure TGUIThreadInfoForm.lblFocusMouseEnter(Sender: TObject);
begin
  HighlightWindow(Sender, fgti.hwndFocus);
end;

procedure TGUIThreadInfoForm.lblForegroundMouseEnter(Sender: TObject);
begin
  HighlightWindow(Sender, FForegroundWindow);
end;

procedure TGUIThreadInfoForm.lblMouseLeave(Sender: TObject);
begin
  ClearHighlight;
end;

procedure TGUIThreadInfoForm.tmrUpdateLabelsTimer(Sender: TObject);
begin
  UpdateStatus;
end;

procedure TGUIThreadInfoForm.SetWindowInfo(ANewHandle, AOldHandle: THandle; lblHandle, lblClass: TLabel);
var
  buf: array[0..128] of char;
begin
  if ANewHandle = AOldHandle then
  begin
    lblHandle.Font.Color := ReduceToBlack(lblHandle.Font.Color);
    lblClass.Font.Color := ReduceToBlack(lblClass.Font.Color);
  end
  else
  begin
    lblHandle.Font.Color := clGreen;
    lblClass.Font.Color := clGreen;
    lblHandle.Caption := IntToHex(ANewHandle, 1);
    if ANewHandle = 0 then
    begin
      lblHandle.Caption := 'null';
      lblClass.Caption := '';
    end
    else
    begin
      if GetClassName(ANewHandle, buf, 128) = 0
        then lblClass.Caption := SysErrorMessage(GetLastError)
        else lblClass.Caption := buf;
    end;
  end;
end;

function TGUIThreadInfoForm.ReduceToBlack(c: TColor): TColor;
var
  r,g,b: Byte;
begin
  c := ColorToRGB(c);
  r := c and $FF;
  g := (c and $FF00) shr 8;
  b := (c and $FF0000) shr 16;

  if r > 4 then Dec(r, 4) else r := 0;
  if g > 4 then Dec(g, 4) else g := 0;
  if b > 4 then Dec(b, 4) else b := 0;

  Result := RGB(r,g,b);
end;

procedure TGUIThreadInfoForm.UpdateStatus;
var
  gti: TGUIThreadInfo;
  fg: THandle;
  hProcess: THandle;
  buf: array[0..260] of char;
  tid: Cardinal;
  pid: Cardinal;
begin
  gti.cbSize := SizeOf(gti);
  if not GetGUIThreadInfo(0, gti) then
  begin
    lblStatus.Caption := SysErrorMessage(GetLastError) + ' ' + IntToStr(GetLastError);
    lblStatus.Font.Color := clRed;
    Exit;
  end;

  lblStatus.ParentFont := True;
  lblStatus.Caption := 'Ready';

  fg := GetForegroundWindow;

  SetWindowInfo(fg, FForegroundWindow, lblForegroundHandle, lblForegroundClass);
  SetWindowInfo(gti.hwndActive, fgti.hwndActive, lblActiveHandle, lblActiveClass);
  SetWindowInfo(gti.hwndFocus, fgti.hwndFocus, lblFocusHandle, lblFocusClass);
  SetWindowInfo(gti.hwndCapture, fgti.hwndCapture, lblCaptureHandle, lblCaptureClass);

  tid := GetWindowThreadProcessId(fg, pid);

  if tid <> FForegroundThreadID then
  begin
    lblThreadHandle.Font.Color := clGreen;
    lblThreadHandle.Caption := IntToHex(tid, 1) + ' ('+IntToHex(pid, 1)+')';
    lblThreadHandle.Update;
    lblThreadName.Font.Color := clGreen;
    lblThreadName.Update;

    hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, pid);
    if hProcess = 0 then
    begin
      FProcessName := SysErrorMessage(GetLastError);
    end
    else
    begin
      if GetModuleFileNameEx(hProcess, 0, buf, 260) > 0
        then FProcessName := buf
        else FProcessName := SysErrorMessage(GetLastError);
      CloseHandle(hProcess);
    end;

    lblThreadName.Caption := FProcessName;
  end
  else
  begin
    lblThreadHandle.Font.Color := ReduceToBlack(lblThreadHandle.Font.Color);
    lblThreadHandle.Update;
    lblThreadName.Font.Color := ReduceToBlack(lblThreadName.Font.Color);
    lblThreadName.Update;
  end;

  FForegroundThreadID := tid;
  FForegroundWindow := fg;
  fgti := gti;
end;

end.
