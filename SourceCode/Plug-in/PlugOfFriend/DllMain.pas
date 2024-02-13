unit DllMain;

interface
uses
  Classes, EngineAPI, EngineType, SysUtils, MudUtil;

procedure LoadPlug();
procedure UnLoadPlug(boExit: Boolean);

procedure APIUserLoginEnd(PlayObject: TObject); stdcall;
procedure APIMakeGhost(PlayObject: TObject); stdcall;
procedure SetFriend(AddBaseObject, NameBaseObject: TObject; nCheck: Integer); stdcall;
function PlayObjectOperateMessage(BaseObject: TObject; wIdent: Word; wParam: Word;
  nParam1: Integer; nParam2: Integer; nParam3: Integer; MsgObject: TObject;
  dwDeliveryTime: LongWord; pszMsg: PChar; var boReturn: Boolean): Boolean; stdcall;

procedure AddFriend(PlayObject: TObject; AddName: string);
procedure DelFriend(PlayObject: TObject; AddName: string);
function InFriendList(PlayObject: TObject; AddName: string): Boolean;

var
  OLDUSERLOGINEND: _TOBJECTACTION;
  OLDMAKEGHOST: _TOBJECTACTION;
  OLDPLAYOBJECTOPERATEMESSAGE: _TOBJECTOPERATEMESSAGE;
implementation
uses
  Grobal2;

var

  DelIndexList: TQuickIndexList;
  DelFileName: string;

procedure LoadPlug();
begin
  DelFileName := GetUserDataDir()^ + 'UnFriend.txt';
  DelIndexList := TQuickIndexList.Create;
  DelIndexList.LoadFromFile(DelFileName);

  OLDUSERLOGINEND := TPlayObject_GetHookUserLoginEnd();
  TPlayObject_SetHookUserLoginEnd(APIUserLoginEnd);

  OLDMAKEGHOST := TPlayObject_GetHookPlayObjectMakeGhost();
  TPlayObject_SetHookPlayObjectMakeGhost(APIMakeGhost);

  OLDPLAYOBJECTOPERATEMESSAGE := TPlayObject_GetHookPlayOperateMessage();
  TPlayObject_SetHookPlayOperateMessage(PlayObjectOperateMessage);
end;

procedure UnLoadPlug(boExit: Boolean);
begin
  if not boExit then begin
    if not API_UnModule(MODULE_USERLOGINEND, @APIUserLoginEnd, @OLDUSERLOGINEND) then
      TPlayObject_SetHookUserLoginEnd(OLDUSERLOGINEND);

    if not API_UnModule(MODULE_PLAYOPERATEMESSAGE, @PlayObjectOperateMessage, @OLDPLAYOBJECTOPERATEMESSAGE)
    then
      TPlayObject_SetHookPlayOperateMessage(OLDPLAYOBJECTOPERATEMESSAGE);

    if not API_UnModule(MODULE_USERLOGINEND, @APIMakeGhost, @OLDMAKEGHOST) then
      TPlayObject_SetHookPlayObjectMakeGhost(OLDMAKEGHOST);
  end;

  DelIndexList.SaveToFile(DelFileName);
  DelIndexList.Free;
end;

procedure APIUserLoginEnd(PlayObject: TObject); stdcall;
var
  FriendList: TAPIStringList;
  i, UserIndex, II: integer;
  PObject: TPlayObject;
  sSendMsg, MyName: string;
  FreeFriendList: TStringList;
  FreeFriendIndex: integer;
  boDel: Boolean;
begin
  //֪ͨ������������
  sSendMsg := '';
  MyName := TBaseObject_sCharName(PlayObject)^;
  FriendList := TPlayObject_FriendList(PlayObject);
  FreeFriendList := Nil;
  FreeFriendIndex := DelIndexList.GetIndex(MyName);
  if FreeFriendIndex > -1 then
    FreeFriendList := TStringList(DelIndexList.Objects[FreeFriendIndex]);

  for I := TStringList_Count(FriendList) - 1 downto 0 do begin
    UserIndex := Integer(TStringList_Objects(FriendList, I));
    if FreeFriendList <> nil then begin
      boDel := False;
      for II := 0 to FreeFriendList.Count - 1 do begin
        if UserIndex = Integer(FreeFriendList.Objects[ii]) then begin
          TBaseObject_SysHintMsg(PlayObject,
            PChar('[<CO$FFFF>' + FreeFriendList[ii] + '<CE>] �Ѿ�����Ӻ����б���ɾ��.'), c_Red);
          boDel := True;
          FreeFriendList.Delete(II);
          break;
        end;
      end;
      if boDel then begin
        TStringList_Delete(FriendList, I);
        Continue;
      end;
    end;
    PObject := TPlayObject_GetLoginPlay(UserIndex);  //ȡ�����Ƿ�����
    if PObject <> nil then begin
      sSendMsg := TStringList_Strings(FriendList, I) + '/1/' + sSendMsg;
      TBaseObject_SendDefMsg(PObject, PObject, SM_FRIEND_LOGIN, UserIndex, 1, 0, 0, PChar(MyName));
    end else begin
      sSendMsg := TStringList_Strings(FriendList, I) + '/0/' + sSendMsg;
    end;
  end;
  if sSendMsg <> '' then
    TBaseObject_SendDefMsg(PlayObject, PlayObject, SM_FRIEND_LOGIN, 0, 1, 0, 1, PChar(sSendMsg));

  if FreeFriendList <> nil then begin
    FreeFriendList.Free;
    DelIndexList.Delete(FreeFriendIndex);
    DelIndexList.SaveToFile(DelFileName);
  end;

  //������һ���������
  if Assigned(OLDUSERLOGINEND) then
    OLDUSERLOGINEND(PlayObject);
end;

procedure APIMakeGhost(PlayObject: TObject); stdcall;
var
  FriendList: TAPIStringList;
  i, UserIndex: integer;
  PObject: TPlayObject;
  MyName: string;
begin

  //֪ͨ������������
  MyName := TBaseObject_sCharName(PlayObject)^;
  FriendList := TPlayObject_FriendList(PlayObject);
  for I := TStringList_Count(FriendList) - 1 downto 0 do begin
    UserIndex := Integer(TStringList_Objects(FriendList, I));
    PObject := TPlayObject_GetLoginPlay(UserIndex);  //ȡ�����Ƿ�����
    if PObject <> nil then begin
      TBaseObject_SendDefMsg(PObject, PObject, SM_FRIEND_LOGIN, UserIndex, 0, 0, 0,
        PChar(MyName));
    end;
  end;
  
  //������һ���������
  if Assigned(OLDMAKEGHOST) then
    OLDMAKEGHOST(PlayObject);
end;

function PlayObjectOperateMessage(BaseObject: TObject; wIdent: Word; wParam: Word;
  nParam1: Integer; nParam2: Integer; nParam3: Integer; MsgObject: TObject;
  dwDeliveryTime: LongWord; pszMsg: PChar; var boReturn: Boolean): Boolean; stdcall;
begin
  Result := True; //�÷���ֵ��ʱ������
  boReturn := False; //���� False ���򽫲���ƥ��
  case wIdent of
    CM_FRIEND_CHENGE: begin
        case wParam of
          0: AddFriend(BaseObject, DecodeString(pszMsg));
          1: DelFriend(BaseObject, DecodeString(pszMsg));  
        end;
      end;
  else begin
      if Assigned(OldPlayObjectOperateMessage) then begin //���ݸ���һ�������������
        Result := OldPlayObjectOperateMessage(BaseObject, wIdent, wParam, nParam1,
          nParam2, nParam3, BaseObject, dwDeliveryTime, pszMsg, boReturn);
      end else boReturn := True; //���� True �����������ƥ��
    end;
  end;
end;

procedure SetFriend(AddBaseObject, NameBaseObject: TObject; nCheck: Integer); stdcall;
var
  AddFriendList, NameFriendList: TAPIStringList;
  AddName: string;
  UserName: string;
  AddIndex,UserIndex: Integer;
begin
  case nCheck of
    0: TBaseObject_SysHintMsg(AddBaseObject,
      PChar('[<CO$FFFF>' + TBaseObject_sCharName(NameBaseObject)^ + '<CE>] �ܾ�����ĺ�������.'), c_Red);
    1: begin
      AddName := TBaseObject_sCharName(AddBaseObject)^;
      UserName := TBaseObject_sCharName(NameBaseObject)^;
      if InFriendList(AddBaseObject, UserName) then begin
        TBaseObject_SysHintMsg(AddBaseObject, PChar('[' + UserName + '] �Ѿ���������ĺ����б���.'), c_Red);
        TBaseObject_SysHintMsg(NameBaseObject,
          PChar('���Ѿ������� [<CO$FFFF>' + AddName + '<CE>] �ĺ����б���.'), c_Red);
        exit;
      end;
      if InFriendList(NameBaseObject, AddName) then begin
        TBaseObject_SysHintMsg(NameBaseObject, PChar('[' + AddName + '] �Ѿ���������ĺ����б���.'), c_Red);
        TBaseObject_SysHintMsg(AddBaseObject,
          PChar('���Ѿ������� [<CO$FFFF>' + UserName + '<CE>] �ĺ����б���.'), c_Red);
        exit;
      end;
      AddFriendList := TPlayObject_FriendList(AddBaseObject);
      if TStringList_Count(AddFriendList) >= MAXFRIENDS then begin
        TBaseObject_SysHintMsg(AddBaseObject, '��ĺ����б�����.', c_Red);
        TBaseObject_SysHintMsg(NameBaseObject, PChar('[<CO$FFFF>' + AddName + '<CE>] �ĺ����б�����.'), c_Red);
        exit;
      end;
      NameFriendList := TPlayObject_FriendList(NameBaseObject);
      if TStringList_Count(NameFriendList) >= MAXFRIENDS then begin
        TBaseObject_SysHintMsg(NameBaseObject, '��ĺ����б�����.', c_Red);
        TBaseObject_SysHintMsg(AddBaseObject, PChar('[<CO$FFFF>' + UserName + '<CE>] �ĺ����б�����.'), c_Red);
        exit;
      end;
      AddIndex := TPlayObject_GetDBIndex(AddBaseObject);
      UserIndex := TPlayObject_GetDBIndex(NameBaseObject);
      TStringList_AddObject(AddFriendList, PChar(UserName), TObject(UserIndex));
      TStringList_AddObject(NameFriendList, PChar(AddName), TObject(AddIndex));
      TBaseObject_SendDefMsg(AddBaseObject, AddBaseObject, SM_FRIEND_LOGIN, UserIndex, 1, 0, 2, PChar(UserName));
      TBaseObject_SendDefMsg(NameBaseObject, NameBaseObject, SM_FRIEND_LOGIN, AddIndex, 1, 0, 2, PChar(AddName));
      TBaseObject_SysHintMsg(AddBaseObject, PChar('[<CO$FFFF>' + UserName + '<CE>] �Ѽ�Ϊ����.'), c_Red);
      TBaseObject_SysHintMsg(NameBaseObject, PChar('[<CO$FFFF>' + AddName + '<CE>] �Ѽ�Ϊ����.'), c_Red);
    end;
  end;
end;

procedure DelFriend(PlayObject: TObject; AddName: string);
var
  FriendList, DelFriendList: TAPIStringList;
  i, DelIndex, II, MyIndex: integer;
  DelPlayObject: TPlayObject;
  MyName: string;
begin
  if TBaseObject_boGhost(PlayObject)^ then exit;
  FriendList := TPlayObject_FriendList(PlayObject);
  MyName := TBaseObject_sCharName(PlayObject)^;
  for I := 0 to TStringList_Count(FriendList) - 1 do begin
    if CompareText(TStringList_Strings(FriendList, I), AddName) = 0 then begin
      DelIndex := Integer(TStringList_Objects(FriendList, I));
      DelPlayObject := TPlayObject_GetLoginPlay(DelIndex);
      MyIndex := TPlayObject_GetDBIndex(PlayObject);
      if (DelPlayObject <> nil) and (not TBaseObject_boGhost(PlayObject)^) then begin
        DelFriendList := TPlayObject_FriendList(DelPlayObject);
        for II := 0 to TStringList_Count(DelFriendList) - 1 do begin
          if MyIndex = Integer(TStringList_Objects(DelFriendList, II)) then begin
            TBaseObject_SendDefMsg(DelPlayObject, DelPlayObject, SM_FRIEND_LOGIN, MyIndex, 1, 0, 3, PChar(MyName));
            TStringList_Delete(DelFriendList, II);
            break;
          end;
        end;
      end else begin
        DelIndexList.AddRecord(AddName, MyName, MyIndex);
        DelIndexList.SaveToFile(DelFileName);
      end;

      TStringList_Delete(FriendList, I);
      break;
    end;
  end;
end;

procedure AddFriend(PlayObject: TObject; AddName: string);
var
  FriendList: TAPIStringList;
  AddObject: TPlayObject;
  UserName: string;
begin
  if TBaseObject_boGhost(PlayObject)^ then exit;
  UserName := TBaseObject_sCharName(PlayObject)^;
  if AddName = UserName then begin
    TPlayObject_SendDefMessage(PlayObject, SM_MENU_OK, 0, 0, 0, 0, '��������Լ���Ϊ����');
    exit;
  end;
  if InFriendList(PlayObject, AddName) then begin
    TPlayObject_SendDefMessage(PlayObject, SM_MENU_OK, 0, 0, 0, 0,
      PChar('[' + AddName + '] �Ѿ���������ĺ����б���.'));
    exit;
  end;
  FriendList := TPlayObject_FriendList(PlayObject);
  if TStringList_Count(FriendList) >= MAXFRIENDS then begin
    TPlayObject_SendDefMessage(PlayObject, SM_MENU_OK, 0, 0, 0, 0,
      '��ĺ����б������Ѵﵽ�������.');
    exit;
  end;
  AddObject := TUserEngine_GetPlayObject(PChar(AddName), False);
  if (AddObject <> nil) and (not TBaseObject_boGhost(AddObject)^) then begin
    FriendList := TPlayObject_FriendList(AddObject);
    if TStringList_Count(FriendList) >= MAXFRIENDS then begin
      TPlayObject_SendDefMessage(PlayObject, SM_MENU_OK, 0, 0, 0, 0,
        PChar('[' + AddName + '] �ĺ����б������Ѵﵽ�������.'));
      exit;
    end;
    if TPlayObject_AddCheckMsg(AddObject,
          PChar('[' + UserName + '] ϣ�������Ϊ����. ���Ƿ�ͬ��?'),
          tmc_Friend,
          Pointer(TPlayObject_GetDBIndex(PlayObject)),
          62) <> nil then
      TBaseObject_SysHintMsg(PlayObject, '�ȴ��Է���֤����.', c_Red)
    else
      TBaseObject_SysHintMsg(PlayObject, '�벻Ҫ�ظ��ύ.', c_Red);
  end else
    TPlayObject_SendDefMessage(PlayObject, SM_MENU_OK, 0, 0, 0, 0,
      PChar('[' + AddName + '] û������.'));
end;

function InFriendList(PlayObject: TObject;  AddName: string): Boolean;
var
  FriendList: TAPIStringList;
  i: integer;
begin
  Result := False;
  FriendList := TPlayObject_FriendList(PlayObject);
  for I := 0 to TStringList_Count(FriendList) - 1 do begin
    if CompareText(TStringList_Strings(FriendList, I), AddName) = 0 then begin
      Result := True;
      break;
    end;
  end;
end;

end.
