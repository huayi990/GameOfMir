unit RunDB;

interface

uses
  Windows, SysUtils, Grobal2, WinSock, M2Share, Common;

procedure DBSOcketThread(ThreadInfo: pTThreadInfo); stdcall;

function DBSocketConnected(): Boolean;

function GetDBSockMsg(nQueryID, nOldIdent, nLoadIdent: Integer; var nIdent: Integer; var nRecog: Integer; DataPoint: PAnsiChar; dwTimeOut: LongWord; boLoadRcd: Boolean): Boolean;

function MakeHumRcdFromLocal(var HumanRcd: THumDataInfo): Boolean;

function LoadHumRcdFromDB(sAccount, sCharName, sStr: string; var HumanRcd: THumDataInfo; nCertCode: Integer): Boolean;

function SaveHumRcdToDB(sAccount, sCharName: string; nSessionID: Integer; var HumanRcd: THumDataInfo): Boolean;

function SaveRcd(sAccount, sCharName: string; nSessionID: Integer; var HumanRcd: THumDataInfo): Boolean;

function LoadRcd(sAccount, sCharName, sStr: string; nCertCode: Integer; var HumanRcd: THumDataInfo): Boolean;

procedure SendDBSockMsg(SendBuff: PAnsiChar; nLeng: Integer);

function GetQueryID(Config: pTConfig): Integer;

implementation

uses
  svMain, HUtil32, EDcodeEx;

const
  UN_LOADRCD = 1;
  UN_SAVERCD = 2;

var
  DBReadBuff: array[0..8191] of Byte;

procedure DBSocketRead(Config: pTConfig);
var
  dwReceiveTimeTick: LongWord;
  nReceiveTime: Integer;
  nRecvLen: Integer;
  nRet: Integer;
begin
  try
    if Config.DBSocket = INVALID_SOCKET then
      Exit;
    dwReceiveTimeTick := GetTickCount();
    nRet := ioctlsocket(Config.DBSocket, FIONREAD, nRecvLen);
    if (nRet = SOCKET_ERROR) or (nRecvLen = 0) then
    begin
      WSAGetLastError;
      Config.DBSocket := INVALID_SOCKET;
      Sleep(100);
      Config.boDBSocketConnected := False;
      Exit;
    end;
    nRecvLen := recv(Config.DBSocket, DBReadBuff[0], SizeOf(DBReadBuff), 0);
    Inc(Config.nDBSocketRecvIncLen, nRecvLen);
    if (nRecvLen <> SOCKET_ERROR) and (nRecvLen > 0) then
    begin
      if nRecvLen > Config.nDBSocketRecvMaxLen then
        Config.nDBSocketRecvMaxLen := nRecvLen;
      EnterCriticalSection(UserDBSection);
      try
        ReallocMem(g_Config.pDBSocketRecvBuff, g_Config.nDBSocketRecvLeng + nRecvLen);
        Move(DBReadBuff[0], g_Config.pDBSocketRecvBuff[g_Config.nDBSocketRecvLeng], nRecvLen);
        Inc(g_Config.nDBSocketRecvLeng, nRecvLen);
      finally
        LeaveCriticalSection(UserDBSection);
      end;
    end;
    Inc(Config.nDBSocketRecvCount);
    nReceiveTime := GetTickCount - dwReceiveTimeTick;
    if Config.nDBReceiveMaxTime < nReceiveTime then
      Config.nDBReceiveMaxTime := nReceiveTime;
  except
    MainOutMessage('[Exception] RunDB->DBSocketRead');
  end;
end;

procedure DBSocketProcess(Config: pTConfig; ThreadInfo: pTThreadInfo);
var
  s: TSocket;
  name: sockaddr_in;
  HostEnt: PHostEnt;
  argp: Longint;
  readfds: TFDSet;
  timeout: TTimeVal;
  nRet: Integer;
  boRecvData: BOOL;
  nRunTime: Integer;
  dwRunTick: LongWord;
  boShow: Boolean;
resourcestring
  sIDServerConnected = '���ݿ������(%s:%d)���ӳɹ�...';
  sIDServerDisconnect = '���ݿ������(%s:%d)�Ͽ�����...';
begin
  try
    s := INVALID_SOCKET;
    if Config.DBSocket <> INVALID_SOCKET then
      s := Config.DBSocket;
    dwRunTick := GetTickCount();
    ThreadInfo.dwRunTick := dwRunTick;
    boRecvData := False;
    boShow := False;
    while True do
    begin
      EnterCriticalSection(Config.DBSocketSection);
      Try
        if ThreadInfo.boTerminaled then
          Break;
        if not boRecvData then
          Sleep(1)
        else
          Sleep(0);
        boRecvData := False;
        nRunTime := GetTickCount - ThreadInfo.dwRunTick;
        if ThreadInfo.nRunTime < nRunTime then
          ThreadInfo.nRunTime := nRunTime;
        if ThreadInfo.nMaxRunTime < nRunTime then
          ThreadInfo.nMaxRunTime := nRunTime;
        if GetTickCount - dwRunTick >= 1000 then
        begin
          dwRunTick := GetTickCount();
          if ThreadInfo.nRunTime > 0 then
            Dec(ThreadInfo.nRunTime);
        end;
        ThreadInfo.dwRunTick := GetTickCount();
        ThreadInfo.boActived := True;
        ThreadInfo.nRunFlag := 125;
        if (Config.DBSocket = INVALID_SOCKET) or (s = INVALID_SOCKET) then
        begin
          if Config.DBSocket <> INVALID_SOCKET then
          begin
            Config.DBSocket := INVALID_SOCKET;
            Sleep(100);
            ThreadInfo.nRunFlag := 126;
            Config.boDBSocketConnected := False;
          end;
          if s <> INVALID_SOCKET then
          begin
            closesocket(s);
            s := INVALID_SOCKET;
          end;
          if Config.sDBAddr = '' then
            Continue;
          s := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
          if s = INVALID_SOCKET then
            Continue;
          ThreadInfo.nRunFlag := 127;
          HostEnt := gethostbyname(PAnsiChar(@Config.sDBAddr[1]));
          if HostEnt = nil then
            Continue;
          PInteger(@name.sin_addr.S_addr)^ := PInteger(HostEnt.h_addr^)^;
          name.sin_family := HostEnt.h_addrtype;
          name.sin_port := htons(Config.nDBPort);
          name.sin_family := PF_INET;
          ThreadInfo.nRunFlag := 128;
          if connect(s, name, SizeOf(name)) = SOCKET_ERROR then
          begin
            WSAGetLastError;
            if boShow then
            begin
              boShow := False;
              MainOutMessage(Format(sIDServerDisconnect, [Config.sDBAddr, Config.nDBPort]));
            end;
            closesocket(s);
            s := INVALID_SOCKET;
            Continue;
          end;
          argp := 1;
          if ioctlsocket(s, FIONBIO, argp) = SOCKET_ERROR then
          begin
            closesocket(s);
            s := INVALID_SOCKET;
            Continue;
          end;
          ThreadInfo.nRunFlag := 129;
          Config.DBSocket := s;
          Config.boDBSocketConnected := True;
          if not boShow then
          begin
            boShow := True;
            MainOutMessage(Format(sIDServerConnected, [Config.sDBAddr, Config.nDBPort]));
          end;
        end;
        readfds.fd_count := 1;
        readfds.fd_array[0] := s;
        timeout.tv_sec := 0;
        timeout.tv_usec := 20;
        ThreadInfo.nRunFlag := 130;
        nRet := select(0, @readfds, nil, nil, @timeout);
        if nRet = SOCKET_ERROR then
        begin
          ThreadInfo.nRunFlag := 131;
          nRet := WSAGetLastError;
          if nRet = WSAEWOULDBLOCK then
          begin
            Sleep(10);
            Continue;
          end;
          ThreadInfo.nRunFlag := 132;
          nRet := WSAGetLastError;
          Config.nDBSocketWSAErrCode := nRet - WSABASEERR;
          Inc(Config.nDBSocketErrorCount);
          Config.DBSocket := INVALID_SOCKET;
          Sleep(100);
          Config.boDBSocketConnected := False;
          closesocket(s);
          s := INVALID_SOCKET;
          Continue;
        end;
        boRecvData := True;
        ThreadInfo.nRunFlag := 133;
        while (nRet > 0) do
        begin
          if nRet <= 0 then break;
          DBSocketRead(Config);
          Dec(nRet);
        end;
      Finally
        LeaveCriticalSection(Config.DBSocketSection);
      End;
    end;
    if Config.DBSocket <> INVALID_SOCKET then
    begin
      Config.DBSocket := INVALID_SOCKET;
      Config.boDBSocketConnected := False;
    end;
    if s <> INVALID_SOCKET then
    begin
      closesocket(s);
    end;
  except
    on E: Exception do
    begin
      MainOutMessage('[Exception] RunDB->DBSocketProcess');
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure DBSOcketThread(ThreadInfo: pTThreadInfo); stdcall;
var
  nErrorCount: Integer;
resourcestring
  sExceptionMsg = '[Exception] DBSocketThread ErrorCount = %d';
begin
  nErrorCount := 0;
  while True do
  begin
    try
      DBSocketProcess(ThreadInfo.Config, ThreadInfo);
      Break;
    except
      Inc(nErrorCount);
      if nErrorCount > 10 then
        Break;
      MainOutMessage(Format(sExceptionMsg, [nErrorCount]));
    end;
  end;
  ExitThread(0);
end;

function DBSocketConnected(): Boolean;
begin
{$IF DBSOCKETMODE = TIMERENGINE}
  Result := g_boDBSocketRead;
{$ELSE}
  Result := g_Config.boDBSocketConnected;
{$IFEND}

end;

function GetDBSockMsg(nQueryID, nOldIdent, nLoadIdent: Integer; var nIdent: Integer; var nRecog: Integer; DataPoint: PAnsiChar; dwTimeOut: LongWord; boLoadRcd: Boolean): Boolean;
var
  boLoadDBOK: Boolean;
  dwTimeOutTick: LongWord;
  nLen: Integer;
  Buff, TempBuff, MsgBuff: PAnsiChar;
  pMsg: pTDBMsgHeader;
  boExit: Boolean;
resourcestring
  sLoadDBTimeOut = '[RunDB] ��ȡ�������ݳ�ʱ... [';
  sSaveDBTimeOut = '[RunDB] �����������ݳ�ʱ... [';
begin
  boLoadDBOK := False;
  Result := False;
  boExit := False;
  dwTimeOutTick := GetTickCount();
  while (True) do
  begin
    if (GetTickCount - dwTimeOutTick) > dwTimeOut then
    begin
      n4EBB6C := n4EBB68;
      Break;
    end;
    EnterCriticalSection(UserDBSection);
    try
      Buff := g_Config.pDBSocketRecvBuff;
      nLen := g_Config.nDBSocketRecvLeng;
      if nLen >= SizeOf(TDBMsgHeader) then
      begin
        while (True) do
        begin
          pMsg := pTDBMsgHeader(Buff);
          if (pMsg.dwHead = RUNGATECODE) and (pMsg.dwCode = pMsg.dwCheckCode) then
          begin
            if (pMsg.nLength + SizeOf(TDBMsgHeader)) > nLen then
              Break;
            MsgBuff := Ptr(Longint(Buff) + SizeOf(TDBMsgHeader));
            if (pMsg.dwCode = nQueryID) then
            begin
              nIdent := pMsg.DefMsg.Ident;
              nRecog := pMsg.DefMsg.Recog;
              case nLoadIdent of
                UN_LOADRCD:
                  begin
                    Move(MsgBuff^, DataPoint^, SizeOf(TDBHumDataInfo));
                  end;
              end;
              boLoadDBOK := True;
              Result := True;
              nLen := 0;
              boExit := True;
              Break;
            end
            else
            begin
              Buff := Buff + SizeOf(TDBMsgHeader) + pMsg.nLength;
              nLen := nLen - (pMsg.nLength + SizeOf(TDBMsgHeader));
              Inc(g_Config.nLoadDBErrorCount);
            end;
          end
          else
          begin
            Inc(Buff);
            Dec(nLen);
          end;
          if nLen < SizeOf(TMsgHeader) then
            Break;
        end;
        if nLen > 0 then
        begin
          if g_Config.nDBSocketRecvLeng <> nLen then
          begin
            GetMem(TempBuff, nLen);
            Move(Buff^, TempBuff^, nLen);
            FreeMem(g_Config.pDBSocketRecvBuff);
            g_Config.pDBSocketRecvBuff := TempBuff;
            g_Config.nDBSocketRecvLeng := nLen;
          end;
        end
        else
        begin
          if g_Config.pDBSocketRecvBuff <> nil then
            FreeMem(g_Config.pDBSocketRecvBuff);
          g_Config.pDBSocketRecvBuff := nil;
          g_Config.nDBSocketRecvLeng := 0;
        end;
      end;
      if boExit then
      begin
        if g_Config.pDBSocketRecvBuff <> nil then
          FreeMem(g_Config.pDBSocketRecvBuff);
        g_Config.pDBSocketRecvBuff := nil;
        g_Config.nDBSocketRecvLeng := 0;
        Break;
      end;
    finally
      LeaveCriticalSection(UserDBSection);
    end;
    Sleep(1);
  end;
  if not boLoadDBOK then
  begin
    if boLoadRcd then
    begin
      MainOutMessage(sLoadDBTimeOut + IntToStr(nOldIdent) + ']');
    end
    else
    begin
      MainOutMessage(sSaveDBTimeOut + IntToStr(nOldIdent) + ']');
    end;
  end;
  if (GetTickCount - dwTimeOutTick) > dwRunDBTimeMax then
  begin
    dwRunDBTimeMax := GetTickCount - dwTimeOutTick;
  end;
  g_Config.boDBSocketWorking := False;
end;

function MakeHumRcdFromLocal(var HumanRcd: THumDataInfo): Boolean;
begin
  SafeFillChar(HumanRcd, SizeOf(THumDataInfo), #0);
  HumanRcd.Data.Abil.Level := 30;
  Result := True;
end;

function LoadHumRcdFromDB(sAccount, sCharName, sStr: string; var HumanRcd: THumDataInfo; nCertCode: Integer): Boolean;
begin
  Result := False;
  SafeFillChar(HumanRcd, SizeOf(THumDataInfo), #0);
  if LoadRcd(sAccount, sCharName, sStr, nCertCode, HumanRcd) then
  begin
    if (HumanRcd.Data.sChrName = sCharName) and ((HumanRcd.Data.sAccount = '') or (sAccount = '') or (HumanRcd.Data.sAccount = sAccount)) then
      Result := True;
  end;
  Inc(g_Config.nLoadDBCount);
end;

function SaveHumRcdToDB(sAccount, sCharName: string; nSessionID: Integer; var HumanRcd: THumDataInfo): Boolean;
begin
  Result := SaveRcd(sAccount, sCharName, nSessionID, HumanRcd);
  Inc(g_Config.nSaveDBCount);
end;

function SaveRcd(sAccount, sCharName: string; nSessionID: Integer; var HumanRcd: THumDataInfo): Boolean; //004B42C8
var
  nQueryID: Integer;
  nIdent: Integer;
  nRecog: Integer;
  pMsg: TDBMsgHeader;
  SendBuff: PAnsiChar;
  nLen: Integer;
  DBHumDataInfo: TDBHumDataInfo;
begin
  nQueryID := GetQueryID(@g_Config);
  Result := False;
  n4EBB68 := 101;
  DBHumDataInfo.sAccount := sAccount;
  DBHumDataInfo.UserName := sCharName;
  DBHumDataInfo.HumDataInfo := HumanRcd;
  pMsg.dwHead := RUNGATECODE;
  pMsg.dwCode := nQueryID;
  pMsg.dwCheckCode := nQueryID;
  pMsg.DefMsg.Ident := DB_SAVEHUMANRCD;
  pMsg.DefMsg.Recog := nSessionID;
  pMsg.nLength := SizeOf(TDBHumDataInfo);
  nLen := SizeOf(TDBMsgHeader) + SizeOf(TDBHumDataInfo);
  GetMem(SendBuff, nLen);
  Try
    Move(pMsg, SendBuff^, SizeOf(TDBMsgHeader));
    Move(DBHumDataInfo, SendBuff[SizeOf(TDBMsgHeader)], pMsg.nLength);
    SendDBSockMsg(SendBuff, nLen);
    if GetDBSockMsg(nQueryID, DB_SAVEHUMANRCD, UN_SAVERCD, nIdent, nRecog, nil, g_Config.dwGetDBSockMsgTime {5000}, False) then
    begin
      if (nIdent = DBR_SAVEHUMANRCD) and (nRecog = 1) then
        Result := True;
    end;
  Finally
    FreeMem(SendBuff);
  End;
end;

function LoadRcd(sAccount, sCharName, sStr: string; nCertCode: Integer; var HumanRcd: THumDataInfo): Boolean;
var
  LoadHuman: TLoadHuman;
  nQueryID: Integer;
  nIdent, nRecog: Integer;
  pMsg: TDBMsgHeader;
  SendBuff: PAnsiChar;
  nLen: Integer;
  DBHumDataInfo: TDBHumDataInfo;
begin
  Result := False;
  nQueryID := GetQueryID(@g_Config);
  pMsg.dwHead := RUNGATECODE;
  pMsg.dwCode := nQueryID;
  pMsg.dwCheckCode := nQueryID;
  pMsg.DefMsg.Ident := DB_LOADHUMANRCD;
  pMsg.nLength := SizeOf(TLoadHuman);
  nLen := SizeOf(TDBMsgHeader) + SizeOf(TLoadHuman);
  GetMem(SendBuff, nLen);
  Move(pMsg, SendBuff^, SizeOf(TDBMsgHeader));
  LoadHuman.sAccount := sAccount;
  LoadHuman.sChrName := sCharName;
  LoadHuman.sUserAddr := sStr;
  LoadHuman.nSessionID := nCertCode;
  Move(LoadHuman, SendBuff[SizeOf(TDBMsgHeader)], SizeOf(TLoadHuman));
  SafeFillChar(DBHumDataInfo, SizeOf(TDBHumDataInfo), #0);
  SendDBSockMsg(SendBuff, nLen);
  if GetDBSockMsg(nQueryID, DB_LOADHUMANRCD, UN_LOADRCD, nIdent, nRecog, @DBHumDataInfo, g_Config.dwGetDBSockMsgTime {5000}, True) then
  begin
    if (nIdent = DBR_LOADHUMANRCD) and (nRecog = 1) then
    begin
      if DBHumDataInfo.UserName = sCharName then
      begin
        HumanRcd := DBHumDataInfo.HumDataInfo;
        Result := True;
      end;
    end;
  end;
end;

procedure SendDBSockMsg(SendBuff: PAnsiChar; nLeng: Integer);
var
  Config: pTConfig;
{$IF DBSOCKETMODE = THREADENGINE}
  ThreadInfo: pTThreadInfo;
  timeout: TTimeVal;
  writefds: TFDSet;
  nRet: Integer;
  s: TSocket;
{$ELSE}
  nCheckCode: Integer;
  nSendLen: Integer;
{$IFEND}

begin
  Config := @g_Config;
{$IF DBSOCKETMODE = THREADENGINE}
  ThreadInfo := @g_Config.DBSocketThread;
  if not DBSocketConnected then
    Exit;
{$ELSE}
  if not g_boDBSocketRead then exit;
{$IFEND}

  EnterCriticalSection(UserDBSection);
  try
    if Config.pDBSocketRecvBuff <> nil then
      FreeMem(Config.pDBSocketRecvBuff);
    Config.pDBSocketRecvBuff := nil;
    Config.nDBSocketRecvLeng := 0;
  finally
    LeaveCriticalSection(UserDBSection);
  end;
  Config.boDBSocketWorking := True;
  nCheckCode := 0;
{$IF DBSOCKETMODE = TIMERENGINE}
  while True do
  begin
    nSendLen := FrmMain.DBSocket.Socket.SendBuf(SendBuff^, nLeng);
    if nSendLen <> -1 then
      Break;
    Inc(nCheckCode);
    if nCheckCode >= 10 then
      Break;
//    Sleep(500);
  end;
{$ELSE}
  EnterCriticalSection(Config.DBSocketSection);
  Try
    s := Config.DBSocket;
    while True do begin
      Sleep(10);
      ThreadInfo.dwRunTick := GetTickCount();
      ThreadInfo.boActived := True;
      ThreadInfo.nRunFlag := 128;
      ThreadInfo.nRunFlag := 129;
      timeout.tv_sec := 0;
      timeout.tv_usec := 20;
      writefds.fd_count := 1;
      writefds.fd_array[0] := s;
      nRet := select(0, nil, @writefds, nil, @timeout);
      if nRet = SOCKET_ERROR then begin
        nRet := WSAGetLastError();
        Config.nDBSocketWSAErrCode := nRet - WSABASEERR;
        Inc(Config.nDBSocketErrorCount);
        if nRet = WSAEWOULDBLOCK then begin
          Continue;
        end;
        if Config.DBSocket = INVALID_SOCKET then
          break;
        Config.DBSocket := INVALID_SOCKET;
        Sleep(100);
        Config.boDBSocketConnected := False;
        break;
      end;
      if nRet <= 0 then begin
        Continue;
      end;
      nRet := send(s, SendBuff^, nLeng, 0);
      if nRet = SOCKET_ERROR then begin
        Inc(Config.nDBSocketErrorCount);
        Config.nDBSocketWSAErrCode := WSAGetLastError - WSABASEERR;
        Continue;
      end;
      Inc(Config.nDBSocketSendLeng, nRet);
      break;
    end;
  Finally
    LeaveCriticalSection(Config.DBSocketSection);
  End;
{$IFEND}

end;

function GetQueryID(Config: pTConfig): Integer;
begin
  Inc(Config.nDBQueryID);
  if Config.nDBQueryID > High(Smallint) - 1 then
    Config.nDBQueryID := 1;
  Result := Config.nDBQueryID;
end;

end.


