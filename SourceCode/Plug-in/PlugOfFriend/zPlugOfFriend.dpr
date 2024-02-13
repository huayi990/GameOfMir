library zPlugOfFriend;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Windows,
  Classes,
  grobal2 in '..\..\Common\grobal2.pas',
  EngineType in '..\..\Common\EngineType.pas',
  EngineAPI in '..\..\Common\EngineAPI.pas',
  HUtil32 in '..\..\Common\HUtil32.pas',
  DllMain in 'DllMain.pas',
  MudUtil in '..\..\Common\MudUtil.pas';

{$R *.res}

const
  PlugName = '����ͨѶ������ (2009/04/22)';
  LoadPlus = '���غ���ͨѶ�������ɹ�...';
  InitPlus = '���ڳ�ʼ������ͨѶ������...';
  InitPlusOK = '��ʼ������ͨѶ�������ɹ�...';
  UnLoadPlus = 'ж�غ���ͨѶ�������ɹ�...';
  ProcName    = 'SetFriend';

type
  TMsgProc = procedure(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
  TFindProc = function(sProcName: PChar; nNameLen: Integer): Pointer; stdcall;
  TFindObj = function(sObjName: PChar; nNameLen: Integer): TObject; stdcall;
  TSetProc = function(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;

var
  OutMessage: TMsgProc;
  OutSetProc: TSetProc;

function Load(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc:
  TSetProc; FindOBj: TFindObj; LoadMode: Integer): PChar; stdcall;
begin
  MsgProc(LoadPlus, length(LoadPlus), LoadMode);
  OutMessage := MsgProc;
  OutSetProc := SetProc;
  OutSetProc(@SetFriend, ProcName, length(ProcName));
  LoadPlug();
  Result := PlugName;
end;

procedure UnLoad(boExit: Boolean); stdcall;
begin
  OutSetProc(nil, ProcName, length(ProcName));
  UnLoadPlug(boExit);
  OutMessage(UnLoadPlus, length(UnLoadPlus), 1);
end;

function UnModule(ModuleHookType: Integer; OldPointer, NewPointer: Pointer): Boolean; stdcall;
begin
  Result := False;
  case ModuleHookType of
    MODULE_USERLOGINEND: begin
      if @OLDUSERLOGINEND = OldPointer then begin
        OLDUSERLOGINEND := NewPointer;
        Result := True;
      end;
    end;
    MODULE_PLAYOPERATEMESSAGE: begin
      if @OLDPLAYOBJECTOPERATEMESSAGE = OldPointer then begin
        OLDPLAYOBJECTOPERATEMESSAGE := NewPointer;
        Result := True;
      end;
    end;
    MODULE_PLAYOBJECTMAKEGHOST: begin
      if @OLDMAKEGHOST = OldPointer then begin
        OLDMAKEGHOST := NewPointer;
        Result := True;
      end;
    end;
  end;
end;
{
procedure Init(LoadMode: Integer); stdcall;
begin
  OutMessage(InitPlus, length(InitPlus), LoadMode);
  //InitPlug();
  OutMessage(InitPlusOK, length(InitPlusOK), LoadMode);
end;

procedure Config(); stdcall;
begin
  //
end;   }

exports
  Load, UnLoad, UnModule{, Config, Init};

begin
end.

