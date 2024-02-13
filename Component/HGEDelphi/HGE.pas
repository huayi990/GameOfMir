unit HGE;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** Delphi conversion by Erik van Bilsen
*)

interface
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

uses
  System.Classes,
  Winapi.Windows, Winapi.D3DX9, Winapi.Direct3D9;

(****************************************************************************
 * HGE.h
 ****************************************************************************)

const
  HGE_VERSION = $160;
  IRad = 1 / 360;
  TwoPI = 2 * 3.14159265358;

const
//msgDeviceInitialize  = $100;
//msgDeviceFinalize    = $101;
  msgDeviceLost = $102;
  msgDeviceRecovered = $103;
  msgDeviceRestoreSize = $104;
//msgBeginScene        = $104;
//msgEndScene          = $105;
//msgMonoCanvasBegin   = $200;
//msgMultiCanvasBegin  = $201;

(*
** HGE Handle types
*)

type
  ITexture = interface
    ['{9D5C8783-956C-42E1-9307-CAD03DEC1E7A}']
    function GetHandle: IDirect3DTexture9;
    procedure SetHandle(const Value: IDirect3DTexture9);
    function GetWidth(const Original: Boolean = False): Integer;
    function GetHeight(const Original: Boolean = False): Integer;
    function Lock(const ReadOnly: Boolean = True; const Left: Integer = 0; const Top: Integer = 0; const Width: Integer = 0; const Height: Integer = 0): PLongword;
    procedure Unlock;
    property Handle: IDirect3DTexture9 read GetHandle write SetHandle;
  end;

type
  ITarget = interface
    ['{16FB54D6-6682-4496-82F0-4B4617FDF2D0}']
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetTex: ITexture;
    function GetTexture: ITexture;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property Tex: ITexture read GetTex;
  end;

const
  M_PI = 3.14159265358979323846;
  M_PI_2 = 1.57079632679489661923;
  M_PI_4 = 0.785398163397448309616;
  M_1_PI = 0.318309886183790671538;
  M_2_PI = 0.636619772367581343076;

(*
** Hardware color macros
*)
function ARGB(const A, R, G, B: Byte): Longword; inline;

function GetA(const Color: Longword): Byte; inline;

function GetR(const Color: Longword): Byte; inline;

function GetG(const Color: Longword): Byte; inline;

function GetB(const Color: Longword): Byte; inline;

function SetA(const Color: Longword; const A: Byte): Longword; inline;

function SetR(const Color: Longword; const A: Byte): Longword; inline;

function SetG(const Color: Longword; const A: Byte): Longword; inline;

function SetB(const Color: Longword; const A: Byte): Longword; inline;

(*
** HGE Blending constants
*)
const
  BLEND_COLORADD   = 1;
  BLEND_COLORMUL   = 0;
  BLEND_ALPHABLEND = 2;
  BLEND_ALPHAADD   = 0;
  BLEND_ZWRITE     = 4;
  BLEND_NOZWRITE   = 0;

  BLEND_DEFAULT     = BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE;
  BLEND_DEFAULT_Z   = BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_ZWRITE;

  Blend_Add              = 100;
  Blend_SrcAlpha         = 101;
  Blend_SrcAlphaAdd      = 102;
  Blend_SrcColor         = 103;
  BLEND_SrcColorAdd      = 104;
  Blend_Invert           = 105;
  Blend_SrcBright        = 106;
  Blend_Multiply         = 107;
  Blend_InvMultiply      = 108;
  Blend_MultiplyAlpha    = 109;
  Blend_InvMultiplyAlpha = 110;
  Blend_DestBright       = 111;
  Blend_InvSrcBright     = 112;
  Blend_InvDestBright    = 113;
  Blend_Bright           = 114;
  Blend_BrightAdd        = 115;
  Blend_GrayScale        = 116;
  Blend_Light            = 117;
  Blend_LightAdd         = 118;
  Blend_Add2X            = 119;
  Blend_OneColor         = 120;
  Blend_XOR              = 121;
  fxNone                 = 122;
  fxBlend                = 123;
  fxAnti                 = 124;
  fxGrayScale            = 125;
  fxBright               = 126;
  fxAspBlend             = 127;


{*
** HGE System state constants
*}
type
  THGEBoolState = (HGE_WINDOWED = 12,   // bool    run in window?    (default: false)
    HGE_ZBUFFER = 13,   // bool    use z-buffer?    (default: false)
    HGE_TEXTUREFILTER = 28,   // bool    texture filtering?  (default: true)
//  HGE_USESOUND      = 18,   // bool    use BASS for sound?  (default: true)
    HGE_DONTSUSPEND = 24,   // bool    focus lost:suspend?  (default: false)
    HGE_HIDEMOUSE = 25,   // bool    hide system cursor?  (default: true)
    HGE_SHOWSPLASH = 27,   // bool		 hide system cursor?	(default: true)
    HGE_HARDWARE = 30,   // bool
    HGEBOOLSTATE_FORCE_DWORD = $7FFFFFFF);

type
  THGEFuncState = (HGE_FRAMEFUNC = 1,    // bool*()  frame function    (default: NULL) (you MUST set this)
    HGE_RENDERFUNC = 2,    // bool*()  render function    (default: NULL)
    HGE_FOCUSLOSTFUNC = 3,    // bool*()  focus lost function  (default: NULL)
    HGE_FOCUSGAINFUNC = 4,    // bool*()  focus gain function  (default: NULL)
    HGE_GFXRESTOREFUNC = 5,    // bool*()	 exit function		(default: NULL)
    HGE_EXITFUNC = 6,    // bool*()  exit function    (default: NULL)
    HGEFUNCSTATE_FORCE_DWORD = $7FFFFFFF);

  THGEFinalizeState = (HGE_FINALIZE = 1, HGEFINALIZESTATE_FORCE_DWORD = $7FFFFFFF);

  THGEInitializeState = (HGE_INITIALIZE = 1, HGEINITIALIZESTATE_FORCE_DWORD = $7FFFFFFF);

  THGENotifyEventState = (HGE_NOTIFYEVENT = 1, HGENOTIFYEVENTSTATE_FORCE_DWORD = $7FFFFFFF);

type
  THGEHWndState = (HGE_HWND = 26,  // int    window handle: read only
    HGE_HWNDPARENT = 27,  // int    parent win handle  (default: 0)
    HGEHWNDSTATE_FORCE_DWORD = $7FFFFFFF);

type
  THGEIntState = (HGE_FScreenWidth = 9,    // int    screen width         (default: 800)
    HGE_FScreenHeight = 10,   // int    screen height        (default: 600)
    HGE_SCREENBPP = 11,   // int    screen bitdepth      (default: 32) (desktop bpp in windowed mode)
//  HGE_SAMPLERATE      = 19,   // int    sample rate          (default: 44100)
//  HGE_FXVOLUME        = 20,   // int    global fx volume     (default: 100)
//  HGE_MUSVOLUME       = 21,   // int    global music volume  (default: 100)
    HGE_FPS = 23,   // int    fixed fps            (default: HGEFPS_UNLIMITED)
    HGEINTSTATE_FORCE_DWORD = $7FFFFFF);

type
  THGEStringState = (
//  HGE_ICON        = 7,    // char*  icon resource    (default: NULL)
//  HGE_TITLE       = 8,    // char*  window title    (default: "HGE")
//  HGE_INIFILE     = 15,   // char*  ini file      (default: NULL) (meaning no file)
    HGE_LOGFILE = 16,   // char*  log file      (default: NULL) (meaning no file)
    HGESTRINGSTATE_FORCE_DWORD = $7FFFFFFF);

(*
** Callback protoype used by HGE
*)
type
  THGECallback = function: Boolean of object;

  TDeviceNotifyEvent = procedure(Sender: TObject; Msg: Cardinal) of object;

  TInitializeEvent = procedure(Sender: TObject; var Success: Boolean; var ErrorMsg: string) of object;

(*
** HGE_FPS system state special constants
*)
const
  HGEFPS_UNLIMITED = 0;
  HGEFPS_VSYNC = -1;

(*
** HGE Primitive type constants
*)
const
  HGEPRIM_LINES = 2;
  HGEPRIM_TRIPLES = 3;
  HGEPRIM_QUADS = 4;

(*
** HGE Vertex structure
*)
type
  THGEVertex = record
    X, Y: Single;   // screen position
    Z: Single;      // Z-buffer depth 0..1
    Col: Longword;  // color
    TX, TY: Single; // texture coordinates
  end;

  PHGEVertex = ^THGEVertex;

  THGEVertexArray = array[0..MaxInt div 32 - 1] of THGEVertex;

  PHGEVertexArray = ^THGEVertexArray;

(*
** HGE Triple structure
*)
type
  THGETriple = record
    V: array[0..2] of THGEVertex;
    Tex: ITexture;
    Blend: Integer;
  end;

  PHGETriple = ^THGETriple;

(*
** HGE Quad structure
*)
type
  THGEQuad = record
    V: array[0..3] of THGEVertex;
    Tex: ITexture;
    Blend: Integer;
  end;

  PHGEQuad = ^THGEQuad;

(*
** HGE Input Event structure
*)
type
  THGEInputEvent = record
    EventType: Integer;  // event type
    Key: Integer;        // key code
    Flags: Integer;      // event flags
    Chr: Integer;        // character code
    Wheel: Integer;      // wheel shift
    X: Single;           // mouse cursor x-coordinate
    Y: Single;           // mouse cursor y-coordinate
  end;

(*
** HGE Input Event type constants
*)
const
  INPUT_KEYDOWN = 1;
  INPUT_KEYUP = 2;
  INPUT_MBUTTONDOWN = 3;
  INPUT_MBUTTONUP = 4;
  INPUT_MOUSEMOVE = 5;
  INPUT_MOUSEWHEEL = 6;

(*
** HGE Input Event flags
*)
const
  HGEINP_SHIFT = 1;
  HGEINP_CTRL = 2;
  HGEINP_ALT = 4;
  HGEINP_CAPSLOCK = 8;
  HGEINP_SCROLLLOCK = 16;
  HGEINP_NUMLOCK = 32;
  HGEINP_REPEAT = 64;

type
  IHGE = interface
    ['{14AD0876-19A5-4B13-B2D8-46ECE1E336BA}']
    function System_Initiate: Boolean;
    procedure System_Shutdown;
    function System_Start: Boolean;
    function System_GetErrorMessage: string;
    procedure System_Log(const S: string); overload;
    procedure System_Log(const Format: string; const Args: array of const); overload;
//  function System_Launch(const Url: String): Boolean;
    procedure System_Snapshot(const Filename: string);
    procedure System_SetState(const State: THGEBoolState; const Value: Boolean); overload;
    procedure System_SetState(const State: THGEFuncState; const Value: THGECallback); overload;
    procedure System_SetState(const State: THGEHWndState; const Value: HWnd); overload;
    procedure System_SetState(const State: THGEIntState; const Value: Integer); overload;
    procedure System_SetState(const State: THGEStringState; const Value: string); overload;
    procedure System_SetState(const State: THGEInitializeState; const Value: TInitializeEvent); overload;
    procedure System_SetState(const State: THGEFinalizeState; const Value: TNotifyEvent); overload;
    procedure System_SetState(const State: THGENotifyEventState; const Value: TDeviceNotifyEvent); overload;
    function System_GetState(const State: THGEBoolState): Boolean; overload;
    function System_GetState(const State: THGEFuncState): THGECallback; overload;
    function System_GetState(const State: THGEHWndState): HWnd; overload;
    function System_GetState(const State: THGEIntState): Integer; overload;
    function System_GetState(const State: THGEStringState): string; overload;
    function System_GetState(const State: THGEInitializeState): TInitializeEvent; overload;
    function System_GetState(const State: THGEFinalizeState): TNotifyEvent; overload;
    function System_GetState(const State: THGENotifyEventState): TDeviceNotifyEvent; overload;
    procedure Ini_SetInt(const Section, Name: string; const Value: Integer);
    function Ini_GetInt(const Section, Name: string; const DefVal: Integer = 0): Integer;
    procedure Ini_SetFloat(const Section, Name: string; const Value: Single);
    function Ini_GetFloat(const Section, Name: string; const DefVal: Single): Single;
    procedure Ini_SetString(const Section, Name, Value: string);
    function Ini_GetString(const Section, Name, DefVal: string): string;
    procedure Random_Seed(const Seed: Integer = 0);
    function Random_Int(const Min, Max: Integer): Integer;
    function Random_Float(const Min, Max: Single): Single;
    function Timer_GetTime: Single;
    function Timer_GetDelta: Single;
    function Timer_GetFPS: Integer;
    function Gfx_CanBegin(): Boolean;
    function Gfx_BeginScene(const Target: ITarget = nil): Boolean;
    procedure Gfx_EndScene;
    procedure Gfx_Clear(const Color: Longword);
    procedure Gfx_DrawPolygon(const Vertex: array of THGEVertex; Tex: ITexture; BlendMode: Integer = BLEND_Default);
    procedure Gfx_RenderLine(const X1, Y1, X2, Y2: Single; const Color: Longword = $FFFFFFFF; const Z: Single = 0.5);
    procedure Gfx_RenderCircle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_Default);
    procedure Gfx_RenderTriangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderEllipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderArc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderLine2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
    procedure Gfx_RenderQuadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderPolygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderSquareSchedule(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderTriple(const Triple: THGETriple);
    procedure Gfx_RenderQuad(const Quad: THGEQuad);
    function Gfx_StartBatch(const PrimType: Integer; const Tex: ITexture; const Blend: Integer; out MaxPrim: Integer): PHGEVertexArray;
    procedure Gfx_FinishBatch(const NPrim: Integer);
    procedure Gfx_SetClipping(X: Integer = 0; Y: Integer = 0; W: Integer = 0; H: Integer = 0);
    procedure Gfx_SetTransform(const X: Single = 0; const Y: Single = 0; const DX: Single = 0; const DY: Single = 0; const Rot: Single = 0; const HScale: Single = 0; const VScale: Single = 0);
    function Target_Create(const Width, Height: Integer; const ZBuffer: Boolean): ITarget;
    function Target_GetTexture(const Target: ITarget): ITexture;
    function Texture_Create(const Width, Height: Integer): ITexture; overload;
    function Texture_Create(const Width, Height: Integer; Pool: TD3DPool; Format: TD3DFormat): ITexture; overload;
    function Texture_Create(const Width, Height: Integer; Tex: IDirect3DTexture9): ITexture; overload;
    function Texture_GetWidth(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_GetHeight(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_Lock(const Tex: ITexture; const ReadOnly: Boolean = True; const Left: Integer = 0; const Top: Integer = 0; const Width: Integer = 0; const Height: Integer = 0): PLongword;
    procedure Texture_Unlock(const Tex: ITexture);
    procedure Gfx_Restore(nWidth, nHeight, nBitCount: Integer);
    procedure RenderBatch(const EndScene: Boolean = False);
    function GetCurPrimType: Integer;
    procedure SetCurPrimType(const Value: Integer);
    procedure SetBlendMode(const Blend: Integer);
    function GetD3DDevice: IDirect3DDevice9;
    function GetD3D: IDirect3D9;
    procedure CopyVertices(pVertices: PByte; numVertices: integer);
    function GetVertArray: PHGEVertexArray;
    function GetCurTexture: ITexture;
    procedure SetCurTexture(const Value: ITexture);
    property CurTexture: ITexture read GetCurTexture write SetCurTexture;
    property CurPrimType: Integer read GetCurPrimType write SetCurPrimType;
    function GetD3DCaps: PD3DCaps9;
    property D3DCaps: PD3DCaps9 read GetD3DCaps;
    function GetAvailableTextureMem: Integer;
    property AvailableTextureMem: Integer read GetAvailableTextureMem;
  end;

function HGECreate(const Ver: Integer): IHGE;

(*
** HGE Virtual-key codes
*)
const
  HGEK_LBUTTON = $01;
  HGEK_RBUTTON = $02;
  HGEK_MBUTTON = $04;
  HGEK_ESCAPE = $1B;
  HGEK_BACKSPACE = $08;
  HGEK_TAB = $09;
  HGEK_ENTER = $0D;
  HGEK_SPACE = $20;
  HGEK_SHIFT = $10;
  HGEK_CTRL = $11;
  HGEK_ALT = $12;
  HGEK_LWIN = $5B;
  HGEK_RWIN = $5C;
  HGEK_APPS = $5D;
  HGEK_PAUSE = $13;
  HGEK_CAPSLOCK = $14;
  HGEK_NUMLOCK = $90;
  HGEK_SCROLLLOCK = $91;
  HGEK_PGUP = $21;
  HGEK_PGDN = $22;
  HGEK_HOME = $24;
  HGEK_END = $23;
  HGEK_INSERT = $2D;
  HGEK_DELETE = $2E;
  HGEK_LEFT = $25;
  HGEK_UP = $26;
  HGEK_RIGHT = $27;
  HGEK_DOWN = $28;
  HGEK_0 = $30;
  HGEK_1 = $31;
  HGEK_2 = $32;
  HGEK_3 = $33;
  HGEK_4 = $34;
  HGEK_5 = $35;
  HGEK_6 = $36;
  HGEK_7 = $37;
  HGEK_8 = $38;
  HGEK_9 = $39;
  HGEK_A = $41;
  HGEK_B = $42;
  HGEK_C = $43;
  HGEK_D = $44;
  HGEK_E = $45;
  HGEK_F = $46;
  HGEK_G = $47;
  HGEK_H = $48;
  HGEK_I = $49;
  HGEK_J = $4A;
  HGEK_K = $4B;
  HGEK_L = $4C;
  HGEK_M = $4D;
  HGEK_N = $4E;
  HGEK_O = $4F;
  HGEK_P = $50;
  HGEK_Q = $51;
  HGEK_R = $52;
  HGEK_S = $53;
  HGEK_T = $54;
  HGEK_U = $55;
  HGEK_V = $56;
  HGEK_W = $57;
  HGEK_X = $58;
  HGEK_Y = $59;
  HGEK_Z = $5A;
  HGEK_GRAVE = $C0;
  HGEK_MINUS = $BD;
  HGEK_EQUALS = $BB;
  HGEK_BACKSLASH = $DC;
  HGEK_LBRACKET = $DB;
  HGEK_RBRACKET = $DD;
  HGEK_SEMICOLON = $BA;
  HGEK_APOSTROPHE = $DE;
  HGEK_COMMA = $BC;
  HGEK_PERIOD = $BE;
  HGEK_SLASH = $BF;
  HGEK_NUMPAD0 = $60;
  HGEK_NUMPAD1 = $61;
  HGEK_NUMPAD2 = $62;
  HGEK_NUMPAD3 = $63;
  HGEK_NUMPAD4 = $64;
  HGEK_NUMPAD5 = $65;
  HGEK_NUMPAD6 = $66;
  HGEK_NUMPAD7 = $67;
  HGEK_NUMPAD8 = $68;
  HGEK_NUMPAD9 = $69;
  HGEK_MULTIPLY = $6A;
  HGEK_DIVIDE = $6F;
  HGEK_ADD = $6B;
  HGEK_SUBTRACT = $6D;
  HGEK_DECIMAL = $6E;
  HGEK_F1 = $70;
  HGEK_F2 = $71;
  HGEK_F3 = $72;
  HGEK_F4 = $73;
  HGEK_F5 = $74;
  HGEK_F6 = $75;
  HGEK_F7 = $76;
  HGEK_F8 = $77;
  HGEK_F9 = $78;
  HGEK_F10 = $79;
  HGEK_F11 = $7A;
  HGEK_F12 = $7B;

implementation

uses
  Messages, Math, MMSystem, ShellAPI, SysUtils, Types, ZLib
  {,D3DX81mo, ZipUtils, UnZip};

const
  CRLF = #13#10;

(****************************************************************************
 * HGE.h - Macro implementations
 ****************************************************************************)

function ARGB(const A, R, G, B: Byte): Longword; inline;
begin
  Result := (A shl 24) or (R shl 16) or (G shl 8) or B;
end;

function GetA(const Color: Longword): Byte; inline;
begin
  Result := Color shr 24;
end;

function GetR(const Color: Longword): Byte; inline;
begin
  Result := (Color shr 16) and $FF;
end;

function GetG(const Color: Longword): Byte; inline;
begin
  Result := (Color shr 8) and $FF;
end;

function GetB(const Color: Longword): Byte; inline;
begin
  Result := Color and $FF;
end;

function SetA(const Color: Longword; const A: Byte): Longword; inline;
begin
  Result := (Color and $00FFFFFF) or (A shl 24);
end;

function SetR(const Color: Longword; const A: Byte): Longword; inline;
begin
  Result := (Color and $FF00FFFF) or (A shl 16);
end;

function SetG(const Color: Longword; const A: Byte): Longword; inline;
begin
  Result := (Color and $FFFF00FF) or (A shl 8);
end;

function SetB(const Color: Longword; const A: Byte): Longword; inline;
begin
  Result := (Color and $FFFFFF00) or A;
end;

(****************************************************************************
 * HGE_Impl.h
 ****************************************************************************)

{.$DEFINE DEMO}

const
  D3DFVF_HGEVERTEX = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;
  VERTEX_BUFFER_SIZE = 4000;
  ShaderCode = 'ps_1_1'#13#10 + 'def c0, 0, 1, 0, 0'#13#10 + 'def c1, 1, 0, 0, 0'#13#10 + 'def c2, 0.333333343, 0.333333343, 0.333333343, 0'#13#10 + 'tex t0'#13#10 +                                             //2018.12.31 着色器灰度计算
    'dp3 r0, c0, t0'#13#10 + 'dp3 r1, c1, t0'#13#10 + 'add r0.w, r0.w, r1.w'#13#10 + 'add r0.w, t0.z, r0.w'#13#10 + 'mov r1.w, t0.w'#13#10 + '+ mul r1.xyz, r0.w, c2'#13#10 + 'mov r0, r1';

type
  PResourceList = ^TResourceList;

  TResourceList = record
    Filename: string;
//  Password: String; // NOTE: ZIP passwords are not supported in Delphi version
    Next: PResourceList;
  end;

type
  PInputEventList = ^TInputEventList;

  TInputEventList = record
    Event: THGEInputEvent;
    Next: PInputEventList;
  end;

(*
** HGE Interface implementation
*)
type
  THGEImpl = class(TInterfacedObject, IHGE)
  protected
    { IHGE }
    function System_Initiate: Boolean;
    procedure System_Shutdown;
    function System_Start: Boolean;
    function System_GetErrorMessage: string;
    procedure System_Log(const S: string); overload;
    procedure System_Log(const Format: string; const Args: array of const); overload;
//  function System_Launch(const Url: String): Boolean;
    procedure System_Snapshot(const Filename: string);
    procedure System_SetState(const State: THGEBoolState; const Value: Boolean); overload;
    procedure System_SetState(const State: THGEFuncState; const Value: THGECallback); overload;
    procedure System_SetState(const State: THGEHWndState; const Value: HWnd); overload;
    procedure System_SetState(const State: THGEIntState; const Value: Integer); overload;
    procedure System_SetState(const State: THGEStringState; const Value: string); overload;
    procedure System_SetState(const State: THGEInitializeState; const Value: TInitializeEvent); overload;
    procedure System_SetState(const State: THGEFinalizeState; const Value: TNotifyEvent); overload;
    procedure System_SetState(const State: THGENotifyEventState; const Value: TDeviceNotifyEvent); overload;
    function System_GetState(const State: THGEBoolState): Boolean; overload;
    function System_GetState(const State: THGEFuncState): THGECallback; overload;
    function System_GetState(const State: THGEHWndState): HWnd; overload;
    function System_GetState(const State: THGEIntState): Integer; overload;
    function System_GetState(const State: THGEStringState): string; overload;
    function System_GetState(const State: THGEInitializeState): TInitializeEvent; overload;
    function System_GetState(const State: THGEFinalizeState): TNotifyEvent; overload;
    function System_GetState(const State: THGENotifyEventState): TDeviceNotifyEvent; overload;
    procedure Ini_SetInt(const Section, Name: string; const Value: Integer);
    function Ini_GetInt(const Section, Name: string; const DefVal: Integer = 0): Integer;
    procedure Ini_SetFloat(const Section, Name: string; const Value: Single);
    function Ini_GetFloat(const Section, Name: string; const DefVal: Single): Single;
    procedure Ini_SetString(const Section, Name, Value: string);
    function Ini_GetString(const Section, Name, DefVal: string): string;
    procedure Random_Seed(const Seed: Integer = 0);
    function Random_Int(const Min, Max: Integer): Integer;
    function Random_Float(const Min, Max: Single): Single;
    function Timer_GetTime: Single;
    function Timer_GetDelta: Single;
    function Timer_GetFPS: Integer;
    function Gfx_CanBegin(): Boolean;
    function Gfx_BeginScene(const Target: ITarget = nil): Boolean;
    procedure Gfx_EndScene;
    procedure Gfx_Clear(const Color: Longword);
    procedure Gfx_DrawPolygon(const Vertex: array of THGEVertex; Tex: ITexture; BlendMode: Integer = BLEND_Default);
    procedure Gfx_RenderLine(const X1, Y1, X2, Y2: Single; const Color: Longword = $FFFFFFFF; const Z: Single = 0.5);
    procedure Gfx_RenderCircle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_Default);
    procedure Gfx_RenderTriangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderEllipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderArc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderLine2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
    procedure Gfx_RenderQuadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderPolygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderSquareSchedule(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderTriple(const Triple: THGETriple);
    procedure Gfx_RenderQuad(const Quad: THGEQuad);
    function Gfx_StartBatch(const PrimType: Integer; const Tex: ITexture; const Blend: Integer; out MaxPrim: Integer): PHGEVertexArray;
    procedure Gfx_FinishBatch(const NPrim: Integer);
    procedure Gfx_SetClipping(X: Integer = 0; Y: Integer = 0; W: Integer = 0; H: Integer = 0);
    procedure Gfx_SetTransform(const X: Single = 0; const Y: Single = 0; const DX: Single = 0; const DY: Single = 0; const Rot: Single = 0; const HScale: Single = 0; const VScale: Single = 0);
    function Target_Create(const Width, Height: Integer; const ZBuffer: Boolean): ITarget;
    function Target_GetTexture(const Target: ITarget): ITexture;
    function Texture_Create(const Width, Height: Integer): ITexture; overload;
    function Texture_Create(const Width, Height: Integer; Pool: TD3DPool; Format: TD3DFormat): ITexture; overload;
    function Texture_Create(const Width, Height: Integer; Tex: IDirect3DTexture9): ITexture; overload;
    function Texture_GetWidth(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_GetHeight(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_Lock(const Tex: ITexture; const ReadOnly: Boolean = True; const Left: Integer = 0; const Top: Integer = 0; const Width: Integer = 0; const Height: Integer = 0): PLongword;
    procedure Texture_Unlock(const Tex: ITexture);
    procedure Gfx_Restore(nWidth, nHeight, nBitCount: Integer);


    { Extensions }
    procedure RenderBatch(const EndScene: Boolean = False);
    procedure SetBlendMode(const Blend: Integer);
    function GetD3DDevice: IDirect3DDevice9;
    function GetD3D: IDirect3D9;
    procedure CopyVertices(pVertices: PByte; numVertices: integer);
    function GetVertArray: PHGEVertexArray;
    function GetCurPrimType: Integer;
    procedure SetCurPrimType(const Value: Integer);
    function GetCurTexture: ITexture;
    procedure SetCurTexture(const Value: ITexture);
    function GetD3DCaps: PD3DCaps9;
    function GetAvailableTextureMem: Integer;
  private
//////// Implementation ////////
//  FInstance: THandle;
//  FWnd: HWnd;
    FAvailableTextureMem: LongWord;
    FD3DCaps: TD3DCaps9;
    FActive: Boolean;
    FError: string;
//  FAppPath: String;
    FFormatSettings: TFormatSettings;


//  procedure FocusChange(const Act: Boolean);
    procedure PostError(const Error: string);
    class function InterfaceGet: THGEImpl;
  private
//  Extensions

  private
//  System States
    FProcFrameFunc: THGECallback;
    FProcRenderFunc: THGECallback;
    FProcFocusLostFunc: THGECallback;
    FProcFocusGainFunc: THGECallback;
    FProcGfxRestoreFunc: THGECallback;
    FProcExitFunc: THGECallback;
    FOnFinalize: TNotifyEvent;
    FOnInitialize: TInitializeEvent;
    FOnNotifyEvent: TDeviceNotifyEvent;
//  FIcon: String;
//  FWinTitle: String;
    FScreenWidth: Integer;
    FScreenHeight: Integer;
    FScreenBPP: Integer;
    FWindowed: Boolean;
    FZBuffer: Boolean;
    FTextureFilter: Boolean;
    FIniFile: string;
    FLogFile: string;
    FUseSound: Boolean;
    FHGEFPS: Integer;
    FHideMouse: Boolean;
    FHardwareTL: Boolean;
    FDontSuspend: Boolean;
    FWndParent: HWnd;
  private
    FD3DPP: PD3DPresentParameters;
    FD3DPPW: TD3DPresentParameters;
    FD3DPPFS: TD3DPresentParameters;
    FD3D: IDirect3D9;
    FD3DDevice: IDirect3DDevice9;
    FVB: IDirect3DVertexBuffer9;
    FIB: IDirect3DIndexBuffer9;
    FScreenSurf: IDirect3DSurface9;
    FScreenDepth: IDirect3DSurface9;
    FTargets: TList;
    FCurTarget: ITarget;
    FMatView: TD3DXMatrix;
    FMatProj: TD3DXMatrix;
    FVertArray: PHGEVertexArray;
    FPrim: Integer;
    FCurPrimType: Integer;
    FCurBlendMode: Integer;
    FCurTexture: ITexture;
   //增加麻痹效果
    FPixelShaderBuffer: ID3DXBuffer;
    FPixelShader: IDirect3DPixelShader9;
    function GfxInit: Boolean;
    procedure GfxDone;
    function GfxRestore: Boolean;
    procedure GfxUpdateParameters;
    function InitLost: Boolean;
    function FormatId(const Fmt: TD3DFormat): Integer;
    procedure SetProjectionMatrix(const Width, Height: Integer);
  private
    FSearch: TSearchRec;
  private
//  Timer
    FTime: Single;
    FDeltaTime: Single;
    FFixedDelta: Longword;
    FFPS: Integer;
    FT0, FT0FPS, FDT: Longword;
    FCFPS: Integer;
  private
    constructor Create;
  public
    destructor Destroy; override;
  end;

var
  PHGE: THGEImpl = nil;

type
  IInternalTarget = interface(ITarget)
    ['{579FDCE5-3D0C-403F-9B58-44117B226A26}']
    function GetDepth: IDirect3DSurface9;
    procedure Restore;
    procedure Lost;
    property Depth: IDirect3DSurface9 read GetDepth;
  end;

type
  TTexture = class(TInterfacedObject, ITexture)
  private
    FHandle: IDirect3DTexture9;
    FOriginalWidth: Integer;
    FOriginalHeight: Integer;
  protected
    { ITexture }
    function GetHandle: IDirect3DTexture9;
    procedure SetHandle(const Value: IDirect3DTexture9);
    function GetWidth(const Original: Boolean = False): Integer;
    function GetHeight(const Original: Boolean = False): Integer;
    function Lock(const ReadOnly: Boolean = True; const Left: Integer = 0; const Top: Integer = 0; const Width: Integer = 0; const Height: Integer = 0): PLongword;
    procedure Unlock;
  public
    constructor Create(const AHandle: IDirect3DTexture9; const AOriginalWidth, AOriginalHeight: Integer);
  end;

type
  TTarget = class(TInterfacedObject, ITarget, IInternalTarget)
  private
    FWidth: Integer;
    FHeight: Integer;
    FTex: ITexture;
    FDepth: IDirect3DSurface9;
  protected
    { ITarget }
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetTex: ITexture;
    function GetTexture: ITexture;
    { IInternalTarget }
    function GetDepth: IDirect3DSurface9;
    procedure Restore;
    procedure Lost;
  public
    constructor Create(const AWidth, AHeight: Integer; const ATex: ITexture; const ADepth: IDirect3DSurface9);
    destructor Destroy; override;
  end;

{ TTexture }

constructor TTexture.Create(const AHandle: IDirect3DTexture9; const AOriginalWidth, AOriginalHeight: Integer);
begin
  inherited Create;
  FHandle := AHandle;
  FOriginalWidth := AOriginalWidth;
  FOriginalHeight := AOriginalHeight;
end;

function TTexture.GetHandle: IDirect3DTexture9;
begin
  Result := FHandle;
end;

function TTexture.GetHeight(const Original: Boolean): Integer;
var
  Desc: TD3DSurfaceDesc;
begin
  if (Original) then
    Result := FOriginalHeight
  else if (Succeeded(FHandle.GetLevelDesc(0, Desc))) then
    Result := Desc.Height
  else
    Result := 0;
end;

function TTexture.GetWidth(const Original: Boolean): Integer;
var
  Desc: TD3DSurfaceDesc;
begin
  if (Original) then
    Result := FOriginalWidth
  else if (Succeeded(FHandle.GetLevelDesc(0, Desc))) then
    Result := Desc.Width
  else
    Result := 0;
end;

function TTexture.Lock(const ReadOnly: Boolean; const Left, Top, Width, Height: Integer): PLongword;
var
  Desc: TD3DSurfaceDesc;
  Rect: TD3DLockedRect;
  Region: TRect;
  PRec: PRect;
  Flags: Integer;
begin
  Result := nil;
  FHandle.GetLevelDesc(0, Desc);
  if (Desc.Format <> D3DFMT_A8R8G8B8) and (Desc.Format <> D3DFMT_X8R8G8B8) then
    Exit;

  if (Width <> 0) and (Height <> 0) then
  begin
    Region.Left := Left;
    Region.Top := Top;
    Region.Right := Left + Width;
    Region.Bottom := Top + Height;
    PRec := @Region;
  end
  else
    PRec := nil;

  if (ReadOnly) then
    Flags := D3DLOCK_READONLY
  else
    Flags := 0;

  if (Failed(FHandle.LockRect(0, Rect, PRec, Flags))) then
    PHGE.PostError('Can''t lock texture')
  else
    Result := Rect.pBits;
end;

procedure TTexture.SetHandle(const Value: IDirect3DTexture9);
begin
  FHandle := Value;
end;

procedure TTexture.Unlock;
begin
  FHandle.UnlockRect(0);
end;

constructor TTarget.Create(const AWidth, AHeight: Integer; const ATex: ITexture; const ADepth: IDirect3DSurface9);
begin
  inherited Create;
  FWidth := AWidth;
  FHeight := AHeight;
  FTex := ATex;
  FDepth := ADepth;
  PHGE.FTargets.Add(Self);
end;

destructor TTarget.Destroy;
begin
  PHGE.FTargets.Remove(Self);
  inherited;
end;

function TTarget.GetDepth: IDirect3DSurface9;
begin
  Result := FDepth;
end;

function TTarget.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TTarget.GetTex: ITexture;
begin
  Result := FTex;
end;

function TTarget.GetTexture: ITexture;
begin
  Result := FTex;
end;

function TTarget.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TTarget.Lost;
var
  DXTexture: IDirect3DTexture9;
begin
  if not Assigned(FTex) then
  begin
    D3DXCreateTexture(PHGE.FD3DDevice, FWidth, FHeight, 1, D3DUSAGE_RENDERTARGET, PHGE.FD3DPP.BackBufferFormat, D3DPOOL_DEFAULT, DXTexture);
    FTex := TTexture.Create(DXTexture, FWidth, FHeight);
  end;
  if not Assigned(FDepth) then
    PHGE.FD3DDevice.CreateDepthStencilSurface(FWidth, FHeight, D3DFMT_D16, D3DMULTISAMPLE_NONE, 0, false, FDepth, nil);
end;

procedure TTarget.Restore;
begin
  if FTex <> nil then
    FTex.Handle := nil;
  FTex := nil;
  FDepth := nil;
end;

var
  GSeed: Longword = 0;

function LoWordInt(const N: Longword): Integer; inline;
begin
  Result := Smallint(LoWord(N));
end;

function HiWordInt(const N: Longword): Integer; inline;
begin
  Result := Smallint(HiWord(N));
end;

function HGECreate(const Ver: Integer): IHGE;
begin
  if (Ver = HGE_VERSION) then
  begin
    Result := THGEImpl.InterfaceGet;
  end
  else
    Result := nil;
end;

procedure THGEImpl.CopyVertices(pVertices: PByte; numVertices: integer);
var
  pVB: PByte;
begin
  FD3DDevice.SetVertexShader(nil);
  FD3DDevice.SetFVF(D3DFVF_HGEVERTEX);
  FVB.Lock(0, SizeOf(THGEVertex) * numVertices, Pointer(pVB), 0);
  Move(pVertices^, pVB^, Sizeof(THGEVertex) * numVertices);
  FVB.Unlock;
  FD3DDevice.SetStreamSource(0, FVB, 0, Sizeof(THGEVertex));
end;

constructor THGEImpl.Create;
begin
  inherited;
//FInstance := GetModuleHandle(nil);
  FActive := False;
  FHGEFPS := HGEFPS_VSYNC;
//FWinTitle := 'HGE';
  FScreenWidth := 800;
  FScreenHeight := 600;
  FScreenBPP := 32;
  FTextureFilter := True;
  FUseSound := True;
//FSampleRate := 44100;
//FFXVolume := 100;
//FMusVolume := 100;
  FHideMouse := True;
  FHardwareTL := True;
  FZBuffer := False;
//GetModuleFileName(FInstance,P,MAX_PATH);
//FAppPath := ExtractFilePath(P);
  FSearch.FindHandle := INVALID_HANDLE_VALUE;
  FTargets := TList.Create;
//GetLocaleFormatSettings(GetThreadLocale,FFormatSettings);   //2007
  TFormatSettings.Create(GetThreadLocale); //XE
  FTargets := TList.Create;
  FFormatSettings.DecimalSeparator := '.';
  FFormatSettings.ThousandSeparator := ',';
  FProcFrameFunc := nil;
  FProcRenderFunc := nil;
  FProcFocusLostFunc := nil;
  FProcFocusGainFunc := nil;
  FProcGfxRestoreFunc := nil;
  FProcExitFunc := nil;
  FOnFinalize := nil;
  FOnInitialize := nil;
  FOnNotifyEvent := nil;
  FAvailableTextureMem := 0;
  FillChar(FD3DCaps, SizeOf(FD3DCaps), #0);
  D3DXAssembleShader(ShaderCode, Length(ShaderCode), nil, nil, 0, @FPixelShaderBuffer, nil); //2018.12.31 着色器灰度
end;

destructor THGEImpl.Destroy;
begin
//if (FWnd <> 0) then begin
  System_Shutdown;
//Resource_RemoveAllPacks;
  PHGE := nil;
//end;
  FTargets.Free;
  inherited;
end;

function THGEImpl.FormatId(const Fmt: TD3DFormat): Integer;
begin
  case Fmt of
    D3DFMT_R5G6B5:
      Result := 1;
    D3DFMT_X1R5G5B5:
      Result := 2;
    D3DFMT_A1R5G5B5:
      Result := 3;
    D3DFMT_X8R8G8B8:
      Result := 4;
    D3DFMT_A8R8G8B8:
      Result := 5;
  else
    Result := 0;
  end;
end;

function THGEImpl.GetAvailableTextureMem: Integer;
begin
  Result := FAvailableTextureMem;
end;

function THGEImpl.GetD3DCaps: PD3DCaps9;
begin
  Result := @FD3DCaps;
end;

function THGEImpl.GetCurPrimType: Integer;
begin
  Result := FCurPrimType;
end;

function THGEImpl.GetCurTexture: ITexture;
begin
  Result := FCurTexture;
end;

function THGEImpl.GetD3D: IDirect3D9;
begin
  Result := FD3D;
end;

function THGEImpl.GetD3DDevice: IDirect3DDevice9;
begin
  Result := FD3DDevice;
end;

function THGEImpl.GetVertArray: PHGEVertexArray;
begin
  Result := FVertArray;
end;

procedure THGEImpl.GfxDone;
begin
  if Assigned(FOnFinalize) then
    FOnFinalize(Self);

  FScreenSurf := nil;
  FScreenDepth := nil;
  FTargets.Clear;

  if Assigned(FIB) then
  begin
    FD3DDevice.SetIndices(nil);
    FIB := nil;
  end;
  if Assigned(FVB) then
  begin
    if Assigned(FVertArray) then
    begin
      FVB.Unlock;
      FVertArray := nil;
    end;
    FD3DDevice.SetStreamSource(0, nil, SizeOf(THGEVertex), 0);
    FVB := nil;
  end;
  FD3DDevice := nil;
  FD3D := nil;
end;

function THGEImpl.GfxInit: Boolean;
const
  Formats: array[0..5] of string = ('UNKNOWN', 'R5G6B5', 'X1R5G5B5', 'A1R5G5B5', 'X8R8G8B8', 'A8R8G8B8');
var
  AdID: TD3DAdapterIdentifier9;
  Mode: TD3DDisplayMode;
  Format: TD3DFormat;
  NModes, I: Longword;
begin
  Result := False;
  Format := D3DFMT_UNKNOWN;

// Init D3D
  if FWndParent = 0 then
  begin
    PostError('Windows handle is null');
    Exit;
  end;

  FD3D := Direct3DCreate9(D3D_SDK_VERSION); // 120 or D3D_SDK_VERSION
  if (FD3D = nil) then
  begin
    PostError('Can''t create D3D interface');
    Exit;
  end;

// Get adapter info

  FD3D.GetAdapterIdentifier(D3DADAPTER_DEFAULT, 0, AdID);
  System_Log('D3D Driver: %s', [AdID.Driver]);
  System_Log('Description: %s', [AdID.Description]);

  if (Failed(FD3D.GetAdapterDisplayMode(D3DADAPTER_DEFAULT, Mode))) or (Mode.Format = D3DFMT_UNKNOWN) then
  begin
    PostError('Can''t determine desktop video mode');
    if (FWindowed) then
      Exit;
  end;

  ZeroMemory(@FD3DPPW, SizeOf(FD3DPPW));

  FD3DPPW.BackBufferWidth := FScreenWidth;
  FD3DPPW.BackBufferHeight := FScreenHeight;
  FD3DPPW.BackBufferFormat := Mode.Format;
  FD3DPPW.BackBufferCount := 1;
  FD3DPPW.MultiSampleType := D3DMULTISAMPLE_NONE;
  FD3DPPW.hDeviceWindow := FWndParent;
  FD3DPPW.Windowed := True;
//FD3DPPW.Flags            := D3DPRESENTFLAG_LOCKABLE_BACKBUFFER;

  if (FHGEFPS = HGEFPS_VSYNC) then
  begin
    FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY;
    Fd3dppW.PresentationInterval := D3DPRESENT_INTERVAL_DEFAULT;
  end
  else
    FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY;

  if (FZBuffer) then
  begin
    FD3DPPW.EnableAutoDepthStencil := True;
    FD3DPPW.AutoDepthStencilFormat := D3DFMT_D16;
  end;

// Set up Full Screen presentation parameters

  NModes := FD3D.GetAdapterModeCount(D3DADAPTER_DEFAULT, Mode.format);
  for I := 0 to NModes - 1 do
  begin
    FD3D.EnumAdapterModes(D3DADAPTER_DEFAULT, Mode.Format, I, Mode);
    if (Integer(Mode.Width) <> FScreenWidth) or (Integer(Mode.Height) <> FScreenHeight) then
      Continue;
    if (FScreenBPP = 16) and (FormatId(Mode.Format) > FormatId(D3DFMT_A1R5G5B5)) then
      Continue;
    if (FormatId(Mode.Format) > FormatId(Format)) then
      Format := Mode.Format;
  end;
  if (Format = D3DFMT_UNKNOWN) then
  begin
    PostError('Can''t find appropriate full screen video mode');
    if (not FWindowed) then
      Exit;
  end;

  ZeroMemory(@FD3DPPFS, SizeOf(FD3DPPFS));

  FD3DPPFS.BackBufferWidth := FScreenWidth;
  FD3DPPFS.BackBufferHeight := FScreenHeight;
  FD3DPPFS.BackBufferFormat := Format;
  FD3DPPFS.BackBufferCount := 1;
  FD3DPPFS.MultiSampleType := D3DMULTISAMPLE_NONE;
  FD3DPPFS.hDeviceWindow := FWndParent;
  FD3DPPFS.Windowed := False;
  FD3DPPFS.Flags := D3DPRESENTFLAG_LOCKABLE_BACKBUFFER;

  FD3DPPFS.SwapEffect := D3DSWAPEFFECT_FLIP;
  FD3DPPFS.FullScreen_RefreshRateInHz := D3DPRESENT_RATE_DEFAULT;
  if (FHGEFPS = HGEFPS_VSYNC) then
    FD3DPPFS.PresentationInterval := D3DPRESENT_INTERVAL_ONE
  else
    FD3DPPFS.PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;

  if (FZBuffer) then
  begin
    FD3DPPFS.EnableAutoDepthStencil := True;
    FD3DPPFS.AutoDepthStencilFormat := D3DFMT_D16;
  end;

  if (FWindowed) then
    FD3DPP := @FD3DPPW
  else
    FD3DPP := @FD3DPPFS;

  if (FormatId(FD3DPP.BackBufferFormat) < 4) then
    FScreenBPP := 16
  else
    FScreenBPP := 32;

  if (Failed(FD3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, FWndParent, D3DCREATE_SOFTWARE_VERTEXPROCESSING, FD3DPP, FD3DDevice))) then
  begin
    PostError('Can''t create D3D device');
    Exit;
  end;

  FD3DDevice.SetDialogBoxMode(true);

  FAvailableTextureMem := FD3DDevice.GetAvailableTextureMem;
  FD3DDevice.GetDeviceCaps(FD3DCaps);
//AdjustWindow;
  System_Log('Mode: %d x %d x %s' + CRLF, [FScreenWidth, FScreenHeight, Formats[FormatId(Format)]]);

// Create vertex batch buffer

  FVertArray := nil;

// Init all stuff that can be lost

  SetProjectionMatrix(FScreenWidth, FScreenHeight);
  D3DXMatrixIdentity(FMatView);

  if (not InitLost) then
    Exit;

  Gfx_Clear(0);

  Result := True;
end;

procedure THGEImpl.GfxUpdateParameters;
const
  Formats: array[0..5] of string = ('UNKNOWN', 'R5G6B5', 'X1R5G5B5', 'A1R5G5B5', 'X8R8G8B8', 'A8R8G8B8');
var
  Mode: TD3DDisplayMode;
  Format: TD3DFormat;
  NModes, I: Longword;
begin

  if FWindowed then
  begin
    FD3DPP := @FD3DPPW;
    if (Failed(FD3D.GetAdapterDisplayMode(D3DADAPTER_DEFAULT, Mode))) or (Mode.Format = D3DFMT_UNKNOWN) then
    begin
      PostError('Can''t determine desktop video mode');
      Exit;
    end;
    FD3DPP.BackBufferFormat := Mode.Format;
  end
  else
  begin
    FD3DPP := @FD3DPPFS;
    Format := D3DFMT_UNKNOWN;
    NModes := FD3D.GetAdapterModeCount(D3DADAPTER_DEFAULT, Mode.Format);
    for I := 0 to NModes - 1 do
    begin
      FD3D.EnumAdapterModes(D3DADAPTER_DEFAULT, Mode.Format, I, Mode);
      if (Integer(Mode.Width) <> FScreenWidth) or (Integer(Mode.Height) <> FScreenHeight) then
        Continue;
      if (FScreenBPP = 16) and (FormatId(Mode.Format) > FormatId(D3DFMT_A1R5G5B5)) then
        Continue;
      if (FormatId(Mode.Format) > FormatId(Format)) then
        Format := Mode.Format;
    end;
    if (Format = D3DFMT_UNKNOWN) then
    begin
      PostError('Can''t find appropriate full screen video mode');
      Exit;
    end;
    FD3DPP.BackBufferFormat := Format;
  end;
  FD3DPP.BackBufferWidth := FScreenWidth;
  FD3DPP.BackBufferHeight := FScreenHeight;
end;

function THGEImpl.GfxRestore: Boolean;
var
  I: Integer;
  Target: TTarget;
begin

  Result := False;
  if (FD3DDevice = nil) then
    Exit;
  if Assigned(FOnNotifyEvent) then
    FOnNotifyEvent(Self, msgDeviceLost);

  FScreenSurf := nil;
  FScreenDepth := nil;

  for I := 0 to FTargets.Count - 1 do
  begin
    Target := TTarget(FTargets[I]);
    Target.Restore;
  end;

  if Assigned(FIB) then
  begin
    FD3DDevice.SetIndices(nil);
    FIB := nil;
  end;
  if Assigned(FVB) then
  begin
    FD3DDevice.SetStreamSource(0, nil, 0, SizeOf(THGEVertex));
    FVB := nil;
  end;

  GfxUpdateParameters;

  FD3DDevice.Reset(FD3DPP^);

  SetProjectionMatrix(FScreenWidth, FScreenHeight);
  D3DXMatrixIdentity(FMatView);

  if (not InitLost) then
    Exit;

  if Assigned(FOnNotifyEvent) then
    FOnNotifyEvent(Self, msgDeviceRecovered);

  if Assigned(FProcGfxRestoreFunc) then
    Result := FProcGfxRestoreFunc
  else
    Result := True;
end;

function THGEImpl.Gfx_CanBegin(): Boolean; //检测设备是否丢失
var
  HR: HResult;
begin
  Result := False;
 //2018.12.31 着色器灰度         就这里不一样。
  if Assigned(FPixelShader) then
    FPixelShader := nil;
  FD3DDevice.CreatePixelShader(FPixelShaderBuffer.GetBufferPointer, FPixelShader);

  HR := FD3DDevice.TestCooperativeLevel; //说明设备丢失了
  if (HR = D3DERR_DEVICELOST) then
    Exit;

  if (HR = D3DERR_DEVICENOTRESET) then begin
    if (not GfxRestore) then  //进行重置
      Exit;
  end;

  Result := True;
end;

function THGEImpl.Gfx_BeginScene(const Target: ITarget): Boolean;
var
  Surf, Depth: IDirect3DSurface9;
begin
  Result := False;

  if not Gfx_CanBegin then
    Exit;

  if Assigned(FVertArray) then
  begin
    PostError('Gfx_BeginScene: Scene is already being rendered');
    Exit;
  end;

  if (Target <> FCurTarget) then
  begin
    if Assigned(Target) then
    begin
      Target.Tex.Handle.GetSurfaceLevel(0, Surf);
      Depth := (Target as IInternalTarget).Depth;
    end
    else
    begin
      Surf := FScreenSurf;
      Depth := FScreenDepth;
    end;
    if (Failed(FD3DDevice.SetRenderTarget(0, Surf))) then
    begin
      PostError('Gfx_BeginScene: Can''t set render target');
      Exit;
    end;
    if Assigned(Target) then
    begin
      Surf := nil;
      if Assigned((Target as IInternalTarget).Depth) then
        FD3DDevice.SetRenderState(D3DRS_ZENABLE, D3DZB_TRUE)
      else
        FD3DDevice.SetRenderState(D3DRS_ZENABLE, D3DZB_FALSE);
      SetProjectionMatrix(Target.Width, Target.Height);
    end
    else
    begin
      if (FZBuffer) then
        FD3DDevice.SetRenderState(D3DRS_ZENABLE, D3DZB_TRUE)
      else
        FD3DDevice.SetRenderState(D3DRS_ZENABLE, D3DZB_FALSE);
      SetProjectionMatrix(FScreenWidth, FScreenHeight);
    end;

    FD3DDevice.SetTransform(D3DTS_PROJECTION, FMatProj);
    D3DXMatrixIdentity(FMatView);
    FD3DDevice.SetTransform(D3DTS_VIEW, FMatView);

    FCurTarget := Target;
  end;
  FD3DDevice.BeginScene;
  FVB.Lock(0, 0, Pointer(FVertArray), 0);
  Result := True;
end;

procedure THGEImpl.Gfx_Clear(const Color: Longword);
begin
  if Assigned(FCurTarget) then
  begin
    if Assigned((FCurTarget as IInternalTarget).Depth) then
      FD3DDevice.Clear(0, nil, D3DCLEAR_TARGET {or D3DCLEAR_ZBUFFER}, Color, 1.0, 0) //DX9进房间边缘花屏问题修复
    else
      FD3DDevice.Clear(0, nil, D3DCLEAR_TARGET, Color, 1.0, 0);
  end else begin
    if (FZBuffer) then
      FD3DDevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, Color, 1.0, 0)
    else
      FD3DDevice.Clear(0, nil, D3DCLEAR_TARGET, Color, 1.0, 0);
  end;
end;

procedure THGEImpl.Gfx_EndScene;
begin
  RenderBatch(True);
  FD3DDevice.EndScene;
  if (FCurTarget = nil) then
    FD3DDevice.Present(nil, nil, 0, nil);
end;

procedure THGEImpl.Gfx_FinishBatch(const NPrim: Integer);
begin
  FPrim := NPrim;
end;

procedure THGEImpl.Gfx_RenderArc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer);
var
  Max, I: Integer;
  Ic, IInc: Single;
begin
  if Assigned(FVertArray) then
  begin
    if Radius > 1000 then
      Radius := 1000;

    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    Max := Round(Radius);
    IInc := 1 / Max;
    IInc := IInc * (EndRadius - StartRadius) * IRad;
    Ic := StartRadius * IRad;

    FVertArray[0].X := X;
    FVertArray[0].Y := Y;
    FVertArray[0].Col := Color;
    for I := 1 to Max + 1 do
    begin
      FVertArray[I].X := X + Radius * Cos(Ic * TwoPI);
      FVertArray[I].Y := Y + Radius * Sin(Ic * TwoPI);
      FVertArray[I].Col := Color;
      Ic := Ic + IInc;
    end;

    if DrawStartEnd then
      I := 0
    else
      I := 1;

    if (FCurTexture <> nil) then
    begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if not Filled then begin
      FVertArray[0].X := FVertArray[Max + 1].X;
      FVertArray[0].Y := FVertArray[Max + 1].Y;
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, I, Max + (1 - I));
    end else begin
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderCircle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  Max, I: Integer;
  Ic, IInc: Single;
begin
  if Assigned(FVertArray) then
  begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    if Radius > 1000 then
      Radius := 1000;
    Max := Round(Radius);
    IInc := 1 / Max;
    Ic := 0;

    FVertArray[0].X := X;
    FVertArray[0].Y := Y;
    FVertArray[0].col := Color;
    for I := 1 to Max + 1 do
    begin
      FVertArray[I].X := X + Radius * Cos(Ic * TwoPI);
      FVertArray[I].Y := Y + Radius * Sin(Ic * TwoPI);
      FVertArray[I].col := Color;
      Ic := Ic + IInc;
    end;

    if (FCurTexture <> nil) then
    begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;
    if not Filled then begin
      FVertArray[0].X := FVertArray[Max + 1].X;
      FVertArray[0].Y := FVertArray[Max + 1].Y;
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, Max + 1);
    end else begin
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderEllipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  Max, I: Integer;
  Ic, IInc: Single;
begin
  if Assigned(FVertArray) then
  begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    if R1 > 1000 then
      R1 := 1000;
    Max := Round(R1);
    IInc := 1 / Max;
    Ic := 0;

    FVertArray[0].X := X;
    FVertArray[0].Y := Y;
    FVertArray[0].Col := Color;
    for I := 1 to Max + 1 do
    begin
      FVertArray[I].X := X + R1 * Cos(Ic * TwoPI);
      FVertArray[I].Y := Y + R2 * Sin(Ic * TwoPI);
      FVertArray[I].Col := Color;
      Ic := Ic + IInc;
    end;

    if (FCurTexture <> nil) then
    begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if not Filled then
    begin
      FVertArray[0].X := FVertArray[Max + 1].X;
      FVertArray[0].Y := FVertArray[Max + 1].Y;
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, Max + 1);
    end else begin
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderLine(const X1, Y1, X2, Y2: Single; const Color: Longword; const Z: Single);
var
  I: Integer;
begin
  if Assigned(FVertArray) then
  begin
    if (FCurPrimType <> HGEPRIM_LINES) or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_LINES) or (FCurTexture <> nil) or (FCurBlendMode <> BLEND_DEFAULT) then
    begin
      RenderBatch;
      FCurPrimType := HGEPRIM_LINES;
      if (FCurBlendMode <> BLEND_DEFAULT) then
        SetBlendMode(BLEND_DEFAULT);
      if (FCurTexture <> nil) then
      begin
        FD3DDevice.SetTexture(0, nil);
        FCurTexture := nil;
      end;
    end;

    I := FPrim * HGEPRIM_LINES;
    FVertArray[I].X := X1;
    FVertArray[I + 1].X := X2;
    FVertArray[I].Y := Y1;
    FVertArray[I + 1].Y := Y2;
    FVertArray[I].Z := Z;
    FVertArray[I + 1].Z := Z;
    FVertArray[I].Col := Color;
    FVertArray[I + 1].Col := Color;
    FVertArray[I].TX := 0;
    FVertArray[I + 1].TX := 0;
    FVertArray[I].TY := 0;
    FVertArray[I + 1].TY := 0;

    Inc(FPrim);
  end;
end;

procedure THGEImpl.Gfx_RenderLine2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
begin
  if Assigned(FVertArray) then
  begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    FVertArray[0].X := X1;
    FVertArray[0].Y := Y1;
    FVertArray[0].Col := Color1;
    FVertArray[1].X := X2;
    FVertArray[1].Y := Y2;
    FVertArray[1].Col := Color2;
    if (FCurTexture <> nil) then
    begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;
    CopyVertices(@FVertArray^, 2);
    FD3DDevice.DrawPrimitive(D3DPT_LINELIST, 0, 1);
  end;
end;

procedure THGEImpl.Gfx_RenderSquareSchedule(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
var
  I: Integer;
begin
  if Assigned(FVertArray) then
  begin
    RenderBatch;
    FCurPrimType := HGEPRIM_TRIPLES;
    SetBlendMode(BlendMode);

    for I := 0 to NumPoints - 1 do
    begin
      FVertArray[I].X := Points[I].X;
      FVertArray[I].Y := Points[I].Y;
      FVertArray[I].Col := Color;
    end;

    if (FCurTexture <> nil) then
    begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    CopyVertices(@FVertArray^, NumPoints);
    FD3DDevice.DrawPrimitive(D3DPT_TRIANGLELIST, 0, NumPoints div 3);
  end;
end;

procedure THGEImpl.Gfx_RenderPolygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  I: Integer;
begin
  if Assigned(FVertArray) then
  begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    for I := 0 to NumPoints - 1 do
    begin
      FVertArray[I].X := Points[I].X;
      FVertArray[I].Y := Points[I].Y;
      FVertArray[I].Col := Color;
    end;

    if (FCurTexture <> nil) then
    begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;
    if Filled then
    begin
      CopyVertices(@FVertArray^, NumPoints);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, NumPoints - 2);
    end
    else
    begin
      FVertArray[NumPoints].X := Points[0].X;
      FVertArray[NumPoints].Y := Points[0].Y;
      FVertArray[NumPoints].Col := Color;
      CopyVertices(@FVertArray^, NumPoints + 1);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, NumPoints);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderQuad(const Quad: THGEQuad);
begin
  if Assigned(FVertArray) then
  begin
    if (FCurPrimType <> HGEPRIM_QUADS) or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_QUADS) or (FCurTexture <> Quad.Tex) or (FCurBlendMode <> Quad.Blend) then
    begin
      RenderBatch;
      FCurPrimType := HGEPRIM_QUADS;
      if (FCurBlendMode <> Quad.Blend) then
        SetBlendMode(Quad.Blend);
      if (Quad.Tex <> FCurTexture) then
      begin
        if Assigned(Quad.Tex) then
          FD3DDevice.SetTexture(0, Quad.Tex.Handle)
        else
          FD3DDevice.SetTexture(0, nil);
        FCurTexture := Quad.Tex;
      end;
    end;

    Move(Quad.V, FVertArray[FPrim * HGEPRIM_QUADS], SizeOf(THGEVertex) * HGEPRIM_QUADS);
    Inc(FPrim);
  end;
end;

procedure THGEImpl.Gfx_RenderQuadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  pX: Integer;
begin
  if Assigned(FVertArray) then
  begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    //修复矩形少一个角
    pX := 0;
    if not Filled then
      pX := 1;

    FVertArray[0].X := X1 - pX;
    FVertArray[0].Y := Y1;
    FVertArray[0].Col := Color1;
    FVertArray[1].X := X2;
    FVertArray[1].Y := Y2;
    FVertArray[1].Col := Color2;
    FVertArray[2].X := X3;
    FVertArray[2].Y := Y3;
    FVertArray[2].Col := Color3;
    FVertArray[3].X := X4;
    FVertArray[3].Y := Y4;
    FVertArray[3].Col := Color4;

    if (FCurTexture <> nil) then
    begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if Filled then  //填满
    begin
      CopyVertices(@FVertArray^, 4);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, 2);
    end
    else
    begin
      FVertArray[4].X := X1 - pX;
      FVertArray[4].Y := Y1;
      FVertArray[4].Col := Color1;
      CopyVertices(@FVertArray^, 5);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, 4);
    end;
  end;
end;

procedure THGEImpl.Gfx_DrawPolygon(const Vertex: array of THGEVertex; Tex: ITexture; BlendMode: Integer = BLEND_Default);
var
  nCount: Integer;
begin
  if Assigned(FVertArray) then
  begin
    nCount := Length(Vertex);
    if nCount > 0 then
    begin
      RenderBatch;
      FCurPrimType := HGEPRIM_TRIPLES;
      if (FCurBlendMode <> BlendMode) then
        SetBlendMode(BlendMode);

      if (Tex <> FCurTexture) then
      begin
        if Assigned(Tex) then
          FD3DDevice.SetTexture(0, Tex.Handle)
        else
          FD3DDevice.SetTexture(0, nil);
        FCurTexture := Tex;
      end;

      Move(Vertex[0], FVertArray[0], SizeOf(THGEVertex) * nCount);
      Inc(FPrim, nCount div 3);

      RenderBatch;
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderTriangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  if Assigned(FVertArray) then
  begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    FVertArray[0].X := X1;
    FVertArray[0].Y := Y1;
    FVertArray[0].Col := Color;
    FVertArray[1].X := X2;
    FVertArray[1].Y := Y2;
    FVertArray[1].Col := Color;
    FVertArray[2].X := X3;
    FVertArray[2].Y := Y3;
    FVertArray[2].Col := Color;

    if (FCurTexture <> nil) then
    begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if Filled then
    begin
      CopyVertices(@FVertArray^, 3);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLELIST, 0, 1);
    end
    else
    begin
      FVertArray[3].X := X1;
      FVertArray[3].Y := Y1;
      FVertArray[3].Col := Color;
      CopyVertices(@FVertArray^, 4);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, 3);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderTriple(const Triple: THGETriple);
begin
  if Assigned(FVertArray) then
  begin
    if (FCurPrimType <> HGEPRIM_TRIPLES) or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_TRIPLES) or (FCurTexture <> Triple.Tex) or (FCurBlendMode <> Triple.Blend) then
    begin
      RenderBatch;
      FCurPrimType := HGEPRIM_TRIPLES;
      if (FCurBlendMode <> Triple.Blend) then
        SetBlendMode(Triple.Blend);
      if (Triple.Tex <> FCurTexture) then
      begin
        if Assigned(Triple.Tex) then
          FD3DDevice.SetTexture(0, Triple.Tex.Handle)
        else
          FD3DDevice.SetTexture(0, nil);
        FCurTexture := Triple.Tex;
      end;
    end;

    Move(Triple.V, FVertArray[FPrim * HGEPRIM_TRIPLES], SizeOf(THGEVertex) * HGEPRIM_TRIPLES);
    Inc(FPrim);
  end;
end;

procedure THGEImpl.Gfx_Restore(nWidth, nHeight, nBitCount: Integer);
begin
  if (FScreenWidth <> nWidth) or (FScreenHeight <> nHeight) then
  begin
    FScreenWidth := nWidth;
    FScreenHeight := nHeight;
    GfxRestore;
    if Assigned(FOnNotifyEvent) then
      FOnNotifyEvent(Self, msgDeviceRestoreSize);
  end;
end;

procedure THGEImpl.Gfx_SetClipping(X, Y, W, H: Integer);
var
  VP: TD3DViewport9;
  ScrWidth, ScrHeight: Integer;
  Tmp: TD3DXMATRIX;
begin
  if (FCurTarget = nil) then begin
    ScrWidth := PHGE.System_GetState(HGE_FScreenWidth);
    ScrHeight := PHGE.System_GetState(HGE_FScreenHeight);
  end else begin
    ScrWidth := Texture_GetWidth(FCurTarget.Tex);
    ScrHeight := Texture_GetHeight(FCurTarget.Tex);
  end;

  if (W = 0) then begin
    VP.X := 0;
    VP.Y := 0;
    VP.Width := ScrWidth;
    VP.Height := ScrHeight;
  end else begin
    if (X < 0) then
    begin
      Inc(W, X);
      X := 0;
    end;
    if (Y < 0) then
    begin
      Inc(H, Y);
      Y := 0;
    end;

    if (X + W > ScrWidth) then
      W := ScrWidth - X;
    if (Y + H > ScrHeight) then
      H := ScrHeight - Y;

    VP.X := X;
    VP.Y := Y;
    VP.Width := W;
    VP.Height := H;
  end;

  VP.MinZ := 0.0;
  VP.MaxZ := 1.0;

  RenderBatch;
  FD3DDevice.SetViewport(VP);

  D3DXMatrixScaling(FMatProj, 1.0, -1.0, 1.0);
  D3DXMatrixTranslation(Tmp, -0.5, +0.5, 0.0);
  D3DXMatrixMultiply(FMatProj, FMatProj, Tmp);
  D3DXMatrixOrthoOffCenterLH(Tmp, VP.X, VP.X + VP.Width, -(VP.Y + VP.Height), -VP.Y, VP.MinZ, VP.MaxZ);
  D3DXMatrixMultiply(FMatProj, FMatProj, Tmp);
  FD3DDevice.SetTransform(D3DTS_PROJECTION, FMatProj);
end;

procedure THGEImpl.Gfx_SetTransform(const X, Y, DX, DY, Rot, HScale, VScale: Single);
var
  Tmp: TD3DXMATRIX;
begin
  if (VScale = 0.0) then begin
    D3DXMatrixIdentity(FMatView)
  end else begin
    D3DXMatrixTranslation(FMatView, -X, -Y, 0.0);
    D3DXMatrixScaling(Tmp, HScale, VScale, 1.0);
    D3DXMatrixMultiply(FMatView, FMatView, Tmp);
    D3DXMatrixRotationZ(Tmp, -Rot);
    D3DXMatrixMultiply(FMatView, FMatView, Tmp);
    D3DXMatrixTranslation(Tmp, X + DX, Y + DY, 0.0);
    D3DXMatrixMultiply(FMatView, FMatView, Tmp);
  end;

  RenderBatch;
  FD3DDevice.SetTransform(D3DTS_VIEW, FMatView);
end;

function THGEImpl.Gfx_StartBatch(const PrimType: Integer; const Tex: ITexture; const Blend: Integer; out MaxPrim: Integer): PHGEVertexArray;
begin
  if Assigned(FVertArray) then
  begin
    RenderBatch;

    FCurPrimType := PrimType;
    if (FCurBlendMode <> Blend) then
      SetBlendMode(Blend);
    if (Tex <> FCurTexture) then
    begin
      if Assigned(Tex) then
        FD3DDevice.SetTexture(0, Tex.Handle)
      else
        FD3DDevice.SetTexture(0, nil);
      FCurTexture := Tex;
    end;

    MaxPrim := VERTEX_BUFFER_SIZE div PrimType;
    Result := FVertArray;
  end
  else
    Result := nil;
end;

function THGEImpl.InitLost: Boolean;
var
  Target: TTarget;
  PIndices: PWord;
  N: Word;
  I: Integer;
begin
  Result := False;

// Store render target

  FScreenSurf := nil;
  FScreenDepth := nil;

  FD3DDevice.GetRenderTarget(0, FScreenSurf);
  FD3DDevice.GetDepthStencilSurface(FScreenDepth);

  for I := 0 to FTargets.Count - 1 do
  begin
    Target := TTarget(FTargets[I]);
    Target.Lost;
  end;

// Create Vertex buffer

  if (Failed(FD3DDevice.CreateVertexBuffer(VERTEX_BUFFER_SIZE * SizeOf(THGEVertex), D3DUSAGE_WRITEONLY, D3DFVF_HGEVERTEX, D3DPOOL_DEFAULT, FVB, nil))) then
  begin
    PostError('Can''t create D3D vertex buffer');
    Exit;
  end;

  FD3DDevice.SetVertexShader(nil);
  FD3DDevice.SetFVF(D3DFVF_HGEVERTEX);
  FD3DDevice.SetStreamSource(0, FVB, 0, SizeOf(THGEVertex));

// Create and setup Index buffer

  if (Failed(FD3DDevice.CreateIndexBuffer(VERTEX_BUFFER_SIZE * 6 div 4 * SizeOf(Word), D3DUSAGE_WRITEONLY, D3DFMT_INDEX16, D3DPOOL_DEFAULT, FIB, nil))) then
  begin
    PostError('Can''t create D3D index buffer');
    Exit;
  end;

  N := 0;
  if (Failed(FIB.Lock(0, 0, Pointer(PIndices), 0))) then
  begin
    PostError('Can''t lock D3D index buffer');
    Exit;
  end;

  for I := 0 to (VERTEX_BUFFER_SIZE div 4) - 1 do
  begin
    PIndices^ := N;
    Inc(PIndices);
    PIndices^ := N + 1;
    Inc(PIndices);
    PIndices^ := N + 2;
    Inc(PIndices);
    PIndices^ := N + 2;
    Inc(PIndices);
    PIndices^ := N + 3;
    Inc(PIndices);
    PIndices^ := N;
    Inc(PIndices);
    Inc(N, 4);
  end;

  FIB.Unlock;
  FD3DDevice.SetIndices(FIB);

//Set common render states

//pD3DDevice->SetRenderState( D3DRS_LASTPIXEL, FALSE );
  FD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
  FD3DDevice.SetRenderState(D3DRS_LIGHTING, 0);

  FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, 1);
  FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
  FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);

  FD3DDevice.SetRenderState(D3DRS_ALPHATESTENABLE, 1);
  FD3DDevice.SetRenderState(D3DRS_ALPHAREF, 1);
  FD3DDevice.SetRenderState(D3DRS_ALPHAFUNC, D3DCMP_GREATEREQUAL);

  FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
  FD3DDevice.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
  FD3DDevice.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

  FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
  FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
  FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

  FD3DDevice.SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_POINT);

  if (FTextureFilter) then
  begin
    FD3DDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
    FD3DDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
  end
  else
  begin
    FD3DDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_POINT);
    FD3DDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_POINT);
  end;

  FPrim := 0;
  FCurPrimType := HGEPRIM_QUADS;
  FCurBlendMode := BLEND_DEFAULT;
  FCurTexture := nil;

  FD3DDevice.SetTransform(D3DTS_VIEW, FMatView);
  FD3DDevice.SetTransform(D3DTS_PROJECTION, FMatProj);

  Result := True;
end;

function THGEImpl.Ini_GetFloat(const Section, Name: string; const DefVal: Single): Single;
var
  Buf: array[0..255] of Char;
begin
  Result := DefVal;
  if (FIniFile <> '') then
    if (GetPrivateProfileString(PChar(Section), PChar(Name), '', Buf, 255, PChar(FIniFile)) <> 0) then
      Result := StrToFloatDef(Buf, DefVal, FFormatSettings);
end;

function THGEImpl.Ini_GetInt(const Section, Name: string; const DefVal: Integer): Integer;
var
  Buf: array[0..255] of Char;
begin
  Result := DefVal;
  if (FIniFile <> '') then
    if (GetPrivateProfileString(PChar(Section), PChar(Name), '', Buf, 255, PChar(FIniFile)) <> 0) then
      Result := StrToIntDef(Buf, DefVal);
end;

function THGEImpl.Ini_GetString(const Section, Name, DefVal: string): string;
var
  Buf: array[0..255] of Char;
begin
  Result := DefVal;
  if (FIniFile <> '') then
    if (GetPrivateProfileString(PChar(Section), PChar(Name), '', Buf, 255, PChar(FIniFile)) <> 0) then
      Result := Buf;
end;

procedure THGEImpl.Ini_SetFloat(const Section, Name: string; const Value: Single);
begin
  if (FIniFile <> '') then
    WritePrivateProfileString(PChar(Section), PChar(Name), PChar(FloatToStrF(Value, ffGeneral, 7, 0, FFormatSettings)), PChar(FIniFile));
end;

procedure THGEImpl.Ini_SetInt(const Section, Name: string; const Value: Integer);
begin
  if (FIniFile <> '') then
    WritePrivateProfileString(PChar(Section), PChar(Name), PChar(IntToStr(Value)), PChar(FIniFile));
end;

procedure THGEImpl.Ini_SetString(const Section, Name, Value: string);
begin
  if (FIniFile <> '') then
    WritePrivateProfileString(PChar(Section), PChar(Name), PChar(Value), PChar(FIniFile));
end;

class function THGEImpl.InterfaceGet: THGEImpl;
begin
  if (PHGE = nil) then
    PHGE := THGEImpl.Create;
  Result := PHGE;
end;

procedure THGEImpl.PostError(const Error: string);
begin
  System_Log(Error);
  FError := Error;
end;

function THGEImpl.Random_Float(const Min, Max: Single): Single;
begin
  GSeed := 214013 * GSeed + 2531011;
  //return min+g_seed*(1.0f/4294967295.0f)*(max-min);
  Result := Min + (GSeed shr 16) * (1.0 / 65535.0) * (Max - Min);
end;

function THGEImpl.Random_Int(const Min, Max: Integer): Integer;
begin
  GSeed := 214013 * GSeed + 2531011;
  Result := Min + Integer((GSeed xor GSeed shr 15) mod Cardinal(Max - Min + 1));
end;

procedure THGEImpl.Random_Seed(const Seed: Integer);
begin
  if (Seed = 0) then
    GSeed := timeGetTime
  else
    GSeed := Seed;
end;

procedure THGEImpl.RenderBatch(const EndScene: Boolean);
begin
  if (FPrim = 0) and (not EndScene) then
    Exit;
  if Assigned(FVertArray) then
  begin
    FVB.Unlock;
    if (FPrim <> 0) then
    begin
      case FCurPrimType of
        HGEPRIM_QUADS:
          FD3DDevice.DrawIndexedPrimitive(D3DPT_TRIANGLELIST, 0, 0, FPrim shl 2, 0, FPrim shl 1);
        HGEPRIM_TRIPLES:
          FD3DDevice.DrawPrimitive(D3DPT_TRIANGLELIST, 0, FPrim);
        HGEPRIM_LINES:
          FD3DDevice.DrawPrimitive(D3DPT_LINELIST, 0, FPrim);
      end;

      FPrim := 0;
    end;

    if (EndScene) then
      FVertArray := nil
    else
      FVB.Lock(0, 0, Pointer(FVertArray), 0);
  end;
end;

procedure THGEImpl.SetBlendMode(const Blend: Integer);
begin

  FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
  FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
  if Blend_GrayScale = Blend then
  begin  //2018.12.31 着色器灰度
//    with FD3DDevice do
//      begin
//        SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
//        SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
//        SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
//        SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
//      end;
    //设置灰度 这句不能少否则没效果
    FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
    FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
    FD3DDevice.SetPixelShader(FPixelShader);
  end
  else
  begin
    FD3DDevice.SetPixelShader(nil);
    case Blend of
      Blend_Default:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
        end;
      Blend_ColorAdd:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
          FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_ADD);
        end;
      Blend_Add:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);

        end;
      Blend_SrcAlphaAdd:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
        end;
      Blend_SrcColor:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
        end;
      BLEND_SrcColorAdd:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
        end;
      Blend_Invert:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ZERO);
        end;
      Blend_SrcBright:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCCOLOR);
        end;
      Blend_Multiply:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCCOLOR);
        end;
      Blend_InvMultiply:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
        end;
      Blend_MultiplyAlpha:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCALPHA);
        end;
      Blend_InvMultiplyAlpha:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
        end;
      Blend_DestBright:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_DESTCOLOR);
        end;
      Blend_InvSrcBright:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVSRCCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
        end;
      Blend_InvDestBright:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVDESTCOLOR);
        end;
      Blend_Bright:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
          FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
        end;
      Blend_BrightAdd:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
          FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE4X);
        end;
      Blend_Light:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
          FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
        end;
      Blend_LightAdd:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
          FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE4X);
        end;
      Blend_Add2X:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
          FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
        end;
      Blend_OneColor:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
          FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, 25);
          FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
        end;
      Blend_XOR:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
          FD3DDEvice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
        end;
      fxNone:
        begin
          FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ZERO);
          FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
        end;
      fxBlend:
        begin
          FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
//        FD3DDevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
        end;
      fxAnti:
        begin
          FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
//        FD3DDevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
        end;
      fxBright:
        begin
          FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
          FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
        end;
      fxAspBlend:
        begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
          FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
          FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
        end;
//      fxgaoliang:
//        begin  //测试
//          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
//          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
//          FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
//          FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
//        end;
    end;
  end;
  FCurBlendMode := Blend;
end;

procedure THGEImpl.SetCurPrimType(const Value: Integer);
begin
  FCurPrimType := Value;
end;

procedure THGEImpl.SetCurTexture(const Value: ITexture);
begin
  FCurTexture := Value;
end;

procedure THGEImpl.SetProjectionMatrix(const Width, Height: Integer);
var
  Tmp: TD3DXMatrix;
begin
  D3DXMatrixScaling(FMatProj, 1.0, -1.0, 1.0);
  D3DXMatrixTranslation(Tmp, -0.5, Height + 0.5, 0.0);
  D3DXMatrixMultiply(FMatProj, FMatProj, Tmp);
  D3DXMatrixOrthoOffCenterLH(Tmp, 0, Width, 0, Height, 0.0, 1.0);
  D3DXMatrixMultiply(FMatProj, FMatProj, Tmp);
end;

function THGEImpl.System_GetErrorMessage: string;
begin
  Result := FError;
end;

function THGEImpl.System_GetState(const State: THGEStringState): string;
begin
  case State of
    {HGE_ICON:
      Result := FIcon;
    HGE_TITLE:
      Result := FWinTitle; }
    {HGE_INIFILE:
      Result := FIniFile;}
    HGE_LOGFILE:
      Result := FLogFile;
  else
    Result := '';
  end;
end;

function THGEImpl.System_GetState(const State: THGEIntState): Integer;
begin
  case State of
    HGE_FScreenWidth:
      Result := FScreenWidth;
    HGE_FScreenHeight:
      Result := FScreenHeight;
    HGE_SCREENBPP:
      Result := FScreenBPP;
    {HGE_SAMPLERATE:
      Result := FSampleRate;  }
    {HGE_FXVOLUME:
      Result := FFXVolume;
    HGE_MUSVOLUME:
      Result := FMusVolume;  }
    HGE_FPS:
      Result := FHGEFPS;
  else
    Result := 0;
  end;
end;

function THGEImpl.System_GetState(const State: THGEFuncState): THGECallback;
begin
  case State of
    HGE_FRAMEFUNC:
      Result := FProcFrameFunc;
    HGE_RENDERFUNC:
      Result := FProcRenderFunc;
    HGE_FOCUSLOSTFUNC:
      Result := FProcFocusLostFunc;
    HGE_FOCUSGAINFUNC:
      Result := FProcFocusGainFunc;
    HGE_EXITFUNC:
      Result := FProcExitFunc;
  else
    Result := nil;
  end;
end;

function THGEImpl.System_GetState(const State: THGEBoolState): Boolean;
begin
  case State of
    HGE_WINDOWED:
      Result := FWindowed;
    HGE_ZBUFFER:
      Result := FZBuffer;
    HGE_TEXTUREFILTER:
      Result := FTextureFilter;
    {HGE_USESOUND:
      Result := FUseSound;  }
    HGE_DONTSUSPEND:
      Result := FDontSuspend;
    HGE_HIDEMOUSE:
      Result := FHideMouse;
    HGE_HARDWARE:
      Result := FHardwareTL;
  else
    Result := False;
  end;
end;

function THGEImpl.System_GetState(const State: THGEHWndState): HWnd;
begin
  case State of
    {HGE_HWND:
      Result := FWnd;  }
    HGE_HWNDPARENT:
      Result := FWndParent;
  else
    Result := 0;
  end;
end;

function THGEImpl.System_Initiate: Boolean;
var
  OSVer: TOSVersionInfo;
  TM: TSystemTime;
  MemSt: TMemoryStatus;
//WinClass: TWndClass;
//Width, Height: Integer;
  boSuccess: Boolean;
  sErrorMsg: string;
begin
  Result := False;
//Log system info
  System_Log('HGE Started..' + CRLF);
  System_Log('HGE version: %x.%x', [HGE_VERSION shr 8, HGE_VERSION and $FF]);
  GetLocalTime(TM);
  System_Log('Date: %02d.%02d.%d, %02d:%02d:%02d' + CRLF, [TM.wDay, TM.wMonth, TM.wYear, TM.wHour, TM.wMinute, TM.wSecond]);

//System_Log('Application: %s',[FWinTitle]);
  OSVer.dwOSVersionInfoSize := SizeOf(OSVer);
  GetVersionEx(OSVer);
  System_Log('OS: Windows %d.%d.%d', [OSVer.dwMajorVersion, OSVer.dwMinorVersion, OSVer.dwBuildNumber]);

  GlobalMemoryStatus(MemSt);
  System_Log('Memory: %dK total, %dK free' + CRLF, [MemSt.dwTotalPhys div 1024, MemSt.dwAvailPhys div 1024]);

  TimeBeginPeriod(1);
  Random_Seed;
  //InputInit;
  if (not GfxInit) then
  begin
    System_Shutdown;
    Exit;
  end;
  {if (not SoundInit) then begin
    System_Shutdown;
    Exit;
  end;   }
  boSuccess := True;
  sErrorMsg := '';
  if Assigned(FOnInitialize) then
    FOnInitialize(Self, boSuccess, sErrorMsg);

  if not boSuccess then
  begin
    PostError('Can''t Initialize (' + sErrorMsg + ')');
    System_Shutdown;
    Exit;
  end;

  System_Log('Init done.' + CRLF);

  FTime := 0.0;
  FT0 := timeGetTime;
  FT0FPS := FT0;
  FDT := 0;
  FCFPS := 0;
  FFPS := 0;

//Show splash

//Done

  Result := True;
end;

procedure THGEImpl.System_Log(const S: string);
begin
  System_Log(S, []);
end;

procedure THGEImpl.System_Log(const Format: string; const Args: array of const);
var
  HF: THandle;
  S: string;
  BytesWritten: Cardinal;
begin
  if (FLogFile = '') then
    Exit;

  HF := CreateFile(PChar(FLogFile), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if (HF = 0) then
    Exit;
  try
    SetFilePointer(HF, 0, nil, FILE_END);
    S := SysUtils.Format(Format, Args) + CRLF;
    WriteFile(HF, S[1], Length(S), BytesWritten, nil);
  finally
    CloseHandle(HF);
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEStringState; const Value: string);
begin
  case State of

    HGE_LOGFILE:


  end;
end;

procedure THGEImpl.System_SetState(const State: THGEIntState; const Value: Integer);
begin
  case State of
    HGE_FScreenWidth:
      if (FD3DDevice = nil) then
        FScreenWidth := Value;
    HGE_FScreenHeight:
      if (FD3DDevice = nil) then
        FScreenHeight := Value;
    HGE_SCREENBPP:
//    if (FD3DDevice = nil) then
      FScreenBPP := Value;
    {HGE_SAMPLERATE:
      if(FBass = 0) then
        FSampleRate := Value;  }
    {HGE_FXVOLUME:
      begin
        FFXVolume := Value;
        SetFXVolume(FFXVolume);
      end;
    HGE_MUSVOLUME:
      begin
        FMusVolume := Value;
        SetMusVolume(FMusVolume);
      end;   }
    HGE_FPS:
      begin
        if Assigned(FVertArray) then
          Exit;
        if Assigned(FD3DDevice) then
        begin
          if (((FHGEFPS >= 0) and (Value < 0)) or ((FHGEFPS < 0) and (Value >= 0))) then
          begin
            if (Value = HGEFPS_VSYNC) then
            begin

              fd3dppW.SwapEffect := D3DSWAPEFFECT_COPY;
              fd3dppW.PresentationInterval := D3DPRESENT_INTERVAL_DEFAULT;
              fd3dppFS.PresentationInterval := D3DPRESENT_INTERVAL_ONE;
            end
            else
            begin
              FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY;
              FD3DPPFS.PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
            end;
//            if Assigned(FProcFocusLostFunc) then
//              FProcFocusLostFunc;
            GfxRestore();
//            if Assigned(FProcFocusGainFunc) then
//              FProcFocusGainFunc;
          end;
        end;
        FHGEFPS := Value;
        if (FHGEFPS > 0) then
          FFixedDelta := 1000 div Value
        else
          FFixedDelta := 0;
      end;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEBoolState; const Value: Boolean);
begin
  case State of
    HGE_WINDOWED:
      begin
        if (FWindowed <> Value) and (not Assigned(FVertArray)) and (Assigned(FD3DDevice)) then
        begin
          if (FD3DPPW.BackBufferFormat = D3DFMT_UNKNOWN) or (FD3DPPFS.BackBufferFormat = D3DFMT_UNKNOWN) then
            Exit;
          FWindowed := Value;
          if (FWindowed) then
            FD3DPP := @FD3DPPW
          else
            FD3DPP := @FD3DPPFS;

          if (FormatId(FD3DPPW.BackBufferFormat) < 4) then
            FScreenBPP := 16
          else
            FScreenBPP := 32;

          GfxRestore;
        end
        else
          FWindowed := Value;
      end;
    HGE_ZBUFFER:
      if (FD3DDevice = nil) then
        FZBuffer := Value;
    HGE_TEXTUREFILTER:
      begin
        FTextureFilter := Value;
        if Assigned(FD3DDevice) then
        begin
          RenderBatch;
          if (FTextureFilter) then
          begin
            FD3DDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
            FD3DDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
          end
          else
          begin
            FD3DDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_POINT);
            FD3DDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_POINT);
          end;
        end;
      end;
    HGE_HIDEMOUSE:
      FHideMouse := Value;
    HGE_HARDWARE:
      FHardwareTL := Value;
    HGE_DONTSUSPEND:
      FDontSuspend := Value;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEFuncState; const Value: THGECallback);
begin
  case State of
    HGE_FRAMEFUNC:
      FProcFrameFunc := Value;
    HGE_RENDERFUNC:
      FProcRenderFunc := Value;
    HGE_FOCUSLOSTFUNC:
      FProcFocusLostFunc := Value;
    HGE_FOCUSGAINFUNC:
      FProcFocusGainFunc := Value;
    HGE_GFXRESTOREFUNC:
      FProcGfxRestoreFunc := Value;
    HGE_EXITFUNC:
      FProcExitFunc := Value;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEHWndState; const Value: HWnd);
begin
  case State of
    HGE_HWNDPARENT:
      FWndParent := Value;
  end;
end;

procedure THGEImpl.System_Shutdown;
begin
  System_Log(CRLF + 'Finishing..');
  TimeEndPeriod(1);

  GfxDone;

  System_Log('The End.');
end;

//截图
procedure THGEImpl.System_Snapshot(const Filename: string);
var
  Surf: IDirect3DSurface9;
  ShotName: String;
  I: Integer;
begin
  {if (Filename = '') then begin
    I := 0;
    ShotName := Resource_EnumFiles('Shot???.bmp');
    while (ShotName <> '') do begin
      Inc(I);
      ShotName := Resource_EnumFiles;
    end;
    ShotName := Resource_MakePath(Format('Shot%3d.bmp',[I]));
  end else}
    ShotName := Filename;

  if Assigned(FD3DDevice) then begin
    FD3DDevice.GetBackBuffer(0,0,D3DBACKBUFFER_TYPE_MONO,Surf);
    D3DXSaveSurfaceToFile(PChar(ShotName),D3DXIFF_BMP,Surf,nil,nil);
  end;
end;

function THGEImpl.System_Start: Boolean;
//var
//  Msg: TMsg;
begin
  Result := False;
  {if (FWnd = 0) then begin
    PostError('System_Start: System_Initiate wasn''t called');
    Exit;
  end;   }

  if (not Assigned(FProcFrameFunc)) then
  begin
    PostError('System_Start: No frame function defined');
    Exit;
  end;

  FActive := True;

  // MAIN LOOP

  while True do
  begin

		// Process window messages if not in "child mode"
		// (if in "child mode" the parent application will do this for us)

  {  if(FWndParent = 0) then begin
      if (PeekMessage(Msg,0,0,0,PM_REMOVE)) then begin
        if (Msg.message = WM_QUIT) then
          Break;
        // TranslateMessage(&msg);
        DispatchMessage(Msg);
        Continue;
      end;
    end;    }

		// Check if mouse is over HGE window for Input_IsMouseOver

		//UpdateMouse();

		// If HGE window is focused or we have the "don't suspend" state - process the main loop

    if (FActive or FDontSuspend) then
    begin
			// Ensure we have at least 1ms time step
			// to not confuse user's code with 0
      repeat
        FDT := TimeGetTime - FT0;
      until (FDT >= 1);

			// If we reached the time for the next frame
			// or we just run in unlimited FPS mode, then
			// do the stuff
      if (FDT >= FFixedDelta) then
      begin
				// fDeltaTime = time step in seconds returned by Timer_GetDelta
        FDeltaTime := FDT / 1000.0;

				// Cap too large time steps usually caused by lost focus to avoid jerks
        if (FDeltaTime > 0.2) then
        begin
          if (FFixedDelta <> 0) then
            FDeltaTime := FFixedDelta / 1000.0
          else
            FDeltaTime := 0.01;
        end;
				// Update time counter returned Timer_GetTime
        FTime := FTime + FDeltaTime;

				// Store current time for the next frame
				// and count FPS
        FT0 := TimeGetTime;
        if (FT0 - FT0FPS <= 1000) then
          Inc(FCFPS)
        else
        begin
          FFPS := FCFPS;
          FCFPS := 0;
          FT0FPS := FT0;
        end;

				// Do user's stuff
        if (FProcFrameFunc) then
          Break;
        if Assigned(FProcRenderFunc) then
          FProcRenderFunc;

				// If if "child mode" - return after processing single frame
        if (FWndParent <> 0) then
          Break;

				// Clean up input events that were generated by
				// WindowProc and weren't handled by user's code
        //ClearQueue;

				// If we use VSYNC - we could afford a little
				// sleep to lower CPU usage
//        if (not FWindowed) and (FHGEFPS = HGEFPS_VSYNC) then
//          Sleep(1);
      end
      else
      begin
  			// If we have a fixed frame rate and the time
	  		// for the next frame isn't too close, sleep a bit
        if ((FFixedDelta <> 0) and (FDT + 3 < FFixedDelta)) then
          Sleep(1);
      end;
    end
    else
      // If main loop is suspended - just sleep a bit
      // (though not too much to allow instant window
      // redraw if requested by OS)
      Sleep(1);
  end;
  //ClearQueue;
  FActive := False;
  Result := True;
end;

function THGEImpl.Target_Create(const Width, Height: Integer; const ZBuffer: Boolean): ITarget;
var
  Tex: ITexture;
  DXTexture: IDirect3DTexture9;
  Depth: IDirect3DSurface9;
  Desc: TD3DSurfaceDesc;
begin
  Result := nil;

  if (Failed(D3DXCreateTexture(FD3DDevice, Width, Height, 1, D3DUSAGE_RENDERTARGET, FD3DPP.BackBufferFormat, D3DPOOL_DEFAULT, DXTexture))) then
  begin
    PostError('Can''t create render target texture');
    Exit;
  end;
  Tex := TTexture.Create(DXTexture, Width, Height);

  DXTexture.GetLevelDesc(0, Desc);

  if (ZBuffer) then
  begin
    if (Failed(FD3DDevice.CreateDepthStencilSurface(Desc.Width, Desc.Height, D3DFMT_D16, D3DMULTISAMPLE_NONE, 0, False, Depth, nil))) then
    begin
      PostError('Can''t create render target depth buffer');
      Exit;
    end;
  end
  else
    Depth := nil;

  Result := TTarget.Create(Desc.Width, Desc.Height, Tex, Depth);
end;

function THGEImpl.Target_GetTexture(const Target: ITarget): ITexture;
begin
  if Assigned(Target) then
    Result := Target.Tex
  else
    Result := nil;
end;

function THGEImpl.Texture_Create(const Width, Height: Integer): ITexture;
var
  PTex: IDirect3DTexture9;
begin
  if (Failed(D3DXCreateTexture(FD3DDevice, Width, Height, 1,          // Mip levels
    0,          // Usage
    D3DFMT_A8R8G8B8,  // Format
    D3DPOOL_MANAGED,  // Memory pool
    PTex))) then
  begin
    PostError('Can''t create texture');
    Result := nil
  end
  else
    Result := TTexture.Create(PTex, Width, Height);
end;

function THGEImpl.Texture_Create(const Width, Height: Integer; Pool: TD3DPool; Format: TD3DFormat): ITexture;
var
  PTex: IDirect3DTexture9;
begin
  if (Failed(D3DXCreateTexture(FD3DDevice, Width, Height, 1,          // Mip levels
    0,          // Usage
    Format,     // Format
    Pool,       // Memory pool
    PTex))) then
  begin
    PostError('Can''t create texture');
    Result := nil
  end
  else
    Result := TTexture.Create(PTex, Width, Height);
end;

function THGEImpl.Texture_Create(const Width, Height: Integer; Tex: IDirect3DTexture9): ITexture;
begin
  Result := TTexture.Create(Tex, Width, Height);
end;

function THGEImpl.Texture_GetHeight(const Tex: ITexture; const Original: Boolean): Integer;
begin
  Result := Tex.GetHeight(Original);
end;

function THGEImpl.Texture_GetWidth(const Tex: ITexture; const Original: Boolean): Integer;
begin
  Result := Tex.GetWidth(Original);
end;

function THGEImpl.Texture_Lock(const Tex: ITexture; const ReadOnly: Boolean; const Left, Top, Width, Height: Integer): PLongword;
begin
  Result := Tex.Lock(ReadOnly, Left, Top, Width, Height);
end;

procedure THGEImpl.Texture_Unlock(const Tex: ITexture);
begin
  Tex.Unlock;
end;

function THGEImpl.Timer_GetDelta: Single;
begin
  Result := FDeltaTime;
end;

function THGEImpl.Timer_GetFPS: Integer;
begin
  Result := FFPS;
end;

function THGEImpl.Timer_GetTime: Single;
begin
  Result := FTime;
end;

function THGEImpl.System_GetState(const State: THGEInitializeState): TInitializeEvent;
begin
  case State of
    HGE_INITIALIZE:
      Result := FOnInitialize;
  else
    Result := nil;
  end;
end;

function THGEImpl.System_GetState(const State: THGEFinalizeState): TNotifyEvent;
begin
  case State of
    HGE_FINALIZE:
      Result := FOnFinalize;
  else
    Result := nil;
  end;
end;

function THGEImpl.System_GetState(const State: THGENotifyEventState): TDeviceNotifyEvent;
begin
  case State of
    HGE_NOTIFYEVENT:
      Result := FOnNotifyEvent;
  else
    Result := nil;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEInitializeState; const Value: TInitializeEvent);
begin
  case State of
    HGE_INITIALIZE:
      begin
        FOnInitialize := Value;
      end;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEFinalizeState; const Value: TNotifyEvent);
begin
  case State of
    HGE_FINALIZE:
      begin
        FOnFinalize := Value;
      end;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGENotifyEventState; const Value: TDeviceNotifyEvent);
begin
  case State of
    HGE_NOTIFYEVENT:
      begin
        FOnNotifyEvent := Value;
      end;
  end;
end;

end.

