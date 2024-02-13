unit MonsterConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin;

type
  TfrmMonsterConfig = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox8: TGroupBox;
    Label23: TLabel;
    EditMonOneDropGoldCount: TSpinEdit;
    ButtonGeneralSave: TButton;
    CheckBoxDropGoldToPlayBag: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    CheckBoxShowMonLevel: TCheckBox;
    EditShowMonLevelFormat: TEdit;
    procedure ButtonGeneralSaveClick(Sender: TObject);
    procedure EditMonOneDropGoldCountChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxDropGoldToPlayBagClick(Sender: TObject);
    procedure CheckBoxShowMonLevelClick(Sender: TObject);
    procedure EditShowMonLevelFormatChange(Sender: TObject);
  private
    boOpened: Boolean;
    boModValued: Boolean;
    procedure ModValue();
    procedure uModValue();
    procedure RefGeneralInfo();
    { Private declarations }
  public
    procedure Open;
    { Public declarations }
  end;

var
  frmMonsterConfig: TfrmMonsterConfig;

implementation

uses M2Share, SDK;

{$R *.dfm}

{ TfrmMonsterConfig }

procedure TfrmMonsterConfig.ModValue;
begin
  boModValued := True;
  ButtonGeneralSave.Enabled := True;
end;

procedure TfrmMonsterConfig.uModValue;
begin
  boModValued := False;
  ButtonGeneralSave.Enabled := False;
end;

procedure TfrmMonsterConfig.FormCreate(Sender: TObject);
begin
{$IF SoftVersion = VERDEMO}
  Caption := '��Ϸ����[��ʾ�汾���������õ�����Ч�������ܱ���]'
{$IFEND}
end;

procedure TfrmMonsterConfig.Open;
begin
  boOpened := False;
  uModValue();
  RefGeneralInfo();
  boOpened := True;
  PageControl1.ActivePageIndex := 0;
  ShowModal;
end;

procedure TfrmMonsterConfig.RefGeneralInfo;
begin
  EditMonOneDropGoldCount.Value := g_Config.nMonOneDropGoldCount;
  CheckBoxDropGoldToPlayBag.Checked := g_Config.boDropGoldToPlayBag;
  EditShowMonLevelFormat.Text := g_Config.sShowMonLevelFormat;
  CheckBoxShowMonLevel.Checked := g_Config.boShowMonLevel;
  EditShowMonLevelFormat.Enabled := CheckBoxShowMonLevel.Checked; 
end;

procedure TfrmMonsterConfig.ButtonGeneralSaveClick(Sender: TObject);
begin
  Config.WriteInteger('Setup', 'MonOneDropGoldCount', g_Config.nMonOneDropGoldCount);
  Config.WriteBool('Setup', 'DropGoldToPlayBag', g_Config.boDropGoldToPlayBag);
  Config.WriteBool('Setup', 'ShowMonLevel', g_Config.boShowMonLevel);
  Config.WriteString('Setup', 'ShowMonLevelFormat', g_Config.sShowMonLevelFormat);
  uModValue();
end;

procedure TfrmMonsterConfig.EditMonOneDropGoldCountChange(Sender: TObject);
begin
  if EditMonOneDropGoldCount.Text = '' then begin
    EditMonOneDropGoldCount.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nMonOneDropGoldCount := EditMonOneDropGoldCount.Value;
  ModValue();
end;

procedure TfrmMonsterConfig.EditShowMonLevelFormatChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.sShowMonLevelFormat := EditShowMonLevelFormat.Text;
  ModValue();
end;

procedure TfrmMonsterConfig.CheckBoxDropGoldToPlayBagClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boDropGoldToPlayBag := CheckBoxDropGoldToPlayBag.Checked;
  ModValue();
end;

procedure TfrmMonsterConfig.CheckBoxShowMonLevelClick(Sender: TObject);
begin
  if not boOpened then Exit;
  EditShowMonLevelFormat.Enabled := CheckBoxShowMonLevel.Checked; 
  g_Config.boShowMonLevel := CheckBoxShowMonLevel.Checked;
  ModValue();
end;

end.
