unit LogShare;

interface
uses
  Windows, Messages, SysUtils;

const
  GS_QUIT = 2000;
  SG_FORMHANDLE = 1000; //������HANLD
  SG_STARTNOW = 1001; //��������������...
  SG_STARTOK = 1002; //�������...

  tLogServer = 2;

  ADODBString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';
  ADODBSQL =
    'INSERT INTO Log (����,��ͼ,X����,Y����,��������,��Ʒ����,��ƷID,��Ʒ����,���׶���,��ע1,��ע2,��ע3) values (%s,'#39'%s'#39',%s,%s,'#39'%s'#39','#39'%s'#39',%s,%s,'#39'%s'#39','#39'%s'#39','#39'%s'#39','#39'%s'#39')';

type
  TLogClass = record
    sLogName: string[10];
    nLogIdx: Byte;
  end;
var
  sBaseDir: string = '.\BaseDir\';
  sServerName: string = 'Gameofmir';
  sCaption: string = 'LogDataServer';
  g_dwGameCenterHandle: THandle;
  nServerPort: Integer = 10000;
  g_boTeledata: Boolean = False;

  m_LogList: array[0..12] of TLogClass = (
    (sLogName: '��������'; nLogIdx: 0),
    (sLogName: '��Ҹı�'; nLogIdx: 1),
    (sLogName: '���ı�'; nLogIdx: 2),
    (sLogName: '���ı�'; nLogIdx: 3),
    (sLogName: 'Ԫ���ı�'; nLogIdx: 4),
    (sLogName: '���ָı�'; nLogIdx: 5),
    (sLogName: '�����ı�'; nLogIdx: 6),
    (sLogName: '������Ʒ'; nLogIdx: 7),
    (sLogName: '������Ʒ'; nLogIdx: 8),
    (sLogName: '�ֿ��ȡ'; nLogIdx: 9),
    (sLogName: 'ǿ���ı�'; nLogIdx: 10),
    (sLogName: '������Ʒ'; nLogIdx: 11),
    (sLogName: '�����ı�'; nLogIdx: 12)
  );

procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
implementation

procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(Word(tLogServer), wIdent);
  SendData.cbData := Length(AnsiString(sSendMsg)) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  Move(PAnsiChar(AnsiString(sSendMsg))^, PAnsiChar(AnsiString(SendData.lpData))^, Length(AnsiString(sSendMsg)) + 1);
  SendMessage(g_dwGameCenterHandle, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

end.

