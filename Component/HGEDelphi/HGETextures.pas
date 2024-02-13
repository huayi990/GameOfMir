unit HGETextures;

interface

uses
  System.SysUtils, System.Classes, System.Math, Winapi.Windows, Winapi.Direct3D9,
  Vcl.Graphics, Vcl.Imaging.pngimage, HGE, HGEBase;

type
  TDXTextureBehavior = (tbManaged, tbUnmanaged, tbDynamic, tbRTarget, tbSystem);

  TDXLockFlags = (lfNormal, lfReadOnly, lfWriteOnly);

  TDXTextureState = (tsNotReady, tsReady, tsLost, tsFailure);

  TDXAccessInfo = record
    Bits: Pointer;
    Pitch: Integer;
    Format: TColorFormat;
  end;

  TDXTexture = class
  private
    FHeight: Integer;
    FWidth: Integer;
    FTexWidth: Integer;
    FTexHeight: Integer;
    FTexture: ITexture;
    FSize: TPoint;
    FPatternSize: TPoint;
    FFormat: TD3DFormat;
    FBehavior: TDXTextureBehavior;
    FActive: Boolean;
    FDrawCanvas: TObject;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetSize(const Value: TPoint);
    //procedure MakeTexture();
    procedure SetBehavior(const Value: TDXTextureBehavior);
    procedure SetFormat(const Value: TD3DFormat);
    procedure SetPatternSize(const Value: TPoint);
    function GetPool(): TD3DPool;
    procedure LoadBitmapToTexture(Stream: TStream);
    function GetPixel(X, Y: Integer): Cardinal;
    procedure SetPixel(X, Y: Integer; const Value: Cardinal);
  protected
    FState: TDXTextureState;
    function MakeReady(): Boolean; dynamic;
    procedure MakeNotReady(); dynamic;
    procedure ChangeState(NewState: TDXTextureState);
  public
    constructor Create(DrawCanvas: TObject = nil); dynamic;
    destructor Destroy; override;
    procedure LoadFromFile(FileName: string);
    Procedure LoadFromBitmapEX(bitmap: TBitmap);
    Procedure LoadFromBitmap(bitmap: TBitmap; TRANSPARENT: Boolean = True);
    function Lock(Flags: TDXLockFlags; out Access: TDXAccessInfo): Boolean;
    function LockRect(const LockArea: TRect; Flags: TDXLockFlags; out Access: TDXAccessInfo): Boolean;
    function Unlock(): Boolean;
    procedure Lost(); dynamic;
    procedure Recovered(); dynamic;
    function Clear(): Boolean;
    function ClientRect: TRect; dynamic;
    function Width: Integer; dynamic;
    function Height: Integer; dynamic;
    procedure CopyTexture(SourceTexture: TDXTexture); overload;
    procedure CopyTexture(X, Y: Integer; SourceTexture: TDXTexture); overload;
    procedure Line(nX, nY, nLength: Integer; FColor: Cardinal);
    procedure LineTo(nX, nY, nWidth: Integer; FColor: Cardinal);
    property Canvas: TObject read FDrawCanvas write FDrawCanvas;
    property Active: Boolean read GetActive write SetActive;
    property Size: TPoint read FSize write SetSize;
    property PatternSize: TPoint read FPatternSize write SetPatternSize;
    property Image: ITexture read FTexture write FTexture;
    property Format: TD3DFormat read FFormat write SetFormat;
    property Behavior: TDXTextureBehavior read FBehavior write SetBehavior;
    property Pixels[X, Y: Integer]: Cardinal read GetPixel write SetPixel;
    procedure TextOutEx(X, Y: Integer; Text: WideString); overload;
    procedure TextOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal); overload;
    procedure TextOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal; BColor: Cardinal; boClearMark: Boolean = False); overload;
    procedure TextBoldOutEx(X, Y: Integer; Text: WideString); overload;  //加入粗体
    procedure TextBoldOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal); overload;
    procedure TextBoldOutExx(X, Y: Integer; Text: WideString; FColor: Cardinal); overload;
    procedure TextBoldOutExxx(X, Y: Integer; Text: WideString; FColor: Cardinal); overload;
    procedure TextBoldOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal; BColor: Cardinal; boClearMark: Boolean = False); overload;
    procedure Draw(X, Y: Integer; Source: TDXTexture; TRANSPARENT: Boolean); overload;
    procedure Draw(X, Y: Integer; Source: TDXTexture; TRANSPARENT, MirrorX, MirrorY: Boolean); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; TRANSPARENT: Boolean); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; TRANSPARENT, MirrorX, MirrorY: Boolean); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Color, DrawFx: Cardinal); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; TRANSPARENT: Boolean; DrawFx: Cardinal); overload;
    procedure StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; TRANSPARENT: Boolean); overload;
    procedure StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; DrawFx: Cardinal); overload;
    procedure StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; dwColor: Cardinal; DrawFx: Cardinal); overload;
  end;

  TDXImageTexture = class(TDXTexture)
  public
    constructor Create(DrawCanvas: TObject = nil); override;
    function ClientRect: TRect; override;
    function Width: Integer; override;
    function Height: Integer; override;
  end;

  TDXRenderTargetTexture = class(TDXTexture)
  private
    FTarget: ITarget;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
  protected
    function MakeReady(): Boolean; override;
    procedure MakeNotReady(); override;
  public
    constructor Create(DrawCanvas: TObject = nil); override;
    destructor Destroy; override;
    procedure Lost(); override;
    procedure Recovered(); override;
    property Target: ITarget read FTarget write FTarget;
    property Active: Boolean read GetActive write SetActive;
  end;

  TDirectDrawSurface = TDXTexture;

procedure InitializeTexturesInfo();

implementation

uses
  HGECanvas, HGEFonts, HGEFont;

var
  FHGE: IHGE = nil;
  FQuad: THGEQuad;

procedure TextOutBold(Canvas: TCanvas; x, y, fcolor, bcolor: Integer; str: string); //字体深浅
//var
//  nLen: Integer;
begin
  SelectObject(Canvas.Handle, Canvas.Font.Handle);
  try
    SetBkMode(Canvas.Handle, 0);
    SetTextColor(Canvas.Handle, bcolor);
    TextOut(Canvas.Handle, 0, 1, PChar(str), Length(str));
    TextOut(Canvas.Handle, 2, 1, PChar(str), Length(str));
    TextOut(Canvas.Handle, 1, 0, PChar(str), Length(str));
    TextOut(Canvas.Handle, 1, 2, PChar(str), Length(str));
    SetTextColor(Canvas.Handle, fcolor);
    TextOut(Canvas.Handle, 1, 1, PChar(str), Length(str));
  finally
    SelectObject(Canvas.Handle, Canvas.Font.Handle);
  end;
end;
//procedure TextOutBold(Canvas: TCanvas; x, y, fcolor, bcolor: integer; str: string);
//var
//  nLen: Integer;
//begin
//  nLen := Length(str);
//  Canvas.Brush.Color := bcolor;
//  Windows.SetBkMode(Canvas.Handle, TRANSPARENT);
//
//  Windows.SetBkColor(Canvas.Handle, Canvas.Brush.Color);
//  Windows.SetTextColor(Canvas.Handle, bcolor);
//  Windows.TextOut(Canvas.Handle, x, y - 1, PChar(str), nlen);
//  Windows.TextOut(Canvas.Handle, x, y + 1, PChar(str), nlen);
//  Windows.TextOut(Canvas.Handle, x - 1, y, PChar(str), nlen);
//  Windows.TextOut(Canvas.Handle, x + 1, y, PChar(str), nlen);
//  Windows.TextOut(Canvas.Handle, x - 1, y - 1, PChar(str), nlen);
//  Windows.TextOut(Canvas.Handle, x + 1, y + 1, PChar(str), nlen);
//  Windows.TextOut(Canvas.Handle, x - 1, y + 1, PChar(str), nlen);
//  Windows.TextOut(Canvas.Handle, x + 1, y - 1, PChar(str), nlen);
//  Windows.SetTextColor(Canvas.Handle, fcolor);
//  Windows.TextOut(Canvas.Handle, x, y, PChar(str), nLen)
//end;

procedure InitializeTexturesInfo();
begin
  FHGE := HGECreate(HGE_VERSION);
end;

{ TDXTexture }

procedure TDXTexture.ChangeState(NewState: TDXTextureState);
begin
  if (FState = tsNotReady) and (NewState = tsReady) then
  begin
    if MakeReady() then
      FState := tsReady;
  end
  else if (NewState = tsNotReady) then
  begin
    if (FState = tsReady) then
      MakeNotReady();
    FState := tsNotReady;
  end
  else if (FState = tsReady) and (NewState = tsLost) and (FBehavior <> tbManaged) then
  begin
    MakeNotReady();
    FState := tsLost;
  end
  else if (FState = tsLost) and (NewState = tsReady) then
  begin
    if (MakeReady()) then
      FState := tsReady
    else
      FState := tsFailure;
  end
  else if (FState = tsFailure) and (NewState = tsReady) then
  begin
    if (MakeReady()) then
      FState := tsReady;
  end;
end;

function TDXTexture.Clear(): Boolean;
var
  Access: TDXAccessInfo;
begin
  Result := False;
  if not Active then
    Exit;
  if Lock(lfWriteOnly, Access) then
  begin
    Try
      FillChar(Access.Bits^, Access.Pitch * Size.Y, #0);
      Result := True;
    Finally
      Unlock();
    End;
  end;
end;

function TDXTexture.ClientRect: TRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := FSize.X;
  Result.Bottom := FSize.Y;
end;

procedure TDXTexture.CopyTexture(SourceTexture: TDXTexture);
var
  SourceAccess: TDXAccessInfo;
  Access: TDXAccessInfo;
begin
  if SourceTexture = nil then
    Exit;
  if Active then
    ChangeState(tsNotReady);
  FSize := SourceTexture.Size;
  FPatternSize := SourceTexture.PatternSize;
  FFormat := SourceTexture.Format;
  ChangeState(tsReady);
  if SourceTexture.Lock(lfReadOnly, SourceAccess) then
  begin
    Try
      if Lock(lfWriteOnly, Access) then
      begin
        Try
          Move(SourceAccess.Bits^, Access.Bits^, Access.Pitch * FSize.Y);
        Finally
          Unlock;
        End;
      end;
    Finally
      SourceTexture.Unlock;
    End;
  end;
end;

//Copy纹理
procedure TDXTexture.CopyTexture(X, Y: Integer; SourceTexture: TDXTexture);
var
  SourceAccess: TDXAccessInfo;
  Access: TDXAccessInfo;
  srcleft, srcwidth, srctop, srcbottom, I: Integer;
  ReadBuffer, WriteBuffer: Pointer;
begin
  if SourceTexture = nil then
    Exit;
  if X >= FSize.X then
    Exit;
  if Y >= FSize.Y then
    Exit;
  if X < 0 then
  begin
    srcleft := -X;
    srcwidth := SourceTexture.Width + X;
    X := 0;
  end
  else
  begin
    srcleft := 0;
    srcwidth := SourceTexture.Width;
  end;
  if Y < 0 then
  begin
    srctop := -Y;
    srcbottom := srctop + SourceTexture.Height + Y;
    Y := 0;
  end
  else
  begin
    srctop := 0;
    srcbottom := srctop + SourceTexture.Height;
  end;

  if (srcleft + srcwidth) > SourceTexture.Width then
    srcwidth := SourceTexture.Width - srcleft;
  if srcbottom > SourceTexture.Height then
    srcbottom := SourceTexture.Height;
  if (X + srcwidth) > FSize.X then
    srcwidth := FSize.X - X;

  if (Y + srcbottom - srctop) > FSize.Y then
    srcbottom := FSize.Y - Y + srctop;

  if (srcwidth <= 0) or (srcbottom <= 0) or (srcleft >= SourceTexture.Width) or (srctop >= SourceTexture.Height) then
    Exit;

  if SourceTexture.Lock(lfReadOnly, SourceAccess) then
  begin
    Try
      if Lock(lfWriteOnly, Access) then
      begin
        Try
          for I := srctop to srcbottom - 1 do
          begin
            ReadBuffer := Pointer(Integer(SourceAccess.Bits) + SourceAccess.Pitch * I + (srcleft * 2));
            WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * (Y + I - srctop) + (X * 2));
            Move(ReadBuffer^, WriteBuffer^, srcwidth * 2);
          end;
        Finally
          Unlock;
        End;
      end;
    Finally
      SourceTexture.Unlock;
    End;
  end;
end;

constructor TDXTexture.Create(DrawCanvas: TObject);
begin
  inherited Create;
  FTexture := nil;
  FState := tsNotReady;
  FFormat := D3DFMT_A8R8G8B8;
  FBehavior := tbManaged;
  FActive := False;
  FDrawCanvas := DrawCanvas;
end;

destructor TDXTexture.Destroy;
begin
  if FTexture <> nil then
    FTexture.Handle := nil;
  FTexture := nil;
  inherited;
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawRect(Source, X, Y, SrcRect, bTransparent[Transparent]);
end;

procedure TDXTexture.Draw(X, Y: Integer; Source: TDXTexture; Transparent: Boolean);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).Draw(Source, X, Y, bTransparent[Transparent]);
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Color, DrawFx: Cardinal);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawRect(Source, X, Y, SrcRect, DrawFx, Color);
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawRect(Source, X, Y, SrcRect, DrawFx);
end;

function TDXTexture.GetActive: Boolean;
begin
  Result := (FTexture <> nil) and (FState = tsReady) and (FTexture.Handle <> nil);
end;

function TDXTexture.GetPixel(X, Y: Integer): Cardinal;
var
  Access: TDXAccessInfo;
  PPixel: Pointer;
begin
  Result := 0;
  if (X < 0) or (Y < 0) or (X > Size.X) or (Y > Size.Y) then
    Exit;

  // (1) Lock the desired texture.
  if (not Lock(lfReadOnly, Access)) then
  begin
    Result := 0;
    Exit;
  end;
  try
    PPixel := Pointer(Integer(Access.Bits) + (Access.Pitch * Y) + (X * Format2Bytes[Access.Format]));
    Result := DisplaceRB(PixelXto32(PPixel, Access.Format));
  finally
    Unlock();
  end;
end;

function TDXTexture.GetPool: TD3DPool;
begin
  Result := D3DPOOL_DEFAULT;
  case FBehavior of
    tbManaged:
      Result := D3DPOOL_MANAGED;
    tbUnmanaged:
      ;
    tbDynamic:
      ;
    tbRTarget:
      ;
    tbSystem:
      Result := D3DPOOL_SYSTEMMEM;
  end;
end;

function TDXTexture.Height: Integer;
begin
  Result := FSize.Y;
end;

procedure TDXTexture.Line(nX, nY, nLength: Integer; FColor: Cardinal);
var
  Access: TDXAccessInfo;
  wColor: Word;
  RGBQuad: TRGBQuad;
  WriteBuffer: Pointer;
begin
  if nY < 0 then
    Exit;
  if nY > FSize.Y then
    Exit;
  if nX > FSize.X then
    Exit;
  if nX < 0 then
  begin
    nLength := nLength - nX;
    nX := 0;
  end;
  if (nX + nLength) > FSize.X then
    nLength := FSize.X - nX;
  if nLength <= 0 then
    Exit;
  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((Word(RGBQuad.rgbRed) and $F0) shl 4) + (Word(RGBQuad.rgbGreen) and $F0) + (Word(RGBQuad.rgbBlue) shr 4);
  if Lock(lfWriteOnly, Access) then
  begin
    Try
      WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * nY + nX * 2);
      asm
                    push                edi
                    push                edx
                    push                eax
                    mov                 edi, WriteBuffer
                    mov                 ecx, nLength
                    mov                 dx, wColor

@pixloop:
                    mov                 ax, [edi].Word
                    mov                 [edi], dx
                    add                 edi, 2
                    Dec                 ecx
                    jnz                 @pixloop
                    pop                 eax
                    pop                 edx
                    pop                 edi
      end;
    Finally
      Unlock;
    End;
  end;
end;

procedure TDXTexture.LineTo(nX, nY, nWidth: Integer; FColor: Cardinal);
var
  Access: TDXAccessInfo;
  I: Integer;
  WriteBuffer: PWord;
  wColor: Word;
  RGBQuad: TRGBQuad;
begin
  if nX < 0 then
  begin
    nWidth := nWidth + nX;
    nX := 0;
  end;
  if nY < 0 then
    Exit;
  if nX >= FSize.X then
    Exit;
  if nY >= FSize.Y then
    Exit;
  if (nX + nWidth) > FSize.X then
    nWidth := FSize.X - nX;
  if nWidth <= 0 then
    Exit;
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((Word(RGBQuad.rgbRed) and $F0) shl 4) + (Word(RGBQuad.rgbGreen) and $F0) + (Word(RGBQuad.rgbBlue) shr 4);
  if Lock(lfWriteOnly, Access) then
  begin
    Try
      WriteBuffer := PWord(Integer(Access.Bits) + (Access.Pitch * nY) + (nX * 2));
      for I := nX to nWidth + nX do
      begin
        WriteBuffer^ := wColor;
        Inc(WriteBuffer);
      end;
    Finally
      Unlock;
    End;
  end;
end;

procedure TDXTexture.LoadBitmapToTexture(Stream: TStream);
var
  Bitmap: TBitmap;
  Access: TDXAccessInfo;
  Y: Integer;
  WriteBuffer, ReadBuffer: PChar;
begin
  Bitmap := TBitmap.Create;
  Try
    Stream.Position := 0;
    Bitmap.LoadFromStream(Stream);
    FTexture := FHGE.Texture_Create(Bitmap.Width, Bitmap.Height, GetPool, FFormat);
    if (FTexture <> nil) and (FTexture.Handle <> nil) then
    begin
      if Lock(lfWriteOnly, Access) then
      begin
        for Y := 0 to Bitmap.Height - 1 do
        begin
          ReadBuffer := Bitmap.ScanLine[Y];
          WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
          Move(ReadBuffer^, WriteBuffer^, Bitmap.Width * 2);
        end;
        Unlock;
      end;
    end;
  Finally
    Bitmap.Free;
  End;
end;

procedure TDXTexture.LoadFromFile(FileName: string);
var
  MemoryStream: TMemoryStream;
begin
  if FTexture <> nil then
  begin
    FTexture.Handle := nil;
    FTexture := nil;
  end;
  if FileExists(FileName) then
  begin
    MemoryStream := TMemoryStream.Create;
    Try
      MemoryStream.LoadFromFile(FileName);
      if MemoryStream.Size > 2 then
      begin
        if (PChar(MemoryStream.Memory)[0] + PChar(MemoryStream.Memory)[1]) = 'BM' then
        begin
          LoadBitmapToTexture(MemoryStream);
        end;
        if FTexture <> nil then
        begin
          FSize.X := FTexture.GetWidth;
          FSize.Y := FTexture.GetHeight;
          FPatternSize := FSize;
        end;
      end;
    Finally
      MemoryStream.Free;
    End;
  end;
end;

procedure TDXTexture.LoadFromBitmapEX(bitmap: TBitmap);
var
  nloop, jloop: Integer;
  OldColP: PLongWord;
  btAlpha: Byte;
  BmpBuff: PRGBQuad;
begin
  FTexWidth := 1 Shl Ceil(Log2(bitmap.Width));
  FTexHeight := 1 Shl Ceil(Log2(bitmap.Height));
  FTexture := FHGE.Texture_Create(FTexWidth, FTexHeight);
  OldColP := FTexture.Lock(False);
  for nloop := 0 to bitmap.Height - 1 do
  begin
    BmpBuff := bitmap.ScanLine[nloop];
    for jloop := 0 to bitmap.Width - 1 do
    begin
      if BmpBuff.rgbRed = 0 then
        btAlpha := 255
      else if BmpBuff.rgbGreen = 0 then
        btAlpha := 0
      else
        btAlpha := 255;
      if btAlpha <> 0 then
        OldColP^ := ((Word(btAlpha) and $F0) shl 8) + ((Word(BmpBuff.rgbRed) and $F0) shl 4) + (Word(BmpBuff.rgbGreen) and $F0) + (Word(BmpBuff.rgbBlue) shr 4)
      else
        OldColP^ := 0;
      Inc(BmpBuff);
      Inc(OldColP);
    end;
    Inc(OldColP, FTexWidth - bitmap.Width);
  end;
  FTexture.Unlock;
  FWidth := bitmap.width;
  FHeight := bitmap.Height;
  FQuad.Tex := FTexture;
  FQuad.V[0].TX := 0;
  FQuad.V[0].TY := 0;
  FQuad.V[1].TX := FWidth / FTexWidth;
  FQuad.V[1].TY := 0;
  FQuad.V[2].TX := FWidth / FTexWidth;
  FQuad.V[2].TY := FHeight / FTexHeight;
  FQuad.V[3].TX := 0;
  FQuad.V[3].TY := FHeight / FTexHeight;
  FQuad.Blend := BLEND_DEFAULT;
  FQuad.V[0].Col := $FFFFFFFF;
  FQuad.V[1].Col := $FFFFFFFF;
  FQuad.V[2].Col := $FFFFFFFF;
  FQuad.V[3].Col := $FFFFFFFF;
end;

procedure TDXTexture.LoadFromBitmap(bitmap: TBitmap; Transparent: Boolean);
var
  nloop, jloop: Integer;
  OldColP: PLongWord;
  r, b, g: Byte;
  c: TColor;
begin
  FTexWidth := 1 Shl Ceil(Log2(bitmap.Width));
  FTexHeight := 1 Shl Ceil(Log2(bitmap.Height));
  FTexture := FHGE.Texture_Create(FTexWidth, FTexHeight);
  OldColP := FTexture.Lock(False);
  for nloop := 0 to bitmap.height - 1 do
  begin
    for jloop := 0 to bitmap.width - 1 do
    Begin
      c := bitmap.canvas.Pixels[jloop, nloop];
      if Transparent then
      begin
        If c = 0 Then
        begin
          OldColP^ := $00000000;
        end
        else
        begin
          r := GetRValue(c);
          g := GetGValue(c);
          b := GetBValue(c);
          OldColP^ := ARGB($FF, r, g, b);
        end;
      end
      else
      begin
        r := GetRValue(c);
        g := GetGValue(c);
        b := GetBValue(c);
        OldColP^ := ARGB($FF, r, g, b);
      end;
      Inc(OldColP);
    end;
    Inc(OldColP, FTexWidth - bitmap.Width);
  end;
  FTexture.Unlock;
  FWidth := bitmap.width;
  FHeight := bitmap.Height;
  FQuad.Tex := FTexture;
  FQuad.V[0].TX := 0;
  FQuad.V[0].TY := 0;
  FQuad.V[1].TX := FWidth / FTexWidth;
  FQuad.V[1].TY := 0;
  FQuad.V[2].TX := FWidth / FTexWidth;
  FQuad.V[2].TY := FHeight / FTexHeight;
  FQuad.V[3].TX := 0;
  FQuad.V[3].TY := FHeight / FTexHeight;
  FQuad.Blend := BLEND_DEFAULT;
  FQuad.V[0].Col := $FFFFFFFF;
  FQuad.V[1].Col := $FFFFFFFF;
  FQuad.V[2].Col := $FFFFFFFF;
  FQuad.V[3].Col := $FFFFFFFF;
end;

function TDXTexture.Lock(Flags: TDXLockFlags; out Access: TDXAccessInfo): Boolean;
var
  LockedRect: TD3DLocked_Rect;
  Usage: Cardinal;
begin
  // (1) Verify conditions.
  Result := False;

  if (FTexture = nil) or (FTexture.Handle = nil) then
    Exit;

  // (2) Determine USAGE.
  Usage := 0;
  if (Flags = lfReadOnly) then
    Usage := D3DLOCK_READONLY;

  // (3) Lock the entire texture.
  Result := Succeeded(FTexture.Handle.LockRect(0, LockedRect, nil, Usage));

  // (4) Return access information.
  if (Result) then
  begin
    Access.Bits := LockedRect.pBits;
    Access.Pitch := LockedRect.Pitch;
    Access.Format := D3DToFormat(FFormat);
  end;
end;

function TDXTexture.LockRect(const LockArea: TRect; Flags: TDXLockFlags; out Access: TDXAccessInfo): Boolean;
var
  LockedRect: TD3DLocked_Rect;
  Usage: Cardinal;
begin
  // (1) Verify conditions.
  Result := False;
  if (FTexture = nil) or (FTexture.Handle = nil) then
    Exit;

  // (2) Determine USAGE.
  Usage := 0;
  if (Flags = lfReadOnly) then
    Usage := D3DLOCK_READONLY;

  // (3) Lock the entire texture.
  Result := Succeeded(FTexture.Handle.LockRect(0, LockedRect, @LockArea, Usage));

  // (4) Return access information.
  if (Result) then
  begin
    Access.Bits := LockedRect.pBits;
    Access.Pitch := LockedRect.Pitch;
    Access.Format := D3DToFormat(FFormat);
  end;
end;

procedure TDXTexture.Lost;
begin
  ChangeState(tsLost);
end;

procedure TDXTexture.MakeNotReady;
begin
  if FTexture <> nil then
    FTexture.Handle := nil;
  FTexture := nil;
end;

function TDXTexture.MakeReady: Boolean;
var
//  Res: Integer;
  Pool: TD3DPool;
  //Usage: Cardinal;
  //Levels: Integer;
begin
  // (1) Determine texture POOL.
  Result := False;

  Pool := D3DPOOL_DEFAULT;
  case FBehavior of
    tbManaged:
      Pool := D3DPOOL_MANAGED;
    tbSystem:
      Pool := D3DPOOL_SYSTEMMEM;
  end;

  // (2) Apply MipMapping request.
  {if (FMipMapping) then
  begin
    Usage := D3DUSAGE_AUTOGENMIPMAP;
    Levels := 0;
  end
  else
  begin  }
  //Usage := 0;
  //Levels := 1;
  //end;

  // (3) Determine texture USAGE.
  {case FBehavior of
    tbDynamic: Usage := Usage or D3DUSAGE_DYNAMIC;
    tbRTarget: Usage := Usage or D3DUSAGE_RENDERTARGET;
  end;   }

  FTexture := FHGE.Texture_Create(FSize.X, FSize.Y, Pool, FFormat);
  if (FTexture <> nil) and (FTexture.Handle <> nil) then
  begin
    FSize.X := FTexture.GetWidth();
    FSize.Y := FTexture.GetHeight();
    Result := True;
  end
  else
    FTexture := nil;

  // (4) Attempt to create the texture.
  {Res := Direct3DDevice.CreateTexture(FSize.X, FSize.Y, Levels, Usage, FFormat, Pool, FTexture9, nil);
  if (Failed(Res)) then
  begin
    // -> Release textures that were created successfully.
    MakeNotReady();
  end
  else
    Result := True;   }
end;
 {
procedure TDXTexture.MakeTexture;
begin
  //
end;    }

procedure TDXTexture.Recovered;
begin
  ChangeState(tsReady);
end;

procedure TDXTexture.SetActive(const Value: Boolean);
begin
  if Value then
    ChangeState(tsReady)
  else
    ChangeState(tsNotReady);
  FActive := FState = tsReady;
end;

procedure TDXTexture.SetBehavior(const Value: TDXTextureBehavior);
begin
  FBehavior := Value;
end;

procedure TDXTexture.SetFormat(const Value: TD3DFormat);
begin
  FFormat := Value;
end;

procedure TDXTexture.SetPatternSize(const Value: TPoint);
begin
  FPatternSize := Value;
end;

procedure TDXTexture.SetPixel(X, Y: Integer; const Value: Cardinal);
var
  Access: TDXAccessInfo;
  PPixel: Pointer;
begin
  // (1) Lock the desired texture.
  if (X < 0) or (Y < 0) or (X > Size.X) or (Y > Size.Y) then
    Exit;
  if (not Lock(lfWriteOnly, Access)) then
    Exit;

  try
    // (2) Get pointer to the requested pixel.
    PPixel := Pointer(Integer(Access.Bits) + (Access.Pitch * Y) + (X * Format2Bytes[Access.Format]));

    // (3) Apply format conversion.
    Pixel32toX(DisplaceRB(Value), PPixel, Access.Format);
  finally
    // (4) Unlock the texture.
    Unlock();
  end;
end;

procedure TDXTexture.SetSize(const Value: TPoint);
begin
  FSize := Value;
end;

procedure TDXTexture.StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; dwColor: Cardinal; DrawFx: Cardinal);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawStretch(Source, SrcRect.Left, SrcRect.Top, SrcRect.Right, SrcRect.Bottom, DesRect, DrawFx, dwColor);
end;

procedure TDXTexture.StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; DrawFx: Cardinal);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawStretch(Source, SrcRect.Left, SrcRect.Top, SrcRect.Right, SrcRect.Bottom, DesRect, DrawFx);
end;

procedure TDXTexture.TextOutEx(X, Y: Integer; Text: WideString);
begin
  TextOutEx(X, Y, Text, clWhite);
end;

procedure TDXTexture.TextOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal);
var
  Access, SourceAccess: TDXAccessInfo;
  AsciiRect: TRect;
  j, nX, nY, kerning, nFontWidth, nFontHeight: Integer;
  ReadBuffer, WriteBuffer: Pointer;
  wColor: Word;
  RGBQuad: TRGBQuad;
  Texture: TDXTexture;
  FontText: pTFontText;
  BitMap: TBitmap;
  FWidth, FHeigth: Integer;
  SizeWidth, SizeHeight: Integer;    //字符串宽度与高度
begin
  if Text = '' then
    Exit;
  kerning := 0;
  nX := 0;
  Dec(X);
  Dec(Y);

  SizeWidth := TDXDrawCanvas(FDrawCanvas).TextWidth(Text) + 2;
  SizeHeight := TDXDrawCanvas(FDrawCanvas).TextHeight(Text) + 2;

  Texture := ImageFont.GetTextDIBEX(Text, FColor, clBlack);
  if Texture = nil then
  begin
    Texture := TDXTexture.Create;
    Texture.Size := Point(SizeWidth, SizeHeight);
    Texture.Behavior := tbUnmanaged;
    Texture.PatternSize := Point(SizeWidth, SizeHeight);
    Texture.Format := D3DFMT_A4R4G4B4;
    Texture.Active := True;

    BitMap := TBitmap.Create;
    try
      BitMap.PixelFormat := pf32bit;
      BitMap.Canvas.Font.Name := MainForm.Canvas.Font.Name;      //字体名称
      BitMap.Canvas.Font.Size := MainForm.Canvas.Font.Size;      //字体大小
      BitMap.Canvas.Font.Style := MainForm.Canvas.Font.Style;    //字体类型, 比如加粗[fsBold]
      BitMap.Canvas.Brush.Color := clRed;
      BitMap.TransparentColor := clRed;
      BitMap.Transparent := True;
      BitMap.Canvas.Handle := GetDC(GetDesktopWindow());
      FWidth := SizeWidth;
      FHeigth := SizeHeight;
      BitMap.Width := FWidth;
      BitMap.Height := FHeigth;
      TextOutBold(BitMap.Canvas, 1, 1, clWhite, clBlack, Text);
      Texture.LoadFromBitmapEX(BitMap);
    finally
      FreeAndNil(BitMap);
    end;

    New(FontText);
    FontText.Font := Texture;
    FontText.Text := Text;
    FontText.Time := GetTickCount;
    FontText.Name := MainForm.Canvas.Font.Name;
    FontText.Size := MainForm.Canvas.Font.Size;
    FontText.Style := MainForm.Canvas.Font.Style;    //字体类型, 比如加粗[fsBold]
    FontText.FColor := FColor;
    FontText.BColor := clBlack;
    ImageFont.FontTextList.Add(FontText);
  end;

  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((Word(RGBQuad.rgbRed) and $F0) shl 4) + (Word(RGBQuad.rgbGreen) and $F0) + (Word(RGBQuad.rgbBlue) shr 4);

  if Texture.Lock(lfReadOnly, SourceAccess) then
  begin
    Try
      if Lock(lfWriteOnly, Access) then
      begin
        try
          while Text <> '' do
          begin
            if X >= Width then
              Break;
            AsciiRect := Texture.ClientRect;
            if (AsciiRect.Right > 4) then
            begin
              nY := Y;
              nFontWidth := AsciiRect.Right - AsciiRect.Left;
              if nFontWidth < 4 then
                Continue;
              if X < 0 then
              begin
                nX := -X;
                if (-X) >= (nFontWidth + kerning) then
                begin
                  Inc(X, nFontWidth + kerning);     //修复X提示
                  Continue;
                end;
                AsciiRect.Left := AsciiRect.Left - X;
                nFontWidth := AsciiRect.Right - AsciiRect.Left;
                if nFontWidth <= 0 then
                begin
                  X := kerning;
                  Continue;
                end;
                X := 0;
              end;
              if (X + nFontWidth) >= Width then
              begin
                nFontWidth := Width - X;
                if nFontWidth <= 0 then
                  Exit;
              end;

              if nY < 0 then
              begin
                AsciiRect.Top := AsciiRect.Top - nY;
                nY := 0;
              end;
              nFontHeight := AsciiRect.Bottom - AsciiRect.Top;
              if nFontHeight <= 0 then
              begin
                Inc(X, nFontWidth + kerning);
                Continue;
              end;

              for j := AsciiRect.Top to AsciiRect.Bottom - 1 do
              begin
                if nY >= Height then
                  Break;
                ReadBuffer := Pointer(Integer(SourceAccess.Bits) + SourceAccess.Pitch * j + (nX * 4));
                WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * nY + X * 2);
                asm
                    push                esi
                    push                edi
                    push                ebx
                    push                edx
                    mov                 esi, ReadBuffer
                    mov                 edi, WriteBuffer
                    mov                 ecx, nFontWidth
                    mov                 dx, wColor

@pixloop:
                    mov                 ax, [esi].Word
                    add                 esi, 4
                    cmp                 ax, 0
                    JE                  @@Next
                    AND                 ax, dx
                    mov                 [edi], ax

@@Next:
                    add                 edi, 2
                    Dec                 ecx
                    jnz                 @pixloop
                    pop                 edx
                    pop                 ebx
                    pop                 edi
                    pop                 esi
                end;
                Inc(nY);
              end;
              Inc(X, nFontWidth + kerning);
            end;
            Text := '';
          end;
        finally
          Unlock;
        end;
      end;
    finally
      Texture.Unlock;
    end;
  end;
end;

procedure TDXTexture.TextOutEx(X, Y: Integer; Text: WideString; FColor, BColor: Cardinal; boClearMark: Boolean);
var
  Access, SourceAccess: TDXAccessInfo;
  AsciiRect: TRect;
  j, nX, nY, kerning, nFontWidth, nFontHeight: Integer;
  ReadBuffer, WriteBuffer: Pointer;
  wColor, wBColor: Word;
  RGBQuad: TRGBQuad;
  Texture: TDXTexture;
  FontText: pTFontText;
  BitMap: TBitmap;
  FWidth, FHeigth: Integer;
  SizeWidth, SizeHeight: Integer;    //字符串宽度与高度
begin
  if Text = '' then
    Exit;
  if (BColor = 0) then
  begin
    TextOutEx(X, Y, Text, FColor);
    Exit;
  end;
  kerning := 0;
  Dec(X);
  Dec(Y);
  nX := 0;

  SizeWidth := TDXDrawCanvas(FDrawCanvas).TextWidth(Text) + 2;
  SizeHeight := TDXDrawCanvas(FDrawCanvas).TextHeight(Text) + 2;

  Texture := ImageFont.GetTextDIBEX(Text, FColor, clBlack);
  if Texture = nil then
  begin
    Texture := TDXTexture.Create;
    Texture.Size := Point(SizeWidth, SizeHeight);
    Texture.Behavior := tbUnmanaged;
    Texture.PatternSize := Point(SizeWidth, SizeHeight);
    Texture.Format := D3DFMT_A4R4G4B4;
    Texture.Active := True;

    BitMap := TBitmap.Create;
    try
      BitMap.PixelFormat := pf32bit;
      BitMap.Canvas.Font.Name := MainForm.Canvas.Font.Name;
      BitMap.Canvas.Font.Size := MainForm.Canvas.Font.Size;
      BitMap.Canvas.Font.Style := MainForm.Canvas.Font.Style;    //字体类型, 比如加粗[fsBold]
      BitMap.Canvas.Brush.Color := clRed;
      BitMap.TransparentColor := clRed;
      BitMap.Transparent := True;
      BitMap.Canvas.Handle := GetDC(GetDesktopWindow());
      FWidth := SizeWidth;
      FHeigth := SizeHeight;
      BitMap.Width := FWidth;
      BitMap.Height := FHeigth;
      TextOutBold(BitMap.Canvas, 1, 1, clWhite, clBlack, Text);
      Texture.LoadFromBitmapEX(BitMap);
    finally
      FreeAndNil(BitMap);
    end;

    New(FontText);
    FontText.Font := Texture;
    FontText.Text := Text;
    FontText.Time := GetTickCount;
    FontText.Name := MainForm.Canvas.Font.Name;
    FontText.Size := MainForm.Canvas.Font.Size;
    FontText.Style := MainForm.Canvas.Font.Style;    //字体类型, 比如加粗[fsBold]
    FontText.FColor := FColor;
    FontText.BColor := clBlack;
    ImageFont.FontTextList.Add(FontText);
  end;

  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((Word(RGBQuad.rgbRed) and $F0) shl 4) + (Word(RGBQuad.rgbGreen) and $F0) + (Word(RGBQuad.rgbBlue) shr 4);

  if boClearMark then
  begin
    wBColor := 0;
  end
  else
  begin
    BColor := DisplaceRB(BColor or $FF000000);
    RGBQuad := PRGBQuad(@BColor)^;
    wBColor := ($F0 shl 8) + ((Word(RGBQuad.rgbRed) and $F0) shl 4) + (Word(RGBQuad.rgbGreen) and $F0) + (Word(RGBQuad.rgbBlue) shr 4);
  end;

  if Texture.Lock(lfReadOnly, SourceAccess) then
  begin
    try
      if Lock(lfWriteOnly, Access) then
      begin
        try
          while Text <> '' do
          begin
            if X >= Width then
              Break;
            AsciiRect := Texture.ClientRect;
            if (AsciiRect.Right > 4) then
            begin
              nY := Y;
              nFontWidth := AsciiRect.Right - AsciiRect.Left;
              if nFontWidth < 4 then
                Continue;
              if X < 0 then
              begin
                nX := -X;
                if (-X) >= (nFontWidth + kerning) then
                begin
                  Inc(X, nFontWidth + kerning);
                  Continue;
                  //Break;
                end;
                AsciiRect.Left := AsciiRect.Left - X;
                nFontWidth := AsciiRect.Right - AsciiRect.Left;
                if nFontWidth <= 0 then
                begin
                  X := kerning;
                  Continue;
                end;
                X := 0;
              end;
              if (X + nFontWidth) >= Width then
              begin
                nFontWidth := Width - X;
                if nFontWidth <= 0 then
                  Exit;
              end;

              if nY < 0 then
              begin
                AsciiRect.Top := AsciiRect.Top - nY;
                nY := 0;
              end;
              nFontHeight := AsciiRect.Bottom - AsciiRect.Top;
              if nFontHeight <= 0 then
              begin
                Inc(X, nFontWidth + kerning);
                Continue;
              end;

              for j := AsciiRect.Top to AsciiRect.Bottom - 1 do
              begin
                if nY >= Height then
                  Break;
                ReadBuffer := Pointer(Integer(SourceAccess.Bits) + SourceAccess.Pitch * j + (nX * 4));
                WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * nY + X * 2);
                asm
                    push                esi
                    push                edi
                    push                ebx
                    push                edx
                    mov                 esi, ReadBuffer
                    mov                 edi, WriteBuffer
                    mov                 ecx, nFontWidth
                    mov                 dx, wColor
                    mov                 bx, wBColor

@pixloop:
                    mov                 ax, [esi].Word
                    add                 esi, 4
                    cmp                 ax, 0
                    JE                  @@Next
                    cmp                 ax, $F000
                    JE                  @@AddBColor
                    AND                 ax, dx
                    mov                 [edi], dx
                    JMP                 @@Next

@@AddBColor:
                    mov                 [edi], bx

@@Next:
                    add                 edi, 2
                    Dec                 ecx
                    jnz                 @pixloop
                    pop                 edx
                    pop                 ebx
                    pop                 edi
                    pop                 esi
                end;
                Inc(nY);
              end;
              Inc(X, nFontWidth + kerning);
            end;
            Text := '';
          end;
        finally
          Unlock;
        end;
      end;
    finally
      Texture.Unlock;
    end;
  end;
end;

//加入粗体
procedure TDXTexture.TextBoldOutEx(X, Y: Integer; Text: WideString);
begin
  TextOutEx(X, Y, Text, clWhite);
end;

procedure TDXTexture.TextBoldOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal);
var
  Access, SourceAccess: TDXAccessInfo;
  AsciiRect: TRect;
  j, nX, nY, kerning, nFontWidth, nFontHeight: Integer;
  ReadBuffer, WriteBuffer: Pointer;
  wColor: Word;
  RGBQuad: TRGBQuad;
  Texture: TDXTexture;
  FontText: pTFontText;
  BitMap: TBitmap;
  FWidth, FHeigth: Integer;
  SizeWidth, SizeHeight: Integer;    //字符串宽度与高度
begin
  if Text = '' then
    Exit;
  kerning := 0;
  nX := 0;
  Dec(X);
  Dec(Y);

  SizeWidth := TDXDrawCanvas(FDrawCanvas).TextWidth(Text) * 2;
  SizeHeight := TDXDrawCanvas(FDrawCanvas).TextHeight(Text) + 10;

  Texture := ImageFont.GetTextBoldDIBEX(Text, FColor, clBlack);
  if Texture = nil then
  begin
    Texture := TDXTexture.Create;
    Texture.Size := Point(SizeWidth, SizeHeight);
    Texture.Behavior := tbUnmanaged;
    Texture.PatternSize := Point(SizeWidth, SizeHeight);
    Texture.Format := D3DFMT_A4R4G4B4;
    Texture.Active := True;

    BitMap := TBitmap.Create;
    try
      BitMap.PixelFormat := pf32bit;
      BitMap.Canvas.Font.Name := MainForm.Canvas.Font.Name;      //字体名称
      BitMap.Canvas.Font.Size := MainForm.Canvas.Font.Size;      //字体大小
      BitMap.Canvas.Font.Style := [fsBold];    //字体类型, 比如加粗[fsBold]
      BitMap.Canvas.Brush.Color := clRed;
      BitMap.TransparentColor := clRed;
      BitMap.Transparent := True;
      BitMap.Canvas.Handle := GetDC(GetDesktopWindow());
//        FWidth := BitMap.Canvas.TextWidth(Text) + 2;
//        FHeigth := BitMap.Canvas.TextHeight(Text) + 2;
      FWidth := SizeWidth;
      FHeigth := SizeHeight;
      BitMap.Width := FWidth;
      BitMap.Height := FHeigth;
      TextOutBold(BitMap.Canvas, 1, 1, clWhite, clBlack, Text);
      Texture.LoadFromBitmapEX(BitMap);
    finally
      FreeAndNil(BitMap);
    end;

    New(FontText);
    FontText.Font := Texture;
    FontText.Text := Text;
    FontText.Time := GetTickCount;
    FontText.Name := MainForm.Canvas.Font.Name;
    FontText.Size := MainForm.Canvas.Font.Size;
    FontText.Style := [fsBold];    //字体类型, 比如加粗[fsBold]
    FontText.FColor := FColor;
    FontText.BColor := clBlack;
    ImageFont.FontTextBoldList.Add(FontText);
  end;

  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((Word(RGBQuad.rgbRed) and $F0) shl 4) + (Word(RGBQuad.rgbGreen) and $F0) + (Word(RGBQuad.rgbBlue) shr 4);

  if Texture.Lock(lfReadOnly, SourceAccess) then
  begin
    try
      if Lock(lfWriteOnly, Access) then
      begin
        try
          while Text <> '' do
          begin
            if X >= Width then
              Break;
            AsciiRect := Texture.ClientRect;
            if (AsciiRect.Right > 4) then
            begin
              nY := Y;
              nFontWidth := AsciiRect.Right - AsciiRect.Left;
              if nFontWidth < 4 then
                Continue;
              if X < 0 then
              begin
                nX := -X;
                if (-X) >= (nFontWidth + kerning) then
                begin
                  Inc(X, nFontWidth + kerning);     //修复X提示
                  Continue;
                end;
                AsciiRect.Left := AsciiRect.Left - X;
                nFontWidth := AsciiRect.Right - AsciiRect.Left;
                if nFontWidth <= 0 then
                begin
                  X := kerning;
                  Continue;
                end;
                X := 0;
              end;
              if (X + nFontWidth) >= Width then
              begin
                nFontWidth := Width - X;
                if nFontWidth <= 0 then
                  Exit;
              end;

              if nY < 0 then
              begin
                AsciiRect.Top := AsciiRect.Top - nY;
                nY := 0;
              end;
              nFontHeight := AsciiRect.Bottom - AsciiRect.Top;
              if nFontHeight <= 0 then
              begin
                Inc(X, nFontWidth + kerning);
                Continue;
              end;

              for j := AsciiRect.Top to AsciiRect.Bottom - 1 do
              begin
                if nY >= Height then
                  Break;
                ReadBuffer := Pointer(Integer(SourceAccess.Bits) + SourceAccess.Pitch * j + (nX * 4));
                WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * nY + X * 2);
                asm
                    push                esi
                    push                edi
                    push                ebx
                    push                edx
                    mov                 esi, ReadBuffer
                    mov                 edi, WriteBuffer
                    mov                 ecx, nFontWidth
                    mov                 dx, wColor

@pixloop:
                    mov                 ax, [esi].Word
                    add                 esi, 4
                    cmp                 ax, 0
                    JE                  @@Next
                    AND                 ax, dx
                    mov                 [edi], ax

@@Next:
                    add                 edi, 2
                    Dec                 ecx
                    jnz                 @pixloop
                    pop                 edx
                    pop                 ebx
                    pop                 edi
                    pop                 esi
                end;
                Inc(nY);
              end;
              Inc(X, nFontWidth + kerning);
            end;
            Text := '';
          end;
        finally
          Unlock;
        end;
      end;
    finally
      Texture.Unlock;
    end;
  end;
end;

procedure TDXTexture.TextBoldOutExx(X, Y: Integer; Text: WideString; FColor: Cardinal);
var
  Access, SourceAccess: TDXAccessInfo;
  AsciiRect: TRect;
  j, nX, nY, kerning, nFontWidth, nFontHeight: Integer;
  ReadBuffer, WriteBuffer: Pointer;
  wColor: Word;
  RGBQuad: TRGBQuad;
  Texture: TDXTexture;
  FontText: pTFontText;
  BitMap: TBitmap;
  FWidth, FHeigth: Integer;
  SizeWidth, SizeHeight: Integer;    //字符串宽度与高度
begin
  if Text = '' then
    Exit;
  kerning := 0;
  nX := 0;
  Dec(X);
  Dec(Y);
  SizeWidth := TDXDrawCanvas(FDrawCanvas).TextWidth(Text) * 2;
  SizeHeight := TDXDrawCanvas(FDrawCanvas).TextHeight(Text) + 10;
  Texture := ImageFont.GetTextBoldDIBEX(Text, FColor, clBlack);
  if Texture = nil then
  begin
    Texture := TDXTexture.Create;
    Texture.Size := Point(SizeWidth, SizeHeight);
    Texture.Behavior := tbUnmanaged;
    Texture.PatternSize := Point(SizeWidth, SizeHeight);
    Texture.Format := D3DFMT_A4R4G4B4;
    Texture.Active := True;
    BitMap := TBitmap.Create;
    try
      BitMap.PixelFormat := pf32bit;
      BitMap.Canvas.Font.Name := MainForm.Canvas.Font.Name;      //字体名称
      BitMap.Canvas.Font.Size := MainForm.Canvas.Font.Size + 2;      //字体大小
      BitMap.Canvas.Font.Style := [fsBold];    //字体类型, 比如加粗[fsBold]
      BitMap.Canvas.Brush.Color := clRed;
      BitMap.TransparentColor := clRed;
      BitMap.Transparent := True;
      BitMap.Canvas.Handle := GetDC(GetDesktopWindow());
      FWidth := SizeWidth;
      FHeigth := SizeHeight;
      BitMap.Width := FWidth;
      BitMap.Height := FHeigth;
      TextOutBold(BitMap.Canvas, 1, 1, clWhite, clBlack, Text);
      Texture.LoadFromBitmapEX(BitMap);
    finally
      FreeAndNil(BitMap);
    end;
    New(FontText);
    FontText.Font := Texture;
    FontText.Text := Text;
    FontText.Time := GetTickCount;
    FontText.Name := MainForm.Canvas.Font.Name;
    FontText.Size := MainForm.Canvas.Font.Size + 2;
    FontText.Style := [fsBold];    //字体类型, 比如加粗[fsBold]
    FontText.FColor := FColor;
    FontText.BColor := clBlack;
    ImageFont.FontTextBoldList.Add(FontText);
  end;
  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((Word(RGBQuad.rgbRed) and $F0) shl 4) + (Word(RGBQuad.rgbGreen) and $F0) + (Word(RGBQuad.rgbBlue) shr 4);
  if Texture.Lock(lfReadOnly, SourceAccess) then
  begin
    try
      if Lock(lfWriteOnly, Access) then
      begin
        try
          while Text <> '' do
          begin
            if X >= Width then
              Break;
            AsciiRect := Texture.ClientRect;
            if (AsciiRect.Right > 4) then
            begin
              nY := Y;
              nFontWidth := AsciiRect.Right - AsciiRect.Left;
              if nFontWidth < 4 then
                Continue;
              if X < 0 then
              begin
                nX := -X;
                if (-X) >= (nFontWidth + kerning) then
                begin
                  Inc(X, nFontWidth + kerning);     //修复X提示
                  Continue;
                end;
                AsciiRect.Left := AsciiRect.Left - X;
                nFontWidth := AsciiRect.Right - AsciiRect.Left;
                if nFontWidth <= 0 then
                begin
                  X := kerning;
                  Continue;
                end;
                X := 0;
              end;
              if (X + nFontWidth) >= Width then
              begin
                nFontWidth := Width - X;
                if nFontWidth <= 0 then
                  Exit;
              end;

              if nY < 0 then
              begin
                AsciiRect.Top := AsciiRect.Top - nY;
                nY := 0;
              end;
              nFontHeight := AsciiRect.Bottom - AsciiRect.Top;
              if nFontHeight <= 0 then
              begin
                Inc(X, nFontWidth + kerning);
                Continue;
              end;

              for j := AsciiRect.Top to AsciiRect.Bottom - 1 do
              begin
                if nY >= Height then
                  Break;
                ReadBuffer := Pointer(Integer(SourceAccess.Bits) + SourceAccess.Pitch * j + (nX * 4));
                WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * nY + X * 2);
                asm
                    push                esi
                    push                edi
                    push                ebx
                    push                edx
                    mov                 esi, ReadBuffer
                    mov                 edi, WriteBuffer
                    mov                 ecx, nFontWidth
                    mov                 dx, wColor
@pixloop:
                    mov                 ax, [esi].Word
                    add                 esi, 4
                    cmp                 ax, 0
                    JE                  @@Next
                    AND                 ax, dx
                    mov                 [edi], ax
@@Next:
                    add                 edi, 2
                    Dec                 ecx
                    jnz                 @pixloop
                    pop                 edx
                    pop                 ebx
                    pop                 edi
                    pop                 esi
                end;
                Inc(nY);
              end;
              Inc(X, nFontWidth + kerning);
            end;
            Text := '';
          end;
        finally
          Unlock;
        end;
      end;
    finally
      Texture.Unlock;
    end;
  end;
end;


procedure TDXTexture.TextBoldOutExxx(X, Y: Integer; Text: WideString; FColor: Cardinal);
var
  Access, SourceAccess: TDXAccessInfo;
  AsciiRect: TRect;
  j, nX, nY, kerning, nFontWidth, nFontHeight: Integer;
  ReadBuffer, WriteBuffer: Pointer;
  wColor: Word;
  RGBQuad: TRGBQuad;
  Texture: TDXTexture;
  FontText: pTFontText;
  BitMap: TBitmap;
  FWidth, FHeigth: Integer;
  SizeWidth, SizeHeight: Integer;    //字符串宽度与高度
begin
  if Text = '' then
    Exit;
  kerning := 0;
  nX := 0;
  Dec(X);
  Dec(Y);
  SizeWidth := TDXDrawCanvas(FDrawCanvas).TextWidth(Text) * 2;
  SizeHeight := TDXDrawCanvas(FDrawCanvas).TextHeight(Text) + 10;
  Texture := ImageFont.GetTextBoldDIBEX(Text, FColor, clBlack);
  if Texture = nil then
  begin
    Texture := TDXTexture.Create;
    Texture.Size := Point(SizeWidth, SizeHeight);
    Texture.Behavior := tbUnmanaged;
    Texture.PatternSize := Point(SizeWidth, SizeHeight);
    Texture.Format := D3DFMT_A4R4G4B4;
    Texture.Active := True;
    BitMap := TBitmap.Create;
    try
      BitMap.PixelFormat := pf32bit;
      BitMap.Canvas.Font.Name := '新宋体';      //字体名称
      BitMap.Canvas.Font.Size := MainForm.Canvas.Font.Size;      //字体大小
      BitMap.Canvas.Font.Style := [fsBold];    //字体类型, 比如加粗[fsBold]
      BitMap.Canvas.Brush.Color := clRed;
      BitMap.TransparentColor := clRed;
      BitMap.Transparent := True;
      BitMap.Canvas.Handle := GetDC(GetDesktopWindow());
      FWidth := SizeWidth;
      FHeigth := SizeHeight;
      BitMap.Width := FWidth;
      BitMap.Height := FHeigth;
      TextOutBold(BitMap.Canvas, 1, 1, clWhite, clBlack, Text);
      Texture.LoadFromBitmapEX(BitMap);
    finally
      FreeAndNil(BitMap);
    end;
    New(FontText);
    FontText.Font := Texture;
    FontText.Text := Text;
    FontText.Time := GetTickCount;
    FontText.Name := '新宋体';
    FontText.Size := MainForm.Canvas.Font.Size;
    FontText.Style := [fsBold];    //字体类型, 比如加粗[fsBold]
    FontText.FColor := FColor;
    FontText.BColor := clBlack;
    ImageFont.FontTextBoldList.Add(FontText);
  end;
  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((Word(RGBQuad.rgbRed) and $F0) shl 4) + (Word(RGBQuad.rgbGreen) and $F0) + (Word(RGBQuad.rgbBlue) shr 4);
  if Texture.Lock(lfReadOnly, SourceAccess) then
  begin
    try
      if Lock(lfWriteOnly, Access) then
      begin
        try
          while Text <> '' do
          begin
            if X >= Width then
              Break;
            AsciiRect := Texture.ClientRect;
            if (AsciiRect.Right > 4) then
            begin
              nY := Y;
              nFontWidth := AsciiRect.Right - AsciiRect.Left;
              if nFontWidth < 4 then
                Continue;
              if X < 0 then
              begin
                nX := -X;
                if (-X) >= (nFontWidth + kerning) then
                begin
                  Inc(X, nFontWidth + kerning);     //修复X提示
                  Continue;
                end;
                AsciiRect.Left := AsciiRect.Left - X;
                nFontWidth := AsciiRect.Right - AsciiRect.Left;
                if nFontWidth <= 0 then
                begin
                  X := kerning;
                  Continue;
                end;
                X := 0;
              end;
              if (X + nFontWidth) >= Width then
              begin
                nFontWidth := Width - X;
                if nFontWidth <= 0 then
                  Exit;
              end;

              if nY < 0 then
              begin
                AsciiRect.Top := AsciiRect.Top - nY;
                nY := 0;
              end;
              nFontHeight := AsciiRect.Bottom - AsciiRect.Top;
              if nFontHeight <= 0 then
              begin
                Inc(X, nFontWidth + kerning);
                Continue;
              end;

              for j := AsciiRect.Top to AsciiRect.Bottom - 1 do
              begin
                if nY >= Height then
                  Break;
                ReadBuffer := Pointer(Integer(SourceAccess.Bits) + SourceAccess.Pitch * j + (nX * 4));
                WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * nY + X * 2);
                asm
                    push                esi
                    push                edi
                    push                ebx
                    push                edx
                    mov                 esi, ReadBuffer
                    mov                 edi, WriteBuffer
                    mov                 ecx, nFontWidth
                    mov                 dx, wColor
@pixloop:
                    mov                 ax, [esi].Word
                    add                 esi, 4
                    cmp                 ax, 0
                    JE                  @@Next
                    AND                 ax, dx
                    mov                 [edi], ax
@@Next:
                    add                 edi, 2
                    Dec                 ecx
                    jnz                 @pixloop
                    pop                 edx
                    pop                 ebx
                    pop                 edi
                    pop                 esi
                end;
                Inc(nY);
              end;
              Inc(X, nFontWidth + kerning);
            end;
            Text := '';
          end;
        finally
          Unlock;
        end;
      end;
    finally
      Texture.Unlock;
    end;
  end;
end;

procedure TDXTexture.TextBoldOutEx(X, Y: Integer; Text: WideString; FColor, BColor: Cardinal; boClearMark: Boolean);
var
  Access, SourceAccess: TDXAccessInfo;
  AsciiRect: TRect;
  j, nX, nY, kerning, nFontWidth, nFontHeight: Integer;
  ReadBuffer, WriteBuffer: Pointer;
  wColor, wBColor: Word;
  RGBQuad: TRGBQuad;
  Texture: TDXTexture;
  FontText: pTFontText;
  BitMap: TBitmap;
  FWidth, FHeigth: Integer;
  SizeWidth, SizeHeight: Integer;    //字符串宽度与高度
begin
  if Text = '' then
    Exit;
  if (BColor = 0) then
  begin
    TextBoldOutEx(X, Y, Text, FColor);
    Exit;
  end;
  kerning := 0;
  Dec(X);
  Dec(Y);
  nX := 0;

  SizeWidth := TDXDrawCanvas(FDrawCanvas).TextWidth(Text) * 2;
  SizeHeight := TDXDrawCanvas(FDrawCanvas).TextHeight(Text) + 10;

  Texture := ImageFont.GetTextBoldDIBEX(Text, FColor, clBlack);
  if Texture = nil then
  begin
    Texture := TDXTexture.Create;
    Texture.Size := Point(SizeWidth, SizeHeight);
    Texture.Behavior := tbUnmanaged;
    Texture.PatternSize := Point(SizeWidth, SizeHeight);
    Texture.Format := D3DFMT_A4R4G4B4;
    Texture.Active := True;

    BitMap := TBitmap.Create;
    try
      BitMap.PixelFormat := pf32bit;
      BitMap.Canvas.Font.Name := MainForm.Canvas.Font.Name;
      BitMap.Canvas.Font.Size := MainForm.Canvas.Font.Size;
      BitMap.Canvas.Font.Style := [fsBold];    //字体类型, 比如加粗[fsBold]
      BitMap.Canvas.Brush.Color := clRed;
      BitMap.TransparentColor := clRed;
      BitMap.Transparent := True;
      BitMap.Canvas.Handle := GetDC(GetDesktopWindow());
      FWidth := SizeWidth;
      FHeigth := SizeHeight;
      BitMap.Width := FWidth;
      BitMap.Height := FHeigth;
      TextOutBold(BitMap.Canvas, 1, 1, clWhite, clBlack, Text);
      Texture.LoadFromBitmapEX(BitMap);
    finally
      FreeAndNil(BitMap);
    end;

    New(FontText);
    FontText.Font := Texture;
    FontText.Text := Text;
    FontText.Time := GetTickCount;
    FontText.Name := MainForm.Canvas.Font.Name;
    FontText.Size := MainForm.Canvas.Font.Size;
    FontText.Style := [fsBold];    //字体类型, 比如加粗[fsBold]
    FontText.FColor := FColor;
    FontText.BColor := clBlack;
    ImageFont.FontTextBoldList.Add(FontText);
  end;

  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((Word(RGBQuad.rgbRed) and $F0) shl 4) + (Word(RGBQuad.rgbGreen) and $F0) + (Word(RGBQuad.rgbBlue) shr 4);

  if boClearMark then
  begin
    wBColor := 0;
  end
  else
  begin
    BColor := DisplaceRB(BColor or $FF000000);
    RGBQuad := PRGBQuad(@BColor)^;
    wBColor := ($F0 shl 8) + ((Word(RGBQuad.rgbRed) and $F0) shl 4) + (Word(RGBQuad.rgbGreen) and $F0) + (Word(RGBQuad.rgbBlue) shr 4);
  end;

  if Texture.Lock(lfReadOnly, SourceAccess) then
  begin
    try
      if Lock(lfWriteOnly, Access) then
      begin
        try
          while Text <> '' do
          begin
            if X >= Width then
              Break;
            AsciiRect := Texture.ClientRect;
            if (AsciiRect.Right > 4) then
            begin
              nY := Y;
              nFontWidth := AsciiRect.Right - AsciiRect.Left;
              if nFontWidth < 4 then
                Continue;
              if X < 0 then
              begin
                nX := -X;
                if (-X) >= (nFontWidth + kerning) then
                begin
                  Inc(X, nFontWidth + kerning);
                  Continue;
                  //Break;
                end;
                AsciiRect.Left := AsciiRect.Left - X;
                nFontWidth := AsciiRect.Right - AsciiRect.Left;
                if nFontWidth <= 0 then
                begin
                  X := kerning;
                  Continue;
                end;
                X := 0;
              end;
              if (X + nFontWidth) >= Width then
              begin
                nFontWidth := Width - X;
                if nFontWidth <= 0 then
                  Exit;
              end;

              if nY < 0 then
              begin
                AsciiRect.Top := AsciiRect.Top - nY;
                nY := 0;
              end;
              nFontHeight := AsciiRect.Bottom - AsciiRect.Top;
              if nFontHeight <= 0 then
              begin
                Inc(X, nFontWidth + kerning);
                Continue;
              end;

              for j := AsciiRect.Top to AsciiRect.Bottom - 1 do
              begin
                if nY >= Height then
                  Break;
                ReadBuffer := Pointer(Integer(SourceAccess.Bits) + SourceAccess.Pitch * j + (nX * 4));
                WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * nY + X * 2);
                asm
                    push                esi
                    push                edi
                    push                ebx
                    push                edx
                    mov                 esi, ReadBuffer
                    mov                 edi, WriteBuffer
                    mov                 ecx, nFontWidth
                    mov                 dx, wColor
                    mov                 bx, wBColor

@pixloop:
                    mov                 ax, [esi].Word
                    add                 esi, 4
                    cmp                 ax, 0
                    JE                  @@Next
                    cmp                 ax, $F000
                    JE                  @@AddBColor
                    AND                 ax, dx
                    mov                 [edi], dx
                    JMP                 @@Next

@@AddBColor:
                    mov                 [edi], bx

@@Next:
                    add                 edi, 2
                    Dec                 ecx
                    jnz                 @pixloop
                    pop                 edx
                    pop                 ebx
                    pop                 edi
                    pop                 esi
                end;
                Inc(nY);
              end;
              Inc(X, nFontWidth + kerning);
            end;
            Text := '';
          end;
        finally
          Unlock;
        end;
      end;
    finally
      Texture.Unlock;
    end;
  end;
end;

procedure TDXTexture.StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; Transparent: Boolean);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawStretch(Source, SrcRect.Left, SrcRect.Top, SrcRect.Right, SrcRect.Bottom, DesRect, bTransparent[Transparent]);
end;

function TDXTexture.Unlock: Boolean;
begin
  Result := (FTexture <> nil) and (FTexture.Handle <> nil) and (Succeeded(FTexture.Handle.UnlockRect(0)));
end;

function TDXTexture.Width: Integer;
begin
  Result := FSize.X;
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean; DrawFx: Cardinal);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawRect(Source, X, Y, SrcRect, DrawFx, $7DFFFFFF);
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent, MirrorX, MirrorY: Boolean);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawRect(Source, X, Y, SrcRect, bTransparent[Transparent], $FFFFFFFF, MirrorX, MirrorY);
end;

procedure TDXTexture.Draw(X, Y: Integer; Source: TDXTexture; Transparent, MirrorX, MirrorY: Boolean);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).Draw(Source, X, Y, bTransparent[Transparent], $FFFFFFFF, MirrorX, MirrorY);
end;

{ TDXImageTexture }

function TDXImageTexture.ClientRect: TRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := FPatternSize.X;
  Result.Bottom := FPatternSize.Y;
end;

constructor TDXImageTexture.Create(DrawCanvas: TObject);
begin
  inherited Create(DrawCanvas);
  FFormat := D3DFMT_A1R5G5B5;
  FBehavior := tbManaged;
end;

function TDXImageTexture.Height: Integer;
begin
  Result := FPatternSize.Y;
end;

function TDXImageTexture.Width: Integer;
begin
  Result := FPatternSize.X;
end;

{ TDXRenderTargetTexture }

constructor TDXRenderTargetTexture.Create(DrawCanvas: TObject);
begin
  inherited;
  FTarget := nil;
end;

destructor TDXRenderTargetTexture.Destroy;
begin
  FTarget := nil;
  FTexture := nil;
  inherited;
end;

function TDXRenderTargetTexture.GetActive: Boolean;
begin
  Result := (FTarget <> nil) and (FTexture <> nil);
end;

procedure TDXRenderTargetTexture.Lost;
begin
  FTexture := nil;
end;

procedure TDXRenderTargetTexture.MakeNotReady;
begin
  FTarget := nil;
end;

function TDXRenderTargetTexture.MakeReady: Boolean;
begin
  Result := False;
  if FTarget = nil then
  begin
    FTarget := FHGE.Target_Create(FSize.X, FSize.Y, False);
    if FTarget <> nil then
    begin
      FTexture := FTarget.GetTexture;
      if FTexture <> nil then
      begin
        FPatternSize.X := FSize.X;
        FPatternSize.Y := FSize.Y;
        FSize.X := FTexture.GetWidth();
        FSize.Y := FTexture.GetHeight();
      end;
    end;
    Result := (FTarget <> nil) and (FTexture <> nil);
  end;
end;

procedure TDXRenderTargetTexture.Recovered;
begin
  if FTarget <> nil then
    FTexture := FTarget.GetTexture;
end;

procedure TDXRenderTargetTexture.SetActive(const Value: Boolean);
begin
  if Value then
    MakeReady
  else
    MakeNotReady;
end;

initialization
  FHGE := nil;

finalization
  FHGE := nil;

end.



