unit Gfxfont;

interface

uses
  Windows, HGE, HGESprite;

const
  Font_Count = High(Word);

type
  tagEngineFontGlyph = record
    t: ITexture;
    w: Single;
    h: Single;
    x: Single;
    y: Single;
    c: Single;
  end;

  TENGINEFONTGLYPH = tagEngineFontGlyph;

  TGfxFont = class
  public
    constructor Create(const FontName: PWideChar; FaceSize: Integer; bBold: Boolean = False; bItalic: Boolean = False; bAntialias: Boolean = True);
    destructor Destroy(); override;
  public
    // 渲染文本
    procedure Print(X: Single; Y: Single; Text: PWideChar);
    // 设置与获取颜色
    procedure SetColor(Color: Cardinal; i: Integer = -1);
    function GetColor(i: Integer = 0): Cardinal;
    // 获取文本宽高
    function GetTextSize(Text: PWideChar): TSize;
    // 根据坐标获取字符
    function GetCharacterFromPos(Text: PWideChar; Pixel_X, Pixel_Y: Single): WideChar;
    // 设置字间距
    procedure SetKerningWidth(Kerning: Single);
    procedure SetKerningHeight(Kerning: Single);
    // 获取字间距
    function GetKerningWidth(): Single;
    function GetKerningHeight(): Single;
    // 字体大小
    function GetFontSize(): Single;
  private
    m_Glyphs: array[0..Font_Count - 1] of TENGINEFONTGLYPH;
    m_nAntialias: Cardinal; //反锯齿
    m_nAscent: Integer; //基线
    //m_dwFontColor: Cardinal;
    m_nFontSize: Single;
    m_nKerningWidth: Single;
    m_nKerningHeight: Single;
    m_pHGE: IHGE;
    m_pSprite: IHGESprite;
    // GDI设备
    m_hMemDC: HDC;
    m_hFont: HFONT;
    function GetGlyphByCharacter(C: WideChar): Cardinal;
    function GetWidthFromCharacter(C: WideChar; Original: Boolean = False): Single;
    procedure CacheCharacter(Idx: Cardinal; C: WideChar);
  end;

implementation

{ TGfxFont }

const
  g_byAlphaLever: array[0..65 - 1] of Byte = (0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144, 148, 152, 156, 160, 164, 168, 172, 176, 180, 184, 188, 192, 196, 200, 204, 208, 212, 216, 220, 224, 228, 232, 236, 240, 244, 248, 252, 255);

const
  WideNull = WideChar(#0);
  WideCR = WideChar(#13);
  WideLF = WideChar(#10);
  WideCRLF: WideString = #13#10;

type
  TByteAry = array[0..0] of Byte;

  PByteAry = ^TByteAry;

procedure TGfxFont.CacheCharacter(Idx: Cardinal; C: WideChar);
var
  nChar: Cardinal;
  mat: MAT2;
  gm: GLYPHMETRICS;
  nLen: Cardinal;
  hTex: ITexture;
  lpBuf: PByteAry;
  lpSrc: PByteAry;
  lpDst: PLongWord;
  nSrcPitch, nDstPitch: Cardinal;
  x, y, k, i: Cardinal;
begin
  if (Idx < Font_Count) and (m_Glyphs[Idx].t = nil) then begin
    nChar := Cardinal(C);
    mat.eM11.fract := 0;
    mat.eM11.value := 1;
    mat.eM12.fract := 0;
    mat.eM12.value := 0;
    mat.eM21.fract := 0;
    mat.eM21.value := 0;
    mat.eM22.fract := 0;
    mat.eM22.value := 1;
    nLen := GetGlyphOutlineW(m_hMemDC, nChar, m_nAntialias, gm, 0, nil, mat);
    hTex := m_pHGE.Texture_Create(gm.gmBlackBoxX, gm.gmBlackBoxY);
    if hTex = nil then
      Exit;

    if nLen > 0 then begin
      GetMem(lpBuf, nLen);
      if nLen = GetGlyphOutlineW(m_hMemDC, nChar, m_nAntialias, gm, nLen, lpBuf, mat) then begin
        lpSrc := lpBuf;
        lpDst := m_pHGE.Texture_Lock(hTex, False);
        if GGO_BITMAP = m_nAntialias then begin
          if gm.gmBlackBoxX mod 32 = 0 then
            nSrcPitch := (gm.gmBlackBoxX div 32) * 4
          else
            nSrcPitch := ((gm.gmBlackBoxX div 32) + 1) * 4;
          nDstPitch := m_pHGE.Texture_GetWidth(hTex);

          for y := 0 to gm.gmBlackBoxY - 1 do begin
            x := 0;
            while x < gm.gmBlackBoxX do begin
              for k := 0 to 7 do begin
                i := 8 * x + k;
                if i >= gm.gmBlackBoxX then begin
                  Inc(x, 7);
                  Break;
                end;
                if (lpSrc[x] shr (7 - k)) and 1 = 0 then
                  PCardinal(Cardinal(lpDst) + i * SizeOf(Integer))^ := 0
                else
                  PCardinal(Cardinal(lpDst) + i * SizeOf(Integer))^ := $FFFFFFFF;
              end;
              Inc(x);
            end;
            Inc(lpSrc, nSrcPitch);
            Inc(lpDst, nDstPitch);
          end;
        end
        else begin
          if gm.gmBlackBoxX mod 4 = 0 then
            nSrcPitch := (gm.gmBlackBoxX div 4) * 4
          else
            nSrcPitch := (gm.gmBlackBoxX div 4 + 1) * 4;
          nDstPitch := m_pHGE.Texture_GetWidth(hTex);
          for y := 0 to gm.gmBlackBoxY - 1 do begin
            for x := 0 to gm.gmBlackBoxX - 1 do
              PCardinal(Cardinal(lpDst) + x * SizeOf(Integer))^ := ARGB(g_byAlphaLever[lpSrc[x]], $FF, $FF, $FF);
            Inc(lpSrc, nSrcPitch);
            Inc(lpDst, nDstPitch);
          end;
        end;
        m_pHGE.Texture_Unlock(hTex);
      end;
      FreeMem(lpBuf);
    end
    else begin
      // 非正常显示字符
    end;
    m_Glyphs[Idx].t := hTex;
    m_Glyphs[Idx].w := gm.gmBlackBoxX;
    m_Glyphs[Idx].h := gm.gmBlackBoxY;
    m_Glyphs[Idx].x := -gm.gmptGlyphOrigin.X;
    m_Glyphs[Idx].y := gm.gmptGlyphOrigin.Y - m_nAscent;
    m_Glyphs[Idx].C := gm.gmCellIncX;
  end;
end;

constructor TGfxFont.Create(const FontName: PWideChar; FaceSize: Integer; bBold, bItalic, bAntialias: Boolean);
var
  h_DC: HDC;
  Bold: Integer;
  tm: TEXTMETRICW;
begin
  m_pHGE := HGECreate(HGE_VERSION);
  // 创建GDI相关设备
  h_DC := GetDC(m_pHGE.System_GetState(HGE_HWND));
  m_hMemDC := CreateCompatibleDC(h_DC);
  if m_hMemDC = 0 then
    Exit;

  ReleaseDC(m_pHGE.System_GetState(HGE_HWND), h_DC);
  SetMapMode(m_hMemDC, MM_TEXT);
  SetTextColor(m_hMemDC, RGB($FF, $FF, $FF));
  SetBkColor(m_hMemDC, RGB(0, 0, 0));

  if bBold then
    Bold := FW_BOLD
  else
    Bold := FW_NORMAL;
  m_hFont := CreateFontW(-FaceSize, 0, 0, 0, Bold, Integer(bItalic), Cardinal(False), Cardinal(False), DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, FF_DONTCARE or DEFAULT_PITCH, FontName);
  if m_hFont = 0 then
    Exit;

  SelectObject(m_hMemDC, m_hFont);
  FillChar(m_Glyphs, SizeOf(TENGINEFONTGLYPH) * Font_Count, 0);
  if bAntialias then
    m_nAntialias := GGO_GRAY8_BITMAP
  else
    m_nAntialias := GGO_BITMAP;
  GetTextMetricsW(m_hMemDC, tm);
  m_nAscent := tm.tmAscent;
  m_nFontSize := FaceSize;
  m_nKerningWidth := 0;
  m_nKerningHeight := 0;
  m_pSprite := THGESprite.Create(nil, 0, 0, 0, 0);
  m_pSprite.SetColor(ARGB($FF, $FF, $FF, $FF));
end;

destructor TGfxFont.Destroy;
var
  nIdx: Integer;
begin
  for nIdx := 0 to Font_Count - 1 do
    if m_Glyphs[nIdx].t <> nil then
      m_Glyphs[nIdx].t := nil;

  if m_hFont <> 0 then
    DeleteObject(m_hFont);
  if m_hMemDC <> 0 then
    DeleteDC(m_hMemDC);
  if m_pSprite <> nil then
    m_pSprite := nil;
  if m_pHGE <> nil then
    m_pHGE := nil;
  inherited;
end;

function TGfxFont.GetCharacterFromPos(Text: PWideChar; Pixel_X, Pixel_Y: Single): WideChar;
var
  X, Y, W: Single;
begin
  X := 0;
  Y := 0;
  while Text^ <> WideNull do begin
    if (Text^ = WideCR) and (PWideChar(Integer(Text) + SizeOf(WideChar))^ = WideLF) then begin
      X := 0;
      Y := m_nFontSize + m_nKerningWidth;
      Inc(Text);
      if Text^ = WideNull then
        Break;
    end;
    W := GetWidthFromCharacter(Text^);
    if (Pixel_X > X) and (Pixel_X <= X + W) and (Pixel_Y > Y) and (Pixel_Y <= Y + m_nFontSize) then begin
      Result := Text^;
      Exit;
    end;
    X := X + W + m_nKerningWidth;
    Inc(Text);
  end;
  Result := WideNull;
end;

function TGfxFont.GetColor(i: Integer): Cardinal;
begin
  Result := m_pSprite.GetColor(i);
end;

function TGfxFont.GetFontSize: Single;
begin
  Result := m_nFontSize;
end;

function TGfxFont.GetGlyphByCharacter(C: WideChar): Cardinal;
var
  Idx: Cardinal;
begin
  Idx := Cardinal(C);
  if m_Glyphs[Idx].t = nil then
    CacheCharacter(Idx, C);
  Result := Idx;
end;

function TGfxFont.GetKerningHeight: Single;
begin
  Result := m_nKerningHeight;
end;

function TGfxFont.GetKerningWidth: Single;
begin
  Result := m_nKerningWidth;
end;

function TGfxFont.GetTextSize(Text: PWideChar): TSize;
var
  Dim: TSize;
  nRowWidth: Single;
begin
  nRowWidth := 0;
  Dim.cx := 0;
  Dim.cy := Round(m_nFontSize);
  while Text^ <> WideNull do begin
    if (Text^ = WideCR) and (PWideChar(Integer(Text) + SizeOf(WideChar))^ = WideLF) then begin
      Dim.cy := Round(m_nFontSize + m_nKerningHeight);
      if Dim.cx < nRowWidth then
        Dim.cx := Round(nRowWidth);
      nRowWidth := 0;
      Inc(Text, 2);
    end
    else begin
      nRowWidth := nRowWidth + GetWidthFromCharacter(Text^) + m_nKerningWidth;
      Inc(Text);
    end;
  end;
  if Dim.cx < Round(nRowWidth) then
    Dim.cx := Round(nRowWidth);
  Result := Dim;
end;

function TGfxFont.GetWidthFromCharacter(C: WideChar; Original: Boolean): Single;
var
  Idx: Cardinal;
begin
  Idx := GetGlyphByCharacter(C);
  if Original and (Idx > 0) and (Idx < Font_Count) then begin
    Result := m_Glyphs[Idx].C;
    Exit;
  end;
  if Idx >= $2000 then
    Result := m_nFontSize
  else
    Result := m_nFontSize / 2;
end;

procedure TGfxFont.Print(X, Y: Single; Text: PWideChar);
var
  OffsetX, OffsetY: Single;
  Idx: Cardinal;
begin
  OffsetX := X;
  OffsetY := Y;
  while Text^ <> WideNull do begin
    if (Text^ = WideCR) and (PWideChar(Integer(Text) + SizeOf(WideChar))^ = WideLF) then begin
      OffsetX := X;
      OffsetY := OffsetY + m_nFontSize + m_nKerningHeight;
      Inc(Text, 2);
    end
    else begin
      Idx := GetGlyphByCharacter(Text^);
      if Idx > 0 then begin
        m_pSprite.SetTexture(m_Glyphs[Idx].t);
        m_pSprite.SetTextureRect(0, 0, m_Glyphs[Idx].W, m_Glyphs[Idx].h);
        m_pSprite.Render(OffsetX - m_Glyphs[Idx].X, OffsetY - m_Glyphs[Idx].Y);
        OffsetX := OffsetX + GetWidthFromCharacter(Text^) + m_nKerningWidth;
      end
      else
        OffsetX := OffsetX + GetWidthFromCharacter(Text^) + m_nKerningWidth;

      Inc(Text);
    end;
  end;
end;

procedure TGfxFont.SetColor(Color: Cardinal; i: Integer);
begin
  m_pSprite.SetColor(Color, i);
end;

procedure TGfxFont.SetKerningHeight(Kerning: Single);
begin
  m_nKerningHeight := Kerning;
end;

procedure TGfxFont.SetKerningWidth(Kerning: Single);
begin
  m_nKerningWidth := Kerning;
end;

end.

