unit GameCommand;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, Spin, Grobal2;

type
  TfrmGameCmd = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    StringGridGameCmd: TStringGrid;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditUserCmdName: TEdit;
    EditUserCmdPerMission: TSpinEdit;
    Label6: TLabel;
    EditUserCmdOK: TButton;
    LabelUserCmdFunc: TLabel;
    LabelUserCmdParam: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditUserCmdSave: TButton;
    StringGridGameMasterCmd: TStringGrid;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    LabelGameMasterCmdFunc: TLabel;
    LabelGameMasterCmdParam: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditGameMasterCmdName: TEdit;
    EditGameMasterCmdPerMission: TSpinEdit;
    EditGameMasterCmdOK: TButton;
    EditGameMasterCmdSave: TButton;
    StringGridGameDebugCmd: TStringGrid;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    LabelGameDebugCmdFunc: TLabel;
    LabelGameDebugCmdParam: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditGameDebugCmdName: TEdit;
    EditGameDebugCmdPerMission: TSpinEdit;
    EditGameDebugCmdOK: TButton;
    EditGameDebugCmdSave: TButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGridGameCmdClick(Sender: TObject);
    procedure EditUserCmdNameChange(Sender: TObject);
    procedure EditUserCmdPerMissionChange(Sender: TObject);
    procedure EditUserCmdOKClick(Sender: TObject);
    procedure EditUserCmdSaveClick(Sender: TObject);
    procedure StringGridGameMasterCmdClick(Sender: TObject);
    procedure EditGameMasterCmdNameChange(Sender: TObject);
    procedure EditGameMasterCmdPerMissionChange(Sender: TObject);
    procedure EditGameMasterCmdOKClick(Sender: TObject);
    procedure StringGridGameDebugCmdClick(Sender: TObject);
    procedure EditGameDebugCmdNameChange(Sender: TObject);
    procedure EditGameDebugCmdPerMissionChange(Sender: TObject);
    procedure EditGameDebugCmdOKClick(Sender: TObject);
    procedure EditGameMasterCmdSaveClick(Sender: TObject);
    procedure EditGameDebugCmdSaveClick(Sender: TObject);
  private
    nRefGameUserIndex: Integer;
    nRefGameMasterIndex: Integer;
    nRefGameDebugIndex: Integer;
    procedure RefUserCommand();
    procedure RefGameUserCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);

    procedure RefGameMasterCommand();
    procedure RefGameMasterCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);

    procedure RefDebugCommand();
    procedure RefGameDebugCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmGameCmd: TfrmGameCmd;

implementation

uses M2Share;

{$R *.dfm}

procedure TfrmGameCmd.FormCreate(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
  StringGridGameCmd.RowCount := 2;
  StringGridGameCmd.Cells[0, 0] := '��Ϸ����';
  StringGridGameCmd.Cells[1, 0] := '����Ȩ��';
  StringGridGameCmd.Cells[2, 0] := '�����ʽ';
  StringGridGameCmd.Cells[3, 0] := '����˵��';

  StringGridGameMasterCmd.RowCount := 2;
  StringGridGameMasterCmd.Cells[0, 0] := '��Ϸ����';
  StringGridGameMasterCmd.Cells[1, 0] := '����Ȩ��';
  StringGridGameMasterCmd.Cells[2, 0] := '�����ʽ';
  StringGridGameMasterCmd.Cells[3, 0] := '����˵��';

  StringGridGameDebugCmd.RowCount := 2;
  StringGridGameDebugCmd.Cells[0, 0] := '��Ϸ����';
  StringGridGameDebugCmd.Cells[1, 0] := '����Ȩ��';
  StringGridGameDebugCmd.Cells[2, 0] := '�����ʽ';
  StringGridGameDebugCmd.Cells[3, 0] := '����˵��';

end;

procedure TfrmGameCmd.Open;
begin
  RefUserCommand();
  RefGameMasterCommand();
  RefDebugCommand();
  ShowModal;
end;

procedure TfrmGameCmd.RefGameUserCmd(GameCmd: pTGameCmd; sCmdParam, sDesc:
  string);
begin
  Inc(nRefGameUserIndex);
  if StringGridGameCmd.RowCount - 1 < nRefGameUserIndex then begin
    StringGridGameCmd.RowCount := nRefGameUserIndex + 1;
  end;

  StringGridGameCmd.Cells[0, nRefGameUserIndex] := GameCmd.sCmd;
  StringGridGameCmd.Cells[1, nRefGameUserIndex] :=
    IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameCmd.Cells[2, nRefGameUserIndex] := sCmdParam;
  StringGridGameCmd.Cells[3, nRefGameUserIndex] := sDesc;
  StringGridGameCmd.Objects[0, nRefGameUserIndex] := TObject(GameCmd);
end;

procedure TfrmGameCmd.RefUserCommand;
begin
  EditUserCmdOK.Enabled := False;
  nRefGameUserIndex := 0;

  RefGameUserCmd(@g_GameCommand.Data,
    '@' + g_GameCommand.Data.sCmd,
    '�鿴��ǰ����������ʱ��');
  RefGameUserCmd(@g_GameCommand.PRVMSG,
    '@' + g_GameCommand.PRVMSG.sCmd,
    '��ָֹ�����﷢��˽����Ϣ');
  RefGameUserCmd(@g_GameCommand.ALLOWMSG,
    '@' + g_GameCommand.ALLOWMSG.sCmd,
    '��ֹ�������Լ���˽����Ϣ');
  RefGameUserCmd(@g_GameCommand.LETSHOUT,
    '@' + g_GameCommand.LETSHOUT.sCmd,
    '��ֹ�������������Ϣ');
  RefGameUserCmd(@g_GameCommand.LETTRADE,
    '@' + g_GameCommand.LETTRADE.sCmd,
    '��ֹ���׽�����Ʒ');
  RefGameUserCmd(@g_GameCommand.LETGUILD,
    '@' + g_GameCommand.LETGUILD.sCmd,
    '��������л�');
  RefGameUserCmd(@g_GameCommand.ENDGUILD,
    '@' + g_GameCommand.ENDGUILD.sCmd,
    '�˳���ǰ��������л�');
  RefGameUserCmd(@g_GameCommand.BANGUILDCHAT,
    '@' + g_GameCommand.BANGUILDCHAT.sCmd,
    '��ֹ�����л�������Ϣ');
  RefGameUserCmd(@g_GameCommand.AUTHALLY,
    '@' + g_GameCommand.AUTHALLY.sCmd,
    '���л��������');
  RefGameUserCmd(@g_GameCommand.AUTH,
    '@' + g_GameCommand.AUTH.sCmd,
    '��ʼ�����л�����');
  RefGameUserCmd(@g_GameCommand.AUTHCANCEL,
    '@' + g_GameCommand.AUTHCANCEL.sCmd,
    'ȡ���л����˹�ϵ');
  RefGameUserCmd(@g_GameCommand.USERMOVE,
    '@' + g_GameCommand.USERMOVE.sCmd,
    '�ƶ���ͼָ������(��Ҫ������װ��)');
  RefGameUserCmd(@g_GameCommand.SEARCHING,
    '@' + g_GameCommand.SEARCHING.sCmd,
    '̽����������λ��(��Ҫ��̽��װ��)');
  RefGameUserCmd(@g_GameCommand.ALLOWGROUPCALL,
    '@' + g_GameCommand.ALLOWGROUPCALL.sCmd,
    '������غ�һ');
  RefGameUserCmd(@g_GameCommand.GROUPRECALLL,
    '@' + g_GameCommand.GROUPRECALLL.sCmd,
    '�������Ա���͵����(��Ҫ������ȫ��װ��)');
  RefGameUserCmd(@g_GameCommand.ALLOWGUILDRECALL,
    '@' + g_GameCommand.ALLOWGUILDRECALL.sCmd,
    '�����л��һ');
  RefGameUserCmd(@g_GameCommand.GUILDRECALLL,
    '@' + g_GameCommand.GUILDRECALLL.sCmd,
    '���л��Ա�������(��Ҫ���лᴫ��װ��)');
  RefGameUserCmd(@g_GameCommand.ALLOWFIREND,
    '@' + g_GameCommand.ALLOWFIREND.sCmd,
    '����/�ܾ���Ϊ����');
  {RefGameUserCmd(@g_GameCommand.UNLOCKSTORAGE,
    '@' + g_GameCommand.UNLOCKSTORAGE.sCmd,
    '�ֿ����');
  RefGameUserCmd(@g_GameCommand.UnLock,
    '@' + g_GameCommand.UnLock.sCmd,
    '������¼������');
  RefGameUserCmd(@g_GameCommand.Lock,
    '@' + g_GameCommand.Lock.sCmd,
    '�����ֿ�');
  RefGameUserCmd(@g_GameCommand.SETPASSWORD,
    '@' + g_GameCommand.SETPASSWORD.sCmd,
    '���òֿ�����');
  RefGameUserCmd(@g_GameCommand.CHGPASSWORD,
    '@' + g_GameCommand.CHGPASSWORD.sCmd,
    '�޸Ĳֿ�����');
  RefGameUserCmd(@g_GameCommand.UNPASSWORD,
    '@' + g_GameCommand.UNPASSWORD.sCmd,
    '�������(�ȿ������������)');    }
  RefGameUserCmd(@g_GameCommand.DEAR,
    '@' + g_GameCommand.DEAR.sCmd,
    '��ѯ����λ��');
  RefGameUserCmd(@g_GameCommand.ALLOWDEARRCALL,
    '@' + g_GameCommand.ALLOWDEARRCALL.sCmd,
    '������޴���');
  RefGameUserCmd(@g_GameCommand.DEARRECALL,
    '@' + g_GameCommand.DEARRECALL.sCmd,
    '���޽��Է����͵����');
  RefGameUserCmd(@g_GameCommand.MASTER,
    '@' + g_GameCommand.MASTER.sCmd,
    '��ѯʦͽλ��');
  RefGameUserCmd(@g_GameCommand.ALLOWMASTERRECALL,
    '@' + g_GameCommand.ALLOWMASTERRECALL.sCmd,
    '����ʦͽ����');
  RefGameUserCmd(@g_GameCommand.MASTERECALL,
    '@' + g_GameCommand.MASTERECALL.sCmd,
    'ʦ����ͽ���ٻ������');
  RefGameUserCmd(@g_GameCommand.TAKEONHORSE,
    '@' + g_GameCommand.TAKEONHORSE.sCmd,
    '�����ƺ�������');
  RefGameUserCmd(@g_GameCommand.TAKEOFHORSE,
    '@' + g_GameCommand.TAKEOFHORSE.sCmd,
    '����������');
  {RefGameUserCmd(@g_GameCommand.LOCKLOGON,
    '@' + g_GameCommand.LOCKLOGON.sCmd,
    '����/�رյ�¼��');   }

  RefGameUserCmd(@g_GameCommand.AllSysMsg,
    '@' + g_GameCommand.AllSysMsg.sCmd,
    'ǧ�ﴫ��');
  RefGameUserCmd(@g_GameCommand.MEMBERFUNCTION,
    '@' + g_GameCommand.MEMBERFUNCTION.sCmd,
    '����QManage�е�@Member');
  RefGameUserCmd(@g_GameCommand.MEMBERFUNCTIONEX,
    '@' + g_GameCommand.MEMBERFUNCTIONEX.sCmd,
    '����QFunction�е�@Member');
end;

procedure TfrmGameCmd.StringGridGameCmdClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
begin
  nIndex := StringGridGameCmd.Row;
  GameCmd := pTGameCmd(StringGridGameCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    EditUserCmdName.Text := GameCmd.sCmd;
    EditUserCmdPerMission.Value := GameCmd.nPermissionMin;
    LabelUserCmdParam.Caption := StringGridGameCmd.Cells[2, nIndex];
    LabelUserCmdFunc.Caption := StringGridGameCmd.Cells[3, nIndex];
  end;
  EditUserCmdOK.Enabled := False;
end;

procedure TfrmGameCmd.EditUserCmdNameChange(Sender: TObject);
begin
  EditUserCmdOK.Enabled := True;
  EditUserCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditUserCmdPerMissionChange(Sender: TObject);
begin
  EditUserCmdOK.Enabled := True;
  EditUserCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditUserCmdOKClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
  sCmd: string;
  nPermission: Integer;
begin
  sCmd := Trim(EditUserCmdName.Text);
  nPermission := EditUserCmdPerMission.Value;
  if sCmd = '' then begin
    Application.MessageBox('�������Ʋ���Ϊ��.', '��ʾ��Ϣ',
      MB_OK +
      MB_ICONERROR);
    EditUserCmdName.SetFocus;
    exit;
  end;

  nIndex := StringGridGameCmd.Row;
  GameCmd := pTGameCmd(StringGridGameCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    GameCmd.sCmd := sCmd;
    GameCmd.nPermissionMin := nPermission;
  end;
  RefUserCommand();
end;

procedure TfrmGameCmd.EditUserCmdSaveClick(Sender: TObject);
begin
  EditUserCmdSave.Enabled := False;
  CommandConf.WriteString('Command', 'Data', g_GameCommand.Data.sCmd);
  CommandConf.WriteString('Command', 'PRVMSG', g_GameCommand.PRVMSG.sCmd);
  CommandConf.WriteString('Command', 'ALLOWMSG', g_GameCommand.ALLOWMSG.sCmd);
  CommandConf.WriteString('Command', 'LETSHOUT', g_GameCommand.LETSHOUT.sCmd);
  CommandConf.WriteString('Command', 'LETTRADE', g_GameCommand.LETTRADE.sCmd);
  CommandConf.WriteString('Command', 'LETGUILD', g_GameCommand.LETGUILD.sCmd);
  CommandConf.WriteString('Command', 'ENDGUILD', g_GameCommand.ENDGUILD.sCmd);
  CommandConf.WriteString('Command', 'BANGUILDCHAT', g_GameCommand.BANGUILDCHAT.sCmd);
  CommandConf.WriteString('Command', 'AUTHALLY', g_GameCommand.AUTHALLY.sCmd);
  CommandConf.WriteString('Command', 'AUTH', g_GameCommand.AUTH.sCmd);
  CommandConf.WriteString('Command', 'AUTHCANCEL', g_GameCommand.AUTHCANCEL.sCmd);
  CommandConf.WriteString('Command', 'USERMOVE', g_GameCommand.USERMOVE.sCmd);
  CommandConf.WriteString('Command', 'SEARCHING', g_GameCommand.SEARCHING.sCmd);
  CommandConf.WriteString('Command', 'ALLOWGROUPCALL', g_GameCommand.ALLOWGROUPCALL.sCmd);
  CommandConf.WriteString('Command', 'GROUPRECALLL', g_GameCommand.GROUPRECALLL.sCmd);
  CommandConf.WriteString('Command', 'ALLOWGUILDRECALL', g_GameCommand.ALLOWGUILDRECALL.sCmd);
  CommandConf.WriteString('Command', 'GUILDRECALLL', g_GameCommand.GUILDRECALLL.sCmd);
  CommandConf.WriteString('Command', 'UNLOCKSTORAGE', g_GameCommand.UNLOCKSTORAGE.sCmd);
  CommandConf.WriteString('Command', 'UnLock', g_GameCommand.UnLock.sCmd);
  CommandConf.WriteString('Command', 'Lock', g_GameCommand.Lock.sCmd);
  CommandConf.WriteString('Command', 'SETPASSWORD', g_GameCommand.SETPASSWORD.sCmd);
  CommandConf.WriteString('Command', 'CHGPASSWORD', g_GameCommand.CHGPASSWORD.sCmd);
  CommandConf.WriteString('Command', 'UNPASSWORD', g_GameCommand.UNPASSWORD.sCmd);
  CommandConf.WriteString('Command', 'DEAR', g_GameCommand.DEAR.sCmd);
  CommandConf.WriteString('Command', 'ALLOWDEARRCALL', g_GameCommand.ALLOWDEARRCALL.sCmd);
  CommandConf.WriteString('Command', 'DEARRECALL', g_GameCommand.DEARRECALL.sCmd);
  CommandConf.WriteString('Command', 'MASTER', g_GameCommand.MASTER.sCmd);
  CommandConf.WriteString('Command', 'ALLOWMASTERRECALL', g_GameCommand.ALLOWMASTERRECALL.sCmd);
  CommandConf.WriteString('Command', 'MASTERECALL', g_GameCommand.MASTERECALL.sCmd);
  CommandConf.WriteString('Command', 'ALLOWFIREND', g_GameCommand.ALLOWFIREND.sCmd);
  CommandConf.WriteString('Command', 'REST', g_GameCommand.REST.sCmd);
  CommandConf.WriteString('Command', 'TAKEONHORSE', g_GameCommand.TAKEONHORSE.sCmd);
  CommandConf.WriteString('Command', 'TAKEOFHORSE', g_GameCommand.TAKEOFHORSE.sCmd);
  CommandConf.WriteString('Command', 'LOCKLOGON', g_GameCommand.LOCKLOGON.sCmd);
  CommandConf.WriteString('Command', 'AllSysMsg', g_GameCommand.AllSysMsg.sCmd);
  CommandConf.WriteString('Command', 'MEMBERFUNCTION', g_GameCommand.MEMBERFUNCTION.sCmd);
  CommandConf.WriteString('Command', 'MEMBERFUNCTIONEX', g_GameCommand.MEMBERFUNCTIONEX.sCmd);

end;

procedure TfrmGameCmd.RefGameMasterCmd(GameCmd: pTGameCmd; sCmdParam, sDesc:
  string);
begin
  Inc(nRefGameMasterIndex);
  if StringGridGameMasterCmd.RowCount - 1 < nRefGameMasterIndex then begin
    StringGridGameMasterCmd.RowCount := nRefGameMasterIndex + 1;
  end;

  StringGridGameMasterCmd.Cells[0, nRefGameMasterIndex] := GameCmd.sCmd;
  StringGridGameMasterCmd.Cells[1, nRefGameMasterIndex] :=
    IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameMasterCmd.Cells[2, nRefGameMasterIndex] := sCmdParam;
  StringGridGameMasterCmd.Cells[3, nRefGameMasterIndex] := sDesc;
  StringGridGameMasterCmd.Objects[0, nRefGameMasterIndex] := TObject(GameCmd);
end;

procedure TfrmGameCmd.RefGameMasterCommand;
//var
//  GameCmd: pTGameCmd;
//  sDesc: string;
//  sCmdParam: string;
begin
  EditGameMasterCmdOK.Enabled := False;
  nRefGameMasterIndex := 0;

  {RefGameMasterCmd(@g_GameCommand.CLRPASSWORD,
    '@' + g_GameCommand.CLRPASSWORD.sCmd + ' ��������',
    '�������ֿ�/��¼����(֧��Ȩ�޷���)'); }

  {RefGameMasterCmd(@g_GameCommand.WHO,
    '@' + g_GameCommand.WHO.sCmd,
    '�鿴��ǰ��������������(֧��Ȩ�޷���)');  }

  {RefGameMasterCmd(@g_GameCommand.TOTAL,
    '@' + g_GameCommand.TOTAL.sCmd,
    '�鿴���з�������������(֧��Ȩ�޷���)');    }

  RefGameMasterCmd(@g_GameCommand.GAMEMASTER,
    '@' + g_GameCommand.GAMEMASTER.sCmd,
    '����/�˳�����Աģʽ(����ģʽ�󲻻��ܵ��κν�ɫ����)(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.OBSERVER,
    '@' + g_GameCommand.OBSERVER.sCmd,
    '����/�˳�����ģʽ(����ģʽ����˿������Լ�)(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.SUEPRMAN,
    '@' + g_GameCommand.SUEPRMAN.sCmd,
    '����/�˳��޵�ģʽ(����ģʽ�����ﲻ������)(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.MAKE,
    '@' + g_GameCommand.MAKE.sCmd + ' ��Ʒ���� ����',
    '����ָ����Ʒ(֧��Ȩ�޷��䣬С�����Ȩ����������ֹ�����б�����)');

  RefGameMasterCmd(@g_GameCommand.SMAKE,
    '@' + g_GameCommand.SMAKE.sCmd + ' �������ʹ��˵��',
    '�����Լ����ϵ���Ʒ����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.Move,
    '@' + g_GameCommand.Move.sCmd + ' ��ͼ��',
    '�ƶ���ָ����ͼ(֧��Ȩ�޷��䣬С�����Ȩ�����ܽ�ֹ���͵�ͼ�б�����)');

  RefGameMasterCmd(@g_GameCommand.POSITIONMOVE,
    '@' + g_GameCommand.POSITIONMOVE.sCmd + ' ��ͼ�� X Y',
    '�ƶ���ָ����ͼ(֧��Ȩ�޷��䣬С�����Ȩ�����ܽ�ֹ���͵�ͼ�б�����)');

  RefGameMasterCmd(@g_GameCommand.RECALL,
    '@' + g_GameCommand.RECALL.sCmd + ' ��������',
    '��ָ�������ٻ������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.REGOTO,
    '@' + g_GameCommand.REGOTO.sCmd + ' ��������',
    '����ָ������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.TING,
    '@' + g_GameCommand.TING.sCmd + ' ��������',
    '��ָ�������������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.SUPERTING,
    '@' + g_GameCommand.SUPERTING.sCmd + ' �������� ��Χ��С',
    '��ָ���������ָ����Χ�ڵ������������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.MAPMOVE,
    '@' + g_GameCommand.MAPMOVE.sCmd + ' Դ��ͼ�� Ŀ���ͼ��',
    '��������ͼ�е������ƶ���������ͼ��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.INFO,
    '@' + g_GameCommand.INFO.sCmd + ' ��������',
    '��������Ϣ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.HUMANLOCAL,
    '@' + g_GameCommand.HUMANLOCAL.sCmd + ' ��ͼ��',
    '��ѯ����IP���ڵ���(�����IP������ѯ���)(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.VIEWWHISPER,
    '@' + g_GameCommand.VIEWWHISPER.sCmd + ' ��������',
    '�鿴ָ�������˽����Ϣ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.MOBLEVEL,
    '@' + g_GameCommand.MOBLEVEL.sCmd,
    '�鿴��߽�ɫ��Ϣ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.MOBCOUNT,
    '@' + g_GameCommand.MOBCOUNT.sCmd + ' ��ͼ��',
    '�鿴��ͼ�й�������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.HUMANCOUNT,
    '@' + g_GameCommand.HUMANCOUNT.sCmd,
    '�鿴�������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.Map,
    '@' + g_GameCommand.Map.sCmd,
    '��ʾ��ǰ���ڵ�ͼ�����Ϣ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.Level,
    '@' + g_GameCommand.Level.sCmd,
    '�����Լ��ĵȼ�(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.KICK,
    '@' + g_GameCommand.KICK.sCmd + ' ��������',
    '��ָ������������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.ReAlive,
    '@' + g_GameCommand.ReAlive.sCmd + ' ��������',
    '��ָ�����︴��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.KILL,
    '@' + g_GameCommand.KILL.sCmd + '��������',
    '��ָ����������ɱ��(ɱ����ʱ����Թ���)(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.CHANGEJOB,
    '@' + g_GameCommand.CHANGEJOB.sCmd +
    ' �������� ְҵ����(Warr Wizard Taos)',
    '���������ְҵ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.FREEPENALTY,
    '@' + g_GameCommand.FREEPENALTY.sCmd + ' ��������',
    '���ָ�������PKֵ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.PKPOINT,
    '@' + g_GameCommand.PKPOINT.sCmd + ' ��������',
    '�鿴ָ�������PKֵ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.IncPkPoint,
    '@' + g_GameCommand.IncPkPoint.sCmd + ' �������� ����',
    '����ָ�������PKֵ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.CHANGEGENDER,
    '@' + g_GameCommand.CHANGEGENDER.sCmd + ' �������� �Ա�(�С�Ů)',
    '����������Ա�(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.HAIR,
    '@' + g_GameCommand.HAIR.sCmd + ' ����ֵ',
    '����ָ�������ͷ������(֧��Ȩ�޷���)');

  {RefGameMasterCmd(@g_GameCommand.BonusPoint,
    '@' + g_GameCommand.BonusPoint.sCmd + ' �������� ���Ե���',
    '������������Ե���(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DELBONUSPOINT,
    '@' + g_GameCommand.DELBONUSPOINT.sCmd + ' ��������',
    'ɾ����������Ե���(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.RESTBONUSPOINT,
    '@' + g_GameCommand.RESTBONUSPOINT.sCmd + ' ��������',
    '����������Ե������·���(֧��Ȩ�޷���)');  }

  RefGameMasterCmd(@g_GameCommand.SETPERMISSION,
    '@' + g_GameCommand.SETPERMISSION.sCmd +
    ' �������� Ȩ�޵ȼ�(0 - 10)',
    '���������Ȩ�޵ȼ������Խ���ͨ������ΪGMȨ��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.RENEWLEVEL,
    '@' + g_GameCommand.RENEWLEVEL.sCmd +
    ' �������� ����(Ϊ����鿴)',
    '�����鿴�����ת���ȼ�(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DELGOLD,
    '@' + g_GameCommand.DELGOLD.sCmd + ' �������� ����',
    'ɾ������ָ�������Ľ��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.ADDGOLD,
    '@' + g_GameCommand.ADDGOLD.sCmd + ' �������� ����',
    '��������ָ�������Ľ��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.GAMEGOLD,
    '@' + g_GameCommand.GAMEGOLD.sCmd + ' �������� ���Ʒ�(+ - =) ����',
    '���������Ԫ������(֧��Ȩ�޷���)');

  {RefGameMasterCmd(@g_GameCommand.GAMEPOINT,
    '@' + g_GameCommand.GAMEPOINT.sCmd +
    ' �������� ���Ʒ�(+ - =) ����',
    '�����������Ϸ������(֧��Ȩ�޷���)');   }

  RefGameMasterCmd(@g_GameCommand.CREDITPOINT,
    '@' + g_GameCommand.CREDITPOINT.sCmd +
    ' �������� ���Ʒ�(+ - =) ����',
    '�����������������(֧��Ȩ�޷���)');

  {RefGameMasterCmd(@g_GameCommand.REFINEWEAPON,
    '@' + g_GameCommand.REFINEWEAPON.sCmd +
    ' ������ ħ���� ���� ׼ȷ��',
    '����������������(֧��Ȩ�޷���)');  }

  RefGameMasterCmd(@g_GameCommand.ADJUESTLEVEL,
    '@' + g_GameCommand.ADJUESTLEVEL.sCmd + ' �������� �ȼ�',
    '����ָ������ĵȼ�(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.ADJUESTEXP,
    '@' + g_GameCommand.ADJUESTEXP.sCmd + ' �������� ����ֵ',
    '����ָ������ľ���ֵ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.CHANGEDEARNAME,
    '@' + g_GameCommand.CHANGEDEARNAME.sCmd +
    ' �������� ��ż����(���Ϊ �� �����)',
    '����ָ���������ż����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.CHANGEMASTERNAME,
    '@' + g_GameCommand.CHANGEMASTERNAME.sCmd +
    ' �������� ʦͽ����(���Ϊ �� �����)',
    '����ָ�������ʦͽ����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.RECALLMOB,
    '@' + g_GameCommand.RECALLMOB.sCmd + ' �������� ���� �ٻ��ȼ�',
    '�ٻ�ָ������Ϊ����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.TRAINING,
    '@' + g_GameCommand.TRAINING.sCmd +
    ' ��������  �������� �����ȼ�(0-3)',
    '��������ļ��������ȼ�(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.TRAININGSKILL,
    '@' + g_GameCommand.TRAININGSKILL.sCmd +
    ' ��������  �������� �����ȼ�(0-3)',
    '��ָ���������Ӽ���(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DELETESKILL,
    '@' + g_GameCommand.DELETESKILL.sCmd + ' �������� ��������(All)',
    'ɾ������ļ��ܣ�All����ɾ��ȫ������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DELETEITEM,
    '@' + g_GameCommand.DELETEITEM.sCmd + ' �������� ��Ʒ���� ����',
    'ɾ����������ָ������Ʒ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.CLEARMISSION,
    '@' + g_GameCommand.CLEARMISSION.sCmd + ' ��������',
    '�������������־(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.AddGuild,
    '@' + g_GameCommand.AddGuild.sCmd + ' �л����� ������',
    '�½�һ���л�(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DELGUILD,
    '@' + g_GameCommand.DELGUILD.sCmd + ' �л�����',
    'ɾ��һ���л�(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.CHANGESABUKLORD,
    '@' + g_GameCommand.CHANGESABUKLORD.sCmd + ' �л�����',
    '���ĳǱ������л�(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.FORCEDWALLCONQUESTWAR,
    '@' + g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd,
    'ǿ�п�ʼ/ֹͣ����ս(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.CONTESTPOINT,
    '@' + g_GameCommand.CONTESTPOINT.sCmd + ' �л�����',
    '�鿴�л��������÷����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.STARTCONTEST,
    '@' + g_GameCommand.STARTCONTEST.sCmd,
    '��ʼ�л�������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.ENDCONTEST,
    '@' + g_GameCommand.ENDCONTEST.sCmd,
    '�����л�������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.ANNOUNCEMENT,
    '@' + g_GameCommand.ANNOUNCEMENT.sCmd,
    '�鿴�л����������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.MOB,
    '@' + g_GameCommand.MOB.sCmd + ' �������� ����',
    '����߷���ָ�����������Ĺ���(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.Mission,
    '@' + g_GameCommand.Mission.sCmd + ' X  Y',
    '���ù���ļ��е�(���й��﹥����)(֧��Ȩ�޷���');

  RefGameMasterCmd(@g_GameCommand.MobPlace,
    '@' + g_GameCommand.MobPlace.sCmd + ' X  Y �������� ��������',
    '�ڵ�ǰ��ͼָ��XY���ù���(֧��Ȩ�޷���(�ȱ������ù���ļ��е�)�����õĹ�����������ṥ����Щ����');

  RefGameMasterCmd(@g_GameCommand.CLEARMON,
    '@' + g_GameCommand.CLEARMON.sCmd +
    ' ��ͼ��(* Ϊ����) ��������(* Ϊ����) ����Ʒ(0,1)',
    '�����ͼ�еĹ���(֧��Ȩ�޷���'')');

  RefGameMasterCmd(@g_GameCommand.DISABLESENDMSG,
    '@' + g_GameCommand.DISABLESENDMSG.sCmd + ' ��������',
    '��ָ��������뷢�Թ����б������б���Լ����������Լ����Կ����������˿�����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.ENABLESENDMSG,
    '@' + g_GameCommand.ENABLESENDMSG.sCmd,
    '��ָ������ӷ��Թ����б���ɾ��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DISABLESENDMSGLIST,
    '@' + g_GameCommand.DISABLESENDMSGLIST.sCmd,
    '�鿴���Թ����б��е�����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.SHUTUP,
    '@' + g_GameCommand.SHUTUP.sCmd + ' ��������',
    '��ָ���������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.RELEASESHUTUP,
    '@' + g_GameCommand.RELEASESHUTUP.sCmd + ' ��������',
    '��ָ������ӽ����б���ɾ��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.SHUTUPLIST,
    '@' + g_GameCommand.SHUTUPLIST.sCmd,
    '�鿴�����б��е�����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.SABUKWALLGOLD,
    '@' + g_GameCommand.SABUKWALLGOLD.sCmd,
    '�鿴�Ǳ������(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.STARTQUEST,
    '@' + g_GameCommand.STARTQUEST.sCmd,
    '��ʼ���ʹ��ܣ���Ϸ��������ͬʱ�������ⴰ��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DENYIPLOGON,
    '@' + g_GameCommand.DENYIPLOGON.sCmd + ' IP��ַ �Ƿ����÷�(0,1)',
    '��ָ��IP��ַ�����ֹ��¼�б�����ЩIP��¼���û����޷�������Ϸ(֧��Ȩ�޷���)');
    
  RefGameMasterCmd(@g_GameCommand.DELDENYIPLOGON,
    '@' + g_GameCommand.DELDENYIPLOGON.sCmd + ' IP��ַ',
    '��ָ��IP��ַ�ӽ�ֹ��¼�б���ɾ��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYIPLOGON,
    '@' + g_GameCommand.SHOWDENYIPLOGON.sCmd,
    '�鿴��ֹ��¼IP��ַ�б��е�����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DENYACCOUNTLOGON,
    '@' + g_GameCommand.DENYACCOUNTLOGON.sCmd +
    ' ��¼�ʺ� �Ƿ����÷�(0,1)',
    '��ָ����¼�ʺż����ֹ��¼�б��Դ��ʺŵ�¼���û����޷�������Ϸ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DELDENYACCOUNTLOGON,
    '@' + g_GameCommand.DELDENYACCOUNTLOGON.sCmd + ' ��¼�ʺ�',
    '��ָ����¼�ʺŴӽ�ֹ��¼�б���ɾ��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYACCOUNTLOGON,
    '@' + g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd,
    '�鿴��ֹ��¼�ʺ��б��е�����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DENYCHARNAMELOGON,
    '@' + g_GameCommand.DENYCHARNAMELOGON.sCmd +
    ' �������� �Ƿ����÷�(0,1)',
    '��ָ���������Ƽ����ֹ��¼�б������ｫ�޷�������Ϸ(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.DELDENYCHARNAMELOGON,
    '@' + g_GameCommand.DELDENYCHARNAMELOGON.sCmd + ' ��������',
    '��ָ���������ƴӽ�ֹ��¼�б���ɾ��(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYCHARNAMELOGON,
    '@' + g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd,
    '�鿴��ֹ���������б��е�����(֧��Ȩ�޷���)');

  RefGameMasterCmd(@g_GameCommand.SETMAPMODE,
    '@' + g_GameCommand.SETMAPMODE.sCmd,
    '���õ�ͼģʽ');

  RefGameMasterCmd(@g_GameCommand.SHOWMAPMODE,
    '@' + g_GameCommand.SHOWMAPMODE.sCmd,
    '��ʾ��ͼģʽ');

  RefGameMasterCmd(@g_GameCommand.SPIRIT,
    '@' + g_GameCommand.SPIRIT.sCmd,
    '��ʼ����Ч�����ѱ�');

  RefGameMasterCmd(@g_GameCommand.SPIRITSTOP,
    '@' + g_GameCommand.SPIRITSTOP.sCmd,
    'ֹͣ����Ч�����ѱ�');

end;

procedure TfrmGameCmd.RefGameDebugCmd(GameCmd: pTGameCmd; sCmdParam, sDesc:
  string);
begin
  Inc(nRefGameDebugIndex);
  if StringGridGameDebugCmd.RowCount - 1 < nRefGameDebugIndex then begin
    StringGridGameDebugCmd.RowCount := nRefGameDebugIndex + 1;
  end;

  StringGridGameDebugCmd.Cells[0, nRefGameDebugIndex] := GameCmd.sCmd;
  StringGridGameDebugCmd.Cells[1, nRefGameDebugIndex] :=
    IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameDebugCmd.Cells[2, nRefGameDebugIndex] := sCmdParam;
  StringGridGameDebugCmd.Cells[3, nRefGameDebugIndex] := sDesc;
  StringGridGameDebugCmd.Objects[0, nRefGameDebugIndex] := TObject(GameCmd);
end;

procedure TfrmGameCmd.RefDebugCommand;
var
  GameCmd: pTGameCmd;
begin
  EditGameDebugCmdOK.Enabled := False;
  nRefGameDebugIndex := 0;
  //  StringGridGameDebugCmd.RowCount:=41;

  GameCmd := @g_GameCommand.SHOWFLAG;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '�鿴����ָ����ʶ��״̬');

  GameCmd := @g_GameCommand.SETFLAG;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '��������ָ����ʶ��״̬(��/��)');

  GameCmd := @g_GameCommand.MOBNPC;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '����һ���µ�NPC');

  GameCmd := @g_GameCommand.DELNPC;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    'ɾ��ָ��NPC');

  GameCmd := @g_GameCommand.LOTTERYTICKET;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '�鿴��Ʊ�н�����');

  GameCmd := @g_GameCommand.RELOADADMIN;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼��ع���Ա�б�');

  GameCmd := @g_GameCommand.ReLoadNpc;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼���NPC�ű�');

  GameCmd := @g_GameCommand.RELOADMANAGE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼��ص�¼�ű�');

  GameCmd := @g_GameCommand.RELOADROBOTMANAGE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼��ػ���������');

  GameCmd := @g_GameCommand.RELOADROBOT;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼��ػ����˽ű�');

  GameCmd := @g_GameCommand.RELOADMONITEMS;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼��ع��ﱬ������');

  {GameCmd := @g_GameCommand.RELOADDIARY;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    'δʹ��');  }

  GameCmd := @g_GameCommand.RELOADITEMDB;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼�����Ʒ���ݿ�');

  GameCmd := @g_GameCommand.RELOADMAGICDB;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼��ؼ������ݿ�');

  GameCmd := @g_GameCommand.RELOADMONSTERDB;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼��ع������ݿ�');

  GameCmd := @g_GameCommand.RELOADMINMAP;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼���С��ͼ����');

  GameCmd := @g_GameCommand.RELOADGUILD;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼����л���Ϣ');

  {GameCmd := @g_GameCommand.RELOADGUILDALL;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');  }

  GameCmd := @g_GameCommand.RELOADLINENOTICE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼�����Ϸ������Ϣ');

  {GameCmd := @g_GameCommand.RELOADABUSE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���¼����໰��������');     }

  GameCmd := @g_GameCommand.BACKSTEP;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '�������');

  {GameCmd := @g_GameCommand.RECONNECTION;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '��ָ�����������л���������');

  GameCmd := @g_GameCommand.DISABLEFILTER;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '�����໰���˹���');    }

  GameCmd := @g_GameCommand.CHGUSERFULL;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���÷����������������');

  GameCmd := @g_GameCommand.CHGZENFASTSTEP;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���ù����ж��ٶ�');

  {GameCmd := @g_GameCommand.OXQUIZROOM;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');  }

  {GameCmd := @g_GameCommand.BALL;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    ''); }

  GameCmd := @g_GameCommand.FIREBURN;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���Լ���ǰ�������ӵ�ͼ�¼�');

  GameCmd := @g_GameCommand.TESTFIRE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '���Լ���Χ��Χ�����ӵ�ͼ�¼�');

  GameCmd := @g_GameCommand.TESTSTATUS;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '��������״̬ʱ��');

  {GameCmd := @g_GameCommand.TESTGOLDCHANGE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');   }

  {GameCmd := @g_GameCommand.GSA;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.TESTGA;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');   }

  GameCmd := @g_GameCommand.MAPINFO;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '��ʾ��ͼ��ϸ��Ϣ');

  GameCmd := @g_GameCommand.CLEARBAG;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '�������ȫ����Ʒ');

  GameCmd := @g_GameCommand.SHOWEFFECT;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd + ' ��ЧID',
    '������Ч��ʾ');

end;

procedure TfrmGameCmd.StringGridGameMasterCmdClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
begin
  nIndex := StringGridGameMasterCmd.Row;
  GameCmd := pTGameCmd(StringGridGameMasterCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    EditGameMasterCmdName.Text := GameCmd.sCmd;
    EditGameMasterCmdPerMission.Value := GameCmd.nPermissionMin;
    LabelGameMasterCmdParam.Caption := StringGridGameMasterCmd.Cells[2, nIndex];
    LabelGameMasterCmdFunc.Caption := StringGridGameMasterCmd.Cells[3, nIndex];
  end;
  EditGameMasterCmdOK.Enabled := False;
end;

procedure TfrmGameCmd.EditGameMasterCmdNameChange(Sender: TObject);
begin
  EditGameMasterCmdOK.Enabled := True;
  EditGameMasterCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameMasterCmdPerMissionChange(Sender: TObject);
begin
  EditGameMasterCmdOK.Enabled := True;
  EditGameMasterCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameMasterCmdOKClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
  sCmd: string;
  nPermission: Integer;
begin

  sCmd := Trim(EditGameMasterCmdName.Text);
  nPermission := EditGameMasterCmdPerMission.Value;
  if sCmd = '' then begin
    Application.MessageBox('�������Ʋ���Ϊ��.', '��ʾ��Ϣ',
      MB_OK +
      MB_ICONERROR);
    EditGameMasterCmdName.SetFocus;
    exit;
  end;

  nIndex := StringGridGameMasterCmd.Row;
  GameCmd := pTGameCmd(StringGridGameMasterCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    GameCmd.sCmd := sCmd;
    GameCmd.nPermissionMin := nPermission;
  end;
  RefGameMasterCommand();
end;

procedure TfrmGameCmd.EditGameMasterCmdSaveClick(Sender: TObject);
begin
  EditGameMasterCmdSave.Enabled := False;
  CommandConf.WriteString('Command', 'CLRPASSWORD',
    g_GameCommand.CLRPASSWORD.sCmd);
  CommandConf.WriteInteger('Permission', 'CLRPASSWORD',
    g_GameCommand.CLRPASSWORD.nPermissionMin);
  CommandConf.WriteString('Command', 'WHO', g_GameCommand.WHO.sCmd);
  CommandConf.WriteInteger('Permission', 'WHO',
    g_GameCommand.WHO.nPermissionMin);
  CommandConf.WriteString('Command', 'TOTAL', g_GameCommand.TOTAL.sCmd);
  CommandConf.WriteInteger('Permission', 'TOTAL',
    g_GameCommand.TOTAL.nPermissionMin);
  CommandConf.WriteString('Command', 'GAMEMASTER',
    g_GameCommand.GAMEMASTER.sCmd);
  CommandConf.WriteInteger('Permission', 'GAMEMASTER',
    g_GameCommand.GAMEMASTER.nPermissionMin);
  CommandConf.WriteString('Command', 'OBSERVER', g_GameCommand.OBSERVER.sCmd);
  CommandConf.WriteInteger('Permission', 'OBSERVER',
    g_GameCommand.OBSERVER.nPermissionMin);
  CommandConf.WriteString('Command', 'SUEPRMAN', g_GameCommand.SUEPRMAN.sCmd);
  CommandConf.WriteInteger('Permission', 'SUEPRMAN',
    g_GameCommand.SUEPRMAN.nPermissionMin);
  CommandConf.WriteString('Command', 'MAKE', g_GameCommand.MAKE.sCmd);
  CommandConf.WriteInteger('Permission', 'MAKE',
    g_GameCommand.MAKE.nPermissionMin);
  CommandConf.WriteString('Command', 'SMAKE', g_GameCommand.SMAKE.sCmd);
  CommandConf.WriteInteger('Permission', 'SMAKE',
    g_GameCommand.SMAKE.nPermissionMin);
  CommandConf.WriteString('Command', 'Move', g_GameCommand.Move.sCmd);
  CommandConf.WriteInteger('Permission', 'Move',
    g_GameCommand.Move.nPermissionMin);
  CommandConf.WriteString('Command', 'POSITIONMOVE',
    g_GameCommand.POSITIONMOVE.sCmd);
  CommandConf.WriteInteger('Permission', 'POSITIONMOVE',
    g_GameCommand.POSITIONMOVE.nPermissionMin);
  CommandConf.WriteString('Command', 'RECALL', g_GameCommand.RECALL.sCmd);
  CommandConf.WriteInteger('Permission', 'RECALL',
    g_GameCommand.RECALL.nPermissionMin);
  CommandConf.WriteString('Command', 'REGOTO', g_GameCommand.REGOTO.sCmd);
  CommandConf.WriteInteger('Permission', 'REGOTO',
    g_GameCommand.REGOTO.nPermissionMin);
  CommandConf.WriteString('Command', 'TING', g_GameCommand.TING.sCmd);
  CommandConf.WriteInteger('Permission', 'TING',
    g_GameCommand.TING.nPermissionMin);
  CommandConf.WriteString('Command', 'SUPERTING', g_GameCommand.SUPERTING.sCmd);
  CommandConf.WriteInteger('Permission', 'SUPERTING',
    g_GameCommand.SUPERTING.nPermissionMin);
  CommandConf.WriteString('Command', 'MAPMOVE', g_GameCommand.MAPMOVE.sCmd);
  CommandConf.WriteInteger('Permission', 'MAPMOVE',
    g_GameCommand.MAPMOVE.nPermissionMin);
  CommandConf.WriteString('Command', 'INFO', g_GameCommand.INFO.sCmd);
  CommandConf.WriteInteger('Permission', 'INFO',
    g_GameCommand.INFO.nPermissionMin);
  CommandConf.WriteString('Command', 'HUMANLOCAL',
    g_GameCommand.HUMANLOCAL.sCmd);
  CommandConf.WriteInteger('Permission', 'HUMANLOCAL',
    g_GameCommand.HUMANLOCAL.nPermissionMin);
  CommandConf.WriteString('Command', 'VIEWWHISPER',
    g_GameCommand.VIEWWHISPER.sCmd);
  CommandConf.WriteInteger('Permission', 'VIEWWHISPER',
    g_GameCommand.VIEWWHISPER.nPermissionMin);
  CommandConf.WriteString('Command', 'MOBLEVEL', g_GameCommand.MOBLEVEL.sCmd);
  CommandConf.WriteInteger('Permission', 'MOBLEVEL',
    g_GameCommand.MOBLEVEL.nPermissionMin);
  CommandConf.WriteString('Command', 'MOBCOUNT', g_GameCommand.MOBCOUNT.sCmd);
  CommandConf.WriteInteger('Permission', 'MOBCOUNT',
    g_GameCommand.MOBCOUNT.nPermissionMin);
  CommandConf.WriteString('Command', 'HUMANCOUNT',
    g_GameCommand.HUMANCOUNT.sCmd);
  CommandConf.WriteInteger('Permission', 'HUMANCOUNT',
    g_GameCommand.HUMANCOUNT.nPermissionMin);
  CommandConf.WriteString('Command', 'Map', g_GameCommand.Map.sCmd);
  CommandConf.WriteInteger('Permission', 'Map',
    g_GameCommand.Map.nPermissionMin);
  CommandConf.WriteString('Command', 'Level', g_GameCommand.Level.sCmd);
  CommandConf.WriteInteger('Permission', 'Level',
    g_GameCommand.Level.nPermissionMin);
  CommandConf.WriteString('Command', 'KICK', g_GameCommand.KICK.sCmd);
  CommandConf.WriteInteger('Permission', 'KICK',
    g_GameCommand.KICK.nPermissionMin);
  CommandConf.WriteString('Command', 'ReAlive', g_GameCommand.ReAlive.sCmd);
  CommandConf.WriteInteger('Permission', 'ReAlive',
    g_GameCommand.ReAlive.nPermissionMin);
  CommandConf.WriteString('Command', 'KILL', g_GameCommand.KILL.sCmd);
  CommandConf.WriteInteger('Permission', 'KILL',
    g_GameCommand.KILL.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEJOB', g_GameCommand.CHANGEJOB.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEJOB',
    g_GameCommand.CHANGEJOB.nPermissionMin);
  CommandConf.WriteString('Command', 'FREEPENALTY',
    g_GameCommand.FREEPENALTY.sCmd);
  CommandConf.WriteInteger('Permission', 'FREEPENALTY',
    g_GameCommand.FREEPENALTY.nPermissionMin);
  CommandConf.WriteString('Command', 'PKPOINT', g_GameCommand.PKPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'PKPOINT',
    g_GameCommand.PKPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'IncPkPoint',
    g_GameCommand.IncPkPoint.sCmd);
  CommandConf.WriteInteger('Permission', 'IncPkPoint',
    g_GameCommand.IncPkPoint.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEGENDER',
    g_GameCommand.CHANGEGENDER.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEGENDER',
    g_GameCommand.CHANGEGENDER.nPermissionMin);
  CommandConf.WriteString('Command', 'HAIR', g_GameCommand.HAIR.sCmd);
  CommandConf.WriteInteger('Permission', 'HAIR',
    g_GameCommand.HAIR.nPermissionMin);
  CommandConf.WriteString('Command', 'BonusPoint',
    g_GameCommand.BonusPoint.sCmd);
  CommandConf.WriteInteger('Permission', 'BonusPoint',
    g_GameCommand.BonusPoint.nPermissionMin);
  CommandConf.WriteString('Command', 'DELBONUSPOINT',
    g_GameCommand.DELBONUSPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'DELBONUSPOINT',
    g_GameCommand.DELBONUSPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'RESTBONUSPOINT',
    g_GameCommand.RESTBONUSPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'RESTBONUSPOINT',
    g_GameCommand.RESTBONUSPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'SETPERMISSION',
    g_GameCommand.SETPERMISSION.sCmd);
  CommandConf.WriteInteger('Permission', 'SETPERMISSION',
    g_GameCommand.SETPERMISSION.nPermissionMin);
  CommandConf.WriteString('Command', 'RENEWLEVEL',
    g_GameCommand.RENEWLEVEL.sCmd);
  CommandConf.WriteInteger('Permission', 'RENEWLEVEL',
    g_GameCommand.RENEWLEVEL.nPermissionMin);
  CommandConf.WriteString('Command', 'DELGOLD', g_GameCommand.DELGOLD.sCmd);
  CommandConf.WriteInteger('Permission', 'DELGOLD',
    g_GameCommand.DELGOLD.nPermissionMin);
  CommandConf.WriteString('Command', 'ADDGOLD', g_GameCommand.ADDGOLD.sCmd);
  CommandConf.WriteInteger('Permission', 'ADDGOLD',
    g_GameCommand.ADDGOLD.nPermissionMin);
  CommandConf.WriteString('Command', 'GAMEGOLD', g_GameCommand.GAMEGOLD.sCmd);
  CommandConf.WriteInteger('Permission', 'GAMEGOLD',
    g_GameCommand.GAMEGOLD.nPermissionMin);
  CommandConf.WriteString('Command', 'GAMEPOINT', g_GameCommand.GAMEPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'GAMEPOINT',
    g_GameCommand.GAMEPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'CREDITPOINT',
    g_GameCommand.CREDITPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'CREDITPOINT',
    g_GameCommand.CREDITPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'REFINEWEAPON',
    g_GameCommand.REFINEWEAPON.sCmd);
  CommandConf.WriteInteger('Permission', 'REFINEWEAPON',
    g_GameCommand.REFINEWEAPON.nPermissionMin);
  CommandConf.WriteString('Command', 'ADJUESTLEVEL',
    g_GameCommand.ADJUESTLEVEL.sCmd);
  CommandConf.WriteInteger('Permission', 'ADJUESTLEVEL',
    g_GameCommand.ADJUESTLEVEL.nPermissionMin);
  CommandConf.WriteString('Command', 'ADJUESTEXP',
    g_GameCommand.ADJUESTEXP.sCmd);
  CommandConf.WriteInteger('Permission', 'ADJUESTEXP',
    g_GameCommand.ADJUESTEXP.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEDEARNAME',
    g_GameCommand.CHANGEDEARNAME.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEDEARNAME',
    g_GameCommand.CHANGEDEARNAME.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEMASTERNAME',
    g_GameCommand.CHANGEMASTERNAME.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEMASTERNAME',
    g_GameCommand.CHANGEMASTERNAME.nPermissionMin);
  CommandConf.WriteString('Command', 'RECALLMOB', g_GameCommand.RECALLMOB.sCmd);
  CommandConf.WriteInteger('Permission', 'RECALLMOB',
    g_GameCommand.RECALLMOB.nPermissionMin);
  CommandConf.WriteString('Command', 'TRAINING', g_GameCommand.TRAINING.sCmd);
  CommandConf.WriteInteger('Permission', 'TRAINING',
    g_GameCommand.TRAINING.nPermissionMin);
  CommandConf.WriteString('Command', 'TRAININGSKILL',
    g_GameCommand.TRAININGSKILL.sCmd);
  CommandConf.WriteInteger('Permission', 'TRAININGSKILL',
    g_GameCommand.TRAININGSKILL.nPermissionMin);
  CommandConf.WriteString('Command', 'DELETESKILL',
    g_GameCommand.DELETESKILL.sCmd);
  CommandConf.WriteInteger('Permission', 'DELETESKILL',
    g_GameCommand.DELETESKILL.nPermissionMin);
  CommandConf.WriteString('Command', 'DELETEITEM',
    g_GameCommand.DELETEITEM.sCmd);
  CommandConf.WriteInteger('Permission', 'DELETEITEM',
    g_GameCommand.DELETEITEM.nPermissionMin);
  CommandConf.WriteString('Command', 'CLEARMISSION',
    g_GameCommand.CLEARMISSION.sCmd);
  CommandConf.WriteInteger('Permission', 'CLEARMISSION',
    g_GameCommand.CLEARMISSION.nPermissionMin);
  CommandConf.WriteString('Command', 'AddGuild', g_GameCommand.AddGuild.sCmd);
  CommandConf.WriteInteger('Permission', 'AddGuild',
    g_GameCommand.AddGuild.nPermissionMin);
  CommandConf.WriteString('Command', 'DELGUILD', g_GameCommand.DELGUILD.sCmd);
  CommandConf.WriteInteger('Permission', 'DELGUILD',
    g_GameCommand.DELGUILD.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGESABUKLORD',
    g_GameCommand.CHANGESABUKLORD.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGESABUKLORD',
    g_GameCommand.CHANGESABUKLORD.nPermissionMin);
  CommandConf.WriteString('Command', 'FORCEDWALLCONQUESTWAR',
    g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd);
  CommandConf.WriteInteger('Permission', 'FORCEDWALLCONQUESTWAR',
    g_GameCommand.FORCEDWALLCONQUESTWAR.nPermissionMin);
  CommandConf.WriteString('Command', 'CONTESTPOINT',
    g_GameCommand.CONTESTPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'CONTESTPOINT',
    g_GameCommand.CONTESTPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'STARTCONTEST',
    g_GameCommand.STARTCONTEST.sCmd);
  CommandConf.WriteInteger('Permission', 'STARTCONTEST',
    g_GameCommand.STARTCONTEST.nPermissionMin);
  CommandConf.WriteString('Command', 'ENDCONTEST',
    g_GameCommand.ENDCONTEST.sCmd);
  CommandConf.WriteInteger('Permission', 'ENDCONTEST',
    g_GameCommand.ENDCONTEST.nPermissionMin);
  CommandConf.WriteString('Command', 'ANNOUNCEMENT',
    g_GameCommand.ANNOUNCEMENT.sCmd);
  CommandConf.WriteInteger('Permission', 'ANNOUNCEMENT',
    g_GameCommand.ANNOUNCEMENT.nPermissionMin);
  CommandConf.WriteString('Command', 'MOB', g_GameCommand.MOB.sCmd);
  CommandConf.WriteInteger('Permission', 'MOB',
    g_GameCommand.MOB.nPermissionMin);
  CommandConf.WriteString('Command', 'Mission', g_GameCommand.Mission.sCmd);
  CommandConf.WriteInteger('Permission', 'Mission',
    g_GameCommand.Mission.nPermissionMin);
  CommandConf.WriteString('Command', 'MobPlace', g_GameCommand.MobPlace.sCmd);
  CommandConf.WriteInteger('Permission', 'MobPlace',
    g_GameCommand.MobPlace.nPermissionMin);
  CommandConf.WriteString('Command', 'CLEARMON', g_GameCommand.CLEARMON.sCmd);
  CommandConf.WriteInteger('Permission', 'CLEARMON',
    g_GameCommand.CLEARMON.nPermissionMin);
  CommandConf.WriteString('Command', 'DISABLESENDMSG',
    g_GameCommand.DISABLESENDMSG.sCmd);
  CommandConf.WriteInteger('Permission', 'DISABLESENDMSG',
    g_GameCommand.DISABLESENDMSG.nPermissionMin);
  CommandConf.WriteString('Command', 'ENABLESENDMSG',
    g_GameCommand.ENABLESENDMSG.sCmd);
  CommandConf.WriteInteger('Permission', 'ENABLESENDMSG',
    g_GameCommand.ENABLESENDMSG.nPermissionMin);
  CommandConf.WriteString('Command', 'DISABLESENDMSGLIST',
    g_GameCommand.DISABLESENDMSGLIST.sCmd);
  CommandConf.WriteInteger('Permission', 'DISABLESENDMSGLIST',
    g_GameCommand.DISABLESENDMSGLIST.nPermissionMin);
  CommandConf.WriteString('Command', 'SHUTUP', g_GameCommand.SHUTUP.sCmd);
  CommandConf.WriteInteger('Permission', 'SHUTUP',
    g_GameCommand.SHUTUP.nPermissionMin);
  CommandConf.WriteString('Command', 'RELEASESHUTUP',
    g_GameCommand.RELEASESHUTUP.sCmd);
  CommandConf.WriteInteger('Permission', 'RELEASESHUTUP',
    g_GameCommand.RELEASESHUTUP.nPermissionMin);
  CommandConf.WriteString('Command', 'SHUTUPLIST',
    g_GameCommand.SHUTUPLIST.sCmd);
  CommandConf.WriteInteger('Permission', 'SHUTUPLIST',
    g_GameCommand.SHUTUPLIST.nPermissionMin);
  CommandConf.WriteString('Command', 'SABUKWALLGOLD',
    g_GameCommand.SABUKWALLGOLD.sCmd);
  CommandConf.WriteInteger('Permission', 'SABUKWALLGOLD',
    g_GameCommand.SABUKWALLGOLD.nPermissionMin);
  CommandConf.WriteString('Command', 'STARTQUEST',
    g_GameCommand.STARTQUEST.sCmd);
  CommandConf.WriteInteger('Permission', 'STARTQUEST',
    g_GameCommand.STARTQUEST.nPermissionMin);
  CommandConf.WriteString('Command', 'DENYIPLOGON',
    g_GameCommand.DENYIPLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DENYIPLOGON',
    g_GameCommand.DENYIPLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'DENYACCOUNTLOGON',
    g_GameCommand.DENYACCOUNTLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DENYACCOUNTLOGON',
    g_GameCommand.DENYACCOUNTLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'DENYCHARNAMELOGON',
    g_GameCommand.DENYCHARNAMELOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DENYCHARNAMELOGON',
    g_GameCommand.DENYCHARNAMELOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'DELDENYIPLOGON',
    g_GameCommand.DELDENYIPLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DELDENYIPLOGON',
    g_GameCommand.DELDENYIPLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'DELDENYACCOUNTLOGON',
    g_GameCommand.DELDENYACCOUNTLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DELDENYACCOUNTLOGON',
    g_GameCommand.DELDENYACCOUNTLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'DELDENYCHARNAMELOGON',
    g_GameCommand.DELDENYCHARNAMELOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DELDENYCHARNAMELOGON',
    g_GameCommand.DELDENYCHARNAMELOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'SHOWDENYIPLOGON',
    g_GameCommand.SHOWDENYIPLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'SHOWDENYIPLOGON',
    g_GameCommand.SHOWDENYIPLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'SHOWDENYACCOUNTLOGON',
    g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'SHOWDENYACCOUNTLOGON',
    g_GameCommand.SHOWDENYACCOUNTLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'SHOWDENYCHARNAMELOGON',
    g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'SHOWDENYCHARNAMELOGON',
    g_GameCommand.SHOWDENYCHARNAMELOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'SETMAPMODE',
    g_GameCommand.SETMAPMODE.sCmd);
  CommandConf.WriteInteger('Permission', 'SETMAPMODE',
    g_GameCommand.SETMAPMODE.nPermissionMin);
  CommandConf.WriteString('Command', 'SHOWMAPMODE',
    g_GameCommand.SHOWMAPMODE.sCmd);
  CommandConf.WriteInteger('Permission', 'SHOWMAPMODE',
    g_GameCommand.SHOWMAPMODE.nPermissionMin);
  CommandConf.WriteString('Command', 'Attack', g_GameCommand.Attack.sCmd);
  CommandConf.WriteInteger('Permission', 'Attack',
    g_GameCommand.Attack.nPermissionMin);
  CommandConf.WriteString('Command', 'LUCKYPOINT',
    g_GameCommand.LUCKYPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'LUCKYPOINT',
    g_GameCommand.LUCKYPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGELUCK',
    g_GameCommand.CHANGELUCK.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGELUCK',
    g_GameCommand.CHANGELUCK.nPermissionMin);
  CommandConf.WriteString('Command', 'HUNGER', g_GameCommand.HUNGER.sCmd);
  CommandConf.WriteInteger('Permission', 'HUNGER',
    g_GameCommand.HUNGER.nPermissionMin);
  CommandConf.WriteString('Command', 'NAMECOLOR', g_GameCommand.NAMECOLOR.sCmd);
  CommandConf.WriteInteger('Permission', 'NAMECOLOR',
    g_GameCommand.NAMECOLOR.nPermissionMin);
  CommandConf.WriteString('Command', 'TRANSPARECY',
    g_GameCommand.TRANSPARECY.sCmd);
  CommandConf.WriteInteger('Permission', 'TRANSPARECY',
    g_GameCommand.TRANSPARECY.nPermissionMin);
  CommandConf.WriteString('Command', 'LEVEL0', g_GameCommand.LEVEL0.sCmd);
  CommandConf.WriteInteger('Permission', 'LEVEL0',
    g_GameCommand.LEVEL0.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEITEMNAME',
    g_GameCommand.CHANGEITEMNAME.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEITEMNAME',
    g_GameCommand.CHANGEITEMNAME.nPermissionMin);
  CommandConf.WriteString('Command', 'ADDTOITEMEVENT',
    g_GameCommand.ADDTOITEMEVENT.sCmd);
  CommandConf.WriteInteger('Permission', 'ADDTOITEMEVENT',
    g_GameCommand.ADDTOITEMEVENT.nPermissionMin);
  CommandConf.WriteString('Command', 'ADDTOITEMEVENTASPIECES',
    g_GameCommand.ADDTOITEMEVENTASPIECES.sCmd);
  CommandConf.WriteInteger('Permission', 'ADDTOITEMEVENTASPIECES',
    g_GameCommand.ADDTOITEMEVENTASPIECES.nPermissionMin);
  CommandConf.WriteString('Command', 'ItemEventList',
    g_GameCommand.ItemEventList.sCmd);
  CommandConf.WriteInteger('Permission', 'ItemEventList',
    g_GameCommand.ItemEventList.nPermissionMin);
  CommandConf.WriteString('Command', 'STARTINGGIFTNO',
    g_GameCommand.STARTINGGIFTNO.sCmd);
  CommandConf.WriteInteger('Permission', 'STARTINGGIFTNO',
    g_GameCommand.STARTINGGIFTNO.nPermissionMin);
  CommandConf.WriteString('Command', 'DELETEALLITEMEVENT',
    g_GameCommand.DELETEALLITEMEVENT.sCmd);
  CommandConf.WriteInteger('Permission', 'DELETEALLITEMEVENT',
    g_GameCommand.DELETEALLITEMEVENT.nPermissionMin);
  CommandConf.WriteString('Command', 'STARTITEMEVENT',
    g_GameCommand.STARTITEMEVENT.sCmd);
  CommandConf.WriteInteger('Permission', 'STARTITEMEVENT',
    g_GameCommand.STARTITEMEVENT.nPermissionMin);
  CommandConf.WriteString('Command', 'ITEMEVENTTERM',
    g_GameCommand.ITEMEVENTTERM.sCmd);
  CommandConf.WriteInteger('Permission', 'ITEMEVENTTERM',
    g_GameCommand.ITEMEVENTTERM.nPermissionMin);
  CommandConf.WriteString('Command', 'OPDELETESKILL',
    g_GameCommand.OPDELETESKILL.sCmd);
  CommandConf.WriteInteger('Permission', 'OPDELETESKILL',
    g_GameCommand.OPDELETESKILL.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEWEAPONDURA',
    g_GameCommand.CHANGEWEAPONDURA.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEWEAPONDURA',
    g_GameCommand.CHANGEWEAPONDURA.nPermissionMin);
  CommandConf.WriteString('Command', 'SBKDOOR', g_GameCommand.SBKDOOR.sCmd);
  CommandConf.WriteInteger('Permission', 'SBKDOOR',
    g_GameCommand.SBKDOOR.nPermissionMin);
  CommandConf.WriteString('Command', 'SPIRIT', g_GameCommand.SPIRIT.sCmd);
  CommandConf.WriteInteger('Permission', 'SPIRIT',
    g_GameCommand.SPIRIT.nPermissionMin);
  CommandConf.WriteString('Command', 'SPIRITSTOP',
    g_GameCommand.SPIRITSTOP.sCmd);
  CommandConf.WriteInteger('Permission', 'SPIRITSTOP',
    g_GameCommand.SPIRITSTOP.nPermissionMin);

end;

procedure TfrmGameCmd.StringGridGameDebugCmdClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
begin
  nIndex := StringGridGameDebugCmd.Row;
  GameCmd := pTGameCmd(StringGridGameDebugCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    EditGameDebugCmdName.Text := GameCmd.sCmd;
    EditGameDebugCmdPerMission.Value := GameCmd.nPermissionMin;
    LabelGameDebugCmdParam.Caption := StringGridGameDebugCmd.Cells[2, nIndex];
    LabelGameDebugCmdFunc.Caption := StringGridGameDebugCmd.Cells[3, nIndex];
  end;
  EditGameDebugCmdOK.Enabled := False;
end;

procedure TfrmGameCmd.EditGameDebugCmdNameChange(Sender: TObject);
begin
  EditGameDebugCmdOK.Enabled := True;
  EditGameDebugCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameDebugCmdPerMissionChange(Sender: TObject);
begin
  EditGameDebugCmdOK.Enabled := True;
  EditGameDebugCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameDebugCmdOKClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
  sCmd: string;
  nPermission: Integer;
begin
  sCmd := Trim(EditGameDebugCmdName.Text);
  nPermission := EditGameDebugCmdPerMission.Value;
  if sCmd = '' then begin
    Application.MessageBox('�������Ʋ���Ϊ��.', '��ʾ��Ϣ',
      MB_OK +
      MB_ICONERROR);
    EditGameDebugCmdName.SetFocus;
    exit;
  end;

  nIndex := StringGridGameDebugCmd.Row;
  GameCmd := pTGameCmd(StringGridGameDebugCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    GameCmd.sCmd := sCmd;
    GameCmd.nPermissionMin := nPermission;
  end;
  RefDebugCommand();
end;

procedure TfrmGameCmd.EditGameDebugCmdSaveClick(Sender: TObject);
begin
  EditGameDebugCmdSave.Enabled := False;
  CommandConf.WriteString('Command', 'SHOWFLAG', g_GameCommand.SHOWFLAG.sCmd);
  CommandConf.WriteString('Command', 'SETFLAG', g_GameCommand.SETFLAG.sCmd);
  CommandConf.WriteString('Command', 'SHOWOPEN', g_GameCommand.SHOWOPEN.sCmd);
  CommandConf.WriteString('Command', 'SETOPEN', g_GameCommand.SETOPEN.sCmd);
  CommandConf.WriteString('Command', 'SHOWUNIT', g_GameCommand.SHOWUNIT.sCmd);
  CommandConf.WriteString('Command', 'SETUNIT', g_GameCommand.SETUNIT.sCmd);
  CommandConf.WriteString('Command', 'MOBNPC', g_GameCommand.MOBNPC.sCmd);
  CommandConf.WriteString('Command', 'DELNPC', g_GameCommand.DELNPC.sCmd);
  CommandConf.WriteString('Command', 'LOTTERYTICKET',
    g_GameCommand.LOTTERYTICKET.sCmd);
  CommandConf.WriteString('Command', 'RELOADADMIN',
    g_GameCommand.RELOADADMIN.sCmd);
  CommandConf.WriteString('Command', 'ReLoadNpc', g_GameCommand.ReLoadNpc.sCmd);
  CommandConf.WriteString('Command', 'RELOADMANAGE',
    g_GameCommand.RELOADMANAGE.sCmd);
  CommandConf.WriteString('Command', 'RELOADROBOTMANAGE',
    g_GameCommand.RELOADROBOTMANAGE.sCmd);
  CommandConf.WriteString('Command', 'RELOADROBOT',
    g_GameCommand.RELOADROBOT.sCmd);
  CommandConf.WriteString('Command', 'RELOADMONITEMS',
    g_GameCommand.RELOADMONITEMS.sCmd);
  CommandConf.WriteString('Command', 'RELOADDIARY',
    g_GameCommand.RELOADDIARY.sCmd);
  CommandConf.WriteString('Command', 'RELOADITEMDB',
    g_GameCommand.RELOADITEMDB.sCmd);
  CommandConf.WriteString('Command', 'RELOADMAGICDB',
    g_GameCommand.RELOADMAGICDB.sCmd);
  CommandConf.WriteString('Command', 'RELOADMONSTERDB',
    g_GameCommand.RELOADMONSTERDB.sCmd);
  CommandConf.WriteString('Command', 'RELOADMINMAP',
    g_GameCommand.RELOADMINMAP.sCmd);
  CommandConf.WriteString('Command', 'RELOADGUILD',
    g_GameCommand.RELOADGUILD.sCmd);
  CommandConf.WriteString('Command', 'RELOADGUILDALL',
    g_GameCommand.RELOADGUILDALL.sCmd);
  CommandConf.WriteString('Command', 'RELOADLINENOTICE',
    g_GameCommand.RELOADLINENOTICE.sCmd);
  CommandConf.WriteString('Command', 'RELOADABUSE',
    g_GameCommand.RELOADABUSE.sCmd);
  CommandConf.WriteString('Command', 'BACKSTEP', g_GameCommand.BACKSTEP.sCmd);
  CommandConf.WriteString('Command', 'RECONNECTION',
    g_GameCommand.RECONNECTION.sCmd);
  CommandConf.WriteString('Command', 'DISABLEFILTER',
    g_GameCommand.DISABLEFILTER.sCmd);
  CommandConf.WriteString('Command', 'CHGUSERFULL',
    g_GameCommand.CHGUSERFULL.sCmd);
  CommandConf.WriteString('Command', 'CHGZENFASTSTEP',
    g_GameCommand.CHGZENFASTSTEP.sCmd);
  CommandConf.WriteString('Command', 'OXQUIZROOM',
    g_GameCommand.OXQUIZROOM.sCmd);
  CommandConf.WriteString('Command', 'BALL', g_GameCommand.BALL.sCmd);
  CommandConf.WriteString('Command', 'FIREBURN', g_GameCommand.FIREBURN.sCmd);
  CommandConf.WriteString('Command', 'TESTFIRE', g_GameCommand.TESTFIRE.sCmd);
  CommandConf.WriteString('Command', 'TESTSTATUS',
    g_GameCommand.TESTSTATUS.sCmd);
  CommandConf.WriteString('Command', 'TESTGOLDCHANGE',
    g_GameCommand.TESTGOLDCHANGE.sCmd);
  CommandConf.WriteString('Command', 'GSA', g_GameCommand.GSA.sCmd);
  CommandConf.WriteString('Command', 'TESTGA', g_GameCommand.TESTGA.sCmd);
  CommandConf.WriteString('Command', 'MAPINFO', g_GameCommand.MAPINFO.sCmd);
  CommandConf.WriteString('Command', 'CLEARBAG', g_GameCommand.CLEARBAG.sCmd);

end;

end.

