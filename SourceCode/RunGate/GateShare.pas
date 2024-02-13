unit GateShare;

interface
uses
  Windows, Messages, SysUtils, Classes, JSocket, WinSock, SyncObjs, IniFiles,
  Common, Grobal2;
const
  tRunGate = 8;

  g_sUpDateTime = '��������: 2012/05/01';
  BlockIPListName = '.\BlockIPList.txt';
  TeledataBlockIPListName = '.\Config\RunGate_BlockIPList.txt';
  ConfigFileName = '.\Config.ini';
  TeledataConfigFileName = '.\Config\Config.ini';

  RUNATEMAXSESSION = 1000;
  MSGMAXLENGTH = 200000;
  //SENDCHECKSIZE = 512;
  //SENDCHECKSIZEMAX = 20480;

  sSTATUS_FAIL = '+FAIL/';
  sSTATUS_GOOD = '+GOOD/';
  sSTATUS_SPEED = '+Fail/';
  sSTATUS_TIME = '+TIME/';
type
  TGList = class(TList)
  private
    GLock: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

  TBlockIPMethod = (mDisconnect, mBlock, mBlockList);
  TBlockSysMode = (mAllBlock, mSelfBolck, mClose, mDisMsg, mDisMsgorSys);
  TSockaddr = record
    nIPaddr: Integer;
    nCount: Integer;
    dwIPCountTick1: LongWord;
    nIPCount1: Integer;
    dwIPCountTick2: LongWOrd;
    nIPCount2: Integer;
    dwDenyTick: LongWord;
    nIPDenyCount: Integer;
  end;
  pTSockaddr = ^TSockaddr;

  TBlockaddr = record
    nBeginAddr: LongWord;
    nEndAddr: LongWord;
  end;
  pTBlockaddr = ^TBlockaddr;

  TConfig = record
    boCheckSpeed: Boolean;
    boHit: Boolean;
    boSpell: Boolean;
    boRun: Boolean;
    boWalk: Boolean;
    boTurn: Boolean;
    nHitTime: Integer;
    nSpellTime: Integer;
    nRunTime: Integer;
    nWalkTime: Integer;
    nTurnTime: Integer;
    nHitCount: Integer;
    nSpellCount: Integer;
    nRunCount: Integer;
    nWalkCount: Integer;
    nTurnCount: Integer;
    btSpeedControlMode: Byte;
    boSpeedShowMsg: Boolean;
    sSpeedShowMsg: string;
    btMsgColor: Byte;
    nIncErrorCount: Byte;
    nDecErrorCount: Byte;
  end;

  TGameSpeed = record
    dwHitTimeTick: LongWord;
    dwSpellTimeTick: LongWord;
    dwRunTimeTick: LongWord;
    dwWalkTimeTick: LongWord;
    dwTurnTimeTick: LongWord;
    nHitCount: Integer;
    nSpellCount: Integer;
    nRunCount: Integer;
    nWalkCount: Integer;
    nTurnCount: Integer;
  end;
  pTGameSpeed = ^TGameSpeed;

  TSessionInfo = record
    Socket: TCustomWinSocket;
    sSocData: string;
    sSendData: string;
    nUserListIndex: Integer;
    nPacketIdx: Integer;
    nPacketErrCount: Integer;
    //���ݰ�����ظ��������ͻ����÷���������ݼ�⣩
    boStartLogon: Boolean;
    boSendLock: Boolean;
    boOverNomSize: Boolean;
    nOverNomSizeCount: ShortInt;
    dwSendLatestTime: LongWord;
    //nCheckSendLength: Integer;
    //boSendAvailable: Boolean;
    //boSendCheck: Boolean;
    dwTimeOutTime: LongWord;
    nReceiveLength: Integer;
    dwReceiveLengthTick: LongWord;
    dwReceiveTick: LongWord;
    dwSendClientCheckTick: LongWord;
    dwSpeedTick: Integer;
    boLuck: Boolean;
    nSpeedTimeCount: integer;
    nSckHandle: Integer;
    sRemoteAddr: string;
    sUserName: string[15];
    nSessionID: Integer;
    sAccount: string[20];
    dwSuspendedTick: LongWord;
    dwSuspendedCount: Integer;
    dwSayMsgTick: LongWord; //���Լ������
    dwSayMsgCount: Integer;
    dwSayMsgCloseTime: LongWord;
    dwHitTick: LongWord; //����ʱ��
    GameSpeed: TGameSpeed;
  end;

  pTSessionInfo = ^TSessionInfo;
  TSendUserData = record
    nSocketIdx: Integer; //0x00
    nSocketHandle: Integer; //0x04
    sMsg: string; //0x08
  end;
  pTSendUserData = ^TSendUserData;
procedure AddMainLogMsg(Msg: string; nLevel: Integer);
procedure LoadBlockIPList();
procedure SaveBlockIPList();
procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
var
  g_Config: TConfig = (
    boHit: False;
    boSpell: False;
    boRun: False;
    boWalk: False;
    boTurn: False;
    nHitTime: 550;
    nSpellTime: 730;
    nRunTime: 440;
    nWalkTime: 440;
    nTurnTime: 440;
    nHitCount: 15;
    nSpellCount: 15;
    nRunCount: 15;
    nWalkCount: 15;
    nTurnCount: 15;
    btSpeedControlMode: 1;
    boSpeedShowMsg: True;
    sSpeedShowMsg:
    '����ʾ��: �밮����Ϸ����,��Ҫʹ�÷Ƿ����!';
    btMsgColor: 0;
    nIncErrorCount: 5;
    nDecErrorCount: 3;
    );

  g_boTeledata: Boolean = False;

  CS_MainLog: TCriticalSection;
  CS_FilterMsg: TCriticalSection;
  MainLogMsgList: TStringList;
  nShowLogLevel: Integer = 0;
  GateClass: string = 'RunGate';
  nMaxMemoListCount: Integer = 100;
  GateName: string = 'RunGate';

  TitleName: string = 'GameOfMir';

  ServerAddr: string = '127.0.0.1';
  ServerPort: Integer = 5000;
  GateAddr: string = '0.0.0.0';
  GatePort: Integer = 7200;
  CenterPort: Integer = 5600;
  CenterAddr: string = '127.0.0.1';
  boStarted: Boolean = False;
  boCenterReady: boolean = False;
  boClose: Boolean = False;
  boShowBite: Boolean = True; //��ʾB �� KB
  boServiceStart: Boolean = False;
  boGateReady: Boolean = False; //0045AA74 �����Ƿ����
  boCheckServerFail: Boolean = False;
  //���� <->��Ϸ������֮�����Ƿ�ʧ�ܣ���ʱ��
//  dwCheckServerTimeOutTime    :LongWord = 60 * 1000 ;//���� <->��Ϸ������֮���ⳬʱʱ�䳤��
  dwCheckServerTimeOutTime: LongWord = 3 * 60 * 1000;
  //���� <->��Ϸ������֮���ⳬʱʱ�䳤��
  AbuseList: TStringList; //004694F4
  SessionArray: array[0..RUNATEMAXSESSION - 1] of TSessionInfo;
  SessionCount: Integer; //0x32C ���ӻỰ��
  boShowSckData: Boolean; //0x324 �Ƿ���ʾSOCKET���յ���Ϣ

  sReplaceWord: string = '*';
  ReviceMsgList: TList; //0x45AA64
  //SendMsgList: TList; //0x45AA68
  nCurrConnCount: Integer;
  boSendHoldTimeOut: Boolean;
  dwSendHoldTick: LongWord;
  n45AA80: Integer;
  n45AA84: Integer;
  //dwCheckRecviceTick: LongWord;
  dwCheckRecviceMin: LongWord;
  dwCheckRecviceMax: LongWord;

  dwCheckServerTick: LongWord;
  dwCheckServerTimeMin: LongWord;
  dwCheckServerTimeMax: LongWord;
  SocketBuffer: PAnsiChar; //45AA5C
  nBuffLen: Integer; //45AA60
  List_45AA58: TList;
  boDecodeMsgLock: Boolean;
  dwProcessReviceMsgTimeLimit: LongWord;
  dwProcessSendMsgTimeLimit: LongWord;

  BlockIPList: TGList; //��ֹ����IP�б�
  TempBlockIPList: TGList; //��ʱ��ֹ����IP�б�
  IpList: TGList; //IP�ν�ֹ�����б�
  CurrIPaddrList: TGList;
  //AttackIPaddrList: TGList; //����IP��ʱ�б�

  nMaxClientPacketSize: Integer = 7000;
  nNomClientPacketSize: Integer = 200;
  nMaxClientMsgCount: Integer = 15;
  nEditSpeedCount: integer = 1;
  nEditSpeedTick: Integer = 60 * 1000;
  //nEditSpeedTime: Integer = 1000;
  //nMaxOverNomSizeCount: Integer = 2;

  nCheckServerFail: Integer = 0;
  //dwAttackTick: LongWord = 300;
  //nAttackCount: Integer = 5;
  g_dwGameCenterHandle: THandle;

  BlockMethod: TBlockIPMethod = mDisconnect;
  BlockSysMode: TBlockSysMode = mDisMsgorSys;
  boBlockSayMsg: Boolean = False;
  bokickOverPacketSize: Boolean = True;
  sDropFilterMsgAlert: string = '�����͵���Ϣ������˷Ƿ��ַ�[%s]��';

  //  nClientSendBlockSize        :Integer = 250; //���͸��ͻ������ݰ���С����
  nClientSendBlockSize: Integer = 8192; //���͸��ͻ������ݰ���С����

  nMaxConnOfIPaddr: Integer = 50;
  dwClientTimeOutTime: LongWord = 30 * 1000;
  dwSessionTimeOutTime: LongWord = 3 * 60 * 1000;
  dwSendClientCheckTime: LongWord = 60 * 1000;
  //���������ͻ��˷��ͼ��ͨ����Ϣ

  nIPCountLimitTime1: LongWord = 1000;
  nIPCountLimit1: Integer = 20;
  nIPCountLimitTime2: LongWord = 3000;
  nIPCountLimit2: Integer = 40;

  nSayMsgMaxLen: Integer = 70; //�����ַ�����
  nSayMsgTime: LongWord = 3000; //���Լ��ʱ��
  nSayMsgCount: Integer = 2; //���Դ���
  nSayMsgCloseTime: LongWord = 600000; //����ʱ��
  boBlockSay: Boolean = False;
  //�ͻ������ӻỰ��ʱ(ָ��ʱ����δ�����ݴ���)
  Conf: TIniFile;
  sConfigFileName: string;

  //sHintMsgPreFix: string = '����ʾ��';
  btRedMsgFColor: Byte = $FF; //ǰ��
  btRedMsgBColor: Byte = $38; //����
  btGreenMsgFColor: Byte = $DB; //ǰ��
  btGreenMsgBColor: Byte = $FF; //����
  btBlueMsgFColor: Byte = $FF; //ǰ��
  btBlueMsgBColor: Byte = $FC; //����

  boCCProtect: Boolean = True;

  nOldShowLogLevel: Integer = 0;
  nOldIPCountLimitTime1: LongWord = 1000;
  nOldIPCountLimit1: Integer = 20;
  nOldIPCountLimitTime2: LongWord = 3000;
  nOldIPCountLimit2: Integer = 40;
  boOldCheckClientMsg: Boolean = True;
  OldBlockMethod: TBlockIPMethod = mDisconnect;
  dwOldSessionTimeOutTime: LongWord = 3 * 60 * 1000;
  dwOldClientTimeOutTime: LongWord = 10 * 1000;
  nOldMaxConnOfIPaddr: Integer = 50;
implementation
uses
Hutil32;

procedure AddMainLogMsg(Msg: string; nLevel: Integer);
var
  tMsg: string;
begin
  try
    CS_MainLog.Enter;
    if nLevel <= nShowLogLevel then begin
      tMsg := '[' + TimeToStr(Now) + '] ' + Msg;
      MainLogMsgList.Add(tMsg);
    end;
  finally
    CS_MainLog.Leave;
  end;
end;
 {
procedure SaveAbuseFile();
var
  sFileName: string;
begin
  sFileName := '.\WordFilter.txt';
  try
    CS_FilterMsg.Enter;
    AbuseList.SaveToFile(sFileName);
  finally
    CS_FilterMsg.Leave;
  end;
end;

procedure LoadAbuseFile();
var
  sFileName: string;
begin
  AddMainLogMsg('���ڼ������ֹ���������Ϣ...', 4);
  sFileName := '.\WordFilter.txt';
  try
    CS_FilterMsg.Enter;
    AbuseList.Clear;
  finally
    CS_FilterMsg.Leave;
  end;
  if FileExists(sFileName) then begin
    try
      CS_FilterMsg.Enter;
      AbuseList.LoadFromFile(sFileName);
    finally
      CS_FilterMsg.Leave;
    end;
  end;
  AddMainLogMsg('���ֹ�����Ϣ�������...', 4);
end;   }

procedure LoadBlockIPList();
var
  i: Integer;
  sFileName: string;
  LoadList: TStringList;
  sIPaddr, sBeginaddr, sEndaddr: string;
  nBeginaddr, nEndaddr: Integer;
  Blockaddr: pTBlockaddr;
  IPaddr: pTSockaddr;
begin
  if g_boTeledata then sFileName := TeledataBlockIPListName
  else sFileName := BlockIPListName;
  
  for i := 0 to BlockIPList.Count - 1 do begin
    Dispose(pTSockaddr(BlockIPList[i]))
  end;
  BlockIPList.Clear;

  for i := 0 to IPList.Count - 1 do begin
    Dispose(pTBlockaddr(IPList[i]))
  end;
  IPList.Clear;
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sIPaddr := Trim(LoadList.Strings[i]);
      if sIPaddr = '' then
        Continue;
      sEndaddr := GetValidStr3(sIPaddr, sBeginaddr, [' ', #9]);
      nBeginaddr := inet_addr(PAnsiChar(AnsiString(sBeginaddr)));
      nEndaddr := inet_addr(PAnsiChar(AnsiString(sEndaddr)));
      if (nBeginaddr <> INADDR_NONE) and (nEndaddr <> INADDR_NONE) and (LongWord(nEndaddr) >= LongWord(nBeginaddr)) then begin
        New(Blockaddr);
        Blockaddr.nBeginAddr := nBeginaddr;
        Blockaddr.nEndAddr := nEndaddr;
        IPList.Add(Blockaddr);
      end else
      if (nBeginaddr <> INADDR_NONE) then begin
        New(IPaddr);
        SafeFillChar(IPaddr^, SizeOf(TSockaddr), 0);
        IPaddr.nIPaddr := nBeginaddr;
        BlockIPList.Add(IPaddr);
      end;
    end;
    LoadList.Free;
  end;
end;

procedure SaveBlockIPList();
var
  i: Integer;
  SaveList: TStringList;
  sFileName: string;
begin
  if g_boTeledata then sFileName := TeledataBlockIPListName
  else sFileName := BlockIPListName;
  SaveList := TStringList.Create;
  for i := 0 to IPList.Count - 1 do begin
    SaveList.Add(StrPas(inet_ntoa(TInAddr(pTBlockaddr(IPList[i]).nBeginAddr))) + #9 +
      StrPas(inet_ntoa(TInAddr(pTBlockaddr(IPList[i]).nEndAddr))));
  end;
  for I := 0 to BlockIPList.Count - 1 do begin
    SaveList.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(BlockIPList.Items[I]).nIPaddr))));
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
end;

procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(Word(tRunGate), wIdent);
  SendData.cbData := Length(AnsiString(sSendMsg)) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  Move(PAnsiChar(AnsiString(sSendMsg))^, PAnsiChar(AnsiString(SendData.lpData))^, Length(AnsiString(sSendMsg)) + 1);
  SendMessage(g_dwGameCenterHandle, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

constructor TGList.Create;
begin
  inherited Create;
  InitializeCriticalSection(GLock);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(GLock);
  inherited;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(GLock);
end;

procedure TGList.UnLock;
begin
  LeaveCriticalSection(GLock);
end;

initialization
  begin
    
    CS_MainLog := TCriticalSection.Create;
    CS_FilterMsg := TCriticalSection.Create;
    MainLogMsgList := TStringList.Create;
    AbuseList := TStringList.Create;
    ReviceMsgList := TList.Create;
    //SendMsgList := TList.Create;
    List_45AA58 := TList.Create;
    boShowSckData := False;
  end;

finalization
  begin
    List_45AA58.Free;
    ReviceMsgList.Free;
    //SendMsgList.Free;
    AbuseList.Free;
    MainLogMsgList.Free;
    CS_MainLog.Free;
    CS_FilterMsg.Free;

  end;

end.


