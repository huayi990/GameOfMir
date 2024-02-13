unit svMain;
                                                 
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JSocket, ExtCtrls, Buttons, StdCtrls, IniFiles, M2Share,
  Grobal2, SDK, HUtil32, RunSock, Envir, ItmUnit, Magic, Guild, Event,
  Castle, FrnEngn, UsrEngn, MudUtil, SyncObjs, Menus, ComCtrls, Grids, ObjBase,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, RzCommon, Common,
  RzEdit, RzPanel, RzSplit, RzGrids, ImgList, ImageHlp;

const
  WM_RUN_OK = WM_USER + 1080;

type
  TFrmMain = class(TForm)
    Timer1: TTimer;                        
    RunTimer: TTimer;
    DBSocket: TClientSocket;
    ConnectTimer: TTimer;
    StartTimer: TTimer;
    SaveVariableTimer: TTimer;
    CloseTimer: TTimer;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_CONTROL_RELOAD_CONF: TMenuItem;
    MENU_CONTROL_CLEARLOGMSG: TMenuItem;
    MENU_HELP: TMenuItem;
    MENU_HELP_ABOUT: TMenuItem;
    MENU_MANAGE: TMenuItem;
    MENU_CONTROL_RELOAD: TMenuItem;
    MENU_CONTROL_RELOAD_ITEMDB: TMenuItem;
    MENU_CONTROL_RELOAD_MAGICDB: TMenuItem;
    MENU_CONTROL_RELOAD_MONSTERDB: TMenuItem;
    MENU_MANAGE_PLUG: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_SERVERCONFIG: TMenuItem;
    MENU_OPTION_GAME: TMenuItem;
    MENU_OPTION_FUNCTION: TMenuItem;
    MENU_CONTROL_RELOAD_MONSTERSAY: TMenuItem;
    MENU_CONTROL_RELOAD_DISABLEMAKE: TMenuItem;
    MENU_CONTROL_GATE: TMenuItem;
    MENU_CONTROL_GATE_OPEN: TMenuItem;
    MENU_CONTROL_GATE_CLOSE: TMenuItem;
    MENU_VIEW: TMenuItem;
    MENU_VIEW_SESSION: TMenuItem;
    MENU_VIEW_ONLINEHUMAN: TMenuItem;
    MENU_VIEW_LEVEL: TMenuItem;
    MENU_VIEW_LIST: TMenuItem;
    MENU_MANAGE_ONLINEMSG: TMenuItem;
    MENU_VIEW_KERNELINFO: TMenuItem;
    MENU_TOOLS: TMenuItem;
    MENU_TOOLS_MERCHANT: TMenuItem;
    MENU_TOOLS_NPC: TMenuItem;
    MENU_OPTION_ITEMFUNC: TMenuItem;
    MENU_TOOLS_MONGEN: TMenuItem;
    G1: TMenuItem;
    MENU_OPTION_MONSTER: TMenuItem;
    MENU_TOOLS_IPSEARCH: TMenuItem;
    MENU_MANAGE_CASTLE: TMenuItem;
    IdUDPClientLog: TIdUDPClient;
    RzSplitter: TRzSplitter;
    RzSplitter1: TRzSplitter;
    QFunctionNPC: TMenuItem;
    QManageNPC: TMenuItem;
    RobotManageNPC: TMenuItem;
    MonItems: TMenuItem;
    MemoLog: TMemo;
    GridGate: TStringGrid;
    Panel1: TPanel;
    LbUserCount: TLabel;
    LbRunTime: TLabel;
    Label20: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    LabelMon: TLabel;
    LabelVersion: TLabel;
    OpenDialog: TOpenDialog;
    P1: TMenuItem;
    MENU_TOOLS_TEST: TMenuItem;
    E1: TMenuItem;
    S1: TMenuItem;
    M1: TMenuItem;
    GateSocket: TServerSocket;
    MENU_MANAGE_SHOP: TMenuItem;
    N2: TMenuItem;
    B1: TMenuItem;
    MENU_CONTROL_TESTSERVER: TMenuItem;
    MENU_TOOLS_OFFLINE: TMenuItem;
    MENU_TOOLS_OFFLINE_SAVENAME: TMenuItem;
    MENU_TOOLS_OFFLINE_LOADNAME: TMenuItem;
    V1: TMenuItem;
    L1: TMenuItem;
    NPC1: TMenuItem;
    F1: TMenuItem;
    MENU_MANAGE_ONLINEEMAIL: TMenuItem;
    MENU_VIEW_COM: TMenuItem;

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MemoLogChange(Sender: TObject);
    procedure MemoLogDblClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_CONFClick(Sender: TObject);
    procedure MENU_CONTROL_CLEARLOGMSGClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_ITEMDBClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MAGICDBClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MONSTERDBClick(Sender: TObject);
    procedure MENU_HELP_ABOUTClick(Sender: TObject);
    procedure MENU_OPTION_SERVERCONFIGClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_GAMEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MENU_OPTION_FUNCTIONClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MONSTERSAYClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_DISABLEMAKEClick(Sender: TObject);
    procedure MENU_CONTROL_GATE_OPENClick(Sender: TObject);
    procedure MENU_CONTROL_GATE_CLOSEClick(Sender: TObject);
    procedure MENU_CONTROLClick(Sender: TObject);
    procedure MENU_VIEW_GATEClick(Sender: TObject);
    procedure MENU_VIEW_SESSIONClick(Sender: TObject);
    procedure MENU_VIEW_ONLINEHUMANClick(Sender: TObject);
    procedure MENU_VIEW_LEVELClick(Sender: TObject);
    procedure MENU_VIEW_LISTClick(Sender: TObject);
    procedure MENU_MANAGE_ONLINEMSGClick(Sender: TObject);
    procedure MENU_VIEW_KERNELINFOClick(Sender: TObject);
    procedure MENU_TOOLS_MERCHANTClick(Sender: TObject);
    procedure MENU_OPTION_ITEMFUNCClick(Sender: TObject);
    procedure MENU_TOOLS_MONGENClick(Sender: TObject);
    procedure MENU_MANAGE_PLUGClick(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure MENU_OPTION_MONSTERClick(Sender: TObject);
    procedure MENU_TOOLS_IPSEARCHClick(Sender: TObject);
    procedure MENU_MANAGE_CASTLEClick(Sender: TObject);
    procedure QFunctionNPCClick(Sender: TObject);
    procedure QManageNPCClick(Sender: TObject);
    procedure RobotManageNPCClick(Sender: TObject);
    procedure MonItemsClick(Sender: TObject);
    procedure MENU_TOOLS_NPCClick(Sender: TObject);
    procedure DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ConnectTimerTimer(Sender: TObject);
    procedure MENU_TOOLS_TESTClick(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure M1Click(Sender: TObject);
    procedure GateSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure GateSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure MENU_MANAGE_SHOPClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure MENU_CONTROL_TESTSERVERClick(Sender: TObject);
    procedure MENU_TOOLS_OFFLINE_SAVENAMEClick(Sender: TObject);
    procedure MENU_TOOLS_OFFLINE_LOADNAMEClick(Sender: TObject);
    procedure V1Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure MemoLogKeyPress(Sender: TObject; var Key: Char);
    procedure NPC1Click(Sender: TObject);
    procedure F1Click(Sender: TObject);
    procedure MENU_MANAGE_ONLINEEMAILClick(Sender: TObject);
    procedure MENU_VIEW_COMClick(Sender: TObject);
  private
    boServiceStarted: Boolean;
    boRunTimerRun: Boolean;
    procedure Timer1Timer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure SaveVariableTimerTimer(Sender: TObject);
    procedure RunTimerTimer(Sender: TObject);


    procedure StartService();
    procedure StopService();
    procedure SaveItemNumber(boStop: Boolean);
    function LoadClientFile(): Boolean;
    procedure StartEngine;
    //procedure MakeStoneMines;
    procedure ReloadConfig(Sender: TObject);
    procedure ClearMemoLog();
    procedure CloseGateSocket();
    { Private declarations }
  public
//    GateSocket: TServerSocket;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure OnProgramException(Sender: TObject; E: Exception);
    procedure SetMenu(); virtual;
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
{$IF Public_Ver = Public_Release}
    procedure RunMessage(var Message: TMessage); message WM_RUN_OK;
{$IFEND}
    { Public declarations }
  end;

//function LoadAbuseInformation(FileName: string): Boolean;
procedure LoadServerTable();
procedure WriteConLog(MsgList: TStringList);
//procedure ChangeCaptionText(Msg: PChar; nLen: Integer); stdcall;
procedure UserEngineThread(ThreadInfo: pTThreadInfo); stdcall;
procedure ProcessGameRun();
procedure TFrmMain_ChangeGateSocket(boOpenGateSocket: Boolean); stdcall;

var
  FrmMain: TFrmMain;
  g_GateSocket: TServerSocket;

implementation
uses
  LocalDB, {InterServerMsg, InterMsgClient, }IdSrvClient, FSrvValue, EncryptFile,
  GeneralConfig, GameConfig, FunctionConfig, ObjRobot, ViewSession, ObjMon,
  ViewOnlineHuman, ViewLevel, ViewList, OnlineMsg, ViewKernelInfo, CoralWry,
  ConfigMerchant, ItemSet, ConfigMonGen, {$IFDEF PLUGOPEN}PlugInManage, PlugOfEngine,{$ENDIF} EDcodeEx,
  GameCommand, MonsterConfig, RunDB, CastleManage, EngineRegister, ViewCompoundInfo, OnlineEmail,
  FrmShop, FrnEmail, CheckDll, MD5Unit, MyCommon{$IF Public_Ver = Public_Free}, CheckDllFile{$IFEND}
{$IFDEF DEBUG}
  , ObjPlay;
{$ELSE}
  , RegDllFile;
{$ENDIF}

//------------------------------------------------------------------------------
{PlugOfEngine}//�����������
//exports

//------------------------------------------------------------------------------
var
  sCaption: string;
  l_dwRunTimeTick: LongWord;
  boRemoteOpenGateSocket: Boolean = False;

  boSaveData: Boolean = False;
  sChar: string = ' ?';
  sRun: string = 'Run';
  m_nSaveIdx: Word;
{$R *.dfm}

  {procedure ChangeCaptionText(Msg: PChar; nLen: Integer); stdcall;
  var
    sMsg: string;
  begin
    if (nLen > 0) and (nLen < 50) then begin
      setlength(sMsg, nLen);
      Move(Msg^, sMsg[1], nLen);
      sCaptionExtText := sMsg;
    end;
  end;    }

procedure TFrmMain_ChangeGateSocket(boOpenGateSocket: Boolean);
  stdcall;
begin
  //if nCRCA = nVersion then                   //��֤Ҫ�޸�
  boRemoteOpenGateSocket := boOpenGateSocket;
end;
        {
function LoadAbuseInformation(FileName: string): Boolean;
var
  i: Integer;
  sText: string;
begin
  Result := False;
  if FileExists(FileName) then begin
    AbuseTextList.Clear;
    AbuseTextList.LoadFromFile(FileName);
    i := 0;
    while (True) do begin
      if AbuseTextList.Count <= i then
        break;
      sText := Trim(AbuseTextList.Strings[i]);
      if sText = '' then begin
        AbuseTextList.Delete(i);
        Continue;
      end;
      Inc(i);
    end;
    Result := True;
  end;
end;           }

procedure LoadServerTable();
var
  i, ii: Integer;
  LoadList: TStringList;
  GateList: TStringList;
  //  SrvNetInfo: pTSrvNetInfo;
  sLineText, sGateMsg: string;
  {sServerIdx, }sIPaddr, sPort: string;
begin
  for i := 0 to ServerTableList.Count - 1 do begin
    TList(ServerTableList.Items[i]).Free;
  end;
  ServerTableList.Clear;
  if FileExists('.\!servertable.txt') then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile('.\!servertable.txt');
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sGateMsg := Trim(GetValidStr3(sLineText, sGateMsg, [' ', #9]));
        if sGateMsg <> '' then begin
          GateList := TStringList.Create;
          for ii := 0 to 30 do begin
            if sGateMsg = '' then
              break;
            sGateMsg := Trim(GetValidStr3(sGateMsg, sIPaddr, [' ', #9]));
            sGateMsg := Trim(GetValidStr3(sGateMsg, sPort, [' ', #9]));
            if (sIPaddr <> '') and (sPort <> '') then begin
              GateList.AddObject(sIPaddr, TObject(StrToIntDef(sPort, 0)));
            end;
          end;
          ServerTableList.Add(GateList);
        end;
      end;
    end;
    FreeAndNil(LoadList);
  end
  else begin
    ShowMessage('Servertable.txt not found.');
  end;
end;

procedure WriteConLog(MsgList: TStringList);
var
  i: Integer;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  sLogDir, sLogFileName: string;
  LogFile: TextFile;
begin
  if MsgList.Count <= 0 then
    exit;
  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  if not DirectoryExists(g_Config.sConLogDir) then begin
    //CreateDirectory(PChar(g_Config.sConLogDir),nil);
    CreateDir(g_Config.sConLogDir);
  end;
  sLogDir := g_Config.sConLogDir + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day);
  if not DirectoryExists(sLogDir) then begin
    CreateDirectory(PChar(sLogDir), nil);
  end;
  sLogFileName := sLogDir + '\C-' + IntToStr(nServerIndex) + '-' +
    IntToStr2(Hour) + 'H' + IntToStr2((Min div 10 * 2) * 5) + 'M.txt';

  if not FileExists(sLogFileName) then begin
    Rewrite(LogFile);
  end
  else begin
    Append(LogFile);
  end;
  for i := 0 to MsgList.Count - 1 do begin
    WriteLn(LogFile, '1' + #9 + MsgList.Strings[i]);
  end; // for
  CloseFile(LogFile);
end;

procedure TFrmMain.S1Click(Sender: TObject);
begin
  if g_MapEventNpc <> nil then begin
    g_MapEventNpc.ClearScript;
    g_MapEventNpc.LoadNpcScript;
    //FrmDB.LoadMapEvent;
    MainOutMessage('QMapEvent Script has finished loading.');
  end;
end;

procedure TFrmMain.SaveItemNumber(boStop: Boolean);
var
  i: Integer;
begin
  try
    Config.WriteInteger('Setup', 'ItemNumber', g_Config.nItemNumber);
    Config.WriteInteger('Setup', 'ItemNumberEx', g_Config.nItemNumberEx);
    if boStop then begin
      for I := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do begin
        GlobalConf.WriteInteger('Integer', 'GlobalVal' + IntToStr(I), g_Config.GlobalVal[I])
      end;
      for I := Low(g_Config.GlobalAVal) to High(g_Config.GlobalAVal) do begin
        GlobalConf.WriteString('String', 'GlobalStrVal' + IntToStr(I), g_Config.GlobalAVal[I])
      end;
    end
    else begin
      for I := 0 to 30 do begin
        if m_nSaveIdx > High(g_Config.GlobalVal) then
          m_nSaveIdx := Low(g_Config.GlobalVal);
        GlobalConf.WriteInteger('Integer', 'GlobalVal' + IntToStr(m_nSaveIdx), g_Config.GlobalVal[m_nSaveIdx]);
        GlobalConf.WriteString('String', 'GlobalStrVal' + IntToStr(m_nSaveIdx), g_Config.GlobalAVal[m_nSaveIdx]);
        Inc(m_nSaveIdx);
      end;
    end;
    {for i := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do begin
      Config.WriteInteger('Setup', 'GlobalVal' + IntToStr(i),
        g_Config.GlobalVal[i])
    end;
    for i := Low(g_Config.GlobalAVal) to High(g_Config.GlobalAVal) do begin
      Config.WriteString('Setup', 'GlobalStrVal' + IntToStr(i),
        g_Config.GlobalAVal[i])
    end;       }
    Config.WriteInteger('Setup', 'WinLotteryCount', g_Config.nWinLotteryCount);
    Config.WriteInteger('Setup', 'NoWinLotteryCount', g_Config.nNoWinLotteryCount);
    Config.WriteInteger('Setup', 'WinLotteryLevel1', g_Config.nWinLotteryLevel1);
    Config.WriteInteger('Setup', 'WinLotteryLevel2', g_Config.nWinLotteryLevel2);
    Config.WriteInteger('Setup', 'WinLotteryLevel3', g_Config.nWinLotteryLevel3);
    Config.WriteInteger('Setup', 'WinLotteryLevel4', g_Config.nWinLotteryLevel4);
    Config.WriteInteger('Setup', 'WinLotteryLevel5', g_Config.nWinLotteryLevel5);
    Config.WriteInteger('Setup', 'WinLotteryLevel6', g_Config.nWinLotteryLevel6);
  except
  end;
end;

procedure TFrmMain.AppOnIdle(Sender: TObject; var Done: Boolean);
begin
  //   MainOutMessage ('����');
end;

procedure TFrmMain.B1Click(Sender: TObject);
var
  nCode: Integer;
begin
  nCode := FrmDB.LoadBoxs();
  if nCode < 0 then begin
    MainOutMessage('Reload chest configuration failed.' + 'Code: ' + IntToStr(nCode));
  end else
    MainOutMessage('Reload chest configuration complete.');
end;

procedure TFrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TFrmMain.DBSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
//  tStr: string;
  nMsgLen: Integer;
  tBuffer: PAnsiChar;
begin
  nMsgLen := Socket.ReceiveLength;
  if nMsgLen > 0 then begin
    GetMem(tBuffer, nMsgLen);
    nMsgLen := Socket.ReceiveBuf(tBuffer^, nMsgLen);
    EnterCriticalSection(UserDBSection);
    try
      ReallocMem(g_Config.pDBSocketRecvBuff, g_Config.nDBSocketRecvLeng + nMsgLen);
      Move(tBuffer^, g_Config.pDBSocketRecvBuff[g_Config.nDBSocketRecvLeng], nMsgLen);
      Inc(g_Config.nDBSocketRecvLeng, nMsgLen);
    finally
      LeaveCriticalSection(UserDBSection);
    end;
    FreeMem(tBuffer);
  end;
  {EnterCriticalSection(UserDBSection);
  try
    tStr := Socket.ReceiveText;
    g_Config.sDBSocketRecvText := g_Config.sDBSocketRecvText + tStr;
    //    MainOutMessage(sDBSocStr[1]);
    if not g_Config.boDBSocketWorking then begin
      g_Config.sDBSocketRecvText := '';
    end;
  finally
    LeaveCriticalSection(UserDBSection);
  end; }
end;

procedure TFrmMain.E1Click(Sender: TObject);
begin
  FrmDB.LoadMapEvent;
  MainOutMessage('Map Event Configuration complete.');
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  boWriteLog: Boolean;
  i: Integer;
  nRow: Integer;
  wHour: Word;
  wMinute: Word;
  wSecond: Word;
  wDay: Word;
  tSecond: Integer;
  sSrvType: string;
  sVerType: string;
  tTimeCount: Currency;
  GateInfo: pTGateInfo;
  //  sGate,tGate      :String;
  LogFile: TextFile;
  s28: string;
  ABuffer: TBytes;
  nLen: Integer;
  UserItem: PTUserItem;
begin
  //if boCheckED then
{$IF Var_Free = 1}      // - ��Ѱ�
  Caption := sCaption;// + enmsg.DecryptStr('mO5TEZkA6D8f9q7M');
{$ELSE}
  {$IF Public_Ver = Public_Test}    // - 10�����Ʋ��԰�
    Caption := sCaption;// + enmsg.DecryptStr('p5mSNTagY2rsJLrvnDjq0weI6rimV6G2');
  {$ELSE}
    if not g_boTestServer then Caption := sCaption// + enmsg.DecryptStr('X0vEmXTXgF7tNcAQbJRzyGmrqMGrHtT0')
    else Caption := sCaption;
  {$IFEND}
{$IFEND}
  {if (not boCanConned) and (not boCheckED) then begin
    boCanConned := True;
    RegSocket.Active := False;
    RegSocket.Active := True;
  end;  }
  EnterCriticalSection(LogMsgCriticalSection);
  try
    if MemoLog.Lines.Count > 500 then
      MemoLog.Clear;
    boWriteLog := True;
    if MainLogMsgList.Count > 0 then begin
      try
        if not FileExists(sLogFileName) then begin
          AssignFile(LogFile, sLogFileName);
          Rewrite(LogFile);
        end
        else begin
          AssignFile(LogFile, sLogFileName);
          Append(LogFile);
        end;
        boWriteLog := False;
      except
        MemoLog.Lines.Add('Save log information error.');
      end;
    end;
    for i := 0 to MainLogMsgList.Count - 1 do begin
      MemoLog.Lines.Add(MainLogMsgList.Strings[i]);
      if not boWriteLog then begin
        WriteLn(LogFile, MainLogMsgList.Strings[i]);
      end;
    end;
    MainLogMsgList.Clear;
    if not boWriteLog then
      CloseFile(LogFile);
    for i := 0 to LogStringList.Count - 1 do begin
      try
        s28 := LogStringList.Strings[I];
        nLen := Length(s28) + 1;
        if LogStringList.Objects[I] <> nil then begin
          UserItem := pTUserItem(LogStringList.Objects[I]);
          SetLength(ABuffer, nLen + SizeOf(TUserItem));
          Move(s28[1], ABuffer[0], nLen);
          Move(UserItem^, ABuffer[nLen], SizeOf(TUserItem));
          Dispose(UserItem);
          LogStringList.Objects[I] := nil;
        end else begin
          SetLength(ABuffer, nLen);
          Move(s28[1], ABuffer[0], nLen);
        end;
        Inc(g_nSendLogCount);
        IdUDPClientLog.Send(string(ABuffer));
      except
        Inc(g_nSendLogErrorCount);
        Continue;
      end;
    end;
    LogStringList.Clear;
    if LogonCostLogList.Count > 0 then begin
      WriteConLog(LogonCostLogList);
    end;
    LogonCostLogList.Clear;
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;

{$IF SoftVersion = VERDEMO}
  sVerType := '[D]';
{$ELSEIF SoftVersion = VERFREE}
  sVerType := '[F]';
{$ELSEIF SoftVersion = VERSTD}
  sVerType := '[S]';
{$ELSEIF SoftVersion = VEROEM}
  sVerType := '[O]';
{$ELSEIF SoftVersion = VERPRO}
  sVerType := '[P]';
{$ELSEIF SoftVersion = VERENT}
  sVerType := '[E]';
{$IFEND}

  if nServerIndex = 0 then begin
    sSrvType := '[M]';
  end
  else begin
    {if FrmMsgClient.MsgClient.Socket.Connected then begin
      sSrvType := '[S]';
    end
    else begin
      sSrvType := '[ ]';
    end;   }
  end;
  //LabelVersion.Caption := LabelVersion;

  //����߳� ����ʱ��
  //g_dwEngineRunTime:=GetTickCount - g_dwEngineTick;

  tTimeCount := GetTickCount() / (24 * 60 * 60 * 1000);
  if tTimeCount >= 20 then
    LbRunTime.Font.Color := clRed
  else if tTimeCount >= 15 then
    LbRunTime.Font.Color := clMaroon
  else
    LbRunTime.Font.Color := clBlack;
  //PCTimeCount.Caption := CurrToStr(tTimeCount) + '��';

  tSecond := (GetTickCount() - g_dwStartTick) div 1000;
  wDay := tSecond div (24 * 60 * 60);
  tSecond := tSecond mod (24 * 60 * 60);
  wHour := tSecond div 3600;
  wMinute := (tSecond div 60) mod 60;
  wSecond := tSecond mod 60;

  LbRunTime.Caption := Format('%s[%d:%d:%d:%d/%s]', [sSrvType, wDay, wHour,
    wMinute, wSecond, CurrToStr(tTimeCount)]);
  {LbRunTime.Caption := sSrvType + IntToStr(wHour) + ':' +
    IntToStr(wMinute) + ':' +
    IntToStr(wSecond) + ' ' + sVerType; { +
  IntToStr(g_dwEngineRunTime) + g_sProcessName + '-' + g_sOldProcessName;}
  LbUserCount.Caption := Format('(%d)   [%d/%d/%d][%d/%d/%d]',
    [UserEngine.MonsterCount,
    UserEngine.OnlinePlayCount,
    UserEngine.PlayObjectCount,
    UserEngine.OffLinePlayCount,
      UserEngine.LoadPlayCount,
      FrontEngine.SaveListCount,
      UserEngine.m_PlayObjectFreeList.Count]);

  {LbUserCount.Caption := '(' + IntToStr(UserEngine.MonsterCount) + ')   ' +
    IntToStr(UserEngine.OnlinePlayObject) + '/' +
    IntToStr(UserEngine.PlayObjectCount) + '[' +
    IntToStr(UserEngine.LoadPlayCount) + '/' +
    IntToStr(UserEngine.m_PlayObjectFreeList.Count) + ']';   }
  {
  Label1.Caption:= 'Run' + IntToStr(nRunTimeMin) + '/' + IntToStr(nRunTimeMax) + ' ' +
                   'Soc' + IntToStr(g_nSockCountMin) + '/' + IntToStr(g_nSockCountMax) + ' ' +
                   'Usr' + IntToStr(g_nUsrTimeMin) + '/' + IntToStr(g_nUsrTimeMax);
  }
  Label1.Caption := format('Run(%d/%d) Soc(%d/%d) Usr(%d/%d)',
    [nRunTimeMin,
      nRunTimeMax,
      g_nSockCountMin,
      g_nSockCountMax,
      g_nUsrTimeMin,
      g_nUsrTimeMax]);
  {
  Label2.Caption:= 'Hum' + IntToStr(g_nHumCountMin) + '/' + IntToStr(g_nHumCountMax) + ' ' +
                   'Mon' + IntToStr(g_nMonTimeMin) + '/' + IntToStr(g_nMonTimeMax) + ' ' +
                   'UsrRot' + IntToStr(dwUsrRotCountMin) + '/' + IntToStr(dwUsrRotCountMax) + ' ' +
                   'Merch' + IntToStr(UserEngine.dwProcessMerchantTimeMin) + '/' + IntToStr(UserEngine.dwProcessMerchantTimeMax) + ' ' +
                   'Npc' + IntToStr(UserEngine.dwProcessNpcTimeMin) + '/' + IntToStr(UserEngine.dwProcessNpcTimeMax) + ' ' +
                   '(' + IntToStr(g_nProcessHumanLoopTime) + ')';
  }
  Label2.Caption := format('Her(%d/%d) Hum(%d/%d) Mer(%d/%d) Npc(%d/%d)',
    [dwUsrRotCountMin,
      dwUsrRotCountMax,
      g_nHumCountMin,
      g_nHumCountMax,
      UserEngine.dwProcessMerchantTimeMin,
      UserEngine.dwProcessMerchantTimeMax,
      UserEngine.dwProcessNpcTimeMin,
      UserEngine.dwProcessNpcTimeMax]);

  LabelMon.Caption := g_sMonGenInfo1 + ' - ' + g_sMonGenInfo2;

  {Label20.Caption:='MonG' + IntToStr(g_nMonGenTime) + '/' + IntToStr(g_nMonGenTimeMin) + '/' + IntToStr(g_nMonGenTimeMax) + ' ' +
                   'MonP' + IntToStr(g_nMonProcTime) + '/' + IntToStr(g_nMonProcTimeMin) + '/' + IntToStr(g_nMonProcTimeMax) + ' ' +
                   'ObjRun' + IntToStr(g_nBaseObjTimeMin) + '/' + IntToStr(g_nBaseObjTimeMax);
 }
  //Label20.Caption := format('Monr(%d/%d/%d) Monp(%d/%d/%d) ObjRun(%d/%d)',
  Label20.Caption := format('Monr(%d/%d/%d) Monp(%d/%d/%d) Log(%d/%d)',
    [g_nMonGenTime,
      g_nMonGenTimeMin,
      g_nMonGenTimeMax,
      g_nMonProcTime,
      g_nMonProcTimeMin,
      g_nMonProcTimeMax,
      g_nSendLogCount,
      g_nSendLogErrorCount{,
      g_nBaseObjTimeMin,
      g_nBaseObjTimeMax}]);

  //MemStatus.Caption:='�ڴ�: ' + IntToStr(ROUND(AllocMemSize / 1024)) + 'KB';// + ' �ڴ����: ' + IntToStr(AllocMemCount);
  //Lbcheck.Caption:='check' + IntToStr(g_CheckCode.dwThread0) + '/w' + IntToStr(g_ProcessMsg.wIdent) + '/' + IntToStr(g_ProcessMsg.nParam1) + '/' +  IntToStr(g_ProcessMsg.nParam2) + '/' +  IntToStr(g_ProcessMsg.nParam3) + '/' + g_ProcessMsg.sMsg;

  if dwStartTimeTick = 0 then
    dwStartTimeTick := GetTickCount;
  dwStartTime := (GetTickCount - dwStartTimeTick) div 1000;

  {
  //004E5B78
  for i:= Low(RunSocket.GateList) to High(RunSocket.GateList) do begin
    GateInfo:=@RunSocket.GateList[i];
    if GateInfo.boUsed and (GateInfo.Socket <> nil) then begin
      if GateInfo.nSendMsgBytes < 1024 then begin
        tGate:=IntToStr(GateInfo.nSendMsgBytes) + 'b ';
      end else begin//004E5BDA
        tGate:=IntToStr(GateInfo.nSendMsgBytes div 1024) + 'kb ';
      end;//004E5C0A
      sGate:='[G' + IntToStr(i) + ': ' +
             IntToStr(GateInfo.nSendMsgCount) + '/' +
             IntToStr(GateInfo.nSendRemainCount) + ' ' +
             tGate + IntToStr(GateInfo.nSendedMsgCount) + ']' + sGate;
    end;//004E5C90
  end;
  Label3.Caption:=sGate;
  }
 // GridGate
  nRow := 1;
  //for i:= Low(RunSocket.GateList) to High(RunSocket.GateList) do begin
  for i := Low(g_GateArr) to High(g_GateArr) do begin
    GridGate.Cells[0, i + 1] := '';
    GridGate.Cells[1, i + 1] := '';
    GridGate.Cells[2, i + 1] := '';
    GridGate.Cells[3, i + 1] := '';
    GridGate.Cells[4, i + 1] := '';
    GridGate.Cells[5, i + 1] := '';
    GridGate.Cells[6, i + 1] := '';
    GateInfo := @g_GateArr[i];
    //GateInfo:=@RunSocket.GateList[i];
    if GateInfo.boUsed and (GateInfo.Socket <> nil) then begin
      GridGate.Cells[0, nRow] := IntToStr(i);
      GridGate.Cells[1, nRow] := GateInfo.sAddr + ':' + IntToStr(GateInfo.nPort);
      GridGate.Cells[2, nRow] := IntToStr(GateInfo.nSendMsgCount);
      GridGate.Cells[3, nRow] := IntToStr(GateInfo.nSendedMsgCount);
      GridGate.Cells[4, nRow] := IntToStr(GateInfo.nSendRemainCount);
      if GateInfo.nSendMsgBytes < 1024 then begin
        GridGate.Cells[5, nRow] := IntToStr(GateInfo.nSendMsgBytes) + 'b';
      end
      else begin
        GridGate.Cells[5, nRow] := IntToStr(GateInfo.nSendMsgBytes div 1024) + 'kb';
      end;
      GridGate.Cells[6, nRow] := IntToStr(GateInfo.nUserCount) + '/' + IntToStr(GateInfo.UserList.Count);
      Inc(nRow);
    end;
  end;
  //LbRunSocketTime.Caption:='Soc' + IntToStr(g_nGateRecvMsgLenMin) + '/' + IntToStr(g_nGateRecvMsgLenMax) + ' Ct' + IntToStr(CertCheck.Count) + '/' + IntToStr(EventCheck.Count);
  //LbRunSocketTime.Caption:='Sess' + IntToStr(FrmIDSoc.GetSessionCount());
  //Inc(nRunTimeMax);
  if g_nSockCountMax > 0 then
    Dec(g_nSockCountMax);
  if g_nUsrTimeMax > 0 then
    Dec(g_nUsrTimeMax);

  if dwUsrRotCountMax > 0 then
    Dec(dwUsrRotCountMax);
  if g_nHumCountMax > 0 then
    Dec(g_nHumCountMax);
  if UserEngine.dwProcessMerchantTimeMax > 0 then
    Dec(UserEngine.dwProcessMerchantTimeMax);
  if UserEngine.dwProcessNpcTimeMax > 0 then
    Dec(UserEngine.dwProcessNpcTimeMax);

  if g_nMonTimeMax > 0 then
    Dec(g_nMonTimeMax);
  if g_nMonGenTimeMin > 1 then
    Dec(g_nMonGenTimeMin, 2);
  if g_nMonProcTimeMin > 1 then
    Dec(g_nMonProcTimeMin, 2);
  if g_nBaseObjTimeMax > 0 then
    Dec(g_nBaseObjTimeMax);
end;

procedure TFrmMain.V1Click(Sender: TObject);
begin
  FrmDB.LoadMissionData();
  MainOutMessage('Reload Task configuration complete.');
end;

procedure TFrmMain.StartTimerTimer(Sender: TObject);
var
  nCode: Integer;
  FileVersionInfo: TFileVersionInfo;
  NameBuffer: array[0..MAX_PATH] of Char;
  nSize: LongWord;
begin
{$IF Public_Ver = Public_Free}
  CheckDLL_AppendString := Check_Dll.FindExport('AppendString');
{$ELSE}
  InitializeCheckDll('AppendString');
{$IFEND}
  SendGameCenterMsg(SG_STARTNOW, 'Starting M2Server...');
  StartTimer.Enabled := False;
  SafeFillChar(LoginPlayObject, SizeOf(LoginPlayObject), #0);
  FrmDB := TFrmDB.Create();
  StartService();                        
  try
    if SizeOf(THumDataInfo) <> SIZEOFTHUMAN then begin
      ShowMessage('sizeof(THuman) ' + IntToStr(SizeOf(THumDataInfo)) + ' <> SIZEOFTHUMAN ' + IntToStr(SIZEOFTHUMAN));
      Close;
      exit;
    end;
    if not LoadClientFile then begin
      Close;
      exit;
    end;
{$IF DBTYPE = BDE}
    FrmDB.Query.DatabaseName := sDBName;
{$ELSE}
    FrmDB.Query.ConnectionString := g_sADODBString;
{$IFEND}
    SafeFillChar(g_SayItemList, SizeOf(g_SayItemList), #0);
    g_SayItemIndex := 0;
    LoadGameLogItemNameList();
    LoadDenyIPAddrList();
    LoadDenyAccountList();
    LoadDenyChrNameList();
    LoadMonDropLimitList();
    FrmDB.LoadDefiniensConst;
    MemoLog.Lines.Add('NPC constant configuration loaded complete.');

    {FrmDB.LoadSetItems;
    MemoLog.Lines.Add('��װ���ü��سɹ�...');  }
    //LoadNoClearMonList();
    //g_Config.nServerFile_CRCB := CalcFileCRC(Application.ExeName);
    {$IFDEF PLUGOPEN}
    MemoLog.Lines.Add('Loading engine plugin.');
    PlugInEngine.LoadPlugIn;
    {$ENDIF}
    MemoLog.Lines.Add('Loading item database.');
    nCode := FrmDB.LoadItemsDB;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Item database failed to load.' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add(format('Item database loaded complete.(%d)...', [UserEngine.StdItemList.Count]));

    MemoLog.Lines.Add('Loading chest information.');
    nCode := FrmDB.LoadBoxs;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Chest information failed to Load' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('Database configuration information load complete.');

    MemoLog.Lines.Add('Loading MiniMap file.');
    nCode := FrmDB.LoadMinMap;
    if nCode < 0 then begin
      MemoLog.Lines.Add('MiniMap file failed to load.' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('MiniMap file load complete.');

    MemoLog.Lines.Add('Loading Skills database.');
    nCode := FrmDB.LoadMagicDB;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Skills database failed to load.' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add(format('Skills database load complete. (%d)...', [nCode]));

    MemoLog.Lines.Add('Loading map data.');
    nCode := FrmDB.LoadMapInfo;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Map data failed to load.' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add(format('Map data is load complete. (%d)...', [g_MapManager.Count]));

    MemoLog.Lines.Add('Loading MapQuest information...');
    nCode := FrmDB.LoadMapQuest;
    if nCode < 0 then begin
      MemoLog.Lines.Add('MapQuest information failed to load.');
      exit;
    end;
    MemoLog.Lines.Add('MapQuest information load complete.');

    MemoLog.Lines.Add('Loading Monster database.');
    nCode := FrmDB.LoadMonsterDB;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Monster database failed to load.' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add(format('Monster database load complete. (%d)...',
      [UserEngine.MonsterList.Count]));

    

    MemoLog.Lines.Add('Loading MonGen information...');
    nCode := FrmDB.LoadMonGen;
    if nCode < 0 then begin
      MemoLog.Lines.Add('MonGen information failed to load.' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add(format('Mongen information load complete. (%d)...', [UserEngine.m_MonGenList.Count]));

    MemoLog.Lines.Add('Loading MonSayMsg information...');
    FrmDB.LoadMonSayMsg();
    MemoLog.Lines.Add(format('MonSayMsg information complete. (%d)...', [g_MonSayMsgList.Count]));
    {LoadDisableTakeOffList();

    LoadDisableMakeItem();
    LoadEnableMakeItem();   }
    //LoadDisableMoveMap;
    //ItemUnit.LoadCustomItemName();
    LoadDisableSendMsgList();
    //LoadItemBindIPaddr();
    //LoadItemBindAccount();
    //LoadItemBindCharName();
    LoadUnMasterList();
    LoadUnMarryList();
    LoadUnForceMasterList();
    LoadUnFriendList();

    {LoadAllowPickUpItemList(); //���������ȡ��Ʒ

    LoadAllowSellOffItemList();   }

    //MemoLog.Lines.Add('���ڼ��ؼ�����Ʒ���ݿ�...');
    //g_SellOffGoldList.LoadSellOffGoldList();
    //g_SellOffGoodList.LoadSellOffGoodList();
    //MemoLog.Lines.Add(format('���ؼ�����Ʒ���ݿ�ɹ�(%d)...', [g_SellOffGoodList.RecCount]));

   // MemoLog.Lines.Add('���ڼ������޲ֿ����ݿ�...');
   // g_BigStorageList.LoadBigStorageList();
  //  MemoLog.Lines.Add(format('�������޲ֿ����ݿ�ɹ�(%d/%d)...', [g_BigStorageList.HumManCount,g_BigStorageList.RecordCount]));

    MemoLog.Lines.Add('Loading BundleList information...');

    nCode := FrmDB.LoadUnbindList;
    if nCode < 0 then begin
      MemoLog.Lines.Add('BundleList information failed to load.' + 'Code: ' +
        IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('BundleList information load complete.');

    LoadBindItemTypeFromUnbindList(); {������װ��Ʒ����}


    {MemoLog.Lines.Add('���ڼ��ص�ͼ�����¼���Ϣ...');
    nCode := FrmDB.LoadMapEvent;
    if nCode < 0 then begin
      MemoLog.Lines.Add('���ص�ͼ�����¼���Ϣʧ��.');
      exit;
    end;
    MemoLog.Lines.Add('���ص�ͼ�����¼���Ϣ�ɹ�...');  }

    {MemoLog.Lines.Add('���ڼ�������˵����Ϣ...');
    nCode := FrmDB.LoadQuestDiary;
    if nCode < 0 then begin
      MemoLog.Lines.Add('��������˵����Ϣʧ��.');
      exit;
    end;
    MemoLog.Lines.Add('��������˵����Ϣ�ɹ�...');  }

    {if LoadAbuseInformation('.\!abuse.txt') then begin
      MemoLog.Lines.Add('�������ֹ�����Ϣ�ɹ�...');
    end;  }

    MemoLog.Lines.Add('Loading Announcement message.');
    if not LoadLineNotice(g_Config.sNoticeDir + 'LineNotice.txt') then begin
      MemoLog.Lines.Add('Load Announcement message failed.');
    end;
    MemoLog.Lines.Add('Announcement message load complete.');

    MemoLog.Lines.Add('Loading Hint message...');
    if not LoadLineHint(g_Config.sNoticeDir + 'LineHint.txt') then begin
      MemoLog.Lines.Add('Hint message failed to load.');
    end;
    MemoLog.Lines.Add('Hint message load complete.');

    RobotManage := TRobotManage.Create;
    MemoLog.Lines.Add('Robot configuration load complete.');



    FrmDB.LoadAdminList();
    MemoLog.Lines.Add('Administrators list load complete.');
    g_GuildManager.LoadGuildInfo;
    MemoLog.Lines.Add('Guild list load complete.');

    g_CastleManager.LoadCastleList();
    MemoLog.Lines.Add('Castle list load complete.');

    //UserCastle.Initialize;
    g_CastleManager.Initialize;
    MemoLog.Lines.Add('Castle initialize complete.');
   { if (nServerIndex = 0) then
      FrmSrvMsg.StartMsgServer
    else
      FrmMsgClient.ConnectMsgServer; }
    StartEngine();
    g_Config.sFileMD5 := UpperCase(FileToMD5Text(ParamStr(0)));
    GetFileVersion(ParamStr(0), @FileVersionInfo);
    g_Config.sFileVersion := FileVersionInfo.sVersion;
    nSize := MAX_PATH - 1;
    GetComputerName(@NameBuffer, nSize);
    NameBuffer[nSize] := #0;
    g_Config.sIdeSerialNumber := GetIdeSerialNumber;
    g_Config.sPCName := Strpas(NameBuffer);
    g_Config.dwFileID := UpperCase(GetMD5TextOf16(g_Config.sIdeSerialNumber + g_Config.sPCName));
    boStartReady := True;
    Sleep(500);

{$IF DBSOCKETMODE = TIMERENGINE}
    ConnectTimer.Enabled := True;
{$ELSE}
    SafeFillChar(g_Config.DBSOcketThread, SizeOf(g_Config.DBSOcketThread), 0);
    g_Config.DBSOcketThread.Config := @g_Config;
    g_Config.DBSOcketThread.hThreadHandle := CreateThread(nil,
      0,
      @DBSocketThread,
      @g_Config.DBSOcketThread,
      0,
      g_Config.DBSOcketThread.dwThreadID);
{$IFEND}

{$IF IDSOCKETMODE = THREADENGINE}
        SafeFillChar(g_Config.IDSocketThread, SizeOf(g_Config.IDSocketThread), 0);
        g_Config.IDSocketThread.Config := @g_Config;
        g_Config.IDSocketThread.hThreadHandle := CreateThread(nil,
          0,
          @IDSocketThread,
          @g_Config.IDSocketThread,
          0,
          g_Config.IDSocketThread.dwThreadID);

{$IFEND}
    //ConnectTimer.Enabled := True;

    g_dwRunTick := GetTickCount();

    n4EBD1C := 0;
    g_dwUsrRotCountTick := GetTickCount();

    GateSocket.Address := g_Config.sGateAddr;
    GateSocket.Port := g_Config.nGatePort;
    g_GateSocket := GateSocket;

    //SendGameCenterMsg(SG_CHECKCODEADDR, IntToStr(Integer(@g_CheckCode)));
    dwRunDBTimeMax := GetTickCount();
    g_dwStartTick := GetTickCount();
    //RegSocket.Host := g_Config.sRegServerAddr;
    //RegSocket.Port := g_Config.nRegServerPort;
    Timer1Timer(Timer1);
    Timer1.Enabled := True;
    SaveVariableTimer.Enabled := True;
    RunTimer.Enabled := True;
    boServiceStarted := True;
    LabelVersion.Caption := 'Version: ' + g_Config.sFileVersion;
{$IF Public_Ver = Public_Release}
    {$IF Var_Free = 1}
      RegDll_LoadList(Application.Handle, Handle, g_Config.nGatePort, RegDll_OutMessage, RegDll_OKProc, True);
    {$ELSE}
      RegDll_LoadList(Application.Handle, Handle, g_Config.nGatePort, RegDll_OutMessage, RegDll_OKProc, False);
    {$IFEND}
{$ELSE}
    SendGameCenterMsg(SG_STARTOK, 'Start M2Server complete.');
{$IFEND}
    //RegSocket.Active := True;
  except
    on E: Exception do
      MainOutMessage('Server startup exception.' + E.Message);
  end;
end;

procedure TFrmMain.StartEngine();
var
  nCode: Integer;
  //  sProductInfo:String;
  //  sWebSite:String;
  //  sBbsSite:String;
  //  sSellInfo1:String;
  //  sSellInfo2:String;
begin
  try
{$IF IDSOCKETMODE = TIMERENGINE}
    FrmIDSoc.Initialize;
    MemoLog.Lines.Add('Login server connection initialization complete.');
{$IFEND}
    g_MapManager.LoadMapDoor;
    MemoLog.Lines.Add('Map Manager loaded successfully.');

    if not g_Config.boVentureServer then begin
      nCode := FrmDB.LoadGuardList;
      if nCode < 0 then begin
        MemoLog.Lines.Add('Load guard list failed.' + 'Code: ' + IntToStr(nCode));
      end;
      MemoLog.Lines.Add('Guard list loaded successfully.');
    end;

    //MakeStoneMines();
    //MemoLog.Lines.Add('�������ݳ�ʼ�ɹ�...');
{$IF Public_Ver = Public_Release}
    RegDllFile_InitializationDataStream;
{$IFEND}
    nCode := FrmDB.LoadMakeItem;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Load MakeItem failed.' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('MakeItem loaded successfully.');

    nCode := FrmDB.LoadMakeMagic;
    if nCode < 0 then begin
      MemoLog.Lines.Add('MakeMagic failed to load.' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('MakeMagic load complete.');

    nCode := FrmDB.LoadMerchant;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Merchant failed to load.' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('Merchants load complete.');

    nCode := FrmDB.LoadNpcs;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Management NPC list failed to load.' + 'Code: ' + IntToStr(nCode));
      exit;
    end;
    MemoLog.Lines.Add('Management NPC list load complete.');


    nCode := FrmDB.LoadStartPoint;
    if nCode < 0 then begin
      MemoLog.Lines.Add('An error occurred while loading StartPoint configuration.(Error code: ' + IntToStr(nCode) + ')');
      Close;
    end;
    MemoLog.Lines.Add('StartPoint load complete.');

    ShopEngine.initialize;
    MemoLog.Lines.Add('Store configuration load complete.');

    InitCoralWry();
    MemoLog.Lines.Add('IP query configuration load complete.');

    FrmDB.LoadMissionData();
    MemoLog.Lines.Add('Task Configuration load complete.');

    FrmDB.LoadMapDesc();
    MemoLog.Lines.Add('Map Descriptions load complete.');
    FrmDB.LoadUserCmd();
    MemoLog.Lines.Add('Custom GM commands load complete.');

    LoadFilterSayList();
    LoadFilterGuildList();
    LoadFilterShopList();
    MemoLog.Lines.Add('Filter list load complete.');
    {$IFDEF PLUGOPEN}
    MemoLog.Lines.Add('Initializing EnginePlugin.');
    PlugInEngine.InitPlugIn;
    {$ENDIF}
    nCode := UserEMail.Initialize;
    MemoLog.Lines.Add('Data loading complete.(' + IntToStr(nCode) + '/' + IntToStr(UserEMail.EMailCount) + '/' +
      IntToStr(UserEMail.UserCount) + ')...');

    FrontEngine.Resume;
    UserEMail.Resume;
    MemoLog.Lines.Add('Character Data Engine startup complete.');

    UserEngine.Initialize;
    MemoLog.Lines.Add('Game Engine initialized complete.');
    g_MapManager.MakeSafePkZone; //��ȫ����Ȧ
{$IFDEF RELEASE}
{$IF Public_Ver <> Public_Free}
    EncryptFile_InitializationDataStream;
    DLL_Encode6BitBuf := Dll_Encrypt.FindExport(DecodeString('wxSKlhgF]kKWm{W<p<'));
    DLL_Decode6BitBuf := Dll_Encrypt.FindExport(DecodeString('whwKlhgF]kKWm{W<p<'));
{$IFEND}
{$ENDIF}

    //sCaptionExtText:='רҵ��';
    //Caption := sCaption + ' [' + sCaptionExtText + ']';

    {if (nStartModule >= 0) and Assigned(PlugProcArray[nStartModule].nProcAddr) then begin
      if PlugProcArray[nStartModule].nCheckCode = 1 then begin
        TStartProc(PlugProcArray[nStartModule].nProcAddr);
      end;
    end;    }

    boSaveData := True;
  except
    MainOutMessage('Exception error when the service starts.');
  end;
end;
   {
procedure TFrmMain.MakeStoneMines();
var
  i, nW, nH: Integer;
  Envir: TEnvirnoment;
begin
  for i := 0 to g_MapManager.Count - 1 do begin
    Envir := TEnvirnoment(g_MapManager.Items[i]);
    if Envir.m_boMINE then begin
      for nW := 0 to Envir.m_nWidth - 1 do begin
        for nH := 0 to Envir.m_nHeight - 1 do begin
          //if (nW mod 2 = 0) and (nH mod 2 = 0) then
          TStoneMineEvent.Create(Envir, nW, nH, ET_STONEMINE);
        end;
      end;
    end;
  end;
end;    }

procedure TFrmMain.L1Click(Sender: TObject);
begin
  FrmDB.LoadMakeMagic();
  MainOutMessage('���¼�������ܴ����б�ɹ�...');
end;

function TFrmMain.LoadClientFile(): Boolean;
begin
  {MemoLog.Lines.Add('���ڼ��ؿͻ��˰汾��Ϣ...');
  if not (g_Config.sClientFile1 = '') then
    g_Config.nClientFile1_CRC := CalcFileCRC(g_Config.sClientFile1);
  if not (g_Config.sClientFile2 = '') then
    g_Config.nClientFile2_CRC := CalcFileCRC(g_Config.sClientFile2);
  if not (g_Config.sClientFile3 = '') then
    g_Config.nClientFile3_CRC := CalcFileCRC(g_Config.sClientFile3);
  if (g_Config.nClientFile1_CRC <> 0) or (g_Config.nClientFile2_CRC <> 0) or
    (g_Config.nClientFile3_CRC <> 0) then begin
    MemoLog.Lines.Add('���ؿͻ��˰汾��Ϣ�ɹ�...');
    //    Result := True;
  end
  else begin
    MemoLog.Lines.Add('���ؿͻ��˰汾��Ϣʧ��.');
    //    Result := False;
  end;        }
  Result := True;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  nX, nY: Integer;
  //  Year, Month, Day: Word;
  //  MemoryStream: TMemoryStream;
resourcestring
  //sDemoVersion = '��ʾ��';
  sGateIdx = '����';
  sGateIPaddr = '���ص�ַ';
  sGateListMsg = '��������';
  sGateSendCount = '��������';
  sGateMsgCount = 'ʣ������';
  sGateSendKB = 'ƽ������';
  sGateUserCount = '�������';
begin
  Randomize;
  //showmessage(inttostr(sizeof(TUserItem)));
  //showmessage(dateTimetostr(LongWordToDateTime(DateTimeToLongWord(Now))));
  boRunTimerRun := False;
  boStartReady := False;
  m_nSaveIdx := 0;
  nRunTimeMax := 0;
  g_boDBSocketRead := False;
  g_Config.sCurrentDir := GetCurrentDir();
  if ParamStr(1) = '-e' then boEncrypt := True;
  g_dwGameCenterHandle := StrToIntDef(ParamStr(1), 0);
  nX := StrToIntDef(ParamStr(2), -1);
  nY := StrToIntDef(ParamStr(3), -1);
  //boTeledata := (ParamStr(4) = '1');
  boTeledata := False;
  if (nX >= 0) or (nY >= 0) then begin
    Left := nX;
    Top := nY;
  end;
{$IFDEF DEBUG}
  MENU_TOOLS_TEST.Visible := True;
{$ENDIF}
  
  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(Self.Handle));
  GridGate.RowCount := 21;
  GridGate.Cells[0, 0] := sGateIdx;
  GridGate.Cells[1, 0] := sGateIPaddr;
  GridGate.Cells[2, 0] := sGateListMsg;
  GridGate.Cells[3, 0] := sGateSendCount;
  GridGate.Cells[4, 0] := sGateMsgCount;
  GridGate.Cells[5, 0] := sGateSendKB;
  GridGate.Cells[6, 0] := sGateUserCount;

  {DBSocket.OnConnect := DBSocketConnect;
  DBSocket.OnError := DBSocketError;
  DBSocket.OnRead := DBSocketRead;  }

  Timer1.OnTimer := Timer1Timer;
  RunTimer.OnTimer := RunTimerTimer;
  StartTimer.OnTimer := StartTimerTimer;
  SaveVariableTimer.OnTimer := SaveVariableTimerTimer;
  //ConnectTimer.OnTimer := ConnectTimerTimer;
  CloseTimer.OnTimer := CloseTimerTimer;

  MemoLog.OnChange := MemoLogChange;
  StartTimer.Enabled := True;
  for nX := Low(g_TopInfo) to High(g_TopInfo) do
    g_TopInfo[nX] := nil;
    
{$IFDEF PLUGOPEN}
  MENU_MANAGE_PLUG.Visible := True;
{$ENDIF}
end;

procedure TFrmMain.F1Click(Sender: TObject);
begin
  if LoadFilterSayList() then
    UserEngine.SendBroadFilterInfo();
    
  MainOutMessage('����������¼������...');
  LoadFilterGuildList();
  MainOutMessage('�л�������¼������...');
  LoadFilterShopList();
  MainOutMessage('��̯�������¼������...');
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
resourcestring
  sCloseServerYesNo = '�Ƿ�ȷ�Ϲر���Ϸ��������';
  sCloseServerTitle = 'ȷ����Ϣ';
begin
  if not boServiceStarted then begin
    //    Application.Terminate;
    exit;
  end;
  if g_boExitServer then begin
    boStartReady := False;
    exit;
  end;
  CanClose := False;
  if Application.MessageBox(PChar(sCloseServerYesNo), PChar(sCloseServerTitle), MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    g_boExitServer := True;
    CloseGateSocket();
    g_Config.boKickAllUser := True;
    // RunSocket.CloseAllGate;
    //    GateSocket.Close;
    CloseTimer.Enabled := True;
  end;
end;

procedure TFrmMain.CloseTimerTimer(Sender: TObject);
resourcestring
  sCloseServer = '%s [���ڹرշ�����(%d/%d/%d)...]';
  sCloseServer1 = '%s [�������ѹر�]';
begin
  Caption := Format(sCloseServer, [g_Config.sServerName, UserEngine.PlayObjectCount,
    FrontEngine.SaveListCount, UserEMail.MsgCount]);
  if (UserEngine.PlayObjectCount = 0) and FrontEngine.IsIdle and UserEMail.IsIdle then begin
    CloseTimer.Enabled := False;
    Caption := Format(sCloseServer1, [g_Config.sServerName]);
    StopService;
    Close;
  end;
end;

procedure TFrmMain.SaveVariableTimerTimer(Sender: TObject);
begin
  SaveItemNumber(False);
  {if boSaveData then begin
    if g_SellOffGoodList <> nil then g_SellOffGoodList.SaveSellOffGoodList();
    if g_SellOffGoldList <> nil then g_SellOffGoldList.SaveSellOffGoldList();
    if g_BigStorageList <> nil then g_BigStorageList.SaveStorageList();
  end;     }
end;

procedure TFrmMain.GateSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  RunSocket.CloseErrGate(Socket, ErrorCode);
end;

procedure TFrmMain.GateSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.CloseGate(Socket);
end;

procedure TFrmMain.GateSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.AddGate(Socket);
end;

procedure TFrmMain.GateSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.SocketRead(Socket);
end;

procedure TFrmMain.RunTimerTimer(Sender: TObject);
begin
  if boRunTimerRun then exit;
  boRunTimerRun := True;
  Try
    if boStartReady then begin
      RunSocket.Execute;
      FrmIDSoc.Run;
      UserEngine.Execute;
      ShopEngine.Run;
      ProcessGameRun();

      {if nServerIndex = 0 then
        FrmSrvMsg.Run
      else
        FrmMsgClient.Run;   }
    end;
    Inc(n4EBD1C);
    if (GetTickCount - g_dwRunTick) > 999 then begin
      g_dwRunTick := GetTickCount();
      nRunTimeMin := n4EBD1C;
      if nRunTimeMax < nRunTimeMin then
        nRunTimeMax := nRunTimeMin;
      n4EBD1C := 0;
    end;
    //if True{boRemoteOpenGateSocket} then begin //��֤Ҫ�޸�

  Finally
    boRunTimerRun := False;
  End;
  {end
  else begin
    if Assigned(g_GateSocket) then begin
      if g_GateSocket.Socket.Connected then
        g_GateSocket.Active := False;
    end;
  end;  }
end;

procedure TFrmMain.ConnectTimerTimer(Sender: TObject);
begin
  if DBSocket.Active then exit;
  DBSocket.Active := True;
end;

procedure TFrmMain.ReloadConfig(Sender: TObject);
begin
  try
    LoadConfig();
    FrmIDSoc.Timer1Timer(Sender);
    {if not (nServerIndex = 0) then begin
      if not FrmMsgClient.MsgClient.Active then begin
        FrmMsgClient.MsgClient.Active := True;
      end;
    end;     }
    IdUDPClientLog.Host := g_Config.sLogServerAddr;
    IdUDPClientLog.Port := g_Config.nLogServerPort;
    LoadServerTable();
    LoadClientFile();
  finally

  end;
end;

procedure TFrmMain.M1Click(Sender: TObject);
var
  nCode : Integer;
begin
  nCode := FrmDB.LoadMakeItem;
  if nCode < 0 then begin
    MainOutMessage('�ؼ��ش�����Ʒʧ�� .' + 'Code: ' + IntToStr(nCode));
    exit;
  end;
  MainOutMessage('������Ʒ��Ϣ�ؼ��سɹ�...');
  if Application.MessageBox('�Ƿ����¼�������NPC�б�?', '��ʾ��Ϣ', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
  begin
    FrmDB.ReLoadMerchants();
    UserEngine.ReloadMerchantList();
    MainOutMessage('NPC reload completed.');
  end;
end;

procedure TFrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 500 then
    MemoLog.Clear;
end;

procedure TFrmMain.MemoLogDblClick(Sender: TObject);
begin
  ClearMemoLog();
end;

procedure TFrmMain.MemoLogKeyPress(Sender: TObject; var Key: Char);
begin
{$IF Public_Ver = Public_Release}
  if Key = #13 then begin
    if (MemoLog.Lines.Count > 0) = (MemoLog.Lines[0] = '/debug') then
      MemoLog.Lines.Add('{C46AA8FE-92AC-48C5-80B4-E4614E36704F}');
  end;
{$IFEND}
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_CONFClick(Sender: TObject);
begin
  ReloadConfig(Sender);
end;

procedure TFrmMain.MENU_CONTROL_CLEARLOGMSGClick(Sender: TObject);
begin
  ClearMemoLog();
end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
begin
  ReloadConfig(Sender);
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_ITEMDBClick(Sender: TObject);
begin
  FrmDB.LoadItemsDB();
  MainOutMessage('Items database reload completed.');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MAGICDBClick(Sender: TObject);
begin
  FrmDB.LoadMagicDB();
  MainOutMessage('Skills database reload completed.');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MONSTERDBClick(Sender: TObject);
begin
  FrmDB.LoadMonsterDB();
  MainOutMessage('Monster database reload completed.');
end;

procedure TFrmMain.StartService;
var
  TimeNow: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  F: TextFile;
  Config: pTConfig;
 // s: string;
  //  sAppFilesSize:String;
  //  nStartFilesSize,nEndFilesSize:Integer;
  //I: Integer;
  //c: Int64;
  I: Integer;
begin
  Config := @g_Config;
    
  //s := g_Config.sUserDataDir;
  //MakeSureDirectoryPathExists(PChar(s));
  nRunTimeMax := 0;
  g_nSockCountMax := 0;
  g_nUsrTimeMax := 0;
  g_nHumCountMax := 0;
  g_nMonTimeMax := 0;
  g_nMonGenTimeMax := 0;
  g_nMonProcTime := 0;
  g_nMonProcTimeMin := 0;
  g_nMonProcTimeMax := 0;
  dwUsrRotCountMin := 0;
  dwUsrRotCountMax := 0;
  g_nSendLogCount := 0;
  g_nSendLogErrorCount := 0;
  g_nProcessHumanLoopTime := 0;
  g_dwHumLimit := 30;
  g_dwMonLimit := 30;
  g_dwZenLimit := 5;
  g_dwNpcLimit := 5;
  g_dwSocLimit := 10;
  nDecLimit := 20;
  Config.sDBSocketRecvText := '';
  Config.boDBSocketWorking := False;
  Config.nLoadDBErrorCount := 0;
  Config.nLoadDBCount := 0;
  Config.nSaveDBCount := 0;
  Config.nDBQueryID := 0;
  boStartReady := False;
  g_boExitServer := False;
  boFilterWord := True;
  Config.nWinLotteryCount := 0;
  Config.nNoWinLotteryCount := 0;
  Config.nWinLotteryLevel1 := 0;
  Config.nWinLotteryLevel2 := 0;
  Config.nWinLotteryLevel3 := 0;
  Config.nWinLotteryLevel4 := 0;
  Config.nWinLotteryLevel5 := 0;
  Config.nWinLotteryLevel6 := 0;
  SafeFillChar(g_Config.GlobalVal, SizeOf(g_Config.GlobalVal), #0);
  SafeFillChar(g_Config.GlobaDyMval, SizeOf(g_Config.GlobaDyMval), #0);
  SafeFillChar(g_Config.GlobalAVal, SizeOf(g_Config.GlobalAVal), #0);
  SafeFillChar(g_Config.GlobalUVal, SizeOf(g_Config.GlobalUVal), #0);
{$IF USECODE = USEREMOTECODE}
  New(Config.Encode6BitBuf);
  Config.Encode6BitBuf^ := g_Encode6BitBuf;

  New(Config.Decode6BitBuf);
  Config.Decode6BitBuf^ := g_Decode6BitBuf;
{$IFEND}
  LoadConfig();

  {c := 0;
  for I := 45 to 75 do
    c := Int64(Config.dwNeedExps[I]) + c;
  MemoLog.Lines.Add(IntToStr(C));  }
  Memo := MemoLog;
  //nServerIndex := 0;
  //zPlugOfEngine := TPlugOfEngine.Create;
  {$IFDEF PLUGOPEN}
  PlugInEngine := TPlugInManage.Create;
  zPlugOfEngine := TPlugOfEnginge.Create;
  {$ENDIF}
  RunSocket := TRunSocket.Create();
  MainLogMsgList := TStringList.Create;
  LogStringList := TStringList.Create;
  LogonCostLogList := TStringList.Create;
  g_MapManager := TMapManager.Create;
  g_FBMapManager := TGStringList.Create;
  ItemUnit := TItemUnit.Create;
  MagicManager := TMagicManager.Create;
  //NoticeManager := TNoticeManager.Create;
  g_GuildManager := TGuildManager.Create;
  g_EventManager := TEventManager.Create;
  g_CastleManager := TCastleManager.Create;
  {
  g_UserCastle        := TUserCastle.Create;

  CastleManager.Add(g_UserCastle);
  }
  for I := Low(g_MakeMagicList) to High(g_MakeMagicList) do
    g_MakeMagicList[I] := TList.Create;

  FrontEngine := TFrontEngine.Create(True);
  UserEMail := TUserEMail.Create(True);
  UserEngine := TUserEngine.Create();
  //RobotManage := TRobotManage.Create;
  g_MakeItemList := TList.Create;
  g_BoxsList := TList.Create;
  g_StartPointList := TGStringList.Create;
  g_MapQuestList := TList.Create;
  ServerTableList := TList.Create;
  g_DenySayMsgList := TQuickList.Create;
  MiniMapList := TStringList.Create;
  g_UnbindList := TStringList.Create;
  LineNoticeList := TStringList.Create;
  //QuestDiaryList := TList.Create;
  ItemEventList := TStringList.Create;
  //AbuseTextList := TStringList.Create;
  g_MonSayMsgList := TStringList.Create;
  {g_DisableMakeItemList := TGStringList.Create;
  g_EnableMakeItemList := TGStringList.Create;  }
  //g_DisableMoveMapList := TGStringList.Create;
  //g_ItemNameList := TGList.Create;
  g_DisableSendMsgList := TGStringList.Create;
  {g_MonDropLimitLIst := TGStringList.Create;
  g_DisableTakeOffList := TGStringList.Create; }
  g_CompoundInfoList := TGStringList.Create;
  g_UnMasterList := TGStringList.Create;
  g_UnMarryList := TGStringList.Create;
  g_UserCmdList := TGStringList.Create;
  g_UnForceMasterList := TGStringList.Create;
  g_GameLogItemNameList := TGStringList.Create;
  g_DenyIPAddrList := TGStringList.Create;
  g_DenyChrNameList := TGStringList.Create;
  g_DenyAccountList := TGStringList.Create;
  g_UnFriendList := TStringList.Create;
  g_MonDropLimitList := TGList.Create;
  g_FilterSay := TGStringList.Create;
  g_FilterGuild := TGStringList.Create;
  g_FilterShop := TGStringList.Create;
  g_SetItemsList := TList.Create;
  //g_SetItems := TGList.Create;
  //g_NoClearMonList := TGStringList.Create;

  //g_ItemBindIPaddr := TGList.Create;
  //g_ItemBindAccount := TGList.Create;
  //g_ItemBindCharName := TGList.Create;

  //g_AllowSellOffItemList := TGStringList.Create;
  //g_SellOffGoodList := TSellOffGoodList.Create;
  //g_SellOffGoldList := TSellOffGoldList.Create;
  //g_BigStorageList := TBigStorageList.Create;

  {g_MapEventListOfDropItem := TGList.Create;
  g_MapEventListOfPickUpItem := TGList.Create;
  g_MapEventListOfMine := TGList.Create;
  g_MapEventListOfWalk := TGList.Create;
  g_MapEventListOfRun := TGList.Create; }
  g_MapEventList  := TGList.Create;

  InitializeCriticalSection(LogMsgCriticalSection);
  InitializeCriticalSection(ProcessMsgCriticalSection);
  InitializeCriticalSection(ProcessHumanCriticalSection);

  InitializeCriticalSection(Config.UserIDSection);
  InitializeCriticalSection(UserDBSection);
  InitializeCriticalSection(Config.DBSocketSection);
  CS_6 := TCriticalSection.Create;
  g_DynamicVarList := TList.Create;

  SafeFillChar(g_TaxisAllList, SizeOf(g_TaxisAllList), #0);
  SafeFillChar(g_TaxisWarrList, SizeOf(g_TaxisWarrList), #0);
  SafeFillChar(g_TaxisWaidList, SizeOf(g_TaxisWaidList), #0);
  SafeFillChar(g_TaxisTaosList, SizeOf(g_TaxisTaosList), #0);
  SafeFillChar(g_TaxisMasterList, SizeOf(g_TaxisMasterList), #0);

  SafeFillChar(g_TaxisHeroAllList, SizeOf(g_TaxisHeroAllList), #0);
  SafeFillChar(g_TaxisHeroWarrList, SizeOf(g_TaxisHeroWarrList), #0);
  SafeFillChar(g_TaxisHeroWaidList, SizeOf(g_TaxisHeroWaidList), #0);
  SafeFillChar(g_TaxisHeroTaosList, SizeOf(g_TaxisHeroTaosList), #0);

  //AddToProcTable(@TPlugOfEngine_SetUserLicense, PChar(Base64DecodeStr('U2V0VXNlckxpY2Vuc2U=')), 5); //  SetUserLicense
  //AddToProcTable(@TFrmMain_ChangeGateSocket, PChar(Base64DecodeStr('Q2hhbmdlR2F0ZVNvY2tldA==')), 6); //ChangeGateSocket

  TimeNow := Now();
  DecodeDate(TimeNow, Year, Month, Day);
  DecodeTime(TimeNow, Hour, Min, Sec, MSec);
  if not DirectoryExists(g_Config.sLogDir) then begin
    CreateDir(Config.sLogDir);
  end;

  sLogFileName := g_Config.sLogDir {'.\Log\'} + IntToStr(Year) + '-' +
  IntToStr2(Month) + '-' + IntToStr2(Day) + '.' + IntToStr2(Hour) + '-' +
    IntToStr2(Min) + '.txt';
  AssignFile(F, sLogFileName);
  Rewrite(F);
  CloseFile(F);
  Caption := '';
  MemoLog.Lines.Add('Reading configuration information.');
  nShiftUsrDataNameNo := 1;

  DBSocket.Address := g_Config.sDBAddr;
  DBSocket.Port := g_Config.nDBPort;
  Caption := g_Config.sServerName;
  sCaption := g_Config.sServerName;
  LoadServerTable();

  {if Decode(sBUYHINTINFO, s) then Dec(nCrackedLevel, 5);
  nAppFilesSize := GetFilesSize(Application.ExeName);         //��������С�������ȷ��Ϊ�ѿ��ƽ�
  if Decode(sFilesSize,sAppFilesSize) then begin
    nStartFilesSize:=StrToIntDef(sAppFilesSize,0)-10000;
    nEndFilesSize:=StrToIntDef(sAppFilesSize,0)+10000;
    if (nAppFilesSize >=nStartFilesSize) and (nAppFilesSize <=nEndFilesSize) then Dec(nErrorLevel,1000) else Inc(nErrorLevel,888);
  end;   }

  IdUDPClientLog.Host := g_Config.sLogServerAddr;
  IdUDPClientLog.Port := g_Config.nLogServerPort;

  Application.OnIdle := AppOnIdle;
  Application.OnException := OnProgramException;

end;

procedure TFrmMain.StopService;
var
  i: Integer;
  Config: pTConfig;
{$IF DBSOCKETMODE = THREADENGINE}
  ThreadInfo: pTThreadInfo;
{$IFEND}
begin
  try
    //SaveUnFriendList;
    Timer1.Enabled := False;
    SaveVariableTimer.Enabled := False;
    Timer1Timer(Timer1);
    RunTimer.Enabled := False;
    FrontEngine.Terminate();
    //UserEMail.FreeInitialize;
    UserEMail.Terminate;

    Config := @g_Config;
    {$IFDEF PLUGOPEN}
    PlugInEngine.Free;
    zPlugOfEngine.Free;
    {$ENDIF}
    ShopEngine.SaveShopItems(False);
    ShopEngine.Freeinitialize;
    UnInitCoralWry();
    //zPlugOfEngine.Free;


    FrmIDSoc.Close;
    GateSocket.Close;
    Memo := nil;
    SaveItemNumber(True);
    g_CastleManager.Free;

{$IF DBSOCKETMODE = THREADENGINE}
    ThreadInfo := @Config.DBSocketThread;
    ThreadInfo.boTerminaled := True;
    if WaitForSingleObject(ThreadInfo.hThreadHandle, 1000) <> 0 then begin
      SuspendThread(ThreadInfo.hThreadHandle);
    end;
{$IFEND}

    FrontEngine.Free;
    UserEMail.Free;
    MagicManager.Free;

    UserEngine.Free;

    RobotManage.Free;

    RunSocket.Free;

    ConnectTimer.Enabled := False;
    DBSocket.Close;

    FreeAndNil(MainLogMsgList);
    FreeAndNil(LogStringList);
    FreeAndNil(LogonCostLogList);
    g_MapManager.Free;
    g_FBMapManager.Free;
    ItemUnit.Free;

    //NoticeManager.Free;
    g_GuildManager.Free;

    for i := 0 to g_MakeItemList.Count - 1 do begin
      Dispose(pTMakeItem(g_MakeItemList[i]));
    end;
    for i := 0 to g_StartPointList.Count - 1 do begin
      DisPose(pTStartPoint(g_StartPointList.Objects[i]));
    end;
    FreeAndNil(g_StartPointList);
    
    FreeAndNil(g_BoxsList);

    for i := 0 to g_MapQuestList.Count - 1 do begin
      DisPose(pTQuestInfo(g_MapQuestList[i]));
    end;
    FreeAndNil(g_MapQuestList);

    for I := 0 to g_SetItemsList.Count - 1 do begin
      Dispose(pTSetItems(g_SetItemsList[I])); 
    end;

    for I := 0 to g_CompoundInfoList.Count - 1 do begin
      Dispose(pTCompoundInfos(g_CompoundInfoList.Objects[I])); 
    end;

    FreeAndNil(g_MakeItemList);
    FreeAndNil(ServerTableList);
    FreeAndNil(g_DenySayMsgList);
    FreeAndNil(MiniMapList);
    FreeAndNil(g_UnbindList);
    FreeAndNil(LineNoticeList);
    //FreeAndNil(QuestDiaryList);
    FreeAndNil(ItemEventList);
    //FreeAndNil(AbuseTextList);
    FreeAndNil(g_MonSayMsgList);
    {FreeAndNil(g_DisableMakeItemList);
    FreeAndNil(g_EnableMakeItemList);  }
    //FreeAndNil(g_DisableMoveMapList);
    //FreeAndNil(g_ItemNameList);
    FreeAndNil(g_DisableSendMsgList);
    {FreeAndNil(g_MonDropLimitLIst);
    FreeAndNil(g_DisableTakeOffList); }
    FreeAndNil(g_CompoundInfoList);
    FreeAndNil(g_UnMasterList);
    FreeAndNil(g_UnMarryList);
    FreeAndNil(g_UserCmdList);
    FreeAndNil(g_UnForceMasterList);
    FreeAndNil(g_GameLogItemNameList);
    FreeAndNil(g_DenyIPAddrList);
    FreeAndNil(g_DenyChrNameList);
    FreeAndNil(g_DenyAccountList);
    FreeAndNil(g_UnFriendList);

    FreeAndNil(g_FilterSay);
    FreeAndNil(g_FilterGuild);
    FreeAndNil(g_FilterShop);
    FreeAndNil(g_SetItemsList);


    //FreeAndNil(g_NoClearMonList);
    //FreeAndNil(g_AllowSellOffItemList);
    //g_SellOffGoldList.UnLoadSellOffGoldList();
    //g_SellOffGoodList.UnLoadSellOffGoodList();
    //FreeAndNil(g_SellOffGoodList);
    //FreeAndNil(g_SellOffGoldList);
    //FreeAndNil(g_BigStorageList);
    {for i := 0 to g_ItemBindIPaddr.Count - 1 do begin
      DisPose(pTItemBind(g_ItemBindIPaddr.Items[i]));
    end;
    for i := 0 to g_ItemBindAccount.Count - 1 do begin
      DisPose(pTItemBind(g_ItemBindAccount.Items[i]));
    end;
    for i := 0 to g_ItemBindCharName.Count - 1 do begin
      DisPose(pTItemBind(g_ItemBindCharName.Items[i]));
    end;
    FreeAndNil(g_ItemBindIPaddr);
    FreeAndNil(g_ItemBindAccount);
    FreeAndNil(g_ItemBindCharName);  }

    for I := Low(g_MakeMagicList) to High(g_MakeMagicList) do
      FreeAndNil(g_MakeMagicList[I]);

    for i := 0 to g_MapEventList.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventList.Items[i]));
    end;
    FreeAndNil(g_MapEventList);

   { for I := 0 to g_SetItems.Count - 1 do begin
      pTSetItems(g_SetItems[I]).ItemsList.Free;
      pTSetItems(g_SetItems[I]).ValueList.Free;
      Dispose(pTSetItems(g_SetItems[I]));
    end;
    FreeAndNil(g_SetItems);     }
    {for i := 0 to g_MapEventListOfDropItem.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventListOfDropItem.Items[i]));
    end;
    FreeAndNil(g_MapEventListOfDropItem);

    for i := 0 to g_MapEventListOfPickUpItem.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventListOfPickUpItem.Items[i]));
    end;
    FreeAndNil(g_MapEventListOfPickUpItem);

    for i := 0 to g_MapEventListOfMine.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventListOfMine.Items[i]));
    end;
    FreeAndNil(g_MapEventListOfMine);

    for i := 0 to g_MapEventListOfWalk.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventListOfWalk.Items[i]));
    end;
    FreeAndNil(g_MapEventListOfWalk);

    for i := 0 to g_MapEventListOfRun.Count - 1 do begin
      DisPose(pTMapEvent(g_MapEventListOfRun.Items[i]));
    end;
    FreeAndNil(g_MapEventListOfRun); }

    DeleteCriticalSection(LogMsgCriticalSection);
    DeleteCriticalSection(ProcessMsgCriticalSection);
    DeleteCriticalSection(ProcessHumanCriticalSection);

    DeleteCriticalSection(Config.UserIDSection);
    DeleteCriticalSection(UserDBSection);
    DeleteCriticalSection(Config.DBSocketSection);


    CS_6.Free;
    for i := 0 to g_DynamicVarList.Count - 1 do begin
      DisPose(pTDynamicVar(g_DynamicVarList.Items[i]));
    end;
    FreeAndNil(g_DynamicVarList);

    if g_BindItemTypeList <> nil then begin
      for i := 0 to g_BindItemTypeList.Count - 1 do begin
        DisPose(pTBindItem(g_BindItemTypeList.Items[i]));
      end;
      FreeAndNil(g_BindItemTypeList);
    end;

    if g_MonDropLimitList <> nil then begin
      for I := 0 to g_MonDropLimitList.Count - 1 do begin
        Dispose(pTMonDropLimitInfo(g_MonDropLimitList.Items[I]));
      end;
      FreeAndNil(g_MonDropLimitList);
    end;

    //FreeAndNil(g_AllowPickUpItemList);

    boServiceStarted := False;
    FreeCheckDll;
  except
    {on E: Exception do begin
      ShowMessage('������Ϣ:' + E.Message);
      Exit;
      raise;
    end; }
  end;
end;

procedure TFrmMain.MENU_HELP_ABOUTClick(Sender: TObject);
begin
  MainOutMessage(g_sUpDateTime);
  MainOutMessage(g_sProgram);
  MainOutMessage(g_sWebSite);
end;

procedure TFrmMain.DBSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if not g_boDBSocketRead then
  MainOutMessage('Database server(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')connection successful.');
  g_boDBSocketRead := True;
  if g_Config.pDBSocketRecvBuff <> nil then
    FreeMem(g_Config.pDBSocketRecvBuff);
  g_Config.pDBSocketRecvBuff := nil;
  g_Config.nDBSocketRecvLeng := 0;
end;

procedure TFrmMain.DBSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if g_boDBSocketRead then
  MainOutMessage('Database server(' + Socket.RemoteAddress + ':' +
    IntToStr(Socket.RemotePort) + ')Disconnected.');
  g_boDBSocketRead := False;
  if g_Config.pDBSocketRecvBuff <> nil then
    FreeMem(g_Config.pDBSocketRecvBuff);
  g_Config.pDBSocketRecvBuff := nil;
  g_Config.nDBSocketRecvLeng := 0;
end;

procedure TFrmMain.MENU_OPTION_SERVERCONFIGClick(Sender: TObject);
begin
  FrmServerValue := TFrmServerValue.Create(Owner);
  FrmServerValue.Top := Self.Top + 20;
  FrmServerValue.Left := Self.Left;
  FrmServerValue.AdjuestServerConfig();
  FrmServerValue.Free;
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  frmGeneralConfig := TfrmGeneralConfig.Create(Owner);
  frmGeneralConfig.Top := Self.Top + 20;
  frmGeneralConfig.Left := Self.Left;
  frmGeneralConfig.Open();
  frmGeneralConfig.Free;
  Caption := g_Config.sServerName;
end;

procedure TFrmMain.MENU_OPTION_GAMEClick(Sender: TObject);
begin
  frmGameConfig := TfrmGameConfig.Create(Owner);
  frmGameConfig.Top := Self.Top + 20;
  frmGameConfig.Left := Self.Left;
  frmGameConfig.Open;
  frmGameConfig.Free;
end;

procedure TFrmMain.MENU_OPTION_FUNCTIONClick(Sender: TObject);
begin
  frmFunctionConfig := TfrmFunctionConfig.Create(Owner);
  frmFunctionConfig.Top := Self.Top + 20;
  frmFunctionConfig.Left := Self.Left;
  frmFunctionConfig.Open;
  frmFunctionConfig.Free;
end;

procedure TFrmMain.G1Click(Sender: TObject);
begin
  frmGameCmd := TfrmGameCmd.Create(Owner);
  frmGameCmd.Top := Self.Top + 20;
  frmGameCmd.Left := Self.Left;
  frmGameCmd.Open;
  frmGameCmd.Free;
end;

procedure TFrmMain.MENU_OPTION_MONSTERClick(Sender: TObject);
begin
  frmMonsterConfig := TfrmMonsterConfig.Create(Owner);
  frmMonsterConfig.Top := Self.Top + 20;
  frmMonsterConfig.Left := Self.Left;
  frmMonsterConfig.Open;
  frmMonsterConfig.Free;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MONSTERSAYClick(Sender: TObject);
begin
  UserEngine.ClearMonSayMsg();
  FrmDB.LoadMonSayMsg();
  MainOutMessage('���¼��ع���˵���������...');
end;

procedure TFrmMain.MENU_CONTROL_TESTSERVERClick(Sender: TObject);
begin
  g_boTestServer := not g_boTestServer;
  MENU_CONTROL_TESTSERVER.Checked := g_boTestServer;

end;

procedure TFrmMain.MENU_CONTROL_RELOAD_DISABLEMAKEClick(Sender: TObject);
begin
  {LoadDisableTakeOffList();
  LoadDisableMakeItem();
  LoadEnableMakeItem(); }
  //LoadDisableMoveMap();
  //ItemUnit.LoadCustomItemName();
  LoadDisableSendMsgList();
  LoadGameLogItemNameList();
  {LoadItemBindIPaddr();
  LoadItemBindAccount();
  LoadItemBindCharName();  }
  LoadUnMasterList();
  LoadUnForceMasterList();
  LoadDenyIPAddrList();
  LoadDenyAccountList();
  LoadDenyChrNameList();
  //LoadNoClearMonList();
  //LoadAllowSellOffItemList();
  FrmDB.LoadAdminList();
  MainOutMessage('���¼����б��������...');
end;

procedure TFrmMain.MENU_CONTROL_GATE_OPENClick(Sender: TObject);
resourcestring
  sGatePortOpen = 'Game gateway port (%s:%d) Open.';
begin
  if not GateSocket.Active then begin
    GateSocket.Active := True;
    MainOutMessage(format(sGatePortOpen, [GateSocket.Address,
      GateSocket.Port]));
  end;
end;

procedure TFrmMain.MENU_CONTROL_GATE_CLOSEClick(Sender: TObject);
begin
  CloseGateSocket();
end;

procedure TFrmMain.CloseGateSocket;
var
  i: Integer;
resourcestring
  sGatePortClose = 'Game gateway port (%s:%d) Closed.';
begin
  if GateSocket.Active then begin
    for i := 0 to GateSocket.Socket.ActiveConnections - 1 do begin
      GateSocket.Socket.Connections[i].Close;
    end;
    GateSocket.Active := False;
    MainOutMessage(format(sGatePortClose, [GateSocket.Address,
      GateSocket.Port]));
  end;
end;

procedure TFrmMain.MENU_CONTROLClick(Sender: TObject);
begin
  if GateSocket.Active then begin
    MENU_CONTROL_GATE_OPEN.Enabled := False;
    MENU_CONTROL_GATE_CLOSE.Enabled := True;
  end
  else begin
    MENU_CONTROL_GATE_OPEN.Enabled := True;
    MENU_CONTROL_GATE_CLOSE.Enabled := False;
  end;
end;

procedure UserEngineProcess(Config: pTConfig; ThreadInfo: pTThreadInfo);
var
  nRunTime: Integer;
  dwRunTick: LongWord;
begin
  l_dwRunTimeTick := 0;
  dwRunTick := GetTickCount();
  ThreadInfo.dwRunTick := dwRunTick;
  while not ThreadInfo.boTerminaled do begin
    nRunTime := GetTickCount - ThreadInfo.dwRunTick;
    if ThreadInfo.nRunTime < nRunTime then
      ThreadInfo.nRunTime := nRunTime;
    if ThreadInfo.nMaxRunTime < nRunTime then
      ThreadInfo.nMaxRunTime := nRunTime;
    if GetTickCount - dwRunTick >= 1000 then begin
      dwRunTick := GetTickCount();
      if ThreadInfo.nRunTime > 0 then
        Dec(ThreadInfo.nRunTime);
    end;

    ThreadInfo.dwRunTick := GetTickCount();
    ThreadInfo.boActived := True;
    ThreadInfo.nRunFlag := 125;
    if Config.boThreadRun then
      ProcessGameRun();
    Sleep(1);
  end;
end;

procedure UserEngineThread(ThreadInfo: pTThreadInfo); stdcall;
var
  nErrorCount: Integer;
resourcestring
  sExceptionMsg = '[Exception] UserEngineThread ErrorCount = %d';
begin
  nErrorCount := 0;
  while True do begin
    try
      UserEngineProcess(ThreadInfo.Config, ThreadInfo);
      break;
    except
      Inc(nErrorCount);
      if nErrorCount > 10 then
        break;
      MainOutMessage(format(sExceptionMsg, [nErrorCount]));
    end;
  end;
  ExitThread(0);
end;

procedure ProcessGameRun();
var
  i: Integer;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    UserEngine.PrcocessData;
    g_EventManager.Run;
    RobotManage.Run;
    if GetTickCount - l_dwRunTimeTick > 10000 then begin
      l_dwRunTimeTick := GetTickCount();
      g_GuildManager.Run;
      g_CastleManager.Run;
      g_DenySayMsgList.Lock;
      try
        for i := g_DenySayMsgList.Count - 1 downto 0 do begin
          if GetTickCount > LongWord(g_DenySayMsgList.Objects[i]) then begin
            g_DenySayMsgList.Delete(i);
          end;
        end;
      finally
        g_DenySayMsgList.UnLock;
      end;
    end;
    
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.MENU_VIEW_COMClick(Sender: TObject);
begin
  FrmViewCompoundInfo.Open();
end;

procedure TFrmMain.MENU_VIEW_GATEClick(Sender: TObject);
begin
  {MENU_VIEW_GATE.Checked := not MENU_VIEW_GATE.Checked;
  GridGate.Visible := MENU_VIEW_GATE.Checked; }
end;

procedure TFrmMain.MENU_VIEW_SESSIONClick(Sender: TObject);
begin
  frmViewSession := TfrmViewSession.Create(Owner);
  frmViewSession.Top := Top + 20;
  frmViewSession.Left := Left;
  frmViewSession.Open();
  frmViewSession.Free;
end;

procedure TFrmMain.MENU_VIEW_ONLINEHUMANClick(Sender: TObject);
begin
  frmViewOnlineHuman := TfrmViewOnlineHuman.Create(Owner);
  frmViewOnlineHuman.Top := Top + 20;
  frmViewOnlineHuman.Left := Left;
  frmViewOnlineHuman.Open();
  frmViewOnlineHuman.Free;
end;

procedure TFrmMain.MENU_VIEW_LEVELClick(Sender: TObject);
begin
  frmViewLevel := TfrmViewLevel.Create(Owner);
  frmViewLevel.Top := Top + 20;
  frmViewLevel.Left := Left;
  frmViewLevel.Open();
  frmViewLevel.Free;
end;

procedure TFrmMain.MENU_VIEW_LISTClick(Sender: TObject);
begin
  frmViewList := TfrmViewList.Create(Owner);
  frmViewList.Top := Top + 20;
  frmViewList.Left := Left;
  frmViewList.Open();
  frmViewList.Free;
end;

procedure TFrmMain.MENU_MANAGE_ONLINEEMAILClick(Sender: TObject);
begin
  frmOnlineEmail := TfrmOnlineEmail.Create(Owner);
  frmOnlineEmail.Top := Top + 20;
  frmOnlineEmail.Left := Left;
  frmOnlineEmail.Open();
  frmOnlineEmail.Free;
end;

procedure TFrmMain.MENU_MANAGE_ONLINEMSGClick(Sender: TObject);
begin
  frmOnlineMsg := TfrmOnlineMsg.Create(Owner);
  frmOnlineMsg.Top := Top + 20;
  frmOnlineMsg.Left := Left;
  frmOnlineMsg.Open();
  frmOnlineMsg.Free;
end;

procedure TFrmMain.MENU_MANAGE_PLUGClick(Sender: TObject);
begin
  {$IFDEF PLUGOPEN}
  ftmPlugInManage := TftmPlugInManage.Create(Owner);
  ftmPlugInManage.Top := Top + 20;
  ftmPlugInManage.Left := Left;
  ftmPlugInManage.Open();
  ftmPlugInManage.Free;
  {$ENDIF}
end;

procedure TFrmMain.MENU_MANAGE_SHOPClick(Sender: TObject);
begin
  FormShop := TFormShop.Create(Owner);
  FormShop.Top := Top + 20;
  FormShop.Left := Left;
  FormShop.Open();
  FormShop.Free;
end;

procedure TFrmMain.SetMenu;
begin
  FrmMain.Menu := MainMenu;
end;

procedure TFrmMain.MENU_VIEW_KERNELINFOClick(Sender: TObject);
begin
  frmViewKernelInfo := TfrmViewKernelInfo.Create(Owner);
  frmViewKernelInfo.Top := Top + 20;
  frmViewKernelInfo.Left := Left;
  frmViewKernelInfo.Open();
  frmViewKernelInfo.Free;
end;

procedure TFrmMain.MENU_TOOLS_MERCHANTClick(Sender: TObject);
begin
  frmConfigMerchant := TfrmConfigMerchant.Create(Owner);
  frmConfigMerchant.Top := Top + 20;
  frmConfigMerchant.Left := Left;
  frmConfigMerchant.Open();
  frmConfigMerchant.Free;
end;

procedure TFrmMain.MENU_OPTION_ITEMFUNCClick(Sender: TObject);
begin
  frmItemSet := TfrmItemSet.Create(Owner);
  frmItemSet.Top := Top + 20;
  frmItemSet.Left := Left;
  frmItemSet.Open();
  frmItemSet.Free;
end;

procedure TFrmMain.ClearMemoLog;
begin
  if Application.MessageBox('�Ƿ�ȷ�������־��Ϣ.',
    '��ʾ��Ϣ', MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    MemoLog.Clear;
  end;
end;

procedure TFrmMain.MENU_TOOLS_MONGENClick(Sender: TObject);
begin
  frmConfigMonGen := TfrmConfigMonGen.Create(Owner);
  frmConfigMonGen.Top := Top + 20;
  frmConfigMonGen.Left := Left;
  frmConfigMonGen.Open();
  frmConfigMonGen.Free;
end;

procedure TFrmMain.MENU_TOOLS_NPCClick(Sender: TObject);
begin
  frmConfigMerchant := TfrmConfigMerchant.Create(Owner);
  frmConfigMerchant.Top := Top + 20;
  frmConfigMerchant.Left := Left;
  frmConfigMerchant.Open();
  frmConfigMerchant.Free;
end;

procedure TFrmMain.MENU_TOOLS_OFFLINE_LOADNAMEClick(Sender: TObject);
var
  LoadList: TStringList;
  sName: string;
begin
  if FileExists('.\OffLineList.txt') then begin
    LoadList := TStringList.Create;
    Try
      LoadList.LoadFromFile('.\OffLineList.txt');
      for sName in LoadList do begin
        if (sName <> '') and (sName[1] <> ';') then begin
          FrontEngine.AddToLoadRcdList('', sName, '127.0.0.1', False, -1, 0, 0, 20110101, -1, -1, -1, 0);
        end;
      end;
    Finally
      LoadList.Free;
    End;
  end;
  {FrontEngine.AddToLoadRcdList(sAccount,
                  sChrName,
                  GateUser.sIPaddr,
                  boFlag,
                  nSessionID,
                  nGameGold,
                  nIDIndex,
                  //nPayMent,
                  //nPayMode,
                  nClientVersion,
                  nSocket,
                  GateUser.nGSocketIdx,
                  GateIdx,
                  nCheckEMail);    }
end;

procedure TFrmMain.MENU_TOOLS_OFFLINE_SAVENAMEClick(Sender: TObject);
var
  i: Integer;
  SaveList: TStringList;
begin
  SaveList := TStringList.Create;
  Try
    for I := 0 to UserEngine.m_OffLineList.Count - 1 do begin
      SaveList.Add(UserEngine.m_OffLineList[I]);
    end;
    SaveList.SaveToFile('.\OffLineList.txt');
    MainOutMessage('�����ѻ�����������OffLineList.txt�ɹ�...');
  Finally
    SaveList.Free;
  End;

end;

procedure TFrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  wIdent: Word;
  TopHeader: TTopHeader;
begin
  wIdent := HiWord(MsgData.From);
  sData := StrPas(PAnsiChar(MsgData.CopyDataStruct^.lpData));
  case wIdent of
    GS_QUIT: begin
        g_boExitServer := True;
        CloseGateSocket();
        g_Config.boKickAllUser := True;
        CloseTimer.Enabled := True;
      end;
    1: ;
    2: ;
    3: ;
    1000: begin
        MsgData.Result := 1;
      end;
    1001: begin
        TopHeader := pTTopHeader(MsgData.CopyDataStruct^.lpData)^;
        if (TopHeader.btType in [0..13]) then begin
          if (TopHeader.wCount > 0) then begin
            SetLength(g_TopInfo[TopHeader.btType], TopHeader.wCount);
            Move(PAnsiChar(MsgData.CopyDataStruct.lpData)[SizeOf(TopHeader)], g_TopInfo[TopHeader.btType][0], TopHeader.wCount * SizeOf(TTopInfo));
          end else g_TopInfo[TopHeader.btType] := nil;
        end;
      end;
  end;
end;

procedure TFrmMain.MENU_TOOLS_TESTClick(Sender: TObject);
{$IFDEF DEBUG}
//var
//  HumanRcd: THumDataInfo;
var
  PlayObject: TPlayObject;
  {sX, sY: String;
  MapCellInfo: pTMapCellinfo;
  I: Integer;
  OSObject: pTOSObject;
  BaseObject: TBaseObject; }
{$ENDIF}
begin
{$IFDEF DEBUG}
  PlayObject := UserEngine.GetPlayObject('������һ');
  MainOutMessage(Format('%d %d %d %d %d %d %d %d %d %d ', [PlayObject.m_nInteger[10],
    PlayObject.m_nInteger[11],
    PlayObject.m_nInteger[12],
    PlayObject.m_nInteger[13],
    PlayObject.m_nInteger[14],
    PlayObject.m_nInteger[15],
    PlayObject.m_nInteger[16],
    PlayObject.m_nInteger[17],
    PlayObject.m_nInteger[18],
    PlayObject.m_nInteger[19]]))
  {if PlayObject <> nil then begin
    if not InputQuery('��������', '����X����', sX) then
      Exit;
    if not InputQuery('��������', '����y����', sY) then
      Exit;

    if PlayObject.m_PEnvir.GetMapCellInfo(StrToIntDef(sX, 0), StrToIntDef(sY, 0), MapCellInfo) then begin
      MainOutMessage(IntToStr(MapCellInfo.chFlag));
      if (MapCellInfo.ObjList <> nil) then begin
        for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
          OSObject := MapCellInfo.ObjList.Items[I];
          if OSObject <> nil then begin
            if OSObject.btType = OS_MOVINGOBJECT then begin
              BaseObject := TBaseObject(OSObject.CellObj);
              if BaseObject <> nil then begin
                MainOutMessage(Format('%s %s %s %d %d', [sX, sY, BaseObject.m_sCharName, BaseObject.m_nCurrX, BaseObject.m_nCurrY]))
              end;
            end;
          end;
        end;
      end;
    end;
  end;   }

//  LoadRcd('1234565','aaaa','127.1.1.1',123, HumanRcd);
  //FrontEngine.AddToLoadRcdList('1234565', 'aaaa', '127.0.0.1' , False, 123, 0, 0, 0 , 0, 0, 0);
{$ENDIF}
end;

procedure TFrmMain.N2Click(Sender: TObject);
begin
  FrmDB.LoadDefiniensConst;
  MainOutMessage('�ű������б�������...');
end;

procedure TFrmMain.NPC1Click(Sender: TObject);
begin
  FrmDB.ReLoadMerchants();
  UserEngine.ReloadMerchantList();
  MainOutMessage('����NPC���¼������...');
  UserEngine.ReloadNpcList();
  MainOutMessage('����NPC���¼������...');
end;

procedure TFrmMain.MENU_TOOLS_IPSEARCHClick(Sender: TObject);
var
  sIPaddr: string;
begin
  try
    sIPaddr := '192.168.0.1';
    //sIPaddr := InputBox('IP���ڵ�����ѯ', '����IP��ַ:', '192.168.0.1');
    if not InputQuery('IP���ڵ�����ѯ', '����IP��ַ:', sIPaddr) then
      Exit;
    if not IsIPaddr(sIPaddr) then begin
      Application.MessageBox('�����IP��ַ��ʽ����ȷ.', '������Ϣ', MB_OK + MB_ICONERROR);
      Exit;
    end;
    {if not IsIPaddr(sIPaddr) then begin
      Application.MessageBox('�����IP��ַ��ʽ����ȷ.', '������Ϣ', MB_OK + MB_ICONERROR);
      Exit;
    end;  }
    MemoLog.Lines.Add(format('%s:%s', [sIPaddr, GetIPLocal(sIPaddr)]));
  except
    MemoLog.Lines.Add(format('%s:%s', [sIPaddr, 'δ֪']));
  end;
end;

procedure TFrmMain.MENU_MANAGE_CASTLEClick(Sender: TObject);
begin
  frmCastleManage := TfrmCastleManage.Create(Owner);
  frmCastleManage.Top := Top + 20;
  frmCastleManage.Left := Left;
  frmCastleManage.Open();
  frmCastleManage.Free;
end;

procedure TFrmMain.QFunctionNPCClick(Sender: TObject);
begin
  if g_FunctionNPC <> nil then begin
    g_FunctionNPC.ClearScript;
    g_FunctionNPC.LoadNpcScript;
    MainOutMessage('QFunction �ű��������...');
  end;
end;

procedure TFrmMain.QManageNPCClick(Sender: TObject);
begin
  if g_ManageNPC <> nil then begin
    g_ManageNPC.ClearScript();
    g_ManageNPC.LoadNpcScript();
    MainOutMessage('���¼��ص�½�ű����...');
  end;
end;

procedure TFrmMain.RobotManageNPCClick(Sender: TObject);
begin
  if g_RobotNPC <> nil then begin
    g_RobotNPC.ClearScript();
    g_RobotNPC.LoadNpcScript();
    RobotManage.RELOADROBOT();
    MainOutMessage('���¼��ػ����˽ű����...');
  end;
end;

procedure TFrmMain.MonItemsClick(Sender: TObject);
var
  i: Integer;
  Monster: pTMonInfo;
begin
  try
    for i := 0 to UserEngine.MonsterList.Count - 1 do begin
      Monster := UserEngine.MonsterList.Items[i];
      FrmDB.LoadMonitems(Monster.sName, Monster.ItemList);
    end;
    MainOutMessage('���ﱬ��Ʒ�б��ؼ������...');
  except
    MainOutMessage('���ﱬ��Ʒ�б��ؼ���ʧ��.');
  end;
end;

{$IF Public_Ver = Public_Release}
procedure TFrmMain.RunMessage(var Message: TMessage);
begin
  SendGameCenterMsg(SG_STARTOK, '��Ϸ�������������...');
end;
{$IFEND}

initialization
  begin
    //AddToProcTable(@ChangeCaptionText, Base64DecodeStr('Q2hhbmdlQ2FwdGlvblRleHQ='), 0 {} {'ChangeCaptionText'}); //���뺯���б�
    //nStartModule := AddToPulgProcTable(Base64DecodeStr('U3RhcnRNb2R1bGU='), 1); //StartModule
    //nGetRegisterName := AddToPulgProcTable(Base64DecodeStr('R2V0UmVnaXN0ZXJOYW1l'), 3); //GetRegisterName
    //nStartRegister := AddToPulgProcTable(Base64DecodeStr('UmVnaXN0ZXJMaWNlbnNl'), 4); //StartRegister
  end;
finalization
end.






