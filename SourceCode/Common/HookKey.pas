unit HookKey;

interface
uses
  Windows, Messages;

const
  WH_KEYBOARD_LL = 13;
  //����һ�������ú������ĸ��ṹ�е�flags�Ƚ϶��ó�ALT���Ƿ���
  LLKHF_ALTDOWN = $20;

type
  tagKBDLLHOOKSTRUCT = packed record
    vkCode: DWORD; //�����ֵ
    scanCode: DWORD; //ɨ����ֵ��û���ù���
  {һЩ��չ��־�����ֵ�Ƚ��鷳��MSDN��˵��Ҳ��̫���ף�����
  ����������������־ֵ�ĵ���λ���������ƣ�Ϊ1ʱALT������Ϊ0�෴��}
    flags: DWORD;
    time: DWORD; //��Ϣʱ���
    dwExtraInfo: DWORD; //����Ϣ��ص���չ��Ϣ
  end;
  KBDLLHOOKSTRUCT = tagKBDLLHOOKSTRUCT;
  PKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;

function LowLevelKeyboardProc(nCode: Integer; WParam: WPARAM; LParam:
  LPARAM): LRESULT; stdcall;

function HookStar(): Boolean; //���ù���
function HookEnd(): Boolean;

implementation

var
  hhkLowLevelKybd: HHOOK = 0;

function LowLevelKeyboardProc(nCode: Integer; WParam: WPARAM; LParam:
  LPARAM): LRESULT; stdcall;
var
  fEatKeystroke: BOOL;
  p: PKBDLLHOOKSTRUCT;
begin
  Result := 0;
  fEatKeystroke := FALSE;
  p := PKBDLLHOOKSTRUCT(lParam);
  //nCodeֵΪHC_ACTIONʱ��ʾWParam��LParam���������˰�����Ϣ
  if (nCode = HC_ACTION) then
  begin
    //���ذ�����Ϣ�������Ƿ���Ctrl+Esc��Alt+Tab����Alt+Esc���ܼ���
    case wParam of
      WM_KEYDOWN,
        WM_SYSKEYDOWN,
        WM_KEYUP,
        WM_SYSKEYUP:
        //ShowMessage(IntToStr(p.vkCode));
    end;
  end;

  if fEatKeystroke = True then
    Result := 1;
  if nCode <> 0 then
    Result := CallNextHookEx(0, nCode, wParam, lParam);
end;

function HookStar(): Boolean; //���ù���
begin
  //���ü��̹���
  Result := False;
  if hhkLowLevelKybd = 0 then
  begin
    hhkLowLevelKybd := SetWindowsHookExW(WH_KEYBOARD_LL,
      LowLevelKeyboardProc,
      Hinstance,
      0);
    if hhkLowLevelKybd <> 0 then Result := True;
  end;
end;

function HookEnd(): Boolean;
begin
  Result := False;
  if hhkLowLevelKybd <> 0 then
    if UnhookWindowsHookEx(hhkLowLevelKybd) <> False then
    begin
      hhkLowLevelKybd := 0;
      Result := True;
    end;
end;

initialization
  begin
  end;

finalization
  begin
  end;

end.

