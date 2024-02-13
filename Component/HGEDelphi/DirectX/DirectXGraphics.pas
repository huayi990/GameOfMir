(*)
 [------------------------------------------------------------------------------
 [  DirectXGraphics 8[.1] Delphi Adaptation (c) by Tim Baumgarten
 [------------------------------------------------------------------------------
 [  Files    : d3d8types.h
 [             d3d8caps.h
 [             d3d8.h
 [  Modified : 10-Nov-2001
 [  E-Mail   : Ampaze@gmx.net
 [------------------------------------------------------------------------------
(*)

(*)
 [------------------------------------------------------------------------------
 [ History :
 [----------
 [ 10-Nov-2001 (Tim Baumgarten) : Added DX 8.1, and still testing,
 [                                Define DX8 to make it work with dx8 runtime.
 [------------------------------------------------------------------------------
 [ 05-Nov-2001 (Tim Baumgarten) : Changed the EnumTypes for D6, so you might
 [                                have to typecast to LongWord in some cases.
 [------------------------------------------------------------------------------
 [ 28-Jul-2001 (Tim Baumgarten) : Changed "var pDestinationSurface : IDirect3DSurface8" to
 [                                "const pDestinationSurface : IDirect3DSurface8" in
 [                                IDirect3DDevice8.CopyRects
 [------------------------------------------------------------------------------
 [ 14-Mar-2001 (Tim Baumgarten) : Changed CreateVertexShader as pFunction can
 [                                be nil.
 [------------------------------------------------------------------------------
 [ 28-Jan-2001 (Tim Baumgarten) : Added TD3DMultiSampleType = TD3DMultiSample_Type;
 [------------------------------------------------------------------------------
 [ 23-Dec-2000 (Tim Baumgarten) : Changed all types that are declared as UInt
 [                                in C to be Cardinal in Delphi
 [------------------------------------------------------------------------------
 [ 23-Dec-2000 (Tim Baumgarten) : Changed all types that are declared as DWord
 [                                in C to be LongWord in Delphi
 [------------------------------------------------------------------------------
 [ 14-Dec-2000 (Tim Baumgarten) : Changed some parameters of IDirect3DDevice8.DrawRectPatch
 [                                and IDirect3DDevice8.DrawTriPatch to Pointers.
 [------------------------------------------------------------------------------
 [ 14-Dec-2000 (Tim Baumgarten) : Added versions without underlines of some structures
 [------------------------------------------------------------------------------
 [ 14-Dec-2000 (Tim Baumgarten) : Added "Pointer to Structure" (PStructure = ^TStructure)
 [                                to all structures.
 [------------------------------------------------------------------------------
 [ 26-Nov-2000 (Tim Baumgarten) : Returncodes are now typecasted with HResult
 [------------------------------------------------------------------------------
(*)

unit DirectXGraphics;

{$MINENUMSIZE 4}
{$ALIGN ON}
{$DEFINE STATIC_LINKING}


{$IFDEF VER140}
  {$DEFINE DELPHI6}
{$ENDIF}
{$IFDEF DELPHI6}
  {$DEFINE DELPHI6_AND_HIGHER}
  {$DEFINE D6UP}
{$ENDIF}

{$IFNDEF DELPHI6_AND_HIGHER}
  {$DEFINE NOENUMS}
{$ENDIF}
interface

uses
  Windows,sysutils, MMSystem;

{$IFNDEF STATIC_LINKING}
var
  D3D8DLL : HMODULE;
{$ENDIF}

const
      D3D8DLLName = 'd3d9.dll';
      d3dx9dll ={$IFDEF DEBUG} 'd3dx9_33.dll'{$ELSE} 'd3dx9_33.dll'{$ENDIF};
      d3dx9texDLL    = {$IFDEF D3DX_SEPARATE} 'd3dx9abTex.dll'  {$ELSE} d3dx9dll {$ENDIF};
      d3dx9mathDLL   = {$IFDEF D3DX_SEPARATE} 'd3dx9abMath.dll' {$ELSE} d3dx9dll {$ENDIF};
      DIRECT3D_VERSION = $0800;

      iTrue = DWord(True);
      iFalse = DWord(False);
type
  D3DVALUE = Single;
  TD3DValue = D3DVALUE;
  PD3DValue = ^TD3DValue;
  {$NODEFINE D3DVALUE}
  {$NODEFINE TD3DValue}
  {$NODEFINE PD3DValue}

type TD3DColor = type LongWord;

  // maps unsigned 8 bits/channel to D3DCOLOR
  function D3DCOLOR_ARGB(a, r, g, b : Cardinal) : TD3DColor; // ((D3DCOLOR)((((a)&= $ff)<<24)|(((r)&= $ff)<<16)|(((g)&= $ff)<<8)|((b)&= $ff)))
  function D3DCOLOR_RGBA(r, g, b, a : Cardinal) : TD3DColor; // D3DCOLOR_ARGB(a;r;g;b)
  function D3DCOLOR_XRGB(r, g, b : Cardinal) : TD3DColor; //   D3DCOLOR_ARGB(= $ff;r;g;b)

// maps floating point channels (0.f to 1.f range) to D3DCOLOR
  function D3DCOLOR_COLORVALUE(r, g, b, a : Single) : TD3DColor; // D3DCOLOR_RGBA((DWORD)((r)*255.f);(DWORD)((g)*255.f);(DWORD)((b)*255.f);(DWORD)((a)*255.f))


////////////////////////// d3d8input /////////////////////////////////
// Global level dynamic loading support
{$IFDEF DYNAMIC_LINK_ALL}
  {$DEFINE DIRECTINPUT_DYNAMIC_LINK}
{$ENDIF}
{$IFDEF DYNAMIC_LINK_EXPLICIT_ALL}
  {$DEFINE DIRECTINPUT_DYNAMIC_LINK_EXPLICIT}
{$ENDIF}

// Remove "dots" below to force some kind of dynamic linking
{.$DEFINE DIRECTINPUT_DYNAMIC_LINK}
{.$DEFINE DIRECTINPUT_DYNAMIC_LINK_EXPLICIT}

////////////////////////////////////////////////////////////////////////
// Assume for what DirectInput version we will compile headers
{$IFDEF DIRECTX9}
  {$DEFINE DIRECTINPUT_VERSION_8}
{$ENDIF}
{$IFDEF DIRECTX8}
  {$DEFINE DIRECTINPUT_VERSION_8}
{$ENDIF}
{$IFDEF DIRECTX7}
  {$DEFINE DIRECTINPUT_VERSION_7}
{$ENDIF}
{$IFDEF DIRECTX6}
  {$DEFINE DIRECTINPUT_VERSION_5}
{$ENDIF}
{$IFDEF DIRECTX5}
  {$DEFINE DIRECTINPUT_VERSION_5}
{$ENDIF}
{$IFDEF DIRECTX3}
  {$DEFINE DIRECTINPUT_VERSION_3}
{$ENDIF}

{$IFNDEF DIRECTINPUT_VERSION_8}
  {$IFNDEF DIRECTINPUT_VERSION_7}
    {$IFNDEF DIRECTINPUT_VERSION_5b}
      {$IFNDEF DIRECTINPUT_VERSION_5}
        {$IFNDEF DIRECTINPUT_VERSION_3}
// Compiling for DirectInput8 by default
{$DEFINE DIRECTINPUT_VERSION_8}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

////////////////////////////////////////////////////////////////////////
// Define DirectInputVerrsion constant
const
{$IFDEF DIRECTINPUT_VERSION_8}
  DIRECTINPUT_VERSION = $0800;
{$ELSE}{$IFDEF DIRECTINPUT_VERSION_7}
  DIRECTINPUT_VERSION = $0700;
{$ELSE}{$IFDEF DIRECTINPUT_VERSION_5b}
  DIRECTINPUT_VERSION = $05b2;
{$ELSE}{$IFDEF DIRECTINPUT_VERSION_5}
  DIRECTINPUT_VERSION = $0500;
{$ELSE}{$IFDEF DIRECTINPUT_VERSION_3}
  DIRECTINPUT_VERSION = $0300;
{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}
  {$EXTERNALSYM DIRECTINPUT_VERSION}

////////////////////////////////////////////////////////////////////////
// Emit conditionals to C++Builder compiler
{$IFDEF DIRECTINPUT_VERSION_3}
  {$HPPEMIT '#define DIRECTINPUT_VERSION         0x0300'}
{$ENDIF}
{$IFDEF DIRECTINPUT_VERSION_5}
  {$HPPEMIT '#define DIRECTINPUT_VERSION         0x0500'}
{$ENDIF}
{$IFDEF DIRECTINPUT_VERSION_5b}
  {$HPPEMIT '#define DIRECTINPUT_VERSION         0x05b2'}
{$ENDIF}
{$IFDEF DIRECTINPUT_VERSION_7}
  {$HPPEMIT '#define DIRECTINPUT_VERSION         0x0700'}
{$ENDIF}
{$IFDEF DIRECTINPUT_VERSION_8}
  {$HPPEMIT '#define DIRECTINPUT_VERSION         0x0800'}
{$ENDIF}

{$IFDEF DIRECTINPUT_VERSION_8}
  {$DEFINE DIRECTINPUT_VERSION_7}
{$ENDIF}
{$IFDEF DIRECTINPUT_VERSION_7}
  {$DEFINE DIRECTINPUT_VERSION_5b}
{$ENDIF}
{$IFDEF DIRECTINPUT_VERSION_5b}
  {$DEFINE DIRECTINPUT_VERSION_5}
{$ENDIF}
{$IFDEF DIRECTINPUT_VERSION_5}
  {$DEFINE DIRECTINPUT_VERSION_3}
{$ENDIF}

{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputEffect);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputDeviceA);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputDeviceW);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputA);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputW);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInput2A);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInput2W);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInput7A);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInput7W);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInput8A);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInput8W);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputDeviceA);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputDeviceW);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputDevice2A);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputDevice2W);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputDevice7A);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputDevice7W);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputDevice8A);'}
{$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirectInputDevice8W);'}
{$HPPEMIT '#ifdef UNICODE'}
{$HPPEMIT 'typedef _di_IDirectInputW _di_IDirectInput;'}
{$HPPEMIT 'typedef _di_IDirectInput2W _di_IDirectInput2;'}
{$HPPEMIT 'typedef _di_IDirectInput7W _di_IDirectInput7;'}
{$HPPEMIT 'typedef _di_IDirectInput8W _di_IDirectInput8;'}
{$HPPEMIT 'typedef _di_IDirectInputDeviceW _di_IDirectInputDevice;'}
{$HPPEMIT 'typedef _di_IDirectInputDevice2W _di_IDirectInputDevice2;'}
{$HPPEMIT 'typedef _di_IDirectInputDevice7W _di_IDirectInputDevice7;'}
{$HPPEMIT 'typedef _di_IDirectInputDevice8W _di_IDirectInputDevice8;'}
{$HPPEMIT '#else'}
{$HPPEMIT 'typedef _di_IDirectInputA _di_IDirectInput;'}
{$HPPEMIT 'typedef _di_IDirectInput2A _di_IDirectInput2;'}
{$HPPEMIT 'typedef _di_IDirectInput7A _di_IDirectInput7;'}
{$HPPEMIT 'typedef _di_IDirectInput8A _di_IDirectInput8;'}
{$HPPEMIT 'typedef _di_IDirectInputDeviceA _di_IDirectInputDevice;'}
{$HPPEMIT 'typedef _di_IDirectInputDevice2A _di_IDirectInputDevice2;'}
{$HPPEMIT 'typedef _di_IDirectInputDevice7A _di_IDirectInputDevice7;'}
{$HPPEMIT 'typedef _di_IDirectInputDevice8A _di_IDirectInputDevice8;'}
{$HPPEMIT '#endif'}

const
  CLSID_DirectInput        : TGUID = '{25E609E0-B259-11CF-BFC7-444553540000}';
  {$EXTERNALSYM CLSID_DirectInput}
  CLSID_DirectInputDevice  : TGUID = '{25E609E1-B259-11CF-BFC7-444553540000}';
  {$EXTERNALSYM CLSID_DirectInputDevice}

  CLSID_DirectInput8       : TGUID = '{25E609E4-B259-11CF-BFC7-444553540000}';
  {$EXTERNALSYM CLSID_DirectInput8}
  CLSID_DirectInputDevice8 : TGUID = '{25E609E5-B259-11CF-BFC7-444553540000}';
  {$EXTERNALSYM CLSID_DirectInputDevice8}

  const
  IID_IDirectInputA        : TGUID = '{89521360-AA8A-11CF-BFC7-444553540000}';
  {$EXTERNALSYM IID_IDirectInputA}
  IID_IDirectInputW        : TGUID = '{89521361-AA8A-11CF-BFC7-444553540000}';
  {$EXTERNALSYM IID_IDirectInputW}
  IID_IDirectInput2A       : TGUID = '{5944E662-AA8A-11CF-BFC7-444553540000}';
  {$EXTERNALSYM IID_IDirectInput2A}
  IID_IDirectInput2W       : TGUID = '{5944E663-AA8A-11CF-BFC7-444553540000}';
  {$EXTERNALSYM IID_IDirectInput2W}
  IID_IDirectInput7A       : TGUID = '{9A4CB684-236D-11D3-8E9D-00C04F6844AE}';
  {$EXTERNALSYM IID_IDirectInput7A}
  IID_IDirectInput7W       : TGUID = '{9A4CB685-236D-11D3-8E9D-00C04F6844AE}';
  {$EXTERNALSYM IID_IDirectInput7W}
  IID_IDirectInput8A       : TGUID = '{BF798030-483A-4DA2-AA99-5D64ED369700}';
  {$EXTERNALSYM IID_IDirectInput8A}
  IID_IDirectInput8W       : TGUID = '{BF798031-483A-4DA2-AA99-5D64ED369700}';
  {$EXTERNALSYM IID_IDirectInput8W}
  IID_IDirectInputDeviceA  : TGUID = '{5944E680-C92E-11CF-BFC7-444553540000}';
  {$EXTERNALSYM IID_IDirectInputDeviceA}
  IID_IDirectInputDeviceW  : TGUID = '{5944E681-C92E-11CF-BFC7-444553540000}';
  {$EXTERNALSYM IID_IDirectInputDeviceW}
  IID_IDirectInputDevice2A : TGUID = '{5944E682-C92E-11CF-BFC7-444553540000}';
  {$EXTERNALSYM IID_IDirectInputDevice2A}
  IID_IDirectInputDevice2W : TGUID = '{5944E683-C92E-11CF-BFC7-444553540000}';
  {$EXTERNALSYM IID_IDirectInputDevice2W}
  IID_IDirectInputDevice7A : TGUID = '{57D7C6BC-2356-11D3-8E9D-00C04F6844AE}';
  {$EXTERNALSYM IID_IDirectInputDevice7A}
  IID_IDirectInputDevice7W : TGUID = '{57D7C6BD-2356-11D3-8E9D-00C04F6844AE}';
  {$EXTERNALSYM IID_IDirectInputDevice7W}
  IID_IDirectInputDevice8A : TGUID = '{54D41080-DC15-4833-A41B-748F73A38179}';
  {$EXTERNALSYM IID_IDirectInputDevice8A}
  IID_IDirectInputDevice8W : TGUID = '{54D41081-DC15-4833-A41B-748F73A38179}';
  {$EXTERNALSYM IID_IDirectInputDevice8W}
  IID_IDirectInputEffect   : TGUID = '{E7E1F7C0-88D2-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM IID_IDirectInputEffect}

  // String constants for Interface IDs
  SID_IDirectInputA        = '{89521360-AA8A-11CF-BFC7-444553540000}';
  SID_IDirectInputW        = '{89521361-AA8A-11CF-BFC7-444553540000}';
  SID_IDirectInput2A       = '{5944E662-AA8A-11CF-BFC7-444553540000}';
  SID_IDirectInput2W       = '{5944E663-AA8A-11CF-BFC7-444553540000}';
  SID_IDirectInput7A       = '{9A4CB684-236D-11D3-8E9D-00C04F6844AE}';
  SID_IDirectInput7W       = '{9A4CB685-236D-11D3-8E9D-00C04F6844AE}';
  SID_IDirectInput8A       = '{BF798030-483A-4DA2-AA99-5D64ED369700}';
  SID_IDirectInput8W       = '{BF798031-483A-4DA2-AA99-5D64ED369700}';
  SID_IDirectInputDeviceA  = '{5944E680-C92E-11CF-BFC7-444553540000}';
  SID_IDirectInputDeviceW  = '{5944E681-C92E-11CF-BFC7-444553540000}';
  SID_IDirectInputDevice2A = '{5944E682-C92E-11CF-BFC7-444553540000}';
  SID_IDirectInputDevice2W = '{5944E683-C92E-11CF-BFC7-444553540000}';
  SID_IDirectInputDevice7A = '{57D7C6BC-2356-11D3-8E9D-00C04F6844AE}';
  SID_IDirectInputDevice7W = '{57D7C6BD-2356-11D3-8E9D-00C04F6844AE}';
  SID_IDirectInputDevice8A = '{54D41080-DC15-4833-A41B-748F73A38179}';
  SID_IDirectInputDevice8W = '{54D41081-DC15-4833-A41B-748F73A38179}';
  SID_IDirectInputEffect   = '{E7E1F7C0-88D2-11D0-9AD0-00A0C9A06E35}';

  const
  GUID_XAxis   : TGUID = '{A36D02E0-C9F3-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_XAxis}
  GUID_YAxis   : TGUID = '{A36D02E1-C9F3-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_YAxis}
  GUID_ZAxis   : TGUID = '{A36D02E2-C9F3-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_ZAxis}
  GUID_RxAxis  : TGUID = '{A36D02F4-C9F3-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_RxAxis}
  GUID_RyAxis  : TGUID = '{A36D02F5-C9F3-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_RyAxis}
  GUID_RzAxis  : TGUID = '{A36D02E3-C9F3-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_RzAxis}
  GUID_Slider  : TGUID = '{A36D02E4-C9F3-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_Slider}

  GUID_Button  : TGUID = '{A36D02F0-C9F3-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_Button}
  GUID_Key     : TGUID = '{55728220-D33C-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_Key}

  GUID_POV     : TGUID = '{A36D02F2-C9F3-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_POV}

  GUID_Unknown : TGUID = '{A36D02F3-C9F3-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_Unknown}

(****************************************************************************
 *
 *      Predefined product GUIDs
 *
 ****************************************************************************)

const
  GUID_SysMouse       : TGUID = '{6F1D2B60-D5A0-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_SysMouse}
  GUID_SysKeyboard    : TGUID = '{6F1D2B61-D5A0-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_SysKeyboard}
  GUID_Joystick       : TGUID = '{6F1D2B70-D5A0-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_Joystick}
  GUID_SysMouseEm     : TGUID = '{6F1D2B80-D5A0-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_SysMouseEm}
  GUID_SysMouseEm2    : TGUID = '{6F1D2B81-D5A0-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_SysMouseEm2}
  GUID_SysKeyboardEm  : TGUID = '{6F1D2B82-D5A0-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_SysKeyboardEm}
  GUID_SysKeyboardEm2 : TGUID = '{6F1D2B83-D5A0-11CF-BFC7-444553540000}';
  {$EXTERNALSYM GUID_SysKeyboardEm2}


const
  GUID_ConstantForce : TGUID = '{13541C20-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_ConstantForce}
  GUID_RampForce     : TGUID = '{13541C21-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_RampForce}
  GUID_Square        : TGUID = '{13541C22-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_Square}
  GUID_Sine          : TGUID = '{13541C23-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_Sine}
  GUID_Triangle      : TGUID = '{13541C24-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_Triangle}
  GUID_SawtoothUp    : TGUID = '{13541C25-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_SawtoothUp}
  GUID_SawtoothDown  : TGUID = '{13541C26-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_SawtoothDown}
  GUID_Spring        : TGUID = '{13541C27-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_Spring}
  GUID_Damper        : TGUID = '{13541C28-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_Damper}
  GUID_Inertia       : TGUID = '{13541C29-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_Inertia}
  GUID_Friction      : TGUID = '{13541C2A-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_Friction}
  GUID_CustomForce   : TGUID = '{13541C2B-8E33-11D0-9AD0-00A0C9A06E35}';
  {$EXTERNALSYM GUID_CustomForce}


{$IFDEF DIRECTINPUT_VERSION_5}
const
  DIEFT_ALL                   = $00000000;
  {$EXTERNALSYM DIEFT_ALL}

  DIEFT_CONSTANTFORCE         = $00000001;
  {$EXTERNALSYM DIEFT_CONSTANTFORCE}
  DIEFT_RAMPFORCE             = $00000002;
  {$EXTERNALSYM DIEFT_RAMPFORCE}
  DIEFT_PERIODIC              = $00000003;
  {$EXTERNALSYM DIEFT_PERIODIC}
  DIEFT_CONDITION             = $00000004;
  {$EXTERNALSYM DIEFT_CONDITION}
  DIEFT_CUSTOMFORCE           = $00000005;
  {$EXTERNALSYM DIEFT_CUSTOMFORCE}
  DIEFT_HARDWARE              = $000000FF;
  {$EXTERNALSYM DIEFT_HARDWARE}
  DIEFT_FFATTACK              = $00000200;
  {$EXTERNALSYM DIEFT_FFATTACK}
  DIEFT_FFFADE                = $00000400;
  {$EXTERNALSYM DIEFT_FFFADE}
  DIEFT_SATURATION            = $00000800;
  {$EXTERNALSYM DIEFT_SATURATION}
  DIEFT_POSNEGCOEFFICIENTS    = $00001000;
  {$EXTERNALSYM DIEFT_POSNEGCOEFFICIENTS}
  DIEFT_POSNEGSATURATION      = $00002000;
  {$EXTERNALSYM DIEFT_POSNEGSATURATION}
  DIEFT_DEADBAND              = $00004000;
  {$EXTERNALSYM DIEFT_DEADBAND}
  DIEFT_STARTDELAY            = $00008000;
  {$EXTERNALSYM DIEFT_STARTDELAY}

//#define DIEFT_GETTYPE(n)            LOBYTE(n)
function DIEFT_GETTYPE(n: Cardinal): Byte;
{$EXTERNALSYM DIEFT_GETTYPE}

const
  DI_DEGREES                  = 100;
  {$EXTERNALSYM DI_DEGREES}
  DI_FFNOMINALMAX             = 10000;
  {$EXTERNALSYM DI_FFNOMINALMAX}
  DI_SECONDS                  = 1000000;
  {$EXTERNALSYM DI_SECONDS}

type
  PDIConstantForce = ^TDIConstantForce;
  DICONSTANTFORCE = packed record
    lMagnitude: Longint;
  end;
  {$EXTERNALSYM DICONSTANTFORCE}
  TDIConstantForce = DICONSTANTFORCE;

  PDIRampForce = ^TDIRampForce;
  DIRAMPFORCE = packed record
    lStart: Longint;
    lEnd: Longint;
  end;
  {$EXTERNALSYM DIRAMPFORCE}
  TDIRampForce = DIRAMPFORCE;

  PDIPeriodic = ^TDIPeriodic;
  DIPERIODIC = packed record
    dwMagnitude: DWORD;
    lOffset: Longint;
    dwPhase: DWORD;
    dwPeriod: DWORD;
  end;
  {$EXTERNALSYM DIPERIODIC}
  TDIPeriodic = DIPERIODIC;

  PDICondition = ^TDICondition;
  DICONDITION = packed record
    lOffset: Longint;
    lPositiveCoefficient: Longint;
    lNegativeCoefficient: Longint;
    dwPositiveSaturation: DWORD;
    dwNegativeSaturation: DWORD;
    lDeadBand: Longint;
  end;
  {$EXTERNALSYM DICONDITION}
  TDICondition = DICONDITION;

  PDICustomForce = ^TDICustomForce;
  DICUSTOMFORCE = packed record
    cChannels: DWORD;
    dwSamplePeriod: DWORD;
    cSamples: DWORD;
    rglForceData: PLongint;
  end;
  {$EXTERNALSYM DICUSTOMFORCE}
  TDICustomForce = DICUSTOMFORCE;

  PDIEnvelope = ^TDIEnvelope;
  DIENVELOPE = packed record
    dwSize: DWORD;                   (* sizeof(DIENVELOPE)   *)
    dwAttackLevel: DWORD;
    dwAttackTime: DWORD;             (* Microseconds         *)
    dwFadeLevel: DWORD;
    dwFadeTime: DWORD;               (* Microseconds         *)
  end;
  {$EXTERNALSYM DIENVELOPE}
  TDIEnvelope = DIENVELOPE;

 PDIEffectDX5 = ^TDIEffectDX5;
  DIEFFECT_DX5 = packed record
    dwSize: DWORD;                   (* sizeof(DIEFFECT_DX5) *)
    dwFlags: DWORD;                  (* DIEFF_*              *)
    dwDuration: DWORD;               (* Microseconds         *)
    dwSamplePeriod: DWORD;           (* Microseconds         *)
    dwGain: DWORD;
    dwTriggerButton: DWORD;          (* or DIEB_NOTRIGGER    *)
    dwTriggerRepeatInterval: DWORD;  (* Microseconds         *)
    cAxes: DWORD;                    (* Number of axes       *)
    rgdwAxes: PDWORD;                (* Array of axes        *)
    rglDirection: PLongint;          (* Array of directions  *)
    lpEnvelope: PDIEnvelope;         (* Optional             *)
    cbTypeSpecificParams: DWORD;     (* Size of params       *)
    lpvTypeSpecificParams: Pointer;  (* Pointer to params    *)
  end;
  {$EXTERNALSYM DIEFFECT_DX5}
  TDIEffectDX5 = DIEFFECT_DX5;

  PDIEffect = ^TDIEffect;
  DIEFFECT = packed record
    dwSize: DWORD;                   (* sizeof(DIEFFECT)     *)
    dwFlags: DWORD;                  (* DIEFF_*              *)
    dwDuration: DWORD;               (* Microseconds         *)
    dwSamplePeriod: DWORD;           (* Microseconds         *)
    dwGain: DWORD;
    dwTriggerButton: DWORD;          (* or DIEB_NOTRIGGER    *)
    dwTriggerRepeatInterval: DWORD;  (* Microseconds         *)
    cAxes: DWORD;                    (* Number of axes       *)
    rgdwAxes: PDWORD;                (* Array of axes        *)
    rglDirection: PLongint;          (* Array of directions  *)
    lpEnvelope: PDIEnvelope;         (* Optional             *)
    cbTypeSpecificParams: DWORD;     (* Size of params       *)
    lpvTypeSpecificParams: Pointer;  (* Pointer to params    *)
{$IFDEF DIRECTINPUT_VERSION_6}
    dwStartDelay:  DWORD;            (* Microseconds         *)
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0600 *)
  end;
  {$EXTERNALSYM DIEFFECT}
  TDIEffect = DIEFFECT;

  DIEFFECT_DX6 = DIEFFECT;
  {$EXTERNALSYM DIEFFECT_DX6}
  TDIEffectDX6 = DIEFFECT_DX6;
  PDIEffectDX6 = ^TDIEffectDX6;

{$IFDEF DIRECTINPUT_VERSION_7}
  PDIFileEffect = ^TDIFileEffect;
  DIFILEEFFECT = packed record
    dwSize: DWORD;
    GuidEffect: TGUID;
    lpDiEffect: PDIEffect;
    szFriendlyName: array [0..MAX_PATH-1] of Char;
  end;
  {$EXTERNALSYM DIFILEEFFECT}
  TDIFileEffect = DIFILEEFFECT;

  TDIEnumEffectsInFileCallback = function (const Effect: TDIFileEffect; Data: Pointer): BOOL; stdcall;
  {$NODEFINE TDIEnumEffectsInFileCallback}
  {$HPPEMIT 'typedef LPDIENUMEFFECTSINFILECALLBACK TDIEnumEffectsInFileCallback;'}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0700 *)

const
  DIEFF_OBJECTIDS             = $00000001;
  {$EXTERNALSYM DIEFF_OBJECTIDS}
  DIEFF_OBJECTOFFSETS         = $00000002;
  {$EXTERNALSYM DIEFF_OBJECTOFFSETS}
  DIEFF_CARTESIAN             = $00000010;
  {$EXTERNALSYM DIEFF_CARTESIAN}
  DIEFF_POLAR                 = $00000020;
  {$EXTERNALSYM DIEFF_POLAR}
  DIEFF_SPHERICAL             = $00000040;
  {$EXTERNALSYM DIEFF_SPHERICAL}

  DIEP_DURATION               = $00000001;
  {$EXTERNALSYM DIEP_DURATION}
  DIEP_SAMPLEPERIOD           = $00000002;
  {$EXTERNALSYM DIEP_SAMPLEPERIOD}
  DIEP_GAIN                   = $00000004;
  {$EXTERNALSYM DIEP_GAIN}
  DIEP_TRIGGERBUTTON          = $00000008;
  {$EXTERNALSYM DIEP_TRIGGERBUTTON}
  DIEP_TRIGGERREPEATINTERVAL  = $00000010;
  {$EXTERNALSYM DIEP_TRIGGERREPEATINTERVAL}
  DIEP_AXES                   = $00000020;
  {$EXTERNALSYM DIEP_AXES}
  DIEP_DIRECTION              = $00000040;
  {$EXTERNALSYM DIEP_DIRECTION}
  DIEP_ENVELOPE               = $00000080;
  {$EXTERNALSYM DIEP_ENVELOPE}
  DIEP_TYPESPECIFICPARAMS     = $00000100;
  {$EXTERNALSYM DIEP_TYPESPECIFICPARAMS}
{$IFDEF DIRECTINPUT_VERSION_6}
  DIEP_STARTDELAY             = $00000200;
  {$EXTERNALSYM DIEP_STARTDELAY}
  DIEP_ALLPARAMS_DX5          = $000001FF;
  {$EXTERNALSYM DIEP_ALLPARAMS_DX5}
  DIEP_ALLPARAMS              = $000003FF;
  {$EXTERNALSYM DIEP_ALLPARAMS}
{$ELSE} (* DIRECTINPUT_VERSION < 0x0600 *)
  DIEP_ALLPARAMS              = $000001FF;
  {$EXTERNALSYM DIEP_ALLPARAMS}
{$ENDIF} (* DIRECTINPUT_VERSION ? 0x0600 *)
  DIEP_START                  = $20000000;
  {$EXTERNALSYM DIEP_START}
  DIEP_NORESTART              = $40000000;
  {$EXTERNALSYM DIEP_NORESTART}
  DIEP_NODOWNLOAD             = $80000000;
  {$EXTERNALSYM DIEP_NODOWNLOAD}
  DIEB_NOTRIGGER              = $FFFFFFFF;
  {$EXTERNALSYM DIEB_NOTRIGGER}

  DIES_SOLO                   = $00000001;
  {$EXTERNALSYM DIES_SOLO}
  DIES_NODOWNLOAD             = $80000000;
  {$EXTERNALSYM DIES_NODOWNLOAD}

  DIEGES_PLAYING              = $00000001;
  {$EXTERNALSYM DIEGES_PLAYING}
  DIEGES_EMULATED             = $00000002;
  {$EXTERNALSYM DIEGES_EMULATED}

type
  PDIEffEscape = ^TDIEffEscape;
  DIEFFESCAPE = packed record
    dwSize: DWORD;
    dwCommand: DWORD;
    lpvInBuffer: Pointer;
    cbInBuffer: DWORD;
    lpvOutBuffer: Pointer;
    cbOutBuffer: DWORD;
  end;
  {$EXTERNALSYM DIEFFESCAPE}
  TDIEffEscape = DIEFFESCAPE;


type
  {$EXTERNALSYM IDirectInputEffect}
  IDirectInputEffect = interface(IUnknown)
    [SID_IDirectInputEffect]
    (*** IDirectInputEffect methods ***)
    function Initialize(hinst: THandle; dwVersion: DWORD; const rguid: TGUID): HResult; stdcall;
    function GetEffectGuid(out pguid: TGUID): HResult; stdcall;
    function GetParameters(var peff: TDIEffect; dwFlags: DWORD): HResult; stdcall;
    function SetParameters(const peff: TDIEffect; dwFlags: DWORD): HResult; stdcall;
    function Start(dwIterations, dwFlags: DWORD): HResult; stdcall;
    function Stop: HResult; stdcall;
    function GetEffectStatus(out pdwFlags: DWORD): HResult; stdcall;
    function Download: HResult; stdcall;
    function Unload: HResult; stdcall;
    function Escape(var pesc: PDIEffEscape): HResult; stdcall;
  end;
 {$ENDIF}


const
{$IFNDEF DIRECTINPUT_VERSION_8} (* #if DIRECTINPUT_VERSION <= 0x700 *)
  DIDEVTYPE_DEVICE        = 1;
  {$EXTERNALSYM DIDEVTYPE_DEVICE}
  DIDEVTYPE_MOUSE         = 2;
  {$EXTERNALSYM DIDEVTYPE_MOUSE}
  DIDEVTYPE_KEYBOARD      = 3;
  {$EXTERNALSYM DIDEVTYPE_KEYBOARD}
  DIDEVTYPE_JOYSTICK      = 4;
  {$EXTERNALSYM DIDEVTYPE_JOYSTICK}
{$ELSE}
  DI8DEVCLASS_ALL             = 0;
  {$EXTERNALSYM DI8DEVCLASS_ALL}
  DI8DEVCLASS_DEVICE          = 1;
  {$EXTERNALSYM DI8DEVCLASS_DEVICE}
  DI8DEVCLASS_POINTER         = 2;
  {$EXTERNALSYM DI8DEVCLASS_POINTER}
  DI8DEVCLASS_KEYBOARD        = 3;
  {$EXTERNALSYM DI8DEVCLASS_KEYBOARD}
  DI8DEVCLASS_GAMECTRL        = 4;
  {$EXTERNALSYM DI8DEVCLASS_GAMECTRL}

  DI8DEVTYPE_DEVICE           = $11;
  {$EXTERNALSYM DI8DEVTYPE_DEVICE}
  DI8DEVTYPE_MOUSE            = $12;
  {$EXTERNALSYM DI8DEVTYPE_MOUSE}
  DI8DEVTYPE_KEYBOARD         = $13;
  {$EXTERNALSYM DI8DEVTYPE_KEYBOARD}
  DI8DEVTYPE_JOYSTICK         = $14;
  {$EXTERNALSYM DI8DEVTYPE_JOYSTICK}
  DI8DEVTYPE_GAMEPAD          = $15;
  {$EXTERNALSYM DI8DEVTYPE_GAMEPAD}
  DI8DEVTYPE_DRIVING          = $16;
  {$EXTERNALSYM DI8DEVTYPE_DRIVING}
  DI8DEVTYPE_FLIGHT           = $17;
  {$EXTERNALSYM DI8DEVTYPE_FLIGHT}
  DI8DEVTYPE_1STPERSON        = $18;
  {$EXTERNALSYM DI8DEVTYPE_1STPERSON}
  DI8DEVTYPE_DEVICECTRL       = $19;
  {$EXTERNALSYM DI8DEVTYPE_DEVICECTRL}
  DI8DEVTYPE_SCREENPOINTER    = $1A;
  {$EXTERNALSYM DI8DEVTYPE_SCREENPOINTER}
  DI8DEVTYPE_REMOTE           = $1B;
  {$EXTERNALSYM DI8DEVTYPE_REMOTE}
  DI8DEVTYPE_SUPPLEMENTAL     = $1C;
  {$EXTERNALSYM DI8DEVTYPE_SUPPLEMENTAL}
{$ENDIF} (* DIRECTINPUT_VERSION <= 0x700 *)

  DIDEVTYPE_HID           = $00010000;
  {$EXTERNALSYM DIDEVTYPE_HID}

{$IFNDEF DIRECTINPUT_VERSION_8} (* #if DIRECTINPUT_VERSION <= 0x700 *)
  DIDEVTYPEMOUSE_UNKNOWN          =  1;
  {$EXTERNALSYM DIDEVTYPEMOUSE_UNKNOWN}
  DIDEVTYPEMOUSE_TRADITIONAL      =  2;
  {$EXTERNALSYM DIDEVTYPEMOUSE_TRADITIONAL}
  DIDEVTYPEMOUSE_FINGERSTICK      =  3;
  {$EXTERNALSYM DIDEVTYPEMOUSE_FINGERSTICK}
  DIDEVTYPEMOUSE_TOUCHPAD         =  4;
  {$EXTERNALSYM DIDEVTYPEMOUSE_TOUCHPAD}
  DIDEVTYPEMOUSE_TRACKBALL        =  5;
  {$EXTERNALSYM DIDEVTYPEMOUSE_TRACKBALL}

  DIDEVTYPEKEYBOARD_UNKNOWN       =  0;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_UNKNOWN}
  DIDEVTYPEKEYBOARD_PCXT          =  1;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_PCXT}
  DIDEVTYPEKEYBOARD_OLIVETTI      =  2;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_OLIVETTI}
  DIDEVTYPEKEYBOARD_PCAT          =  3;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_PCAT}
  DIDEVTYPEKEYBOARD_PCENH         =  4;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_PCENH}
  DIDEVTYPEKEYBOARD_NOKIA1050     =  5;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_NOKIA1050}
  DIDEVTYPEKEYBOARD_NOKIA9140     =  6;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_NOKIA9140}
  DIDEVTYPEKEYBOARD_NEC98         =  7;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_NEC98}
  DIDEVTYPEKEYBOARD_NEC98LAPTOP   =  8;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_NEC98LAPTOP}
  DIDEVTYPEKEYBOARD_NEC98106      =  9;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_NEC98106}
  DIDEVTYPEKEYBOARD_JAPAN106      = 10;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_JAPAN106}
  DIDEVTYPEKEYBOARD_JAPANAX       = 11;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_JAPANAX}
  DIDEVTYPEKEYBOARD_J3100         = 12;
  {$EXTERNALSYM DIDEVTYPEKEYBOARD_J3100}

  DIDEVTYPEJOYSTICK_UNKNOWN       =  1;
  {$EXTERNALSYM DIDEVTYPEJOYSTICK_UNKNOWN}
  DIDEVTYPEJOYSTICK_TRADITIONAL   =  2;
  {$EXTERNALSYM DIDEVTYPEJOYSTICK_TRADITIONAL}
  DIDEVTYPEJOYSTICK_FLIGHTSTICK   =  3;
  {$EXTERNALSYM DIDEVTYPEJOYSTICK_FLIGHTSTICK}
  DIDEVTYPEJOYSTICK_GAMEPAD       =  4;
  {$EXTERNALSYM DIDEVTYPEJOYSTICK_GAMEPAD}
  DIDEVTYPEJOYSTICK_RUDDER        =  5;
  {$EXTERNALSYM DIDEVTYPEJOYSTICK_RUDDER}
  DIDEVTYPEJOYSTICK_WHEEL         =  6;
  {$EXTERNALSYM DIDEVTYPEJOYSTICK_WHEEL}
  DIDEVTYPEJOYSTICK_HEADTRACKER   =  7;
  {$EXTERNALSYM DIDEVTYPEJOYSTICK_HEADTRACKER}
{$ELSE}
  DI8DEVTYPEMOUSE_UNKNOWN                     = 1;
  {$EXTERNALSYM DI8DEVTYPEMOUSE_UNKNOWN}
  DI8DEVTYPEMOUSE_TRADITIONAL                 = 2;
  {$EXTERNALSYM DI8DEVTYPEMOUSE_TRADITIONAL}
  DI8DEVTYPEMOUSE_FINGERSTICK                 = 3;
  {$EXTERNALSYM DI8DEVTYPEMOUSE_FINGERSTICK}
  DI8DEVTYPEMOUSE_TOUCHPAD                    = 4;
  {$EXTERNALSYM DI8DEVTYPEMOUSE_TOUCHPAD}
  DI8DEVTYPEMOUSE_TRACKBALL                   = 5;
  {$EXTERNALSYM DI8DEVTYPEMOUSE_TRACKBALL}
  DI8DEVTYPEMOUSE_ABSOLUTE                    = 6;
  {$EXTERNALSYM DI8DEVTYPEMOUSE_ABSOLUTE}

  DI8DEVTYPEKEYBOARD_UNKNOWN                  = 0;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_UNKNOWN}
  DI8DEVTYPEKEYBOARD_PCXT                     = 1;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_PCXT}
  DI8DEVTYPEKEYBOARD_OLIVETTI                 = 2;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_OLIVETTI}
  DI8DEVTYPEKEYBOARD_PCAT                     = 3;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_PCAT}
  DI8DEVTYPEKEYBOARD_PCENH                    = 4;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_PCENH}
  DI8DEVTYPEKEYBOARD_NOKIA1050                = 5;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_NOKIA1050}
  DI8DEVTYPEKEYBOARD_NOKIA9140                = 6;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_NOKIA9140}
  DI8DEVTYPEKEYBOARD_NEC98                    = 7;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_NEC98}
  DI8DEVTYPEKEYBOARD_NEC98LAPTOP              = 8;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_NEC98LAPTOP}
  DI8DEVTYPEKEYBOARD_NEC98106                 = 9;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_NEC98106}
  DI8DEVTYPEKEYBOARD_JAPAN106                 = 10;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_JAPAN106}
  DI8DEVTYPEKEYBOARD_JAPANAX                  = 11;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_JAPANAX}
  DI8DEVTYPEKEYBOARD_J3100                    = 12;
  {$EXTERNALSYM DI8DEVTYPEKEYBOARD_J3100}

  DI8DEVTYPE_LIMITEDGAMESUBTYPE               = 1;
  {$EXTERNALSYM DI8DEVTYPE_LIMITEDGAMESUBTYPE}

  DI8DEVTYPEJOYSTICK_LIMITED                  = DI8DEVTYPE_LIMITEDGAMESUBTYPE;
  {$EXTERNALSYM DI8DEVTYPEJOYSTICK_LIMITED}
  DI8DEVTYPEJOYSTICK_STANDARD                 = 2;
  {$EXTERNALSYM DI8DEVTYPEJOYSTICK_STANDARD}

  DI8DEVTYPEGAMEPAD_LIMITED                   = DI8DEVTYPE_LIMITEDGAMESUBTYPE;
  {$EXTERNALSYM DI8DEVTYPEGAMEPAD_LIMITED}
  DI8DEVTYPEGAMEPAD_STANDARD                  = 2;
  {$EXTERNALSYM DI8DEVTYPEGAMEPAD_STANDARD}
  DI8DEVTYPEGAMEPAD_TILT                      = 3;
  {$EXTERNALSYM DI8DEVTYPEGAMEPAD_TILT}

  DI8DEVTYPEDRIVING_LIMITED                   = DI8DEVTYPE_LIMITEDGAMESUBTYPE;
  {$EXTERNALSYM DI8DEVTYPEDRIVING_LIMITED}
  DI8DEVTYPEDRIVING_COMBINEDPEDALS            = 2;
  {$EXTERNALSYM DI8DEVTYPEDRIVING_COMBINEDPEDALS}
  DI8DEVTYPEDRIVING_DUALPEDALS                = 3;
  {$EXTERNALSYM DI8DEVTYPEDRIVING_DUALPEDALS}
  DI8DEVTYPEDRIVING_THREEPEDALS               = 4;
  {$EXTERNALSYM DI8DEVTYPEDRIVING_THREEPEDALS}
  DI8DEVTYPEDRIVING_HANDHELD                  = 5;
  {$EXTERNALSYM DI8DEVTYPEDRIVING_HANDHELD}

  DI8DEVTYPEFLIGHT_LIMITED                    = DI8DEVTYPE_LIMITEDGAMESUBTYPE;
  {$EXTERNALSYM DI8DEVTYPEFLIGHT_LIMITED}
  DI8DEVTYPEFLIGHT_STICK                      = 2;
  {$EXTERNALSYM DI8DEVTYPEFLIGHT_STICK}
  DI8DEVTYPEFLIGHT_YOKE                       = 3;
  {$EXTERNALSYM DI8DEVTYPEFLIGHT_YOKE}
  DI8DEVTYPEFLIGHT_RC                         = 4;
  {$EXTERNALSYM DI8DEVTYPEFLIGHT_RC}

  DI8DEVTYPE1STPERSON_LIMITED                 = DI8DEVTYPE_LIMITEDGAMESUBTYPE;
  {$EXTERNALSYM DI8DEVTYPE1STPERSON_LIMITED}
  DI8DEVTYPE1STPERSON_UNKNOWN                 = 2;
  {$EXTERNALSYM DI8DEVTYPE1STPERSON_UNKNOWN}
  DI8DEVTYPE1STPERSON_SIXDOF                  = 3;
  {$EXTERNALSYM DI8DEVTYPE1STPERSON_SIXDOF}
  DI8DEVTYPE1STPERSON_SHOOTER                 = 4;
  {$EXTERNALSYM DI8DEVTYPE1STPERSON_SHOOTER}

  DI8DEVTYPESCREENPTR_UNKNOWN                 = 2;
  {$EXTERNALSYM DI8DEVTYPESCREENPTR_UNKNOWN}
  DI8DEVTYPESCREENPTR_LIGHTGUN                = 3;
  {$EXTERNALSYM DI8DEVTYPESCREENPTR_LIGHTGUN}
  DI8DEVTYPESCREENPTR_LIGHTPEN                = 4;
  {$EXTERNALSYM DI8DEVTYPESCREENPTR_LIGHTPEN}
  DI8DEVTYPESCREENPTR_TOUCH                   = 5;
  {$EXTERNALSYM DI8DEVTYPESCREENPTR_TOUCH}

  DI8DEVTYPEREMOTE_UNKNOWN                    = 2;
  {$EXTERNALSYM DI8DEVTYPEREMOTE_UNKNOWN}

  DI8DEVTYPEDEVICECTRL_UNKNOWN                = 2;
  {$EXTERNALSYM DI8DEVTYPEDEVICECTRL_UNKNOWN}
  DI8DEVTYPEDEVICECTRL_COMMSSELECTION         = 3;
  {$EXTERNALSYM DI8DEVTYPEDEVICECTRL_COMMSSELECTION}
  DI8DEVTYPEDEVICECTRL_COMMSSELECTION_HARDWIRED = 4;
  {$EXTERNALSYM DI8DEVTYPEDEVICECTRL_COMMSSELECTION_HARDWIRED}

  DI8DEVTYPESUPPLEMENTAL_UNKNOWN              = 2;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_UNKNOWN}
  DI8DEVTYPESUPPLEMENTAL_2NDHANDCONTROLLER    = 3;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_2NDHANDCONTROLLER}
  DI8DEVTYPESUPPLEMENTAL_HEADTRACKER          = 4;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_HEADTRACKER}
  DI8DEVTYPESUPPLEMENTAL_HANDTRACKER          = 5;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_HANDTRACKER}
  DI8DEVTYPESUPPLEMENTAL_SHIFTSTICKGATE       = 6;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_SHIFTSTICKGATE}
  DI8DEVTYPESUPPLEMENTAL_SHIFTER              = 7;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_SHIFTER}
  DI8DEVTYPESUPPLEMENTAL_THROTTLE             = 8;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_THROTTLE}
  DI8DEVTYPESUPPLEMENTAL_SPLITTHROTTLE        = 9;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_SPLITTHROTTLE}
  DI8DEVTYPESUPPLEMENTAL_COMBINEDPEDALS       = 10;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_COMBINEDPEDALS}
  DI8DEVTYPESUPPLEMENTAL_DUALPEDALS           = 11;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_DUALPEDALS}
  DI8DEVTYPESUPPLEMENTAL_THREEPEDALS          = 12;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_THREEPEDALS}
  DI8DEVTYPESUPPLEMENTAL_RUDDERPEDALS         = 13;
  {$EXTERNALSYM DI8DEVTYPESUPPLEMENTAL_RUDDERPEDALS}
{$ENDIF} (* DIRECTINPUT_VERSION <= 0x700 *)

// #define GET_DIDEVICE_TYPE(dwDevType)    LOBYTE(dwDevType)
function GET_DIDEVICE_TYPE(dwDevType: DWORD): Byte;
{$EXTERNALSYM GET_DIDEVICE_TYPE}
// #define GET_DIDEVICE_SUBTYPE(dwDevType) HIBYTE(dwDevType)
function GET_DIDEVICE_SUBTYPE(dwDevType: DWORD): Byte;
{$EXTERNALSYM GET_DIDEVICE_SUBTYPE}

{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
(* This structure is defined for DirectX 3.0 compatibility *)
type
  PD3DVector = ^TD3DVector;
  TD3DVector = packed record
    x : Single;
    y : Single;
    z : Single;
  end;

  PD3DColorValue = ^TD3DColorValue;
  TD3DColorValue = packed record
    r : Single;
    g : Single;
    b : Single;
    a : Single;
  end;

  PD3DRect = ^TD3DRect;
  TD3DRect = packed record
    x1 : LongInt;
    y1 : LongInt;
    x2 : LongInt;
    y2 : LongInt;
  end;

  PD3DMatrix = ^TD3DMatrix;
  TD3DMatrix = packed record
    case Integer of
      0 : (_11, _12, _13, _14 : Single;
           _21, _22, _23, _24 : Single;
           _31, _32, _33, _34 : Single;
           _41, _42, _43, _44 : Single);
      1 : (m : array [0..3, 0..3] of Single);
  end;

  type
  //2014.08.31  DirectX9.0
  PPD3DXMatrix = ^PD3DXMatrix;
  PD3DXMatrix = ^TD3DXMatrix;
  {$EXTERNALSYM PD3DXMatrix}
  TD3DXMatrix = TD3DMatrix;
  {$NODEFINE TD3DXMatrix}



  PD3DViewport9 = ^TD3DViewport9;
  _D3DVIEWPORT9 = packed record
    X: DWord;
    Y: DWord;         { Viewport Top left }
    Width: DWord;
    Height: DWord;    { Viewport Dimensions }
    MinZ: Single;       { Min/max of clip Volume }
    MaxZ: Single;
  end {_D3DVIEWPORT9};
  {$EXTERNALSYM _D3DVIEWPORT9}
  D3DVIEWPORT9 = _D3DVIEWPORT9;
  {$EXTERNALSYM D3DVIEWPORT9}
  TD3DViewport9 = _D3DVIEWPORT9;

type
  (*$HPPEMIT 'typedef D3DXVECTOR3       TD3DXVector3;' *)
  (*$HPPEMIT 'typedef D3DXVECTOR3      *PD3DXVector3;' *)
  PD3DXVector3 = ^TD3DXVector3;
  {$EXTERNALSYM PD3DXVector3}
  TD3DXVector3 = TD3DVector;
  {$NODEFINE TD3DXVector3}

// Some pascal equalents of C++ class functions & operators
const D3DXVector3Zero: TD3DXVector3 = (x:0; y:0; z:0);  // (0,0,0)
function D3DXVector3(_x, _y, _z: Single): TD3DXVector3;
function D3DXVector3Equal(const v1, v2: TD3DXVector3): Boolean;

type
  PDIDevCapsDX3 = ^TDIDevCapsDX3;
  DIDEVCAPS_DX3 = packed record
    dwSize:    DWORD;
    dwFlags:   DWORD;
    dwDevType: DWORD;
    dwAxes:    DWORD;
    dwButtons: DWORD;
    dwPOVs:    DWORD;
  end;
  {$EXTERNALSYM DIDEVCAPS_DX3}
  TDIDevCapsDX3 = DIDEVCAPS_DX3;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)

  PDIDevCaps = ^TDIDevCaps;
  DIDEVCAPS = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwDevType: DWORD;
    dwAxes: DWORD;
    dwButtons: DWORD;
    dwPOVs: DWORD;
{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
    dwFFSamplePeriod: DWORD;
    dwFFMinTimeResolution: DWORD;
    dwFirmwareRevision: DWORD;
    dwHardwareRevision: DWORD;
    dwFFDriverVersion: DWORD;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)
  end;
  {$EXTERNALSYM DIDEVCAPS}
  TDIDevCaps = DIDEVCAPS;

const
  DIDC_ATTACHED           = $00000001;
  {$EXTERNALSYM DIDC_ATTACHED}
  DIDC_POLLEDDEVICE       = $00000002;
  {$EXTERNALSYM DIDC_POLLEDDEVICE}
  DIDC_EMULATED           = $00000004;
  {$EXTERNALSYM DIDC_EMULATED}
  DIDC_POLLEDDATAFORMAT   = $00000008;
  {$EXTERNALSYM DIDC_POLLEDDATAFORMAT}
{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
  DIDC_FORCEFEEDBACK      = $00000100;
  {$EXTERNALSYM DIDC_FORCEFEEDBACK}
  DIDC_FFATTACK           = $00000200;
  {$EXTERNALSYM DIDC_FFATTACK}
  DIDC_FFFADE             = $00000400;
  {$EXTERNALSYM DIDC_FFFADE}
  DIDC_SATURATION         = $00000800;
  {$EXTERNALSYM DIDC_SATURATION}
  DIDC_POSNEGCOEFFICIENTS = $00001000;
  {$EXTERNALSYM DIDC_POSNEGCOEFFICIENTS}
  DIDC_POSNEGSATURATION   = $00002000;
  {$EXTERNALSYM DIDC_POSNEGSATURATION}
  DIDC_DEADBAND           = $00004000;
  {$EXTERNALSYM DIDC_DEADBAND}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)
  DIDC_STARTDELAY         = $00008000;
  {$EXTERNALSYM DIDC_STARTDELAY}
{$IFDEF DIRECTINPUT_VERSION_5b} (* #if(DIRECTINPUT_VERSION >= 0x050a) *)
  DIDC_ALIAS              = $00010000;
  {$EXTERNALSYM DIDC_ALIAS}
  DIDC_PHANTOM            = $00020000;
  {$EXTERNALSYM DIDC_PHANTOM}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x050a *)
{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION >= 0x0800) *)
  DIDC_HIDDEN             = $00040000;
  {$EXTERNALSYM DIDC_HIDDEN}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0800 *)

  DIDFT_ALL           = $00000000;
  {$EXTERNALSYM DIDFT_ALL}

  DIDFT_RELAXIS       = $00000001;
  {$EXTERNALSYM DIDFT_RELAXIS}
  DIDFT_ABSAXIS       = $00000002;
  {$EXTERNALSYM DIDFT_ABSAXIS}
  DIDFT_AXIS          = $00000003;
  {$EXTERNALSYM DIDFT_AXIS}

  DIDFT_PSHBUTTON     = $00000004;
  {$EXTERNALSYM DIDFT_PSHBUTTON}
  DIDFT_TGLBUTTON     = $00000008;
  {$EXTERNALSYM DIDFT_TGLBUTTON}
  DIDFT_BUTTON        = $0000000C;
  {$EXTERNALSYM DIDFT_BUTTON}

  DIDFT_POV           = $00000010;
  {$EXTERNALSYM DIDFT_POV}
  DIDFT_COLLECTION    = $00000040;
  {$EXTERNALSYM DIDFT_COLLECTION}
  DIDFT_NODATA        = $00000080;
  {$EXTERNALSYM DIDFT_NODATA}
  DIDFT_OPTIONAL      = $80000000;
  DIDFT_ANYINSTANCE   = $00FFFF00;
  {$EXTERNALSYM DIDFT_ANYINSTANCE}
  DIDFT_INSTANCEMASK  = DIDFT_ANYINSTANCE;
  {$EXTERNALSYM DIDFT_INSTANCEMASK}

// #define DIDFT_MAKEINSTANCE(n) ((WORD)(n) << 8)
function DIDFT_MAKEINSTANCE(n: Cardinal): Cardinal;
{$EXTERNALSYM DIDFT_MAKEINSTANCE}
// #define DIDFT_GETTYPE(n)     LOBYTE(n)
function DIDFT_GETTYPE(n: Cardinal): Byte;
{$EXTERNALSYM DIDFT_GETTYPE}
// #define DIDFT_GETINSTANCE(n) LOWORD((n) >> 8)
function DIDFT_GETINSTANCE(n: Cardinal): Cardinal;
{$EXTERNALSYM DIDFT_GETINSTANCE}

const
  DIDFT_FFACTUATOR        = $01000000;
  {$EXTERNALSYM DIDFT_FFACTUATOR}
  DIDFT_FFEFFECTTRIGGER   = $02000000;
  {$EXTERNALSYM DIDFT_FFEFFECTTRIGGER}
{$IFDEF DIRECTINPUT_VERSION_5b} (* #if(DIRECTINPUT_VERSION >= 0x050a) *)
  DIDFT_OUTPUT            = $10000000;
  {$EXTERNALSYM DIDFT_OUTPUT}
  DIDFT_VENDORDEFINED     = $04000000;
  {$EXTERNALSYM DIDFT_VENDORDEFINED}
  DIDFT_ALIAS             = $08000000;
  {$EXTERNALSYM DIDFT_ALIAS}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x050a *)

// #define DIDFT_ENUMCOLLECTION(n) ((WORD)(n) << 8)
function DIDFT_ENUMCOLLECTION(n: Cardinal): Cardinal;
{$EXTERNALSYM DIDFT_ENUMCOLLECTION}

const
  DIDFT_NOCOLLECTION      = $00FFFF00;
  {$EXTERNALSYM DIDFT_NOCOLLECTION}

type
  PDIObjectDataFormat = ^TDIObjectDataFormat;
  _DIOBJECTDATAFORMAT = packed record
    pguid: PGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
  end;
  {$EXTERNALSYM _DIOBJECTDATAFORMAT}
  DIOBJECTDATAFORMAT = _DIOBJECTDATAFORMAT;
  {$EXTERNALSYM DIOBJECTDATAFORMAT}
  TDIObjectDataFormat = _DIOBJECTDATAFORMAT;

  MouseState = packed record
    lAxisX:integer;
    lAxisY:integer;
    abButtons: array [0..2] of BYTE;
    bPadding:byte;
  end;

  PDIDataFormat = ^TDIDataFormat;
  _DIDATAFORMAT = packed record
    dwSize: DWORD;
    dwObjSize: DWORD;
    dwFlags: DWORD;
    dwDataSize: DWORD;
    dwNumObjs: DWORD;
    rgodf: PDIObjectDataFormat;
  end;
  {$EXTERNALSYM _DIDATAFORMAT}
  DIDATAFORMAT = _DIDATAFORMAT;
  {$EXTERNALSYM DIDATAFORMAT}
  TDIDataFormat = _DIDATAFORMAT;

const
  DIDF_ABSAXIS            = $00000001;
  {$EXTERNALSYM DIDF_ABSAXIS}
  DIDF_RELAXIS            = $00000002;
  {$EXTERNALSYM DIDF_RELAXIS}


{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION > 0x0700) *)

type
  PDIActionA = ^TDIActionA;
  PDIActionW = ^TDIActionW;
  PDIAction = PDIActionA;
  _DIACTIONA = packed record
    uAppData: Pointer;
    dwSemantic: DWORD;
    dwFlags: DWORD;
    case Byte of
      0: (
        lptszActionName: PAnsiChar;
        guidInstance: TGUID;
        dwObjID: DWORD;
        dwHow: DWORD;
       );
      1: (
        uResIdString: LongWord;
      );
  end;
  {$EXTERNALSYM _DIACTIONA}
  _DIACTIONW = packed record
    uAppData: Pointer;
    dwSemantic: DWORD;
    dwFlags: DWORD;
    case Byte of
      0: (
        lptszActionName: PWideChar;
        guidInstance: TGUID;
        dwObjID: DWORD;
        dwHow: DWORD;
       );
      1: (
        uResIdString: LongWord;
      );
  end;
  {$EXTERNALSYM _DIACTIONW}
  _DIACTION = _DIACTIONA;
  {$EXTERNALSYM _DIACTION}
  DIACTIONA = _DIACTIONA;
  {$EXTERNALSYM DIACTIONA}
  DIACTIONW = _DIACTIONW;
  {$EXTERNALSYM DIACTIONW}
  DIACTION = DIACTIONA;
  {$EXTERNALSYM DIACTION}
  TDIActionA = _DIACTIONA;
  TDIActionW = _DIACTIONW;
  TDIAction = TDIActionA;

const
  DIA_FORCEFEEDBACK       = $00000001;
  {$EXTERNALSYM DIA_FORCEFEEDBACK}
  DIA_APPMAPPED           = $00000002;
  {$EXTERNALSYM DIA_APPMAPPED}
  DIA_APPNOMAP            = $00000004;
  {$EXTERNALSYM DIA_APPNOMAP}
  DIA_NORANGE             = $00000008;
  {$EXTERNALSYM DIA_NORANGE}
  DIA_APPFIXED            = $00000010;
  {$EXTERNALSYM DIA_APPFIXED}

  DIAH_UNMAPPED           = $00000000;
  {$EXTERNALSYM DIAH_UNMAPPED}
  DIAH_USERCONFIG         = $00000001;
  {$EXTERNALSYM DIAH_USERCONFIG}
  DIAH_APPREQUESTED       = $00000002;
  {$EXTERNALSYM DIAH_APPREQUESTED}
  DIAH_HWAPP              = $00000004;
  {$EXTERNALSYM DIAH_HWAPP}
  DIAH_HWDEFAULT          = $00000008;
  {$EXTERNALSYM DIAH_HWDEFAULT}
  DIAH_DEFAULT            = $00000020;
  {$EXTERNALSYM DIAH_DEFAULT}
  DIAH_ERROR              = $80000000;
  {$EXTERNALSYM DIAH_ERROR}

type
  PDIActionFormatA = ^TDIActionFormatA;
  PDIActionFormatW = ^TDIActionFormatW;
  PDIActionFormat = PDIActionFormatA;
  _DIACTIONFORMATA = packed record
    dwSize        : DWORD;
    dwActionSize  : DWORD;
    dwDataSize    : DWORD;
    dwNumActions  : DWORD;
    rgoAction     : PDIActionA;
    guidActionMap : TGUID;
    dwGenre       : DWORD;
    dwBufferSize  : DWORD;
    lAxisMin      : Longint;
    lAxisMax      : Longint;
    hInstString   : THandle;
    ftTimeStamp   : TFileTime;
    dwCRC         : DWORD;
    tszActionMap  : array [0..MAX_PATH-1] of AnsiChar;
  end;
  {$EXTERNALSYM _DIACTIONFORMATA}
  _DIACTIONFORMATW = packed record
    dwSize        : DWORD;
    dwActionSize  : DWORD;
    dwDataSize    : DWORD;
    dwNumActions  : DWORD;
    rgoAction     : PDIActionW;
    guidActionMap : TGUID;
    dwGenre       : DWORD;
    dwBufferSize  : DWORD;
    lAxisMin      : Longint;
    lAxisMax      : Longint;
    hInstString   : THandle;
    ftTimeStamp   : TFileTime;
    dwCRC         : DWORD;
    tszActionMap  : array [0..MAX_PATH-1] of WideChar;
  end;
  {$EXTERNALSYM _DIACTIONFORMATW}
  _DIACTIONFORMAT = _DIACTIONFORMATA;
  {$EXTERNALSYM _DIACTIONFORMAT}
  DIACTIONFORMATA = _DIACTIONFORMATA;
  {$EXTERNALSYM DIACTIONFORMATA}
  DIACTIONFORMATW = _DIACTIONFORMATW;
  {$EXTERNALSYM DIACTIONFORMATW}
  DIACTIONFORMAT = DIACTIONFORMATA;
  {$EXTERNALSYM DIACTIONFORMAT}
  TDIActionFormatA = _DIACTIONFORMATA;
  TDIActionFormatW = _DIACTIONFORMATW;
  TDIActionFormat = TDIActionFormatA;

const
  DIAFTS_NEWDEVICELOW     = $FFFFFFFF;
  {$EXTERNALSYM DIAFTS_NEWDEVICELOW}
  DIAFTS_NEWDEVICEHIGH    = $FFFFFFFF;
  {$EXTERNALSYM DIAFTS_NEWDEVICEHIGH}
  DIAFTS_UNUSEDDEVICELOW  = $00000000;
  {$EXTERNALSYM DIAFTS_UNUSEDDEVICELOW}
  DIAFTS_UNUSEDDEVICEHIGH = $00000000;
  {$EXTERNALSYM DIAFTS_UNUSEDDEVICEHIGH}

  DIDBAM_DEFAULT          = $00000000;
  {$EXTERNALSYM DIDBAM_DEFAULT}
  DIDBAM_PRESERVE         = $00000001;
  {$EXTERNALSYM DIDBAM_PRESERVE}
  DIDBAM_INITIALIZE       = $00000002;
  {$EXTERNALSYM DIDBAM_INITIALIZE}
  DIDBAM_HWDEFAULTS       = $00000004;
  {$EXTERNALSYM DIDBAM_HWDEFAULTS}

  DIDSAM_DEFAULT          = $00000000;
  {$EXTERNALSYM DIDSAM_DEFAULT}
  DIDSAM_NOUSER           = $00000001;
  {$EXTERNALSYM DIDSAM_NOUSER}
  DIDSAM_FORCESAVE        = $00000002;
  {$EXTERNALSYM DIDSAM_FORCESAVE}

  DICD_DEFAULT            = $00000000;
  {$EXTERNALSYM DICD_DEFAULT}
  DICD_EDIT               = $00000001;
  {$EXTERNALSYM DICD_EDIT}



type
  PDIColorSet = ^TDIColorSet;
  _DICOLORSET = packed record
    dwSize: DWORD;
    cTextFore: TD3DColor;
    cTextHighlight: TD3DColor;
    cCalloutLine: TD3DColor;
    cCalloutHighlight: TD3DColor;
    cBorder: TD3DColor;
    cControlFill: TD3DColor;
    cHighlightFill: TD3DColor;
    cAreaFill: TD3DColor;
  end;
  {$EXTERNALSYM _DICOLORSET}
  DICOLORSET = _DICOLORSET;
  {$EXTERNALSYM DICOLORSET}
  TDIColorSet = _DICOLORSET;

  PDIConfigureDevicesParamsA = ^TDIConfigureDevicesParamsA;
  PDIConfigureDevicesParamsW = ^TDIConfigureDevicesParamsW;
  PDIConfigureDevicesParams = PDIConfigureDevicesParamsA;
  _DICONFIGUREDEVICESPARAMSA = packed record
     dwSize:         DWORD;
     dwcUsers:       DWORD;
     lptszUserNames: PAnsiChar;
     dwcFormats:     DWORD;
     lprgFormats:    PDIActionFormatA;
     hwnd:           HWND;
     dics:           TDIColorSet;
     lpUnkDDSTarget: IUnknown;
  end;
  {$EXTERNALSYM _DICONFIGUREDEVICESPARAMSA}
  _DICONFIGUREDEVICESPARAMSW = packed record
     dwSize:         DWORD;
     dwcUsers:       DWORD;
     lptszUserNames: PWideChar;
     dwcFormats:     DWORD;
     lprgFormats:    PDIActionFormatW;
     hwnd:           HWND;
     dics:           TDIColorSet;
     lpUnkDDSTarget: IUnknown;
  end;
  {$EXTERNALSYM _DICONFIGUREDEVICESPARAMSW}
  _DICONFIGUREDEVICESPARAMS = _DICONFIGUREDEVICESPARAMSA;
  {$EXTERNALSYM _DICONFIGUREDEVICESPARAMS}
  DICONFIGUREDEVICESPARAMSA = _DICONFIGUREDEVICESPARAMSA;
  {$EXTERNALSYM DICONFIGUREDEVICESPARAMSA}
  DICONFIGUREDEVICESPARAMSW = _DICONFIGUREDEVICESPARAMSW;
  {$EXTERNALSYM DICONFIGUREDEVICESPARAMSW}
  DICONFIGUREDEVICESPARAMS = DICONFIGUREDEVICESPARAMSA;
  {$EXTERNALSYM DICONFIGUREDEVICESPARAMS}
  TDIConfigureDevicesParamsA = _DICONFIGUREDEVICESPARAMSA;
  TDIConfigureDevicesParamsW = _DICONFIGUREDEVICESPARAMSW;
  TDIConfigureDevicesParams = TDIConfigureDevicesParamsA;

const
  DIDIFT_CONFIGURATION    = $00000001;
  {$EXTERNALSYM DIDIFT_CONFIGURATION}
  DIDIFT_OVERLAY          = $00000002;
  {$EXTERNALSYM DIDIFT_OVERLAY}

  DIDAL_CENTERED      = $00000000;
  {$EXTERNALSYM DIDAL_CENTERED}
  DIDAL_LEFTALIGNED   = $00000001;
  {$EXTERNALSYM DIDAL_LEFTALIGNED}
  DIDAL_RIGHTALIGNED  = $00000002;
  {$EXTERNALSYM DIDAL_RIGHTALIGNED}
  DIDAL_MIDDLE        = $00000000;
  {$EXTERNALSYM DIDAL_MIDDLE}
  DIDAL_TOPALIGNED    = $00000004;
  {$EXTERNALSYM DIDAL_TOPALIGNED}
  DIDAL_BOTTOMALIGNED = $00000008;
  {$EXTERNALSYM DIDAL_BOTTOMALIGNED}

type
  PDIDeviceImageInfoA = ^TDIDeviceImageInfoA;
  PDIDeviceImageInfoW = ^TDIDeviceImageInfoW;
  PDIDeviceImageInfo = PDIDeviceImageInfoA;
  _DIDEVICEIMAGEINFOA = packed record
    tszImagePath: array [0..MAX_PATH-1] of AnsiChar;
    dwFlags:         DWORD;
    // These are valid if DIDIFT_OVERLAY is present in dwFlags.
    dwViewID:        DWORD;
    rcOverlay:       TRect;
    dwObjID:         DWORD;
    dwcValidPts:     DWORD;
    rgptCalloutLine: array [0..4] of TPoint;
    rcCalloutRect:   TRect;
    dwTextAlign:     DWORD;
  end;
  {$EXTERNALSYM _DIDEVICEIMAGEINFOA}
  _DIDEVICEIMAGEINFOW = packed record
    tszImagePath: array [0..MAX_PATH-1] of WideChar;
    dwFlags:         DWORD;
    // These are valid if DIDIFT_OVERLAY is present in dwFlags.
    dwViewID:        DWORD;
    rcOverlay:       TRect;
    dwObjID:         DWORD;
    dwcValidPts:     DWORD;
    rgptCalloutLine: array [0..4] of TPoint;
    rcCalloutRect:   TRect;
    dwTextAlign:     DWORD;
  end;
  {$EXTERNALSYM _DIDEVICEIMAGEINFOW}
  _DIDEVICEIMAGEINFO = _DIDEVICEIMAGEINFOA;
  {$EXTERNALSYM _DIDEVICEIMAGEINFO}
  DIDEVICEIMAGEINFOA = _DIDEVICEIMAGEINFOA;
  {$EXTERNALSYM DIDEVICEIMAGEINFOA}
  DIDEVICEIMAGEINFOW = _DIDEVICEIMAGEINFOW;
  {$EXTERNALSYM DIDEVICEIMAGEINFOW}
  DIDEVICEIMAGEINFO = DIDEVICEIMAGEINFOA;
  {$EXTERNALSYM DIDEVICEIMAGEINFO}
  TDIDeviceImageInfoA = _DIDEVICEIMAGEINFOA;
  TDIDeviceImageInfoW = _DIDEVICEIMAGEINFOW;
  TDIDeviceImageInfo = TDIDeviceImageInfoA;

  PDIDeviceImageInfoHeaderA = ^TDIDeviceImageInfoHeaderA;
  PDIDeviceImageInfoHeaderW = ^TDIDeviceImageInfoHeaderW;
  PDIDeviceImageInfoHeader = PDIDeviceImageInfoHeaderA;
  _DIDEVICEIMAGEINFOHEADERA = packed record
    dwSize:             DWORD;
    dwSizeImageInfo:    DWORD;
    dwcViews:           DWORD;
    dwcButtons:         DWORD;
    dwcAxes:            DWORD;
    dwcPOVs:            DWORD;
    dwBufferSize:       DWORD;
    dwBufferUsed:       DWORD;
    lprgImageInfoArray: PDIDeviceImageInfoA;
  end;
  {$EXTERNALSYM _DIDEVICEIMAGEINFOHEADERA}
  _DIDEVICEIMAGEINFOHEADERW = packed record
    dwSize:             DWORD;
    dwSizeImageInfo:    DWORD;
    dwcViews:           DWORD;
    dwcButtons:         DWORD;
    dwcAxes:            DWORD;
    dwcPOVs:            DWORD;
    dwBufferSize:       DWORD;
    dwBufferUsed:       DWORD;
    lprgImageInfoArray: PDIDeviceImageInfoW;
  end;
  {$EXTERNALSYM _DIDEVICEIMAGEINFOHEADERW}
  _DIDEVICEIMAGEINFOHEADER = _DIDEVICEIMAGEINFOHEADERA;
  {$EXTERNALSYM _DIDEVICEIMAGEINFOHEADER}
  DIDEVICEIMAGEINFOHEADERA = _DIDEVICEIMAGEINFOHEADERA;
  {$EXTERNALSYM _DIDEVICEIMAGEINFOHEADERA}
  DIDEVICEIMAGEINFOHEADERW = _DIDEVICEIMAGEINFOHEADERW;
  {$EXTERNALSYM _DIDEVICEIMAGEINFOHEADERW}
  DIDEVICEIMAGEINFOHEADER = DIDEVICEIMAGEINFOHEADERA;
  {$EXTERNALSYM _DIDEVICEIMAGEINFOHEADER}
  TDIDeviceImageInfoHeaderA = _DIDEVICEIMAGEINFOHEADERA;
  TDIDeviceImageInfoHeaderW = _DIDEVICEIMAGEINFOHEADERW;
  TDIDeviceImageInfoHeader = TDIDeviceImageInfoHeaderA;

{$ENDIF} (* DIRECTINPUT_VERSION > 0x0700 *)

{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
(* These structures are defined for DirectX 3.0 compatibility *)

type
  PDIDeviceObjectInstanceDX3A = ^TDIDeviceObjectInstanceDX3A;
  PDIDeviceObjectInstanceDX3W = ^TDIDeviceObjectInstanceDX3W;
  PDIDeviceObjectInstanceDX3 = PDIDeviceObjectInstanceDX3A;
  DIDEVICEOBJECTINSTANCE_DX3A = packed record
    dwSize:   DWORD;
    guidType: TGUID;
    dwOfs:    DWORD;
    dwType:   DWORD;
    dwFlags:  DWORD;
    tszName: array [0..MAX_PATH-1] of AnsiChar;
  end;
  {$EXTERNALSYM DIDEVICEOBJECTINSTANCE_DX3A}
  DIDEVICEOBJECTINSTANCE_DX3W = packed record
    dwSize:   DWORD;
    guidType: TGUID;
    dwOfs:    DWORD;
    dwType:   DWORD;
    dwFlags:  DWORD;
    tszName: array [0..MAX_PATH-1] of WideChar;
  end;
  {$EXTERNALSYM DIDEVICEOBJECTINSTANCE_DX3W}
  DIDEVICEOBJECTINSTANCE_DX3 = DIDEVICEOBJECTINSTANCE_DX3A;
  {$EXTERNALSYM DIDEVICEOBJECTINSTANCE_DX3}
  TDIDeviceObjectInstanceDX3A = DIDEVICEOBJECTINSTANCE_DX3A;
  TDIDeviceObjectInstanceDX3W = DIDEVICEOBJECTINSTANCE_DX3W;
  TDIDeviceObjectInstanceDX3 = TDIDeviceObjectInstanceDX3A;

{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)

type
  PDIDeviceObjectInstanceA = ^TDIDeviceObjectInstanceA;
  PDIDeviceObjectInstanceW = ^TDIDeviceObjectInstanceW;
  PDIDeviceObjectInstance = PDIDeviceObjectInstanceA;
  DIDEVICEOBJECTINSTANCEA = packed record
    dwSize:              DWORD;
    guidType:            TGUID;
    dwOfs:               DWORD;
    dwType:              DWORD;
    dwFlags:             DWORD;
    tszName: array[0..MAX_PATH-1] of AnsiChar;
{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
    dwFFMaxForce:        DWORD;
    dwFFForceResolution: DWORD;
    wCollectionNumber:   Word;
    wDesignatorIndex:    Word;
    wUsagePage:          Word;
    wUsage:              Word;
    dwDimension:         DWORD;
    wExponent:           Word;
    wReportId:           Word;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)
  end;
  {$EXTERNALSYM DIDEVICEOBJECTINSTANCEA}
  DIDEVICEOBJECTINSTANCEW = packed record
    dwSize:              DWORD;
    guidType:            TGUID;
    dwOfs:               DWORD;
    dwType:              DWORD;
    dwFlags:             DWORD;
    tszName: array[0..MAX_PATH-1] of WideChar;
{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
    dwFFMaxForce:        DWORD;
    dwFFForceResolution: DWORD;
    wCollectionNumber:   Word;
    wDesignatorIndex:    Word;
    wUsagePage:          Word;
    wUsage:              Word;
    dwDimension:         DWORD;
    wExponent:           Word;
    wReportId:           Word;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)
  end;
  {$EXTERNALSYM DIDEVICEOBJECTINSTANCEW}
  DIDEVICEOBJECTINSTANCE = DIDEVICEOBJECTINSTANCEA;
  {$EXTERNALSYM DIDEVICEOBJECTINSTANCE}
  TDIDeviceObjectInstanceA = DIDEVICEOBJECTINSTANCEA;
  TDIDeviceObjectInstanceW = DIDEVICEOBJECTINSTANCEW;
  TDIDeviceObjectInstance = TDIDeviceObjectInstanceA;


type
  TDIEnumDeviceObjectsCallbackA = function (var lpddoi: TDIDeviceObjectInstanceA; pvRef : Pointer): BOOL; stdcall;
  {$EXTERNALSYM TDIEnumDeviceObjectsCallbackA}
  TDIEnumDeviceObjectsCallbackW = function (var lpddoi: TDIDeviceObjectInstanceW; pvRef : Pointer): BOOL; stdcall;
  {$EXTERNALSYM TDIEnumDeviceObjectsCallbackW}
  TDIEnumDeviceObjectsCallback = TDIEnumDeviceObjectsCallbackA;
  {$EXTERNALSYM TDIEnumDeviceObjectsCallback}


{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
const
  DIDOI_FFACTUATOR        = $00000001;
  {$EXTERNALSYM DIDOI_FFACTUATOR}
  DIDOI_FFEFFECTTRIGGER   = $00000002;
  {$EXTERNALSYM DIDOI_FFEFFECTTRIGGER}
  DIDOI_POLLED            = $00008000;
  {$EXTERNALSYM DIDOI_POLLED}
  DIDOI_ASPECTPOSITION    = $00000100;
  {$EXTERNALSYM DIDOI_ASPECTPOSITION}
  DIDOI_ASPECTVELOCITY    = $00000200;
  {$EXTERNALSYM DIDOI_ASPECTVELOCITY}
  DIDOI_ASPECTACCEL       = $00000300;
  {$EXTERNALSYM DIDOI_ASPECTACCEL}
  DIDOI_ASPECTFORCE       = $00000400;
  {$EXTERNALSYM DIDOI_ASPECTFORCE}
  DIDOI_ASPECTMASK        = $00000F00;
  {$EXTERNALSYM DIDOI_ASPECTMASK}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)
{$IFDEF DIRECTINPUT_VERSION_5b} (* #if(DIRECTINPUT_VERSION >= 0x050a) *)
  DIDOI_GUIDISUSAGE       = $00010000;
  {$EXTERNALSYM DIDOI_GUIDISUSAGE}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x050a *)

type
  PDIPropHeader = ^TDIPropHeader;
  DIPROPHEADER = packed record
    dwSize: DWORD;
    dwHeaderSize: DWORD;
    dwObj: DWORD;
    dwHow: DWORD;
  end;
  {$EXTERNALSYM DIPROPHEADER}
  TDIPropHeader = DIPROPHEADER;

const
  DIPH_DEVICE             = 0;
  {$EXTERNALSYM DIPH_DEVICE}
  DIPH_BYOFFSET           = 1;
  {$EXTERNALSYM DIPH_BYOFFSET}
  DIPH_BYID               = 2;
  {$EXTERNALSYM DIPH_BYID}
{$IFDEF DIRECTINPUT_VERSION_5b} (* #if(DIRECTINPUT_VERSION >= 0x050a) *)
  DIPH_BYUSAGE            = 3;
  {$EXTERNALSYM DIPH_BYUSAGE}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x050a *)

{$IFDEF DIRECTINPUT_VERSION_5b} (* #if(DIRECTINPUT_VERSION >= 0x050a) *)
// #define DIMAKEUSAGEDWORD(UsagePage, Usage) \
//                                 (DWORD)MAKELONG(Usage, UsagePage)
function DIMAKEUSAGEDWORD(UsagePage, Usage: Word): DWORD;
{$EXTERNALSYM DIMAKEUSAGEDWORD}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x050a *)

type
  PDIPropDWord = ^TDIPropDWord;
  DIPROPDWORD = packed record
    diph: TDIPropHeader;
    dwData: DWORD;
  end;
  {$EXTERNALSYM DIPROPDWORD}
  TDIPropDWord = DIPROPDWORD;

{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION >= 0x0800) *)
  PDIPropPointer = ^TDIPropPointer;
  DIPROPPOINTER = packed record
    diph: TDIPropHeader;
    uData: Pointer;
  end;
  {$EXTERNALSYM DIPROPPOINTER}
  TDIPropPointer = DIPROPPOINTER;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0800 *)

  PDIPropRange = ^TDIPropRange;
  DIPROPRANGE = packed record
    diph: TDIPropHeader;
    lMin: Longint;
    lMax: Longint;
  end;
  {$EXTERNALSYM DIPROPRANGE}
  TDIPropRange = DIPROPRANGE;

const
  DIPROPRANGE_NOMIN       = $80000000;
  {$EXTERNALSYM DIPROPRANGE_NOMIN}
  DIPROPRANGE_NOMAX       = $7FFFFFFF;
  {$EXTERNALSYM DIPROPRANGE_NOMAX}

{$IFDEF DIRECTINPUT_VERSION_5b} (* #if(DIRECTINPUT_VERSION >= 0x050a) *)
type
  PDIPropCal = ^TDIPropCal;
  DIPROPCAL = packed record
    diph: TDIPropHeader;
    lMin: Longint;
    lCenter: Longint;
    lMax: Longint;
  end;
  {$EXTERNALSYM DIPROPCAL}
  TDIPropCal = DIPROPCAL;

  PDIPropCalPov = ^TDIPropCalPov;
  DIPROPCALPOV = packed record
    diph: TDIPropHeader;
    lMin: array[0..4] of Longint;
    lMax: array[0..4] of Longint;
  end;
  {$EXTERNALSYM DIPROPCALPOV}
  TDIPropCalPov = DIPROPCALPOV;

  PDIPropGuidAndPath = ^TDIPropGuidAndPath;
  DIPROPGUIDANDPATH = packed record
    diph: TDIPropHeader;
    guidClass: TGUID;
    wszPath: array[0..MAX_PATH-1] of WideChar;
  end;
  {$EXTERNALSYM DIPROPGUIDANDPATH}
  TDIPropGuidAndPath = DIPROPGUIDANDPATH;

  PDIPropString = ^TDIPropString;
  DIPROPSTRING = packed record
    diph: TDIPropHeader;
    wsz: array[0..MAX_PATH-1] of WideChar;
  end;
  {$EXTERNALSYM DIPROPSTRING}
  TDIPropString = DIPROPSTRING;

{$ENDIF} (* DIRECTINPUT_VERSION >= 0x050a *)

{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION >= 0x0800) *)
const
  MAXCPOINTSNUM          = 8;
  {$EXTERNALSYM MAXCPOINTSNUM}

type
  PCPoint = ^TCPoint;
  _CPOINT = packed record
    lP: Longint;   // raw value
    dwLog: DWORD;  // logical_value / max_logical_value * 10000
  end;
  {$EXTERNALSYM _CPOINT}
  CPOINT = _CPOINT;
  {$EXTERNALSYM CPOINT}
  TCPoint = _CPOINT;

  PDIPropCPoints = ^TDIPropCPoints;
  DIPROPCPOINTS = packed record
    diph: TDIPropHeader;
    dwCPointsNum: DWORD;
    cp: array[0..MAXCPOINTSNUM-1] of TCPoint;
  end;
  {$EXTERNALSYM DIPROPCPOINTS}
  TDIPropCPoints = DIPROPCPOINTS;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0800 *)


// #define MAKEDIPROP(prop)    (*(const GUID *)(prop))

type
  MAKEDIPROP = PGUID;
  {$EXTERNALSYM MAKEDIPROP}

const
  DIPROP_BUFFERSIZE       = MAKEDIPROP(1);
  {$EXTERNALSYM DIPROP_BUFFERSIZE}

  DIPROP_AXISMODE         = MAKEDIPROP(2);
  {$EXTERNALSYM DIPROP_AXISMODE}

  DIPROPAXISMODE_ABS      = 0;
  {$EXTERNALSYM DIPROPAXISMODE_ABS}
  DIPROPAXISMODE_REL      = 1;
  {$EXTERNALSYM DIPROPAXISMODE_REL}

  DIPROP_GRANULARITY      = MAKEDIPROP(3);
  {$EXTERNALSYM DIPROP_GRANULARITY}

  DIPROP_RANGE            = MAKEDIPROP(4);
  {$EXTERNALSYM DIPROP_RANGE}

  DIPROP_DEADZONE         = MAKEDIPROP(5);
  {$EXTERNALSYM DIPROP_DEADZONE}

  DIPROP_SATURATION       = MAKEDIPROP(6);
  {$EXTERNALSYM DIPROP_SATURATION}

  DIPROP_FFGAIN           = MAKEDIPROP(7);
  {$EXTERNALSYM DIPROP_FFGAIN}

  DIPROP_FFLOAD           = MAKEDIPROP(8);
  {$EXTERNALSYM DIPROP_FFLOAD}

  DIPROP_AUTOCENTER       = MAKEDIPROP(9);
  {$EXTERNALSYM DIPROP_AUTOCENTER}

  DIPROPAUTOCENTER_OFF    = 0;
  {$EXTERNALSYM DIPROPAUTOCENTER_OFF}
  DIPROPAUTOCENTER_ON     = 1;
  {$EXTERNALSYM DIPROPAUTOCENTER_ON}

  DIPROP_CALIBRATIONMODE  = MAKEDIPROP(10);
  {$EXTERNALSYM DIPROP_CALIBRATIONMODE}

  DIPROPCALIBRATIONMODE_COOKED    = 0;
  {$EXTERNALSYM DIPROPCALIBRATIONMODE_COOKED}
  DIPROPCALIBRATIONMODE_RAW       = 1;
  {$EXTERNALSYM DIPROPCALIBRATIONMODE_RAW}

{$IFDEF DIRECTINPUT_VERSION_5b} (* #if(DIRECTINPUT_VERSION >= 0x050a) *)
  DIPROP_CALIBRATION      = MAKEDIPROP(11);
  {$EXTERNALSYM DIPROP_CALIBRATION}

  DIPROP_GUIDANDPATH      = MAKEDIPROP(12);
  {$EXTERNALSYM DIPROP_GUIDANDPATH}

  DIPROP_INSTANCENAME     = MAKEDIPROP(13);
  {$EXTERNALSYM DIPROP_INSTANCENAME}

  DIPROP_PRODUCTNAME      = MAKEDIPROP(14);
  {$EXTERNALSYM DIPROP_PRODUCTNAME}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x050a *)

{$IFDEF DIRECTINPUT_VERSION_5b} (* #if(DIRECTINPUT_VERSION >= 0x05b2) *)
  DIPROP_JOYSTICKID       = MAKEDIPROP(15);
  {$EXTERNALSYM DIPROP_JOYSTICKID}

  DIPROP_GETPORTDISPLAYNAME = MAKEDIPROP(16);
  {$EXTERNALSYM DIPROP_GETPORTDISPLAYNAME}

{$ENDIF} (* DIRECTINPUT_VERSION >= 0x05b2 *)

{$IFDEF DIRECTINPUT_VERSION_7} (* #if(DIRECTINPUT_VERSION >= 0x0700) *)
  DIPROP_PHYSICALRANGE    = MAKEDIPROP(18);
  {$EXTERNALSYM DIPROP_PHYSICALRANGE}

  DIPROP_LOGICALRANGE     = MAKEDIPROP(19);
  {$EXTERNALSYM DIPROP_LOGICALRANGE}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0700 *)

{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION >= 0x0800) *)
  DIPROP_KEYNAME          = MAKEDIPROP(20);
  {$EXTERNALSYM DIPROP_KEYNAME}

  DIPROP_CPOINTS          = MAKEDIPROP(21);
  {$EXTERNALSYM DIPROP_CPOINTS}

  DIPROP_APPDATA          = MAKEDIPROP(22);
  {$EXTERNALSYM DIPROP_APPDATA}

  DIPROP_SCANCODE         = MAKEDIPROP(23);
  {$EXTERNALSYM DIPROP_SCANCODE}

  DIPROP_VIDPID           = MAKEDIPROP(24);
  {$EXTERNALSYM DIPROP_VIDPID}

  DIPROP_USERNAME         = MAKEDIPROP(25);
  {$EXTERNALSYM DIPROP_USERNAME}

  DIPROP_TYPENAME         = MAKEDIPROP(26);
  {$EXTERNALSYM DIPROP_TYPENAME}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0800 *)


type
  PDIDeviceObjectDataDX3 = ^TDIDeviceObjectDataDX3;
  DIDEVICEOBJECTDATA_DX3 = packed record
    dwOfs: DWORD;
    dwData: DWORD;
    dwTimeStamp: DWORD;
    dwSequence: DWORD;
  end;
  {$EXTERNALSYM DIDEVICEOBJECTDATA_DX3}
  TDIDeviceObjectDataDX3 = DIDEVICEOBJECTDATA_DX3;

  PDIDeviceObjectData = ^TDIDeviceObjectData;
  DIDEVICEOBJECTDATA = packed record
    dwOfs: DWORD;
    dwData: DWORD;
    dwTimeStamp: DWORD;
    dwSequence: DWORD;
{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION >= 0x0800) *)
    uAppData: Pointer;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0800 *)
  end;
  {$EXTERNALSYM DIDEVICEOBJECTDATA}
  TDIDeviceObjectData = DIDEVICEOBJECTDATA;

const
  DIGDD_PEEK          = $00000001;
  {$EXTERNALSYM DIGDD_PEEK}

// #define DISEQUENCE_COMPARE(dwSequence1, cmp, dwSequence2) \
//                         ((int)((dwSequence1) - (dwSequence2)) cmp 0)
// Translator: This is not convertable to pascal

const
  DISCL_EXCLUSIVE     = $00000001;
  {$EXTERNALSYM DISCL_EXCLUSIVE}
  DISCL_NONEXCLUSIVE  = $00000002;
  {$EXTERNALSYM DISCL_NONEXCLUSIVE}
  DISCL_FOREGROUND    = $00000004;
  {$EXTERNALSYM DISCL_FOREGROUND}
  DISCL_BACKGROUND    = $00000008;
  {$EXTERNALSYM DISCL_BACKGROUND}
  DISCL_NOWINKEY      = $00000010;
  {$EXTERNALSYM DISCL_NOWINKEY}

{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
(* These structures are defined for DirectX 3.0 compatibility *)

type
  PDIDeviceInstanceDX3A = ^TDIDeviceInstanceDX3A;
  PDIDeviceInstanceDX3W = ^TDIDeviceInstanceDX3W;
  PDIDeviceInstanceDX3 = PDIDeviceInstanceDX3A;
  DIDEVICEINSTANCE_DX3A = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: array[0..MAX_PATH-1] of AnsiChar;
    tszProductName: array[0..MAX_PATH-1] of AnsiChar;
  end;
  {$EXTERNALSYM DIDEVICEINSTANCE_DX3A}
  DIDEVICEINSTANCE_DX3W = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: array[0..MAX_PATH-1] of WideChar;
    tszProductName: array[0..MAX_PATH-1] of WideChar;
  end;
  {$EXTERNALSYM DIDEVICEINSTANCE_DX3W}
  DIDEVICEINSTANCE_DX3 = DIDEVICEINSTANCE_DX3A;
  {$EXTERNALSYM DIDEVICEINSTANCE_DX3}
  TDIDeviceInstanceDX3A = DIDEVICEINSTANCE_DX3A;
  TDIDeviceInstanceDX3W = DIDEVICEINSTANCE_DX3W;
  TDIDeviceInstanceDX3 = TDIDeviceInstanceDX3A;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)

type
  PDIDeviceInstanceA = ^TDIDeviceInstanceA;
  PDIDeviceInstanceW = ^TDIDeviceInstanceW;
  PDIDeviceInstance = PDIDeviceInstanceA;
  DIDEVICEINSTANCEA = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: array[0..MAX_PATH-1] of AnsiChar;
    tszProductName: array[0..MAX_PATH-1] of AnsiChar;
{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
    guidFFDriver: TGUID;
    wUsagePage: Word;
    wUsage: Word;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)
  end;
  {$EXTERNALSYM DIDEVICEINSTANCEA}
  DIDEVICEINSTANCEW = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: array[0..MAX_PATH-1] of WideChar;
    tszProductName: array[0..MAX_PATH-1] of WideChar;
{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
    guidFFDriver: TGUID;
    wUsagePage: Word;
    wUsage: Word;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)
  end;
  {$EXTERNALSYM DIDEVICEINSTANCEW}
  DIDEVICEINSTANCE = DIDEVICEINSTANCEA;
  {$EXTERNALSYM DIDEVICEINSTANCE}
  TDIDeviceInstanceA = DIDEVICEINSTANCEA;
  TDIDeviceInstanceW = DIDEVICEINSTANCEW;
  TDIDeviceInstance = TDIDeviceInstanceA;


type
  {$EXTERNALSYM IDirectInputDeviceA}
  IDirectInputDeviceA = interface(IUnknown)
    [SID_IDirectInputDeviceA]
    (*** IDirectInputDeviceA methods ***)
    function GetCapabilities(var lpDIDevCaps: TDIDevCaps): HResult; stdcall;
    function EnumObjects(lpCallback: TDIEnumDeviceObjectsCallbackA; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetProperty(rguidProp: PGUID; var pdiph: TDIPropHeader): HResult; stdcall;
    function SetProperty(rguidProp: PGUID; const pdiph: TDIPropHeader): HResult; stdcall;
    function Acquire: HResult; stdcall;
    function Unacquire: HResult; stdcall;
    function GetDeviceState(cbData: DWORD; lpvData: Pointer): HResult; stdcall;
    function GetDeviceData(cbObjectData: DWORD; rgdod: PDIDeviceObjectData; out pdwInOut: DWORD; dwFlags: DWORD): HResult; stdcall;
    function SetDataFormat(var lpdf: TDIDataFormat): HResult; stdcall;
    function SetEventNotification(hEvent: THandle): HResult; stdcall;
    function SetCooperativeLevel(hwnd: HWND; dwFlags: DWORD): HResult; stdcall;
    function GetObjectInfo(var pdidoi: TDIDeviceObjectInstanceA; dwObj, dwHow: DWORD): HResult; stdcall;
    function GetDeviceInfo(var pdidi: TDIDeviceInstanceA): HResult; stdcall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD): HResult; stdcall;
    function Initialize(hinst: THandle; dwVersion: DWORD; const rguid: TGUID): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInputDeviceW}
  IDirectInputDeviceW = interface(IUnknown)
    [SID_IDirectInputDeviceW]
    (*** IDirectInputDeviceW methods ***)
    function GetCapabilities(var lpDIDevCaps: TDIDevCaps): HResult; stdcall;
    function EnumObjects(lpCallback: TDIEnumDeviceObjectsCallbackW; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetProperty(rguidProp: PGUID; var pdiph: TDIPropHeader): HResult; stdcall;
    function SetProperty(rguidProp: PGUID; const pdiph: TDIPropHeader): HResult; stdcall;
    function Acquire: HResult; stdcall;
    function Unacquire: HResult; stdcall;
    function GetDeviceState(cbData: DWORD; lpvData: Pointer): HResult; stdcall;
    function GetDeviceData(cbObjectData: DWORD; rgdod: PDIDeviceObjectData; out pdwInOut: DWORD; dwFlags: DWORD): HResult; stdcall;
    function SetDataFormat(var lpdf: TDIDataFormat): HResult; stdcall;
    function SetEventNotification(hEvent: THandle): HResult; stdcall;
    function SetCooperativeLevel(hwnd: HWND; dwFlags: DWORD): HResult; stdcall;
    function GetObjectInfo(var pdidoi: TDIDeviceObjectInstanceW; dwObj, dwHow: DWORD): HResult; stdcall;
    function GetDeviceInfo(var pdidi: TDIDeviceInstanceW): HResult; stdcall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD): HResult; stdcall;
    function Initialize(hinst: THandle; dwVersion: DWORD; const rguid: TGUID): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInputDevice}
  IDirectInputDevice = IDirectInputDeviceA;
type
  IID_IDirectInputDevice = IDirectInputDevice;
  {$EXTERNALSYM IID_IDirectInputDevice}

{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)

const
  DISFFC_RESET            = $00000001;
  {$EXTERNALSYM DISFFC_RESET}
  DISFFC_STOPALL          = $00000002;
  {$EXTERNALSYM DISFFC_STOPALL}
  DISFFC_PAUSE            = $00000004;
  {$EXTERNALSYM DISFFC_PAUSE}
  DISFFC_CONTINUE         = $00000008;
  {$EXTERNALSYM DISFFC_CONTINUE}
  DISFFC_SETACTUATORSON   = $00000010;
  {$EXTERNALSYM DISFFC_SETACTUATORSON}
  DISFFC_SETACTUATORSOFF  = $00000020;
  {$EXTERNALSYM DISFFC_SETACTUATORSOFF}

  DIGFFS_EMPTY            = $00000001;
  {$EXTERNALSYM DIGFFS_EMPTY}
  DIGFFS_STOPPED          = $00000002;
  {$EXTERNALSYM DIGFFS_STOPPED}
  DIGFFS_PAUSED           = $00000004;
  {$EXTERNALSYM DIGFFS_PAUSED}
  DIGFFS_ACTUATORSON      = $00000010;
  {$EXTERNALSYM DIGFFS_ACTUATORSON}
  DIGFFS_ACTUATORSOFF     = $00000020;
  {$EXTERNALSYM DIGFFS_ACTUATORSOFF}
  DIGFFS_POWERON          = $00000040;
  {$EXTERNALSYM DIGFFS_POWERON}
  DIGFFS_POWEROFF         = $00000080;
  {$EXTERNALSYM DIGFFS_POWEROFF}
  DIGFFS_SAFETYSWITCHON   = $00000100;
  {$EXTERNALSYM DIGFFS_SAFETYSWITCHON}
  DIGFFS_SAFETYSWITCHOFF  = $00000200;
  {$EXTERNALSYM DIGFFS_SAFETYSWITCHOFF}
  DIGFFS_USERFFSWITCHON   = $00000400;
  {$EXTERNALSYM DIGFFS_USERFFSWITCHON}
  DIGFFS_USERFFSWITCHOFF  = $00000800;
  {$EXTERNALSYM DIGFFS_USERFFSWITCHOFF}
  DIGFFS_DEVICELOST       = $80000000;
  {$EXTERNALSYM DIGFFS_DEVICELOST}

type
  PDIEffectInfoA = ^TDIEffectInfoA;
  PDIEffectInfoW = ^TDIEffectInfoW;
  PDIEffectInfo = PDIEffectInfoA;
  DIEFFECTINFOA = packed record
    dwSize: DWORD;
    guid: TGUID;
    dwEffType: DWORD;
    dwStaticParams: DWORD;
    dwDynamicParams: DWORD;
    tszName: array[0..MAX_PATH-1] of AnsiChar;
  end;
  {$EXTERNALSYM DIEFFECTINFOA}
  DIEFFECTINFOW = packed record
    dwSize: DWORD;
    guid: TGUID;
    dwEffType: DWORD;
    dwStaticParams: DWORD;
    dwDynamicParams: DWORD;
    tszName: array[0..MAX_PATH-1] of WideChar;
  end;
  {$EXTERNALSYM DIEFFECTINFOW}
  DIEFFECTINFO = DIEFFECTINFOA;
  {$EXTERNALSYM DIEFFECTINFO}
  TDIEffectInfoA = DIEFFECTINFOA;
  TDIEffectInfoW = DIEFFECTINFOW;
  TDIEffectInfo = TDIEffectInfoA;

const
  DISDD_CONTINUE          = $00000001;
  {$EXTERNALSYM DISDD_CONTINUE}

type
  TDIEnumEffectsCallbackA = function (var pdei: TDIEffectInfoA; pvRef: Pointer): BOOL; stdcall;
  {$NODEFINE TDIEnumEffectsCallbackA}
  (*$HPPEMIT 'typedef LPDIENUMEFFECTSCALLBACKA TDIEnumEffectsCallbackA;'*)
  TDIEnumEffectsCallbackW = function (var pdei: TDIEffectInfoW; pvRef: Pointer): BOOL; stdcall;
  {$NODEFINE TDIEnumEffectsCallbackW}
  (*$HPPEMIT 'typedef LPDIENUMEFFECTSCALLBACKW TDIEnumEffectsCallbackW;'*)
  TDIEnumEffectsCallback = TDIEnumEffectsCallbackA;
  {$NODEFINE TDIEnumEffectsCallback}
  {$HPPEMIT 'typedef LPDIENUMEFFECTSINFILECALLBACK TDIEnumEffectsInFileCallback;'}
  TDIEnumCreatedEffectObjectsCallback = function (peff : IDirectInputEffect; pvRev: Pointer): BOOL; stdcall;
  {$NODEFINE TDIEnumCreatedEffectObjectsCallback}
  {$HPPEMIT 'typedef LPDIENUMCREATEDEFFECTOBJECTSCALLBACK TDIEnumCreatedEffectObjectsCallback;'}

  {$EXTERNALSYM IDirectInputDevice2A}
  IDirectInputDevice2A = interface(IDirectInputDeviceA)
    [SID_IDirectInputDevice2A]
    (*** IDirectInputDevice2A methods ***)
    function CreateEffect(const rguid: TGUID; lpeff: PDIEffect; out ppdeff: IDirectInputEffect; punkOuter: IUnknown): HResult; stdcall;
    function EnumEffects(lpCallback: TDIEnumEffectsCallbackA; pvRef: Pointer; dwEffType: DWORD): HResult; stdcall;
    function GetEffectInfo(var pdei: TDIEffectInfoA; const rguid: TGUID): HResult; stdcall;
    function GetForceFeedbackState(out pdwOut: DWORD): HResult; stdcall;
    function SendForceFeedbackCommand(dwFlags: DWORD): HResult; stdcall;
    function EnumCreatedEffectObjects(lpCallback: TDIEnumCreatedEffectObjectsCallback; pvRef: Pointer; fl: DWORD): HResult; stdcall;
    function Escape(var pesc: TDIEffEscape): HResult; stdcall;
    function Poll: HResult; stdcall;
    function SendDeviceData(cbObjectData: DWORD; rgdod: PDIDeviceObjectData; var pdwInOut: DWORD; fl: DWORD): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInputDevice2W}
  IDirectInputDevice2W = interface(IDirectInputDeviceW)
    [SID_IDirectInputDevice2W]
    (*** IDirectInputDevice2W methods ***)
    function CreateEffect(const rguid: TGUID; lpeff: PDIEffect; out ppdeff: IDirectInputEffect; punkOuter: IUnknown): HResult; stdcall;
    function EnumEffects(lpCallback: TDIEnumEffectsCallbackW; pvRef: Pointer; dwEffType: DWORD): HResult; stdcall;
    function GetEffectInfo(var pdei: TDIEffectInfoW; const rguid: TGUID): HResult; stdcall;
    function GetForceFeedbackState(out pdwOut: DWORD): HResult; stdcall;
    function SendForceFeedbackCommand(dwFlags: DWORD): HResult; stdcall;
    function EnumCreatedEffectObjects(lpCallback: TDIEnumCreatedEffectObjectsCallback; pvRef: Pointer; fl: DWORD): HResult; stdcall;
    function Escape(var pesc: TDIEffEscape): HResult; stdcall;
    function Poll: HResult; stdcall;
    function SendDeviceData(cbObjectData: DWORD; rgdod: PDIDeviceObjectData; var pdwInOut: DWORD; fl: DWORD): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInputDevice2}
  IDirectInputDevice2 = IDirectInputDevice2A;
type
  IID_IDirectInputDevice2 = IDirectInputDevice2;
  {$EXTERNALSYM IID_IDirectInputDevice2}

{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)

{$IFDEF DIRECTINPUT_VERSION_7} (* #if(DIRECTINPUT_VERSION >= 0x0700) *)
const
  DIFEF_DEFAULT               = $00000000;
  {$EXTERNALSYM DIFEF_DEFAULT}
  DIFEF_INCLUDENONSTANDARD    = $00000001;
  {$EXTERNALSYM DIFEF_INCLUDENONSTANDARD}
  DIFEF_MODIFYIFNEEDED        = $00000010;
  {$EXTERNALSYM DIFEF_MODIFYIFNEEDED}

type
  {$EXTERNALSYM IDirectInputDevice7A}
  IDirectInputDevice7A = interface(IDirectInputDevice2A)
    [SID_IDirectInputDevice7A]
    (*** IDirectInputDevice7A methods ***)
    function EnumEffectsInFile(lpszFileName: PAnsiChar; pec: TDIEnumEffectsInFileCallback; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function WriteEffectToFile(lpszFileName: PAnsiChar; dwEntries: DWORD; rgDiFileEft: PDIFileEffect; dwFlags: DWORD): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInputDevice7W}
  IDirectInputDevice7W = interface(IDirectInputDevice2W)
    [SID_IDirectInputDevice7W]
    (*** IDirectInputDevice7W methods ***)
    function EnumEffectsInFile(lpszFileName: PWideChar; pec: TDIEnumEffectsInFileCallback; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function WriteEffectToFile(lpszFileName: PWideChar; dwEntries: DWORD; rgDiFileEft: PDIFileEffect; dwFlags: DWORD): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInputDevice7}
  IDirectInputDevice7 = IDirectInputDevice7A;
type
  IID_IDirectInputDevice7 = IDirectInputDevice7;
  {$EXTERNALSYM IID_IDirectInputDevice7}

{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0700 *)

{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION >= 0x0800) *)
type
  {$EXTERNALSYM IDirect3DInputDevice8A}
  IDirect3DInputDevice8A = interface(IDirectInputDevice7A)
    [SID_IDirectInputDevice8A]
    (*** IDirectInputDevice8A methods ***)
    function BuildActionMap(lpdiaf: TDIActionFormatA; lpszUserName: PAnsiChar; dwFlags: DWORD): HResult; stdcall;
    function SetActionMap(var lpdiActionFormat: TDIActionFormatA; lptszUserName: PAnsiChar; dwFlags: DWORD): HResult; stdcall;
    function GetImageInfo(var lpdiDevImageInfoHeader: TDIDeviceImageInfoHeaderA): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirect3DInputDevice8W}
  IDirect3DInputDevice8W = interface(IDirectInputDevice7W)
    [SID_IDirectInputDevice8W]
    (*** IDirectInputDevice8W methods ***)
    function BuildActionMap(lpdiaf: TDIActionFormatW; lpszUserName: PWideChar; dwFlags: DWORD): HResult; stdcall;
    function SetActionMap(var lpdiActionFormat: TDIActionFormatW; lptszUserName: PWideChar; dwFlags: DWORD): HResult; stdcall;
    function GetImageInfo(var lpdiDevImageInfoHeader: TDIDeviceImageInfoHeaderW): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirect3DInputDevice8}
  IDirect3DInputDevice8 = IDirect3DInputDevice8A;
type
  IID_IDirectInputDevice8 = IDirect3DInputDevice8;
  {$EXTERNALSYM IID_IDirectInputDevice8}

{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0800 *)

(****************************************************************************
 *
 *      Mouse
 *
 ****************************************************************************)

type
  PDIMouseState = ^TDIMouseState;
  _DIMOUSESTATE = packed record
    lX: Longint;
    lY: Longint;
    lZ: Longint;
    rgbButtons: array[0..3] of Byte;
  end;
  {$EXTERNALSYM _DIMOUSESTATE}
  DIMOUSESTATE = _DIMOUSESTATE;
  {$EXTERNALSYM DIMOUSESTATE}
  TDIMouseState = _DIMOUSESTATE;

{$IFDEF DIRECTINPUT_VERSION_7} (* #if(DIRECTINPUT_VERSION >= 0x0700) *)
  PDIMouseState2 = ^TDIMouseState2;
  _DIMOUSESTATE2 = packed record
    lX: Longint;
    lY: Longint;
    lZ: Longint;
    rgbButtons: array[0..7] of Byte;
  end;
  {$EXTERNALSYM _DIMOUSESTATE2}
  DIMOUSESTATE2 = _DIMOUSESTATE2;
  {$EXTERNALSYM DIMOUSESTATE2}
  TDIMouseState2 = _DIMOUSESTATE2;

{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0700 *)

const
  DIMOFS_X        = 0; // FIELD_OFFSET(DIMOUSESTATE, lX)
  {$EXTERNALSYM DIMOFS_X}
  DIMOFS_Y        = 4; // FIELD_OFFSET(DIMOUSESTATE, lY)
  {$EXTERNALSYM DIMOFS_Y}
  DIMOFS_Z        = 8; // FIELD_OFFSET(DIMOUSESTATE, lZ)
  {$EXTERNALSYM DIMOFS_Z}
  DIMOFS_BUTTON0  = 12;                 // (FIELD_OFFSET(DIMOUSESTATE, rgbButtons) + 0)
  {$EXTERNALSYM DIMOFS_BUTTON0}
  DIMOFS_BUTTON1  = DIMOFS_BUTTON0 + 1; // (FIELD_OFFSET(DIMOUSESTATE, rgbButtons) + 1)
  {$EXTERNALSYM DIMOFS_BUTTON1}
  DIMOFS_BUTTON2  = DIMOFS_BUTTON0 + 2; // (FIELD_OFFSET(DIMOUSESTATE, rgbButtons) + 2)
  {$EXTERNALSYM DIMOFS_BUTTON2}
  DIMOFS_BUTTON3  = DIMOFS_BUTTON0 + 3; // (FIELD_OFFSET(DIMOUSESTATE, rgbButtons) + 3)
  {$EXTERNALSYM DIMOFS_BUTTON3}
{$IFDEF DIRECTINPUT_VERSION_7} (* #if(DIRECTINPUT_VERSION >= 0x0700) *)
  DIMOFS_BUTTON4  = DIMOFS_BUTTON0 + 4; // (FIELD_OFFSET(DIMOUSESTATE2, rgbButtons) + 4)
  {$EXTERNALSYM DIMOFS_BUTTON4}
  DIMOFS_BUTTON5  = DIMOFS_BUTTON0 + 5; // (FIELD_OFFSET(DIMOUSESTATE2, rgbButtons) + 5)
  {$EXTERNALSYM DIMOFS_BUTTON5}
  DIMOFS_BUTTON6  = DIMOFS_BUTTON0 + 6; // (FIELD_OFFSET(DIMOUSESTATE2, rgbButtons) + 6)
  {$EXTERNALSYM DIMOFS_BUTTON6}
  DIMOFS_BUTTON7  = DIMOFS_BUTTON0 + 7; // (FIELD_OFFSET(DIMOUSESTATE2, rgbButtons) + 7)
  {$EXTERNALSYM DIMOFS_BUTTON7}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0700 *)

(****************************************************************************
 *
 *      Keyboard
 *
 ****************************************************************************)

(****************************************************************************
 *
 *      DirectInput keyboard scan codes
 *
 ****************************************************************************)
const
  DIK_ESCAPE          = $01;
  {$EXTERNALSYM DIK_ESCAPE}
  DIK_1               = $02;
  {$EXTERNALSYM DIK_1}
  DIK_2               = $03;
  {$EXTERNALSYM DIK_2}
  DIK_3               = $04;
  {$EXTERNALSYM DIK_3}
  DIK_4               = $05;
  {$EXTERNALSYM DIK_4}
  DIK_5               = $06;
  {$EXTERNALSYM DIK_5}
  DIK_6               = $07;
  {$EXTERNALSYM DIK_6}
  DIK_7               = $08;
  {$EXTERNALSYM DIK_7}
  DIK_8               = $09;
  {$EXTERNALSYM DIK_8}
  DIK_9               = $0A;
  {$EXTERNALSYM DIK_9}
  DIK_0               = $0B;
  {$EXTERNALSYM DIK_0}
  DIK_MINUS           = $0C;    (* - on main keyboard *)
  {$EXTERNALSYM DIK_MINUS}
  DIK_EQUALS          = $0D;
  {$EXTERNALSYM DIK_EQUALS}
  DIK_BACK            = $0E;    (* backspace *)
  {$EXTERNALSYM DIK_BACK}
  DIK_TAB             = $0F;
  {$EXTERNALSYM DIK_TAB}
  DIK_Q               = $10;
  {$EXTERNALSYM DIK_Q}
  DIK_W               = $11;
  {$EXTERNALSYM DIK_W}
  DIK_E               = $12;
  {$EXTERNALSYM DIK_E}
  DIK_R               = $13;
  {$EXTERNALSYM DIK_R}
  DIK_T               = $14;
  {$EXTERNALSYM DIK_T}
  DIK_Y               = $15;
  {$EXTERNALSYM DIK_Y}
  DIK_U               = $16;
  {$EXTERNALSYM DIK_U}
  DIK_I               = $17;
  {$EXTERNALSYM DIK_I}
  DIK_O               = $18;
  {$EXTERNALSYM DIK_O}
  DIK_P               = $19;
  {$EXTERNALSYM DIK_P}
  DIK_LBRACKET        = $1A;
  {$EXTERNALSYM DIK_LBRACKET}
  DIK_RBRACKET        = $1B;
  {$EXTERNALSYM DIK_RBRACKET}
  DIK_RETURN          = $1C;    (* Enter on main keyboard *)
  {$EXTERNALSYM DIK_RETURN}
  DIK_LCONTROL        = $1D;
  {$EXTERNALSYM DIK_LCONTROL}
  DIK_A               = $1E;
  {$EXTERNALSYM DIK_A}
  DIK_S               = $1F;
  {$EXTERNALSYM DIK_S}
  DIK_D               = $20;
  {$EXTERNALSYM DIK_D}
  DIK_F               = $21;
  {$EXTERNALSYM DIK_F}
  DIK_G               = $22;
  {$EXTERNALSYM DIK_G}
  DIK_H               = $23;
  {$EXTERNALSYM DIK_H}
  DIK_J               = $24;
  {$EXTERNALSYM DIK_J}
  DIK_K               = $25;
  {$EXTERNALSYM DIK_K}
  DIK_L               = $26;
  {$EXTERNALSYM DIK_L}
  DIK_SEMICOLON       = $27;
  {$EXTERNALSYM DIK_SEMICOLON}
  DIK_APOSTROPHE      = $28;
  {$EXTERNALSYM DIK_APOSTROPHE}
  DIK_GRAVE           = $29;    (* accent grave *)
  {$EXTERNALSYM DIK_GRAVE}
  DIK_LSHIFT          = $2A;
  {$EXTERNALSYM DIK_LSHIFT}
  DIK_BACKSLASH       = $2B;
  {$EXTERNALSYM DIK_BACKSLASH}
  DIK_Z               = $2C;
  {$EXTERNALSYM DIK_Z}
  DIK_X               = $2D;
  {$EXTERNALSYM DIK_X}
  DIK_C               = $2E;
  {$EXTERNALSYM DIK_C}
  DIK_V               = $2F;
  {$EXTERNALSYM DIK_V}
  DIK_B               = $30;
  {$EXTERNALSYM DIK_B}
  DIK_N               = $31;
  {$EXTERNALSYM DIK_N}
  DIK_M               = $32;
  {$EXTERNALSYM DIK_M}
  DIK_COMMA           = $33;
  {$EXTERNALSYM DIK_COMMA}
  DIK_PERIOD          = $34;    (* . on main keyboard *)
  {$EXTERNALSYM DIK_PERIOD}
  DIK_SLASH           = $35;    (* / on main keyboard *)
  {$EXTERNALSYM DIK_SLASH}
  DIK_RSHIFT          = $36;
  {$EXTERNALSYM DIK_RSHIFT}
  DIK_MULTIPLY        = $37;    (* * on numeric keypad *)
  {$EXTERNALSYM DIK_MULTIPLY}
  DIK_LMENU           = $38;    (* left Alt *)
  {$EXTERNALSYM DIK_LMENU}
  DIK_SPACE           = $39;
  {$EXTERNALSYM DIK_SPACE}
  DIK_CAPITAL         = $3A;
  {$EXTERNALSYM DIK_CAPITAL}
  DIK_F1              = $3B;
  {$EXTERNALSYM DIK_F1}
  DIK_F2              = $3C;
  {$EXTERNALSYM DIK_F2}
  DIK_F3              = $3D;
  {$EXTERNALSYM DIK_F3}
  DIK_F4              = $3E;
  {$EXTERNALSYM DIK_F4}
  DIK_F5              = $3F;
  {$EXTERNALSYM DIK_F5}
  DIK_F6              = $40;
  {$EXTERNALSYM DIK_F6}
  DIK_F7              = $41;
  {$EXTERNALSYM DIK_F7}
  DIK_F8              = $42;
  {$EXTERNALSYM DIK_F8}
  DIK_F9              = $43;
  {$EXTERNALSYM DIK_F9}
  DIK_F10             = $44;
  {$EXTERNALSYM DIK_F10}
  DIK_NUMLOCK         = $45;
  {$EXTERNALSYM DIK_NUMLOCK}
  DIK_SCROLL          = $46;    (* Scroll Lock *)
  {$EXTERNALSYM DIK_SCROLL}
  DIK_NUMPAD7         = $47;
  {$EXTERNALSYM DIK_NUMPAD7}
  DIK_NUMPAD8         = $48;
  {$EXTERNALSYM DIK_NUMPAD8}
  DIK_NUMPAD9         = $49;
  {$EXTERNALSYM DIK_NUMPAD9}
  DIK_SUBTRACT        = $4A;    (* - on numeric keypad *)
  {$EXTERNALSYM DIK_SUBTRACT}
  DIK_NUMPAD4         = $4B;
  {$EXTERNALSYM DIK_NUMPAD4}
  DIK_NUMPAD5         = $4C;
  {$EXTERNALSYM DIK_NUMPAD5}
  DIK_NUMPAD6         = $4D;
  {$EXTERNALSYM DIK_NUMPAD6}
  DIK_ADD             = $4E;    (* + on numeric keypad *)
  {$EXTERNALSYM DIK_ADD}
  DIK_NUMPAD1         = $4F;
  {$EXTERNALSYM DIK_NUMPAD1}
  DIK_NUMPAD2         = $50;
  {$EXTERNALSYM DIK_NUMPAD2}
  DIK_NUMPAD3         = $51;
  {$EXTERNALSYM DIK_NUMPAD3}
  DIK_NUMPAD0         = $52;
  {$EXTERNALSYM DIK_NUMPAD0}
  DIK_DECIMAL         = $53;    (* . on numeric keypad *)
  {$EXTERNALSYM DIK_DECIMAL}
  DIK_OEM_102         = $56;    (* <> or \| on RT 102-key keyboard (Non-U.S.) *)
  {$EXTERNALSYM DIK_OEM_102}
  DIK_F11             = $57;
  {$EXTERNALSYM DIK_F11}
  DIK_F12             = $58;
  {$EXTERNALSYM DIK_F12}
  DIK_F13             = $64;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIK_F13}
  DIK_F14             = $65;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIK_F14}
  DIK_F15             = $66;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIK_F15}
  DIK_KANA            = $70;    (* (Japanese keyboard)            *)
  {$EXTERNALSYM DIK_KANA}
  DIK_ABNT_C1         = $73;    (* /? on Brazilian keyboard *)
  {$EXTERNALSYM DIK_ABNT_C1}
  DIK_CONVERT         = $79;    (* (Japanese keyboard)            *)
  {$EXTERNALSYM DIK_CONVERT}
  DIK_NOCONVERT       = $7B;    (* (Japanese keyboard)            *)
  {$EXTERNALSYM DIK_NOCONVERT}
  DIK_YEN             = $7D;    (* (Japanese keyboard)            *)
  {$EXTERNALSYM DIK_YEN}
  DIK_ABNT_C2         = $7E;    (* Numpad . on Brazilian keyboard *)
  {$EXTERNALSYM DIK_ABNT_C2}
  DIK_NUMPADEQUALS    = $8D;    (* = on numeric keypad (NEC PC98) *)
  {$EXTERNALSYM DIK_NUMPADEQUALS}
  DIK_PREVTRACK       = $90;    (* Previous Track (DIK_CIRCUMFLEX on Japanese keyboard) *)
  {$EXTERNALSYM DIK_PREVTRACK}
  DIK_AT              = $91;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIK_AT}
  DIK_COLON           = $92;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIK_COLON}
  DIK_UNDERLINE       = $93;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIK_UNDERLINE}
  DIK_KANJI           = $94;    (* (Japanese keyboard)            *)
  {$EXTERNALSYM DIK_KANJI}
  DIK_STOP            = $95;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIK_STOP}
  DIK_AX              = $96;    (*                     (Japan AX) *)
  {$EXTERNALSYM DIK_AX}
  DIK_UNLABELED       = $97;    (*                        (J3100) *)
  {$EXTERNALSYM DIK_UNLABELED}
  DIK_NEXTTRACK       = $99;    (* Next Track *)
  {$EXTERNALSYM DIK_NEXTTRACK}
  DIK_NUMPADENTER     = $9C;    (* Enter on numeric keypad *)
  {$EXTERNALSYM DIK_NUMPADENTER}
  DIK_RCONTROL        = $9D;
  {$EXTERNALSYM DIK_RCONTROL}
  DIK_MUTE            = $A0;    (* Mute *)
  {$EXTERNALSYM DIK_MUTE}
  DIK_CALCULATOR      = $A1;    (* Calculator *)
  {$EXTERNALSYM DIK_CALCULATOR}
  DIK_PLAYPAUSE       = $A2;    (* Play / Pause *)
  {$EXTERNALSYM DIK_PLAYPAUSE}
  DIK_MEDIASTOP       = $A4;    (* Media Stop *)
  {$EXTERNALSYM DIK_MEDIASTOP}
  DIK_VOLUMEDOWN      = $AE;    (* Volume - *)
  {$EXTERNALSYM DIK_VOLUMEDOWN}
  DIK_VOLUMEUP        = $B0;    (* Volume + *)
  {$EXTERNALSYM DIK_VOLUMEUP}
  DIK_WEBHOME         = $B2;    (* Web home *)
  {$EXTERNALSYM DIK_WEBHOME}
  DIK_NUMPADCOMMA     = $B3;    (* , on numeric keypad (NEC PC98) *)
  {$EXTERNALSYM DIK_NUMPADCOMMA}
  DIK_DIVIDE          = $B5;    (* / on numeric keypad *)
  {$EXTERNALSYM DIK_DIVIDE}
  DIK_SYSRQ           = $B7;
  {$EXTERNALSYM DIK_SYSRQ}
  DIK_RMENU           = $B8;    (* right Alt *)
  {$EXTERNALSYM DIK_RMENU}
  DIK_PAUSE           = $C5;    (* Pause *)
  {$EXTERNALSYM DIK_PAUSE}
  DIK_HOME            = $C7;    (* Home on arrow keypad *)
  {$EXTERNALSYM DIK_HOME}
  DIK_UP              = $C8;    (* UpArrow on arrow keypad *)
  {$EXTERNALSYM DIK_UP}
  DIK_PRIOR           = $C9;    (* PgUp on arrow keypad *)
  {$EXTERNALSYM DIK_PRIOR}
  DIK_LEFT            = $CB;    (* LeftArrow on arrow keypad *)
  {$EXTERNALSYM DIK_LEFT}
  DIK_RIGHT           = $CD;    (* RightArrow on arrow keypad *)
  {$EXTERNALSYM DIK_RIGHT}
  DIK_END             = $CF;    (* End on arrow keypad *)
  {$EXTERNALSYM DIK_END}
  DIK_DOWN            = $D0;    (* DownArrow on arrow keypad *)
  {$EXTERNALSYM DIK_DOWN}
  DIK_NEXT            = $D1;    (* PgDn on arrow keypad *)
  {$EXTERNALSYM DIK_NEXT}
  DIK_INSERT          = $D2;    (* Insert on arrow keypad *)
  {$EXTERNALSYM DIK_INSERT}
  DIK_DELETE          = $D3;    (* Delete on arrow keypad *)
  {$EXTERNALSYM DIK_DELETE}
  DIK_LWIN            = $DB;    (* Left Windows key *)
  {$EXTERNALSYM DIK_LWIN}
  DIK_RWIN            = $DC;    (* Right Windows key *)
  {$EXTERNALSYM DIK_RWIN}
  DIK_APPS            = $DD;    (* AppMenu key *)
  {$EXTERNALSYM DIK_APPS}
  DIK_POWER           = $DE;    (* System Power *)
  {$EXTERNALSYM DIK_POWER}
  DIK_SLEEP           = $DF;    (* System Sleep *)
  {$EXTERNALSYM DIK_SLEEP}
  DIK_WAKE            = $E3;    (* System Wake *)
  {$EXTERNALSYM DIK_WAKE}
  DIK_WEBSEARCH       = $E5;    (* Web Search *)
  {$EXTERNALSYM DIK_WEBSEARCH}
  DIK_WEBFAVORITES    = $E6;    (* Web Favorites *)
  {$EXTERNALSYM DIK_WEBFAVORITES}
  DIK_WEBREFRESH      = $E7;    (* Web Refresh *)
  {$EXTERNALSYM DIK_WEBREFRESH}
  DIK_WEBSTOP         = $E8;    (* Web Stop *)
  {$EXTERNALSYM DIK_WEBSTOP}
  DIK_WEBFORWARD      = $E9;    (* Web Forward *)
  {$EXTERNALSYM DIK_WEBFORWARD}
  DIK_WEBBACK         = $EA;    (* Web Back *)
  {$EXTERNALSYM DIK_WEBBACK}
  DIK_MYCOMPUTER      = $EB;    (* My Computer *)
  {$EXTERNALSYM DIK_MYCOMPUTER}
  DIK_MAIL            = $EC;    (* Mail *)
  {$EXTERNALSYM DIK_MAIL}
  DIK_MEDIASELECT     = $ED;    (* Media Select *)
  {$EXTERNALSYM DIK_MEDIASELECT}

(*
 *  Alternate names for keys, to facilitate transition from DOS.
 *)
  DIK_BACKSPACE       = DIK_BACK;            (* backspace *)
  {$EXTERNALSYM DIK_BACKSPACE}
  DIK_NUMPADSTAR      = DIK_MULTIPLY;        (* * on numeric keypad *)
  {$EXTERNALSYM DIK_NUMPADSTAR}
  DIK_LALT            = DIK_LMENU;           (* left Alt *)
  {$EXTERNALSYM DIK_LALT}
  DIK_CAPSLOCK        = DIK_CAPITAL;         (* CapsLock *)
  {$EXTERNALSYM DIK_CAPSLOCK}
  DIK_NUMPADMINUS     = DIK_SUBTRACT;        (* - on numeric keypad *)
  {$EXTERNALSYM DIK_NUMPADMINUS}
  DIK_NUMPADPLUS      = DIK_ADD;             (* + on numeric keypad *)
  {$EXTERNALSYM DIK_NUMPADPLUS}
  DIK_NUMPADPERIOD    = DIK_DECIMAL;         (* . on numeric keypad *)
  {$EXTERNALSYM DIK_NUMPADPERIOD}
  DIK_NUMPADSLASH     = DIK_DIVIDE;          (* / on numeric keypad *)
  {$EXTERNALSYM DIK_NUMPADSLASH}
  DIK_RALT            = DIK_RMENU;           (* right Alt *)
  {$EXTERNALSYM DIK_RALT}
  DIK_UPARROW         = DIK_UP;              (* UpArrow on arrow keypad *)
  {$EXTERNALSYM DIK_UPARROW}
  DIK_PGUP            = DIK_PRIOR;           (* PgUp on arrow keypad *)
  {$EXTERNALSYM DIK_PGUP}
  DIK_LEFTARROW       = DIK_LEFT;            (* LeftArrow on arrow keypad *)
  {$EXTERNALSYM DIK_LEFTARROW}
  DIK_RIGHTARROW      = DIK_RIGHT;           (* RightArrow on arrow keypad *)
  {$EXTERNALSYM DIK_RIGHTARROW}
  DIK_DOWNARROW       = DIK_DOWN;            (* DownArrow on arrow keypad *)
  {$EXTERNALSYM DIK_DOWNARROW}
  DIK_PGDN            = DIK_NEXT;            (* PgDn on arrow keypad *)
  {$EXTERNALSYM DIK_PGDN}

(*
 *  Alternate names for keys originally not used on US keyboards.
 *)
  DIK_CIRCUMFLEX      = DIK_PREVTRACK;       (* Japanese keyboard *)
  {$EXTERNALSYM DIK_CIRCUMFLEX}

(****************************************************************************
 *
 *      Joystick
 *
 ****************************************************************************)

type
  PDIJoyState = ^TDIJoyState;
  DIJOYSTATE = packed record
    lX: Longint;                        (* x-axis position              *)
    lY: Longint;                        (* y-axis position              *)
    lZ: Longint;                        (* z-axis position              *)
    lRx: Longint;                       (* x-axis rotation              *)
    lRy: Longint;                       (* y-axis rotation              *)
    lRz: Longint;                       (* z-axis rotation              *)
    rglSlider: array[0..1] of Longint;  (* extra axes positions         *)
    rgdwPOV: array[0..3] of DWORD;      (* POV directions               *)
    rgbButtons: array[0..31] of Byte;   (* 32 buttons                   *)
  end;
  {$EXTERNALSYM DIJOYSTATE}
  TDIJoyState = DIJOYSTATE;

  PDIJoyState2 = ^TDIJoyState2;
  DIJOYSTATE2 = packed record
    lX: Longint;                        (* x-axis position              *)
    lY: Longint;                        (* y-axis position              *)
    lZ: Longint;                        (* z-axis position              *)
    lRx: Longint;                       (* x-axis rotation              *)
    lRy: Longint;                       (* y-axis rotation              *)
    lRz: Longint;                       (* z-axis rotation              *)
    rglSlider: array[0..1] of Longint;  (* extra axes positions         *)
    rgdwPOV: array[0..3] of DWORD;      (* POV directions               *)
    rgbButtons: array[0..127] of Byte;  (* 128 buttons                  *)
    lVX: Longint;                       (* x-axis velocity              *)
    lVY: Longint;                       (* y-axis velocity              *)
    lVZ: Longint;                       (* z-axis velocity              *)
    lVRx: Longint;                      (* x-axis angular velocity      *)
    lVRy: Longint;                      (* y-axis angular velocity      *)
    lVRz: Longint;                      (* z-axis angular velocity      *)
    rglVSlider: array[0..1] of Longint; (* extra axes velocities        *)
    lAX: Longint;                       (* x-axis acceleration          *)
    lAY: Longint;                       (* y-axis acceleration          *)
    lAZ: Longint;                       (* z-axis acceleration          *)
    lARx: Longint;                      (* x-axis angular acceleration  *)
    lARy: Longint;                      (* y-axis angular acceleration  *)
    lARz: Longint;                      (* z-axis angular acceleration  *)
    rglASlider: array[0..1] of Longint; (* extra axes accelerations     *)
    lFX: Longint;                       (* x-axis force                 *)
    lFY: Longint;                       (* y-axis force                 *)
    lFZ: Longint;                       (* z-axis force                 *)
    lFRx: Longint;                      (* x-axis torque                *)
    lFRy: Longint;                      (* y-axis torque                *)
    lFRz: Longint;                      (* z-axis torque                *)
    rglFSlider: array[0..1] of Longint; (* extra axes forces            *)
  end;
  {$EXTERNALSYM DIJOYSTATE2}
  TDIJoyState2 = DIJOYSTATE2;

const
  DIJOFS_X            = 0;  // FIELD_OFFSET(DIJOYSTATE, lX)
  {$EXTERNALSYM DIJOFS_X}
  DIJOFS_Y            = 4;  // FIELD_OFFSET(DIJOYSTATE, lY)
  {$EXTERNALSYM DIJOFS_Y}
  DIJOFS_Z            = 8;  // FIELD_OFFSET(DIJOYSTATE, lZ)
  {$EXTERNALSYM DIJOFS_Z}
  DIJOFS_RX           = 12; // FIELD_OFFSET(DIJOYSTATE, lRx)
  {$EXTERNALSYM DIJOFS_RX}
  DIJOFS_RY           = 16; // FIELD_OFFSET(DIJOYSTATE, lRy)
  {$EXTERNALSYM DIJOFS_RY}
  DIJOFS_RZ           = 20; // FIELD_OFFSET(DIJOYSTATE, lRz)
  {$EXTERNALSYM DIJOFS_RZ}

//  #define DIJOFS_SLIDER(n)   (FIELD_OFFSET(DIJOYSTATE, rglSlider) + \
//                              (n) * sizeof(LONG))
function DIJOFS_SLIDER(n: Cardinal): Cardinal;
{$EXTERNALSYM DIJOFS_SLIDER}

// #define DIJOFS_POV(n)      (FIELD_OFFSET(DIJOYSTATE, rgdwPOV) + \
//                              (n) * sizeof(DWORD))
function DIJOFS_POV(n: Cardinal): Cardinal;
{$EXTERNALSYM DIJOFS_POV}

// #define DIJOFS_BUTTON(n)   (FIELD_OFFSET(DIJOYSTATE, rgbButtons) + (n))
function DIJOFS_BUTTON(n: Cardinal): Cardinal;
{$EXTERNALSYM DIJOFS_BUTTON}

const
  DIJOFS_BUTTON_      = 48; // Helper const

  DIJOFS_BUTTON0      = DIJOFS_BUTTON_ +  0; // DIJOFS_BUTTON(0)
  {$EXTERNALSYM DIJOFS_BUTTON0}
  DIJOFS_BUTTON1      = DIJOFS_BUTTON_ +  1; // DIJOFS_BUTTON(1)
  {$EXTERNALSYM DIJOFS_BUTTON1}
  DIJOFS_BUTTON2      = DIJOFS_BUTTON_ +  2; // DIJOFS_BUTTON(2)
  {$EXTERNALSYM DIJOFS_BUTTON2}
  DIJOFS_BUTTON3      = DIJOFS_BUTTON_ +  3; // DIJOFS_BUTTON(3)
  {$EXTERNALSYM DIJOFS_BUTTON3}
  DIJOFS_BUTTON4      = DIJOFS_BUTTON_ +  4; // DIJOFS_BUTTON(4)
  {$EXTERNALSYM DIJOFS_BUTTON4}
  DIJOFS_BUTTON5      = DIJOFS_BUTTON_ +  5; // DIJOFS_BUTTON(5)
  {$EXTERNALSYM DIJOFS_BUTTON5}
  DIJOFS_BUTTON6      = DIJOFS_BUTTON_ +  6; // DIJOFS_BUTTON(6)
  {$EXTERNALSYM DIJOFS_BUTTON6}
  DIJOFS_BUTTON7      = DIJOFS_BUTTON_ +  7; // DIJOFS_BUTTON(7)
  {$EXTERNALSYM DIJOFS_BUTTON7}
  DIJOFS_BUTTON8      = DIJOFS_BUTTON_ +  8; // DIJOFS_BUTTON(8)
  {$EXTERNALSYM DIJOFS_BUTTON8}
  DIJOFS_BUTTON9      = DIJOFS_BUTTON_ +  9; // DIJOFS_BUTTON(9)
  {$EXTERNALSYM DIJOFS_BUTTON9}
  DIJOFS_BUTTON10     = DIJOFS_BUTTON_ + 10; // DIJOFS_BUTTON(10)
  {$EXTERNALSYM DIJOFS_BUTTON10}
  DIJOFS_BUTTON11     = DIJOFS_BUTTON_ + 11; // DIJOFS_BUTTON(11)
  {$EXTERNALSYM DIJOFS_BUTTON11}
  DIJOFS_BUTTON12     = DIJOFS_BUTTON_ + 12; // DIJOFS_BUTTON(12)
  {$EXTERNALSYM DIJOFS_BUTTON12}
  DIJOFS_BUTTON13     = DIJOFS_BUTTON_ + 13; // DIJOFS_BUTTON(13)
  {$EXTERNALSYM DIJOFS_BUTTON13}
  DIJOFS_BUTTON14     = DIJOFS_BUTTON_ + 14; // DIJOFS_BUTTON(14)
  {$EXTERNALSYM DIJOFS_BUTTON14}
  DIJOFS_BUTTON15     = DIJOFS_BUTTON_ + 15; // DIJOFS_BUTTON(15)
  {$EXTERNALSYM DIJOFS_BUTTON15}
  DIJOFS_BUTTON16     = DIJOFS_BUTTON_ + 16; // DIJOFS_BUTTON(16)
  {$EXTERNALSYM DIJOFS_BUTTON16}
  DIJOFS_BUTTON17     = DIJOFS_BUTTON_ + 17; // DIJOFS_BUTTON(17)
  {$EXTERNALSYM DIJOFS_BUTTON17}
  DIJOFS_BUTTON18     = DIJOFS_BUTTON_ + 18; // DIJOFS_BUTTON(18)
  {$EXTERNALSYM DIJOFS_BUTTON18}
  DIJOFS_BUTTON19     = DIJOFS_BUTTON_ + 19; // DIJOFS_BUTTON(19)
  {$EXTERNALSYM DIJOFS_BUTTON19}
  DIJOFS_BUTTON20     = DIJOFS_BUTTON_ + 20; // DIJOFS_BUTTON(20)
  {$EXTERNALSYM DIJOFS_BUTTON20}
  DIJOFS_BUTTON21     = DIJOFS_BUTTON_ + 21; // DIJOFS_BUTTON(21)
  {$EXTERNALSYM DIJOFS_BUTTON21}
  DIJOFS_BUTTON22     = DIJOFS_BUTTON_ + 22; // DIJOFS_BUTTON(22)
  {$EXTERNALSYM DIJOFS_BUTTON22}
  DIJOFS_BUTTON23     = DIJOFS_BUTTON_ + 23; // DIJOFS_BUTTON(23)
  {$EXTERNALSYM DIJOFS_BUTTON23}
  DIJOFS_BUTTON24     = DIJOFS_BUTTON_ + 24; // DIJOFS_BUTTON(24)
  {$EXTERNALSYM DIJOFS_BUTTON24}
  DIJOFS_BUTTON25     = DIJOFS_BUTTON_ + 25; // DIJOFS_BUTTON(25)
  {$EXTERNALSYM DIJOFS_BUTTON25}
  DIJOFS_BUTTON26     = DIJOFS_BUTTON_ + 26; // DIJOFS_BUTTON(26)
  {$EXTERNALSYM DIJOFS_BUTTON26}
  DIJOFS_BUTTON27     = DIJOFS_BUTTON_ + 27; // DIJOFS_BUTTON(27)
  {$EXTERNALSYM DIJOFS_BUTTON27}
  DIJOFS_BUTTON28     = DIJOFS_BUTTON_ + 28; // DIJOFS_BUTTON(28)
  {$EXTERNALSYM DIJOFS_BUTTON28}
  DIJOFS_BUTTON29     = DIJOFS_BUTTON_ + 29; // DIJOFS_BUTTON(29)
  {$EXTERNALSYM DIJOFS_BUTTON29}
  DIJOFS_BUTTON30     = DIJOFS_BUTTON_ + 30; // DIJOFS_BUTTON(30)
  {$EXTERNALSYM DIJOFS_BUTTON30}
  DIJOFS_BUTTON31     = DIJOFS_BUTTON_ + 31; // DIJOFS_BUTTON(31)
  {$EXTERNALSYM DIJOFS_BUTTON31}

const
  rgodfDIMouse: array[0..6] of TDIObjectDataFormat = (
    (pguid: @GUID_XAxis; dwOfs: DIMOFS_X; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE; dwFlags: 0),
    (pguid: @GUID_YAxis; dwOfs: DIMOFS_Y; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE; dwFlags: 0),
    (pguid: @GUID_ZAxis; dwOfs: DIMOFS_Z; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON0;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON1;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON2;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON3;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0)
  );
  {$EXTERNALSYM rgodfDIMouse}

  c_dfDIMouse: TDIDataFormat = (
    dwSize: Sizeof(TDIDataFormat);              // $18
    dwObjSize: Sizeof(TDIObjectDataFormat);   // $10
    dwFlags: DIDF_RELAXIS;                    // $2
    dwDataSize: Sizeof(TDIMouseState);        // $10
    dwNumObjs: High(rgodfDIMouse) + 1;
    rgodf: @rgodfDIMouse
  );
  {$EXTERNALSYM c_dfDIMouse}


{$IFDEF DIRECTINPUT_VERSION_7} (* #if(DIRECTINPUT_VERSION >= 0x0700) *)
  rgodfDIMouse2: array[0..10] of TDIObjectDataFormat = (
    (pguid: @GUID_XAxis; dwOfs: DIMOFS_X; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE; dwFlags: 0),
    (pguid: @GUID_YAxis; dwOfs: DIMOFS_Y; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE; dwFlags: 0),
    (pguid: @GUID_ZAxis; dwOfs: DIMOFS_Z; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0), // DIDFT_ENUMCOLLECTION(DIDFT_ALIAS) == $80000000
    (pguid: nil; dwOfs: DIMOFS_BUTTON0;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON1;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON2;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON3;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON4;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON5;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON6;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIMOFS_BUTTON7;   dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0)
  );
  {$EXTERNALSYM rgodfDIMouse2}

  c_dfDIMouse2: TDIDataFormat = (
    dwSize     : Sizeof(TDIDataFormat);              // $18
    dwObjSize  : Sizeof(TDIObjectDataFormat);   // $10
    dwFlags    : DIDF_RELAXIS;                    // $2
    dwDataSize : Sizeof(TDIMouseState2);        // $10
    dwNumObjs  : High(rgodfDIMouse2) + 1;
    rgodf      : @rgodfDIMouse2
  );
  {$EXTERNALSYM c_dfDIMouse2}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0700 *)


const
  rgodfKeyboard: array[0..255] of TDIObjectDataFormat = (
    (pguid: @GUID_Key; dwOfs:   0; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (  0 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:   1; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (  1 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:   2; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (  2 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:   3; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (  3 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:   4; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (  4 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:   5; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (  5 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:   6; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (  6 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:   7; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (  7 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:   8; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (  8 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:   9; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (  9 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  10; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 10 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  11; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 11 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  12; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 12 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  13; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 13 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  14; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 14 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  15; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 15 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  16; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 16 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  17; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 17 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  18; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 18 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  19; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 19 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  20; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 20 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  21; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 21 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  22; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 22 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  23; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 23 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  24; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 24 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  25; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 25 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  26; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 26 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  27; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 27 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  28; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 28 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  29; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 29 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  30; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 30 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  31; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 31 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  32; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 32 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  33; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 33 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  34; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 34 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  35; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 35 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  36; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 36 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  37; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 37 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  38; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 38 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  39; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 39 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  40; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 40 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  41; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 41 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  42; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 42 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  43; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 43 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  44; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 44 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  45; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 45 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  46; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 46 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  47; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 47 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  48; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 48 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  49; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 49 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  50; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 50 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  51; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 51 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  52; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 52 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  53; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 53 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  54; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 54 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  55; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 55 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  56; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 56 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  57; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 57 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  58; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 58 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  59; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 59 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  60; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 60 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  61; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 61 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  62; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 62 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  63; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 63 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  64; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 64 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  65; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 65 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  66; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 66 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  67; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 67 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  68; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 68 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  69; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 69 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  70; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 70 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  71; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 71 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  72; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 72 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  73; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 73 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  74; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 74 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  75; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 75 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  76; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 76 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  77; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 77 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  78; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 78 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  79; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 79 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  80; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 80 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  81; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 81 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  82; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 82 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  83; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 83 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  84; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 84 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  85; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 85 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  86; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 86 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  87; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 87 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  88; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 88 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  89; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 89 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  90; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 90 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  91; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 91 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  92; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 92 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  93; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 93 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  94; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 94 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  95; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 95 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  96; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 96 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  97; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 97 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  98; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 98 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs:  99; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or ( 99 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 100; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (100 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 101; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (101 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 102; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (102 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 103; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (103 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 104; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (104 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 105; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (105 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 106; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (106 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 107; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (107 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 108; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (108 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 109; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (109 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 110; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (110 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 111; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (111 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 112; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (112 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 113; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (113 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 114; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (114 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 115; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (115 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 116; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (116 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 117; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (117 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 118; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (118 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 119; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (119 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 120; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (120 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 121; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (121 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 122; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (122 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 123; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (123 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 124; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (124 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 125; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (125 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 126; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (126 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 127; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (127 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 128; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (128 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 129; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (129 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 130; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (130 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 131; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (131 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 132; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (132 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 133; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (133 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 134; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (134 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 135; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (135 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 136; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (136 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 137; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (137 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 138; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (138 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 139; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (139 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 140; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (140 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 141; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (141 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 142; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (142 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 143; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (143 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 144; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (144 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 145; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (145 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 146; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (146 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 147; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (147 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 148; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (148 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 149; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (149 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 150; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (150 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 151; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (151 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 152; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (152 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 153; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (153 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 154; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (154 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 155; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (155 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 156; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (156 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 157; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (157 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 158; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (158 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 159; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (159 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 160; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (160 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 161; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (161 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 162; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (162 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 163; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (163 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 164; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (164 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 165; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (165 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 166; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (166 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 167; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (167 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 168; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (168 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 169; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (169 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 170; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (170 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 171; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (171 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 172; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (172 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 173; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (173 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 174; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (174 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 175; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (175 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 176; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (176 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 177; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (177 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 178; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (178 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 179; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (179 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 180; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (180 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 181; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (181 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 182; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (182 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 183; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (183 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 184; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (184 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 185; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (185 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 186; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (186 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 187; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (187 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 188; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (188 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 189; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (189 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 190; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (190 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 191; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (191 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 192; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (192 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 193; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (193 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 194; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (194 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 195; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (195 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 196; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (196 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 197; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (197 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 198; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (198 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 199; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (199 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 200; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (200 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 201; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (201 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 202; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (202 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 203; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (203 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 204; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (204 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 205; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (205 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 206; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (206 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 207; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (207 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 208; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (208 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 209; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (209 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 210; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (210 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 211; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (211 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 212; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (212 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 213; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (213 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 214; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (214 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 215; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (215 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 216; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (216 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 217; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (217 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 218; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (218 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 219; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (219 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 220; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (220 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 221; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (221 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 222; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (222 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 223; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (223 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 224; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (224 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 225; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (225 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 226; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (226 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 227; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (227 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 228; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (228 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 229; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (229 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 230; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (230 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 231; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (231 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 232; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (232 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 233; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (233 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 234; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (234 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 235; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (235 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 236; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (236 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 237; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (237 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 238; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (238 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 239; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (239 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 240; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (240 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 241; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (241 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 242; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (242 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 243; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (243 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 244; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (244 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 245; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (245 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 246; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (246 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 247; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (247 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 248; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (248 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 249; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (249 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 250; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (250 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 251; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (251 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 252; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (252 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 253; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (253 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 254; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (254 shl 8); dwFlags: 0),
    (pguid: @GUID_Key; dwOfs: 255; dwType: DIDFT_BUTTON or DIPROPRANGE_NOMIN or (255 shl 8); dwFlags: 0)
  );
  {$EXTERNALSYM rgodfKeyboard}

const
  c_dfDIKeyboard: TDIDataFormat = (
    dwSize     : Sizeof(TDIDataFormat);
    dwObjSize  : Sizeof(TDIObjectDataFormat);
    dwFlags    : DIDF_RELAXIS;
    dwDataSize : 256;
    dwNumObjs  : High(rgodfKeyboard) + 1;
    rgodf      : @rgodfKeyboard
  );
  {$EXTERNALSYM c_dfDIKeyboard}


{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
  rgodfJoystick: array[0..43] of TDIObjectDataFormat = (
    (pguid: @GUID_XAxis;  dwOfs: DIJOFS_X;  dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_YAxis;  dwOfs: DIJOFS_Y;  dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_ZAxis;  dwOfs: DIJOFS_Z;  dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_RxAxis; dwOfs: DIJOFS_RX; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_RyAxis; dwOfs: DIJOFS_RY; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_RzAxis; dwOfs: DIJOFS_RZ; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    // 2 Sliders
    (pguid: @GUID_Slider; dwOfs: 24; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_Slider; dwOfs: 28; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    // 4 POVs (yes, really)
    (pguid: @GUID_POV; dwOfs: 32; dwType: DIDFT_POV or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: @GUID_POV; dwOfs: 36; dwType: DIDFT_POV or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: @GUID_POV; dwOfs: 40; dwType: DIDFT_POV or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: @GUID_POV; dwOfs: 44; dwType: DIDFT_POV or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    // Buttons
    (pguid: nil; dwOfs: DIJOFS_BUTTON0;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON1;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON2;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON3;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON4;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON5;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON6;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON7;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON8;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON9;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON10; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON11; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON12; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON13; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON14; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON15; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON16; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON17; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON18; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON19; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON20; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON21; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON22; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON23; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON24; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON25; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON26; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON27; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON28; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON29; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON30; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON31; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0)
  );
  {$EXTERNALSYM rgodfJoystick}

  c_dfDIJoystick: TDIDataFormat = (
    dwSize     : Sizeof(TDIDataFormat);
    dwObjSize  : Sizeof(TDIObjectDataFormat);  // $10
    dwFlags    : DIDF_ABSAXIS;
    dwDataSize : SizeOf(TDIJoyState);         // $10
    dwNumObjs  : High(rgodfJoystick) + 1;  // $2C
    rgodf      : @rgodfJoystick
  );
  {$EXTERNALSYM c_dfDIJoystick}


  rgodfJoystick2: array[0..163] of TDIObjectDataFormat = (
    (pguid: @GUID_XAxis;  dwOfs: DIJOFS_X;  dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_YAxis;  dwOfs: DIJOFS_Y;  dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_ZAxis;  dwOfs: DIJOFS_Z;  dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_RxAxis; dwOfs: DIJOFS_RX; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_RyAxis; dwOfs: DIJOFS_RY; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_RzAxis; dwOfs: DIJOFS_RZ; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    // 2 Sliders
    (pguid: @GUID_Slider; dwOfs: 24; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    (pguid: @GUID_Slider; dwOfs: 28; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTPOSITION),
    // 4 POVs (yes, really)
    (pguid: @GUID_POV; dwOfs: 32; dwType: DIDFT_POV or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: @GUID_POV; dwOfs: 36; dwType: DIDFT_POV or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: @GUID_POV; dwOfs: 40; dwType: DIDFT_POV or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: @GUID_POV; dwOfs: 44; dwType: DIDFT_POV or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    // Buttons
    (pguid: nil; dwOfs: DIJOFS_BUTTON0;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON1;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON2;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON3;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON4;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON5;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON6;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON7;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON8;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON9;  dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON10; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON11; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON12; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON13; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON14; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON15; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON16; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON17; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON18; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON19; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON20; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON21; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON22; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON23; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON24; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON25; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON26; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON27; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON28; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON29; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON30; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs: DIJOFS_BUTTON31; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: 0),
    (pguid: nil; dwOfs:  80; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  81; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  82; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  83; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  84; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  85; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  86; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  87; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  88; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  89; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  90; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  91; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  92; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  93; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  94; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  95; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  96; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  97; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  98; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs:  99; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 100; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 101; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 102; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 103; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 104; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 105; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 106; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 107; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 108; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 109; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 110; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 111; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 112; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 113; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 114; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 115; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 116; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 117; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 118; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 119; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 120; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 121; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 122; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 123; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 124; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 125; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 126; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 127; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 128; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 129; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 130; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 131; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 132; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 133; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 134; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 135; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 136; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 137; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 138; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 139; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 140; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 141; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 142; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 143; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 144; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 145; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 146; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 147; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 148; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 149; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 150; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 151; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 152; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 153; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 154; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 155; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 156; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 157; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 158; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 159; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 160; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 161; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 162; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 163; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 164; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 165; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 166; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 167; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 168; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 169; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 170; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 171; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 172; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 173; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 174; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: nil; dwOfs: 175; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE or $80000000; dwFlags: $0),
    (pguid: @GUID_XAxis;  dwOfs: 176; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTVELOCITY),
    (pguid: @GUID_YAxis;  dwOfs: 180; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTVELOCITY),
    (pguid: @GUID_ZAxis;  dwOfs: 184; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTVELOCITY),
    (pguid: @GUID_RxAxis; dwOfs: 188; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTVELOCITY),
    (pguid: @GUID_RyAxis; dwOfs: 192; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTVELOCITY),
    (pguid: @GUID_RzAxis; dwOfs: 196; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTVELOCITY),
    (pguid: @GUID_Slider; dwOfs:  24; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTVELOCITY),
    (pguid: @GUID_Slider; dwOfs:  28; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTVELOCITY),
    (pguid: @GUID_XAxis;  dwOfs: 208; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTACCEL),
    (pguid: @GUID_YAxis;  dwOfs: 212; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTACCEL),
    (pguid: @GUID_ZAxis;  dwOfs: 216; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTACCEL),
    (pguid: @GUID_RxAxis; dwOfs: 220; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTACCEL),
    (pguid: @GUID_RyAxis; dwOfs: 224; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTACCEL),
    (pguid: @GUID_RzAxis; dwOfs: 228; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTACCEL),
    (pguid: @GUID_Slider; dwOfs:  24; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTACCEL),
    (pguid: @GUID_Slider; dwOfs:  28; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTACCEL),
    (pguid: @GUID_XAxis;  dwOfs: 240; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTFORCE),
    (pguid: @GUID_YAxis;  dwOfs: 244; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTFORCE),
    (pguid: @GUID_ZAxis;  dwOfs: 248; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTFORCE),
    (pguid: @GUID_RxAxis; dwOfs: 252; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTFORCE),
    (pguid: @GUID_RyAxis; dwOfs: 256; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTFORCE),
    (pguid: @GUID_RzAxis; dwOfs: 260; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTFORCE),
    (pguid: @GUID_Slider; dwOfs:  24; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTFORCE),
    (pguid: @GUID_Slider; dwOfs:  28; dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE or $80000000; dwFlags: DIDOI_ASPECTFORCE)
  );
  {$EXTERNALSYM rgodfJoystick2}

  c_dfDIJoystick2: TDIDataFormat = (
    dwSize     : Sizeof(TDIDataFormat);
    dwObjSize  : Sizeof(TDIObjectDataFormat);
    dwFlags    : DIDF_ABSAXIS;
    dwDataSize : SizeOf(TDIJoyState2);
    dwNumObjs  : High(rgodfJoystick2) + 1;
    rgodf      : @rgodfJoystick2
  );
  {$EXTERNALSYM c_dfDIJoystick2}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)



(****************************************************************************
 *
 *  IDirectInput
 *
 ****************************************************************************)

const
  DIENUM_STOP             = BOOL(0);
  {$EXTERNALSYM DIENUM_STOP}
  DIENUM_CONTINUE         = BOOL(1);
  {$EXTERNALSYM DIENUM_CONTINUE}

type
  TDIEnumDevicesCallbackA = function (var lpddi: TDIDeviceInstanceA; pvRef: Pointer): BOOL; stdcall;
  {$EXTERNALSYM TDIEnumDevicesCallbackA}
  TDIEnumDevicesCallbackW = function (var lpddi: TDIDeviceInstanceW; pvRef: Pointer): BOOL; stdcall;
  {$EXTERNALSYM TDIEnumDevicesCallbackW}
  TDIEnumDevicesCallback = TDIEnumDevicesCallbackA;
  {$EXTERNALSYM TDIEnumDevicesCallback}
  TDIConfigureDevicesCallback = function (lpDDSTarget: IUnknown; pvRef: Pointer): BOOL; stdcall;

const
  DIEDFL_ALLDEVICES       = $00000000;
  {$EXTERNALSYM DIEDFL_ALLDEVICES}
  DIEDFL_ATTACHEDONLY     = $00000001;
  {$EXTERNALSYM DIEDFL_ATTACHEDONLY}
{$IFDEF DIRECTINPUT_VERSION_5} (* #if(DIRECTINPUT_VERSION >= 0x0500) *)
  DIEDFL_FORCEFEEDBACK    = $00000100;
  {$EXTERNALSYM DIEDFL_FORCEFEEDBACK}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0500 *)
{$IFDEF DIRECTINPUT_VERSION_5b} (* #if(DIRECTINPUT_VERSION >= 0x050a) *)
  DIEDFL_INCLUDEALIASES   = $00010000;
  {$EXTERNALSYM DIEDFL_INCLUDEALIASES}
  DIEDFL_INCLUDEPHANTOMS  = $00020000;
  {$EXTERNALSYM DIEDFL_INCLUDEPHANTOMS}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x050a *)
{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION >= 0x0800) *)
  DIEDFL_INCLUDEHIDDEN    = $00040000;
  {$EXTERNALSYM DIEDFL_INCLUDEHIDDEN}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0800 *)


{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION >= 0x0800) *)
type
  TDIEnumDevicesBySemanticsCallbackA = function (var lpddi: TDIDeviceInstanceA; lpdid: IDirect3DInputDevice8A; dwFlags, dwRemaining: DWORD; pvRef: Pointer): BOOL; stdcall;
  {$EXTERNALSYM TDIEnumDevicesBySemanticsCallbackA}
  TDIEnumDevicesBySemanticsCallbackW = function (var lpddi: TDIDeviceInstanceW; lpdid: IDirect3DInputDevice8W; dwFlags, dwRemaining: DWORD; pvRef: Pointer): BOOL; stdcall;
  {$EXTERNALSYM TDIEnumDevicesBySemanticsCallbackW}
  TDIEnumDevicesBySemanticsCallback = TDIEnumDevicesBySemanticsCallbackA;
  {$EXTERNALSYM TDIEnumDevicesBySemanticsCallback}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0800 *)

{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION >= 0x0800) *)
const
  DIEDBS_MAPPEDPRI1         = $00000001;
  {$EXTERNALSYM DIEDBS_MAPPEDPRI1}
  DIEDBS_MAPPEDPRI2         = $00000002;
  {$EXTERNALSYM DIEDBS_MAPPEDPRI2}
  DIEDBS_RECENTDEVICE       = $00000010;
  {$EXTERNALSYM DIEDBS_RECENTDEVICE}
  DIEDBS_NEWDEVICE          = $00000020;
  {$EXTERNALSYM DIEDBS_NEWDEVICE}

  DIEDBSFL_ATTACHEDONLY       = $00000000;
  {$EXTERNALSYM DIEDBSFL_ATTACHEDONLY}
  DIEDBSFL_THISUSER           = $00000010;
  {$EXTERNALSYM DIEDBSFL_THISUSER}
  DIEDBSFL_FORCEFEEDBACK      = DIEDFL_FORCEFEEDBACK;
  {$EXTERNALSYM DIEDBSFL_FORCEFEEDBACK}
  DIEDBSFL_AVAILABLEDEVICES   = $00001000;
  {$EXTERNALSYM DIEDBSFL_AVAILABLEDEVICES}
  DIEDBSFL_MULTIMICEKEYBOARDS = $00002000;
  {$EXTERNALSYM DIEDBSFL_MULTIMICEKEYBOARDS}
  DIEDBSFL_NONGAMINGDEVICES   = $00004000;
  {$EXTERNALSYM DIEDBSFL_NONGAMINGDEVICES}
  DIEDBSFL_VALID              = $00007110;
  {$EXTERNALSYM DIEDBSFL_VALID}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0800 *)

type
  {$EXTERNALSYM IDirectInputA}
  IDirectInputA = interface(IUnknown)
    [SID_IDirectInputA]
    (*** IDirectInputA methods ***)
    function CreateDevice(const rguid: TGUID; out lplpDirectInputDevice: IDirectInputDeviceA; pUnkOuter: IUnknown): HResult; stdcall;
    function EnumDevices(dwDevType: DWORD; lpCallback: TDIEnumDevicesCallbackA; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetDeviceStatus(const rguidInstance: TGUID): HResult; stdcall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD): HResult; stdcall;
    function Initialize(hinst: THandle; dwVersion: DWORD): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInputW}
  IDirectInputW = interface(IUnknown)
    [SID_IDirectInputW]
    (*** IDirectInputW methods ***)
    function CreateDevice(const rguid: TGUID; out lplpDirectInputDevice: IDirectInputDeviceW; pUnkOuter: IUnknown): HResult; stdcall;
    function EnumDevices(dwDevType: DWORD; lpCallback: TDIEnumDevicesCallbackW; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetDeviceStatus(const rguidInstance: TGUID): HResult; stdcall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD): HResult; stdcall;
    function Initialize(hinst: THandle; dwVersion: DWORD): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInput}
  IDirectInput = IDirectInputA;
type
  IID_IDirectInput = IDirectInput;
  {$EXTERNALSYM IID_IDirectInput}

type
  {$EXTERNALSYM IDirectInput2A}
  IDirectInput2A = interface(IDirectInputA)
    [SID_IDirectInput2A]
    (*** IDirectInput2A methods ***)
    function FindDevice(const rguidClass: TGUID; ptszName: PAnsiChar; out pguidInstance: TGUID): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInput2W}
  IDirectInput2W = interface(IDirectInputW)
    [SID_IDirectInput2W]
    (*** IDirectInput2W methods ***)
    function FindDevice(const rguidClass: TGUID; ptszName: PWideChar; out pguidInstance: TGUID): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInput2}
  IDirectInput2 = IDirectInput2A;
type
  IID_IDirectInput2 = IDirectInput2;
  {$EXTERNALSYM IID_IDirectInput2}

type
  {$EXTERNALSYM IDirectInput7A}
  IDirectInput7A = interface(IDirectInput2A)
    [SID_IDirectInput7A]
    (*** IDirectInput7A methods ***)
    function CreateDeviceEx(const rguid, riid: TGUID; out pvOut: Pointer; pUnkOuter: IUnknown) : HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInput7W}
  IDirectInput7W = interface(IDirectInput2W)
    [SID_IDirectInput7W]
    (*** IDirectInput7W methods ***)
    function CreateDeviceEx(const rguid, riid: TGUID; out pvOut: Pointer; pUnkOuter: IUnknown) : HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInput7}
  IDirectInput7 = IDirectInput7A;
type
  IID_IDirectInput7 = IDirectInput7;
  {$EXTERNALSYM IID_IDirectInput7}

{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION >= 0x0800) *)
type
  {$EXTERNALSYM IDirectInput8A}
  IDirectInput8A = interface(IUnknown)
    [SID_IDirectInput8A]
    (*** IDirectInput8A methods ***)
    function CreateDevice(const rguid: TGUID; out lplpDirectInputDevice: IDirect3DInputDevice8A; pUnkOuter: IUnknown): HResult; stdcall;
    function EnumDevices(dwDevType: DWORD; lpCallback: TDIEnumDevicesCallbackA; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetDeviceStatus(const rguidInstance: TGUID): HResult; stdcall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD): HResult; stdcall;
    function Initialize(hinst: THandle; dwVersion: DWORD): HResult; stdcall;
    function FindDevice(const rguidClass: TGUID; ptszName: PAnsiChar; out pguidInstance: TGUID): HResult; stdcall;
    function EnumDevicesBySemantics(ptszUserName: PAnsiChar; lpdiActionFormat: TDIActionFormatA; lpCallback: TDIEnumDevicesBySemanticsCallbackA; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function ConfigureDevices(lpdiCallback: TDIConfigureDevicesCallback; lpdiCDParams: TDIConfigureDevicesParamsA; dwFlags: DWORD; pvRefData: Pointer): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirectInput8W}
  IDirectInput8W = interface(IUnknown)
    [SID_IDirectInput8W]
    (*** IDirectInput8W methods ***)
    function CreateDevice(const rguid: TGUID; out lplpDirectInputDevice: IDirect3DInputDevice8W; pUnkOuter: IUnknown): HResult; stdcall;
    function EnumDevices(dwDevType: DWORD; lpCallback: TDIEnumDevicesCallbackW; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetDeviceStatus(const rguidInstance: TGUID): HResult; stdcall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD): HResult; stdcall;
    function Initialize(hinst: THandle; dwVersion: DWORD): HResult; stdcall;
    function FindDevice(const rguidClass: TGUID; ptszName: PWideChar; out pguidInstance: TGUID): HResult; stdcall;
    function EnumDevicesBySemantics(ptszUserName: PWideChar; lpdiActionFormat: TDIActionFormatW; lpCallback: TDIEnumDevicesBySemanticsCallbackW; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function ConfigureDevices(lpdiCallback: TDIConfigureDevicesCallback; lpdiCDParams: TDIConfigureDevicesParamsW; dwFlags: DWORD; pvRefData: Pointer): HResult; stdcall;
  end;

  {$EXTERNALSYM IDirect3DInput8}
  IDirect3DInput8 = IDirectInput8A;
type
  IID_IDirectInput8 = IDirect3DInput8;
  {$EXTERNALSYM IID_IDirectInput8}
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0800 *)


const
  DirectInputDll = 'dinput.dll';
  DirectInput8Dll = 'dinput8.dll';

function DirectInputLoaded: Boolean;
function UnLoadDirectInput: Boolean;
function LoadDirectInput: Boolean;

{$IFDEF DIRECTINPUT_DYNAMIC_LINK}
//{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION > 0x0700) *)
var
  DirectInput8Create: function(hinst: THandle; dwVersion: Cardinal; const riidltf: TGUID; out ppvOut; punkOuter: IUnknown): HResult; stdcall;
  {$EXTERNALSYM DirectInput8Create}

//{$ELSE}
  DirectInputCreateA: function(hinst: THandle; dwVersion: DWORD; out ppDI: IDirectInputA; punkOuter: IUnknown): HResult; stdcall;
  {$EXTERNALSYM DirectInputCreateA}
  DirectInputCreateW: function(hinst: THandle; dwVersion: DWORD; out ppDI: IDirectInputW; punkOuter: IUnknown): HResult; stdcall;
  {$EXTERNALSYM DirectInputCreateW}
  DirectInputCreate: function(hinst: THandle; dwVersion: DWORD; out ppDI: IDirectInput; punkOuter: IUnknown): HResult; stdcall;
  {$EXTERNALSYM DirectInputCreate}

  DirectInputCreateEx: function(hinst : THandle; dwVersion: DWORD; const riidltf: TGUID; out ppvOut; punkOuter: IUnknown): HResult; stdcall;
  {$EXTERNALSYM DirectInputCreateEx}

//{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0700 *)
{$ELSE}
//{$IFDEF DIRECTINPUT_VERSION_8} (* #if(DIRECTINPUT_VERSION > 0x0700) *)
function DirectInput8Create(hinst: THandle; dwVersion: DWORD; const riidltf: TGUID; out ppvOut{: Pointer}; punkOuter: IUnknown): HResult; stdcall; external DirectInput8Dll;
{$EXTERNALSYM DirectInput8Create}

//{$ELSE}
function DirectInputCreateA(hinst: THandle; dwVersion: DWORD; out ppDI: IDirectInputA; punkOuter: IUnknown): HResult; stdcall; external DirectInputDll name 'DirectInputCreateA';
{$EXTERNALSYM DirectInputCreateA}
function DirectInputCreateW(hinst: THandle; dwVersion: DWORD; out ppDI: IDirectInputW; punkOuter: IUnknown): HResult; stdcall; external DirectInputDll name 'DirectInputCreateW';
{$EXTERNALSYM DirectInputCreateW}
function DirectInputCreate(hinst: THandle; dwVersion: DWORD; out ppDI: IDirectInput; punkOuter: IUnknown): HResult; stdcall; external DirectInputDll name 'DirectInputCreateA';
{$EXTERNALSYM DirectInputCreate}

function DirectInputCreateEx(hinst: THandle; dwVersion: DWORD; const riidltf: TGUID; out ppvOut{: Pointer}; punkOuter: IUnknown): HResult; stdcall; external DirectInputDll;
{$EXTERNALSYM DirectInputCreateEx}

//{$ENDIF} (* DIRECTINPUT_VERSION >= 0x0700 *)
{$ENDIF}


(****************************************************************************
 *
 *  Return Codes
 *
 ****************************************************************************)

const
(*
 *  The operation completed successfully.
 *)
  DI_OK                           = S_OK;
  {$EXTERNALSYM DI_OK}

(*
 *  The device exists but is not currently attached.
 *)
  DI_NOTATTACHED                  = S_FALSE;
  {$EXTERNALSYM DI_NOTATTACHED}

(*
 *  The device buffer overflowed.  Some input was lost.
 *)
  DI_BUFFEROVERFLOW               = S_FALSE;
  {$EXTERNALSYM DI_BUFFEROVERFLOW}

(*
 *  The change in device properties had no effect.
 *)
  DI_PROPNOEFFECT                 = S_FALSE;
  {$EXTERNALSYM DI_PROPNOEFFECT}

(*
 *  The operation had no effect.
 *)
  DI_NOEFFECT                     = S_FALSE;
  {$EXTERNALSYM DI_NOEFFECT}

(*
 *  The device is a polled device.  As a result, device buffering
 *  will not collect any data and event notifications will not be
 *  signalled until GetDeviceState is called.
 *)
  DI_POLLEDDEVICE                 = HRESULT($00000002);
  {$EXTERNALSYM DI_POLLEDDEVICE}

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but the effect was not
 *  downloaded because the device is not exclusively acquired
 *  or because the DIEP_NODOWNLOAD flag was passed.
 *)
  DI_DOWNLOADSKIPPED              = HRESULT($00000003);
  {$EXTERNALSYM DI_DOWNLOADSKIPPED}

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but in order to change
 *  the parameters, the effect needed to be restarted.
 *)
  DI_EFFECTRESTARTED              = HRESULT($00000004);
  {$EXTERNALSYM DI_EFFECTRESTARTED}

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but some of them were
 *  beyond the capabilities of the device and were truncated.
 *)
  DI_TRUNCATED                    = HRESULT($00000008);
  {$EXTERNALSYM DI_TRUNCATED}

(*
 *  The settings have been successfully applied but could not be
 *  persisted.
 *)
  DI_SETTINGSNOTSAVED             = HRESULT($0000000B);
  {$EXTERNALSYM DI_SETTINGSNOTSAVED}

(*
 *  Equal to DI_EFFECTRESTARTED | DI_TRUNCATED.
 *)
  DI_TRUNCATEDANDRESTARTED        = HRESULT($0000000C);
  {$EXTERNALSYM DI_TRUNCATEDANDRESTARTED}

(*
 *  A SUCCESS code indicating that settings cannot be modified.
 *)
  DI_WRITEPROTECT                 = HRESULT($00000013);
  {$EXTERNALSYM DI_WRITEPROTECT}


  SEVERITY_ERROR_FACILITY_WIN32   =
      HResult(SEVERITY_ERROR shl 31) or HResult(FACILITY_WIN32 shl 16);
  {$EXTERNALSYM SEVERITY_ERROR_FACILITY_WIN32}

(*
 *  The application requires a newer version of DirectInput.
 *)
  DIERR_OLDDIRECTINPUTVERSION     = HRESULT(SEVERITY_ERROR_FACILITY_WIN32 or
                                            ERROR_OLD_WIN_VERSION);
  {$EXTERNALSYM DIERR_OLDDIRECTINPUTVERSION}

(*
 *  The application was written for an unsupported prerelease version
 *  of DirectInput.
 *)
  DIERR_BETADIRECTINPUTVERSION    = HRESULT(SEVERITY_ERROR_FACILITY_WIN32 or
                                            ERROR_RMODE_APP);
  {$EXTERNALSYM DIERR_BETADIRECTINPUTVERSION}

(*
 *  The object could not be created due to an incompatible driver version
 *  or mismatched or incomplete driver components.
 *)
  DIERR_BADDRIVERVER              = HRESULT(SEVERITY_ERROR_FACILITY_WIN32 or
                                            ERROR_BAD_DRIVER_LEVEL);
  {$EXTERNALSYM DIERR_BADDRIVERVER}

(*
 * The device or device instance or effect is not registered with DirectInput.
 *)
  DIERR_DEVICENOTREG              = REGDB_E_CLASSNOTREG;
  {$EXTERNALSYM DIERR_DEVICENOTREG}

(*
 * The requested object does not exist.
 *)
  DIERR_NOTFOUND                  = HRESULT(SEVERITY_ERROR_FACILITY_WIN32 or
                                            ERROR_FILE_NOT_FOUND);
  {$EXTERNALSYM DIERR_NOTFOUND}

(*
 * The requested object does not exist.
 *)
  DIERR_OBJECTNOTFOUND            = HRESULT(SEVERITY_ERROR_FACILITY_WIN32 or
                                            ERROR_FILE_NOT_FOUND);
  {$EXTERNALSYM DIERR_OBJECTNOTFOUND}

(*
 * An invalid parameter was passed to the returning function,
 * or the object was not in a state that admitted the function
 * to be called.
 *)
  DIERR_INVALIDPARAM              = E_INVALIDARG;
  {$EXTERNALSYM DIERR_INVALIDPARAM}

(*
 * The specified interface is not supported by the object
 *)
  DIERR_NOINTERFACE               = E_NOINTERFACE;
  {$EXTERNALSYM DIERR_NOINTERFACE}

(*
 * An undetermined error occured inside the DInput subsystem
 *)
  DIERR_GENERIC                   = E_FAIL;
  {$EXTERNALSYM DIERR_GENERIC}

(*
 * The DInput subsystem couldn't allocate sufficient memory to complete the
 * caller's request.
 *)
  DIERR_OUTOFMEMORY               = E_OUTOFMEMORY;
  {$EXTERNALSYM DIERR_OUTOFMEMORY}

(*
 * The function called is not supported at this time
 *)
  DIERR_UNSUPPORTED               = E_NOTIMPL;
  {$EXTERNALSYM DIERR_UNSUPPORTED}

(*
 * This object has not been initialized
 *)
  DIERR_NOTINITIALIZED            = HRESULT(SEVERITY_ERROR_FACILITY_WIN32 or
                                            ERROR_NOT_READY);
  {$EXTERNALSYM DIERR_NOTINITIALIZED}

(*
 * This object is already initialized
 *)
  DIERR_ALREADYINITIALIZED        = HRESULT(SEVERITY_ERROR_FACILITY_WIN32 or
                                            ERROR_ALREADY_INITIALIZED);
  {$EXTERNALSYM DIERR_ALREADYINITIALIZED}

(*
 * This object does not support aggregation
 *)
  DIERR_NOAGGREGATION             = CLASS_E_NOAGGREGATION;
  {$EXTERNALSYM DIERR_NOAGGREGATION}

(*
 * Another app has a higher priority level, preventing this call from
 * succeeding.
 *)
  DIERR_OTHERAPPHASPRIO           = E_ACCESSDENIED;
  {$EXTERNALSYM DIERR_OTHERAPPHASPRIO}

(*
 * Access to the device has been lost.  It must be re-acquired.
 *)
  DIERR_INPUTLOST                 = HRESULT(SEVERITY_ERROR_FACILITY_WIN32 or
                                            ERROR_READ_FAULT);
  {$EXTERNALSYM DIERR_INPUTLOST}

(*
 * The operation cannot be performed while the device is acquired.
 *)
  DIERR_ACQUIRED                  = HRESULT(SEVERITY_ERROR_FACILITY_WIN32 or
                                            ERROR_BUSY);
  {$EXTERNALSYM DIERR_ACQUIRED}

(*
 * The operation cannot be performed unless the device is acquired.
 *)
  DIERR_NOTACQUIRED               = HRESULT(SEVERITY_ERROR_FACILITY_WIN32 or
                                            ERROR_INVALID_ACCESS);
  {$EXTERNALSYM DIERR_NOTACQUIRED}

(*
 * The specified property cannot be changed.
 *)
  DIERR_READONLY                  = E_ACCESSDENIED;
  {$EXTERNALSYM DIERR_READONLY}

(*
 * The device already has an event notification associated with it.
 *)
  DIERR_HANDLEEXISTS              = E_ACCESSDENIED;
  {$EXTERNALSYM DIERR_HANDLEEXISTS}

(*
 * Data is not yet available.
 *)
  E_PENDING                       = $8000000A;
  {$EXTERNALSYM E_PENDING}

(*
 * Unable to IDirectInputJoyConfig_Acquire because the user
 * does not have sufficient privileges to change the joystick
 * configuration.
 *)
  DIERR_INSUFFICIENTPRIVS         = $80040200;
  {$EXTERNALSYM DIERR_INSUFFICIENTPRIVS}

(*
 * The device is full.
 *)
  DIERR_DEVICEFULL                = $80040201;
  {$EXTERNALSYM DIERR_DEVICEFULL}

(*
 * Not all the requested information fit into the buffer.
 *)
  DIERR_MOREDATA                  = $80040202;
  {$EXTERNALSYM DIERR_MOREDATA}

(*
 * The effect is not downloaded.
 *)
  DIERR_NOTDOWNLOADED             = $80040203;
  {$EXTERNALSYM DIERR_NOTDOWNLOADED}

(*
 *  The device cannot be reinitialized because there are still effects
 *  attached to it.
 *)
  DIERR_HASEFFECTS                = $80040204;
  {$EXTERNALSYM DIERR_HASEFFECTS}

(*
 *  The operation cannot be performed unless the device is acquired
 *  in DISCL_EXCLUSIVE mode.
 *)
  DIERR_NOTEXCLUSIVEACQUIRED      = $80040205;
  {$EXTERNALSYM DIERR_NOTEXCLUSIVEACQUIRED}

(*
 *  The effect could not be downloaded because essential information
 *  is missing.  For example, no axes have been associated with the
 *  effect, or no type-specific information has been created.
 *)
  DIERR_INCOMPLETEEFFECT          = $80040206;
  {$EXTERNALSYM DIERR_INCOMPLETEEFFECT}

(*
 *  Attempted to read buffered device data from a device that is
 *  not buffered.
 *)
  DIERR_NOTBUFFERED               = $80040207;
  {$EXTERNALSYM DIERR_NOTBUFFERED}

(*
 *  An attempt was made to modify parameters of an effect while it is
 *  playing.  Not all hardware devices support altering the parameters
 *  of an effect while it is playing.
 *)
  DIERR_EFFECTPLAYING             = $80040208;
  {$EXTERNALSYM DIERR_EFFECTPLAYING}

(*
 *  The operation could not be completed because the device is not
 *  plugged in.
 *)
  DIERR_UNPLUGGED                 = $80040209;
  {$EXTERNALSYM DIERR_UNPLUGGED}

(*
 *  SendDeviceData failed because more information was requested
 *  to be sent than can be sent to the device.  Some devices have
 *  restrictions on how much data can be sent to them.  (For example,
 *  there might be a limit on the number of buttons that can be
 *  pressed at once.)
 *)
  DIERR_REPORTFULL                = $8004020A;
  {$EXTERNALSYM DIERR_REPORTFULL}


(*
 *  A mapper file function failed because reading or writing the user or IHV
 *  settings file failed.
 *)
  DIERR_MAPFILEFAIL               = $8004020B;
  {$EXTERNALSYM DIERR_MAPFILEFAIL}


(*--- DINPUT Mapper Definitions: New for Dx8         ---*)


(*--- Keyboard
      Physical Keyboard Device       ---*)

  DIKEYBOARD_ESCAPE                       = $81000401;
  {$EXTERNALSYM DIKEYBOARD_ESCAPE}
  DIKEYBOARD_1                            = $81000402;
  {$EXTERNALSYM DIKEYBOARD_1}
  DIKEYBOARD_2                            = $81000403;
  {$EXTERNALSYM DIKEYBOARD_2}
  DIKEYBOARD_3                            = $81000404;
  {$EXTERNALSYM DIKEYBOARD_3}
  DIKEYBOARD_4                            = $81000405;
  {$EXTERNALSYM DIKEYBOARD_4}
  DIKEYBOARD_5                            = $81000406;
  {$EXTERNALSYM DIKEYBOARD_5}
  DIKEYBOARD_6                            = $81000407;
  {$EXTERNALSYM DIKEYBOARD_6}
  DIKEYBOARD_7                            = $81000408;
  {$EXTERNALSYM DIKEYBOARD_7}
  DIKEYBOARD_8                            = $81000409;
  {$EXTERNALSYM DIKEYBOARD_8}
  DIKEYBOARD_9                            = $8100040A;
  {$EXTERNALSYM DIKEYBOARD_9}
  DIKEYBOARD_0                            = $8100040B;
  {$EXTERNALSYM DIKEYBOARD_0}
  DIKEYBOARD_MINUS                        = $8100040C;    (* - on main keyboard *)
  {$EXTERNALSYM DIKEYBOARD_MINUS}
  DIKEYBOARD_EQUALS                       = $8100040D;
  {$EXTERNALSYM DIKEYBOARD_EQUALS}
  DIKEYBOARD_BACK                         = $8100040E;    (* backspace *)
  {$EXTERNALSYM DIKEYBOARD_BACK}
  DIKEYBOARD_TAB                          = $8100040F;
  {$EXTERNALSYM DIKEYBOARD_TAB}
  DIKEYBOARD_Q                            = $81000410;
  {$EXTERNALSYM DIKEYBOARD_Q}
  DIKEYBOARD_W                            = $81000411;
  {$EXTERNALSYM DIKEYBOARD_W}
  DIKEYBOARD_E                            = $81000412;
  {$EXTERNALSYM DIKEYBOARD_E}
  DIKEYBOARD_R                            = $81000413;
  {$EXTERNALSYM DIKEYBOARD_R}
  DIKEYBOARD_T                            = $81000414;
  {$EXTERNALSYM DIKEYBOARD_T}
  DIKEYBOARD_Y                            = $81000415;
  {$EXTERNALSYM DIKEYBOARD_Y}
  DIKEYBOARD_U                            = $81000416;
  {$EXTERNALSYM DIKEYBOARD_U}
  DIKEYBOARD_I                            = $81000417;
  {$EXTERNALSYM DIKEYBOARD_I}
  DIKEYBOARD_O                            = $81000418;
  {$EXTERNALSYM DIKEYBOARD_O}
  DIKEYBOARD_P                            = $81000419;
  {$EXTERNALSYM DIKEYBOARD_P}
  DIKEYBOARD_LBRACKET                     = $8100041A;
  {$EXTERNALSYM DIKEYBOARD_LBRACKET}
  DIKEYBOARD_RBRACKET                     = $8100041B;
  {$EXTERNALSYM DIKEYBOARD_RBRACKET}
  DIKEYBOARD_RETURN                       = $8100041C;    (* Enter on main keyboard *)
  {$EXTERNALSYM DIKEYBOARD_RETURN}
  DIKEYBOARD_LCONTROL                     = $8100041D;
  {$EXTERNALSYM DIKEYBOARD_LCONTROL}
  DIKEYBOARD_A                            = $8100041E;
  {$EXTERNALSYM DIKEYBOARD_A}
  DIKEYBOARD_S                            = $8100041F;
  {$EXTERNALSYM DIKEYBOARD_S}
  DIKEYBOARD_D                            = $81000420;
  {$EXTERNALSYM DIKEYBOARD_D}
  DIKEYBOARD_F                            = $81000421;
  {$EXTERNALSYM DIKEYBOARD_F}
  DIKEYBOARD_G                            = $81000422;
  {$EXTERNALSYM DIKEYBOARD_G}
  DIKEYBOARD_H                            = $81000423;
  {$EXTERNALSYM DIKEYBOARD_H}
  DIKEYBOARD_J                            = $81000424;
  {$EXTERNALSYM DIKEYBOARD_J}
  DIKEYBOARD_K                            = $81000425;
  {$EXTERNALSYM DIKEYBOARD_K}
  DIKEYBOARD_L                            = $81000426;
  {$EXTERNALSYM DIKEYBOARD_L}
  DIKEYBOARD_SEMICOLON                    = $81000427;
  {$EXTERNALSYM DIKEYBOARD_SEMICOLON}
  DIKEYBOARD_APOSTROPHE                   = $81000428;
  {$EXTERNALSYM DIKEYBOARD_APOSTROPHE}
  DIKEYBOARD_GRAVE                        = $81000429;    (* accent grave *)
  {$EXTERNALSYM DIKEYBOARD_GRAVE}
  DIKEYBOARD_LSHIFT                       = $8100042A;
  {$EXTERNALSYM DIKEYBOARD_LSHIFT}
  DIKEYBOARD_BACKSLASH                    = $8100042B;
  {$EXTERNALSYM DIKEYBOARD_BACKSLASH}
  DIKEYBOARD_Z                            = $8100042C;
  {$EXTERNALSYM DIKEYBOARD_Z}
  DIKEYBOARD_X                            = $8100042D;
  {$EXTERNALSYM DIKEYBOARD_X}
  DIKEYBOARD_C                            = $8100042E;
  {$EXTERNALSYM DIKEYBOARD_C}
  DIKEYBOARD_V                            = $8100042F;
  {$EXTERNALSYM DIKEYBOARD_V}
  DIKEYBOARD_B                            = $81000430;
  {$EXTERNALSYM DIKEYBOARD_B}
  DIKEYBOARD_N                            = $81000431;
  {$EXTERNALSYM DIKEYBOARD_N}
  DIKEYBOARD_M                            = $81000432;
  {$EXTERNALSYM DIKEYBOARD_M}
  DIKEYBOARD_COMMA                        = $81000433;
  {$EXTERNALSYM DIKEYBOARD_COMMA}
  DIKEYBOARD_PERIOD                       = $81000434;    (* . on main keyboard *)
  {$EXTERNALSYM DIKEYBOARD_PERIOD}
  DIKEYBOARD_SLASH                        = $81000435;    (* / on main keyboard *)
  {$EXTERNALSYM DIKEYBOARD_SLASH}
  DIKEYBOARD_RSHIFT                       = $81000436;
  {$EXTERNALSYM DIKEYBOARD_RSHIFT}
  DIKEYBOARD_MULTIPLY                     = $81000437;    (* * on numeric keypad *)
  {$EXTERNALSYM DIKEYBOARD_MULTIPLY}
  DIKEYBOARD_LMENU                        = $81000438;    (* left Alt *)
  {$EXTERNALSYM DIKEYBOARD_LMENU}
  DIKEYBOARD_SPACE                        = $81000439;
  {$EXTERNALSYM DIKEYBOARD_SPACE}
  DIKEYBOARD_CAPITAL                      = $8100043A;
  {$EXTERNALSYM DIKEYBOARD_CAPITAL}
  DIKEYBOARD_F1                           = $8100043B;
  {$EXTERNALSYM DIKEYBOARD_F1}
  DIKEYBOARD_F2                           = $8100043C;
  {$EXTERNALSYM DIKEYBOARD_F2}
  DIKEYBOARD_F3                           = $8100043D;
  {$EXTERNALSYM DIKEYBOARD_F3}
  DIKEYBOARD_F4                           = $8100043E;
  {$EXTERNALSYM DIKEYBOARD_F4}
  DIKEYBOARD_F5                           = $8100043F;
  {$EXTERNALSYM DIKEYBOARD_F5}
  DIKEYBOARD_F6                           = $81000440;
  {$EXTERNALSYM DIKEYBOARD_F6}
  DIKEYBOARD_F7                           = $81000441;
  {$EXTERNALSYM DIKEYBOARD_F7}
  DIKEYBOARD_F8                           = $81000442;
  {$EXTERNALSYM DIKEYBOARD_F8}
  DIKEYBOARD_F9                           = $81000443;
  {$EXTERNALSYM DIKEYBOARD_F9}
  DIKEYBOARD_F10                          = $81000444;
  {$EXTERNALSYM DIKEYBOARD_F10}
  DIKEYBOARD_NUMLOCK                      = $81000445;
  {$EXTERNALSYM DIKEYBOARD_NUMLOCK}
  DIKEYBOARD_SCROLL                       = $81000446;    (* Scroll Lock *)
  {$EXTERNALSYM DIKEYBOARD_SCROLL}
  DIKEYBOARD_NUMPAD7                      = $81000447;
  {$EXTERNALSYM DIKEYBOARD_NUMPAD7}
  DIKEYBOARD_NUMPAD8                      = $81000448;
  {$EXTERNALSYM DIKEYBOARD_NUMPAD8}
  DIKEYBOARD_NUMPAD9                      = $81000449;
  {$EXTERNALSYM DIKEYBOARD_NUMPAD9}
  DIKEYBOARD_SUBTRACT                     = $8100044A;    (* - on numeric keypad *)
  {$EXTERNALSYM DIKEYBOARD_SUBTRACT}
  DIKEYBOARD_NUMPAD4                      = $8100044B;
  {$EXTERNALSYM DIKEYBOARD_NUMPAD4}
  DIKEYBOARD_NUMPAD5                      = $8100044C;
  {$EXTERNALSYM DIKEYBOARD_NUMPAD5}
  DIKEYBOARD_NUMPAD6                      = $8100044D;
  {$EXTERNALSYM DIKEYBOARD_NUMPAD6}
  DIKEYBOARD_ADD                          = $8100044E;    (* + on numeric keypad *)
  {$EXTERNALSYM DIKEYBOARD_ADD}
  DIKEYBOARD_NUMPAD1                      = $8100044F;
  {$EXTERNALSYM DIKEYBOARD_NUMPAD1}
  DIKEYBOARD_NUMPAD2                      = $81000450;
  {$EXTERNALSYM DIKEYBOARD_NUMPAD2}
  DIKEYBOARD_NUMPAD3                      = $81000451;
  {$EXTERNALSYM DIKEYBOARD_NUMPAD3}
  DIKEYBOARD_NUMPAD0                      = $81000452;
  {$EXTERNALSYM DIKEYBOARD_NUMPAD0}
  DIKEYBOARD_DECIMAL                      = $81000453;    (* . on numeric keypad *)
  {$EXTERNALSYM DIKEYBOARD_DECIMAL}
  DIKEYBOARD_OEM_102                      = $81000456;    (* <> or \| on RT 102-key keyboard (Non-U.S.) *)
  {$EXTERNALSYM DIKEYBOARD_OEM_102}
  DIKEYBOARD_F11                          = $81000457;
  {$EXTERNALSYM DIKEYBOARD_F11}
  DIKEYBOARD_F12                          = $81000458;
  {$EXTERNALSYM DIKEYBOARD_F12}
  DIKEYBOARD_F13                          = $81000464;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIKEYBOARD_F13}
  DIKEYBOARD_F14                          = $81000465;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIKEYBOARD_F14}
  DIKEYBOARD_F15                          = $81000466;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIKEYBOARD_F15}
  DIKEYBOARD_KANA                         = $81000470;    (* (Japanese keyboard)            *)
  {$EXTERNALSYM DIKEYBOARD_KANA}
  DIKEYBOARD_ABNT_C1                      = $81000473;    (* /? on Brazilian keyboard *)
  {$EXTERNALSYM DIKEYBOARD_ABNT_C1}
  DIKEYBOARD_CONVERT                      = $81000479;    (* (Japanese keyboard)            *)
  {$EXTERNALSYM DIKEYBOARD_CONVERT}
  DIKEYBOARD_NOCONVERT                    = $8100047B;    (* (Japanese keyboard)            *)
  {$EXTERNALSYM DIKEYBOARD_NOCONVERT}
  DIKEYBOARD_YEN                          = $8100047D;    (* (Japanese keyboard)            *)
  {$EXTERNALSYM DIKEYBOARD_YEN}
  DIKEYBOARD_ABNT_C2                      = $8100047E;    (* Numpad . on Brazilian keyboard *)
  {$EXTERNALSYM DIKEYBOARD_ABNT_C2}
  DIKEYBOARD_NUMPADEQUALS                 = $8100048D;    (* = on numeric keypad (NEC PC98) *)
  {$EXTERNALSYM DIKEYBOARD_NUMPADEQUALS}
  DIKEYBOARD_PREVTRACK                    = $81000490;    (* Previous Track (DIK_CIRCUMFLEX on Japanese keyboard) *)
  {$EXTERNALSYM DIKEYBOARD_PREVTRACK}
  DIKEYBOARD_AT                           = $81000491;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIKEYBOARD_AT}
  DIKEYBOARD_COLON                        = $81000492;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIKEYBOARD_COLON}
  DIKEYBOARD_UNDERLINE                    = $81000493;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIKEYBOARD_UNDERLINE}
  DIKEYBOARD_KANJI                        = $81000494;    (* (Japanese keyboard)            *)
  {$EXTERNALSYM DIKEYBOARD_KANJI}
  DIKEYBOARD_STOP                         = $81000495;    (*                     (NEC PC98) *)
  {$EXTERNALSYM DIKEYBOARD_STOP}
  DIKEYBOARD_AX                           = $81000496;    (*                     (Japan AX) *)
  {$EXTERNALSYM DIKEYBOARD_AX}
  DIKEYBOARD_UNLABELED                    = $81000497;    (*                        (J3100) *)
  {$EXTERNALSYM DIKEYBOARD_UNLABELED}
  DIKEYBOARD_NEXTTRACK                    = $81000499;    (* Next Track *)
  {$EXTERNALSYM DIKEYBOARD_NEXTTRACK}
  DIKEYBOARD_NUMPADENTER                  = $8100049C;    (* Enter on numeric keypad *)
  {$EXTERNALSYM DIKEYBOARD_NUMPADENTER}
  DIKEYBOARD_RCONTROL                     = $8100049D;
  {$EXTERNALSYM DIKEYBOARD_RCONTROL}
  DIKEYBOARD_MUTE                         = $810004A0;    (* Mute *)
  {$EXTERNALSYM DIKEYBOARD_MUTE}
  DIKEYBOARD_CALCULATOR                   = $810004A1;    (* Calculator *)
  {$EXTERNALSYM DIKEYBOARD_CALCULATOR}
  DIKEYBOARD_PLAYPAUSE                    = $810004A2;    (* Play / Pause *)
  {$EXTERNALSYM DIKEYBOARD_PLAYPAUSE}
  DIKEYBOARD_MEDIASTOP                    = $810004A4;    (* Media Stop *)
  {$EXTERNALSYM DIKEYBOARD_MEDIASTOP}
  DIKEYBOARD_VOLUMEDOWN                   = $810004AE;    (* Volume - *)
  {$EXTERNALSYM DIKEYBOARD_VOLUMEDOWN}
  DIKEYBOARD_VOLUMEUP                     = $810004B0;    (* Volume + *)
  {$EXTERNALSYM DIKEYBOARD_VOLUMEUP}
  DIKEYBOARD_WEBHOME                      = $810004B2;    (* Web home *)
  {$EXTERNALSYM DIKEYBOARD_WEBHOME}
  DIKEYBOARD_NUMPADCOMMA                  = $810004B3;    (* , on numeric keypad (NEC PC98) *)
  {$EXTERNALSYM DIKEYBOARD_NUMPADCOMMA}
  DIKEYBOARD_DIVIDE                       = $810004B5;    (* / on numeric keypad *)
  {$EXTERNALSYM DIKEYBOARD_DIVIDE}
  DIKEYBOARD_SYSRQ                        = $810004B7;
  {$EXTERNALSYM DIKEYBOARD_SYSRQ}
  DIKEYBOARD_RMENU                        = $810004B8;    (* right Alt *)
  {$EXTERNALSYM DIKEYBOARD_RMENU}
  DIKEYBOARD_PAUSE                        = $810004C5;    (* Pause *)
  {$EXTERNALSYM DIKEYBOARD_PAUSE}
  DIKEYBOARD_HOME                         = $810004C7;    (* Home on arrow keypad *)
  {$EXTERNALSYM DIKEYBOARD_HOME}
  DIKEYBOARD_UP                           = $810004C8;    (* UpArrow on arrow keypad *)
  {$EXTERNALSYM DIKEYBOARD_UP}
  DIKEYBOARD_PRIOR                        = $810004C9;    (* PgUp on arrow keypad *)
  {$EXTERNALSYM DIKEYBOARD_PRIOR}
  DIKEYBOARD_LEFT                         = $810004CB;    (* LeftArrow on arrow keypad *)
  {$EXTERNALSYM DIKEYBOARD_LEFT}
  DIKEYBOARD_RIGHT                        = $810004CD;    (* RightArrow on arrow keypad *)
  {$EXTERNALSYM DIKEYBOARD_RIGHT}
  DIKEYBOARD_END                          = $810004CF;    (* End on arrow keypad *)
  {$EXTERNALSYM DIKEYBOARD_END}
  DIKEYBOARD_DOWN                         = $810004D0;    (* DownArrow on arrow keypad *)
  {$EXTERNALSYM DIKEYBOARD_DOWN}
  DIKEYBOARD_NEXT                         = $810004D1;    (* PgDn on arrow keypad *)
  {$EXTERNALSYM DIKEYBOARD_NEXT}
  DIKEYBOARD_INSERT                       = $810004D2;    (* Insert on arrow keypad *)
  {$EXTERNALSYM DIKEYBOARD_INSERT}
  DIKEYBOARD_DELETE                       = $810004D3;    (* Delete on arrow keypad *)
  {$EXTERNALSYM DIKEYBOARD_DELETE}
  DIKEYBOARD_LWIN                         = $810004DB;    (* Left Windows key *)
  {$EXTERNALSYM DIKEYBOARD_LWIN}
  DIKEYBOARD_RWIN                         = $810004DC;    (* Right Windows key *)
  {$EXTERNALSYM DIKEYBOARD_RWIN}
  DIKEYBOARD_APPS                         = $810004DD;    (* AppMenu key *)
  {$EXTERNALSYM DIKEYBOARD_APPS}
  DIKEYBOARD_POWER                        = $810004DE;    (* System Power *)
  {$EXTERNALSYM DIKEYBOARD_POWER}
  DIKEYBOARD_SLEEP                        = $810004DF;    (* System Sleep *)
  {$EXTERNALSYM DIKEYBOARD_SLEEP}
  DIKEYBOARD_WAKE                         = $810004E3;    (* System Wake *)
  {$EXTERNALSYM DIKEYBOARD_WAKE}
  DIKEYBOARD_WEBSEARCH                    = $810004E5;    (* Web Search *)
  {$EXTERNALSYM DIKEYBOARD_WEBSEARCH}
  DIKEYBOARD_WEBFAVORITES                 = $810004E6;    (* Web Favorites *)
  {$EXTERNALSYM DIKEYBOARD_WEBFAVORITES}
  DIKEYBOARD_WEBREFRESH                   = $810004E7;    (* Web Refresh *)
  {$EXTERNALSYM DIKEYBOARD_WEBREFRESH}
  DIKEYBOARD_WEBSTOP                      = $810004E8;    (* Web Stop *)
  {$EXTERNALSYM DIKEYBOARD_WEBSTOP}
  DIKEYBOARD_WEBFORWARD                   = $810004E9;    (* Web Forward *)
  {$EXTERNALSYM DIKEYBOARD_WEBFORWARD}
  DIKEYBOARD_WEBBACK                      = $810004EA;    (* Web Back *)
  {$EXTERNALSYM DIKEYBOARD_WEBBACK}
  DIKEYBOARD_MYCOMPUTER                   = $810004EB;    (* My Computer *)
  {$EXTERNALSYM DIKEYBOARD_MYCOMPUTER}
  DIKEYBOARD_MAIL                         = $810004EC;    (* Mail *)
  {$EXTERNALSYM DIKEYBOARD_MAIL}
  DIKEYBOARD_MEDIASELECT                  = $810004ED;    (* Media Select *)
  {$EXTERNALSYM DIKEYBOARD_MEDIASELECT}


(*--- MOUSE
      Physical Mouse Device             ---*)

  DIMOUSE_XAXISAB                         = ($82000200 or DIMOFS_X); (* X Axis-absolute: Some mice natively report absolute coordinates  *)
  {$EXTERNALSYM DIMOUSE_XAXISAB}
  DIMOUSE_YAXISAB                         = ($82000200 or DIMOFS_Y); (* Y Axis-absolute: Some mice natively report absolute coordinates *)
  {$EXTERNALSYM DIMOUSE_YAXISAB}
  DIMOUSE_XAXIS                           = ($82000300 or DIMOFS_X); (* X Axis *)
  {$EXTERNALSYM DIMOUSE_XAXIS}
  DIMOUSE_YAXIS                           = ($82000300 or DIMOFS_Y); (* Y Axis *)
  {$EXTERNALSYM DIMOUSE_YAXIS}
  DIMOUSE_WHEEL                           = ($82000300 or DIMOFS_Z); (* Z Axis *)
  {$EXTERNALSYM DIMOUSE_WHEEL}
  DIMOUSE_BUTTON0                         = ($82000400 or DIMOFS_BUTTON0); (* Button 0 *)
  {$EXTERNALSYM DIMOUSE_BUTTON0}
  DIMOUSE_BUTTON1                         = ($82000400 or DIMOFS_BUTTON1); (* Button 1 *)
  {$EXTERNALSYM DIMOUSE_BUTTON1}
  DIMOUSE_BUTTON2                         = ($82000400 or DIMOFS_BUTTON2); (* Button 2 *)
  {$EXTERNALSYM DIMOUSE_BUTTON2}
  DIMOUSE_BUTTON3                         = ($82000400 or DIMOFS_BUTTON3); (* Button 3 *)
  {$EXTERNALSYM DIMOUSE_BUTTON3}
  DIMOUSE_BUTTON4                         = ($82000400 or DIMOFS_BUTTON4); (* Button 4 *)
  {$EXTERNALSYM DIMOUSE_BUTTON4}
  DIMOUSE_BUTTON5                         = ($82000400 or DIMOFS_BUTTON5); (* Button 5 *)
  {$EXTERNALSYM DIMOUSE_BUTTON5}
  DIMOUSE_BUTTON6                         = ($82000400 or DIMOFS_BUTTON6); (* Button 6 *)
  {$EXTERNALSYM DIMOUSE_BUTTON6}
  DIMOUSE_BUTTON7                         = ($82000400 or DIMOFS_BUTTON7); (* Button 7 *)
  {$EXTERNALSYM DIMOUSE_BUTTON7}


(*--- VOICE
      Physical Dplay Voice Device       ---*)

  DIVOICE_CHANNEL1                        = $83000401;
  {$EXTERNALSYM DIVOICE_CHANNEL1}
  DIVOICE_CHANNEL2                        = $83000402;
  {$EXTERNALSYM DIVOICE_CHANNEL2}
  DIVOICE_CHANNEL3                        = $83000403;
  {$EXTERNALSYM DIVOICE_CHANNEL3}
  DIVOICE_CHANNEL4                        = $83000404;
  {$EXTERNALSYM DIVOICE_CHANNEL4}
  DIVOICE_CHANNEL5                        = $83000405;
  {$EXTERNALSYM DIVOICE_CHANNEL5}
  DIVOICE_CHANNEL6                        = $83000406;
  {$EXTERNALSYM DIVOICE_CHANNEL6}
  DIVOICE_CHANNEL7                        = $83000407;
  {$EXTERNALSYM DIVOICE_CHANNEL7}
  DIVOICE_CHANNEL8                        = $83000408;
  {$EXTERNALSYM DIVOICE_CHANNEL8}
  DIVOICE_TEAM                            = $83000409;
  {$EXTERNALSYM DIVOICE_TEAM}
  DIVOICE_ALL                             = $8300040A;
  {$EXTERNALSYM DIVOICE_ALL}
  DIVOICE_RECORDMUTE                      = $8300040B;
  {$EXTERNALSYM DIVOICE_RECORDMUTE}
  DIVOICE_PLAYBACKMUTE                    = $8300040C;
  {$EXTERNALSYM DIVOICE_PLAYBACKMUTE}
  DIVOICE_TRANSMIT                        = $8300040D;
  {$EXTERNALSYM DIVOICE_TRANSMIT}

  DIVOICE_VOICECOMMAND                    = $83000410;
  {$EXTERNALSYM DIVOICE_VOICECOMMAND}


(*--- Driving Simulator - Racing
      Vehicle control is primary objective  ---*)
  DIVIRTUAL_DRIVING_RACE                  = $01000000;
  {$EXTERNALSYM DIVIRTUAL_DRIVING_RACE}
  DIAXIS_DRIVINGR_STEER                   = $01008A01; (* Steering *)
  {$EXTERNALSYM DIAXIS_DRIVINGR_STEER}
  DIAXIS_DRIVINGR_ACCELERATE              = $01039202; (* Accelerate *)
  {$EXTERNALSYM DIAXIS_DRIVINGR_ACCELERATE}
  DIAXIS_DRIVINGR_BRAKE                   = $01041203; (* Brake-Axis *)
  {$EXTERNALSYM DIAXIS_DRIVINGR_BRAKE}
  DIBUTTON_DRIVINGR_SHIFTUP               = $01000C01; (* Shift to next higher gear *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_SHIFTUP}
  DIBUTTON_DRIVINGR_SHIFTDOWN             = $01000C02; (* Shift to next lower gear *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_SHIFTDOWN}
  DIBUTTON_DRIVINGR_VIEW                  = $01001C03; (* Cycle through view options *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_VIEW}
  DIBUTTON_DRIVINGR_MENU                  = $010004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_MENU}
(*--- Priority 2 controls                            ---*)

  DIAXIS_DRIVINGR_ACCEL_AND_BRAKE         = $01014A04; (* Some devices combine accelerate and brake in a single axis *)
  {$EXTERNALSYM DIAXIS_DRIVINGR_ACCEL_AND_BRAKE}
  DIHATSWITCH_DRIVINGR_GLANCE             = $01004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_DRIVINGR_GLANCE}
  DIBUTTON_DRIVINGR_BRAKE                 = $01004C04; (* Brake-button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_BRAKE}
  DIBUTTON_DRIVINGR_DASHBOARD             = $01004405; (* Select next dashboard option *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_DASHBOARD}
  DIBUTTON_DRIVINGR_AIDS                  = $01004406; (* Driver correction aids *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_AIDS}
  DIBUTTON_DRIVINGR_MAP                   = $01004407; (* Display Driving Map *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_MAP}
  DIBUTTON_DRIVINGR_BOOST                 = $01004408; (* Turbo Boost *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_BOOST}
  DIBUTTON_DRIVINGR_PIT                   = $01004409; (* Pit stop notification *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_PIT}
  DIBUTTON_DRIVINGR_ACCELERATE_LINK       = $0103D4E0; (* Fallback Accelerate button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_ACCELERATE_LINK}
  DIBUTTON_DRIVINGR_STEER_LEFT_LINK       = $0100CCE4; (* Fallback Steer Left button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_STEER_LEFT_LINK}
  DIBUTTON_DRIVINGR_STEER_RIGHT_LINK      = $0100CCEC; (* Fallback Steer Right button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_STEER_RIGHT_LINK}
  DIBUTTON_DRIVINGR_GLANCE_LEFT_LINK      = $0107C4E4; (* Fallback Glance Left button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_GLANCE_LEFT_LINK}
  DIBUTTON_DRIVINGR_GLANCE_RIGHT_LINK     = $0107C4EC; (* Fallback Glance Right button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_GLANCE_RIGHT_LINK}
  DIBUTTON_DRIVINGR_DEVICE                = $010044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_DEVICE}
  DIBUTTON_DRIVINGR_PAUSE                 = $010044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_DRIVINGR_PAUSE}

(*--- Driving Simulator - Combat
      Combat from within a vehicle is primary objective  ---*)
  DIVIRTUAL_DRIVING_COMBAT                = $02000000;
  {$EXTERNALSYM DIVIRTUAL_DRIVING_COMBAT}
  DIAXIS_DRIVINGC_STEER                   = $02008A01; (* Steering  *)
  {$EXTERNALSYM DIAXIS_DRIVINGC_STEER}
  DIAXIS_DRIVINGC_ACCELERATE              = $02039202; (* Accelerate *)
  {$EXTERNALSYM DIAXIS_DRIVINGC_ACCELERATE}
  DIAXIS_DRIVINGC_BRAKE                   = $02041203; (* Brake-axis *)
  {$EXTERNALSYM DIAXIS_DRIVINGC_BRAKE}
  DIBUTTON_DRIVINGC_FIRE                  = $02000C01; (* Fire *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_FIRE}
  DIBUTTON_DRIVINGC_WEAPONS               = $02000C02; (* Select next weapon *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_WEAPONS}
  DIBUTTON_DRIVINGC_TARGET                = $02000C03; (* Select next available target *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_TARGET}
  DIBUTTON_DRIVINGC_MENU                  = $020004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_MENU}
(*--- Priority 2 controls                            ---*)

  DIAXIS_DRIVINGC_ACCEL_AND_BRAKE         = $02014A04; (* Some devices combine accelerate and brake in a single axis *)
  {$EXTERNALSYM DIAXIS_DRIVINGC_ACCEL_AND_BRAKE}
  DIHATSWITCH_DRIVINGC_GLANCE             = $02004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_DRIVINGC_GLANCE}
  DIBUTTON_DRIVINGC_SHIFTUP               = $02004C04; (* Shift to next higher gear *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_SHIFTUP}
  DIBUTTON_DRIVINGC_SHIFTDOWN             = $02004C05; (* Shift to next lower gear *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_SHIFTDOWN}
  DIBUTTON_DRIVINGC_DASHBOARD             = $02004406; (* Select next dashboard option *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_DASHBOARD}
  DIBUTTON_DRIVINGC_AIDS                  = $02004407; (* Driver correction aids *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_AIDS}
  DIBUTTON_DRIVINGC_BRAKE                 = $02004C08; (* Brake-button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_BRAKE}
  DIBUTTON_DRIVINGC_FIRESECONDARY         = $02004C09; (* Alternative fire button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_FIRESECONDARY}
  DIBUTTON_DRIVINGC_ACCELERATE_LINK       = $0203D4E0; (* Fallback Accelerate button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_ACCELERATE_LINK}
  DIBUTTON_DRIVINGC_STEER_LEFT_LINK       = $0200CCE4; (* Fallback Steer Left button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_STEER_LEFT_LINK}
  DIBUTTON_DRIVINGC_STEER_RIGHT_LINK      = $0200CCEC; (* Fallback Steer Right button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_STEER_RIGHT_LINK}
  DIBUTTON_DRIVINGC_GLANCE_LEFT_LINK      = $0207C4E4; (* Fallback Glance Left button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_GLANCE_LEFT_LINK}
  DIBUTTON_DRIVINGC_GLANCE_RIGHT_LINK     = $0207C4EC; (* Fallback Glance Right button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_GLANCE_RIGHT_LINK}
  DIBUTTON_DRIVINGC_DEVICE                = $020044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_DEVICE}
  DIBUTTON_DRIVINGC_PAUSE                 = $020044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_DRIVINGC_PAUSE}

(*--- Driving Simulator - Tank
      Combat from withing a tank is primary objective  ---*)
  DIVIRTUAL_DRIVING_TANK                  = $03000000;
  {$EXTERNALSYM DIVIRTUAL_DRIVING_TANK}
  DIAXIS_DRIVINGT_STEER                   = $03008A01; (* Turn tank left / right *)
  {$EXTERNALSYM DIAXIS_DRIVINGT_STEER}
  DIAXIS_DRIVINGT_BARREL                  = $03010202; (* Raise / lower barrel *)
  {$EXTERNALSYM DIAXIS_DRIVINGT_BARREL}
  DIAXIS_DRIVINGT_ACCELERATE              = $03039203; (* Accelerate *)
  {$EXTERNALSYM DIAXIS_DRIVINGT_ACCELERATE}
  DIAXIS_DRIVINGT_ROTATE                  = $03020204; (* Turn barrel left / right *)
  {$EXTERNALSYM DIAXIS_DRIVINGT_ROTATE}
  DIBUTTON_DRIVINGT_FIRE                  = $03000C01; (* Fire *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_FIRE}
  DIBUTTON_DRIVINGT_WEAPONS               = $03000C02; (* Select next weapon *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_WEAPONS}
  DIBUTTON_DRIVINGT_TARGET                = $03000C03; (* Selects next available target *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_TARGET}
  DIBUTTON_DRIVINGT_MENU                  = $030004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_DRIVINGT_GLANCE             = $03004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_DRIVINGT_GLANCE}
  DIAXIS_DRIVINGT_BRAKE                   = $03045205; (* Brake-axis *)
  {$EXTERNALSYM DIAXIS_DRIVINGT_BRAKE}
  DIAXIS_DRIVINGT_ACCEL_AND_BRAKE         = $03014A06; (* Some devices combine accelerate and brake in a single axis *)
  {$EXTERNALSYM DIAXIS_DRIVINGT_ACCEL_AND_BRAKE}
  DIBUTTON_DRIVINGT_VIEW                  = $03005C04; (* Cycle through view options *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_VIEW}
  DIBUTTON_DRIVINGT_DASHBOARD             = $03005C05; (* Select next dashboard option *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_DASHBOARD}
  DIBUTTON_DRIVINGT_BRAKE                 = $03004C06; (* Brake-button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_BRAKE}
  DIBUTTON_DRIVINGT_FIRESECONDARY         = $03004C07; (* Alternative fire button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_FIRESECONDARY}
  DIBUTTON_DRIVINGT_ACCELERATE_LINK       = $0303D4E0; (* Fallback Accelerate button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_ACCELERATE_LINK}
  DIBUTTON_DRIVINGT_STEER_LEFT_LINK       = $0300CCE4; (* Fallback Steer Left button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_STEER_LEFT_LINK}
  DIBUTTON_DRIVINGT_STEER_RIGHT_LINK      = $0300CCEC; (* Fallback Steer Right button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_STEER_RIGHT_LINK}
  DIBUTTON_DRIVINGT_BARREL_UP_LINK        = $030144E0; (* Fallback Barrel up button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_BARREL_UP_LINK}
  DIBUTTON_DRIVINGT_BARREL_DOWN_LINK      = $030144E8; (* Fallback Barrel down button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_BARREL_DOWN_LINK}
  DIBUTTON_DRIVINGT_ROTATE_LEFT_LINK      = $030244E4; (* Fallback Rotate left button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_ROTATE_LEFT_LINK}
  DIBUTTON_DRIVINGT_ROTATE_RIGHT_LINK     = $030244EC; (* Fallback Rotate right button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_ROTATE_RIGHT_LINK}
  DIBUTTON_DRIVINGT_GLANCE_LEFT_LINK      = $0307C4E4; (* Fallback Glance Left button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_GLANCE_LEFT_LINK}
  DIBUTTON_DRIVINGT_GLANCE_RIGHT_LINK     = $0307C4EC; (* Fallback Glance Right button *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_GLANCE_RIGHT_LINK}
  DIBUTTON_DRIVINGT_DEVICE                = $030044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_DEVICE}
  DIBUTTON_DRIVINGT_PAUSE                 = $030044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_DRIVINGT_PAUSE}

(*--- Flight Simulator - Civilian
      Plane control is the primary objective  ---*)
  DIVIRTUAL_FLYING_CIVILIAN               = $04000000;
  {$EXTERNALSYM DIVIRTUAL_FLYING_CIVILIAN}
  DIAXIS_FLYINGC_BANK                     = $04008A01; (* Roll ship left / right *)
  {$EXTERNALSYM DIAXIS_FLYINGC_BANK}
  DIAXIS_FLYINGC_PITCH                    = $04010A02; (* Nose up / down *)
  {$EXTERNALSYM DIAXIS_FLYINGC_PITCH}
  DIAXIS_FLYINGC_THROTTLE                 = $04039203; (* Throttle *)
  {$EXTERNALSYM DIAXIS_FLYINGC_THROTTLE}
  DIBUTTON_FLYINGC_VIEW                   = $04002401; (* Cycle through view options *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_VIEW}
  DIBUTTON_FLYINGC_DISPLAY                = $04002402; (* Select next dashboard / heads up display option *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_DISPLAY}
  DIBUTTON_FLYINGC_GEAR                   = $04002C03; (* Gear up / down *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_GEAR}
  DIBUTTON_FLYINGC_MENU                   = $040004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_FLYINGC_GLANCE              = $04004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_FLYINGC_GLANCE}
  DIAXIS_FLYINGC_BRAKE                    = $04046A04; (* Apply Brake *)
  {$EXTERNALSYM DIAXIS_FLYINGC_BRAKE}
  DIAXIS_FLYINGC_RUDDER                   = $04025205; (* Yaw ship left/right *)
  {$EXTERNALSYM DIAXIS_FLYINGC_RUDDER}
  DIAXIS_FLYINGC_FLAPS                    = $04055A06; (* Flaps *)
  {$EXTERNALSYM DIAXIS_FLYINGC_FLAPS}
  DIBUTTON_FLYINGC_FLAPSUP                = $04006404; (* Increment stepping up until fully retracted *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_FLAPSUP}
  DIBUTTON_FLYINGC_FLAPSDOWN              = $04006405; (* Decrement stepping down until fully extended *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_FLAPSDOWN}
  DIBUTTON_FLYINGC_BRAKE_LINK             = $04046CE0; (* Fallback brake button *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_BRAKE_LINK}
  DIBUTTON_FLYINGC_FASTER_LINK            = $0403D4E0; (* Fallback throttle up button *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_FASTER_LINK}
  DIBUTTON_FLYINGC_SLOWER_LINK            = $0403D4E8; (* Fallback throttle down button *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_SLOWER_LINK}
  DIBUTTON_FLYINGC_GLANCE_LEFT_LINK       = $0407C4E4; (* Fallback Glance Left button *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_GLANCE_LEFT_LINK}
  DIBUTTON_FLYINGC_GLANCE_RIGHT_LINK      = $0407C4EC; (* Fallback Glance Right button *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_GLANCE_RIGHT_LINK}
  DIBUTTON_FLYINGC_GLANCE_UP_LINK         = $0407C4E0; (* Fallback Glance Up button *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_GLANCE_UP_LINK}
  DIBUTTON_FLYINGC_GLANCE_DOWN_LINK       = $0407C4E8; (* Fallback Glance Down button *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_GLANCE_DOWN_LINK}
  DIBUTTON_FLYINGC_DEVICE                 = $040044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_DEVICE}
  DIBUTTON_FLYINGC_PAUSE                  = $040044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_FLYINGC_PAUSE}

(*--- Flight Simulator - Military
      Aerial combat is the primary objective  ---*)
  DIVIRTUAL_FLYING_MILITARY               = $05000000;
  {$EXTERNALSYM DIVIRTUAL_FLYING_MILITARY}
  DIAXIS_FLYINGM_BANK                     = $05008A01; (* Bank - Roll ship left / right *)
  {$EXTERNALSYM DIAXIS_FLYINGM_BANK}
  DIAXIS_FLYINGM_PITCH                    = $05010A02; (* Pitch - Nose up / down *)
  {$EXTERNALSYM DIAXIS_FLYINGM_PITCH}
  DIAXIS_FLYINGM_THROTTLE                 = $05039203; (* Throttle - faster / slower *)
  {$EXTERNALSYM DIAXIS_FLYINGM_THROTTLE}
  DIBUTTON_FLYINGM_FIRE                   = $05000C01; (* Fire *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_FIRE}
  DIBUTTON_FLYINGM_WEAPONS                = $05000C02; (* Select next weapon *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_WEAPONS}
  DIBUTTON_FLYINGM_TARGET                 = $05000C03; (* Selects next available target *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_TARGET}
  DIBUTTON_FLYINGM_MENU                   = $050004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_FLYINGM_GLANCE              = $05004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_FLYINGM_GLANCE}
  DIBUTTON_FLYINGM_COUNTER                = $05005C04; (* Activate counter measures *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_COUNTER}
  DIAXIS_FLYINGM_RUDDER                   = $05024A04; (* Rudder - Yaw ship left/right *)
  {$EXTERNALSYM DIAXIS_FLYINGM_RUDDER}
  DIAXIS_FLYINGM_BRAKE                    = $05046205; (* Brake-axis *)
  {$EXTERNALSYM DIAXIS_FLYINGM_BRAKE}
  DIBUTTON_FLYINGM_VIEW                   = $05006405; (* Cycle through view options *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_VIEW}
  DIBUTTON_FLYINGM_DISPLAY                = $05006406; (* Select next dashboard option *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_DISPLAY}
  DIAXIS_FLYINGM_FLAPS                    = $05055206; (* Flaps *)
  {$EXTERNALSYM DIAXIS_FLYINGM_FLAPS}
  DIBUTTON_FLYINGM_FLAPSUP                = $05005407; (* Increment stepping up until fully retracted *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_FLAPSUP}
  DIBUTTON_FLYINGM_FLAPSDOWN              = $05005408; (* Decrement stepping down until fully extended *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_FLAPSDOWN}
  DIBUTTON_FLYINGM_FIRESECONDARY          = $05004C09; (* Alternative fire button *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_FIRESECONDARY}
  DIBUTTON_FLYINGM_GEAR                   = $0500640A; (* Gear up / down *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_GEAR}
  DIBUTTON_FLYINGM_BRAKE_LINK             = $050464E0; (* Fallback brake button *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_BRAKE_LINK}
  DIBUTTON_FLYINGM_FASTER_LINK            = $0503D4E0; (* Fallback throttle up button *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_FASTER_LINK}
  DIBUTTON_FLYINGM_SLOWER_LINK            = $0503D4E8; (* Fallback throttle down button *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_SLOWER_LINK}
  DIBUTTON_FLYINGM_GLANCE_LEFT_LINK       = $0507C4E4; (* Fallback Glance Left button *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_GLANCE_LEFT_LINK}
  DIBUTTON_FLYINGM_GLANCE_RIGHT_LINK      = $0507C4EC; (* Fallback Glance Right button *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_GLANCE_RIGHT_LINK}
  DIBUTTON_FLYINGM_GLANCE_UP_LINK         = $0507C4E0; (* Fallback Glance Up button *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_GLANCE_UP_LINK}
  DIBUTTON_FLYINGM_GLANCE_DOWN_LINK       = $0507C4E8; (* Fallback Glance Down button *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_GLANCE_DOWN_LINK}
  DIBUTTON_FLYINGM_DEVICE                 = $050044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_DEVICE}
  DIBUTTON_FLYINGM_PAUSE                  = $050044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_FLYINGM_PAUSE}

(*--- Flight Simulator - Combat Helicopter
      Combat from helicopter is primary objective  ---*)
  DIVIRTUAL_FLYING_HELICOPTER             = $06000000;
  {$EXTERNALSYM DIVIRTUAL_FLYING_HELICOPTER}
  DIAXIS_FLYINGH_BANK                     = $06008A01; (* Bank - Roll ship left / right *)
  {$EXTERNALSYM DIAXIS_FLYINGH_BANK}
  DIAXIS_FLYINGH_PITCH                    = $06010A02; (* Pitch - Nose up / down *)
  {$EXTERNALSYM DIAXIS_FLYINGH_PITCH}
  DIAXIS_FLYINGH_COLLECTIVE               = $06018A03; (* Collective - Blade pitch/power *)
  {$EXTERNALSYM DIAXIS_FLYINGH_COLLECTIVE}
  DIBUTTON_FLYINGH_FIRE                   = $06001401; (* Fire *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_FIRE}
  DIBUTTON_FLYINGH_WEAPONS                = $06001402; (* Select next weapon *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_WEAPONS}
  DIBUTTON_FLYINGH_TARGET                 = $06001403; (* Selects next available target *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_TARGET}
  DIBUTTON_FLYINGH_MENU                   = $060004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_FLYINGH_GLANCE              = $06004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_FLYINGH_GLANCE}
  DIAXIS_FLYINGH_TORQUE                   = $06025A04; (* Torque - Rotate ship around left / right axis *)
  {$EXTERNALSYM DIAXIS_FLYINGH_TORQUE}
  DIAXIS_FLYINGH_THROTTLE                 = $0603DA05; (* Throttle *)
  {$EXTERNALSYM DIAXIS_FLYINGH_THROTTLE}
  DIBUTTON_FLYINGH_COUNTER                = $06005404; (* Activate counter measures *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_COUNTER}
  DIBUTTON_FLYINGH_VIEW                   = $06006405; (* Cycle through view options *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_VIEW}
  DIBUTTON_FLYINGH_GEAR                   = $06006406; (* Gear up / down *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_GEAR}
  DIBUTTON_FLYINGH_FIRESECONDARY          = $06004C07; (* Alternative fire button *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_FIRESECONDARY}
  DIBUTTON_FLYINGH_FASTER_LINK            = $0603DCE0; (* Fallback throttle up button *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_FASTER_LINK}
  DIBUTTON_FLYINGH_SLOWER_LINK            = $0603DCE8; (* Fallback throttle down button *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_SLOWER_LINK}
  DIBUTTON_FLYINGH_GLANCE_LEFT_LINK       = $0607C4E4; (* Fallback Glance Left button *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_GLANCE_LEFT_LINK}
  DIBUTTON_FLYINGH_GLANCE_RIGHT_LINK      = $0607C4EC; (* Fallback Glance Right button *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_GLANCE_RIGHT_LINK}
  DIBUTTON_FLYINGH_GLANCE_UP_LINK         = $0607C4E0; (* Fallback Glance Up button *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_GLANCE_UP_LINK}
  DIBUTTON_FLYINGH_GLANCE_DOWN_LINK       = $0607C4E8; (* Fallback Glance Down button *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_GLANCE_DOWN_LINK}
  DIBUTTON_FLYINGH_DEVICE                 = $060044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_DEVICE}
  DIBUTTON_FLYINGH_PAUSE                  = $060044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_FLYINGH_PAUSE}

(*--- Space Simulator - Combat
      Space Simulator with weapons  ---*)
  DIVIRTUAL_SPACESIM                      = $07000000;
  {$EXTERNALSYM DIVIRTUAL_SPACESIM}
  DIAXIS_SPACESIM_LATERAL                 = $07008201; (* Move ship left / right *)
  {$EXTERNALSYM DIAXIS_SPACESIM_LATERAL}
  DIAXIS_SPACESIM_MOVE                    = $07010202; (* Move ship forward/backward *)
  {$EXTERNALSYM DIAXIS_SPACESIM_MOVE}
  DIAXIS_SPACESIM_THROTTLE                = $07038203; (* Throttle - Engine speed *)
  {$EXTERNALSYM DIAXIS_SPACESIM_THROTTLE}
  DIBUTTON_SPACESIM_FIRE                  = $07000401; (* Fire *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_FIRE}
  DIBUTTON_SPACESIM_WEAPONS               = $07000402; (* Select next weapon *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_WEAPONS}
  DIBUTTON_SPACESIM_TARGET                = $07000403; (* Selects next available target *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_TARGET}
  DIBUTTON_SPACESIM_MENU                  = $070004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_SPACESIM_GLANCE             = $07004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_SPACESIM_GLANCE}
  DIAXIS_SPACESIM_CLIMB                   = $0701C204; (* Climb - Pitch ship up/down *)
  {$EXTERNALSYM DIAXIS_SPACESIM_CLIMB}
  DIAXIS_SPACESIM_ROTATE                  = $07024205; (* Rotate - Turn ship left/right *)
  {$EXTERNALSYM DIAXIS_SPACESIM_ROTATE}
  DIBUTTON_SPACESIM_VIEW                  = $07004404; (* Cycle through view options *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_VIEW}
  DIBUTTON_SPACESIM_DISPLAY               = $07004405; (* Select next dashboard / heads up display option *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_DISPLAY}
  DIBUTTON_SPACESIM_RAISE                 = $07004406; (* Raise ship while maintaining current pitch *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_RAISE}
  DIBUTTON_SPACESIM_LOWER                 = $07004407; (* Lower ship while maintaining current pitch *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_LOWER}
  DIBUTTON_SPACESIM_GEAR                  = $07004408; (* Gear up / down *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_GEAR}
  DIBUTTON_SPACESIM_FIRESECONDARY         = $07004409; (* Alternative fire button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_FIRESECONDARY}
  DIBUTTON_SPACESIM_LEFT_LINK             = $0700C4E4; (* Fallback move left button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_LEFT_LINK}
  DIBUTTON_SPACESIM_RIGHT_LINK            = $0700C4EC; (* Fallback move right button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_RIGHT_LINK}
  DIBUTTON_SPACESIM_FORWARD_LINK          = $070144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_FORWARD_LINK}
  DIBUTTON_SPACESIM_BACKWARD_LINK         = $070144E8; (* Fallback move backwards button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_BACKWARD_LINK}
  DIBUTTON_SPACESIM_FASTER_LINK           = $0703C4E0; (* Fallback throttle up button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_FASTER_LINK}
  DIBUTTON_SPACESIM_SLOWER_LINK           = $0703C4E8; (* Fallback throttle down button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_SLOWER_LINK}
  DIBUTTON_SPACESIM_TURN_LEFT_LINK        = $070244E4; (* Fallback turn left button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_TURN_LEFT_LINK}
  DIBUTTON_SPACESIM_TURN_RIGHT_LINK       = $070244EC; (* Fallback turn right button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_TURN_RIGHT_LINK}
  DIBUTTON_SPACESIM_GLANCE_LEFT_LINK      = $0707C4E4; (* Fallback Glance Left button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_GLANCE_LEFT_LINK}
  DIBUTTON_SPACESIM_GLANCE_RIGHT_LINK     = $0707C4EC; (* Fallback Glance Right button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_GLANCE_RIGHT_LINK}
  DIBUTTON_SPACESIM_GLANCE_UP_LINK        = $0707C4E0; (* Fallback Glance Up button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_GLANCE_UP_LINK}
  DIBUTTON_SPACESIM_GLANCE_DOWN_LINK      = $0707C4E8; (* Fallback Glance Down button *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_GLANCE_DOWN_LINK}
  DIBUTTON_SPACESIM_DEVICE                = $070044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_DEVICE}
  DIBUTTON_SPACESIM_PAUSE                 = $070044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_SPACESIM_PAUSE}

(*--- Fighting - First Person
      Hand to Hand combat is primary objective  ---*)
  DIVIRTUAL_FIGHTING_HAND2HAND            = $08000000;
  {$EXTERNALSYM DIVIRTUAL_FIGHTING_HAND2HAND}
  DIAXIS_FIGHTINGH_LATERAL                = $08008201; (* Sidestep left/right *)
  {$EXTERNALSYM DIAXIS_FIGHTINGH_LATERAL}
  DIAXIS_FIGHTINGH_MOVE                   = $08010202; (* Move forward/backward *)
  {$EXTERNALSYM DIAXIS_FIGHTINGH_MOVE}
  DIBUTTON_FIGHTINGH_PUNCH                = $08000401; (* Punch *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_PUNCH}
  DIBUTTON_FIGHTINGH_KICK                 = $08000402; (* Kick *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_KICK}
  DIBUTTON_FIGHTINGH_BLOCK                = $08000403; (* Block *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_BLOCK}
  DIBUTTON_FIGHTINGH_CROUCH               = $08000404; (* Crouch *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_CROUCH}
  DIBUTTON_FIGHTINGH_JUMP                 = $08000405; (* Jump *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_JUMP}
  DIBUTTON_FIGHTINGH_SPECIAL1             = $08000406; (* Apply first special move *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_SPECIAL1}
  DIBUTTON_FIGHTINGH_SPECIAL2             = $08000407; (* Apply second special move *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_SPECIAL2}
  DIBUTTON_FIGHTINGH_MENU                 = $080004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_FIGHTINGH_SELECT               = $08004408; (* Select special move *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_SELECT}
  DIHATSWITCH_FIGHTINGH_SLIDE             = $08004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_FIGHTINGH_SLIDE}
  DIBUTTON_FIGHTINGH_DISPLAY              = $08004409; (* Shows next on-screen display option *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_DISPLAY}
  DIAXIS_FIGHTINGH_ROTATE                 = $08024203; (* Rotate - Turn body left/right *)
  {$EXTERNALSYM DIAXIS_FIGHTINGH_ROTATE}
  DIBUTTON_FIGHTINGH_DODGE                = $0800440A; (* Dodge *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_DODGE}
  DIBUTTON_FIGHTINGH_LEFT_LINK            = $0800C4E4; (* Fallback left sidestep button *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_LEFT_LINK}
  DIBUTTON_FIGHTINGH_RIGHT_LINK           = $0800C4EC; (* Fallback right sidestep button *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_RIGHT_LINK}
  DIBUTTON_FIGHTINGH_FORWARD_LINK         = $080144E0; (* Fallback forward button *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_FORWARD_LINK}
  DIBUTTON_FIGHTINGH_BACKWARD_LINK        = $080144E8; (* Fallback backward button *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_BACKWARD_LINK}
  DIBUTTON_FIGHTINGH_DEVICE               = $080044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_DEVICE}
  DIBUTTON_FIGHTINGH_PAUSE                = $080044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_FIGHTINGH_PAUSE}

(*--- Fighting - First Person Shooting
      Navigation and combat are primary objectives  ---*)
  DIVIRTUAL_FIGHTING_FPS                  = $09000000;
  {$EXTERNALSYM DIVIRTUAL_FIGHTING_FPS}
  DIAXIS_FPS_ROTATE                       = $09008201; (* Rotate character left/right *)
  {$EXTERNALSYM DIAXIS_FPS_ROTATE}
  DIAXIS_FPS_MOVE                         = $09010202; (* Move forward/backward *)
  {$EXTERNALSYM DIAXIS_FPS_MOVE}
  DIBUTTON_FPS_FIRE                       = $09000401; (* Fire *)
  {$EXTERNALSYM DIBUTTON_FPS_FIRE}
  DIBUTTON_FPS_WEAPONS                    = $09000402; (* Select next weapon *)
  {$EXTERNALSYM DIBUTTON_FPS_WEAPONS}
  DIBUTTON_FPS_APPLY                      = $09000403; (* Use item *)
  {$EXTERNALSYM DIBUTTON_FPS_APPLY}
  DIBUTTON_FPS_SELECT                     = $09000404; (* Select next inventory item *)
  {$EXTERNALSYM DIBUTTON_FPS_SELECT}
  DIBUTTON_FPS_CROUCH                     = $09000405; (* Crouch/ climb down/ swim down *)
  {$EXTERNALSYM DIBUTTON_FPS_CROUCH}
  DIBUTTON_FPS_JUMP                       = $09000406; (* Jump/ climb up/ swim up *)
  {$EXTERNALSYM DIBUTTON_FPS_JUMP}
  DIAXIS_FPS_LOOKUPDOWN                   = $09018203; (* Look up / down  *)
  {$EXTERNALSYM DIAXIS_FPS_LOOKUPDOWN}
  DIBUTTON_FPS_STRAFE                     = $09000407; (* Enable strafing while active *)
  {$EXTERNALSYM DIBUTTON_FPS_STRAFE}
  DIBUTTON_FPS_MENU                       = $090004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_FPS_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_FPS_GLANCE                  = $09004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_FPS_GLANCE}
  DIBUTTON_FPS_DISPLAY                    = $09004408; (* Shows next on-screen display option/ map *)
  {$EXTERNALSYM DIBUTTON_FPS_DISPLAY}
  DIAXIS_FPS_SIDESTEP                     = $09024204; (* Sidestep *)
  {$EXTERNALSYM DIAXIS_FPS_SIDESTEP}
  DIBUTTON_FPS_DODGE                      = $09004409; (* Dodge *)
  {$EXTERNALSYM DIBUTTON_FPS_DODGE}
  DIBUTTON_FPS_GLANCEL                    = $0900440A; (* Glance Left *)
  {$EXTERNALSYM DIBUTTON_FPS_GLANCEL}
  DIBUTTON_FPS_GLANCER                    = $0900440B; (* Glance Right *)
  {$EXTERNALSYM DIBUTTON_FPS_GLANCER}
  DIBUTTON_FPS_FIRESECONDARY              = $0900440C; (* Alternative fire button *)
  {$EXTERNALSYM DIBUTTON_FPS_FIRESECONDARY}
  DIBUTTON_FPS_ROTATE_LEFT_LINK           = $0900C4E4; (* Fallback rotate left button *)
  {$EXTERNALSYM DIBUTTON_FPS_ROTATE_LEFT_LINK}
  DIBUTTON_FPS_ROTATE_RIGHT_LINK          = $0900C4EC; (* Fallback rotate right button *)
  {$EXTERNALSYM DIBUTTON_FPS_ROTATE_RIGHT_LINK}
  DIBUTTON_FPS_FORWARD_LINK               = $090144E0; (* Fallback forward button *)
  {$EXTERNALSYM DIBUTTON_FPS_FORWARD_LINK}
  DIBUTTON_FPS_BACKWARD_LINK              = $090144E8; (* Fallback backward button *)
  {$EXTERNALSYM DIBUTTON_FPS_BACKWARD_LINK}
  DIBUTTON_FPS_GLANCE_UP_LINK             = $0901C4E0; (* Fallback look up button *)
  {$EXTERNALSYM DIBUTTON_FPS_GLANCE_UP_LINK}
  DIBUTTON_FPS_GLANCE_DOWN_LINK           = $0901C4E8; (* Fallback look down button *)
  {$EXTERNALSYM DIBUTTON_FPS_GLANCE_DOWN_LINK}
  DIBUTTON_FPS_STEP_LEFT_LINK             = $090244E4; (* Fallback step left button *)
  {$EXTERNALSYM DIBUTTON_FPS_STEP_LEFT_LINK}
  DIBUTTON_FPS_STEP_RIGHT_LINK            = $090244EC; (* Fallback step right button *)
  {$EXTERNALSYM DIBUTTON_FPS_STEP_RIGHT_LINK}
  DIBUTTON_FPS_DEVICE                     = $090044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_FPS_DEVICE}
  DIBUTTON_FPS_PAUSE                      = $090044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_FPS_PAUSE}

(*--- Fighting - Third Person action
      Perspective of camera is behind the main character  ---*)
  DIVIRTUAL_FIGHTING_THIRDPERSON          = $0A000000;
  {$EXTERNALSYM DIVIRTUAL_FIGHTING_THIRDPERSON}
  DIAXIS_TPS_TURN                         = $0A020201; (* Turn left/right *)
  {$EXTERNALSYM DIAXIS_TPS_TURN}
  DIAXIS_TPS_MOVE                         = $0A010202; (* Move forward/backward *)
  {$EXTERNALSYM DIAXIS_TPS_MOVE}
  DIBUTTON_TPS_RUN                        = $0A000401; (* Run or walk toggle switch *)
  {$EXTERNALSYM DIBUTTON_TPS_RUN}
  DIBUTTON_TPS_ACTION                     = $0A000402; (* Action Button *)
  {$EXTERNALSYM DIBUTTON_TPS_ACTION}
  DIBUTTON_TPS_SELECT                     = $0A000403; (* Select next weapon *)
  {$EXTERNALSYM DIBUTTON_TPS_SELECT}
  DIBUTTON_TPS_USE                        = $0A000404; (* Use inventory item currently selected *)
  {$EXTERNALSYM DIBUTTON_TPS_USE}
  DIBUTTON_TPS_JUMP                       = $0A000405; (* Character Jumps *)
  {$EXTERNALSYM DIBUTTON_TPS_JUMP}
  DIBUTTON_TPS_MENU                       = $0A0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_TPS_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_TPS_GLANCE                  = $0A004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_TPS_GLANCE}
  DIBUTTON_TPS_VIEW                       = $0A004406; (* Select camera view *)
  {$EXTERNALSYM DIBUTTON_TPS_VIEW}
  DIBUTTON_TPS_STEPLEFT                   = $0A004407; (* Character takes a left step *)
  {$EXTERNALSYM DIBUTTON_TPS_STEPLEFT}
  DIBUTTON_TPS_STEPRIGHT                  = $0A004408; (* Character takes a right step *)
  {$EXTERNALSYM DIBUTTON_TPS_STEPRIGHT}
  DIAXIS_TPS_STEP                         = $0A00C203; (* Character steps left/right *)
  {$EXTERNALSYM DIAXIS_TPS_STEP}
  DIBUTTON_TPS_DODGE                      = $0A004409; (* Character dodges or ducks *)
  {$EXTERNALSYM DIBUTTON_TPS_DODGE}
  DIBUTTON_TPS_INVENTORY                  = $0A00440A; (* Cycle through inventory *)
  {$EXTERNALSYM DIBUTTON_TPS_INVENTORY}
  DIBUTTON_TPS_TURN_LEFT_LINK             = $0A0244E4; (* Fallback turn left button *)
  {$EXTERNALSYM DIBUTTON_TPS_TURN_LEFT_LINK}
  DIBUTTON_TPS_TURN_RIGHT_LINK            = $0A0244EC; (* Fallback turn right button *)
  {$EXTERNALSYM DIBUTTON_TPS_TURN_RIGHT_LINK}
  DIBUTTON_TPS_FORWARD_LINK               = $0A0144E0; (* Fallback forward button *)
  {$EXTERNALSYM DIBUTTON_TPS_FORWARD_LINK}
  DIBUTTON_TPS_BACKWARD_LINK              = $0A0144E8; (* Fallback backward button *)
  {$EXTERNALSYM DIBUTTON_TPS_BACKWARD_LINK}
  DIBUTTON_TPS_GLANCE_UP_LINK             = $0A07C4E0; (* Fallback look up button *)
  {$EXTERNALSYM DIBUTTON_TPS_GLANCE_UP_LINK}
  DIBUTTON_TPS_GLANCE_DOWN_LINK           = $0A07C4E8; (* Fallback look down button *)
  {$EXTERNALSYM DIBUTTON_TPS_GLANCE_DOWN_LINK}
  DIBUTTON_TPS_GLANCE_LEFT_LINK           = $0A07C4E4; (* Fallback glance up button *)
  {$EXTERNALSYM DIBUTTON_TPS_GLANCE_LEFT_LINK}
  DIBUTTON_TPS_GLANCE_RIGHT_LINK          = $0A07C4EC; (* Fallback glance right button *)
  {$EXTERNALSYM DIBUTTON_TPS_GLANCE_RIGHT_LINK}
  DIBUTTON_TPS_DEVICE                     = $0A0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_TPS_DEVICE}
  DIBUTTON_TPS_PAUSE                      = $0A0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_TPS_PAUSE}

(*--- Strategy - Role Playing
      Navigation and problem solving are primary actions  ---*)
  DIVIRTUAL_STRATEGY_ROLEPLAYING          = $0B000000;
  {$EXTERNALSYM DIVIRTUAL_STRATEGY_ROLEPLAYING}
  DIAXIS_STRATEGYR_LATERAL                = $0B008201; (* sidestep - left/right *)
  {$EXTERNALSYM DIAXIS_STRATEGYR_LATERAL}
  DIAXIS_STRATEGYR_MOVE                   = $0B010202; (* move forward/backward *)
  {$EXTERNALSYM DIAXIS_STRATEGYR_MOVE}
  DIBUTTON_STRATEGYR_GET                  = $0B000401; (* Acquire item *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_GET}
  DIBUTTON_STRATEGYR_APPLY                = $0B000402; (* Use selected item *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_APPLY}
  DIBUTTON_STRATEGYR_SELECT               = $0B000403; (* Select nextitem *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_SELECT}
  DIBUTTON_STRATEGYR_ATTACK               = $0B000404; (* Attack *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_ATTACK}
  DIBUTTON_STRATEGYR_CAST                 = $0B000405; (* Cast Spell *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_CAST}
  DIBUTTON_STRATEGYR_CROUCH               = $0B000406; (* Crouch *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_CROUCH}
  DIBUTTON_STRATEGYR_JUMP                 = $0B000407; (* Jump *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_JUMP}
  DIBUTTON_STRATEGYR_MENU                 = $0B0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_STRATEGYR_GLANCE            = $0B004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_STRATEGYR_GLANCE}
  DIBUTTON_STRATEGYR_MAP                  = $0B004408; (* Cycle through map options *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_MAP}
  DIBUTTON_STRATEGYR_DISPLAY              = $0B004409; (* Shows next on-screen display option *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_DISPLAY}
  DIAXIS_STRATEGYR_ROTATE                 = $0B024203; (* Turn body left/right *)
  {$EXTERNALSYM DIAXIS_STRATEGYR_ROTATE}
  DIBUTTON_STRATEGYR_LEFT_LINK            = $0B00C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_LEFT_LINK}
  DIBUTTON_STRATEGYR_RIGHT_LINK           = $0B00C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_RIGHT_LINK}
  DIBUTTON_STRATEGYR_FORWARD_LINK         = $0B0144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_FORWARD_LINK}
  DIBUTTON_STRATEGYR_BACK_LINK            = $0B0144E8; (* Fallback move backward button *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_BACK_LINK}
  DIBUTTON_STRATEGYR_ROTATE_LEFT_LINK     = $0B0244E4; (* Fallback turn body left button *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_ROTATE_LEFT_LINK}
  DIBUTTON_STRATEGYR_ROTATE_RIGHT_LINK    = $0B0244EC; (* Fallback turn body right button *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_ROTATE_RIGHT_LINK}
  DIBUTTON_STRATEGYR_DEVICE               = $0B0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_DEVICE}
  DIBUTTON_STRATEGYR_PAUSE                = $0B0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_STRATEGYR_PAUSE}

(*--- Strategy - Turn based
      Navigation and problem solving are primary actions  ---*)
  DIVIRTUAL_STRATEGY_TURN                 = $0C000000;
  {$EXTERNALSYM DIVIRTUAL_STRATEGY_TURN}
  DIAXIS_STRATEGYT_LATERAL                = $0C008201; (* Sidestep left/right *)
  {$EXTERNALSYM DIAXIS_STRATEGYT_LATERAL}
  DIAXIS_STRATEGYT_MOVE                   = $0C010202; (* Move forward/backwards *)
  {$EXTERNALSYM DIAXIS_STRATEGYT_MOVE}
  DIBUTTON_STRATEGYT_SELECT               = $0C000401; (* Select unit or object *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_SELECT}
  DIBUTTON_STRATEGYT_INSTRUCT             = $0C000402; (* Cycle through instructions *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_INSTRUCT}
  DIBUTTON_STRATEGYT_APPLY                = $0C000403; (* Apply selected instruction *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_APPLY}
  DIBUTTON_STRATEGYT_TEAM                 = $0C000404; (* Select next team / cycle through all *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_TEAM}
  DIBUTTON_STRATEGYT_TURN                 = $0C000405; (* Indicate turn over *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_TURN}
  DIBUTTON_STRATEGYT_MENU                 = $0C0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_STRATEGYT_ZOOM                 = $0C004406; (* Zoom - in / out *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_ZOOM}
  DIBUTTON_STRATEGYT_MAP                  = $0C004407; (* cycle through map options *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_MAP}
  DIBUTTON_STRATEGYT_DISPLAY              = $0C004408; (* shows next on-screen display options *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_DISPLAY}
  DIBUTTON_STRATEGYT_LEFT_LINK            = $0C00C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_LEFT_LINK}
  DIBUTTON_STRATEGYT_RIGHT_LINK           = $0C00C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_RIGHT_LINK}
  DIBUTTON_STRATEGYT_FORWARD_LINK         = $0C0144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_FORWARD_LINK}
  DIBUTTON_STRATEGYT_BACK_LINK            = $0C0144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_BACK_LINK}
  DIBUTTON_STRATEGYT_DEVICE               = $0C0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_DEVICE}
  DIBUTTON_STRATEGYT_PAUSE                = $0C0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_STRATEGYT_PAUSE}

(*--- Sports - Hunting
      Hunting                ---*)
  DIVIRTUAL_SPORTS_HUNTING                = $0D000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_HUNTING}
  DIAXIS_HUNTING_LATERAL                  = $0D008201; (* sidestep left/right *)
  {$EXTERNALSYM DIAXIS_HUNTING_LATERAL}
  DIAXIS_HUNTING_MOVE                     = $0D010202; (* move forward/backwards *)
  {$EXTERNALSYM DIAXIS_HUNTING_MOVE}
  DIBUTTON_HUNTING_FIRE                   = $0D000401; (* Fire selected weapon *)
  {$EXTERNALSYM DIBUTTON_HUNTING_FIRE}
  DIBUTTON_HUNTING_AIM                    = $0D000402; (* Select aim/move *)
  {$EXTERNALSYM DIBUTTON_HUNTING_AIM}
  DIBUTTON_HUNTING_WEAPON                 = $0D000403; (* Select next weapon *)
  {$EXTERNALSYM DIBUTTON_HUNTING_WEAPON}
  DIBUTTON_HUNTING_BINOCULAR              = $0D000404; (* Look through Binoculars *)
  {$EXTERNALSYM DIBUTTON_HUNTING_BINOCULAR}
  DIBUTTON_HUNTING_CALL                   = $0D000405; (* Make animal call *)
  {$EXTERNALSYM DIBUTTON_HUNTING_CALL}
  DIBUTTON_HUNTING_MAP                    = $0D000406; (* View Map *)
  {$EXTERNALSYM DIBUTTON_HUNTING_MAP}
  DIBUTTON_HUNTING_SPECIAL                = $0D000407; (* Special game operation *)
  {$EXTERNALSYM DIBUTTON_HUNTING_SPECIAL}
  DIBUTTON_HUNTING_MENU                   = $0D0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_HUNTING_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_HUNTING_GLANCE              = $0D004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_HUNTING_GLANCE}
  DIBUTTON_HUNTING_DISPLAY                = $0D004408; (* show next on-screen display option *)
  {$EXTERNALSYM DIBUTTON_HUNTING_DISPLAY}
  DIAXIS_HUNTING_ROTATE                   = $0D024203; (* Turn body left/right *)
  {$EXTERNALSYM DIAXIS_HUNTING_ROTATE}
  DIBUTTON_HUNTING_CROUCH                 = $0D004409; (* Crouch/ Climb / Swim down *)
  {$EXTERNALSYM DIBUTTON_HUNTING_CROUCH}
  DIBUTTON_HUNTING_JUMP                   = $0D00440A; (* Jump/ Climb up / Swim up *)
  {$EXTERNALSYM DIBUTTON_HUNTING_JUMP}
  DIBUTTON_HUNTING_FIRESECONDARY          = $0D00440B; (* Alternative fire button *)
  {$EXTERNALSYM DIBUTTON_HUNTING_FIRESECONDARY}
  DIBUTTON_HUNTING_LEFT_LINK              = $0D00C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_HUNTING_LEFT_LINK}
  DIBUTTON_HUNTING_RIGHT_LINK             = $0D00C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_HUNTING_RIGHT_LINK}
  DIBUTTON_HUNTING_FORWARD_LINK           = $0D0144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_HUNTING_FORWARD_LINK}
  DIBUTTON_HUNTING_BACK_LINK              = $0D0144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_HUNTING_BACK_LINK}
  DIBUTTON_HUNTING_ROTATE_LEFT_LINK       = $0D0244E4; (* Fallback turn body left button *)
  {$EXTERNALSYM DIBUTTON_HUNTING_ROTATE_LEFT_LINK}
  DIBUTTON_HUNTING_ROTATE_RIGHT_LINK      = $0D0244EC; (* Fallback turn body right button *)
  {$EXTERNALSYM DIBUTTON_HUNTING_ROTATE_RIGHT_LINK}
  DIBUTTON_HUNTING_DEVICE                 = $0D0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_HUNTING_DEVICE}
  DIBUTTON_HUNTING_PAUSE                  = $0D0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_HUNTING_PAUSE}

(*--- Sports - Fishing
      Catching Fish is primary objective   ---*)
  DIVIRTUAL_SPORTS_FISHING                = $0E000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_FISHING}
  DIAXIS_FISHING_LATERAL                  = $0E008201; (* sidestep left/right *)
  {$EXTERNALSYM DIAXIS_FISHING_LATERAL}
  DIAXIS_FISHING_MOVE                     = $0E010202; (* move forward/backwards *)
  {$EXTERNALSYM DIAXIS_FISHING_MOVE}
  DIBUTTON_FISHING_CAST                   = $0E000401; (* Cast line *)
  {$EXTERNALSYM DIBUTTON_FISHING_CAST}
  DIBUTTON_FISHING_TYPE                   = $0E000402; (* Select cast type *)
  {$EXTERNALSYM DIBUTTON_FISHING_TYPE}
  DIBUTTON_FISHING_BINOCULAR              = $0E000403; (* Look through Binocular *)
  {$EXTERNALSYM DIBUTTON_FISHING_BINOCULAR}
  DIBUTTON_FISHING_BAIT                   = $0E000404; (* Select type of Bait *)
  {$EXTERNALSYM DIBUTTON_FISHING_BAIT}
  DIBUTTON_FISHING_MAP                    = $0E000405; (* View Map *)
  {$EXTERNALSYM DIBUTTON_FISHING_MAP}
  DIBUTTON_FISHING_MENU                   = $0E0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_FISHING_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_FISHING_GLANCE              = $0E004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_FISHING_GLANCE}
  DIBUTTON_FISHING_DISPLAY                = $0E004406; (* Show next on-screen display option *)
  {$EXTERNALSYM DIBUTTON_FISHING_DISPLAY}
  DIAXIS_FISHING_ROTATE                   = $0E024203; (* Turn character left / right *)
  {$EXTERNALSYM DIAXIS_FISHING_ROTATE}
  DIBUTTON_FISHING_CROUCH                 = $0E004407; (* Crouch/ Climb / Swim down *)
  {$EXTERNALSYM DIBUTTON_FISHING_CROUCH}
  DIBUTTON_FISHING_JUMP                   = $0E004408; (* Jump/ Climb up / Swim up *)
  {$EXTERNALSYM DIBUTTON_FISHING_JUMP}
  DIBUTTON_FISHING_LEFT_LINK              = $0E00C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_FISHING_LEFT_LINK}
  DIBUTTON_FISHING_RIGHT_LINK             = $0E00C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_FISHING_RIGHT_LINK}
  DIBUTTON_FISHING_FORWARD_LINK           = $0E0144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_FISHING_FORWARD_LINK}
  DIBUTTON_FISHING_BACK_LINK              = $0E0144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_FISHING_BACK_LINK}
  DIBUTTON_FISHING_ROTATE_LEFT_LINK       = $0E0244E4; (* Fallback turn body left button *)
  {$EXTERNALSYM DIBUTTON_FISHING_ROTATE_LEFT_LINK}
  DIBUTTON_FISHING_ROTATE_RIGHT_LINK      = $0E0244EC; (* Fallback turn body right button *)
  {$EXTERNALSYM DIBUTTON_FISHING_ROTATE_RIGHT_LINK}
  DIBUTTON_FISHING_DEVICE                 = $0E0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_FISHING_DEVICE}
  DIBUTTON_FISHING_PAUSE                  = $0E0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_FISHING_PAUSE}

(*--- Sports - Baseball - Batting
      Batter control is primary objective  ---*)
  DIVIRTUAL_SPORTS_BASEBALL_BAT           = $0F000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_BASEBALL_BAT}
  DIAXIS_BASEBALLB_LATERAL                = $0F008201; (* Aim left / right *)
  {$EXTERNALSYM DIAXIS_BASEBALLB_LATERAL}
  DIAXIS_BASEBALLB_MOVE                   = $0F010202; (* Aim up / down *)
  {$EXTERNALSYM DIAXIS_BASEBALLB_MOVE}
  DIBUTTON_BASEBALLB_SELECT               = $0F000401; (* cycle through swing options *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_SELECT}
  DIBUTTON_BASEBALLB_NORMAL               = $0F000402; (* normal swing *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_NORMAL}
  DIBUTTON_BASEBALLB_POWER                = $0F000403; (* swing for the fence *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_POWER}
  DIBUTTON_BASEBALLB_BUNT                 = $0F000404; (* bunt *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_BUNT}
  DIBUTTON_BASEBALLB_STEAL                = $0F000405; (* Base runner attempts to steal a base *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_STEAL}
  DIBUTTON_BASEBALLB_BURST                = $0F000406; (* Base runner invokes burst of speed *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_BURST}
  DIBUTTON_BASEBALLB_SLIDE                = $0F000407; (* Base runner slides into base *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_SLIDE}
  DIBUTTON_BASEBALLB_CONTACT              = $0F000408; (* Contact swing *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_CONTACT}
  DIBUTTON_BASEBALLB_MENU                 = $0F0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_BASEBALLB_NOSTEAL              = $0F004409; (* Base runner goes back to a base *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_NOSTEAL}
  DIBUTTON_BASEBALLB_BOX                  = $0F00440A; (* Enter or exit batting box *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_BOX}
  DIBUTTON_BASEBALLB_LEFT_LINK            = $0F00C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_LEFT_LINK}
  DIBUTTON_BASEBALLB_RIGHT_LINK           = $0F00C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_RIGHT_LINK}
  DIBUTTON_BASEBALLB_FORWARD_LINK         = $0F0144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_FORWARD_LINK}
  DIBUTTON_BASEBALLB_BACK_LINK            = $0F0144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_BACK_LINK}
  DIBUTTON_BASEBALLB_DEVICE               = $0F0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_DEVICE}
  DIBUTTON_BASEBALLB_PAUSE                = $0F0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_BASEBALLB_PAUSE}

(*--- Sports - Baseball - Pitching
      Pitcher control is primary objective   ---*)
  DIVIRTUAL_SPORTS_BASEBALL_PITCH         = $10000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_BASEBALL_PITCH}
  DIAXIS_BASEBALLP_LATERAL                = $10008201; (* Aim left / right *)
  {$EXTERNALSYM DIAXIS_BASEBALLP_LATERAL}
  DIAXIS_BASEBALLP_MOVE                   = $10010202; (* Aim up / down *)
  {$EXTERNALSYM DIAXIS_BASEBALLP_MOVE}
  DIBUTTON_BASEBALLP_SELECT               = $10000401; (* cycle through pitch selections *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_SELECT}
  DIBUTTON_BASEBALLP_PITCH                = $10000402; (* throw pitch *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_PITCH}
  DIBUTTON_BASEBALLP_BASE                 = $10000403; (* select base to throw to *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_BASE}
  DIBUTTON_BASEBALLP_THROW                = $10000404; (* throw to base *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_THROW}
  DIBUTTON_BASEBALLP_FAKE                 = $10000405; (* Fake a throw to a base *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_FAKE}
  DIBUTTON_BASEBALLP_MENU                 = $100004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_BASEBALLP_WALK                 = $10004406; (* Throw intentional walk / pitch out *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_WALK}
  DIBUTTON_BASEBALLP_LOOK                 = $10004407; (* Look at runners on bases *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_LOOK}
  DIBUTTON_BASEBALLP_LEFT_LINK            = $1000C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_LEFT_LINK}
  DIBUTTON_BASEBALLP_RIGHT_LINK           = $1000C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_RIGHT_LINK}
  DIBUTTON_BASEBALLP_FORWARD_LINK         = $100144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_FORWARD_LINK}
  DIBUTTON_BASEBALLP_BACK_LINK            = $100144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_BACK_LINK}
  DIBUTTON_BASEBALLP_DEVICE               = $100044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_DEVICE}
  DIBUTTON_BASEBALLP_PAUSE                = $100044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_BASEBALLP_PAUSE}

(*--- Sports - Baseball - Fielding
      Fielder control is primary objective  ---*)
  DIVIRTUAL_SPORTS_BASEBALL_FIELD         = $11000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_BASEBALL_FIELD}
  DIAXIS_BASEBALLF_LATERAL                = $11008201; (* Aim left / right *)
  {$EXTERNALSYM DIAXIS_BASEBALLF_LATERAL}
  DIAXIS_BASEBALLF_MOVE                   = $11010202; (* Aim up / down *)
  {$EXTERNALSYM DIAXIS_BASEBALLF_MOVE}
  DIBUTTON_BASEBALLF_NEAREST              = $11000401; (* Switch to fielder nearest to the ball *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_NEAREST}
  DIBUTTON_BASEBALLF_THROW1               = $11000402; (* Make conservative throw *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_THROW1}
  DIBUTTON_BASEBALLF_THROW2               = $11000403; (* Make aggressive throw *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_THROW2}
  DIBUTTON_BASEBALLF_BURST                = $11000404; (* Invoke burst of speed *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_BURST}
  DIBUTTON_BASEBALLF_JUMP                 = $11000405; (* Jump to catch ball *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_JUMP}
  DIBUTTON_BASEBALLF_DIVE                 = $11000406; (* Dive to catch ball *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_DIVE}
  DIBUTTON_BASEBALLF_MENU                 = $110004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_BASEBALLF_SHIFTIN              = $11004407; (* Shift the infield positioning *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_SHIFTIN}
  DIBUTTON_BASEBALLF_SHIFTOUT             = $11004408; (* Shift the outfield positioning *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_SHIFTOUT}
  DIBUTTON_BASEBALLF_AIM_LEFT_LINK        = $1100C4E4; (* Fallback aim left button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_AIM_LEFT_LINK}
  DIBUTTON_BASEBALLF_AIM_RIGHT_LINK       = $1100C4EC; (* Fallback aim right button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_AIM_RIGHT_LINK}
  DIBUTTON_BASEBALLF_FORWARD_LINK         = $110144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_FORWARD_LINK}
  DIBUTTON_BASEBALLF_BACK_LINK            = $110144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_BACK_LINK}
  DIBUTTON_BASEBALLF_DEVICE               = $110044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_DEVICE}
  DIBUTTON_BASEBALLF_PAUSE                = $110044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_BASEBALLF_PAUSE}

(*--- Sports - Basketball - Offense
      Offense  ---*)
  DIVIRTUAL_SPORTS_BASKETBALL_OFFENSE     = $12000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_BASKETBALL_OFFENSE}
  DIAXIS_BBALLO_LATERAL                   = $12008201; (* left / right *)
  {$EXTERNALSYM DIAXIS_BBALLO_LATERAL}
  DIAXIS_BBALLO_MOVE                      = $12010202; (* up / down *)
  {$EXTERNALSYM DIAXIS_BBALLO_MOVE}
  DIBUTTON_BBALLO_SHOOT                   = $12000401; (* shoot basket *)
  {$EXTERNALSYM DIBUTTON_BBALLO_SHOOT}
  DIBUTTON_BBALLO_DUNK                    = $12000402; (* dunk basket *)
  {$EXTERNALSYM DIBUTTON_BBALLO_DUNK}
  DIBUTTON_BBALLO_PASS                    = $12000403; (* throw pass *)
  {$EXTERNALSYM DIBUTTON_BBALLO_PASS}
  DIBUTTON_BBALLO_FAKE                    = $12000404; (* fake shot or pass *)
  {$EXTERNALSYM DIBUTTON_BBALLO_FAKE}
  DIBUTTON_BBALLO_SPECIAL                 = $12000405; (* apply special move *)
  {$EXTERNALSYM DIBUTTON_BBALLO_SPECIAL}
  DIBUTTON_BBALLO_PLAYER                  = $12000406; (* select next player *)
  {$EXTERNALSYM DIBUTTON_BBALLO_PLAYER}
  DIBUTTON_BBALLO_BURST                   = $12000407; (* invoke burst *)
  {$EXTERNALSYM DIBUTTON_BBALLO_BURST}
  DIBUTTON_BBALLO_CALL                    = $12000408; (* call for ball / pass to me *)
  {$EXTERNALSYM DIBUTTON_BBALLO_CALL}
  DIBUTTON_BBALLO_MENU                    = $120004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_BBALLO_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_BBALLO_GLANCE               = $12004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_BBALLO_GLANCE}
  DIBUTTON_BBALLO_SCREEN                  = $12004409; (* Call for screen *)
  {$EXTERNALSYM DIBUTTON_BBALLO_SCREEN}
  DIBUTTON_BBALLO_PLAY                    = $1200440A; (* Call for specific offensive play *)
  {$EXTERNALSYM DIBUTTON_BBALLO_PLAY}
  DIBUTTON_BBALLO_JAB                     = $1200440B; (* Initiate fake drive to basket *)
  {$EXTERNALSYM DIBUTTON_BBALLO_JAB}
  DIBUTTON_BBALLO_POST                    = $1200440C; (* Perform post move *)
  {$EXTERNALSYM DIBUTTON_BBALLO_POST}
  DIBUTTON_BBALLO_TIMEOUT                 = $1200440D; (* Time Out *)
  {$EXTERNALSYM DIBUTTON_BBALLO_TIMEOUT}
  DIBUTTON_BBALLO_SUBSTITUTE              = $1200440E; (* substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_BBALLO_SUBSTITUTE}
  DIBUTTON_BBALLO_LEFT_LINK               = $1200C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_BBALLO_LEFT_LINK}
  DIBUTTON_BBALLO_RIGHT_LINK              = $1200C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_BBALLO_RIGHT_LINK}
  DIBUTTON_BBALLO_FORWARD_LINK            = $120144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_BBALLO_FORWARD_LINK}
  DIBUTTON_BBALLO_BACK_LINK               = $120144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_BBALLO_BACK_LINK}
  DIBUTTON_BBALLO_DEVICE                  = $120044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_BBALLO_DEVICE}
  DIBUTTON_BBALLO_PAUSE                   = $120044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_BBALLO_PAUSE}

(*--- Sports - Basketball - Defense
      Defense  ---*)
  DIVIRTUAL_SPORTS_BASKETBALL_DEFENSE     = $13000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_BASKETBALL_DEFENSE}
  DIAXIS_BBALLD_LATERAL                   = $13008201; (* left / right *)
  {$EXTERNALSYM DIAXIS_BBALLD_LATERAL}
  DIAXIS_BBALLD_MOVE                      = $13010202; (* up / down *)
  {$EXTERNALSYM DIAXIS_BBALLD_MOVE}
  DIBUTTON_BBALLD_JUMP                    = $13000401; (* jump to block shot *)
  {$EXTERNALSYM DIBUTTON_BBALLD_JUMP}
  DIBUTTON_BBALLD_STEAL                   = $13000402; (* attempt to steal ball *)
  {$EXTERNALSYM DIBUTTON_BBALLD_STEAL}
  DIBUTTON_BBALLD_FAKE                    = $13000403; (* fake block or steal *)
  {$EXTERNALSYM DIBUTTON_BBALLD_FAKE}
  DIBUTTON_BBALLD_SPECIAL                 = $13000404; (* apply special move *)
  {$EXTERNALSYM DIBUTTON_BBALLD_SPECIAL}
  DIBUTTON_BBALLD_PLAYER                  = $13000405; (* select next player *)
  {$EXTERNALSYM DIBUTTON_BBALLD_PLAYER}
  DIBUTTON_BBALLD_BURST                   = $13000406; (* invoke burst *)
  {$EXTERNALSYM DIBUTTON_BBALLD_BURST}
  DIBUTTON_BBALLD_PLAY                    = $13000407; (* call for specific defensive play *)
  {$EXTERNALSYM DIBUTTON_BBALLD_PLAY}
  DIBUTTON_BBALLD_MENU                    = $130004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_BBALLD_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_BBALLD_GLANCE               = $13004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_BBALLD_GLANCE}
  DIBUTTON_BBALLD_TIMEOUT                 = $13004408; (* Time Out *)
  {$EXTERNALSYM DIBUTTON_BBALLD_TIMEOUT}
  DIBUTTON_BBALLD_SUBSTITUTE              = $13004409; (* substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_BBALLD_SUBSTITUTE}
  DIBUTTON_BBALLD_LEFT_LINK               = $1300C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_BBALLD_LEFT_LINK}
  DIBUTTON_BBALLD_RIGHT_LINK              = $1300C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_BBALLD_RIGHT_LINK}
  DIBUTTON_BBALLD_FORWARD_LINK            = $130144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_BBALLD_FORWARD_LINK}
  DIBUTTON_BBALLD_BACK_LINK               = $130144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_BBALLD_BACK_LINK}
  DIBUTTON_BBALLD_DEVICE                  = $130044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_BBALLD_DEVICE}
  DIBUTTON_BBALLD_PAUSE                   = $130044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_BBALLD_PAUSE}

(*--- Sports - Football - Play
      Play selection  ---*)
  DIVIRTUAL_SPORTS_FOOTBALL_FIELD         = $14000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_FOOTBALL_FIELD}
  DIBUTTON_FOOTBALLP_PLAY                 = $14000401; (* cycle through available plays *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLP_PLAY}
  DIBUTTON_FOOTBALLP_SELECT               = $14000402; (* select play *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLP_SELECT}
  DIBUTTON_FOOTBALLP_HELP                 = $14000403; (* Bring up pop-up help *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLP_HELP}
  DIBUTTON_FOOTBALLP_MENU                 = $140004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLP_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_FOOTBALLP_DEVICE               = $140044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLP_DEVICE}
  DIBUTTON_FOOTBALLP_PAUSE                = $140044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLP_PAUSE}

(*--- Sports - Football - QB
      Offense: Quarterback / Kicker  ---*)
  DIVIRTUAL_SPORTS_FOOTBALL_QBCK          = $15000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_FOOTBALL_QBCK}
  DIAXIS_FOOTBALLQ_LATERAL                = $15008201; (* Move / Aim: left / right *)
  {$EXTERNALSYM DIAXIS_FOOTBALLQ_LATERAL}
  DIAXIS_FOOTBALLQ_MOVE                   = $15010202; (* Move / Aim: up / down *)
  {$EXTERNALSYM DIAXIS_FOOTBALLQ_MOVE}
  DIBUTTON_FOOTBALLQ_SELECT               = $15000401; (* Select *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_SELECT}
  DIBUTTON_FOOTBALLQ_SNAP                 = $15000402; (* snap ball - start play *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_SNAP}
  DIBUTTON_FOOTBALLQ_JUMP                 = $15000403; (* jump over defender *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_JUMP}
  DIBUTTON_FOOTBALLQ_SLIDE                = $15000404; (* Dive/Slide *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_SLIDE}
  DIBUTTON_FOOTBALLQ_PASS                 = $15000405; (* throws pass to receiver *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_PASS}
  DIBUTTON_FOOTBALLQ_FAKE                 = $15000406; (* pump fake pass or fake kick *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_FAKE}
  DIBUTTON_FOOTBALLQ_MENU                 = $150004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_FOOTBALLQ_FAKESNAP             = $15004407; (* Fake snap  *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_FAKESNAP}
  DIBUTTON_FOOTBALLQ_MOTION               = $15004408; (* Send receivers in motion *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_MOTION}
  DIBUTTON_FOOTBALLQ_AUDIBLE              = $15004409; (* Change offensive play at line of scrimmage *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_AUDIBLE}
  DIBUTTON_FOOTBALLQ_LEFT_LINK            = $1500C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_LEFT_LINK}
  DIBUTTON_FOOTBALLQ_RIGHT_LINK           = $1500C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_RIGHT_LINK}
  DIBUTTON_FOOTBALLQ_FORWARD_LINK         = $150144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_FORWARD_LINK}
  DIBUTTON_FOOTBALLQ_BACK_LINK            = $150144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_BACK_LINK}
  DIBUTTON_FOOTBALLQ_DEVICE               = $150044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_DEVICE}
  DIBUTTON_FOOTBALLQ_PAUSE                = $150044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLQ_PAUSE}

(*--- Sports - Football - Offense
      Offense - Runner  ---*)
  DIVIRTUAL_SPORTS_FOOTBALL_OFFENSE       = $16000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_FOOTBALL_OFFENSE}
  DIAXIS_FOOTBALLO_LATERAL                = $16008201; (* Move / Aim: left / right *)
  {$EXTERNALSYM DIAXIS_FOOTBALLO_LATERAL}
  DIAXIS_FOOTBALLO_MOVE                   = $16010202; (* Move / Aim: up / down *)
  {$EXTERNALSYM DIAXIS_FOOTBALLO_MOVE}
  DIBUTTON_FOOTBALLO_JUMP                 = $16000401; (* jump or hurdle over defender *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_JUMP}
  DIBUTTON_FOOTBALLO_LEFTARM              = $16000402; (* holds out left arm *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_LEFTARM}
  DIBUTTON_FOOTBALLO_RIGHTARM             = $16000403; (* holds out right arm *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_RIGHTARM}
  DIBUTTON_FOOTBALLO_THROW                = $16000404; (* throw pass or lateral ball to another runner *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_THROW}
  DIBUTTON_FOOTBALLO_SPIN                 = $16000405; (* Spin to avoid defenders *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_SPIN}
  DIBUTTON_FOOTBALLO_MENU                 = $160004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_FOOTBALLO_JUKE                 = $16004406; (* Use special move to avoid defenders *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_JUKE}
  DIBUTTON_FOOTBALLO_SHOULDER             = $16004407; (* Lower shoulder to run over defenders *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_SHOULDER}
  DIBUTTON_FOOTBALLO_TURBO                = $16004408; (* Speed burst past defenders *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_TURBO}
  DIBUTTON_FOOTBALLO_DIVE                 = $16004409; (* Dive over defenders *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_DIVE}
  DIBUTTON_FOOTBALLO_ZOOM                 = $1600440A; (* Zoom view in / out *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_ZOOM}
  DIBUTTON_FOOTBALLO_SUBSTITUTE           = $1600440B; (* substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_SUBSTITUTE}
  DIBUTTON_FOOTBALLO_LEFT_LINK            = $1600C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_LEFT_LINK}
  DIBUTTON_FOOTBALLO_RIGHT_LINK           = $1600C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_RIGHT_LINK}
  DIBUTTON_FOOTBALLO_FORWARD_LINK         = $160144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_FORWARD_LINK}
  DIBUTTON_FOOTBALLO_BACK_LINK            = $160144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_BACK_LINK}
  DIBUTTON_FOOTBALLO_DEVICE               = $160044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_DEVICE}
  DIBUTTON_FOOTBALLO_PAUSE                = $160044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLO_PAUSE}

(*--- Sports - Football - Defense
      Defense     ---*)
  DIVIRTUAL_SPORTS_FOOTBALL_DEFENSE       = $17000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_FOOTBALL_DEFENSE}
  DIAXIS_FOOTBALLD_LATERAL                = $17008201; (* Move / Aim: left / right *)
  {$EXTERNALSYM DIAXIS_FOOTBALLD_LATERAL}
  DIAXIS_FOOTBALLD_MOVE                   = $17010202; (* Move / Aim: up / down *)
  {$EXTERNALSYM DIAXIS_FOOTBALLD_MOVE}
  DIBUTTON_FOOTBALLD_PLAY                 = $17000401; (* cycle through available plays *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_PLAY}
  DIBUTTON_FOOTBALLD_SELECT               = $17000402; (* select player closest to the ball *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_SELECT}
  DIBUTTON_FOOTBALLD_JUMP                 = $17000403; (* jump to intercept or block *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_JUMP}
  DIBUTTON_FOOTBALLD_TACKLE               = $17000404; (* tackler runner *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_TACKLE}
  DIBUTTON_FOOTBALLD_FAKE                 = $17000405; (* hold down to fake tackle or intercept *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_FAKE}
  DIBUTTON_FOOTBALLD_SUPERTACKLE          = $17000406; (* Initiate special tackle *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_SUPERTACKLE}
  DIBUTTON_FOOTBALLD_MENU                 = $170004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_FOOTBALLD_SPIN                 = $17004407; (* Spin to beat offensive line *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_SPIN}
  DIBUTTON_FOOTBALLD_SWIM                 = $17004408; (* Swim to beat the offensive line *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_SWIM}
  DIBUTTON_FOOTBALLD_BULLRUSH             = $17004409; (* Bull rush the offensive line *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_BULLRUSH}
  DIBUTTON_FOOTBALLD_RIP                  = $1700440A; (* Rip the offensive line *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_RIP}
  DIBUTTON_FOOTBALLD_AUDIBLE              = $1700440B; (* Change defensive play at the line of scrimmage *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_AUDIBLE}
  DIBUTTON_FOOTBALLD_ZOOM                 = $1700440C; (* Zoom view in / out *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_ZOOM}
  DIBUTTON_FOOTBALLD_SUBSTITUTE           = $1700440D; (* substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_SUBSTITUTE}
  DIBUTTON_FOOTBALLD_LEFT_LINK            = $1700C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_LEFT_LINK}
  DIBUTTON_FOOTBALLD_RIGHT_LINK           = $1700C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_RIGHT_LINK}
  DIBUTTON_FOOTBALLD_FORWARD_LINK         = $170144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_FORWARD_LINK}
  DIBUTTON_FOOTBALLD_BACK_LINK            = $170144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_BACK_LINK}
  DIBUTTON_FOOTBALLD_DEVICE               = $170044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_DEVICE}
  DIBUTTON_FOOTBALLD_PAUSE                = $170044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_FOOTBALLD_PAUSE}

(*--- Sports - Golf
                                ---*)
  DIVIRTUAL_SPORTS_GOLF                   = $18000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_GOLF}
  DIAXIS_GOLF_LATERAL                     = $18008201; (* Move / Aim: left / right *)
  {$EXTERNALSYM DIAXIS_GOLF_LATERAL}
  DIAXIS_GOLF_MOVE                        = $18010202; (* Move / Aim: up / down *)
  {$EXTERNALSYM DIAXIS_GOLF_MOVE}
  DIBUTTON_GOLF_SWING                     = $18000401; (* swing club *)
  {$EXTERNALSYM DIBUTTON_GOLF_SWING}
  DIBUTTON_GOLF_SELECT                    = $18000402; (* cycle between: club / swing strength / ball arc / ball spin *)
  {$EXTERNALSYM DIBUTTON_GOLF_SELECT}
  DIBUTTON_GOLF_UP                        = $18000403; (* increase selection *)
  {$EXTERNALSYM DIBUTTON_GOLF_UP}
  DIBUTTON_GOLF_DOWN                      = $18000404; (* decrease selection *)
  {$EXTERNALSYM DIBUTTON_GOLF_DOWN}
  DIBUTTON_GOLF_TERRAIN                   = $18000405; (* shows terrain detail *)
  {$EXTERNALSYM DIBUTTON_GOLF_TERRAIN}
  DIBUTTON_GOLF_FLYBY                     = $18000406; (* view the hole via a flyby *)
  {$EXTERNALSYM DIBUTTON_GOLF_FLYBY}
  DIBUTTON_GOLF_MENU                      = $180004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_GOLF_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_GOLF_SCROLL                 = $18004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_GOLF_SCROLL}
  DIBUTTON_GOLF_ZOOM                      = $18004407; (* Zoom view in / out *)
  {$EXTERNALSYM DIBUTTON_GOLF_ZOOM}
  DIBUTTON_GOLF_TIMEOUT                   = $18004408; (* Call for time out *)
  {$EXTERNALSYM DIBUTTON_GOLF_TIMEOUT}
  DIBUTTON_GOLF_SUBSTITUTE                = $18004409; (* substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_GOLF_SUBSTITUTE}
  DIBUTTON_GOLF_LEFT_LINK                 = $1800C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_GOLF_LEFT_LINK}
  DIBUTTON_GOLF_RIGHT_LINK                = $1800C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_GOLF_RIGHT_LINK}
  DIBUTTON_GOLF_FORWARD_LINK              = $180144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_GOLF_FORWARD_LINK}
  DIBUTTON_GOLF_BACK_LINK                 = $180144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_GOLF_BACK_LINK}
  DIBUTTON_GOLF_DEVICE                    = $180044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_GOLF_DEVICE}
  DIBUTTON_GOLF_PAUSE                     = $180044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_GOLF_PAUSE}

(*--- Sports - Hockey - Offense
      Offense       ---*)
  DIVIRTUAL_SPORTS_HOCKEY_OFFENSE         = $19000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_HOCKEY_OFFENSE}
  DIAXIS_HOCKEYO_LATERAL                  = $19008201; (* Move / Aim: left / right *)
  {$EXTERNALSYM DIAXIS_HOCKEYO_LATERAL}
  DIAXIS_HOCKEYO_MOVE                     = $19010202; (* Move / Aim: up / down *)
  {$EXTERNALSYM DIAXIS_HOCKEYO_MOVE}
  DIBUTTON_HOCKEYO_SHOOT                  = $19000401; (* Shoot *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_SHOOT}
  DIBUTTON_HOCKEYO_PASS                   = $19000402; (* pass the puck *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_PASS}
  DIBUTTON_HOCKEYO_BURST                  = $19000403; (* invoke speed burst *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_BURST}
  DIBUTTON_HOCKEYO_SPECIAL                = $19000404; (* invoke special move *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_SPECIAL}
  DIBUTTON_HOCKEYO_FAKE                   = $19000405; (* hold down to fake pass or kick *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_FAKE}
  DIBUTTON_HOCKEYO_MENU                   = $190004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_HOCKEYO_SCROLL              = $19004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_HOCKEYO_SCROLL}
  DIBUTTON_HOCKEYO_ZOOM                   = $19004406; (* Zoom view in / out *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_ZOOM}
  DIBUTTON_HOCKEYO_STRATEGY               = $19004407; (* Invoke coaching menu for strategy help *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_STRATEGY}
  DIBUTTON_HOCKEYO_TIMEOUT                = $19004408; (* Call for time out *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_TIMEOUT}
  DIBUTTON_HOCKEYO_SUBSTITUTE             = $19004409; (* substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_SUBSTITUTE}
  DIBUTTON_HOCKEYO_LEFT_LINK              = $1900C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_LEFT_LINK}
  DIBUTTON_HOCKEYO_RIGHT_LINK             = $1900C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_RIGHT_LINK}
  DIBUTTON_HOCKEYO_FORWARD_LINK           = $190144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_FORWARD_LINK}
  DIBUTTON_HOCKEYO_BACK_LINK              = $190144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_BACK_LINK}
  DIBUTTON_HOCKEYO_DEVICE                 = $190044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_DEVICE}
  DIBUTTON_HOCKEYO_PAUSE                  = $190044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_HOCKEYO_PAUSE}

(*--- Sports - Hockey - Defense
      Defense       ---*)
  DIVIRTUAL_SPORTS_HOCKEY_DEFENSE         = $1A000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_HOCKEY_DEFENSE}
  DIAXIS_HOCKEYD_LATERAL                  = $1A008201; (* Move / Aim: left / right *)
  {$EXTERNALSYM DIAXIS_HOCKEYD_LATERAL}
  DIAXIS_HOCKEYD_MOVE                     = $1A010202; (* Move / Aim: up / down *)
  {$EXTERNALSYM DIAXIS_HOCKEYD_MOVE}
  DIBUTTON_HOCKEYD_PLAYER                 = $1A000401; (* control player closest to the puck *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_PLAYER}
  DIBUTTON_HOCKEYD_STEAL                  = $1A000402; (* attempt steal *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_STEAL}
  DIBUTTON_HOCKEYD_BURST                  = $1A000403; (* speed burst or body check *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_BURST}
  DIBUTTON_HOCKEYD_BLOCK                  = $1A000404; (* block puck *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_BLOCK}
  DIBUTTON_HOCKEYD_FAKE                   = $1A000405; (* hold down to fake tackle or intercept *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_FAKE}
  DIBUTTON_HOCKEYD_MENU                   = $1A0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_HOCKEYD_SCROLL              = $1A004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_HOCKEYD_SCROLL}
  DIBUTTON_HOCKEYD_ZOOM                   = $1A004406; (* Zoom view in / out *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_ZOOM}
  DIBUTTON_HOCKEYD_STRATEGY               = $1A004407; (* Invoke coaching menu for strategy help *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_STRATEGY}
  DIBUTTON_HOCKEYD_TIMEOUT                = $1A004408; (* Call for time out *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_TIMEOUT}
  DIBUTTON_HOCKEYD_SUBSTITUTE             = $1A004409; (* substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_SUBSTITUTE}
  DIBUTTON_HOCKEYD_LEFT_LINK              = $1A00C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_LEFT_LINK}
  DIBUTTON_HOCKEYD_RIGHT_LINK             = $1A00C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_RIGHT_LINK}
  DIBUTTON_HOCKEYD_FORWARD_LINK           = $1A0144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_FORWARD_LINK}
  DIBUTTON_HOCKEYD_BACK_LINK              = $1A0144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_BACK_LINK}
  DIBUTTON_HOCKEYD_DEVICE                 = $1A0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_DEVICE}
  DIBUTTON_HOCKEYD_PAUSE                  = $1A0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_HOCKEYD_PAUSE}

(*--- Sports - Hockey - Goalie
      Goal tending  ---*)
  DIVIRTUAL_SPORTS_HOCKEY_GOALIE          = $1B000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_HOCKEY_GOALIE}
  DIAXIS_HOCKEYG_LATERAL                  = $1B008201; (* Move / Aim: left / right *)
  {$EXTERNALSYM DIAXIS_HOCKEYG_LATERAL}
  DIAXIS_HOCKEYG_MOVE                     = $1B010202; (* Move / Aim: up / down *)
  {$EXTERNALSYM DIAXIS_HOCKEYG_MOVE}
  DIBUTTON_HOCKEYG_PASS                   = $1B000401; (* pass puck *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_PASS}
  DIBUTTON_HOCKEYG_POKE                   = $1B000402; (* poke / check / hack *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_POKE}
  DIBUTTON_HOCKEYG_STEAL                  = $1B000403; (* attempt steal *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_STEAL}
  DIBUTTON_HOCKEYG_BLOCK                  = $1B000404; (* block puck *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_BLOCK}
  DIBUTTON_HOCKEYG_MENU                   = $1B0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_HOCKEYG_SCROLL              = $1B004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_HOCKEYG_SCROLL}
  DIBUTTON_HOCKEYG_ZOOM                   = $1B004405; (* Zoom view in / out *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_ZOOM}
  DIBUTTON_HOCKEYG_STRATEGY               = $1B004406; (* Invoke coaching menu for strategy help *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_STRATEGY}
  DIBUTTON_HOCKEYG_TIMEOUT                = $1B004407; (* Call for time out *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_TIMEOUT}
  DIBUTTON_HOCKEYG_SUBSTITUTE             = $1B004408; (* substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_SUBSTITUTE}
  DIBUTTON_HOCKEYG_LEFT_LINK              = $1B00C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_LEFT_LINK}
  DIBUTTON_HOCKEYG_RIGHT_LINK             = $1B00C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_RIGHT_LINK}
  DIBUTTON_HOCKEYG_FORWARD_LINK           = $1B0144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_FORWARD_LINK}
  DIBUTTON_HOCKEYG_BACK_LINK              = $1B0144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_BACK_LINK}
  DIBUTTON_HOCKEYG_DEVICE                 = $1B0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_DEVICE}
  DIBUTTON_HOCKEYG_PAUSE                  = $1B0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_HOCKEYG_PAUSE}

(*--- Sports - Mountain Biking
                     ---*)
  DIVIRTUAL_SPORTS_BIKING_MOUNTAIN        = $1C000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_BIKING_MOUNTAIN}
  DIAXIS_BIKINGM_TURN                     = $1C008201; (* left / right *)
  {$EXTERNALSYM DIAXIS_BIKINGM_TURN}
  DIAXIS_BIKINGM_PEDAL                    = $1C010202; (* Pedal faster / slower / brake *)
  {$EXTERNALSYM DIAXIS_BIKINGM_PEDAL}
  DIBUTTON_BIKINGM_JUMP                   = $1C000401; (* jump over obstacle *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_JUMP}
  DIBUTTON_BIKINGM_CAMERA                 = $1C000402; (* switch camera view *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_CAMERA}
  DIBUTTON_BIKINGM_SPECIAL1               = $1C000403; (* perform first special move *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_SPECIAL1}
  DIBUTTON_BIKINGM_SELECT                 = $1C000404; (* Select *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_SELECT}
  DIBUTTON_BIKINGM_SPECIAL2               = $1C000405; (* perform second special move *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_SPECIAL2}
  DIBUTTON_BIKINGM_MENU                   = $1C0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_BIKINGM_SCROLL              = $1C004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_BIKINGM_SCROLL}
  DIBUTTON_BIKINGM_ZOOM                   = $1C004406; (* Zoom view in / out *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_ZOOM}
  DIAXIS_BIKINGM_BRAKE                    = $1C044203; (* Brake axis  *)
  {$EXTERNALSYM DIAXIS_BIKINGM_BRAKE}
  DIBUTTON_BIKINGM_LEFT_LINK              = $1C00C4E4; (* Fallback turn left button *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_LEFT_LINK}
  DIBUTTON_BIKINGM_RIGHT_LINK             = $1C00C4EC; (* Fallback turn right button *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_RIGHT_LINK}
  DIBUTTON_BIKINGM_FASTER_LINK            = $1C0144E0; (* Fallback pedal faster button *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_FASTER_LINK}
  DIBUTTON_BIKINGM_SLOWER_LINK            = $1C0144E8; (* Fallback pedal slower button *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_SLOWER_LINK}
  DIBUTTON_BIKINGM_BRAKE_BUTTON_LINK      = $1C0444E8; (* Fallback brake button *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_BRAKE_BUTTON_LINK}
  DIBUTTON_BIKINGM_DEVICE                 = $1C0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_DEVICE}
  DIBUTTON_BIKINGM_PAUSE                  = $1C0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_BIKINGM_PAUSE}

(*--- Sports: Skiing / Snowboarding / Skateboarding
        ---*)
  DIVIRTUAL_SPORTS_SKIING                 = $1D000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_SKIING}
  DIAXIS_SKIING_TURN                      = $1D008201; (* left / right *)
  {$EXTERNALSYM DIAXIS_SKIING_TURN}
  DIAXIS_SKIING_SPEED                     = $1D010202; (* faster / slower *)
  {$EXTERNALSYM DIAXIS_SKIING_SPEED}
  DIBUTTON_SKIING_JUMP                    = $1D000401; (* Jump *)
  {$EXTERNALSYM DIBUTTON_SKIING_JUMP}
  DIBUTTON_SKIING_CROUCH                  = $1D000402; (* crouch down *)
  {$EXTERNALSYM DIBUTTON_SKIING_CROUCH}
  DIBUTTON_SKIING_CAMERA                  = $1D000403; (* switch camera view *)
  {$EXTERNALSYM DIBUTTON_SKIING_CAMERA}
  DIBUTTON_SKIING_SPECIAL1                = $1D000404; (* perform first special move *)
  {$EXTERNALSYM DIBUTTON_SKIING_SPECIAL1}
  DIBUTTON_SKIING_SELECT                  = $1D000405; (* Select *)
  {$EXTERNALSYM DIBUTTON_SKIING_SELECT}
  DIBUTTON_SKIING_SPECIAL2                = $1D000406; (* perform second special move *)
  {$EXTERNALSYM DIBUTTON_SKIING_SPECIAL2}
  DIBUTTON_SKIING_MENU                    = $1D0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_SKIING_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_SKIING_GLANCE               = $1D004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_SKIING_GLANCE}
  DIBUTTON_SKIING_ZOOM                    = $1D004407; (* Zoom view in / out *)
  {$EXTERNALSYM DIBUTTON_SKIING_ZOOM}
  DIBUTTON_SKIING_LEFT_LINK               = $1D00C4E4; (* Fallback turn left button *)
  {$EXTERNALSYM DIBUTTON_SKIING_LEFT_LINK}
  DIBUTTON_SKIING_RIGHT_LINK              = $1D00C4EC; (* Fallback turn right button *)
  {$EXTERNALSYM DIBUTTON_SKIING_RIGHT_LINK}
  DIBUTTON_SKIING_FASTER_LINK             = $1D0144E0; (* Fallback increase speed button *)
  {$EXTERNALSYM DIBUTTON_SKIING_FASTER_LINK}
  DIBUTTON_SKIING_SLOWER_LINK             = $1D0144E8; (* Fallback decrease speed button *)
  {$EXTERNALSYM DIBUTTON_SKIING_SLOWER_LINK}
  DIBUTTON_SKIING_DEVICE                  = $1D0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_SKIING_DEVICE}
  DIBUTTON_SKIING_PAUSE                   = $1D0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_SKIING_PAUSE}

(*--- Sports - Soccer - Offense
      Offense       ---*)
  DIVIRTUAL_SPORTS_SOCCER_OFFENSE         = $1E000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_SOCCER_OFFENSE}
  DIAXIS_SOCCERO_LATERAL                  = $1E008201; (* Move / Aim: left / right *)
  {$EXTERNALSYM DIAXIS_SOCCERO_LATERAL}
  DIAXIS_SOCCERO_MOVE                     = $1E010202; (* Move / Aim: up / down *)
  {$EXTERNALSYM DIAXIS_SOCCERO_MOVE}
  DIAXIS_SOCCERO_BEND                     = $1E018203; (* Bend to soccer shot/pass *)
  {$EXTERNALSYM DIAXIS_SOCCERO_BEND}
  DIBUTTON_SOCCERO_SHOOT                  = $1E000401; (* Shoot the ball *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_SHOOT}
  DIBUTTON_SOCCERO_PASS                   = $1E000402; (* Pass  *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_PASS}
  DIBUTTON_SOCCERO_FAKE                   = $1E000403; (* Fake *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_FAKE}
  DIBUTTON_SOCCERO_PLAYER                 = $1E000404; (* Select next player *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_PLAYER}
  DIBUTTON_SOCCERO_SPECIAL1               = $1E000405; (* Apply special move *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_SPECIAL1}
  DIBUTTON_SOCCERO_SELECT                 = $1E000406; (* Select special move *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_SELECT}
  DIBUTTON_SOCCERO_MENU                   = $1E0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_SOCCERO_GLANCE              = $1E004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_SOCCERO_GLANCE}
  DIBUTTON_SOCCERO_SUBSTITUTE             = $1E004407; (* Substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_SUBSTITUTE}
  DIBUTTON_SOCCERO_SHOOTLOW               = $1E004408; (* Shoot the ball low *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_SHOOTLOW}
  DIBUTTON_SOCCERO_SHOOTHIGH              = $1E004409; (* Shoot the ball high *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_SHOOTHIGH}
  DIBUTTON_SOCCERO_PASSTHRU               = $1E00440A; (* Make a thru pass *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_PASSTHRU}
  DIBUTTON_SOCCERO_SPRINT                 = $1E00440B; (* Sprint / turbo boost *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_SPRINT}
  DIBUTTON_SOCCERO_CONTROL                = $1E00440C; (* Obtain control of the ball *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_CONTROL}
  DIBUTTON_SOCCERO_HEAD                   = $1E00440D; (* Attempt to head the ball *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_HEAD}
  DIBUTTON_SOCCERO_LEFT_LINK              = $1E00C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_LEFT_LINK}
  DIBUTTON_SOCCERO_RIGHT_LINK             = $1E00C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_RIGHT_LINK}
  DIBUTTON_SOCCERO_FORWARD_LINK           = $1E0144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_FORWARD_LINK}
  DIBUTTON_SOCCERO_BACK_LINK              = $1E0144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_BACK_LINK}
  DIBUTTON_SOCCERO_DEVICE                 = $1E0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_DEVICE}
  DIBUTTON_SOCCERO_PAUSE                  = $1E0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_SOCCERO_PAUSE}

(*--- Sports - Soccer - Defense
      Defense       ---*)
  DIVIRTUAL_SPORTS_SOCCER_DEFENSE         = $1F000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_SOCCER_DEFENSE}
  DIAXIS_SOCCERD_LATERAL                  = $1F008201; (* Move / Aim: left / right *)
  {$EXTERNALSYM DIAXIS_SOCCERD_LATERAL}
  DIAXIS_SOCCERD_MOVE                     = $1F010202; (* Move / Aim: up / down *)
  {$EXTERNALSYM DIAXIS_SOCCERD_MOVE}
  DIBUTTON_SOCCERD_BLOCK                  = $1F000401; (* Attempt to block shot *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_BLOCK}
  DIBUTTON_SOCCERD_STEAL                  = $1F000402; (* Attempt to steal ball *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_STEAL}
  DIBUTTON_SOCCERD_FAKE                   = $1F000403; (* Fake a block or a steal *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_FAKE}
  DIBUTTON_SOCCERD_PLAYER                 = $1F000404; (* Select next player *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_PLAYER}
  DIBUTTON_SOCCERD_SPECIAL                = $1F000405; (* Apply special move *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_SPECIAL}
  DIBUTTON_SOCCERD_SELECT                 = $1F000406; (* Select special move *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_SELECT}
  DIBUTTON_SOCCERD_SLIDE                  = $1F000407; (* Attempt a slide tackle *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_SLIDE}
  DIBUTTON_SOCCERD_MENU                   = $1F0004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_SOCCERD_GLANCE              = $1F004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_SOCCERD_GLANCE}
  DIBUTTON_SOCCERD_FOUL                   = $1F004408; (* Initiate a foul / hard-foul *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_FOUL}
  DIBUTTON_SOCCERD_HEAD                   = $1F004409; (* Attempt a Header *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_HEAD}
  DIBUTTON_SOCCERD_CLEAR                  = $1F00440A; (* Attempt to clear the ball down the field *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_CLEAR}
  DIBUTTON_SOCCERD_GOALIECHARGE           = $1F00440B; (* Make the goalie charge out of the box *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_GOALIECHARGE}
  DIBUTTON_SOCCERD_SUBSTITUTE             = $1F00440C; (* Substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_SUBSTITUTE}
  DIBUTTON_SOCCERD_LEFT_LINK              = $1F00C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_LEFT_LINK}
  DIBUTTON_SOCCERD_RIGHT_LINK             = $1F00C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_RIGHT_LINK}
  DIBUTTON_SOCCERD_FORWARD_LINK           = $1F0144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_FORWARD_LINK}
  DIBUTTON_SOCCERD_BACK_LINK              = $1F0144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_BACK_LINK}
  DIBUTTON_SOCCERD_DEVICE                 = $1F0044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_DEVICE}
  DIBUTTON_SOCCERD_PAUSE                  = $1F0044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_SOCCERD_PAUSE}

(*--- Sports - Racquet
      Tennis - Table-Tennis - Squash   ---*)
  DIVIRTUAL_SPORTS_RACQUET                = $20000000;
  {$EXTERNALSYM DIVIRTUAL_SPORTS_RACQUET}
  DIAXIS_RACQUET_LATERAL                  = $20008201; (* Move / Aim: left / right *)
  {$EXTERNALSYM DIAXIS_RACQUET_LATERAL}
  DIAXIS_RACQUET_MOVE                     = $20010202; (* Move / Aim: up / down *)
  {$EXTERNALSYM DIAXIS_RACQUET_MOVE}
  DIBUTTON_RACQUET_SWING                  = $20000401; (* Swing racquet *)
  {$EXTERNALSYM DIBUTTON_RACQUET_SWING}
  DIBUTTON_RACQUET_BACKSWING              = $20000402; (* Swing backhand *)
  {$EXTERNALSYM DIBUTTON_RACQUET_BACKSWING}
  DIBUTTON_RACQUET_SMASH                  = $20000403; (* Smash shot *)
  {$EXTERNALSYM DIBUTTON_RACQUET_SMASH}
  DIBUTTON_RACQUET_SPECIAL                = $20000404; (* Special shot *)
  {$EXTERNALSYM DIBUTTON_RACQUET_SPECIAL}
  DIBUTTON_RACQUET_SELECT                 = $20000405; (* Select special shot *)
  {$EXTERNALSYM DIBUTTON_RACQUET_SELECT}
  DIBUTTON_RACQUET_MENU                   = $200004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_RACQUET_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_RACQUET_GLANCE              = $20004601; (* scroll view *)
  {$EXTERNALSYM DIHATSWITCH_RACQUET_GLANCE}
  DIBUTTON_RACQUET_TIMEOUT                = $20004406; (* Call for time out *)
  {$EXTERNALSYM DIBUTTON_RACQUET_TIMEOUT}
  DIBUTTON_RACQUET_SUBSTITUTE             = $20004407; (* Substitute one player for another *)
  {$EXTERNALSYM DIBUTTON_RACQUET_SUBSTITUTE}
  DIBUTTON_RACQUET_LEFT_LINK              = $2000C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_RACQUET_LEFT_LINK}
  DIBUTTON_RACQUET_RIGHT_LINK             = $2000C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_RACQUET_RIGHT_LINK}
  DIBUTTON_RACQUET_FORWARD_LINK           = $200144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_RACQUET_FORWARD_LINK}
  DIBUTTON_RACQUET_BACK_LINK              = $200144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_RACQUET_BACK_LINK}
  DIBUTTON_RACQUET_DEVICE                 = $200044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_RACQUET_DEVICE}
  DIBUTTON_RACQUET_PAUSE                  = $200044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_RACQUET_PAUSE}

(*--- Arcade- 2D
      Side to Side movement        ---*)
  DIVIRTUAL_ARCADE_SIDE2SIDE              = $21000000;
  {$EXTERNALSYM DIVIRTUAL_ARCADE_SIDE2SIDE}
  DIAXIS_ARCADES_LATERAL                  = $21008201; (* left / right *)
  {$EXTERNALSYM DIAXIS_ARCADES_LATERAL}
  DIAXIS_ARCADES_MOVE                     = $21010202; (* up / down *)
  {$EXTERNALSYM DIAXIS_ARCADES_MOVE}
  DIBUTTON_ARCADES_THROW                  = $21000401; (* throw object *)
  {$EXTERNALSYM DIBUTTON_ARCADES_THROW}
  DIBUTTON_ARCADES_CARRY                  = $21000402; (* carry object *)
  {$EXTERNALSYM DIBUTTON_ARCADES_CARRY}
  DIBUTTON_ARCADES_ATTACK                 = $21000403; (* attack *)
  {$EXTERNALSYM DIBUTTON_ARCADES_ATTACK}
  DIBUTTON_ARCADES_SPECIAL                = $21000404; (* apply special move *)
  {$EXTERNALSYM DIBUTTON_ARCADES_SPECIAL}
  DIBUTTON_ARCADES_SELECT                 = $21000405; (* select special move *)
  {$EXTERNALSYM DIBUTTON_ARCADES_SELECT}
  DIBUTTON_ARCADES_MENU                   = $210004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_ARCADES_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_ARCADES_VIEW                = $21004601; (* scroll view left / right / up / down *)
  {$EXTERNALSYM DIHATSWITCH_ARCADES_VIEW}
  DIBUTTON_ARCADES_LEFT_LINK              = $2100C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_ARCADES_LEFT_LINK}
  DIBUTTON_ARCADES_RIGHT_LINK             = $2100C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_ARCADES_RIGHT_LINK}
  DIBUTTON_ARCADES_FORWARD_LINK           = $210144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_ARCADES_FORWARD_LINK}
  DIBUTTON_ARCADES_BACK_LINK              = $210144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_ARCADES_BACK_LINK}
  DIBUTTON_ARCADES_VIEW_UP_LINK           = $2107C4E0; (* Fallback scroll view up button *)
  {$EXTERNALSYM DIBUTTON_ARCADES_VIEW_UP_LINK}
  DIBUTTON_ARCADES_VIEW_DOWN_LINK         = $2107C4E8; (* Fallback scroll view down button *)
  {$EXTERNALSYM DIBUTTON_ARCADES_VIEW_DOWN_LINK}
  DIBUTTON_ARCADES_VIEW_LEFT_LINK         = $2107C4E4; (* Fallback scroll view left button *)
  {$EXTERNALSYM DIBUTTON_ARCADES_VIEW_LEFT_LINK}
  DIBUTTON_ARCADES_VIEW_RIGHT_LINK        = $2107C4EC; (* Fallback scroll view right button *)
  {$EXTERNALSYM DIBUTTON_ARCADES_VIEW_RIGHT_LINK}
  DIBUTTON_ARCADES_DEVICE                 = $210044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_ARCADES_DEVICE}
  DIBUTTON_ARCADES_PAUSE                  = $210044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_ARCADES_PAUSE}

(*--- Arcade - Platform Game
      Character moves around on screen  ---*)
  DIVIRTUAL_ARCADE_PLATFORM               = $22000000;
  {$EXTERNALSYM DIVIRTUAL_ARCADE_PLATFORM}
  DIAXIS_ARCADEP_LATERAL                  = $22008201; (* Left / right *)
  {$EXTERNALSYM DIAXIS_ARCADEP_LATERAL}
  DIAXIS_ARCADEP_MOVE                     = $22010202; (* Up / down *)
  {$EXTERNALSYM DIAXIS_ARCADEP_MOVE}
  DIBUTTON_ARCADEP_JUMP                   = $22000401; (* Jump *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_JUMP}
  DIBUTTON_ARCADEP_FIRE                   = $22000402; (* Fire *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_FIRE}
  DIBUTTON_ARCADEP_CROUCH                 = $22000403; (* Crouch *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_CROUCH}
  DIBUTTON_ARCADEP_SPECIAL                = $22000404; (* Apply special move *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_SPECIAL}
  DIBUTTON_ARCADEP_SELECT                 = $22000405; (* Select special move *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_SELECT}
  DIBUTTON_ARCADEP_MENU                   = $220004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_ARCADEP_VIEW                = $22004601; (* Scroll view *)
  {$EXTERNALSYM DIHATSWITCH_ARCADEP_VIEW}
  DIBUTTON_ARCADEP_FIRESECONDARY          = $22004406; (* Alternative fire button *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_FIRESECONDARY}
  DIBUTTON_ARCADEP_LEFT_LINK              = $2200C4E4; (* Fallback sidestep left button *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_LEFT_LINK}
  DIBUTTON_ARCADEP_RIGHT_LINK             = $2200C4EC; (* Fallback sidestep right button *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_RIGHT_LINK}
  DIBUTTON_ARCADEP_FORWARD_LINK           = $220144E0; (* Fallback move forward button *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_FORWARD_LINK}
  DIBUTTON_ARCADEP_BACK_LINK              = $220144E8; (* Fallback move back button *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_BACK_LINK}
  DIBUTTON_ARCADEP_VIEW_UP_LINK           = $2207C4E0; (* Fallback scroll view up button *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_VIEW_UP_LINK}
  DIBUTTON_ARCADEP_VIEW_DOWN_LINK         = $2207C4E8; (* Fallback scroll view down button *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_VIEW_DOWN_LINK}
  DIBUTTON_ARCADEP_VIEW_LEFT_LINK         = $2207C4E4; (* Fallback scroll view left button *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_VIEW_LEFT_LINK}
  DIBUTTON_ARCADEP_VIEW_RIGHT_LINK        = $2207C4EC; (* Fallback scroll view right button *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_VIEW_RIGHT_LINK}
  DIBUTTON_ARCADEP_DEVICE                 = $220044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_DEVICE}
  DIBUTTON_ARCADEP_PAUSE                  = $220044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_ARCADEP_PAUSE}

(*--- CAD - 2D Object Control
      Controls to select and move objects in 2D  ---*)
  DIVIRTUAL_CAD_2DCONTROL                 = $23000000;
  {$EXTERNALSYM DIVIRTUAL_CAD_2DCONTROL}
  DIAXIS_2DCONTROL_LATERAL                = $23008201; (* Move view left / right *)
  {$EXTERNALSYM DIAXIS_2DCONTROL_LATERAL}
  DIAXIS_2DCONTROL_MOVE                   = $23010202; (* Move view up / down *)
  {$EXTERNALSYM DIAXIS_2DCONTROL_MOVE}
  DIAXIS_2DCONTROL_INOUT                  = $23018203; (* Zoom - in / out *)
  {$EXTERNALSYM DIAXIS_2DCONTROL_INOUT}
  DIBUTTON_2DCONTROL_SELECT               = $23000401; (* Select Object *)
  {$EXTERNALSYM DIBUTTON_2DCONTROL_SELECT}
  DIBUTTON_2DCONTROL_SPECIAL1             = $23000402; (* Do first special operation *)
  {$EXTERNALSYM DIBUTTON_2DCONTROL_SPECIAL1}
  DIBUTTON_2DCONTROL_SPECIAL              = $23000403; (* Select special operation *)
  {$EXTERNALSYM DIBUTTON_2DCONTROL_SPECIAL}
  DIBUTTON_2DCONTROL_SPECIAL2             = $23000404; (* Do second special operation *)
  {$EXTERNALSYM DIBUTTON_2DCONTROL_SPECIAL2}
  DIBUTTON_2DCONTROL_MENU                 = $230004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_2DCONTROL_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_2DCONTROL_HATSWITCH         = $23004601; (* Hat switch *)
  {$EXTERNALSYM DIHATSWITCH_2DCONTROL_HATSWITCH}
  DIAXIS_2DCONTROL_ROTATEZ                = $23024204; (* Rotate view clockwise / counterclockwise *)
  {$EXTERNALSYM DIAXIS_2DCONTROL_ROTATEZ}
  DIBUTTON_2DCONTROL_DISPLAY              = $23004405; (* Shows next on-screen display options *)
  {$EXTERNALSYM DIBUTTON_2DCONTROL_DISPLAY}
  DIBUTTON_2DCONTROL_DEVICE               = $230044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_2DCONTROL_DEVICE}
  DIBUTTON_2DCONTROL_PAUSE                = $230044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_2DCONTROL_PAUSE}

(*--- CAD - 3D object control
      Controls to select and move objects within a 3D environment  ---*)
  DIVIRTUAL_CAD_3DCONTROL                 = $24000000;
  {$EXTERNALSYM DIVIRTUAL_CAD_3DCONTROL}
  DIAXIS_3DCONTROL_LATERAL                = $24008201; (* Move view left / right *)
  {$EXTERNALSYM DIAXIS_3DCONTROL_LATERAL}
  DIAXIS_3DCONTROL_MOVE                   = $24010202; (* Move view up / down *)
  {$EXTERNALSYM DIAXIS_3DCONTROL_MOVE}
  DIAXIS_3DCONTROL_INOUT                  = $24018203; (* Zoom - in / out *)
  {$EXTERNALSYM DIAXIS_3DCONTROL_INOUT}
  DIBUTTON_3DCONTROL_SELECT               = $24000401; (* Select Object *)
  {$EXTERNALSYM DIBUTTON_3DCONTROL_SELECT}
  DIBUTTON_3DCONTROL_SPECIAL1             = $24000402; (* Do first special operation *)
  {$EXTERNALSYM DIBUTTON_3DCONTROL_SPECIAL1}
  DIBUTTON_3DCONTROL_SPECIAL              = $24000403; (* Select special operation *)
  {$EXTERNALSYM DIBUTTON_3DCONTROL_SPECIAL}
  DIBUTTON_3DCONTROL_SPECIAL2             = $24000404; (* Do second special operation *)
  {$EXTERNALSYM DIBUTTON_3DCONTROL_SPECIAL2}
  DIBUTTON_3DCONTROL_MENU                 = $240004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_3DCONTROL_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_3DCONTROL_HATSWITCH         = $24004601; (* Hat switch *)
  {$EXTERNALSYM DIHATSWITCH_3DCONTROL_HATSWITCH}
  DIAXIS_3DCONTROL_ROTATEX                = $24034204; (* Rotate view forward or up / backward or down *)
  {$EXTERNALSYM DIAXIS_3DCONTROL_ROTATEX}
  DIAXIS_3DCONTROL_ROTATEY                = $2402C205; (* Rotate view clockwise / counterclockwise *)
  {$EXTERNALSYM DIAXIS_3DCONTROL_ROTATEY}
  DIAXIS_3DCONTROL_ROTATEZ                = $24024206; (* Rotate view left / right *)
  {$EXTERNALSYM DIAXIS_3DCONTROL_ROTATEZ}
  DIBUTTON_3DCONTROL_DISPLAY              = $24004405; (* Show next on-screen display options *)
  {$EXTERNALSYM DIBUTTON_3DCONTROL_DISPLAY}
  DIBUTTON_3DCONTROL_DEVICE               = $240044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_3DCONTROL_DEVICE}
  DIBUTTON_3DCONTROL_PAUSE                = $240044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_3DCONTROL_PAUSE}

(*--- CAD - 3D Navigation - Fly through
      Controls for 3D modeling  ---*)
  DIVIRTUAL_CAD_FLYBY                     = $25000000;
  {$EXTERNALSYM DIVIRTUAL_CAD_FLYBY}
  DIAXIS_CADF_LATERAL                     = $25008201; (* move view left / right *)
  {$EXTERNALSYM DIAXIS_CADF_LATERAL}
  DIAXIS_CADF_MOVE                        = $25010202; (* move view up / down *)
  {$EXTERNALSYM DIAXIS_CADF_MOVE}
  DIAXIS_CADF_INOUT                       = $25018203; (* in / out *)
  {$EXTERNALSYM DIAXIS_CADF_INOUT}
  DIBUTTON_CADF_SELECT                    = $25000401; (* Select Object *)
  {$EXTERNALSYM DIBUTTON_CADF_SELECT}
  DIBUTTON_CADF_SPECIAL1                  = $25000402; (* do first special operation *)
  {$EXTERNALSYM DIBUTTON_CADF_SPECIAL1}
  DIBUTTON_CADF_SPECIAL                   = $25000403; (* Select special operation *)
  {$EXTERNALSYM DIBUTTON_CADF_SPECIAL}
  DIBUTTON_CADF_SPECIAL2                  = $25000404; (* do second special operation *)
  {$EXTERNALSYM DIBUTTON_CADF_SPECIAL2}
  DIBUTTON_CADF_MENU                      = $250004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_CADF_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_CADF_HATSWITCH              = $25004601; (* Hat switch *)
  {$EXTERNALSYM DIHATSWITCH_CADF_HATSWITCH}
  DIAXIS_CADF_ROTATEX                     = $25034204; (* Rotate view forward or up / backward or down *)
  {$EXTERNALSYM DIAXIS_CADF_ROTATEX}
  DIAXIS_CADF_ROTATEY                     = $2502C205; (* Rotate view clockwise / counterclockwise *)
  {$EXTERNALSYM DIAXIS_CADF_ROTATEY}
  DIAXIS_CADF_ROTATEZ                     = $25024206; (* Rotate view left / right *)
  {$EXTERNALSYM DIAXIS_CADF_ROTATEZ}
  DIBUTTON_CADF_DISPLAY                   = $25004405; (* shows next on-screen display options *)
  {$EXTERNALSYM DIBUTTON_CADF_DISPLAY}
  DIBUTTON_CADF_DEVICE                    = $250044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_CADF_DEVICE}
  DIBUTTON_CADF_PAUSE                     = $250044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_CADF_PAUSE}

(*--- CAD - 3D Model Control
      Controls for 3D modeling  ---*)
  DIVIRTUAL_CAD_MODEL                     = $26000000;
  {$EXTERNALSYM DIVIRTUAL_CAD_MODEL}
  DIAXIS_CADM_LATERAL                     = $26008201; (* move view left / right *)
  {$EXTERNALSYM DIAXIS_CADM_LATERAL}
  DIAXIS_CADM_MOVE                        = $26010202; (* move view up / down *)
  {$EXTERNALSYM DIAXIS_CADM_MOVE}
  DIAXIS_CADM_INOUT                       = $26018203; (* in / out *)
  {$EXTERNALSYM DIAXIS_CADM_INOUT}
  DIBUTTON_CADM_SELECT                    = $26000401; (* Select Object *)
  {$EXTERNALSYM DIBUTTON_CADM_SELECT}
  DIBUTTON_CADM_SPECIAL1                  = $26000402; (* do first special operation *)
  {$EXTERNALSYM DIBUTTON_CADM_SPECIAL1}
  DIBUTTON_CADM_SPECIAL                   = $26000403; (* Select special operation *)
  {$EXTERNALSYM DIBUTTON_CADM_SPECIAL}
  DIBUTTON_CADM_SPECIAL2                  = $26000404; (* do second special operation *)
  {$EXTERNALSYM DIBUTTON_CADM_SPECIAL2}
  DIBUTTON_CADM_MENU                      = $260004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_CADM_MENU}
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_CADM_HATSWITCH              = $26004601; (* Hat switch *)
  {$EXTERNALSYM DIHATSWITCH_CADM_HATSWITCH}
  DIAXIS_CADM_ROTATEX                     = $26034204; (* Rotate view forward or up / backward or down *)
  {$EXTERNALSYM DIAXIS_CADM_ROTATEX}
  DIAXIS_CADM_ROTATEY                     = $2602C205; (* Rotate view clockwise / counterclockwise *)
  {$EXTERNALSYM DIAXIS_CADM_ROTATEY}
  DIAXIS_CADM_ROTATEZ                     = $26024206; (* Rotate view left / right *)
  {$EXTERNALSYM DIAXIS_CADM_ROTATEZ}
  DIBUTTON_CADM_DISPLAY                   = $26004405; (* shows next on-screen display options *)
  {$EXTERNALSYM DIBUTTON_CADM_DISPLAY}
  DIBUTTON_CADM_DEVICE                    = $260044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_CADM_DEVICE}
  DIBUTTON_CADM_PAUSE                     = $260044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_CADM_PAUSE}

(*--- Control - Media Equipment
      Remote        ---*)
  DIVIRTUAL_REMOTE_CONTROL                = $27000000;
  {$EXTERNALSYM DIVIRTUAL_REMOTE_CONTROL}
  DIAXIS_REMOTE_SLIDER                    = $27050201; (* Slider for adjustment: volume / color / bass / etc *)
  {$EXTERNALSYM DIAXIS_REMOTE_SLIDER}
  DIBUTTON_REMOTE_MUTE                    = $27000401; (* Set volume on current device to zero *)
  {$EXTERNALSYM DIBUTTON_REMOTE_MUTE}
  DIBUTTON_REMOTE_SELECT                  = $27000402; (* Next/previous: channel/ track / chapter / picture / station *)
  {$EXTERNALSYM DIBUTTON_REMOTE_SELECT}
  DIBUTTON_REMOTE_PLAY                    = $27002403; (* Start or pause entertainment on current device *)
  {$EXTERNALSYM DIBUTTON_REMOTE_PLAY}
  DIBUTTON_REMOTE_CUE                     = $27002404; (* Move through current media *)
  {$EXTERNALSYM DIBUTTON_REMOTE_CUE}
  DIBUTTON_REMOTE_REVIEW                  = $27002405; (* Move through current media *)
  {$EXTERNALSYM DIBUTTON_REMOTE_REVIEW}
  DIBUTTON_REMOTE_CHANGE                  = $27002406; (* Select next device *)
  {$EXTERNALSYM DIBUTTON_REMOTE_CHANGE}
  DIBUTTON_REMOTE_RECORD                  = $27002407; (* Start recording the current media *)
  {$EXTERNALSYM DIBUTTON_REMOTE_RECORD}
  DIBUTTON_REMOTE_MENU                    = $270004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_REMOTE_MENU}
(*--- Priority 2 controls                            ---*)

  DIAXIS_REMOTE_SLIDER2                   = $27054202; (* Slider for adjustment: volume *)
  {$EXTERNALSYM DIAXIS_REMOTE_SLIDER2}
  DIBUTTON_REMOTE_TV                      = $27005C08; (* Select TV *)
  {$EXTERNALSYM DIBUTTON_REMOTE_TV}
  DIBUTTON_REMOTE_CABLE                   = $27005C09; (* Select cable box *)
  {$EXTERNALSYM DIBUTTON_REMOTE_CABLE}
  DIBUTTON_REMOTE_CD                      = $27005C0A; (* Select CD player *)
  {$EXTERNALSYM DIBUTTON_REMOTE_CD}
  DIBUTTON_REMOTE_VCR                     = $27005C0B; (* Select VCR *)
  {$EXTERNALSYM DIBUTTON_REMOTE_VCR}
  DIBUTTON_REMOTE_TUNER                   = $27005C0C; (* Select tuner *)
  {$EXTERNALSYM DIBUTTON_REMOTE_TUNER}
  DIBUTTON_REMOTE_DVD                     = $27005C0D; (* Select DVD player *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DVD}
  DIBUTTON_REMOTE_ADJUST                  = $27005C0E; (* Enter device adjustment menu *)
  {$EXTERNALSYM DIBUTTON_REMOTE_ADJUST}
  DIBUTTON_REMOTE_DIGIT0                  = $2700540F; (* Digit 0 *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DIGIT0}
  DIBUTTON_REMOTE_DIGIT1                  = $27005410; (* Digit 1 *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DIGIT1}
  DIBUTTON_REMOTE_DIGIT2                  = $27005411; (* Digit 2 *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DIGIT2}
  DIBUTTON_REMOTE_DIGIT3                  = $27005412; (* Digit 3 *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DIGIT3}
  DIBUTTON_REMOTE_DIGIT4                  = $27005413; (* Digit 4 *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DIGIT4}
  DIBUTTON_REMOTE_DIGIT5                  = $27005414; (* Digit 5 *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DIGIT5}
  DIBUTTON_REMOTE_DIGIT6                  = $27005415; (* Digit 6 *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DIGIT6}
  DIBUTTON_REMOTE_DIGIT7                  = $27005416; (* Digit 7 *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DIGIT7}
  DIBUTTON_REMOTE_DIGIT8                  = $27005417; (* Digit 8 *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DIGIT8}
  DIBUTTON_REMOTE_DIGIT9                  = $27005418; (* Digit 9 *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DIGIT9}
  DIBUTTON_REMOTE_DEVICE                  = $270044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_REMOTE_DEVICE}
  DIBUTTON_REMOTE_PAUSE                   = $270044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_REMOTE_PAUSE}

(*--- Control- Web
      Help or Browser            ---*)
  DIVIRTUAL_BROWSER_CONTROL               = $28000000;
  {$EXTERNALSYM DIVIRTUAL_BROWSER_CONTROL}
  DIAXIS_BROWSER_LATERAL                  = $28008201; (* Move on screen pointer *)
  {$EXTERNALSYM DIAXIS_BROWSER_LATERAL}
  DIAXIS_BROWSER_MOVE                     = $28010202; (* Move on screen pointer *)
  {$EXTERNALSYM DIAXIS_BROWSER_MOVE}
  DIBUTTON_BROWSER_SELECT                 = $28000401; (* Select current item *)
  {$EXTERNALSYM DIBUTTON_BROWSER_SELECT}
  DIAXIS_BROWSER_VIEW                     = $28018203; (* Move view up/down *)
  {$EXTERNALSYM DIAXIS_BROWSER_VIEW}
  DIBUTTON_BROWSER_REFRESH                = $28000402; (* Refresh *)
  {$EXTERNALSYM DIBUTTON_BROWSER_REFRESH}
  DIBUTTON_BROWSER_MENU                   = $280004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_BROWSER_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_BROWSER_SEARCH                 = $28004403; (* Use search tool *)
  {$EXTERNALSYM DIBUTTON_BROWSER_SEARCH}
  DIBUTTON_BROWSER_STOP                   = $28004404; (* Cease current update *)
  {$EXTERNALSYM DIBUTTON_BROWSER_STOP}
  DIBUTTON_BROWSER_HOME                   = $28004405; (* Go directly to "home" location *)
  {$EXTERNALSYM DIBUTTON_BROWSER_HOME}
  DIBUTTON_BROWSER_FAVORITES              = $28004406; (* Mark current site as favorite *)
  {$EXTERNALSYM DIBUTTON_BROWSER_FAVORITES}
  DIBUTTON_BROWSER_NEXT                   = $28004407; (* Select Next page *)
  {$EXTERNALSYM DIBUTTON_BROWSER_NEXT}
  DIBUTTON_BROWSER_PREVIOUS               = $28004408; (* Select Previous page *)
  {$EXTERNALSYM DIBUTTON_BROWSER_PREVIOUS}
  DIBUTTON_BROWSER_HISTORY                = $28004409; (* Show/Hide History *)
  {$EXTERNALSYM DIBUTTON_BROWSER_HISTORY}
  DIBUTTON_BROWSER_PRINT                  = $2800440A; (* Print current page *)
  {$EXTERNALSYM DIBUTTON_BROWSER_PRINT}
  DIBUTTON_BROWSER_DEVICE                 = $280044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_BROWSER_DEVICE}
  DIBUTTON_BROWSER_PAUSE                  = $280044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_BROWSER_PAUSE}

(*--- Driving Simulator - Giant Walking Robot
      Walking tank with weapons  ---*)
  DIVIRTUAL_DRIVING_MECHA                 = $29000000;
  {$EXTERNALSYM DIVIRTUAL_DRIVING_MECHA}
  DIAXIS_MECHA_STEER                      = $29008201; (* Turns mecha left/right *)
  {$EXTERNALSYM DIAXIS_MECHA_STEER}
  DIAXIS_MECHA_TORSO                      = $29010202; (* Tilts torso forward/backward *)
  {$EXTERNALSYM DIAXIS_MECHA_TORSO}
  DIAXIS_MECHA_ROTATE                     = $29020203; (* Turns torso left/right *)
  {$EXTERNALSYM DIAXIS_MECHA_ROTATE}
  DIAXIS_MECHA_THROTTLE                   = $29038204; (* Engine Speed *)
  {$EXTERNALSYM DIAXIS_MECHA_THROTTLE}
  DIBUTTON_MECHA_FIRE                     = $29000401; (* Fire *)
  {$EXTERNALSYM DIBUTTON_MECHA_FIRE}
  DIBUTTON_MECHA_WEAPONS                  = $29000402; (* Select next weapon group *)
  {$EXTERNALSYM DIBUTTON_MECHA_WEAPONS}
  DIBUTTON_MECHA_TARGET                   = $29000403; (* Select closest enemy available target *)
  {$EXTERNALSYM DIBUTTON_MECHA_TARGET}
  DIBUTTON_MECHA_REVERSE                  = $29000404; (* Toggles throttle in/out of reverse *)
  {$EXTERNALSYM DIBUTTON_MECHA_REVERSE}
  DIBUTTON_MECHA_ZOOM                     = $29000405; (* Zoom in/out targeting reticule *)
  {$EXTERNALSYM DIBUTTON_MECHA_ZOOM}
  DIBUTTON_MECHA_JUMP                     = $29000406; (* Fires jump jets *)
  {$EXTERNALSYM DIBUTTON_MECHA_JUMP}
  DIBUTTON_MECHA_MENU                     = $290004FD; (* Show menu options *)
  {$EXTERNALSYM DIBUTTON_MECHA_MENU}
(*--- Priority 2 controls                            ---*)

  DIBUTTON_MECHA_CENTER                   = $29004407; (* Center torso to legs *)
  {$EXTERNALSYM DIBUTTON_MECHA_CENTER}
  DIHATSWITCH_MECHA_GLANCE                = $29004601; (* Look around *)
  {$EXTERNALSYM DIHATSWITCH_MECHA_GLANCE}
  DIBUTTON_MECHA_VIEW                     = $29004408; (* Cycle through view options *)
  {$EXTERNALSYM DIBUTTON_MECHA_VIEW}
  DIBUTTON_MECHA_FIRESECONDARY            = $29004409; (* Alternative fire button *)
  {$EXTERNALSYM DIBUTTON_MECHA_FIRESECONDARY}
  DIBUTTON_MECHA_LEFT_LINK                = $2900C4E4; (* Fallback steer left button *)
  {$EXTERNALSYM DIBUTTON_MECHA_LEFT_LINK}
  DIBUTTON_MECHA_RIGHT_LINK               = $2900C4EC; (* Fallback steer right button *)
  {$EXTERNALSYM DIBUTTON_MECHA_RIGHT_LINK}
  DIBUTTON_MECHA_FORWARD_LINK             = $290144E0; (* Fallback tilt torso forward button *)
  {$EXTERNALSYM DIBUTTON_MECHA_FORWARD_LINK}
  DIBUTTON_MECHA_BACK_LINK                = $290144E8; (* Fallback tilt toroso backward button *)
  {$EXTERNALSYM DIBUTTON_MECHA_BACK_LINK}
  DIBUTTON_MECHA_ROTATE_LEFT_LINK         = $290244E4; (* Fallback rotate toroso right button *)
  {$EXTERNALSYM DIBUTTON_MECHA_ROTATE_LEFT_LINK}
  DIBUTTON_MECHA_ROTATE_RIGHT_LINK        = $290244EC; (* Fallback rotate torso left button *)
  {$EXTERNALSYM DIBUTTON_MECHA_ROTATE_RIGHT_LINK}
  DIBUTTON_MECHA_FASTER_LINK              = $2903C4E0; (* Fallback increase engine speed *)
  {$EXTERNALSYM DIBUTTON_MECHA_FASTER_LINK}
  DIBUTTON_MECHA_SLOWER_LINK              = $2903C4E8; (* Fallback decrease engine speed *)
  {$EXTERNALSYM DIBUTTON_MECHA_SLOWER_LINK}
  DIBUTTON_MECHA_DEVICE                   = $290044FE; (* Show input device and controls *)
  {$EXTERNALSYM DIBUTTON_MECHA_DEVICE}
  DIBUTTON_MECHA_PAUSE                    = $290044FC; (* Start / Pause / Restart game *)
  {$EXTERNALSYM DIBUTTON_MECHA_PAUSE}

(*
 *  "ANY" semantics can be used as a last resort to get mappings for actions
 *  that match nothing in the chosen virtual genre.  These semantics will be
 *  mapped at a lower priority that virtual genre semantics.  Also, hardware
 *  vendors will not be able to provide sensible mappings for these unless
 *  they provide application specific mappings.
 *)
  DIAXIS_ANY_X_1                          = $FF00C201;
  {$EXTERNALSYM DIAXIS_ANY_X_1}
  DIAXIS_ANY_X_2                          = $FF00C202;
  {$EXTERNALSYM DIAXIS_ANY_X_2}
  DIAXIS_ANY_Y_1                          = $FF014201;
  {$EXTERNALSYM DIAXIS_ANY_Y_1}
  DIAXIS_ANY_Y_2                          = $FF014202;
  {$EXTERNALSYM DIAXIS_ANY_Y_2}
  DIAXIS_ANY_Z_1                          = $FF01C201;
  {$EXTERNALSYM DIAXIS_ANY_Z_1}
  DIAXIS_ANY_Z_2                          = $FF01C202;
  {$EXTERNALSYM DIAXIS_ANY_Z_2}
  DIAXIS_ANY_R_1                          = $FF024201;
  {$EXTERNALSYM DIAXIS_ANY_R_1}
  DIAXIS_ANY_R_2                          = $FF024202;
  {$EXTERNALSYM DIAXIS_ANY_R_2}
  DIAXIS_ANY_U_1                          = $FF02C201;
  {$EXTERNALSYM DIAXIS_ANY_U_1}
  DIAXIS_ANY_U_2                          = $FF02C202;
  {$EXTERNALSYM DIAXIS_ANY_U_2}
  DIAXIS_ANY_V_1                          = $FF034201;
  {$EXTERNALSYM DIAXIS_ANY_V_1}
  DIAXIS_ANY_V_2                          = $FF034202;
  {$EXTERNALSYM DIAXIS_ANY_V_2}
  DIAXIS_ANY_A_1                          = $FF03C201;
  {$EXTERNALSYM DIAXIS_ANY_A_1}
  DIAXIS_ANY_A_2                          = $FF03C202;
  {$EXTERNALSYM DIAXIS_ANY_A_2}
  DIAXIS_ANY_B_1                          = $FF044201;
  {$EXTERNALSYM DIAXIS_ANY_B_1}
  DIAXIS_ANY_B_2                          = $FF044202;
  {$EXTERNALSYM DIAXIS_ANY_B_2}
  DIAXIS_ANY_C_1                          = $FF04C201;
  {$EXTERNALSYM DIAXIS_ANY_C_1}
  DIAXIS_ANY_C_2                          = $FF04C202;
  {$EXTERNALSYM DIAXIS_ANY_C_2}
  DIAXIS_ANY_S_1                          = $FF054201;
  {$EXTERNALSYM DIAXIS_ANY_S_1}
  DIAXIS_ANY_S_2                          = $FF054202;
  {$EXTERNALSYM DIAXIS_ANY_S_2}

  DIAXIS_ANY_1                            = $FF004201;
  {$EXTERNALSYM DIAXIS_ANY_1}
  DIAXIS_ANY_2                            = $FF004202;
  {$EXTERNALSYM DIAXIS_ANY_2}
  DIAXIS_ANY_3                            = $FF004203;
  {$EXTERNALSYM DIAXIS_ANY_3}
  DIAXIS_ANY_4                            = $FF004204;
  {$EXTERNALSYM DIAXIS_ANY_4}

  DIPOV_ANY_1                             = $FF004601;
  {$EXTERNALSYM DIPOV_ANY_1}
  DIPOV_ANY_2                             = $FF004602;
  {$EXTERNALSYM DIPOV_ANY_2}
  DIPOV_ANY_3                             = $FF004603;
  {$EXTERNALSYM DIPOV_ANY_3}
  DIPOV_ANY_4                             = $FF004604;
  {$EXTERNALSYM DIPOV_ANY_4}

// #define DIBUTTON_ANY(instance)                  ( 0xFF004400 | instance )
function DIBUTTON_ANY(instance: Cardinal): Cardinal;
{$EXTERNALSYM DIBUTTON_ANY}



(****************************************************************************
 *
 *  Definitions for non-IDirectInput (VJoyD) features defined more recently
 *  than the current sdk files
 *
 ****************************************************************************)

//#ifdef _INC_MMSYSTEM
//#ifndef MMNOJOY

//#ifndef __VJOYDX_INCLUDED__
//#define __VJOYDX_INCLUDED__

const
(*
 * Flag to indicate that the dwReserved2 field of the JOYINFOEX structure
 * contains mini-driver specific data to be passed by VJoyD to the mini-
 * driver instead of doing a poll.
 *)
  JOY_PASSDRIVERDATA          = $10000000;
  {$EXTERNALSYM JOY_PASSDRIVERDATA}

(*
 * Informs the joystick driver that the configuration has been changed
 * and should be reloaded from the registery.
 * dwFlags is reserved and should be set to zero
 *)
const
  WinMMDll = 'WinMM.dll';
{$IFDEF DIRECTINPUT_DYNAMIC_LINK}
var
  joyConfigChanged: function(dwFlags: DWORD): MMRESULT; stdcall;
{$ELSE}
function joyConfigChanged(dwFlags: DWORD): MMRESULT; stdcall; external WinMMDll;
{$ENDIF}
{$EXTERNALSYM joyConfigChanged}

(*
 * Invoke the joystick control panel directly, using the passed window handle
 * as the parent of the dialog.  This API is only supported for compatibility
 * purposes; new applications should use the RunControlPanel method of a
 * device interface for a game controller.
 * The API is called by using the function pointer returned by
 * GetProcAddress( hCPL, TEXT("ShowJoyCPL") ) where hCPL is a HMODULE returned
 * by LoadLibrary( TEXT("joy.cpl") ).  The typedef is provided to allow
 * declaration and casting of an appropriately typed variable.
 *)
const
  JoyCPL = 'joy.cpl';
type
  TShowJoyCPL =  procedure(hWnd: HWND); stdcall;
{$IFDEF DIRECTINPUT_DYNAMIC_LINK}
var
  ShowJoyCPL: TShowJoyCPL;
{$ELSE}
procedure ShowJoyCPL(hWnd: HWND); stdcall; external JoyCPL;
{$ENDIF}
{$EXTERNALSYM ShowJoyCPL}

const
(*
 * Hardware Setting indicating that the device is a headtracker
 *)
  JOY_HWS_ISHEADTRACKER       = $02000000;
  {$EXTERNALSYM JOY_HWS_ISHEADTRACKER}

(*
 * Hardware Setting indicating that the VxD is used to replace
 * the standard analog polling
 *)
  JOY_HWS_ISGAMEPORTDRIVER    = $04000000;
  {$EXTERNALSYM JOY_HWS_ISGAMEPORTDRIVER}

(*
 * Hardware Setting indicating that the driver needs a standard
 * gameport in order to communicate with the device.
 *)
  JOY_HWS_ISANALOGPORTDRIVER  = $08000000;
  {$EXTERNALSYM JOY_HWS_ISANALOGPORTDRIVER}

(*
 * Hardware Setting indicating that VJoyD should not load this
 * driver, it will be loaded externally and will register with
 * VJoyD of it's own accord.
 *)
  JOY_HWS_AUTOLOAD            = $10000000;
  {$EXTERNALSYM JOY_HWS_AUTOLOAD}

(*
 * Hardware Setting indicating that the driver acquires any
 * resources needed without needing a devnode through VJoyD.
 *)
  JOY_HWS_NODEVNODE           = $20000000;
  {$EXTERNALSYM JOY_HWS_NODEVNODE}


(*
 * Hardware Setting indicating that the device is a gameport bus
 *)
  JOY_HWS_ISGAMEPORTBUS       = $80000000;
  {$EXTERNALSYM JOY_HWS_ISGAMEPORTBUS}
  JOY_HWS_GAMEPORTBUSBUSY     = $00000001;
  {$EXTERNALSYM JOY_HWS_GAMEPORTBUSBUSY}

(*
 * Usage Setting indicating that the settings are volatile and
 * should be removed if still present on a reboot.
 *)
  JOY_US_VOLATILE             = $00000008;
  {$EXTERNALSYM JOY_US_VOLATILE}

//#endif  (* __VJOYDX_INCLUDED__ *)

//#endif  (* not MMNOJOY *)
//#endif  (* _INC_MMSYSTEM *)

(****************************************************************************
 *
 *  Definitions for non-IDirectInput (VJoyD) features defined more recently
 *  than the current ddk files
 *
 ****************************************************************************)

//#ifdef _INC_MMDDK
//#ifndef MMNOJOYDEV

//#ifndef __VJOYDXD_INCLUDED__
//#define __VJOYDXD_INCLUDED__

const
(*
 * Poll type in which the do_other field of the JOYOEMPOLLDATA
 * structure contains mini-driver specific data passed from an app.
 *)
  JOY_OEMPOLL_PASSDRIVERDATA  = 7;
  {$EXTERNALSYM JOY_OEMPOLL_PASSDRIVERDATA}

//#endif  (* __VJOYDXD_INCLUDED__ *)

//#endif  (* not MMNOJOYDEV *)
//#endif  (* _INC_MMDDK *)
(*==========================================================================;
 *
 *  Copyright (C) 1995-2000 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       d3d8types.h
 *  Content:    Direct3D capabilities include file
 *
 ***************************************************************************)








(* Values for clip fields.*)

// Max number of user clipping planes; supported in D3D.
const
  D3DMAXUSERCLIPPLANES = 32;

// These bits could be ORed together to use with D3DRS_CLIPPLANEENABLE
  D3DCLIPPLANE0 = 1;   // (1 << 0)
  D3DCLIPPLANE1 = 2;   // (1 << 1)
  D3DCLIPPLANE2 = 4;   // (1 << 2)
  D3DCLIPPLANE3 = 8;   // (1 << 3)
  D3DCLIPPLANE4 = 16;  // (1 << 4)
  D3DCLIPPLANE5 = 32;  // (1 << 5)

// The following bits are used in the ClipUnion and ClipIntersection
// members of the D3DCLIPSTATUS8
  D3DCS_LEFT        = $00000001;
  D3DCS_RIGHT       = $00000002;
  D3DCS_TOP         = $00000004;
  D3DCS_BOTTOM      = $00000008;
  D3DCS_FRONT       = $00000010;
  D3DCS_BACK        = $00000020;
  D3DCS_PLANE0      = $00000040;
  D3DCS_PLANE1      = $00000080;
  D3DCS_PLANE2      = $00000100;
  D3DCS_PLANE3      = $00000200;
  D3DCS_PLANE4      = $00000400;
  D3DCS_PLANE5      = $00000800;

  D3DCS_ALL = (D3DCS_LEFT or D3DCS_RIGHT or D3DCS_TOP or
              D3DCS_BOTTOM or D3DCS_FRONT or D3DCS_BACK or
              D3DCS_PLANE0 or D3DCS_PLANE1 or D3DCS_PLANE2 or
              D3DCS_PLANE3 or D3DCS_PLANE4 or D3DCS_PLANE5);


type
  PD3DClipStatus9 = ^TD3DClipStatus9;
  _D3DCLIPSTATUS9 = packed record
    ClipUnion: DWord;
    ClipIntersection: DWord;
  end {_D3DCLIPSTATUS9};
  {$EXTERNALSYM _D3DCLIPSTATUS9}
  D3DCLIPSTATUS9 = _D3DCLIPSTATUS9;
  {$EXTERNALSYM D3DCLIPSTATUS9}
  TD3DClipStatus9 = _D3DCLIPSTATUS9;

  PD3DMaterial9 = ^TD3DMaterial9;
  _D3DMATERIAL9 = packed record
    Diffuse: TD3DColorValue;   { Diffuse color RGBA }
    Ambient: TD3DColorValue;   { Ambient color RGB }
    Specular: TD3DColorValue;  { Specular 'shininess' }
    Emissive: TD3DColorValue;  { Emissive color RGB }
    Power: Single;             { Sharpness if specular highlight }
  end {_D3DMATERIAL9};
  {$EXTERNALSYM _D3DMATERIAL9}
  D3DMATERIAL9 = _D3DMATERIAL9;
  {$EXTERNALSYM D3DMATERIAL9}
  TD3DMaterial9 = _D3DMATERIAL9;


//{$IFDEF D6UP}({$ELSE}LongWord;{$ENDIF}



type TD3DLightType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DLIGHT_POINT          = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DLIGHT_SPOT           = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DLIGHT_DIRECTIONAL    = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DLIGHT_FORCE_DWORD    = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type
  PD3DLight9 = ^TD3DLight9;
  _D3DLIGHT9 = packed record
    _Type: TD3DLightType;       { Type of light source }
    Diffuse: TD3DColorValue;    { Diffuse color of light }
    Specular: TD3DColorValue;   { Specular color of light }
    Ambient: TD3DColorValue;    { Ambient color of light }
    Position: TD3DVector;       { Position in world space }
    Direction: TD3DVector;      { Direction in world space }
    Range: Single;              { Cutoff range }
    Falloff: Single;            { Falloff }
    Attenuation0: Single;       { Constant attenuation }
    Attenuation1: Single;       { Linear attenuation }
    Attenuation2: Single;       { Quadratic attenuation }
    Theta: Single;              { Inner angle of spotlight cone }
    Phi: Single;                { Outer angle of spotlight cone }
  end {_D3DLIGHT9};
  {$EXTERNALSYM _D3DLIGHT9}
  D3DLIGHT9 = _D3DLIGHT9;
  {$EXTERNALSYM D3DLIGHT9}
  TD3DLight9 = _D3DLIGHT9;

(* Options for clearing *)
const
  D3DCLEAR_TARGET  = $00000001;  (* Clear target surface *)
  D3DCLEAR_ZBUFFER = $00000002;  (* Clear target z buffer *)
  D3DCLEAR_STENCIL = $00000004;  (* Clear stencil planes *)

(* The following defines the rendering states *)

type TD3DShadeMode = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DSHADE_FLAT               = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSHADE_GOURAUD            = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSHADE_PHONG              = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSHADE_FORCE_DWORD        = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type TD3DFillMode = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DFILL_POINT               = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFILL_WIREFRAME           = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFILL_SOLID               = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFILL_FORCE_DWORD         = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type
  PD3DLinePattern = ^TD3DLinePattern;
  TD3DLinePattern = packed record
    wRepeatFactor : Word;
    wLinePattern  : Word;
  end;

type TD3DBlend = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DBLEND_ZERO               = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_ONE                = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_SRCCOLOR           = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_INVSRCCOLOR        = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_SRCALPHA           = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_INVSRCALPHA        = 6{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_DESTALPHA          = 7{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_INVDESTALPHA       = 8{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_DESTCOLOR          = 9{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_INVDESTCOLOR       = 10{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_SRCALPHASAT        = 11{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_BOTHSRCALPHA       = 12{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_BOTHINVSRCALPHA    = 13{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLEND_FORCE_DWORD        = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type TD3DBLendOp = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DBLENDOP_ADD              = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLENDOP_SUBTRACT         = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLENDOP_REVSUBTRACT      = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLENDOP_MIN              = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLENDOP_MAX              = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBLENDOP_FORCE_DWORD      = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type TD3DTextureAddress = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DTADDRESS_WRAP            = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTADDRESS_MIRROR          = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTADDRESS_CLAMP           = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTADDRESS_BORDER          = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTADDRESS_MIRRORONCE      = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTADDRESS_FORCE_DWORD     = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type TD3DCull = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DCULL_NONE                = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCULL_CW                  = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCULL_CCW                 = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCULL_FORCE_DWORD         = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type TD3DCmpFunc = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DCMP_NEVER                = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCMP_LESS                 = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCMP_EQUAL                = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCMP_LESSEQUAL            = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCMP_GREATER              = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCMP_NOTEQUAL             = 6{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCMP_GREATEREQUAL         = 7{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCMP_ALWAYS               = 8{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCMP_FORCE_DWORD          = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type TD3DStencilOp = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DSTENCILOP_KEEP           = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSTENCILOP_ZERO           = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSTENCILOP_REPLACE        = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSTENCILOP_INCRSAT        = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSTENCILOP_DECRSAT        = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSTENCILOP_INVERT         = 6{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSTENCILOP_INCR           = 7{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSTENCILOP_DECR           = 8{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSTENCILOP_FORCE_DWORD    = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type TD3DFogMode = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DFOG_NONE                 = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFOG_EXP                  = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFOG_EXP2                 = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFOG_LINEAR               = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFOG_FORCE_DWORD          = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type TD3DZBufferType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DZB_FALSE                 = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DZB_TRUE                  = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // Z buffering
       D3DZB_USEW                  = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // W buffering
       D3DZB_FORCE_DWORD           = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

// Primitives supported by draw-primitive API
type TD3DPrimitiveType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DPT_POINTLIST             = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DPT_LINELIST              = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DPT_LINESTRIP             = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DPT_TRIANGLELIST          = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DPT_TRIANGLESTRIP         = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DPT_TRIANGLEFAN           = 6{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DPT_FORCE_DWORD           = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

type TD3DTransformStateType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DTS_VIEW          = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTS_PROJECTION    = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTS_TEXTURE0      = 16{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTS_TEXTURE1      = 17{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTS_TEXTURE2      = 18{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTS_TEXTURE3      = 19{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTS_TEXTURE4      = 20{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTS_TEXTURE5      = 21{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTS_TEXTURE6      = 22{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DTS_TEXTURE7      = 23{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DTS_WORLD         = 0 + 256{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // D3DTS_WORLDMATRIX(0)
       D3DTS_WORLD1        = 1 + 256{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // D3DTS_WORLDMATRIX(1)
       D3DTS_WORLD2        = 2 + 256{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // D3DTS_WORLDMATRIX(2)
       D3DTS_WORLD3        = 3 + 256{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // D3DTS_WORLDMATRIX(3)

       D3DTS_FORCE_DWORD   = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

function D3DTS_WORLDMATRIX(index : LongWord) : TD3DTransformStateType; // (D3DTRANSFORMSTATETYPE)(index + 256)

type TD3DRenderStateType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DRS_ZENABLE                   = 7{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    (* D3DZBUFFERTYPE (or TRUE/FALSE for legacy) *)
       D3DRS_FILLMODE                  = 8{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    (* D3DFILL_MODE        *)
       D3DRS_SHADEMODE                 = 9{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    (* D3DSHADEMODE *)
       D3DRS_LINEPATTERN               = 10{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DLINEPATTERN *)
       D3DRS_ZWRITEENABLE              = 14{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* TRUE to enable z writes *)
       D3DRS_ALPHATESTENABLE           = 15{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* TRUE to enable alpha tests *)
       D3DRS_LASTPIXEL                 = 16{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* TRUE for last-pixel on lines *)
       D3DRS_SRCBLEND                  = 19{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DBLEND *)
       D3DRS_DESTBLEND                 = 20{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DBLEND *)
       D3DRS_CULLMODE                  = 22{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DCULL *)
       D3DRS_ZFUNC                     = 23{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DCMPFUNC *)
       D3DRS_ALPHAREF                  = 24{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DFIXED *)
       D3DRS_ALPHAFUNC                 = 25{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DCMPFUNC *)
       D3DRS_DITHERENABLE              = 26{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* TRUE to enable dithering *)
       D3DRS_ALPHABLENDENABLE          = 27{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* TRUE to enable alpha blending *)
       D3DRS_FOGENABLE                 = 28{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* TRUE to enable fog blending *)
       D3DRS_SPECULARENABLE            = 29{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* TRUE to enable specular *)
       D3DRS_ZVISIBLE                  = 30{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* TRUE to enable z checking *)
       D3DRS_FOGCOLOR                  = 34{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DCOLOR *)
       D3DRS_FOGTABLEMODE              = 35{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DFOGMODE *)
       D3DRS_FOGSTART                  = 36{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* Fog start (for both vertex and pixel fog) *)
       D3DRS_FOGEND                    = 37{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* Fog end      *)
       D3DRS_FOGDENSITY                = 38{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* Fog density  *)
       D3DRS_EDGEANTIALIAS             = 40{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* TRUE to enable edge antialiasing *)
       D3DRS_ZBIAS                     = 47{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* LONG Z bias *)
       D3DRS_RANGEFOGENABLE            = 48{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* Enables range-based fog *)
       D3DRS_STENCILENABLE             = 52{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* BOOL enable/disable stenciling *)
       D3DRS_STENCILFAIL               = 53{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DSTENCILOP to do if stencil test fails *)
       D3DRS_STENCILZFAIL              = 54{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DSTENCILOP to do if stencil test passes and Z test fails *)
       D3DRS_STENCILPASS               = 55{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DSTENCILOP to do if both stencil and Z tests pass *)
       D3DRS_STENCILFUNC               = 56{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DCMPFUNC fn.  Stencil Test passes if ((ref & mask) stencilfn (stencil & mask)) is true *)
       D3DRS_STENCILREF                = 57{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* Reference value used in stencil test *)
       D3DRS_STENCILMASK               = 58{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* Mask value used in stencil test *)
       D3DRS_STENCILWRITEMASK          = 59{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* Write mask applied to values written to stencil buffer *)
       D3DRS_TEXTUREFACTOR             = 60{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   (* D3DCOLOR used for multi-texture blend *)
       D3DRS_WRAP0                     = 128{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* wrap for 1st texture coord. set *)
       D3DRS_WRAP1                     = 129{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* wrap for 2nd texture coord. set *)
       D3DRS_WRAP2                     = 130{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* wrap for 3rd texture coord. set *)
       D3DRS_WRAP3                     = 131{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* wrap for 4th texture coord. set *)
       D3DRS_WRAP4                     = 132{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* wrap for 5th texture coord. set *)
       D3DRS_WRAP5                     = 133{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* wrap for 6th texture coord. set *)
       D3DRS_WRAP6                     = 134{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* wrap for 7th texture coord. set *)
       D3DRS_WRAP7                     = 135{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* wrap for 8th texture coord. set *)
       D3DRS_CLIPPING                  = 136{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_LIGHTING                  = 137{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_AMBIENT                   = 139{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_FOGVERTEXMODE             = 140{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_COLORVERTEX               = 141{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_LOCALVIEWER               = 142{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_NORMALIZENORMALS          = 143{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_DIFFUSEMATERIALSOURCE     = 145{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_SPECULARMATERIALSOURCE    = 146{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_AMBIENTMATERIALSOURCE     = 147{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_EMISSIVEMATERIALSOURCE    = 148{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_VERTEXBLEND               = 151{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_CLIPPLANEENABLE           = 152{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_SOFTWAREVERTEXPROCESSING  = 153{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_POINTSIZE                 = 154{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* float point size *)
       D3DRS_POINTSIZE_MIN             = 155{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* float point size min threshold *)
       D3DRS_POINTSPRITEENABLE         = 156{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* BOOL point texture coord control *)
       D3DRS_POINTSCALEENABLE          = 157{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* BOOL point size scale enable *)
       D3DRS_POINTSCALE_A              = 158{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* float point attenuation A value *)
       D3DRS_POINTSCALE_B              = 159{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* float point attenuation B value *)
       D3DRS_POINTSCALE_C              = 160{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* float point attenuation C value *)
       D3DRS_MULTISAMPLEANTIALIAS      = 161{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // BOOL - set to do FSAA with multisample buffer *)
       D3DRS_MULTISAMPLEMASK           = 162{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // DWORD - per-sample enable/disable
       D3DRS_PATCHEDGESTYLE            = 163{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // Sets whether patch edges will use float style tessellation
       D3DRS_PATCHSEGMENTS             = 164{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // Number of segments per edge when drawing patches
       D3DRS_DEBUGMONITORTOKEN         = 165{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // DEBUG ONLY - token to debug monitor
       D3DRS_POINTSIZE_MAX             = 166{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  (* float point size max threshold *)
       D3DRS_INDEXEDVERTEXBLENDENABLE  = 167{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRS_COLORWRITEENABLE          = 168{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // per-channel write enable
       D3DRS_TWEENFACTOR               = 170{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // float tween factor
       D3DRS_BLENDOP                   = 171{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // D3DBLENDOP setting
{$IFNDEF DX8}
       D3DRS_POSITIONORDER             = 172{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // NPatch position interpolation order. D3DORDER_LINEAR or D3DORDER_CUBIC (default)
       D3DRS_NORMALORDER               = 173{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // NPatch normal interpolation order. D3DORDER_LINEAR (default) or D3DORDER_QUADRATIC
{$ENDIF}
       D3DRS_FORCE_DWORD               = $7fffffff{$IFNDEF NOENUMS}){$ENDIF}; (* force 32-bit size enum *)

// Values for material source
type TD3DMaterialColorSource = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DMCS_MATERIAL         = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // Color from material is used
       D3DMCS_COLOR1           = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // Diffuse vertex color is used
       D3DMCS_COLOR2           = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // Specular vertex color is used
       D3DMCS_FORCE_DWORD      = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};   // force 32-bit size enum


const
// Bias to apply to the texture coordinate set to apply a wrap to.
  D3DRENDERSTATE_WRAPBIAS  = 128;

(* Flags to construct the WRAP render states *)
  D3DWRAP_U = $00000001;
  D3DWRAP_V = $00000002;
  D3DWRAP_W = $00000004;

(* Flags to construct the WRAP render states for 1D thru 4D texture coordinates *)
  D3DWRAPCOORD_0  = $00000001;    // same as D3DWRAP_U
  D3DWRAPCOORD_1  = $00000002;    // same as D3DWRAP_V
  D3DWRAPCOORD_2  = $00000004;    // same as D3DWRAP_W
  D3DWRAPCOORD_3  = $00000008;

(* Flags to construct D3DRS_COLORWRITEENABLE *)
  D3DCOLORWRITEENABLE_RED   = 1;  // (1L<<0)
  D3DCOLORWRITEENABLE_GREEN = 2;  // (1L<<1)
  D3DCOLORWRITEENABLE_BLUE  = 4;  // (1L<<2)
  D3DCOLORWRITEENABLE_ALPHA = 8;  // (1L<<3)

(*
 * State enumerants for per-stage texture processing.
 *)
type TD3DTextureStageStateType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DTSS_COLOROP               =  1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTEXTUREOP - per-stage blending controls for color channels *)
       D3DTSS_COLORARG1             =  2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTA_* (texture arg) *)
       D3DTSS_COLORARG2             =  3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTA_* (texture arg) *)
       D3DTSS_ALPHAOP               =  4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTEXTUREOP - per-stage blending controls for alpha channel *)
       D3DTSS_ALPHAARG1             =  5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTA_* (texture arg) *)
       D3DTSS_ALPHAARG2             =  6{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTA_* (texture arg) *)
       D3DTSS_BUMPENVMAT00          =  7{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* float (bump mapping matrix) *)
       D3DTSS_BUMPENVMAT01          =  8{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* float (bump mapping matrix) *)
       D3DTSS_BUMPENVMAT10          =  9{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* float (bump mapping matrix) *)
       D3DTSS_BUMPENVMAT11          = 10{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* float (bump mapping matrix) *)
       D3DTSS_TEXCOORDINDEX         = 11{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* identifies which set of texture coordinates index this texture *)
       D3DTSS_ADDRESSU              = 13{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTEXTUREADDRESS for U coordinate *)
       D3DTSS_ADDRESSV              = 14{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTEXTUREADDRESS for V coordinate *)
       D3DTSS_BORDERCOLOR           = 15{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DCOLOR *)
       D3DTSS_MAGFILTER             = 16{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTEXTUREFILTER filter to use for magnification *)
       D3DTSS_MINFILTER             = 17{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTEXTUREFILTER filter to use for minification *)
       D3DTSS_MIPFILTER             = 18{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTEXTUREFILTER filter to use between mipmaps during minification *)
       D3DTSS_MIPMAPLODBIAS         = 19{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* float Mipmap LOD bias *)
       D3DTSS_MAXMIPLEVEL           = 20{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* DWORD 0..(n-1) LOD index of largest map to use (0 == largest) *)
       D3DTSS_MAXANISOTROPY         = 21{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* DWORD maximum anisotropy *)
       D3DTSS_BUMPENVLSCALE         = 22{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* float scale for bump map luminance *)
       D3DTSS_BUMPENVLOFFSET        = 23{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* float offset for bump map luminance *)
       D3DTSS_TEXTURETRANSFORMFLAGS = 24{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTEXTURETRANSFORMFLAGS controls texture transform *)
       D3DTSS_ADDRESSW              = 25{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTEXTUREADDRESS for W coordinate *)
       D3DTSS_COLORARG0             = 26{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTA_* third arg for triadic ops *)
       D3DTSS_ALPHAARG0             = 27{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTA_* third arg for triadic ops *)
       D3DTSS_RESULTARG             = 28{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     (* D3DTA_* arg for result (CURRENT or TEMP) *)
       D3DTSS_FORCE_DWORD           = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};     (* force 32-bit size enum *)

const
// Values; used with D3DTSS_TEXCOORDINDEX; to specify that the vertex data(position
// and normal in the camera space) should be taken as texture coordinates
// Low 16 bits are used to specify texture coordinate index; to take the WRAP mode from
  D3DTSS_TCI_PASSTHRU                    = $00000000;
  D3DTSS_TCI_CAMERASPACENORMAL           = $00010000;
  D3DTSS_TCI_CAMERASPACEPOSITION         = $00020000;
  D3DTSS_TCI_CAMERASPACEREFLECTIONVECTOR = $00030000;

(* Enumerations for COLOROP and ALPHAOP texture blending operations set in
 * texture processing stage controls in D3DTSS. *)

type TD3DTextureOp = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}

       // Control
       D3DTOP_DISABLE                   = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   // disables stage
       D3DTOP_SELECTARG1                = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   // the default
       D3DTOP_SELECTARG2                = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       // Modulate
       D3DTOP_MODULATE                  = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   // multiply args together
       D3DTOP_MODULATE2X                = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   // multiply and  1 bit
       D3DTOP_MODULATE4X                = 6{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   // multiply and  2 bits

       // Add
       D3DTOP_ADD                       = 7{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   // add arguments together
       D3DTOP_ADDSIGNED                 = 8{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   // add with -0.5 bias
       D3DTOP_ADDSIGNED2X               = 9{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}   // as above but left  1 bit
       D3DTOP_SUBTRACT                  = 10{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // Arg1 - Arg2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} with no saturation
       D3DTOP_ADDSMOOTH                 = 11{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // add 2 args{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} subtract product
                                              // Arg1 + Arg2 - Arg1*Arg2
                                              // = Arg1 + (1-Arg1)*Arg2

       // Linear alpha blend: Arg1*(Alpha) + Arg2*(1-Alpha)
       D3DTOP_BLENDDIFFUSEALPHA         = 12{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // iterated alpha
       D3DTOP_BLENDTEXTUREALPHA         = 13{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // texture alpha
       D3DTOP_BLENDFACTORALPHA          = 14{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // alpha from D3DRS_TEXTUREFACTOR

       // Linear alpha blend with pre-multiplied arg1 input: Arg1 + Arg2*(1-Alpha)
       D3DTOP_BLENDTEXTUREALPHAPM       = 15{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // texture alpha
       D3DTOP_BLENDCURRENTALPHA         = 16{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // by alpha of current color

       // Specular mapping
       D3DTOP_PREMODULATE               = 17{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // modulate with next texture before use
       D3DTOP_MODULATEALPHA_ADDCOLOR    = 18{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // Arg1.RGB + Arg1.A*Arg2.RGB
                                              // COLOROP only
       D3DTOP_MODULATECOLOR_ADDALPHA    = 19{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // Arg1.RGB*Arg2.RGB + Arg1.A
                                              // COLOROP only
       D3DTOP_MODULATEINVALPHA_ADDCOLOR = 20{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // (1-Arg1.A)*Arg2.RGB + Arg1.RGB
                                              // COLOROP only
       D3DTOP_MODULATEINVCOLOR_ADDALPHA = 21{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // (1-Arg1.RGB)*Arg2.RGB + Arg1.A
                                              // COLOROP only

       // Bump mapping
       D3DTOP_BUMPENVMAP                = 22{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // per pixel env map perturbation
       D3DTOP_BUMPENVMAPLUMINANCE       = 23{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // with luminance channel

       // This can do either diffuse or specular bump mapping with correct input.
       // Performs the function (Arg1.R*Arg2.R + Arg1.G*Arg2.G + Arg1.B*Arg2.B)
       // where each component has been scaled and offset to make it signed.
       // The result is replicated into all four (including alpha) channels.
       // This is a valid COLOROP only.
       D3DTOP_DOTPRODUCT3               = 24{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       // Triadic ops
       D3DTOP_MULTIPLYADD               = 25{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // Arg0 + Arg1*Arg2
       D3DTOP_LERP                      = 26{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // (Arg0)*Arg1 + (1-Arg0)*Arg2

       D3DTOP_FORCE_DWORD               = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

const
(* Values for COLORARG0;1;2; ALPHAARG0;1;2; and RESULTARG texture blending
 * operations set in texture processing stage controls in D3DRENDERSTATE. *)
  D3DTA_SELECTMASK        = $0000000f;  // mask for arg selector
  D3DTA_DIFFUSE           = $00000000;  // select diffuse color (read only)
  D3DTA_CURRENT           = $00000001;  // select stage destination register (read/write)
  D3DTA_TEXTURE           = $00000002;  // select texture color (read only)
  D3DTA_TFACTOR           = $00000003;  // select D3DRS_TEXTUREFACTOR (read only)
  D3DTA_SPECULAR          = $00000004;  // select specular color (read only)
  D3DTA_TEMP              = $00000005;  // select temporary register color (read/write)
  D3DTA_COMPLEMENT        = $00000010;  // take 1.0 - x (read modifier)
  D3DTA_ALPHAREPLICATE    = $00000020;  // replicate alpha to color components (read modifier)


// Values for D3DTSS_***FILTER texture stage states

type TD3DTextureFilterType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DTEXF_NONE            = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // filtering disabled (valid for mip filter only)
       D3DTEXF_POINT           = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // nearest
       D3DTEXF_LINEAR          = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // linear interpolation
       D3DTEXF_ANISOTROPIC     = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // anisotropic
       D3DTEXF_FLATCUBIC       = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // cubic
       D3DTEXF_GAUSSIANCUBIC   = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // different cubic kernel
       D3DTEXF_FORCE_DWORD     = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};   // force 32-bit size enum

const

(* Bits for Flags in ProcessVertices call *)
  D3DPV_DONOTCOPYDATA  = 1 shl 0;

//-------------------------------------------------------------------

// Flexible vertex format bits
//
  D3DFVF_RESERVED0        = $001;
  D3DFVF_POSITION_MASK    = $00E;
  D3DFVF_XYZ              = $002;
  D3DFVF_XYZRHW           = $004;
  D3DFVF_XYZB1            = $006;
  D3DFVF_XYZB2            = $008;
  D3DFVF_XYZB3            = $00a;
  D3DFVF_XYZB4            = $00c;
  D3DFVF_XYZB5            = $00e;

  D3DFVF_NORMAL           = $010;
  D3DFVF_PSIZE            = $020;
  D3DFVF_DIFFUSE          = $040;
  D3DFVF_SPECULAR         = $080;

  D3DFVF_TEXCOUNT_MASK    = $f00;
  D3DFVF_TEXCOUNT_SHIFT   = 8;
  D3DFVF_TEX0             = $000;
  D3DFVF_TEX1             = $100;
  D3DFVF_TEX2             = $200;
  D3DFVF_TEX3             = $300;
  D3DFVF_TEX4             = $400;
  D3DFVF_TEX5             = $500;
  D3DFVF_TEX6             = $600;
  D3DFVF_TEX7             = $700;
  D3DFVF_TEX8             = $800;

  D3DFVF_LASTBETA_UBYTE4  = $1000;

  D3DFVF_RESERVED2        = $E000;  // 4 reserved bits

//---------------------------------------------------------------------
// Vertex Shaders
//

(*

Vertex Shader Declaration

The declaration portion of a vertex shader defines the static external
interface of the shader.  The information in the declaration includes:

- Assignments of vertex shader input registers to data streams.  These
assignments bind a specific vertex register to a single component within a
vertex stream.  A vertex stream element is identified by a byte offset
within the stream and a type.  The type specifies the arithmetic data type
plus the dimensionality (1; 2; 3; or 4 values).  Stream data which is
less than 4 values are always expanded out to 4 values with zero or more
0.F values and one 1.F value.

- Assignment of vertex shader input registers to implicit data from the
primitive tessellator.  This controls the loading of vertex data which is
not loaded from a stream; but rather is generated during primitive
tessellation prior to the vertex shader.

- Loading data into the constant memory at the time a shader is set as the
current shader.  Each token specifies values for one or more contiguous 4
DWORD constant registers.  This allows the shader to update an arbitrary
subset of the constant memory; overwriting the device state (which
contains the current values of the constant memory).  Note that these
values can be subsequently overwritten (between DrawPrimitive calls)
during the time a shader is bound to a device via the
SetVertexShaderConstant method.


Declaration arrays are single-dimensional arrays of DWORDs composed of
multiple tokens each of which is one or more DWORDs.  The single-DWORD
token value = $FFFFFFFF is a special token used to indicate the end of the
declaration array.  The single DWORD token value = $00000000 is a NOP token
with is ignored during the declaration parsing.  Note that = $00000000 is a
valid value for DWORDs following the first DWORD for multiple word tokens.

[31:29] TokenType
    = $0 - NOP (requires all DWORD bits to be zero)
    = $1 - stream selector
    = $2 - stream data definition (map to vertex input memory)
    = $3 - vertex input memory from tessellator
    = $4 - constant memory from shader
    = $5 - extension
    = $6 - reserved
    = $7 - end-of-array (requires all DWORD bits to be 1)

NOP Token (single DWORD token)
    [31:29] = $0
    [28:00] = $0

Stream Selector (single DWORD token)
    [31:29] = $1
    [28]    indicates whether this is a tessellator stream
    [27:04] = $0
    [03:00] stream selector (0..15)

Stream Data Definition (single DWORD token)
    Vertex Input Register Load
      [31:29] = $2
      [28]    = $0
      [27:20] = $0
      [19:16] type (dimensionality and data type)
      [15:04] = $0
      [03:00] vertex register address (0..15)
    Data Skip (no register load)
      [31:29] = $2
      [28]    = $1
      [27:20] = $0
      [19:16] count of DWORDS to skip over (0..15)
      [15:00] = $0
    Vertex Input Memory from Tessellator Data (single DWORD token)
      [31:29] = $3
      [28]    indicates whether data is normals or u/v
      [27:24] = $0
      [23:20] vertex register address (0..15)
      [19:16] type (dimensionality)
      [15:04] = $0
      [03:00] vertex register address (0..15)

Constant Memory from Shader (multiple DWORD token)
    [31:29] = $4
    [28:25] count of 4*DWORD constants to load (0..15)
    [24:07] = $0
    [06:00] constant memory address (0..95)

Extension Token (single or multiple DWORD token)
    [31:29] = $5
    [28:24] count of additional DWORDs in token (0..31)
    [23:00] extension-specific information

End-of-array token (single DWORD token)
    [31:29] = $7
    [28:00] = $1fffffff

The stream selector token must be immediately followed by a contiguous set of stream data definition tokens.  This token sequence fully defines that stream; including the set of elements within the stream; the order in which the elements appear; the type of each element; and the vertex register into which to load an element.
Streams are allowed to include data which is not loaded into a vertex register; thus allowing data which is not used for this shader to exist in the vertex stream.  This skipped data is defined only by a count of DWORDs to skip over; since the type information is irrelevant.
The token sequence:
Stream Select: stream=0
Stream Data Definition (Load): type=FLOAT3; register=3
Stream Data Definition (Load): type=FLOAT3; register=4
Stream Data Definition (Skip): count=2
Stream Data Definition (Load): type=FLOAT2; register=7

defines stream zero to consist of 4 elements; 3 of which are loaded into registers and the fourth skipped over.  Register 3 is loaded with the first three DWORDs in each vertex interpreted as FLOAT data.  Register 4 is loaded with the 4th; 5th; and 6th DWORDs interpreted as FLOAT data.  The next two DWORDs (7th and 8th) are skipped over and not loaded into any vertex input register.   Register 7 is loaded with the 9th and 10th DWORDS interpreted as FLOAT data.
Placing of tokens other than NOPs between the Stream Selector and Stream Data Definition tokens is disallowed.

*)
type TD3DVSDTokenType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DVSD_TOKEN_NOP         = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // NOP or extension
       D3DVSD_TOKEN_STREAM      = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // stream selector
       D3DVSD_TOKEN_STREAMDATA  = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // stream data definition (map to vertex input memory)
       D3DVSD_TOKEN_TESSELLATOR = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // vertex input memory from tessellator
       D3DVSD_TOKEN_CONSTMEM    = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // constant memory from shader
       D3DVSD_TOKEN_EXT         = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // extension
       D3DVSD_TOKEN_END         = 7{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // end-of-array (requires all DWORD bits to be 1)

       D3DVSD_TOKENTYPESHIFT    = 29{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_TOKENTYPEMASK     = 7 shl D3DVSD_TOKENTYPESHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_STREAMNUMBERSHIFT = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_STREAMNUMBERMASK  = $F shl D3DVSD_STREAMNUMBERSHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_DATALOADTYPESHIFT = 28{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_DATALOADTYPEMASK  = $1 shl D3DVSD_DATALOADTYPESHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_DATATYPESHIFT     = 16{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_DATATYPEMASK      = $F shl D3DVSD_DATATYPESHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_SKIPCOUNTSHIFT    = 16{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_SKIPCOUNTMASK     = $F shl D3DVSD_SKIPCOUNTSHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_VERTEXREGSHIFT    = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_VERTEXREGMASK     = $1F shl D3DVSD_VERTEXREGSHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_VERTEXREGINSHIFT  = 20{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_VERTEXREGINMASK   = $F shl D3DVSD_VERTEXREGINSHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_CONSTCOUNTSHIFT   = 25{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_CONSTCOUNTMASK    = $F shl D3DVSD_CONSTCOUNTSHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_CONSTADDRESSSHIFT = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_CONSTADDRESSMASK  = $7F shl D3DVSD_CONSTADDRESSSHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_CONSTRSSHIFT      = 16{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_CONSTRSMASK       = $1FFF shl D3DVSD_CONSTRSSHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_EXTCOUNTSHIFT     = 24{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_EXTCOUNTMASK      = $1F shl D3DVSD_EXTCOUNTSHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_EXTINFOSHIFT      = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_EXTINFOMASK       = $FFFFFF shl D3DVSD_EXTINFOSHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       // Set tessellator stream
       D3DVSD_STREAMTESSSHIFT   = 28{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DVSD_STREAMTESSMASK    = 1 shl D3DVSD_STREAMTESSSHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_STREAM_TESS       = ((D3DVSD_TOKEN_STREAM shl D3DVSD_TOKENTYPESHIFT) and D3DVSD_TOKENTYPEMASK) or D3DVSD_STREAMTESSMASK{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DVSD_FORCE_DWORD       = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};   // force 32-bit size enum

  function D3DVSD_MAKETOKENTYPE(tokenType : TD3DVSDTokenType) : TD3DVSDTokenType;

// macros for generation of CreateVertexShader Declaration token array

// Set current stream
// _StreamNumber [0..(MaxStreams-1)] stream to get data from
//
  function D3DVSD_STREAM(_StreamNumber : LongWord) : TD3DVSDTokenType;

type TD3DVSD_TokenType = TD3DVSDTokenType;

// bind single vertex register to vertex element from vertex stream
//
// _VertexRegister [0..15] address of the vertex register
// _Type [D3DVSDT_*] dimensionality and arithmetic data type

  function D3DVSD_REG( _VertexRegister, _Type : LongWord) : TD3DVSDTokenType;

// Skip _DWORDCount DWORDs in vertex
//
  function D3DVSD_SKIP(_DWORDCount : LongWord) : TD3DVSDTokenType;

// load data into vertex shader constant memory
//
// _ConstantAddress [0..95] - address of constant array to begin filling data
// _Count [0..15] - number of constant vectors to load (4 DWORDs each)
// followed by 4*_Count DWORDS of data
//
  function D3DVSD_CONST( _ConstantAddress, _Count : LongWord) : TD3DVSDTokenType;

// enable tessellator generated normals
//
// _VertexRegisterIn  [0..15] address of vertex register whose input stream
//                            will be used in normal computation
// _VertexRegisterOut [0..15] address of vertex register to output the normal to
//
  function D3DVSD_TESSNORMAL( _VertexRegisterIn, _VertexRegisterOut : LongWord) : TD3DVSDTokenType;

// enable tessellator generated surface parameters
//
// _VertexRegister [0..15] address of vertex register to output parameters
//
  function D3DVSD_TESSUV( _VertexRegister : LongWord) : TD3DVSDTokenType;

// Generates END token
//
const
  D3DVSD_END = $FFFFFFFF;

// Generates NOP token
  D3DVSD_NOP = $00000000;

// bit declarations for _Type fields
  D3DVSDT_FLOAT1      = $00;    // 1D float expanded to (value; 0.; 0.; 1.)
  D3DVSDT_FLOAT2      = $01;    // 2D float expanded to (value; value; 0.; 1.)
  D3DVSDT_FLOAT3      = $02;    // 3D float expanded to (value; value; value; 1.)
  D3DVSDT_FLOAT4      = $03;    // 4D float
  D3DVSDT_D3DCOLOR    = $04;    // 4D packed unsigned bytes mapped to 0. to 1. range
                                    // Input is in D3DCOLOR format (ARGB) expanded to (R; G; B; A)
  D3DVSDT_UBYTE4      = $05;    // 4D unsigned byte
  D3DVSDT_SHORT2      = $06;    // 2D signed short expanded to (value; value; 0.; 1.)
  D3DVSDT_SHORT4      = $07;    // 4D signed short

// assignments of vertex input registers for fixed function vertex shader
//
  D3DVSDE_POSITION      = 0;
  D3DVSDE_BLENDWEIGHT   = 1;
  D3DVSDE_BLENDINDICES  = 2;
  D3DVSDE_NORMAL        = 3;
  D3DVSDE_PSIZE         = 4;
  D3DVSDE_DIFFUSE       = 5;
  D3DVSDE_SPECULAR      = 6;
  D3DVSDE_TEXCOORD0     = 7;
  D3DVSDE_TEXCOORD1     = 8;
  D3DVSDE_TEXCOORD2     = 9;
  D3DVSDE_TEXCOORD3     = 10;
  D3DVSDE_TEXCOORD4     = 11;
  D3DVSDE_TEXCOORD5     = 12;
  D3DVSDE_TEXCOORD6     = 13;
  D3DVSDE_TEXCOORD7     = 14;
  D3DVSDE_POSITION2     = 15;
  D3DVSDE_NORMAL2       = 16;

// Maximum supported number of texture coordinate sets
  D3DDP_MAXTEXCOORD = 8;


//
// Instruction Token Bit Definitions
//
  D3DSI_OPCODE_MASK       = $0000FFFF;

type
  TD3DShaderInstructionOpcodeType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
  D3DSIO_NOP          = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}      // PS/VS
  D3DSIO_MOV          = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}      // PS/VS
  D3DSIO_ADD          = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}      // PS/VS
  D3DSIO_SUB          = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}      // PS
  D3DSIO_MAD          = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}      // PS/VS
  D3DSIO_MUL          = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}      // PS/VS
  D3DSIO_RCP          = 6{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}      // VS
  D3DSIO_RSQ          = 7{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}      // VS
  D3DSIO_DP3          = 8{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}      // PS/VS
  D3DSIO_DP4          = 9{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}      // PS/VS
  D3DSIO_MIN          = 10{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_MAX          = 11{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_SLT          = 12{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_SGE          = 13{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_EXP          = 14{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_LOG          = 15{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_LIT          = 16{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_DST          = 17{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_LRP          = 18{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_FRC          = 19{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_M4x4         = 20{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_M4x3         = 21{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_M3x4         = 22{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_M3x3         = 23{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_M3x2         = 24{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS

  D3DSIO_TEXCOORD     = 64{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXKILL      = 65{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEX          = 66{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXBEM       = 67{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXBEML      = 68{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXREG2AR    = 69{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXREG2GB    = 70{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXM3x2PAD   = 71{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXM3x2TEX   = 72{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXM3x3PAD   = 73{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXM3x3TEX   = 74{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXM3x3DIFF  = 75{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXM3x3SPEC  = 76{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXM3x3VSPEC = 77{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_EXPP         = 78{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_LOGP         = 79{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // VS
  D3DSIO_CND          = 80{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_DEF          = 81{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
{$IFNDEF DX8}
  D3DSIO_TEXREG2RGB   = 82{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXDP3TEX    = 83{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXM3x2DEPTH = 84{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXDP3       = 85{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXM3x3      = 86{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_TEXDEPTH     = 87{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_CMP          = 88{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS
  D3DSIO_BEM          = 89{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}     // PS

  D3DSIO_PHASE        = $FFFD{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
{$ENDIF}
  D3DSIO_COMMENT      = $FFFE{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
  D3DSIO_END          = $FFFF{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

  D3DSIO_FORCE_DWORD  = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};     // force 32-bit size enum

type TD3DShader_Instruction_Opcode_Type = TD3DShaderInstructionOpcodeType;

// Co-Issue Instruction Modifier - if set then this instruction is to be
// issued in parallel with the previous instruction(s) for which this bit
// is not set.
const
  D3DSI_COISSUE           = $40000000;

//
// Parameter Token Bit Definitions
//

{$IFDEF DX8}
  D3DSP_REGNUM_MASK       = $00000FFF;
{$ELSE}
  D3DSP_REGNUM_MASK       = $00001FFF;
{$ENDIF}
// destination parameter write mask
  D3DSP_WRITEMASK_0       = $00010000;  // Component 0 (X;Red)
  D3DSP_WRITEMASK_1       = $00020000;  // Component 1 (Y;Green)
  D3DSP_WRITEMASK_2       = $00040000;  // Component 2 (Z;Blue)
  D3DSP_WRITEMASK_3       = $00080000;  // Component 3 (W;Alpha)
  D3DSP_WRITEMASK_ALL     = $000F0000;  // All Components

// destination parameter modifiers
  D3DSP_DSTMOD_SHIFT      = 20;
  D3DSP_DSTMOD_MASK       = $00F00000;
const
  D3DX_DEFAULT       : ULONG = $FFFFFFFF;

const
  D3DX_FILTER_NONE            = (1 shl 0);
  D3DX_FILTER_POINT           = (2 shl 0);
  D3DX_FILTER_LINEAR          = (3 shl 0);
  D3DX_FILTER_TRIANGLE        = (4 shl 0);
  D3DX_FILTER_BOX             = (5 shl 0);

  D3DX_FILTER_MIRROR_U        = (1 shl 16);
  D3DX_FILTER_MIRROR_V        = (2 shl 16);
  D3DX_FILTER_MIRROR_W        = (4 shl 16);
  D3DX_FILTER_MIRROR          = (7 shl 16);
  D3DX_FILTER_DITHER          = (8 shl 16);

type TD3DShaderParamDSTModType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
  D3DSPDM_NONE        = 0 shl D3DSP_DSTMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // nop
  D3DSPDM_SATURATE    = 1 shl D3DSP_DSTMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // clamp to 0. to 1. range

// destination parameter
  D3DSP_DSTSHIFT_SHIFT    = 24{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
  D3DSP_DSTSHIFT_MASK     = $0F000000{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

// destination/source parameter register type
  D3DSP_REGTYPE_SHIFT     = 28{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
  D3DSP_REGTYPE_MASK      = $70000000{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

  D3DSPDM_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};                       // force 32-bit size enum

type TD3DShader_Param_DSTMod_Type = TD3DShaderParamDSTModType;

type TD3DShaderParamRegisterType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
  D3DSPR_TEMP        = 0 shl LongWord(D3DSP_REGTYPE_SHIFT){$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // Temporary Register File
  D3DSPR_INPUT       = 1 shl LongWord(D3DSP_REGTYPE_SHIFT){$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // Input Register File
  D3DSPR_CONST       = 2 shl LongWord(D3DSP_REGTYPE_SHIFT){$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // Constant Register File
  D3DSPR_ADDR        = 3 shl LongWord(D3DSP_REGTYPE_SHIFT){$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // Address Register (VS)
  D3DSPR_TEXTURE     = 3 shl LongWord(D3DSP_REGTYPE_SHIFT){$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // Texture Register File (PS)
  D3DSPR_RASTOUT     = 4 shl LongWord(D3DSP_REGTYPE_SHIFT){$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // Rasterizer Register File
  D3DSPR_ATTROUT     = 5 shl LongWord(D3DSP_REGTYPE_SHIFT){$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // Attribute Output Register File
  D3DSPR_TEXCRDOUT   = 6 shl LongWord(D3DSP_REGTYPE_SHIFT){$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // Texture Coordinate Output Register File
  D3DSPR_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};                                  // force 32-bit size enum

type TD3DShader_Param_Register_Type = TD3DShaderParamRegisterType;

// Register offsets in the Rasterizer Register File

type TD3DVSRastOutOffsets = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
  D3DSRO_POSITION    = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
  D3DSRO_FOG         = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
  D3DSRO_POINT_SIZE  = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
  D3DSRO_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};  // force 32-bit size enum

type TD3DVS_RastOut_Offsets = TD3DVSRastOutOffsets;

// Source operand addressing modes
const
  D3DVS_ADDRESSMODE_SHIFT = 13;
  D3DVS_ADDRESSMODE_MASK  = 1 shl D3DVS_ADDRESSMODE_SHIFT;

type TD3DVSAddressModeType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
  D3DVS_ADDRMODE_ABSOLUTE    = 0 shl D3DVS_ADDRESSMODE_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
  D3DVS_ADDRMODE_RELATIVE    = 1 shl D3DVS_ADDRESSMODE_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // Relative to register A0
  D3DVS_ADDRMODE_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};                            // force 32-bit size enum

type TD3DVS_AddressMode_Type = TD3DVSAddressModeType;

const
// Source operand swizzle definitions
//
  D3DVS_SWIZZLE_SHIFT     = 16;
  D3DVS_SWIZZLE_MASK      = $00FF0000;

// The following bits define where to take component X from:

  D3DVS_X_X = 0 shl D3DVS_SWIZZLE_SHIFT;
  D3DVS_X_Y = 1 shl D3DVS_SWIZZLE_SHIFT;
  D3DVS_X_Z = 2 shl D3DVS_SWIZZLE_SHIFT;
  D3DVS_X_W = 3 shl D3DVS_SWIZZLE_SHIFT;

// The following bits define where to take component Y from:

  D3DVS_Y_X = 0 shl (D3DVS_SWIZZLE_SHIFT + 2);
  D3DVS_Y_Y = 1 shl (D3DVS_SWIZZLE_SHIFT + 2);
  D3DVS_Y_Z = 2 shl (D3DVS_SWIZZLE_SHIFT + 2);
  D3DVS_Y_W = 3 shl (D3DVS_SWIZZLE_SHIFT + 2);

// The following bits define where to take component Z from:

  D3DVS_Z_X = 0 shl (D3DVS_SWIZZLE_SHIFT + 4);
  D3DVS_Z_Y = 1 shl (D3DVS_SWIZZLE_SHIFT + 4);
  D3DVS_Z_Z = 2 shl (D3DVS_SWIZZLE_SHIFT + 4);
  D3DVS_Z_W = 3 shl (D3DVS_SWIZZLE_SHIFT + 4);

// The following bits define where to take component W from:

  D3DVS_W_X = 0 shl (D3DVS_SWIZZLE_SHIFT + 6);
  D3DVS_W_Y = 1 shl (D3DVS_SWIZZLE_SHIFT + 6);
  D3DVS_W_Z = 2 shl (D3DVS_SWIZZLE_SHIFT + 6);
  D3DVS_W_W = 3 shl (D3DVS_SWIZZLE_SHIFT + 6);

// Value when there is no swizzle (X is taken from X; Y is taken from Y;
// Z is taken from Z; W is taken from W
//
  D3DVS_NOSWIZZLE = D3DVS_X_X or D3DVS_Y_Y or D3DVS_Z_Z or D3DVS_W_W;

// source parameter swizzle
  D3DSP_SWIZZLE_SHIFT = 16;
  D3DSP_SWIZZLE_MASK  = $00FF0000;

  D3DSP_NOSWIZZLE = (0 shl (D3DSP_SWIZZLE_SHIFT + 0)) or
                    (1 shl (D3DSP_SWIZZLE_SHIFT + 2)) or
                    (2 shl (D3DSP_SWIZZLE_SHIFT + 4)) or
                    (3 shl (D3DSP_SWIZZLE_SHIFT + 6));

// pixel-shader swizzle ops
{$IFNDEF DX8}
  D3DSP_REPLICATERED = (0 shl (D3DSP_SWIZZLE_SHIFT + 0)) or
                       (0 shl (D3DSP_SWIZZLE_SHIFT + 2)) or
                       (0 shl (D3DSP_SWIZZLE_SHIFT + 4)) or
                       (0 shl (D3DSP_SWIZZLE_SHIFT + 6));

  D3DSP_REPLICATEGREEN = (1 shl (D3DSP_SWIZZLE_SHIFT + 0)) or
                         (1 shl (D3DSP_SWIZZLE_SHIFT + 2)) or
                         (1 shl (D3DSP_SWIZZLE_SHIFT + 4)) or
                         (1 shl (D3DSP_SWIZZLE_SHIFT + 6));

  D3DSP_REPLICATEBLUE = (2 shl (D3DSP_SWIZZLE_SHIFT + 0)) or
                        (2 shl (D3DSP_SWIZZLE_SHIFT + 2)) or
                        (2 shl (D3DSP_SWIZZLE_SHIFT + 4)) or
                        (2 shl (D3DSP_SWIZZLE_SHIFT + 6));
{$ENDIF}
  D3DSP_REPLICATEALPHA = (3 shl (D3DSP_SWIZZLE_SHIFT + 0)) or
                         (3 shl (D3DSP_SWIZZLE_SHIFT + 2)) or
                         (3 shl (D3DSP_SWIZZLE_SHIFT + 4)) or
                         (3 shl (D3DSP_SWIZZLE_SHIFT + 6));

// source parameter modifiers
  D3DSP_SRCMOD_SHIFT      = 24;
  D3DSP_SRCMOD_MASK       = $0F000000;

type TD3DShaderParamSRCModType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DSPSM_NONE        =  0 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // nop
       D3DSPSM_NEG         =  1 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // negate
       D3DSPSM_BIAS        =  2 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // bias
       D3DSPSM_BIASNEG     =  3 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // bias and negate
       D3DSPSM_SIGN        =  4 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // sign
       D3DSPSM_SIGNNEG     =  5 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // sign and negate
       D3DSPSM_COMP        =  6 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // complement
{$IFNDEF DX8}
       D3DSPSM_X2          =  7 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // *2
       D3DSPSM_X2NEG       =  8 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // *2 and negate
       D3DSPSM_DZ          =  9 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // divide through by z component
       D3DSPSM_DW          = 10 shl D3DSP_SRCMOD_SHIFT{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // divide through by w component
{$ENDIF}
       D3DSPSM_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};                        // force 32-bit size enum

type TD3DShader_Param_SRCMod_Type = TD3DShaderParamSRCModType;
// pixel shader version token
  function D3DPS_VERSION(_Major, _Minor : LongWord) : LongWord;

// vertex shader version token
  function D3DVS_VERSION(_Major, _Minor : LongWord) : LongWord;

// extract major/minor from version cap
  function D3DSHADER_VERSION_MAJOR(_Version : LongWord) : LongWord;
  function D3DSHADER_VERSION_MINOR(_Version : LongWord) : LongWord;


// destination/source parameter register type
const
  D3DSI_COMMENTSIZE_SHIFT = 16;
  D3DSI_COMMENTSIZE_MASK  = $7FFF0000;

  function  D3DSHADER_COMMENT(_DWordSize : LongWord) : LongWord;

// pixel/vertex shader end token
const
  D3DPS_END  = $0000FFFF;
  D3DVS_END  = $0000FFFF;

//---------------------------------------------------------------------

// High order surfaces
//
type TD3DBasisType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DBASIS_BEZIER      = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBASIS_BSPLINE     = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBASIS_INTERPOLATE = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBASIS_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

type TD3DOrderType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DORDER_LINEAR      = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
{$IFNDEF DX8}
       D3DORDER_QUADRATIC   = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
{$ENDIF}
       D3DORDER_CUBIC       = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DORDER_QUINTIC     = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DORDER_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

type TD3DPatchEdgeStyle = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DPATCHEDGE_DISCRETE    = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DPATCHEDGE_CONTINUOUS  = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DPATCHEDGE_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

type TD3DStateBlockType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DSBT_ALL           = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // capture all state
       D3DSBT_PIXELSTATE    = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // capture pixel state
       D3DSBT_VERTEXSTATE   = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF} // capture vertex state
       D3DSBT_FORCE_DWORD   = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};


// The D3DVERTEXBLENDFLAGS type is used with D3DRS_VERTEXBLEND state.
//
type TD3DVertexBlendFlags = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DVBF_DISABLE  = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}         // Disable vertex blending
       D3DVBF_1WEIGHTS = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}         // 2 matrix blending
       D3DVBF_2WEIGHTS = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}         // 3 matrix blending
       D3DVBF_3WEIGHTS = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}         // 4 matrix blending
       D3DVBF_TWEENING = 255{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}       // blending using D3DRS_TWEENFACTOR
       D3DVBF_0WEIGHTS = 256{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}       // one matrix is used with weight 1.0
       D3DVBF_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};     // force 32-bit size enum

type TD3DTextureTransformFlags = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DTTFF_DISABLE         = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // texture coordinates are passed directly
       D3DTTFF_COUNT1          = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // rasterizer should expect 1-D texture coords
       D3DTTFF_COUNT2          = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // rasterizer should expect 2-D texture coords
       D3DTTFF_COUNT3          = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // rasterizer should expect 3-D texture coords
       D3DTTFF_COUNT4          = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // rasterizer should expect 4-D texture coords
       D3DTTFF_PROJECTED       = 256{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}  // texcoords to be divided by COUNTth element
       D3DTTFF_FORCE_DWORD     = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

// Macros to set texture coordinate format bits in the FVF id

const
  D3DFVF_TEXTUREFORMAT2 = 0;         // Two floating point values
  D3DFVF_TEXTUREFORMAT1 = 3;         // One floating point value
  D3DFVF_TEXTUREFORMAT3 = 1;         // Three floating point values
  D3DFVF_TEXTUREFORMAT4 = 2;         // Four floating point values

  function D3DFVF_TEXCOORDSIZE3(CoordIndex : LongWord) : LongWord;
  function D3DFVF_TEXCOORDSIZE2(CoordIndex : LongWord) : LongWord;
  function D3DFVF_TEXCOORDSIZE4(CoordIndex : LongWord) : LongWord;
  function D3DFVF_TEXCOORDSIZE1(CoordIndex : LongWord) : LongWord;

//---------------------------------------------------------------------

(* Direct3D8 Device types *)

type TD3DDevType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
  D3DDEVTYPE_HAL         = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
  D3DDEVTYPE_REF         = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
  D3DDEVTYPE_SW          = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

  D3DDEVTYPE_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

  type
  _D3DSAMPLERSTATETYPE = (
  {$IFNDEF COMPILER6_UP}
    D3DSAMP_invalid_0     {= 0},
    D3DSAMP_ADDRESSU      {= 1},  { D3DTEXTUREADDRESS for U coordinate }
    D3DSAMP_ADDRESSV      {= 2},  { D3DTEXTUREADDRESS for V coordinate }
    D3DSAMP_ADDRESSW      {= 3},  { D3DTEXTUREADDRESS for W coordinate }
    D3DSAMP_BORDERCOLOR   {= 4},  { D3DCOLOR }
    D3DSAMP_MAGFILTER     {= 5},  { D3DTEXTUREFILTER filter to use for magnification }
    D3DSAMP_MINFILTER     {= 6},  { D3DTEXTUREFILTER filter to use for minification }
    D3DSAMP_MIPFILTER     {= 7},  { D3DTEXTUREFILTER filter to use between mipmaps during minification }
    D3DSAMP_MIPMAPLODBIAS {= 8},  { float Mipmap LOD bias }
    D3DSAMP_MAXMIPLEVEL   {= 9},  { DWORD 0..(n-1) LOD index of largest map to use (0 == largest) }
    D3DSAMP_MAXANISOTROPY {= 10}, { DWORD maximum anisotropy }
    D3DSAMP_SRGBTEXTURE   {= 11},

    D3DSAMP_ELEMENTINDEX  {= 12},
    D3DSAMP_DMAPOFFSET
  {$ELSE}
    D3DSAMP_ADDRESSU       = 1,  { D3DTEXTUREADDRESS for U coordinate }
    D3DSAMP_ADDRESSV       = 2,  { D3DTEXTUREADDRESS for V coordinate }
    D3DSAMP_ADDRESSW       = 3,  { D3DTEXTUREADDRESS for W coordinate }
    D3DSAMP_BORDERCOLOR    = 4,  { D3DCOLOR }
    D3DSAMP_MAGFILTER      = 5,  { D3DTEXTUREFILTER filter to use for magnification }
    D3DSAMP_MINFILTER      = 6,  { D3DTEXTUREFILTER filter to use for minification }
    D3DSAMP_MIPFILTER      = 7,  { D3DTEXTUREFILTER filter to use between mipmaps during minification }
    D3DSAMP_MIPMAPLODBIAS  = 8,  { float Mipmap LOD bias }
    D3DSAMP_MAXMIPLEVEL    = 9,  { DWORD 0..(n-1) LOD index of largest map to use (0 == largest) }
    D3DSAMP_MAXANISOTROPY  = 10, { DWORD maximum anisotropy }
    D3DSAMP_SRGBTEXTURE    = 11,
    D3DSAMP_ELEMENTINDEX   = 12, { When multi-element texture is assigned to sampler, this

                                   indicates which element index to use.  Default = 0.  }
    D3DSAMP_DMAPOFFSET     = 13  { Offset in vertices in the pre-sampled displacement map.
                                   Only valid for D3DDMAPSAMPLER sampler  }

  {$ENDIF}

  );
  {$EXTERNALSYM _D3DSAMPLERSTATETYPE}
  D3DSAMPLERSTATETYPE = _D3DSAMPLERSTATETYPE;

  {$EXTERNALSYM D3DSAMPLERSTATETYPE}
  TD3DSamplerStateType = _D3DSAMPLERSTATETYPE;


(* Multi-Sample buffer types *)
type TD3DMultiSampleType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DMULTISAMPLE_NONE            =  0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_2_SAMPLES       =  2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_3_SAMPLES       =  3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_4_SAMPLES       =  4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_5_SAMPLES       =  5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_6_SAMPLES       =  6{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_7_SAMPLES       =  7{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_8_SAMPLES       =  8{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_9_SAMPLES       =  9{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_10_SAMPLES      = 10{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_11_SAMPLES      = 11{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_12_SAMPLES      = 12{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_13_SAMPLES      = 13{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_14_SAMPLES      = 14{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_15_SAMPLES      = 15{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DMULTISAMPLE_16_SAMPLES      = 16{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DMULTISAMPLE_FORCE_DWORD     = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

type TD3DMultiSample_Type = TD3DMultiSampleType;

  function MAKEFOURCC(ch0, ch1, ch2, ch3 : Char) : LongWord;

type PD3DFormat = ^TD3DFormat;
     TD3DFormat = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}

       D3DFMT_UNKNOWN              = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DFMT_R8G8B8               = 20{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_A8R8G8B8             = 21{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_X8R8G8B8             = 22{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_R5G6B5               = 23{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_X1R5G5B5             = 24{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_A1R5G5B5             = 25{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_A4R4G4B4             = 26{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_R3G3B2               = 27{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_A8                   = 28{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_A8R3G3B2             = 29{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_X4R4G4B4             = 30{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
{$IFNDEF DX8}
       D3DFMT_A2B10G10R10          = 31{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_G16R16               = 34{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
{$ENDIF}
       D3DFMT_A8P8                 = 40{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_P8                   = 41{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DFMT_L8                   = 50{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_A8L8                 = 51{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_A4L4                 = 52{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DFMT_V8U8                 = 60{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_L6V5U5               = 61{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_X8L8V8U8             = 62{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_Q8W8V8U8             = 63{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_V16U16               = 64{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_W11V11U10            = 65{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
{$IFNDEF DX8}
       D3DFMT_A2W10V10U10          = 67{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
{$ENDIF}
       D3DFMT_UYVY = Byte('U') or (Byte('Y') shl 8) or (Byte('V') shl 16) or (Byte('Y') shl 24 ){$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_YUY2 = Byte('Y') or (Byte('U') shl 8) or (Byte('Y') shl 16) or (Byte('2') shl 24 ){$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_DXT1 = Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('1') shl 24 ){$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_DXT2 = Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('2') shl 24 ){$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_DXT3 = Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('3') shl 24 ){$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_DXT4 = Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('4') shl 24 ){$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_DXT5 = Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('5') shl 24 ){$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DFMT_D16_LOCKABLE         = 70{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_D32                  = 71{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_D15S1                = 73{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_D24S8                = 75{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_D16                  = 80{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_D24X8                = 77{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_D24X4S4              = 79{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}


       D3DFMT_VERTEXDATA           = 100{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_INDEX16              = 101{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DFMT_INDEX32              = 102{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DFMT_FORCE_DWORD          = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

(* Display Modes *)
type
  PD3DDisplayMode = ^TD3DDisplayMode;
  TD3DDisplayMode = packed record
    Width       : Cardinal;
    Height      : Cardinal;
    RefreshRate : Cardinal;
    Format      : TD3DFormat;
  end;

(* Creation Parameters *)
  PD3DDevice_Creation_Parameters = ^TD3DDevice_Creation_Parameters;
  TD3DDevice_Creation_Parameters = packed record
    AdapterOrdinal : Cardinal;
    DeviceType     : TD3DDevType;
    hFocusWindow   : HWND;
    BehaviorFlags  : LongWord;
  end;

  PD3DDeviceCreationParameters = ^TD3DDeviceCreationParameters;
  TD3DDeviceCreationParameters = TD3DDevice_Creation_Parameters;

(* SwapEffects *)
type TD3DSwapEffect = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DSWAPEFFECT_DISCARD           = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSWAPEFFECT_FLIP              = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DSWAPEFFECT_COPY              = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DSWAPEFFECT_FORCE_DWORD       = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

(* Pool types *)
type TD3DPool  = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DPOOL_DEFAULT                 = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DPOOL_MANAGED                 = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DPOOL_SYSTEMMEM               = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
{$IFNDEF DX8}
       D3DPOOL_SCRATCH                 = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
{$ENDIF}

       D3DPOOL_FORCE_DWORD             = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

const
(* RefreshRate pre-defines *)
  D3DPRESENT_RATE_DEFAULT         = $00000000;
  D3DPRESENT_RATE_UNLIMITED       = $7fffffff;


(* Resize Optional Parameters *)
type
  PD3DPresent_Parameters = ^TD3DPresent_Parameters;
  TD3DPresent_Parameters = packed record
    BackBufferWidth                 : Cardinal;
    BackBufferHeight                : Cardinal;
    BackBufferFormat                : TD3DFormat;
    BackBufferCount                 : Cardinal;

    MultiSampleType                 : TD3DMultiSample_Type;
    MultiSampleQuality              : DWORD;
    SwapEffect                      : TD3DSwapEffect;
    hDeviceWindow                   : HWND;
    Windowed                        : BOOL;
    EnableAutoDepthStencil          : BOOL;
    AutoDepthStencilFormat          : TD3DFormat;
    Flags                           : LongWord;
    FullScreen_RefreshRateInHz      : Cardinal;
    FullScreen_PresentationInterval : Cardinal;
  end;

  PD3DPresentParameters = ^TD3DPresentParameters;
  TD3DPresentParameters = TD3DPresent_Parameters;

// Values for D3DPRESENT_PARAMETERS.Flags
const
  D3DPRESENTFLAG_LOCKABLE_BACKBUFFER  = $00000001;


(* Gamma Ramp: Same as DX7 *)
type
  PD3DGammaRamp = ^TD3DGammaRamp;
  TD3DGammaRamp = packed record
    red   : array [0..255] of Word;
    green : array [0..255] of Word;
    blue  : array [0..255] of Word;
  end;

(* Back buffer types *)
type TD3DBackBufferType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DBACKBUFFER_TYPE_MONO         = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBACKBUFFER_TYPE_LEFT         = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DBACKBUFFER_TYPE_RIGHT        = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DBACKBUFFER_TYPE_FORCE_DWORD  = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

type TD3DBackBuffer_Type = TD3DBackBufferType;

(* Types *)
type TD3DResourceType = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DRTYPE_SURFACE                = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRTYPE_VOLUME                 = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRTYPE_TEXTURE                = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRTYPE_VOLUMETEXTURE          = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRTYPE_CUBETEXTURE            = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRTYPE_VERTEXBUFFER           = 6{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DRTYPE_INDEXBUFFER            = 7{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DRTYPE_FORCE_DWORD            = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

const
(* Usages *)
  D3DUSAGE_RENDERTARGET       = $00000001;
  D3DUSAGE_DEPTHSTENCIL       = $00000002;

(* Usages for Vertex/Index buffers *)
  D3DUSAGE_WRITEONLY          = $00000008;
  D3DUSAGE_SOFTWAREPROCESSING = $00000010;
  D3DUSAGE_DONOTCLIP          = $00000020;
  D3DUSAGE_POINTS             = $00000040;
  D3DUSAGE_RTPATCHES          = $00000080;
  D3DUSAGE_NPATCHES           = $00000100;
  D3DUSAGE_DYNAMIC            = $00000200;

(* CubeMap Face identifiers *)
type TD3DCubeMapFaces = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DCUBEMAP_FACE_POSITIVE_X     = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCUBEMAP_FACE_NEGATIVE_X     = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCUBEMAP_FACE_POSITIVE_Y     = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCUBEMAP_FACE_NEGATIVE_Y     = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCUBEMAP_FACE_POSITIVE_Z     = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
       D3DCUBEMAP_FACE_NEGATIVE_Z     = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}

       D3DCUBEMAP_FACE_FORCE_DWORD    = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

type TD3DCubeMap_Faces = TD3DCubeMapFaces;

const
(* Lock flags *)

  D3DLOCK_READONLY         = $00000010;
  D3DLOCK_DISCARD          = $00002000;
  D3DLOCK_NOOVERWRITE      = $00001000;
  D3DLOCK_NOSYSLOCK        = $00000800;

  D3DLOCK_NO_DIRTY_UPDATE  = $00008000;

(* Vertex Buffer Description *)
type
  PD3DVertexBuffer_Desc = ^TD3DVertexBuffer_Desc;
  TD3DVertexBuffer_Desc = packed record
    Format : TD3DFormat;
    _Type  : TD3DResourceType;
    Usage  : LongWord;
    Pool   : TD3DPool;
    Size   : Cardinal;
    FVF    : LongWord;
  end;

  PD3DVertexBufferDesc = ^TD3DVertexBufferDesc;
  TD3DVertexBufferDesc = TD3DVertexBuffer_Desc;

(* Index Buffer Description *)
  PTD3DIndexBuffer_Desc = ^TD3DIndexBuffer_Desc;
  TD3DIndexBuffer_Desc = packed record
    Format : TD3DFormat;
    _Type  : TD3DResourceType;
    Usage  : LongWord;
    Pool   : TD3DPool;
    Size   : Cardinal;
  end;

  PTD3DIndexBufferDesc = ^TD3DIndexBufferDesc;
  TD3DIndexBufferDesc = TD3DIndexBuffer_Desc;


(* Surface Description *)
  PD3DSurface_Desc = ^TD3DSurface_Desc;
  TD3DSurface_Desc = packed record
    Format          : TD3DFormat;
    _Type           : TD3DResourceType;
    Usage           : LongWord;
    Pool            : TD3DPool;
    Size            : Cardinal;
    MultiSampleType : TD3DMultiSample_Type;
    Width           : Cardinal;
    Height          : Cardinal;
  end;

  PD3DSurfaceDesc = ^TD3DSurfaceDesc;
  TD3DSurfaceDesc = TD3DSurface_Desc;


  PD3DVolume_Desc = ^TD3DVolume_Desc;
  TD3DVolume_Desc = packed record
    Format : TD3DFormat;
    _Type  : TD3DResourceType;
    Usage  : LongWord;
    Pool   : TD3DPool;
    Size   : Cardinal;
    Width  : Cardinal;
    Height : Cardinal;
    Depth  : Cardinal;
  end;

  PD3DVolumeDesc = ^TD3DVolumeDesc;
  TD3DVolumeDesc = TD3DVolume_Desc;


(* Structure for LockRect *)
  PD3DLocked_Rect = ^TD3DLocked_Rect;
  TD3DLocked_Rect = packed record
    Pitch : Integer;
    pBits : Pointer;//void*
  end;

  PD3DLockedRect = ^TD3DLockedRect;
  TD3DLockedRect = TD3DLocked_Rect;


(* Structures for LockBox *)
  PD3DBox = ^TD3DBox;
  TD3DBox = packed record
    Left   : Cardinal;
    Top    : Cardinal;
    Right  : Cardinal;
    Bottom : Cardinal;
    Front  : Cardinal;
    Back   : Cardinal;
  end;

  PD3DLocked_Box = ^TD3DLocked_Box;
  TD3DLocked_Box = packed record
    RowPitch   : Integer;
    SlicePitch : Integer;
    pBits      : Pointer;
  end;

  PD3DLockedBox = ^TD3DLockedBox;
  TD3DLockedBox = TD3DLocked_Box;


(* Structures for LockRange *)
  PD3DRange = ^TD3DRange;
  TD3DRange = packed record
    Offset : Cardinal;
    Size   : Cardinal;
  end;

(* Structures for high order primitives *)
  PD3DRectPatch_Info = ^TD3DRectPatch_Info;
  TD3DRectPatch_Info = packed record
    StartVertexOffsetWidth  : Cardinal;
    StartVertexOffsetHeight : Cardinal;
    Width                   : Cardinal;
    Height                  : Cardinal;
    Stride                  : Cardinal;
    Basis                   : TD3DBasisType;
    Order                   : TD3DOrderType;
  end;

  PD3DRectPatchInfo = ^TD3DRectPatchInfo;
  TD3DRectPatchInfo = TD3DRectPatch_Info;


  PD3DTriPatch_Info = ^TD3DTriPatch_Info;
  TD3DTriPatch_Info = packed record
    StartVertexOffset : Cardinal;
    NumVertices       : Cardinal;
    Basis             : TD3DBasisType;
    Order             : TD3DOrderType;
  end;

  PD3DTriPatchInfo = ^TD3DTriPatchInfo;
  TD3DTriPatchInfo = TD3DTriPatch_Info;


(* Adapter Identifier *)
const
  MAX_DEVICE_IDENTIFIER_STRING = 512;

type
  PD3DAdapter_Identifier9 = ^TD3DAdapter_Identifier9;
  TD3DAdapter_Identifier9 = packed record
    Driver      : array [0..MAX_DEVICE_IDENTIFIER_STRING - 1] of AnsiChar;
    Description : array [0..MAX_DEVICE_IDENTIFIER_STRING - 1] of AnsiChar;
    DeviceNam   : array [0..32] of AnsiChar;
    DriverVersionLowPart : LongWord;     (* Defined for 16 bit driver components *)
    DriverVersionHighPart : LongWord;

    VendorId : LongWord;
    DeviceId : LongWord;
    SubSysId : LongWord;
    Revision : LongWord;

    DeviceIdentifier : TGUID;

    WHQLLevel : LongWord;

  end;

  PD3DAdapterIdentifier9 = ^TD3DAdapterIdentifier9;
  TD3DAdapterIdentifier9 = TD3DAdapter_Identifier9;


(* Raster Status structure returned by GetRasterStatus *)
  PD3DRaster_Status = ^TD3DRaster_Status;
  TD3DRaster_Status = packed record
    InVBlank : Bool;
    ScanLine : Cardinal;
  end;

  PD3DRasterStatus = ^TD3DRasterStatus;
  TD3DRasterStatus = TD3DRaster_Status;

(* Debug monitor tokens (DEBUG only)

   Note that if D3DRS_DEBUGMONITORTOKEN is set; the call is treated as
   passing a token to the debug monitor.  For example; if; after passing
   D3DDMT_ENABLE/DISABLE to D3DRS_DEBUGMONITORTOKEN other token values
   are passed in; the enabled/disabled state of the debug
   monitor will still persist.

   The debug monitor defaults to enabled.

   Calling GetRenderState on D3DRS_DEBUGMONITORTOKEN is not of any use.
*)
type TD3DDebugMonitorTokens = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
       D3DDMT_ENABLE          = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // enable debug monitor
       D3DDMT_DISABLE         = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}    // disable debug monitor
       D3DDMT_FORCE_DWORD     = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

{$IFNDEF DX8}
// GetInfo IDs
const
  D3DDEVINFOID_RESOURCEMANAGER = 5;    (* Used with D3DDEVINFO_RESOURCEMANAGER *)
  D3DDEVINFOID_VERTEXSTATS     = 6;    (* Used with D3DDEVINFO_D3DVERTEXSTATS *)

type
  PD3DResourceStats = ^TD3DResourceStats;
  TD3DResourceStats = packed record
// Data collected since last Present()
    bThrashing            : LongBool;  (* indicates if thrashing *)
    ApproxBytesDownloaded : LongWord;  (* Approximate number of bytes downloaded by resource manager *)
    NumEvicts             : LongWord;  (* number of objects evicted *)
    NumVidCreates         : LongWord;  (* number of objects created in video memory *)
    LastPri               : LongWord;  (* priority of last object evicted *)
    NumUsed               : LongWord;  (* number of objects set to the device *)
    NumUsedInVidMem       : LongWord;  (* number of objects set to the device, which are already in video memory *)
// Persistent data
    WorkingSet            : LongWord;  (* number of objects in video memory *)
    WorkingSetBytes       : LongWord;  (* number of bytes in video memory *)
    TotalManaged          : LongWord;  (* total number of managed objects *)
    TotalBytes            : LongWord;  (* total number of bytes of managed objects *)
  end;

const D3DRTYPECOUNT = LongWord(D3DRTYPE_INDEXBUFFER) + 1;

type
  PD3DDevInfo_ResourceManager = ^TD3DDevInfo_ResourceManager;
  TD3DDevInfo_ResourceManager = packed record
    stats : array [0..D3DRTYPECOUNT - 1] of TD3DResourceStats;
  end;

  PD3DDevInfoResourceManager = ^TD3DDevInfoResourceManager;
  TD3DDevInfoResourceManager = TD3DDevInfo_ResourceManager;


type
  PD3DDevInfo_D3DVertexStats = ^TD3DDevInfo_D3DVertexStats;
  TD3DDevInfo_D3DVertexStats = packed record
    NumRenderedTriangles      : LongWord;  (* total number of triangles that are not clipped in this frame *)
    NumExtraClippingTriangles : LongWord;  (* Number of new triangles generated by clipping *)
  end;
  PD3DDevInfoD3DVertexStats = ^TD3DDevInfoD3DVertexStats;
  TD3DDevInfoD3DVertexStats = TD3DDevInfo_D3DVertexStats;

{$ENDIF}

(*==========================================================================;
 *
 *  Copyright (C) 1995-2000 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       d3d8caps.h
 *  Content:    Direct3D capabilities include file
 *
 ***************************************************************************)
 type

  PD3DVShaderCaps2_0 = ^TD3DVShaderCaps2_0;

  _D3DVSHADERCAPS2_0 = packed record
    Caps:                     DWORD;
    DynamicFlowControlDepth:  Integer;
    NumTemps:                 Integer;
    StaticFlowControlDepth:   Integer;
  end;
  {$EXTERNALSYM _D3DVSHADERCAPS2_0}
  D3DVSHADERCAPS2_0 = _D3DVSHADERCAPS2_0;
  {$EXTERNALSYM D3DVSHADERCAPS2_0}
  TD3DVShaderCaps2_0 = _D3DVSHADERCAPS2_0;

  type
  PD3DPShaderCaps2_0 = ^TD3DPShaderCaps2_0;
  _D3DPSHADERCAPS2_0 = packed record
    Caps:                     DWORD;
    DynamicFlowControlDepth:  Integer;
    NumTemps:                 Integer;
    StaticFlowControlDepth:   Integer;
    NumInstructionSlots:      Integer;
  end;

  {$EXTERNALSYM _D3DPSHADERCAPS2_0}
  D3DPSHADERCAPS2_0 = _D3DPSHADERCAPS2_0;
  {$EXTERNALSYM D3DPSHADERCAPS2_0}
  TD3DPShaderCaps2_0 = _D3DPSHADERCAPS2_0;

type

  PD3DCaps9 = ^TD3DCaps9;
  _D3DCAPS9 = record

    DeviceType: TD3DDevType;
    AdapterOrdinal: DWord;
    Caps: DWord;
    Caps2: DWord;
    Caps3: DWord;
    PresentationIntervals: DWord;
    CursorCaps: DWORD;
    DevCaps: DWord;
    PrimitiveMiscCaps: DWord;
    RasterCaps: DWord;
    ZCmpCaps: DWord;
    SrcBlendCaps: DWord;
    DestBlendCaps: DWord;
    AlphaCmpCaps: DWord;
    ShadeCaps: DWord;
    TextureCaps: DWord;
    TextureFilterCaps: DWord;           // D3DPTFILTERCAPS for IDirect3DTexture9's
    CubeTextureFilterCaps: DWord;       // D3DPTFILTERCAPS for IDirect3DCubeTexture9's
    VolumeTextureFilterCaps: DWord;     // D3DPTFILTERCAPS for IDirect3DVolumeTexture9's
    TextureAddressCaps: DWord;          // D3DPTADDRESSCAPS for IDirect3DTexture9's
    VolumeTextureAddressCaps: DWord;    // D3DPTADDRESSCAPS for IDirect3DVolumeTexture9's
    LineCaps: DWord;                    // D3DLINECAPS
    MaxTextureWidth, MaxTextureHeight: DWord;
    MaxVolumeExtent: DWord;
    MaxTextureRepeat: DWord;
    MaxTextureAspectRatio: DWord;
    MaxAnisotropy: DWord;
    MaxVertexW: Single;
    GuardBandLeft: Single;
    GuardBandTop: Single;
    GuardBandRight: Single;
    GuardBandBottom: Single;
    ExtentsAdjust: Single;
    StencilCaps: DWord;
    FVFCaps: DWord;
    TextureOpCaps: DWord;
    MaxTextureBlendStages: DWord;
    MaxSimultaneousTextures: DWord;
    VertexProcessingCaps: DWord;
    MaxActiveLights: DWord;
    MaxUserClipPlanes: DWord;
    MaxVertexBlendMatrices: DWord;
    MaxVertexBlendMatrixIndex: DWord;
    MaxPointSize: Single;
    MaxPrimitiveCount: DWord;           // max number of primitives per DrawPrimitive call
    MaxVertexIndex: DWord;
    MaxStreams: DWord;
    MaxStreamStride: DWord;             // max stride for SetStreamSource
    VertexShaderVersion: DWord;
    MaxVertexShaderConst: DWord;        // number of vertex shader constant registers
    PixelShaderVersion: DWord;
    PixelShader1xMaxValue: Single;      // max value storable in registers of ps.1.x shaders
    DevCaps2: DWORD;
    MaxNpatchTessellationLevel: Single;
    Reserved5: DWORD;
    MasterAdapterOrdinal: LongWord;     // ordinal of master adaptor for adapter group
    AdapterOrdinalInGroup: LongWord;    // ordinal inside the adapter group
    NumberOfAdaptersInGroup: LongWord;  // number of adapters in this adapter group (only if master)
    DeclTypes: DWORD;                   // Data types, supported in vertex declarations
    NumSimultaneousRTs: DWORD;          // Will be at least 1
    StretchRectFilterCaps: DWORD;       // Filter caps supported by StretchRect
    VS20Caps: TD3DVShaderCaps2_0;
    PS20Caps: TD3DPShaderCaps2_0;
    VertexTextureFilterCaps: DWORD;     // D3DPTFILTERCAPS for IDirect3DTexture9's for texture, used in vertex shaders
    MaxVShaderInstructionsExecuted: DWORD; // maximum number of vertex shader instructions that can be executed
    MaxPShaderInstructionsExecuted: DWORD; // maximum number of pixel shader instructions that can be executed
    MaxVertexShader30InstructionSlots: DWORD;
    MaxPixelShader30InstructionSlots: DWORD;
  end {D3DCAPS9};

  {$EXTERNALSYM _D3DCAPS9}
  D3DCAPS9 = _D3DCAPS9;
  {$EXTERNALSYM D3DCAPS9}
  TD3DCaps9 = _D3DCAPS9;
//
// BIT DEFINES FOR D3DCAPS8 DWORD MEMBERS
//

//
// Caps
//
const
  D3DCAPS_READ_SCANLINE = $00020000;

//
// Caps2
//
  D3DCAPS2_NO2DDURING3DSCENE      = $00000002;
  D3DCAPS2_FULLSCREENGAMMA        = $00020000;
  D3DCAPS2_CANRENDERWINDOWED      = $00080000;
  D3DCAPS2_CANCALIBRATEGAMMA      = $00100000;
  D3DCAPS2_RESERVED               = $02000000;
{$IFNDEF DX8}
  D3DCAPS2_CANMANAGERESOURCE      = $10000000;
  D3DCAPS2_DYNAMICTEXTURES        = $20000000;
{$ENDIF}

//
// Caps3
//
  D3DCAPS3_RESERVED               = $8000001f;

{$IFNDEF DX8}
// Indicates that the device can respect the ALPHABLENDENABLE render state
// when fullscreen while using the FLIP or DISCARD swap effect.
// COPY and COPYVSYNC swap effects work whether or not this flag is set.
  D3DCAPS3_ALPHA_FULLSCREEN_FLIP_OR_DISCARD = $00000020;
{$ENDIF}



//
// PresentationIntervals
//
  D3DPRESENT_INTERVAL_DEFAULT     = $00000000;
  D3DPRESENT_INTERVAL_ONE         = $00000001;
  D3DPRESENT_INTERVAL_TWO         = $00000002;
  D3DPRESENT_INTERVAL_THREE       = $00000004;
  D3DPRESENT_INTERVAL_FOUR        = $00000008;
  D3DPRESENT_INTERVAL_IMMEDIATE   = $80000000;

//
// CursorCaps
//
// Driver supports HW color cursor in at least hi-res modes(height >=400)
  D3DCURSORCAPS_COLOR             = $00000001;
// Driver supports HW cursor also in low-res modes(height < 400)
  D3DCURSORCAPS_LOWRES            = $00000002;

//
// DevCaps
//
  D3DDEVCAPS_EXECUTESYSTEMMEMORY     = $00000010; (* Device can use execute buffers from system memory *)
  D3DDEVCAPS_EXECUTEVIDEOMEMORY      = $00000020; (* Device can use execute buffers from video memory *)
  D3DDEVCAPS_TLVERTEXSYSTEMMEMORY    = $00000040; (* Device can use TL buffers from system memory *)
  D3DDEVCAPS_TLVERTEXVIDEOMEMORY     = $00000080; (* Device can use TL buffers from video memory *)
  D3DDEVCAPS_TEXTURESYSTEMMEMORY     = $00000100; (* Device can texture from system memory *)
  D3DDEVCAPS_TEXTUREVIDEOMEMORY      = $00000200; (* Device can texture from device memory *)
  D3DDEVCAPS_DRAWPRIMTLVERTEX        = $00000400; (* Device can draw TLVERTEX primitives *)
  D3DDEVCAPS_CANRENDERAFTERFLIP      = $00000800; (* Device can render without waiting for flip to complete *)
  D3DDEVCAPS_TEXTURENONLOCALVIDMEM   = $00001000; (* Device can texture from nonlocal video memory *)
  D3DDEVCAPS_DRAWPRIMITIVES2         = $00002000; (* Device can support DrawPrimitives2 *)
  D3DDEVCAPS_SEPARATETEXTUREMEMORIES = $00004000; (* Device is texturing from separate memory pools *)
  D3DDEVCAPS_DRAWPRIMITIVES2EX       = $00008000; (* Device can support Extended DrawPrimitives2 i.e. DX7 compliant driver*)
  D3DDEVCAPS_HWTRANSFORMANDLIGHT     = $00010000; (* Device can support transformation and lighting in hardware and DRAWPRIMITIVES2EX must be also *)
  D3DDEVCAPS_CANBLTSYSTONONLOCAL     = $00020000; (* Device supports a Tex Blt from system memory to non-local vidmem *)
  D3DDEVCAPS_HWRASTERIZATION         = $00080000; (* Device has HW acceleration for rasterization *)
  D3DDEVCAPS_PUREDEVICE              = $00100000; (* Device supports D3DCREATE_PUREDEVICE *)
  D3DDEVCAPS_QUINTICRTPATCHES        = $00200000; (* Device supports quintic Beziers and BSplines *)
  D3DDEVCAPS_RTPATCHES               = $00400000; (* Device supports Rect and Tri patches *)
  D3DDEVCAPS_RTPATCHHANDLEZERO       = $00800000; (* Indicates that RT Patches may be drawn efficiently using handle 0 *)
  D3DDEVCAPS_NPATCHES                = $01000000; (* Device supports N-Patches *)

//
// PrimitiveMiscCaps
//
  D3DPMISCCAPS_MASKZ                 = $00000002;
  D3DPMISCCAPS_LINEPATTERNREP        = $00000004;
  D3DPMISCCAPS_CULLNONE              = $00000010;
  D3DPMISCCAPS_CULLCW                = $00000020;
  D3DPMISCCAPS_CULLCCW               = $00000040;
  D3DPMISCCAPS_COLORWRITEENABLE      = $00000080;
  D3DPMISCCAPS_CLIPPLANESCALEDPOINTS = $00000100; (* Device correctly clips scaled points to clip planes *)
  D3DPMISCCAPS_CLIPTLVERTS           = $00000200; (* device will clip post-transformed vertex primitives *)
  D3DPMISCCAPS_TSSARGTEMP            = $00000400; (* device supports D3DTA_TEMP for temporary register *)
  D3DPMISCCAPS_BLENDOP               = $00000800; (* device supports D3DRS_BLENDOP *)
{$IFNDEF DX8}
  D3DPMISCCAPS_NULLREFERENCE         = $00001000; (* Reference Device that doesnt render *)
{$ENDIF}

//
// LineCaps
//
  D3DLINECAPS_TEXTURE             = $00000001;
  D3DLINECAPS_ZTEST               = $00000002;
  D3DLINECAPS_BLEND               = $00000004;
  D3DLINECAPS_ALPHACMP            = $00000008;
  D3DLINECAPS_FOG                 = $00000010;

//
// RasterCaps
//
  D3DPRASTERCAPS_DITHER                 = $00000001;
  D3DPRASTERCAPS_PAT                    = $00000008;
  D3DPRASTERCAPS_ZTEST                  = $00000010;
  D3DPRASTERCAPS_FOGVERTEX              = $00000080;
  D3DPRASTERCAPS_FOGTABLE               = $00000100;
  D3DPRASTERCAPS_ANTIALIASEDGES         = $00001000;
  D3DPRASTERCAPS_MIPMAPLODBIAS          = $00002000;
  D3DPRASTERCAPS_ZBIAS                  = $00004000;
  D3DPRASTERCAPS_ZBUFFERLESSHSR         = $00008000;
  D3DPRASTERCAPS_FOGRANGE               = $00010000;
  D3DPRASTERCAPS_ANISOTROPY             = $00020000;
  D3DPRASTERCAPS_WBUFFER                = $00040000;
  D3DPRASTERCAPS_WFOG                   = $00100000;
  D3DPRASTERCAPS_ZFOG                   = $00200000;
  D3DPRASTERCAPS_COLORPERSPECTIVE       = $00400000; (* Device iterates colors perspective correct *)
  D3DPRASTERCAPS_STRETCHBLTMULTISAMPLE  = $00800000;

//
// ZCmpCaps, AlphaCmpCaps
//
  D3DPCMPCAPS_NEVER               = $00000001;
  D3DPCMPCAPS_LESS                = $00000002;
  D3DPCMPCAPS_EQUAL               = $00000004;
  D3DPCMPCAPS_LESSEQUAL           = $00000008;
  D3DPCMPCAPS_GREATER             = $00000010;
  D3DPCMPCAPS_NOTEQUAL            = $00000020;
  D3DPCMPCAPS_GREATEREQUAL        = $00000040;
  D3DPCMPCAPS_ALWAYS              = $00000080;

//
// SourceBlendCaps, DestBlendCaps
//
  D3DPBLENDCAPS_ZERO              = $00000001;
  D3DPBLENDCAPS_ONE               = $00000002;
  D3DPBLENDCAPS_SRCCOLOR          = $00000004;
  D3DPBLENDCAPS_INVSRCCOLOR       = $00000008;
  D3DPBLENDCAPS_SRCALPHA          = $00000010;
  D3DPBLENDCAPS_INVSRCALPHA       = $00000020;
  D3DPBLENDCAPS_DESTALPHA         = $00000040;
  D3DPBLENDCAPS_INVDESTALPHA      = $00000080;
  D3DPBLENDCAPS_DESTCOLOR         = $00000100;
  D3DPBLENDCAPS_INVDESTCOLOR      = $00000200;
  D3DPBLENDCAPS_SRCALPHASAT       = $00000400;
  D3DPBLENDCAPS_BOTHSRCALPHA      = $00000800;
  D3DPBLENDCAPS_BOTHINVSRCALPHA   = $00001000;

//
// ShadeCaps
//
  D3DPSHADECAPS_COLORGOURAUDRGB       = $00000008;
  D3DPSHADECAPS_SPECULARGOURAUDRGB    = $00000200;
  D3DPSHADECAPS_ALPHAGOURAUDBLEND     = $00004000;
  D3DPSHADECAPS_FOGGOURAUD            = $00080000;

//
// TextureCaps
//
  D3DPTEXTURECAPS_PERSPECTIVE              = $00000001; (* Perspective-correct texturing is supported *)
  D3DPTEXTURECAPS_POW2                     = $00000002; (* Power-of-2 texture dimensions are required - applies to non-Cube/Volume textures only. *)
  D3DPTEXTURECAPS_ALPHA                    = $00000004; (* Alpha in texture pixels is supported *)
  D3DPTEXTURECAPS_SQUAREONLY               = $00000020; (* Only square textures are supported *)
  D3DPTEXTURECAPS_TEXREPEATNOTSCALEDBYSIZE = $00000040; (* Texture indices are not scaled by the texture size prior to interpolation *)
  D3DPTEXTURECAPS_ALPHAPALETTE             = $00000080; (* Device can draw alpha from texture palettes *)
// Device can use non-POW2 textures if:
//  1) D3DTEXTURE_ADDRESS is set to CLAMP for this texture's stage
//  2) D3DRS_WRAP(N) is zero for this texture's coordinates
//  3) mip mapping is not enabled (use magnification filter only)
  D3DPTEXTURECAPS_NONPOW2CONDITIONAL       = $00000100;
  D3DPTEXTURECAPS_PROJECTED                = $00000400; (* Device can do D3DTTFF_PROJECTED *)
  D3DPTEXTURECAPS_CUBEMAP                  = $00000800; (* Device can do cubemap textures *)
  D3DPTEXTURECAPS_VOLUMEMAP                = $00002000; (* Device can do volume textures *)
  D3DPTEXTURECAPS_MIPMAP                   = $00004000; (* Device can do mipmapped textures *)
  D3DPTEXTURECAPS_MIPVOLUMEMAP             = $00008000; (* Device can do mipmapped volume textures *)
  D3DPTEXTURECAPS_MIPCUBEMAP               = $00010000; (* Device can do mipmapped cube maps *)
  D3DPTEXTURECAPS_CUBEMAP_POW2             = $00020000; (* Device requires that cubemaps be power-of-2 dimension *)
  D3DPTEXTURECAPS_VOLUMEMAP_POW2           = $00040000; (* Device requires that volume maps be power-of-2 dimension *)

//
// TextureFilterCaps
//
  D3DPTFILTERCAPS_MINFPOINT           = $00000100; (* Min Filter *)
  D3DPTFILTERCAPS_MINFLINEAR          = $00000200;
  D3DPTFILTERCAPS_MINFANISOTROPIC     = $00000400;
  D3DPTFILTERCAPS_MIPFPOINT           = $00010000; (* Mip Filter *)
  D3DPTFILTERCAPS_MIPFLINEAR          = $00020000;
  D3DPTFILTERCAPS_MAGFPOINT           = $01000000; (* Mag Filter *)
  D3DPTFILTERCAPS_MAGFLINEAR          = $02000000;
  D3DPTFILTERCAPS_MAGFANISOTROPIC     = $04000000;
  D3DPTFILTERCAPS_MAGFAFLATCUBIC      = $08000000;
  D3DPTFILTERCAPS_MAGFGAUSSIANCUBIC   = $10000000;

//
// TextureAddressCaps
//
  D3DPTADDRESSCAPS_WRAP           = $00000001;
  D3DPTADDRESSCAPS_MIRROR         = $00000002;
  D3DPTADDRESSCAPS_CLAMP          = $00000004;
  D3DPTADDRESSCAPS_BORDER         = $00000008;
  D3DPTADDRESSCAPS_INDEPENDENTUV  = $00000010;
  D3DPTADDRESSCAPS_MIRRORONCE     = $00000020;

//
// StencilCaps
//
  D3DSTENCILCAPS_KEEP             = $00000001;
  D3DSTENCILCAPS_ZERO             = $00000002;
  D3DSTENCILCAPS_REPLACE          = $00000004;
  D3DSTENCILCAPS_INCRSAT          = $00000008;
  D3DSTENCILCAPS_DECRSAT          = $00000010;
  D3DSTENCILCAPS_INVERT           = $00000020;
  D3DSTENCILCAPS_INCR             = $00000040;
  D3DSTENCILCAPS_DECR             = $00000080;

//
// TextureOpCaps
//
  D3DTEXOPCAPS_DISABLE                    = $00000001;
  D3DTEXOPCAPS_SELECTARG1                 = $00000002;
  D3DTEXOPCAPS_SELECTARG2                 = $00000004;
  D3DTEXOPCAPS_MODULATE                   = $00000008;
  D3DTEXOPCAPS_MODULATE2X                 = $00000010;
  D3DTEXOPCAPS_MODULATE4X                 = $00000020;
  D3DTEXOPCAPS_ADD                        = $00000040;
  D3DTEXOPCAPS_ADDSIGNED                  = $00000080;
  D3DTEXOPCAPS_ADDSIGNED2X                = $00000100;
  D3DTEXOPCAPS_SUBTRACT                   = $00000200;
  D3DTEXOPCAPS_ADDSMOOTH                  = $00000400;
  D3DTEXOPCAPS_BLENDDIFFUSEALPHA          = $00000800;
  D3DTEXOPCAPS_BLENDTEXTUREALPHA          = $00001000;
  D3DTEXOPCAPS_BLENDFACTORALPHA           = $00002000;
  D3DTEXOPCAPS_BLENDTEXTUREALPHAPM        = $00004000;
  D3DTEXOPCAPS_BLENDCURRENTALPHA          = $00008000;
  D3DTEXOPCAPS_PREMODULATE                = $00010000;
  D3DTEXOPCAPS_MODULATEALPHA_ADDCOLOR     = $00020000;
  D3DTEXOPCAPS_MODULATECOLOR_ADDALPHA     = $00040000;
  D3DTEXOPCAPS_MODULATEINVALPHA_ADDCOLOR  = $00080000;
  D3DTEXOPCAPS_MODULATEINVCOLOR_ADDALPHA  = $00100000;
  D3DTEXOPCAPS_BUMPENVMAP                 = $00200000;
  D3DTEXOPCAPS_BUMPENVMAPLUMINANCE        = $00400000;
  D3DTEXOPCAPS_DOTPRODUCT3                = $00800000;
  D3DTEXOPCAPS_MULTIPLYADD                = $01000000;
  D3DTEXOPCAPS_LERP                       = $02000000;

//
// FVFCaps
//
  D3DFVFCAPS_TEXCOORDCOUNTMASK    = $0000ffff; (* mask for texture coordinate count field *)
  D3DFVFCAPS_DONOTSTRIPELEMENTS   = $00080000; (* Device prefers that vertex elements not be stripped *)
  D3DFVFCAPS_PSIZE                = $00100000; (* Device can receive point size *)

//
// VertexProcessingCaps
//
  D3DVTXPCAPS_TEXGEN              = $00000001; (* device can do texgen *)
  D3DVTXPCAPS_MATERIALSOURCE7     = $00000002; (* device can do DX7-level colormaterialsource ops *)
  D3DVTXPCAPS_DIRECTIONALLIGHTS   = $00000008; (* device can do directional lights *)
  D3DVTXPCAPS_POSITIONALLIGHTS    = $00000010; (* device can do positional lights (includes point and spot) *)
  D3DVTXPCAPS_LOCALVIEWER         = $00000020; (* device can do local viewer *)
  D3DVTXPCAPS_TWEENING            = $00000040; (* device can do vertex tweening *)
  D3DVTXPCAPS_NO_VSDT_UBYTE4      = $00000080; (* device does not support D3DVSDT_UBYTE4 *)

   {$MINENUMSIZE 1} // Forces TD3DQueryType be 1 byte

  type _D3DQUERYTYPE = (
    D3DQUERYTYPE_VCACHE                 = 4, { D3DISSUE_END }
    D3DQUERYTYPE_RESOURCEMANAGER        = 5, { D3DISSUE_END }
    D3DQUERYTYPE_VERTEXSTATS            = 6, { D3DISSUE_END }
    D3DQUERYTYPE_EVENT                  = 8, { D3DISSUE_END }
    D3DQUERYTYPE_OCCLUSION              = 9  { D3DISSUE_BEGIN, D3DISSUE_END }
  );
  TD3DQueryType = _D3DQUERYTYPE;

  type
  PD3DXImageFileFormat = ^TD3DXImageFileFormat;
  _D3DXIMAGE_FILEFORMAT = (
    D3DXIFF_BMP        {= 0},
    D3DXIFF_JPG        {= 1},
    D3DXIFF_TGA        {= 2},
    D3DXIFF_PNG        {= 3},
    D3DXIFF_DDS        {= 4},
    D3DXIFF_PPM        {= 5},
    D3DXIFF_DIB        {= 6}
  );
  {$EXTERNALSYM _D3DXIMAGE_FILEFORMAT}
  D3DXIMAGE_FILEFORMAT = _D3DXIMAGE_FILEFORMAT;
  {$EXTERNALSYM D3DXIMAGE_FILEFORMAT}
  TD3DXImageFileFormat = _D3DXIMAGE_FILEFORMAT;

  type
  PD3DXImageInfo = ^TD3DXImageInfo;
  _D3DXIMAGE_INFO = packed record
    Width:      LongWord;
    Height:     LongWord;
    Depth:      LongWord;
    MipLevels:  LongWord;
    Format:     TD3DFormat;
    ResourceType: TD3DResourceType;
    ImageFileFormat: TD3DXImageFileFormat;
  end;
  {$EXTERNALSYM _D3DXIMAGE_INFO}
  D3DXIMAGE_INFO = _D3DXIMAGE_INFO;
  {$EXTERNALSYM D3DXIMAGE_INFO}
  TD3DXImageInfo = _D3DXIMAGE_INFO;

const
{$IFDEF DX8}
  D3D_SDK_VERSION = 32;
{$ELSE}
  D3D_SDK_VERSION = 32;
{$ENDIF}

type
  HMonitor = THandle;

const
  IID_IDirect3D9              : TGUID = '{81bdcbca-64d4-426d-ae8d-ad0147f4275c}';
  IID_IDirect3DDevice9        : TGUID = '{D0223B96-BF7A-43fd-92BD-A43B0D82B9EB}';
  IID_IDirect3DResource8      : TGUID = '{1B36BB7B-09B7-410a-B445-7D1430D7B33F}';
  IID_IDirect3DBaseTexture8   : TGUID = '{B4211CFA-51B9-4a9f-AB78-DB99B2BB678E}';
  IID_IDirect3DTexture8       : TGUID = '{E4CDD575-2866-4f01-B12E-7EECE1EC9358}';
  IID_IDirect3DCubeTexture8   : TGUID = '{3EE5B968-2ACA-4c34-8BB5-7E0C3D19B750}';
  IID_IDirect3DVolumeTexture8 : TGUID = '{4B8AAAFA-140F-42ba-9131-597EAFAA2EAD}';
  IID_IDirect3DVertexBuffer8  : TGUID = '{8AEEEAC7-05F9-44d4-B591-000B0DF1CB95}';
  IID_IDirect3DIndexBuffer8   : TGUID = '{0E689C9A-053D-44a0-9D92-DB0E3D750F86}';
  IID_IDirect3DSurface9       : TGUID = '{B96EEBCA-B326-4ea5-882F-2FF5BAE021DD}';
  IID_IDirect3DVolume8        : TGUID = '{BD7349F5-14F1-42e4-9C79-972380DB40C0}';
  IID_IDirect3DSwapChain8     : TGUID = '{928C088B-76B9-4C6B-A536-A590853876CD}';

(*
 * Direct3D interfaces
 *)
 type
  _D3DDECLTYPE = (
  {$IFNDEF COMPILER6_UP}
    D3DDECLTYPE_FLOAT1   {=  0}, // 1D float expanded to (value, 0., 0., 1.)
    D3DDECLTYPE_FLOAT2   {=  1}, // 2D float expanded to (value, value, 0., 1.)
    D3DDECLTYPE_FLOAT3   {=  2}, // 3D float expanded to (value, value, value, 1.)
    D3DDECLTYPE_FLOAT4   {=  3}, // 4D float
    D3DDECLTYPE_D3DCOLOR {=  4}, // 4D packed unsigned bytes mapped to 0. to 1. range
    D3DDECLTYPE_UBYTE4   {=  5}, // 4D unsigned byte
    D3DDECLTYPE_SHORT2   {=  6}, // 2D signed short expanded to (value, value, 0., 1.)
    D3DDECLTYPE_SHORT4   {=  7}, // 4D signed short
    D3DDECLTYPE_UBYTE4N  {=  8}, // Each of 4 bytes is normalized by dividing to 255.0
    D3DDECLTYPE_SHORT2N  {=  9}, // 2D signed short normalized (v[0]/32767.0,v[1]/32767.0,0,1)
    D3DDECLTYPE_SHORT4N  {= 10}, // 4D signed short normalized (v[0]/32767.0,v[1]/32767.0,v[2]/32767.0,v[3]/32767.0)
    D3DDECLTYPE_USHORT2N {= 11}, // 2D unsigned short normalized (v[0]/65535.0,v[1]/65535.0,0,1)
    D3DDECLTYPE_USHORT4N {= 12}, // 4D unsigned short normalized (v[0]/65535.0,v[1]/65535.0,v[2]/65535.0,v[3]/65535.0)
    D3DDECLTYPE_UDEC3    {= 13}, // 3D unsigned 10 10 10 format expanded to (value, value, value, 1)
    D3DDECLTYPE_DEC3N    {= 14}, // 3D signed 10 10 10 format normalized and expanded to (v[0]/511.0, v[1]/511.0, v[2]/511.0, 1)
    D3DDECLTYPE_FLOAT16_2{= 15}, // Two 16-bit floating point values, expanded to (value, value, 0, 1)
    D3DDECLTYPE_FLOAT16_4{= 16}, // Four 16-bit floating point values
    D3DDECLTYPE_UNUSED   {= 17}  // When the type field in a decl is unused.
  {$ELSE}
    D3DDECLTYPE_FLOAT1    =  0,  // 1D float expanded to (value, 0., 0., 1.)
    D3DDECLTYPE_FLOAT2    =  1,  // 2D float expanded to (value, value, 0., 1.)
    D3DDECLTYPE_FLOAT3    =  2,  // 3D float expanded to (value, value, value, 1.)
    D3DDECLTYPE_FLOAT4    =  3,  // 4D float
    D3DDECLTYPE_D3DCOLOR  =  4,  // 4D packed unsigned bytes mapped to 0. to 1. range
    D3DDECLTYPE_UBYTE4    =  5,  // 4D unsigned byte
    D3DDECLTYPE_SHORT2    =  6,  // 2D signed short expanded to (value, value, 0., 1.)
    D3DDECLTYPE_SHORT4    =  7,  // 4D signed short
    D3DDECLTYPE_UBYTE4N   =  8,  // Each of 4 bytes is normalized by dividing to 255.0
    D3DDECLTYPE_SHORT2N   =  9,  // 2D signed short normalized (v[0]/32767.0,v[1]/32767.0,0,1)
    D3DDECLTYPE_SHORT4N   = 10,  // 4D signed short normalized (v[0]/32767.0,v[1]/32767.0,v[2]/32767.0,v[3]/32767.0)
    D3DDECLTYPE_USHORT2N  = 11,  // 2D unsigned short normalized (v[0]/65535.0,v[1]/65535.0,0,1)
    D3DDECLTYPE_USHORT4N  = 12,  // 4D unsigned short normalized (v[0]/65535.0,v[1]/65535.0,v[2]/65535.0,v[3]/65535.0)
    D3DDECLTYPE_UDEC3     = 13,  // 3D unsigned 10 10 10 format expanded to (value, value, value, 1)
    D3DDECLTYPE_DEC3N     = 14,  // 3D signed 10 10 10 format normalized and expanded to (v[0]/511.0, v[1]/511.0, v[2]/511.0, 1)
    D3DDECLTYPE_FLOAT16_2 = 15,  // Two 16-bit floating point values, expanded to (value, value, 0, 1)
    D3DDECLTYPE_FLOAT16_4 = 16,  // Four 16-bit floating point values
    D3DDECLTYPE_UNUSED    = 17   // When the type field in a decl is unused.
  {$ENDIF}
  );

  type
  _D3DDECLUSAGE = (
    D3DDECLUSAGE_POSITION,      // = 0
    D3DDECLUSAGE_BLENDWEIGHT,   // 1
    D3DDECLUSAGE_BLENDINDICES,  // 2
    D3DDECLUSAGE_NORMAL,        // 3
    D3DDECLUSAGE_PSIZE,         // 4
    D3DDECLUSAGE_TEXCOORD,      // 5
    D3DDECLUSAGE_TANGENT,       // 6
    D3DDECLUSAGE_BINORMAL,      // 7
    D3DDECLUSAGE_TESSFACTOR,    // 8
    D3DDECLUSAGE_POSITIONT,     // 9
    D3DDECLUSAGE_COLOR,         // 10
    D3DDECLUSAGE_FOG,           // 11
    D3DDECLUSAGE_DEPTH,         // 12
    D3DDECLUSAGE_SAMPLE         // 13
  );
  {$EXTERNALSYM _D3DDECLUSAGE}
  D3DDECLUSAGE = _D3DDECLUSAGE;
  {$EXTERNALSYM D3DDECLUSAGE}
  TD3DDeclUsage = _D3DDECLUSAGE;

 type
  _D3DDECLMETHOD = (
    D3DDECLMETHOD_DEFAULT,    // = 0,
    D3DDECLMETHOD_PARTIALU,
    D3DDECLMETHOD_PARTIALV,
    D3DDECLMETHOD_CROSSUV,    // Normal
    D3DDECLMETHOD_UV,
    D3DDECLMETHOD_LOOKUP,               // Lookup a displacement map
    D3DDECLMETHOD_LOOKUPPRESAMPLED      // Lookup a pre-sampled displacement map
  );
  {$EXTERNALSYM _D3DDECLMETHOD}
  D3DDECLMETHOD = _D3DDECLMETHOD;
  {$EXTERNALSYM D3DDECLMETHOD}
  TD3DDeclMethod = _D3DDECLMETHOD;

type
   TD3DDeclType = _D3DDECLTYPE;
  PD3DVertexElement9 = ^TD3DVertexElement9;
  _D3DVERTEXELEMENT9 = packed record
    Stream:     Word;                 // Stream index
    Offset:     Word;                 // Offset in the stream in bytes
    _Type:      TD3DDeclType{Byte};   // Data type
    Method:     TD3DDeclMethod{Byte}; // Processing method
    Usage:      TD3DDeclUsage{Byte};  // Semantics
    UsageIndex: Byte;                 // Semantic index
  end;
  {$EXTERNALSYM _D3DVERTEXELEMENT9}
  D3DVERTEXELEMENT9 = _D3DVERTEXELEMENT9;
  {$EXTERNALSYM D3DVERTEXELEMENT9}
  TD3DVertexElement9 = _D3DVERTEXELEMENT9;
type
  (*$HPPEMIT 'typedef D3DXQUATERNION TD3DXQuaternion;' *)
  PD3DXQuaternion = ^TD3DXQuaternion;
  TD3DXQuaternion = packed record
    x, y, z, w: Single;
  end;
  {$NODEFINE TD3DXQuaternion}



type
  IDirect3D9                        = interface;
  IDirect3DDevice9                  = interface;
  IDirect3DStateBlock9              = interface;
  IDirect3DVertexDeclaration9       = interface;
  IDirect3DResource9                = interface;
  IDirect3DBaseTexture9             = interface;
  IDirect3DTexture9                 = interface;
  IDirect3DVolumeTexture9           = interface;
  IDirect3DCubeTexture9             = interface;
  IDirect3DVertexBuffer9            = interface;
  IDirect3DIndexBuffer9             = interface;
  IDirect3DSurface9                 = interface;
  IDirect3DVolume9                  = interface;
  IDirect3DVertexShader9            = interface;
  IDirect3DPixelShader9             = interface;
  IDirect3DSwapChain9               = interface;
  IDirect3DQuery9                   = interface;


  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3D9);'}
  {$EXTERNALSYM IDirect3D9}
  IDirect3D9 = interface(IUnknown)
    ['{81BDCBCA-64D4-426d-AE8D-AD0147F4275C}']
    (*** IDirect3D9 methods ***)
    function RegisterSoftwareDevice(pInitializeFunction: Pointer): HResult; stdcall;
    function GetAdapterCount: LongWord; stdcall;
    function GetAdapterIdentifier(Adapter: LongWord; Flags: DWord; out pIdentifier: TD3DAdapterIdentifier9): HResult; stdcall;
    function GetAdapterModeCount(Adapter: LongWord; Format: TD3DFormat): LongWord; stdcall;
    function EnumAdapterModes(Adapter: LongWord; Format: TD3DFormat; Mode: LongWord; out pMode: TD3DDisplayMode): HResult; stdcall;
    function GetAdapterDisplayMode(Adapter: LongWord; out pMode: TD3DDisplayMode): HResult; stdcall;
    function CheckDeviceType(Adapter: LongWord; CheckType: TD3DDevType; DisplayFormat, BackBufferFormat: TD3DFormat; Windowed: BOOL): HResult; stdcall;
    function CheckDeviceFormat(Adapter: LongWord; DeviceType: TD3DDevType; AdapterFormat: TD3DFormat; Usage: DWord; RType: TD3DResourceType; CheckFormat: TD3DFormat): HResult; stdcall;
    function CheckDeviceMultiSampleType(Adapter: LongWord; DeviceType: TD3DDevType; SurfaceFormat: TD3DFormat; Windowed: BOOL; MultiSampleType: TD3DMultiSampleType; pQualityLevels: PDWORD): HResult; stdcall;
    function CheckDepthStencilMatch(Adapter: LongWord; DeviceType: TD3DDevType; AdapterFormat, RenderTargetFormat, DepthStencilFormat: TD3DFormat): HResult; stdcall;
    function CheckDeviceFormatConversion(Adapter: LongWord; DeviceType: TD3DDevType; SourceFormat, TargetFormat: TD3DFormat): HResult; stdcall;
    function GetDeviceCaps(Adapter: LongWord; DeviceType: TD3DDevType; out pCaps: TD3DCaps9): HResult; stdcall;
    function GetAdapterMonitor(Adapter: LongWord): HMONITOR; stdcall;
    function CreateDevice(Adapter: LongWord; DeviceType: TD3DDevType; hFocusWindow: HWND; BehaviorFlags: DWord; pPresentationParameters: PD3DPresentParameters; out ppReturnedDeviceInterface: IDirect3DDevice9): HResult; stdcall;
  end;

    {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DDevice9);'}
  {$EXTERNALSYM IDirect3DDevice9}

  IDirect3DDevice9 = interface(IUnknown)
    ['{D0223B96-BF7A-43fd-92BD-A43B0D82B9EB}']
    (*** IDirect3DDevice9 methods ***)
    function TestCooperativeLevel: HResult; stdcall;
    function GetAvailableTextureMem: LongWord; stdcall;
    function EvictManagedResources: HResult; stdcall;
    function GetDirect3D(out ppD3D9: IDirect3D9): HResult; stdcall;
    function GetDeviceCaps(out pCaps: TD3DCaps9): HResult; stdcall;
    function GetDisplayMode(iSwapChain: LongWord; out pMode: TD3DDisplayMode): HResult; stdcall;
    function GetCreationParameters(out pParameters: TD3DDeviceCreationParameters): HResult; stdcall;
    function SetCursorProperties(XHotSpot, YHotSpot: LongWord; pCursorBitmap: IDirect3DSurface9): HResult; stdcall;
    procedure SetCursorPosition(XScreenSpace, YScreenSpace: LongWord; Flags: DWord); stdcall;
    function ShowCursor(bShow: BOOL): BOOL; stdcall;
    function CreateAdditionalSwapChain(const pPresentationParameters: TD3DPresentParameters; out pSwapChain: IDirect3DSwapChain9): HResult; stdcall;
    function GetSwapChain(iSwapChain: LongWord; out pSwapChain: IDirect3DSwapChain9): HResult; stdcall;
    function GetNumberOfSwapChains: LongWord; stdcall;
    function Reset(const pPresentationParameters: TD3DPresentParameters): HResult; stdcall;
    function Present(pSourceRect, pDestRect: PRect; hDestWindowOverride: HWND; pDirtyRegion: PRgnData): HResult; stdcall;
    function GetBackBuffer(iSwapChain: LongWord; iBackBuffer: LongWord; _Type: TD3DBackBufferType; out ppBackBuffer: IDirect3DSurface9): HResult; stdcall;
    function GetRasterStatus(iSwapChain: LongWord; out pRasterStatus: TD3DRasterStatus): HResult; stdcall;
    function SetDialogBoxMode(bEnableDialogs: BOOL): HResult; stdcall;
    procedure SetGammaRamp(iSwapChain: LongWord; Flags: DWord; const pRamp: TD3DGammaRamp); stdcall;
    procedure GetGammaRamp(iSwapChain: LongWord; out pRamp: TD3DGammaRamp); stdcall;
    function CreateTexture(Width, Height, Levels: LongWord; Usage: DWord; Format: TD3DFormat; Pool: TD3DPool; out ppTexture: IDirect3DTexture9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateVolumeTexture(Width, Height, Depth, Levels: LongWord; Usage: DWord; Format: TD3DFormat; Pool: TD3DPool; out ppVolumeTexture: IDirect3DVolumeTexture9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateCubeTexture(EdgeLength, Levels: LongWord; Usage: DWord; Format: TD3DFormat; Pool: TD3DPool; out ppCubeTexture: IDirect3DCubeTexture9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateVertexBuffer(Length: LongWord; Usage, FVF: DWord; Pool: TD3DPool; out ppVertexBuffer: IDirect3DVertexBuffer9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateIndexBuffer(Length: LongWord; Usage: DWord; Format: TD3DFormat; Pool: TD3DPool; out ppIndexBuffer: IDirect3DIndexBuffer9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateRenderTarget(Width, Height: LongWord; Format: TD3DFormat; MultiSample: TD3DMultiSampleType; MultisampleQuality: DWORD; Lockable: BOOL; out ppSurface: IDirect3DSurface9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateDepthStencilSurface(Width, Height: LongWord; Format: TD3DFormat; MultiSample: TD3DMultiSampleType; MultisampleQuality: DWORD; Discard: BOOL; out ppSurface: IDirect3DSurface9; pSharedHandle: PHandle): HResult; stdcall;
    function UpdateSurface(pSourceSurface: IDirect3DSurface9; pSourceRect: PRect; pDestinationSurface: IDirect3DSurface9; pDestPoint: PPoint): HResult; stdcall;
    function UpdateTexture(pSourceTexture, pDestinationTexture: IDirect3DBaseTexture9): HResult; stdcall;
    function GetRenderTargetData(pRenderTarget, pDestSurface: IDirect3DSurface9): HResult; stdcall;


    function GetFrontBufferData(iSwapChain: LongWord; pDestSurface: IDirect3DSurface9): HResult; stdcall;


    function StretchRect(pSourceSurface: IDirect3DSurface9; pSourceRect: PRect; pDestSurface: IDirect3DSurface9; pDestRect: PRect; Filter: TD3DTextureFilterType): HResult; stdcall;


    function ColorFill(pSurface: IDirect3DSurface9; pRect: PRect; color: TD3DColor): HResult; stdcall;


    function CreateOffscreenPlainSurface(Width, Height: LongWord; Format: TD3DFormat; Pool: TD3DPool; out ppSurface: IDirect3DSurface9; pSharedHandle: PHandle): HResult; stdcall;


    function SetRenderTarget(RenderTargetIndex: DWORD; pRenderTarget: IDirect3DSurface9): HResult; stdcall;


    function GetRenderTarget(RenderTargetIndex: DWORD; out ppRenderTarget: IDirect3DSurface9): HResult; stdcall;


    function SetDepthStencilSurface(pNewZStencil: IDirect3DSurface9): HResult; stdcall;


    function GetDepthStencilSurface(out ppZStencilSurface: IDirect3DSurface9): HResult; stdcall;


    function BeginScene: HResult; stdcall;


    function EndScene: HResult; stdcall;


    function Clear(Count: DWord; pRects: PD3DRect; Flags: DWord; Color: TD3DColor; Z: Single; Stencil: DWord): HResult; stdcall;


    function SetTransform(State: TD3DTransformStateType; const pMatrix: TD3DMatrix): HResult; stdcall;


    function GetTransform(State: TD3DTransformStateType; out pMatrix: TD3DMatrix): HResult; stdcall;


    function MultiplyTransform(State: TD3DTransformStateType; const pMatrix: TD3DMatrix): HResult; stdcall;


    function SetViewport(const pViewport: TD3DViewport9): HResult; stdcall;


    function GetViewport(out pViewport: TD3DViewport9): HResult; stdcall;


    function SetMaterial(const pMaterial: TD3DMaterial9): HResult; stdcall;


    function GetMaterial(out pMaterial: TD3DMaterial9): HResult; stdcall;


    function SetLight(Index: DWord; const pLight: TD3DLight9): HResult; stdcall;


    function GetLight(Index: DWord; out pLight: TD3DLight9): HResult; stdcall;


    function LightEnable(Index: DWord; Enable: BOOL): HResult; stdcall;


    function GetLightEnable(Index: DWord; out pEnable: BOOL): HResult; stdcall;


    function SetClipPlane(Index: DWord; pPlane: PSingle): HResult; stdcall;


    function GetClipPlane(Index: DWord; pPlane: PSingle): HResult; stdcall;


    function SetRenderState(State: TD3DRenderStateType; Value: DWord): HResult; stdcall;


    function GetRenderState(State: TD3DRenderStateType; out pValue: DWord): HResult; stdcall;


    function CreateStateBlock(_Type: TD3DStateBlockType; out ppSB: IDirect3DStateBlock9): HResult; stdcall;


    function BeginStateBlock: HResult; stdcall;

    function EndStateBlock(out ppSB: IDirect3DStateBlock9): HResult; stdcall;

    function SetClipStatus(const pClipStatus: TD3DClipStatus9): HResult; stdcall;

    function GetClipStatus(out pClipStatus: TD3DClipStatus9): HResult; stdcall;

    function GetTexture(Stage: DWord; out ppTexture: IDirect3DBaseTexture9): HResult; stdcall;


    function SetTexture(Stage: DWord; pTexture: IDirect3DBaseTexture9): HResult; stdcall;


    function GetTextureStageState(Stage: DWord; _Type: TD3DTextureStageStateType; out pValue: DWord): HResult; stdcall;


    function SetTextureStageState(Stage: DWord; _Type: TD3DTextureStageStateType; Value: DWord): HResult; stdcall;


    function GetSamplerState(Sampler: DWORD; _Type: TD3DSamplerStateType; out pValue: DWORD): HResult; stdcall;


    function SetSamplerState(Sampler: DWORD; _Type: TD3DSamplerStateType; Value: DWORD): HResult; stdcall;


    function ValidateDevice(out pNumPasses: DWord): HResult; stdcall;


    function SetPaletteEntries(PaletteNumber: LongWord; pEntries: pPaletteEntry): HResult; stdcall;


    function GetPaletteEntries(PaletteNumber: LongWord; pEntries: pPaletteEntry): HResult; stdcall;


    function SetCurrentTexturePalette(PaletteNumber: LongWord): HResult; stdcall;


    function GetCurrentTexturePalette(out PaletteNumber: LongWord): HResult; stdcall;


    function SetScissorRect(pRect: PRect): HResult; stdcall;


    function GetScissorRect(out pRect: TRect): HResult; stdcall;


    function SetSoftwareVertexProcessing(bSoftware: BOOL): HResult; stdcall;


    function GetSoftwareVertexProcessing: BOOL; stdcall;


    function SetNPatchMode(nSegments: Single): HResult; stdcall;


    function GetNPatchMode: Single; stdcall;


    function DrawPrimitive(PrimitiveType: TD3DPrimitiveType; StartVertex, PrimitiveCount: LongWord): HResult; stdcall;


    function DrawIndexedPrimitive(_Type: TD3DPrimitiveType; BaseVertexIndex: Integer; MinVertexIndex, NumVertices, startIndex, primCount: LongWord): HResult; stdcall;


    function DrawPrimitiveUP(PrimitiveType: TD3DPrimitiveType; PrimitiveCount: LongWord; const pVertexStreamZeroData; VertexStreamZeroStride: LongWord): HResult; stdcall;


    function DrawIndexedPrimitiveUP(PrimitiveType: TD3DPrimitiveType; MinVertexIndex, NumVertice, PrimitiveCount: LongWord; const pIndexData; IndexDataFormat: TD3DFormat; const pVertexStreamZeroData; VertexStreamZeroStride: LongWord): HResult; stdcall;


    function ProcessVertices(SrcStartIndex, DestIndex, VertexCount: LongWord; pDestBuffer: IDirect3DVertexBuffer9; pVertexDecl: IDirect3DVertexDeclaration9; Flags: DWord): HResult; stdcall;


    function CreateVertexDeclaration(pVertexElements: PD3DVertexElement9; out ppDecl: IDirect3DVertexDeclaration9): HResult; stdcall;


    function SetVertexDeclaration(pDecl: IDirect3DVertexDeclaration9): HResult; stdcall;


    function GetVertexDeclaration(out ppDecl: IDirect3DVertexDeclaration9): HResult; stdcall;


    function SetFVF(FVF: DWORD): HResult; stdcall;


    function GetFVF(out FVF: DWORD): HResult; stdcall;


    function CreateVertexShader(pFunction: PDWord; out ppShader: IDirect3DVertexShader9): HResult; stdcall;


    function SetVertexShader(pShader: IDirect3DVertexShader9): HResult; stdcall;


    function GetVertexShader(out ppShader: IDirect3DVertexShader9): HResult; stdcall;


    function SetVertexShaderConstantF(StartRegister: LongWord; pConstantData: PSingle; Vector4fCount: LongWord): HResult; stdcall;


    function GetVertexShaderConstantF(StartRegister: LongWord; pConstantData: PSingle; Vector4fCount: LongWord): HResult; stdcall;


    function SetVertexShaderConstantI(StartRegister: LongWord; pConstantData: PInteger; Vector4iCount: LongWord): HResult; stdcall;


    function GetVertexShaderConstantI(StartRegister: LongWord; pConstantData: PInteger; Vector4iCount: LongWord): HResult; stdcall;


    function SetVertexShaderConstantB(StartRegister: LongWord; pConstantData: PBOOL; BoolCount: LongWord): HResult; stdcall;


    function GetVertexShaderConstantB(StartRegister: LongWord; pConstantData: PBOOL; BoolCount: LongWord): HResult; stdcall;


    function SetStreamSource(StreamNumber: LongWord; pStreamData: IDirect3DVertexBuffer9; OffsetInBytes, Stride: LongWord): HResult; stdcall;


    function GetStreamSource(StreamNumber: LongWord; out ppStreamData: IDirect3DVertexBuffer9; out OffsetInBytes, pStride: LongWord): HResult; stdcall;


    function SetStreamSourceFreq(StreamNumber: LongWord; Divider: LongWord): HResult; stdcall;


    function GetStreamSourceFreq(StreamNumber: LongWord; out Divider: LongWord): HResult; stdcall;


    function SetIndices(pIndexData: IDirect3DIndexBuffer9): HResult; stdcall;


    function GetIndices(out ppIndexData: IDirect3DIndexBuffer9): HResult; stdcall;


    function CreatePixelShader(pFunction: PDWord; out ppShader: IDirect3DPixelShader9): HResult; stdcall;


    function SetPixelShader(pShader: IDirect3DPixelShader9): HResult; stdcall;


    function GetPixelShader(out ppShader: IDirect3DPixelShader9): HResult; stdcall;


    function SetPixelShaderConstantF(StartRegister: LongWord; pConstantData: PSingle; Vector4fCount: LongWord): HResult; stdcall;


    function GetPixelShaderConstantF(StartRegister: LongWord; pConstantData: PSingle; Vector4fCount: LongWord): HResult; stdcall;


    function SetPixelShaderConstantI(StartRegister: LongWord; pConstantData: PInteger; Vector4iCount: LongWord): HResult; stdcall;


    function GetPixelShaderConstantI(StartRegister: LongWord; pConstantData: PInteger; Vector4iCount: LongWord): HResult; stdcall;


    function SetPixelShaderConstantB(StartRegister: LongWord; pConstantData: PBOOL; BoolCount: LongWord): HResult; stdcall;


    function GetPixelShaderConstantB(StartRegister: LongWord; pConstantData: PBOOL; BoolCount: LongWord): HResult; stdcall;


    function DrawRectPatch(Handle: LongWord; pNumSegs: PSingle; pTriPatchInfo: PD3DRectPatchInfo): HResult; stdcall;


    function DrawTriPatch(Handle: LongWord; pNumSegs: PSingle; pTriPatchInfo: PD3DTriPatchInfo): HResult; stdcall;


    function DeletePatch(Handle: LongWord): HResult; stdcall;


    function CreateQuery(_Type: TD3DQueryType; out ppQuery: IDirect3DQuery9): HResult; stdcall;


  end;

  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DSwapChain9);'}
  {$EXTERNALSYM IDirect3DSwapChain9}
  IDirect3DSwapChain9 = interface(IUnknown)
    ['{794950F2-ADFC-458a-905E-10A10B0B503B}']
    (*** IDirect3DSwapChain9 methods ***)
    function Present(pSourceRect, pDestRect: PRect; hDestWindowOverride: HWND; pDirtyRegion: PRgnData; dwFlags: DWORD): HResult; stdcall;
    function GetFrontBufferData(pDestSurface: IDirect3DSurface9): HResult; stdcall;
    function GetBackBuffer(iBackBuffer: LongWord; _Type: TD3DBackBufferType; out ppBackBuffer: IDirect3DSurface9): HResult; stdcall;
    function GetRasterStatus(out pRasterStatus: TD3DRasterStatus): HResult; stdcall;
    function GetDisplayMode(out pMode: TD3DDisplayMode): HResult; stdcall;
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function GetPresentParameters(out pPresentationParameters: TD3DPresentParameters): HResult; stdcall;
  end;

  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DStateBlock9);'}
  {$EXTERNALSYM IDirect3DStateBlock9}
  IDirect3DStateBlock9 = interface(IUnknown)
    ['{B07C4FE5-310D-4ba8-A23C-4F0F206F218B}']
     (*** IDirect3DStateBlock9 methods ***)
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function Capture: HResult; stdcall;
    function Apply: HResult; stdcall;
  end;


  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DVertexShader9);'}
  {$EXTERNALSYM IDirect3DVertexShader9}
  IDirect3DVertexShader9 = interface(IUnknown)
    ['{EFC5557E-6265-4613-8A94-43857889EB36}']
    (*** IDirect3DVertexShader9 methods ***)
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function GetFunction(pData: Pointer; out pSizeOfData: LongWord): HResult; stdcall;
  end;



  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DPixelShader9);'}
  {$EXTERNALSYM IDirect3DPixelShader9}
  IDirect3DPixelShader9 = interface(IUnknown)

    ['{6D3BDBDC-5B02-4415-B852-CE5E8BCCB289}']
    (*** IDirect3DPixelShader9 methods ***)
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function GetFunction(pData: Pointer; out pSizeOfData: LongWord): HResult; stdcall;
  end;

  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DVertexDeclaration9);'}
  {$EXTERNALSYM IDirect3DVertexDeclaration9}
  IDirect3DVertexDeclaration9 = interface(IUnknown)
    ['{DD13C59C-36FA-4098-A8FB-C7ED39DC8546}']
    (*** IDirect3DVertexDeclaration9 methods ***)
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function GetDeclaration(pDecl: PD3DVertexElement9; out pNumElements: LongWord): HResult; stdcall;
  end;


  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DResource9);'}
  {$EXTERNALSYM IDirect3DResource9}
  IDirect3DResource9 = interface(IUnknown)
    ['{05EEC05D-8F7D-4362-B999-D1BAF357C704}']
    (*** IDirect3DResource9 methods ***)
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function SetPrivateData(const refguid: TGUID; const pData; SizeOfData, Flags: DWord): HResult; stdcall;
    function GetPrivateData(const refguid: TGUID; pData: Pointer; out pSizeOfData: DWord): HResult; stdcall;
    function FreePrivateData(const refguid: TGUID): HResult; stdcall;
    function SetPriority(PriorityNew: DWord): DWord; stdcall;
    function GetPriority: DWord; stdcall;
    procedure PreLoad; stdcall;
    function GetType: TD3DResourceType; stdcall;
  end;


  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DBaseTexture9);'}
  {$EXTERNALSYM IDirect3DBaseTexture9}
  IDirect3DBaseTexture9 = interface(IDirect3DResource9)
    ['{580CA87E-1D3C-4d54-991D-B7D3E3C298CE}']
    (*** IDirect3DBaseTexture9 methods ***)
    function SetLOD(LODNew: DWord): DWord; stdcall;
    function GetLOD: DWord; stdcall;
    function GetLevelCount: DWord; stdcall;
    function SetAutoGenFilterType(FilterType: TD3DTextureFilterType): HResult; stdcall;
    function GetAutoGenFilterType: TD3DTextureFilterType; stdcall;
    procedure GenerateMipSubLevels;
  end;

  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DTexture9);'}
  {$EXTERNALSYM IDirect3DTexture9}
  IDirect3DTexture9 = interface(IDirect3DBaseTexture9)
    ['{85C31227-3DE5-4f00-9B3A-F11AC38C18B5}']
    (*** IDirect3DTexture9 methods ***)
    function GetLevelDesc(Level: LongWord; out pDesc: TD3DSurfaceDesc): HResult; stdcall;
    function GetSurfaceLevel(Level: LongWord; out ppSurfaceLevel: IDirect3DSurface9): HResult; stdcall;
    function LockRect(Level: LongWord; out pLockedRect: TD3DLockedRect; pRect: PRect; Flags: DWord): HResult; stdcall;
    function UnlockRect(Level: LongWord): HResult; stdcall;
    function AddDirtyRect(pDirtyRect: PRect): HResult; stdcall;
  end;



  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DVolumeTexture9);'}
  {$EXTERNALSYM IDirect3DVolumeTexture9}
  IDirect3DVolumeTexture9 = interface(IDirect3DBaseTexture9)
    ['{2518526C-E789-4111-A7B9-47EF328D13E6}']
    (*** IDirect3DVolumeTexture9 methods ***)
    function GetLevelDesc(Level: LongWord; out pDesc: TD3DVolumeDesc): HResult; stdcall;
    function GetVolumeLevel(Level: LongWord; out ppVolumeLevel: IDirect3DVolume9): HResult; stdcall;
    function LockBox(Level: LongWord; out pLockedVolume: TD3DLockedBox; pBox: PD3DBox; Flags: DWord): HResult; stdcall;
    function UnlockBox(Level: LongWord): HResult; stdcall;
    function AddDirtyBox(pDirtyBox: PD3DBox): HResult; stdcall;
  end;

  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DCubeTexture9);'}
  {$EXTERNALSYM IDirect3DCubeTexture9}
  IDirect3DCubeTexture9 = interface(IDirect3DBaseTexture9)
    ['{FFF32F81-D953-473a-9223-93D652ABA93F}']
    (*** IDirect3DCubeTexture9 methods ***)
    function GetLevelDesc(Level: LongWord; out pDesc: TD3DSurfaceDesc): HResult; stdcall;
    function GetCubeMapSurface(FaceType: TD3DCubeMapFaces; Level: LongWord; out ppCubeMapSurface: IDirect3DSurface9): HResult; stdcall;
    function LockRect(FaceType: TD3DCubeMapFaces; Level: LongWord; out pLockedRect: TD3DLockedRect; pRect: PRect; Flags: DWord): HResult; stdcall;
    function UnlockRect(FaceType: TD3DCubeMapFaces; Level: LongWord): HResult; stdcall;
    function AddDirtyRect(FaceType: TD3DCubeMapFaces; pDirtyRect: PRect): HResult; stdcall;
  end;


  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DVertexBuffer9);'}
  {$EXTERNALSYM IDirect3DVertexBuffer9}
  IDirect3DVertexBuffer9 = interface(IDirect3DResource9)
    ['{B64BB1B5-FD70-4df6-BF91-19D0A12455E3}']
    (*** IDirect3DVertexBuffer9 methods ***)
    function Lock(OffsetToLock, SizeToLock: LongWord; out ppbData: PBYTE; Flags: DWord): HResult; stdcall;
    function Unlock: HResult; stdcall;
    function GetDesc(out pDesc: TD3DVertexBufferDesc): HResult; stdcall;
  end;

  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DIndexBuffer9);'}
  {$EXTERNALSYM IDirect3DIndexBuffer9}
  IDirect3DIndexBuffer9 = interface(IDirect3DResource9)
    ['{7C9DD65E-D3F7-4529-ACEE-785830ACDE35}']
    (*** IDirect3DIndexBuffer9 methods ***)
    function Lock(OffsetToLock, SizeToLock: DWord; out ppbData: PBYTE; Flags: DWord): HResult; stdcall;
    function Unlock: HResult; stdcall;
    function GetDesc(out pDesc: TD3DIndexBufferDesc): HResult; stdcall;
  end;


  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DSurface9);'}
  {$EXTERNALSYM IDirect3DSurface9}
  IDirect3DSurface9 = interface(IDirect3DResource9)
    ['{0CFBAF3A-9FF6-429a-99B3-A2796AF8B89B}']
    (*** IDirect3DSurface9 methods ***)
    function GetContainer(const riid: TGUID; out ppContainer: Pointer): HResult; stdcall;
    function GetDesc(out pDesc: TD3DSurfaceDesc): HResult; stdcall;
    function LockRect(out pLockedRect: TD3DLockedRect; pRect: PRect; Flags: DWord): HResult; stdcall;
    function UnlockRect: HResult; stdcall;
    function GetDC(out phdc: HDC): HResult; stdcall;
    function ReleaseDC(hdc: HDC): HResult; stdcall;
  end;


  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DVolume9);'}
  {$EXTERNALSYM IDirect3DVolume9}
  IDirect3DVolume9 = interface (IUnknown)
    ['{24F416E6-1F67-4aa7-B88E-D33F6F3128A1}']
    (*** IDirect3DVolume9 methods ***)
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function SetPrivateData(const refguid: TGUID; const pData; SizeOfData, Flags: DWord): HResult; stdcall;
    function GetPrivateData(const refguid: TGUID; pData: Pointer; out pSizeOfData: DWord): HResult; stdcall;
    function FreePrivateData(const refguid: TGUID): HResult; stdcall;
    function GetContainer(const riid: TGUID; var ppContainer: Pointer): HResult; stdcall;
    function GetDesc(out pDesc: TD3DVolumeDesc): HResult; stdcall;
    function LockBox(out pLockedVolume: TD3DLockedBox; pBox: PD3DBox; Flags: DWord): HResult; stdcall;
    function UnlockBox: HResult; stdcall;
  end;

  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IDirect3DQuery9);'}
  {$EXTERNALSYM IDirect3DQuery9}
  IDirect3DQuery9 = interface(IUnknown)
    ['{d9771460-a695-4f26-bbd3-27b840b541cc}']
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function GetType: TD3DQueryType; stdcall;
    function GetDataSize: DWORD; stdcall;
    function Issue(dwIssueFlags: DWORD): HResult; stdcall;
    function GetData(pData: Pointer; dwSize: DWORD; dwGetDataFlags: DWORD): HResult; stdcall;
  end;

(****************************************************************************
 * Flags for SetPrivateData method on all D3D8 interfaces
 *
 * The passed pointer is an IUnknown ptr. The SizeOfData argument to SetPrivateData
 * must be set to sizeof( IUnknown* ). Direct3D will call AddRef through this
 * pointer and Release when the private data is destroyed. The data will be
 * destroyed when another SetPrivateData with the same GUID is set, when
 * FreePrivateData is called, or when the D3D8 object is freed.
 ****************************************************************************)
const
  D3DSPD_IUNKNOWN                         = $00000001;

(****************************************************************************
 *
 * Parameter for IDirect3D8 Enum and GetCaps8 functions to get the info for
 * the current mode only.
 *
 ****************************************************************************)

  D3DCURRENT_DISPLAY_MODE                 = $00EFFFFF;

(****************************************************************************
 *
 * Flags for IDirect3D8::CreateDevice's BehaviorFlags
 *
 ****************************************************************************)

  D3DCREATE_FPU_PRESERVE                  = $00000002;
  D3DCREATE_MULTITHREADED                 = $00000004;

  D3DCREATE_PUREDEVICE                    = $00000010;
  D3DCREATE_SOFTWARE_VERTEXPROCESSING     = $00000020;
  D3DCREATE_HARDWARE_VERTEXPROCESSING     = $00000040;
  D3DCREATE_MIXED_VERTEXPROCESSING        = $00000080;
{$IFNDEF DX8}
  D3DCREATE_DISABLE_DRIVER_MANAGEMENT     = $00000100;
{$ENDIF}

(****************************************************************************
 *
 * Parameter for IDirect3D8::CreateDevice's iAdapter
 *
 ****************************************************************************)

  D3DADAPTER_DEFAULT                      = 0;

(****************************************************************************
 *
 * Flags for IDirect3D8::EnumAdapters
 *
 ****************************************************************************)

  D3DENUM_NO_WHQL_LEVEL                   = $00000002;

(****************************************************************************
 *
 * Maximum number of back-buffers supported in DX8
 *
 ****************************************************************************)

  D3DPRESENT_BACK_BUFFERS_MAX             = 3;

(****************************************************************************
 *
 * Flags for IDirect3DDevice8::SetGammaRamp
 *
 ****************************************************************************)

  D3DSGR_NO_CALIBRATION                  = $00000000;
  D3DSGR_CALIBRATE                       = $00000001;

(****************************************************************************
 *
 * Flags for IDirect3DDevice8::SetCursorPosition
 *
 ****************************************************************************)

  D3DCURSOR_IMMEDIATE_UPDATE             = $00000001;

(****************************************************************************
 *
 * Flags for DrawPrimitive/DrawIndexedPrimitive
 *   Also valid for Begin/BeginIndexed
 *   Also valid for VertexBuffer::CreateVertexBuffer
 ****************************************************************************)

const
  _FACD3D = $876;
  MAKE_D3DHRESULT = (1 shl 31) or (_FACD3D shl 16);


  D3D_OK                                  = S_OK;

  D3DERR_WRONGTEXTUREFORMAT               = HResult(MAKE_D3DHRESULT + 2072);
  D3DERR_UNSUPPORTEDCOLOROPERATION        = HResult(MAKE_D3DHRESULT + 2073);
  D3DERR_UNSUPPORTEDCOLORARG              = HResult(MAKE_D3DHRESULT + 2074);
  D3DERR_UNSUPPORTEDALPHAOPERATION        = HResult(MAKE_D3DHRESULT + 2075);
  D3DERR_UNSUPPORTEDALPHAARG              = HResult(MAKE_D3DHRESULT + 2076);
  D3DERR_TOOMANYOPERATIONS                = HResult(MAKE_D3DHRESULT + 2077);
  D3DERR_CONFLICTINGTEXTUREFILTER         = HResult(MAKE_D3DHRESULT + 2078);
  D3DERR_UNSUPPORTEDFACTORVALUE           = HResult(MAKE_D3DHRESULT + 2079);
  D3DERR_CONFLICTINGRENDERSTATE           = HResult(MAKE_D3DHRESULT + 2081);
  D3DERR_UNSUPPORTEDTEXTUREFILTER         = HResult(MAKE_D3DHRESULT + 2082);
  D3DERR_CONFLICTINGTEXTUREPALETTE        = HResult(MAKE_D3DHRESULT + 2086);
  D3DERR_DRIVERINTERNALERROR              = HResult(MAKE_D3DHRESULT + 2087);

  D3DERR_NOTFOUND                         = HResult(MAKE_D3DHRESULT + 2150);
  D3DERR_MOREDATA                         = HResult(MAKE_D3DHRESULT + 2151);
  D3DERR_DEVICELOST                       = HResult(MAKE_D3DHRESULT + 2152);
  D3DERR_DEVICENOTRESET                   = HResult(MAKE_D3DHRESULT + 2153);
  D3DERR_NOTAVAILABLE                     = HResult(MAKE_D3DHRESULT + 2154);
  D3DERR_OUTOFVIDEOMEMORY                 = HResult(MAKE_D3DHRESULT + 380);
  D3DERR_INVALIDDEVICE                    = HResult(MAKE_D3DHRESULT + 2155);
  D3DERR_INVALIDCALL                      = HResult(MAKE_D3DHRESULT + 2156);
  D3DERR_DRIVERINVALIDCALL                = HResult(MAKE_D3DHRESULT + 2157);

function Direct3DCreate9(SDKVersion : Cardinal) : IDirect3D9;
function D3DXMatrixIdentity(out mOut: TD3DXMatrix): PD3DXMatrix;
{$EXTERNALSYM D3DXMatrixIdentity}
function D3DXMatrixIsIdentity(const m: TD3DXMatrix): BOOL;
{$EXTERNALSYM D3DXMatrixIsIdentity}
function D3DXMatrixScaling(out mOut: TD3DXMatrix; sx, sy, sz: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixScaling}
function D3DXMatrixTranslation(out mOut: TD3DXMatrix; x, y, z: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixTranslation}
function D3DXMatrixMultiply(out mOut: TD3DXMatrix; const m1, m2: TD3DXMatrix): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixMultiply}
function D3DXMatrixOrthoOffCenterLH(out mOut: TD3DXMatrix;
  l, r, b, t, zn, zf: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixOrthoOffCenterLH}
function D3DXMatrixRotationZ(out mOut: TD3DXMatrix; angle: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixRotationZ}

function D3DXCreateTexture(
  Device: IDirect3DDevice9;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  out ppTexture: IDirect3DTexture9): HResult; stdcall; external d3dx9texDLL name 'D3DXCreateTexture';
  {$EXTERNALSYM D3DXCreateTexture}
function D3DXCreateTextureFromFileA(
  Device: IDirect3DDevice9;
  pSrcFile: PAnsiChar;
  out ppTexture: IDirect3DTexture9): HResult; stdcall; external d3dx9texDLL name 'D3DXCreateTextureFromFileA';
{$EXTERNALSYM D3DXCreateTextureFromFileA}

function D3DXCreateTextureFromFileW(
  Device: IDirect3DDevice9;
  pSrcFile: PWideChar;
  out ppTexture: IDirect3DTexture9): HResult; stdcall; external d3dx9texDLL name 'D3DXCreateTextureFromFileW';
{$EXTERNALSYM D3DXCreateTextureFromFileW}

function D3DXCreateTextureFromFile(
  Device: IDirect3DDevice9;
  pSrcFile: PChar;
  out ppTexture: IDirect3DTexture9): HResult; stdcall; external d3dx9texDLL name 'D3DXCreateTextureFromFileA';
{$EXTERNALSYM D3DXCreateTextureFromFile}

function D3DXCreateTextureFromFileExA(
  Device: IDirect3DDevice9;
  pSrcFile: PAnsiChar;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture9): HResult; stdcall; external d3dx9texDLL name 'D3DXCreateTextureFromFileExA';
{$EXTERNALSYM D3DXCreateTextureFromFileExA}

function D3DXCreateTextureFromFileExW(
  Device: IDirect3DDevice9;
  pSrcFile: PWideChar;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture9): HResult; stdcall; external d3dx9texDLL name 'D3DXCreateTextureFromFileExW';
{$EXTERNALSYM D3DXCreateTextureFromFileExW}


function D3DXCreateTextureFromFileInMemoryEx(
  Device: IDirect3DDevice9;
  pSrcData:PAnsiChar;                           //2014.10.21  ґО¸´
  SrcDataSize: LongWord;
  Width: LongWord;
  Height: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture9): HResult; stdcall; external d3dx9texDLL name 'D3DXCreateTextureFromFileInMemoryEx';
{$EXTERNALSYM D3DXCreateTextureFromFileInMemoryEx}

function D3DXCreateCubeTextureFromFileInMemoryEx(
  Device: IDirect3DDevice9;
  const pSrcData;
  SrcDataSize: LongWord;
  Size: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppCubeTexture: IDirect3DCubeTexture9): HResult; stdcall; external d3dx9texDLL;
{$EXTERNALSYM D3DXCreateCubeTextureFromFileInMemoryEx}

function D3DXCreateVolumeTextureFromFileInMemoryEx(
  Device: IDirect3DDevice9;
  const pSrcData;
  SrcDataSize: LongWord;
  Width: LongWord;
  Height: LongWord;
  Depth: LongWord;
  MipLevels: LongWord;
  Usage: DWord;
  Format: TD3DFormat;
  Pool: TD3DPool;
  Filter: DWord;
  MipFilter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo;
  pPalette: PPaletteEntry;
  out ppVolumeTexture: IDirect3DVolumeTexture9): HResult; stdcall; external d3dx9texDLL;
{$EXTERNALSYM D3DXCreateVolumeTextureFromFileInMemoryEx}

function D3DXLoadSurfaceFromFileA(
  pDestSurface: IDirect3DSurface9;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  pSrcFile: PAnsiChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall; external d3dx9texDLL name 'D3DXLoadSurfaceFromFileA';
{$EXTERNALSYM D3DXLoadSurfaceFromFileA}

function D3DXLoadSurfaceFromFileW(
  pDestSurface: IDirect3DSurface9;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  pSrcFile: PWideChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall; external d3dx9texDLL name 'D3DXLoadSurfaceFromFileW';
{$EXTERNALSYM D3DXLoadSurfaceFromFileW}

function D3DXLoadSurfaceFromFile(
  pDestSurface: IDirect3DSurface9;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  pSrcFile: PChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall; external d3dx9texDLL name 'D3DXLoadSurfaceFromFileA';
{$EXTERNALSYM D3DXLoadSurfaceFromFile}

function D3DXLoadSurfaceFromResourceA(
  pDestSurface: IDirect3DSurface9;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  hSrcModule: HModule;
  pSrcResource: PAnsiChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall; external d3dx9texDLL name 'D3DXLoadSurfaceFromResourceA';
{$EXTERNALSYM D3DXLoadSurfaceFromResourceA}

function D3DXLoadSurfaceFromResourceW(
  pDestSurface: IDirect3DSurface9;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  hSrcModule: HModule;
  pSrcResource: PWideChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall; external d3dx9texDLL name 'D3DXLoadSurfaceFromResourceW';
{$EXTERNALSYM D3DXLoadSurfaceFromResourceW}

function D3DXLoadSurfaceFromResource(
  pDestSurface: IDirect3DSurface9;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  hSrcModule: HModule;
  pSrcResource: PChar;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall; external d3dx9texDLL name 'D3DXLoadSurfaceFromResourceA';
{$EXTERNALSYM D3DXLoadSurfaceFromResource}

function D3DXLoadSurfaceFromFileInMemory(
  pDestSurface: IDirect3DSurface9;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  const pSrcData;
  SrcDataSize: LongWord;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo): HResult; stdcall; external d3dx9texDLL;
{$EXTERNALSYM D3DXLoadSurfaceFromFileInMemory}

function D3DXLoadSurfaceFromMemory(
  pDestSurface: IDirect3DSurface9;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  const pSrcMemory;
  SrcFormat: TD3DFormat;
  SrcPitch: LongWord;
  pSrcPalette: PPaletteEntry;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor): HResult; stdcall; external d3dx9texDLL;
{$EXTERNALSYM D3DXLoadSurfaceFromMemory}

function D3DXLoadSurfaceFromSurface(
  pDestSurface: IDirect3DSurface9;
  pDestPalette: PPaletteEntry;
  pDestRect: PRect;
  pSrcSurface: IDirect3DSurface9;
  pSrcPalette: PPaletteEntry;
  pSrcRect: PRect;
  Filter: DWord;
  ColorKey: TD3DColor): HResult; stdcall; external d3dx9texDLL;
{$EXTERNALSYM D3DXLoadSurfaceFromSurface}

function D3DXSaveSurfaceToFileA(
  pDestFile: PAnsiChar;
  DestFormat: TD3DXImageFileFormat;
  pSrcSurface: IDirect3DSurface9;
  pSrcPalette: PPaletteEntry;
  pSrcRect: PRect): HResult; stdcall; external d3dx9texDLL name 'D3DXSaveSurfaceToFileA';
{$EXTERNALSYM D3DXSaveSurfaceToFileA}

function D3DXSaveSurfaceToFileW(
  pDestFile: PWideChar;
  DestFormat: TD3DXImageFileFormat;
  pSrcSurface: IDirect3DSurface9;
  pSrcPalette: PPaletteEntry;
  pSrcRect: PRect): HResult; stdcall; external d3dx9texDLL name 'D3DXSaveSurfaceToFileW';
{$EXTERNALSYM D3DXSaveSurfaceToFileW}

function D3DXSaveSurfaceToFile(
  pDestFile: PChar;
  DestFormat: TD3DXImageFileFormat;
  pSrcSurface: IDirect3DSurface9;
  pSrcPalette: PPaletteEntry;
  pSrcRect: PRect): HResult; stdcall; external d3dx9texDLL name 'D3DXSaveSurfaceToFileA';
{$EXTERNALSYM D3DXSaveSurfaceToFile}





// non-inline

function D3DXMatrixDeterminant(const m: TD3DXMatrix): Single; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixDeterminant}

function D3DXMatrixTranspose(out pOut: TD3DXMatrix; const pM: TD3DXMatrix): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixTranspose}



// Matrix multiplication, followed by a transpose. (Out = T(M1 * M2))
function D3DXMatrixMultiplyTranspose(out pOut: TD3DXMatrix; const pM1, pM2: TD3DXMatrix): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixMultiplyTranspose}

// Calculate inverse of matrix.  Inversion my fail, in which case NULL will
// be returned.  The determinant of pM is also returned it pfDeterminant
// is non-NULL.
function D3DXMatrixInverse(out mOut: TD3DXMatrix; pfDeterminant: PSingle;
    const m: TD3DXMatrix): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixInverse}




// Build a matrix which rotates around the X axis
function D3DXMatrixRotationX(out mOut: TD3DXMatrix; angle: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixRotationX}

// Build a matrix which rotates around the Y axis
function D3DXMatrixRotationY(out mOut: TD3DXMatrix; angle: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixRotationY}



// Build a matrix which rotates around an arbitrary axis
function D3DXMatrixRotationAxis(out mOut: TD3DXMatrix; const v: TD3DXVector3;
  angle: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixRotationAxis}

// Build a matrix from a quaternion
function D3DXMatrixRotationQuaternion(out mOut: TD3DXMatrix; const Q: TD3DXQuaternion): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixRotationQuaternion}

// Yaw around the Y axis, a pitch around the X axis,
// and a roll around the Z axis.
function D3DXMatrixRotationYawPitchRoll(out mOut: TD3DXMatrix; yaw, pitch, roll: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixRotationYawPitchRoll}


// Build transformation matrix.  NULL arguments are treated as identity.
// Mout = Msc-1 * Msr-1 * Ms * Msr * Msc * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixTransformation(out mOut: TD3DXMatrix;
   pScalingCenter: PD3DXVector3;
   pScalingRotation: PD3DXQuaternion; pScaling, pRotationCenter: PD3DXVector3;
   pRotation: PD3DXQuaternion; pTranslation: PD3DXVector3): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixTransformation}

// Build affine transformation matrix.  NULL arguments are treated as identity.
// Mout = Ms * Mrc-1 * Mr * Mrc * Mt
function D3DXMatrixAffineTransformation(out mOut: TD3DXMatrix;
   Scaling: Single; pRotationCenter: PD3DXVector3;
   pRotation: PD3DXQuaternion; pTranslation: PD3DXVector3): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixAffineTransformation}

// Build a lookat matrix. (right-handed)
function D3DXMatrixLookAtRH(out mOut: TD3DXMatrix; const Eye, At, Up: TD3DXVector3): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixLookAtRH}

// Build a lookat matrix. (left-handed)
function D3DXMatrixLookAtLH(out mOut: TD3DXMatrix; const Eye, At, Up: TD3DXVector3): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixLookAtLH}

// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveRH(out mOut: TD3DXMatrix; w, h, zn, zf: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixPerspectiveRH}

// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveLH(out mOut: TD3DXMatrix; w, h, zn, zf: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixPerspectiveLH}

// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveFovRH(out mOut: TD3DXMatrix; flovy, aspect, zn, zf: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixPerspectiveFovRH}

// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveFovLH(out mOut: TD3DXMatrix; flovy, aspect, zn, zf: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixPerspectiveFovLH}

// Build a perspective projection matrix. (right-handed)
function D3DXMatrixPerspectiveOffCenterRH(out mOut: TD3DXMatrix;
   l, r, b, t, zn, zf: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixPerspectiveOffCenterRH}

// Build a perspective projection matrix. (left-handed)
function D3DXMatrixPerspectiveOffCenterLH(out mOut: TD3DXMatrix;
   l, r, b, t, zn, zf: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixPerspectiveOffCenterLH}

// Build an ortho projection matrix. (right-handed)
function D3DXMatrixOrthoRH(out mOut: TD3DXMatrix; w, h, zn, zf: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixOrthoRH}

// Build an ortho projection matrix. (left-handed)
function D3DXMatrixOrthoLH(out mOut: TD3DXMatrix; w, h, zn, zf: Single): PD3DXMatrix; stdcall; external d3dx9mathDLL;
{$EXTERNALSYM D3DXMatrixOrthoLH}


function D3DXFilterTexture(
  pTexture: IDirect3DTexture9;
  pPalette: PPaletteEntry;
  SrcLevel: LongWord;
  Filter: DWord): HResult; stdcall; external d3dx9texDLL;
{$EXTERNALSYM D3DXFilterTexture}

// #define D3DXFilterCubeTexture D3DXFilterTexture
// In Pascal this mapped to DLL-exported "D3DXFilterTexture" function
function D3DXFilterCubeTexture(
  pTexture: IDirect3DCubeTexture9;
  pPalette: PPaletteEntry;
  SrcLevel: LongWord;
  Filter: DWord): HResult; stdcall; external d3dx9texDLL name 'D3DXFilterTexture';
{$EXTERNALSYM D3DXFilterCubeTexture}

// #define D3DXFilterVolumeTexture D3DXFilterTexture
// In Pascal this mapped to DLL-exported "D3DXFilterTexture" function
function D3DXFilterVolumeTexture(
  pTexture: IDirect3DVolumeTexture9;
  pPalette: PPaletteEntry;
  SrcLevel: LongWord;
  Filter: DWord): HResult; stdcall; external d3dx9texDLL name 'D3DXFilterTexture';
{$EXTERNALSYM D3DXFilterVolumeTexture}


{$IFNDEF STATIC_LINKING}
var _Direct3DCreate9 : function (SDKVersion : Cardinal) : Pointer; stdcall;
{$ENDIF}



function DXGErrorString(ErrorValue : HResult) : string;

implementation

function DIEFT_GETTYPE(n: Cardinal): Byte;
begin
  Result := LOBYTE(n);
end;


// #define GET_DIDEVICE_TYPE(dwDevType)    LOBYTE(dwDevType)
function GET_DIDEVICE_TYPE(dwDevType: DWORD): Byte;
begin
  Result := LOBYTE(dwDevType);
end;

// #define GET_DIDEVICE_SUBTYPE(dwDevType) HIBYTE(dwDevType)
function GET_DIDEVICE_SUBTYPE(dwDevType: DWORD): Byte;
begin
  Result := HiByte(Word(dwDevType));
end;

// #define DIDFT_MAKEINSTANCE(n) ((WORD)(n) << 8)
function DIDFT_MAKEINSTANCE(n: Cardinal): Cardinal;
begin
  Result := Word(n) shl 8;
end;

// #define DIDFT_GETTYPE(n)     LOBYTE(n)
function DIDFT_GETTYPE(n: Cardinal): Byte;
begin
  Result := LOBYTE(n);
end;

// #define DIDFT_GETINSTANCE(n) LOWORD((n) >> 8)
function DIDFT_GETINSTANCE(n: Cardinal): Cardinal;
begin
  Result := LOWORD(n) shr 8;
end;

// #define DIDFT_ENUMCOLLECTION(n) ((WORD)(n) << 8)
function DIDFT_ENUMCOLLECTION(n: Cardinal): Cardinal;
begin
  Result := Word(n) shl 8;
end;

{$IFDEF DIRECTINPUT_VERSION_5b} (* #if(DIRECTINPUT_VERSION >= 0x050a) *)
// #define DIMAKEUSAGEDWORD(UsagePage, Usage) \
//                                 (DWORD)MAKELONG(Usage, UsagePage)
function DIMAKEUSAGEDWORD(UsagePage, Usage: Word): DWORD;
begin
  Result:= DWORD(MakeLong(UsagePage, Usage));
end;
{$ENDIF} (* DIRECTINPUT_VERSION >= 0x050a *)

//  #define DIJOFS_SLIDER(n)   (FIELD_OFFSET(DIJOYSTATE, rglSlider) + \
//                              (n) * sizeof(LONG))
function DIJOFS_SLIDER(n: Cardinal): Cardinal;
begin
  Result := Cardinal(@PDIJoyState(nil)^.rglSlider) + n*SizeOf(DWORD); //  + 24;
end;

// #define DIJOFS_POV(n)      (FIELD_OFFSET(DIJOYSTATE, rgdwPOV) + \
//                              (n) * sizeof(DWORD))
function DIJOFS_POV(n: Cardinal): Cardinal;
begin
  Result := Cardinal(@PDIJoyState(nil).rgdwPOV) + n*SizeOf(DWORD); //  + 32;
end;

// #define DIJOFS_BUTTON(n)   (FIELD_OFFSET(DIJOYSTATE, rgbButtons) + (n))
function DIJOFS_BUTTON(n: Cardinal): Cardinal;
begin
  Result := Cardinal(@PDIJoyState(nil).rgbButtons) + n*SizeOf(DWORD); //  + 48;
end;

// #define DIBUTTON_ANY(instance)                  ( 0xFF004400 | instance )
function DIBUTTON_ANY(instance: Cardinal): Cardinal;
begin
  Result := $FF004400 or instance;
end;


{$IFDEF DIRECTINPUT_DYNAMIC_LINK}
var
  DirectInputLib: THandle = 0;
  DirectInput8Lib: THandle = 0;
  WinMMLib: THandle = 0;
  JoyCPLLib: THandle = 0;

function DirectInputLoaded: Boolean;
begin
  Result:= (DirectInputLib <> 0) and (DirectInput8Lib<>0);
end;

function UnLoadDirectInput: Boolean;
begin
  Result:= True;
  if (DirectInputLib <> 0) then
  begin
    Result:= Result and FreeLibrary(DirectInputLib);
    DirectInputCreateA:= nil;
    DirectInputCreateW:= nil;
    DirectInputCreate:= nil;

    DirectInputCreateEx:= nil;
    DirectInputLib:= 0;
  end;

  if (DirectInput8Lib <> 0) then
  begin
    Result:= Result and FreeLibrary(DirectInput8Lib);
    DirectInput8Create:= nil;
    DirectInput8Lib:= 0;
  end;

  if (WinMMLib <> 0) then
  begin
    Result:= Result and FreeLibrary(WinMMLib);
    joyConfigChanged:= nil;
    WinMMLib:= 0;
  end;

  if (JoyCPLLib <> 0) then
  begin
    Result:= Result and FreeLibrary(JoyCPLLib);
    ShowJoyCPL:= nil;
    JoyCPLLib:= 0;
  end;
end;

function LoadDirectInput: Boolean;
begin
  Result:= DirectInputLoaded;
  if (not Result) then
  begin
    DirectInputLib:= LoadLibrary(DirectInputDll);
    if (DirectInputLib<>0) then
    begin
      DirectInputCreateA:= GetProcAddress(DirectInputLib, 'DirectInputCreateA');
      DirectInputCreateW:= GetProcAddress(DirectInputLib, 'DirectInputCreateW');
      {$IFDEF UNICODE}
      DirectInputCreate:= GetProcAddress(DirectInputLib, 'DirectInputCreateW');
      {$ELSE}
      DirectInputCreate:= GetProcAddress(DirectInputLib, 'DirectInputCreateA');
      {$ENDIF}

      DirectInputCreateEx:= GetProcAddress(DirectInputLib, 'DirectInputCreateEx');
    end;

    DirectInput8Lib:= LoadLibrary(DirectInput8Dll);
    if (DirectInput8Lib<>0) then
    begin
      DirectInput8Create:= GetProcAddress(DirectInputLib, 'DirectInput8Create');
    end;

    WinMMLib:= LoadLibrary(WinMMDll);
    if (WinMMLib <> 0) then
    begin
      joyConfigChanged:= GetProcAddress(WinMMLib, 'joyConfigChanged');
    end;

    JoyCPLLib:= LoadLibrary(JoyCPL);
    if (JoyCPLLib <> 0) then
    begin
      ShowJoyCPL:= GetProcAddress(JoyCPLLib, 'ShowJoyCPL');
    end;

    // At least basic procedure is found!
    Result:= Assigned(DirectInputCreate) or Assigned(DirectInput8Create);
    if not Result then UnLoadDirectInput;
  end;
end;
{$ELSE}
function DirectInputLoaded: Boolean;
begin // Stub function for static linking
  Result:= True;
end;

function UnLoadDirectInput: Boolean;
begin // Stub function for static linking
  Result:= True; // should emulate "normal" behaviour
end;

function LoadDirectInput: Boolean;
begin // Stub function for static linking
  Result:= True;
end;

{$ENDIF}


function D3DCOLOR_ARGB(a, r, g, b : Cardinal) : TD3DColor;
begin
  Result := (a shl 24) or (r shl 16) or (g shl 8) or b;
end;

function D3DCOLOR_RGBA(r, g, b, a : Cardinal) : TD3DColor;
begin
  Result := D3DCOLOR_ARGB(a, r, g, b);
end;

function D3DCOLOR_XRGB(r, g, b : Cardinal) : TD3DColor;
begin
  Result := D3DCOLOR_ARGB($ff, r, g, b);
end;

function D3DCOLOR_COLORVALUE(r, g, b, a : Single) : TD3DColor;
begin
  Result := D3DCOLOR_RGBA(Byte(Round(r * 255)), Byte(Round(g * 255)), Byte(Round(b * 255)), Byte(Round(a * 255)))
end;

function D3DTS_WORLDMATRIX(index : LongWord) : TD3DTransformStateType;
begin
  Result := TD3DTransformStateType(index + 256);
end;

function D3DVSD_MAKETOKENTYPE(tokenType : TD3DVSDTokenType) : TD3DVSDTokenType;
begin
  Result := TD3DVSDTokenType((LongWord(tokenType) shl LongWord(D3DVSD_TOKENTYPESHIFT)) and LongWord(D3DVSD_TOKENTYPEMASK));
end;

function D3DVSD_STREAM(_StreamNumber : LongWord) : TD3DVSDTokenType;
begin
  Result := TD3DVSDTokenType(LongWord(D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_STREAM)) or _StreamNumber);
end;

function D3DVSD_REG( _VertexRegister, _Type : LongWord) : TD3DVSDTokenType;
begin
  Result := TD3DVSDTokenType(LongWord(D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_STREAMDATA)) or ((_Type shl LongWord(D3DVSD_DATATYPESHIFT)) or _VertexRegister))
end;

function D3DVSD_SKIP( _DWORDCount : LongWord) : TD3DVSDTokenType;
begin
  Result := TD3DVSDTokenType(LongWord(D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_STREAMDATA)) or $10000000 or (_DWORDCount shl LongWord(D3DVSD_SKIPCOUNTSHIFT)))
end;

function D3DVSD_CONST( _ConstantAddress, _Count : LongWord)  : TD3DVSDTokenType;
begin
  Result := TD3DVSDTokenType(LongWord(D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_CONSTMEM)) or (_Count shl LongWord(D3DVSD_CONSTCOUNTSHIFT)) or _ConstantAddress)
end;

function D3DVSD_TESSNORMAL( _VertexRegisterIn, _VertexRegisterOut : LongWord) : TD3DVSDTokenType;
begin
  Result := TD3DVSDTokenType(LongWord(D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_TESSELLATOR)) or
            (_VertexRegisterIn shl LongWord(D3DVSD_VERTEXREGINSHIFT)) or
            ($02 shl LongWord(D3DVSD_DATATYPESHIFT)) or _VertexRegisterOut);
end;

function D3DVSD_TESSUV( _VertexRegister : LongWord) : TD3DVSDTokenType;
begin
  Result := TD3DVSDTokenType(LongWord(D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_TESSELLATOR)) or $10000000 or
            ($01 shl LongWord(D3DVSD_DATATYPESHIFT)) or _VertexRegister);
end;

function D3DPS_VERSION(_Major, _Minor : LongWord) : LongWord;
begin
  Result := $FFFF0000 or (_Major shl 8 ) or _Minor;
end;

function D3DVS_VERSION(_Major, _Minor : LongWord) : LongWord;
begin
  Result := $FFFE0000 or (_Major shl 8 ) or _Minor;
end;

function D3DSHADER_VERSION_MAJOR(_Version : LongWord) : LongWord;
begin
  Result := (_Version shr 8 ) and $FF;
end;

function D3DSHADER_VERSION_MINOR(_Version : LongWord) : LongWord;
begin
  Result := (_Version shr 0) and $FF;
end;

function  D3DSHADER_COMMENT(_DWordSize : LongWord)  : LongWord;
begin
  Result := ((_DWordSize shl D3DSI_COMMENTSIZE_SHIFT) and D3DSI_COMMENTSIZE_MASK) or LongWord(D3DSIO_COMMENT);
end;

function D3DFVF_TEXCOORDSIZE3(CoordIndex : LongWord) : LongWord;
begin
  Result := D3DFVF_TEXTUREFORMAT3 shl (CoordIndex * 2 + 16)
end;

function D3DFVF_TEXCOORDSIZE2(CoordIndex : LongWord) : LongWord;
begin
  Result := D3DFVF_TEXTUREFORMAT2;
end;

function D3DFVF_TEXCOORDSIZE4(CoordIndex : LongWord) : LongWord;
begin
  Result := D3DFVF_TEXTUREFORMAT4 shl (CoordIndex * 2 + 16)
end;

function D3DFVF_TEXCOORDSIZE1(CoordIndex : LongWord) : LongWord;
begin
  Result := D3DFVF_TEXTUREFORMAT1 shl (CoordIndex * 2 + 16)
end;

function MAKEFOURCC(ch0, ch1, ch2, ch3 : Char) : LongWord;
begin
  Result := Byte(ch0) or (Byte(ch1) shl 8) or (Byte(ch2) shl 16) or (Byte(ch3) shl 24 );
end;

// inline
function D3DXMatrixIdentity(out mOut: TD3DXMatrix): PD3DXMatrix;
begin
  FillChar(mOut, SizeOf(mOut), 0);
  mOut._11:= 1; mOut._22:= 1; mOut._33:= 1; mOut._44:= 1;
  Result:= @mOut;
end;

function D3DXMatrixIsIdentity(const m: TD3DXMatrix): BOOL;
begin
  with m do Result:=
    (_11 = 1) and (_12 = 0) and (_13 = 0) and (_14 = 0) and
    (_21 = 0) and (_22 = 1) and (_23 = 0) and (_24 = 0) and
    (_31 = 0) and (_32 = 0) and (_33 = 1) and (_34 = 0) and
    (_41 = 0) and (_42 = 0) and (_43 = 0) and (_44 = 1);
end;

function D3DXVector3(_x, _y, _z: Single): TD3DXVector3;
begin
  with Result do
  begin
    x:= _x; y:= _y; z:=_z;
  end;
end;

function D3DXVector3Equal(const v1, v2: TD3DXVector3): Boolean;
begin
  Result:= (v1.x = v2.x) and (v1.y = v2.y) and (v1.z = v2.z);
end;

function DXGErrorString(ErrorValue : HResult) : string;
begin
//You should better use D3DXErrorString
  case ErrorValue of

    HResult(D3D_OK)                           : Result := 'No error occurred.';
    HResult(D3DERR_CONFLICTINGRENDERSTATE)    : Result := 'The currently set render states cannot be used together.';
    HResult(D3DERR_CONFLICTINGTEXTUREFILTER)  : Result := 'The current texture filters cannot be used together.';
    HResult(D3DERR_CONFLICTINGTEXTUREPALETTE) : Result := 'The current textures cannot be used simultaneously. This generally occurs when a multitexture device requires that all palletized textures simultaneously enabled also share the same palette.';
    HResult(D3DERR_DEVICELOST)                : Result := 'The device is lost and cannot be restored at the current time, so rendering is not possible.';
    HResult(D3DERR_DEVICENOTRESET)            : Result := 'The device cannot be reset.';
    HResult(D3DERR_DRIVERINTERNALERROR)       : Result := 'Internal driver error.';
    HResult(D3DERR_INVALIDCALL)               : Result := 'The method call is invalid. For example, a method''s parameter may have an invalid value.';
    HResult(D3DERR_INVALIDDEVICE)             : Result := 'The requested device type is not valid.';
    HResult(D3DERR_MOREDATA)                  : Result := 'There is more data available than the specified buffer size can hold.';
    HResult(D3DERR_NOTAVAILABLE)              : Result := 'This device does not support the queried technique.';
    HResult(D3DERR_NOTFOUND)                  : Result := 'The requested item was not found.';
    HResult(D3DERR_OUTOFVIDEOMEMORY)          : Result := 'Direct3D does not have enough display memory to perform the operation.';
    HResult(D3DERR_TOOMANYOPERATIONS)         : Result := 'The application is requesting more texture-filtering operations than the device';
    HResult(D3DERR_UNSUPPORTEDALPHAARG)       : Result := 'The device does not support a specified texture-blending argument for the alpha channel.';
    HResult(D3DERR_UNSUPPORTEDALPHAOPERATION) : Result := 'The device does not support a specified texture-blending operation for the alpha channel.';
    HResult(D3DERR_UNSUPPORTEDCOLORARG)       : Result := 'The device does not support a specified texture-blending argument for color values.';
    HResult(D3DERR_UNSUPPORTEDCOLOROPERATION) : Result := 'The device does not support a specified texture-blending operation for color values.';
    HResult(D3DERR_UNSUPPORTEDFACTORVALUE)    : Result := 'The device does not support the specified texture factor value.';
    HResult(D3DERR_UNSUPPORTEDTEXTUREFILTER)  : Result := 'The device does not support the specified texture filter.';
    HResult(D3DERR_WRONGTEXTUREFORMAT)        : Result := 'The pixel format of the texture surface is not valid.';
    HResult(E_FAIL)                           : Result := 'An undetermined error occurred inside the Direct3D subsystem.';
    HResult(E_INVALIDARG)                     : Result := 'An invalid parameter was passed to the returning function';
    HResult(E_OUTOFMEMORY)                    : Result := 'Direct3D could not allocate sufficient memory to complete the call.';

    else Result := 'Unknown Error';
  end;
end;



{$IFDEF STATIC_LINKING}
function _Direct3DCreate9(SDKVersion : Cardinal) : Pointer; stdcall; external D3D8DLLName name 'Direct3DCreate9';
{$ENDIF}

function Direct3DCreate9(SDKVersion : Cardinal) : IDirect3D9;
begin
{$IFNDEF STATIC_LINKING}
  if Assigned(_Direct3DCreate9) then
  begin
{$ENDIF}
    Result := IDirect3D9(_Direct3DCreate9(SDKVersion));
    if Result <> nil then Result._Release;
{$IFNDEF STATIC_LINKING}
  end else Result := nil;
{$ENDIF}
end;

{$IFNDEF STATIC_LINKING}
initialization
begin
  if not IsNTandDelphiRunning then
  begin
    D3D8DLL := LoadLibrary(D3D8DLLName);
    if D3D8DLL <> 0 then
      _Direct3DCreate9 := GetProcAddress(D3D8DLL, 'Direct3DCreate9')
    else _Direct3DCreate9 := nil;
  end;

  LoadDirectInput;
end;

finalization
begin
  UnLoadDirectInput;
  FreeLibrary(D3D8DLL);
end;
{$ENDIF}

end.

