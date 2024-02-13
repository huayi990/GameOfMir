program mir2;

uses
  Forms,
  Dialogs,
  IniFiles,
  Windows,
  SysUtils,
  ClMain in 'ClMain.pas' {frmMain},
  DrawScrn in 'DrawScrn.pas',
  IntroScn in 'IntroScn.pas',
  PlayScn in 'PlayScn.pas',
  MapUnit in 'MapUnit.pas',
  ClFunc in 'ClFunc.pas',
  cliUtil in 'cliUtil.pas',
  magiceff in 'magiceff.pas',
  SoundUtil in 'SoundUtil.pas',
  Actor in 'Actor.pas',
  HerbActor in 'HerbActor.pas',
  AxeMon in 'AxeMon.pas',
  clEvent in 'clEvent.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  MShare in 'MShare.pas',
  Mpeg in 'Mpeg.pas',
  Share in 'Share.pas',
  DlgConfig in 'DlgConfig.pas' {frmDlgConfig},
  GameSetup in 'GameSetup.pas',
  FState2 in 'FState2.pas' {FrmDlg2},
  WMFile in 'WMFile.pas',
  FState in 'FState.pas' {FrmDlg},
  MudUtil in '..\Common\MudUtil.pas',
  MD5Unit in '..\Common\MD5Unit.pas',
  FState3 in 'FState3.pas' {FrmDlg3},
  UIB in 'UIB.pas',
  NpcActor in 'NpcActor.pas',
  FWeb in 'FWeb.pas' {FrmWeb},
  AxeMon2 in 'AxeMon2.pas',
  AxeMon3 in 'AxeMon3.pas',
  GMManage in 'GMManage.pas' {FormGMManage},
  MNShare in 'MNShare.pas',
  CheckDLL in '..\Common\CheckDLL.pas',
  MyCommon in '..\MyCommon\MyCommon.pas',
  DLLLoader in '..\Common\DLLLoader.pas',
  DLLFile in 'DLLFile.pas',
  Bass in 'Bass.pas',
  CheckDllFile in '..\Common\CheckDllFile.pas',
  LShare in 'LShare.pas',
  Logo in 'Logo.pas',
  EncryptFile in '..\Common\EncryptFile.pas',
  FState4 in 'FState4.pas' {FrmDlg4},
  DES in '..\Common\DES.pas',
  FrmAD in 'FrmAD.pas' {FormAD},
  Gfxfont in '..\..\Component\HGEDelphi\Gfxfont.pas',
  HGE in '..\..\Component\HGEDelphi\HGE.pas',
  HGEBase in '..\..\Component\HGEDelphi\HGEBase.pas',
  HGECanvas in '..\..\Component\HGEDelphi\HGECanvas.pas',
  HGEFont in '..\..\Component\HGEDelphi\HGEFont.pas',
  HGEFonts in '..\..\Component\HGEDelphi\HGEFonts.pas',
  HGEGUI in '..\..\Component\HGEDelphi\HGEGUI.pas',
  HGERect in '..\..\Component\HGEDelphi\HGERect.pas',
  HGESounds in '..\..\Component\HGEDelphi\HGESounds.pas',
  HGESprite in '..\..\Component\HGEDelphi\HGESprite.pas',
  HGETextures in '..\..\Component\HGEDelphi\HGETextures.pas',
  HGEUtils in '..\..\Component\HGEDelphi\HGEUtils.pas',
  WIL in '..\..\Component\HGEDelphi\WIL\WIL.pas',
  wmM2Def in '..\..\Component\HGEDelphi\WIL\wmM2Def.pas',
  wmM2Wis in '..\..\Component\HGEDelphi\WIL\wmM2Wis.pas',
  wmM2Zip in '..\..\Component\HGEDelphi\WIL\wmM2Zip.pas',
  wmMyImage in '..\..\Component\HGEDelphi\WIL\wmMyImage.pas',
  FindMapPath in 'FindMapPath.pas',
  GuaJi in 'GuaJi.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  //Application.CreateForm(TFormAD, FormAD);
  {Application.CreateForm(TFrmWeb, FrmWeb);
  Application.CreateForm(TFrmDlg2, FrmDlg2);
  Application.CreateForm(TFrmDlg, FrmDlg);
  Application.CreateForm(TFrmDlg3, FrmDlg3); }
{$IFDEF DEBUG}
  Application.CreateForm(TfrmDlgConfig, frmDlgConfig);
{$ENDIF}

  //g_nThisCRC := CalcFileCRC(Application.ExeName);
  Application.Run;
end.
