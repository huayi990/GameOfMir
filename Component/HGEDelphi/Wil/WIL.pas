unit WIL;

interface
uses
  System.Classes, System.SysUtils, System.Types, Winapi.Windows, Winapi.Direct3D9,
  Vcl.Graphics, Wilpion, ZLIB, HGECanvas, HGETextures;

{$INCLUDE BitChange.inc}

type
 TWILColorFormat = (WILFMT_A4R4G4B4, WILFMT_A1R5G5B5, WILFMT_R5G6B5, WILFMT_A8R8G8B8);


const
  MAXIMAGECOUNT = 10000000;
  MINIMAGESIZE = 2;
  MAXIMAGESIZE = 2048;

//位移宽高，进行加密
//图像最大宽高不能大于 4095 不然会出错，要修改位移时的处理

  FILETYPE_IMAGE = $1F;  //图像文件
  FILETYPE_DATA = $2F;   //数据文件
  FILETYPE_WAVA = $3F;   //WAVA文件
  FILETYPE_MP3 = $4F;    //MP3文件

 ColorFormat: array[TWILColorFormat] of TD3DFormat = (D3DFMT_A4R4G4B4, D3DFMT_A1R5G5B5, D3DFMT_R5G6B5, D3DFMT_A8R8G8B8);

 g_dwLoadSurfaceTime = 60 * 1000;
 g_dwLoadSurfaceTime4 = g_dwLoadSurfaceTime * 3;
type
  PRGBQuads = ^TRGBQuads;
  TRGBQuads = array[0..255] of TRGBQuad;

  TColorEffect = (ceNone, ceGrayScale, ceGrayScale_Death, ceBright, ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia);

  TDataType = (dtAll, dtMusic, dtData, dtMP3, dtWav);

  TLibType = (ltLoadBmp, ltUseCache, ltFileData);

  TWILType = (t_wmM2Def, t_wmM2Def16, t_wmM2wis, t_wmMyImage, t_wmM3Def, t_wmWoool, t_wm521g, t_wmM2Zip, t_wmM3Zip);

  TZIPLevel = 0..9;

  pTDXTextureSurface = ^TDXTextureSurface;
  TDXTextureSurface = packed record
    nPx: SmallInt;
    nPy: SmallInt;
    Surface: TDXImageTexture;
    dwLatestTime: LongWord;
    boNotRead: Boolean;
  end;

  TDXTextureInfo = record
    nWidth: Word;
    nHeight: Word;
    px: smallint;
    py: smallint;
  end;
  pTDXTextureInfo = ^TDXTextureInfo;

  TDxImage = record
    ColorCount: integer;
    nHandle: THandle;
    nW: SmallInt;
    nH: SmallInt;
    Surface: TDXImageTexture;
    dwLatestTime: LongWord;
    boNotRead: Boolean;
  end;
  PTDxImage = ^TDxImage;
  TDxImageArr = array[0..MaxListSize div 4] of TDxImage;
  PTDxImageArr = ^TDxImageArr;

  TWMBaseImages = class
  private
    FAutoFreeMemorys: Boolean;
    FAutoFreeMemorysTick: LongWord;
    FAutoFreeMemorysTime: LongWord;
    FFreeSurfaceTick: LongWord;
    FWILType: TWILType;
    FAppr             :Word;
    function GetImageSurface(index: integer): TDXImageTexture;

    function GetMemoryStream(index: integer): TMemoryStream;
  protected
    FLibType: TLibType;
    FBoChangeAlpha: Boolean;
    FSurfaceCount: Integer;

    FFileName: String;
    FPassword: string;
//  FFormatName: string;
    FInitialize: Boolean;
    FImageCount: integer;
    FReadOnly: Boolean;
    FboEncryVer: Boolean;
    FFileStream: TFileStream;
    FDxTextureArr: array of TDXTextureSurface;
    function InitializeTexture(): Boolean;
    procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); dynamic;
    function GetStream(index: integer): TMemoryStream; dynamic;
    function GetFormatBitLen(AFormat: TWILColorFormat): Byte;
  public
    FIndexList: TList;
    m_DefMainPalette: TRgbQuads;
    constructor Create(); dynamic;
    destructor Destroy; override;

    function Initialize(): Boolean; dynamic;
    procedure Finalize; dynamic;
    procedure FreeTexture;
    procedure FreeTextureByTime;
    function GetDataStream(index: Integer; DataType: TDataType): TMemoryStream; dynamic;
    function GetCachedImage(index: integer; var px, py: integer): TDXImageTexture;
    property boInitialize: Boolean read FInitialize;
    property ImageCount: integer read FImageCount;
    property FileName: String read FFileName write FFileName;
    property Password: string read FPassword write FPassword;
    property LibType: TLibType read FLibType write FLibType;
    property EncryVer: Boolean read FboEncryVer;
    property SurfaceCount: Integer read FSurfaceCount;
    property ReadOnly: Boolean read FReadOnly;
    property Images[index: integer]: TDXImageTexture read GetImageSurface;
    property Files[index: integer]: TMemoryStream read GetMemoryStream;

    property AutoFreeMemorys: Boolean read FAutoFreeMemorys write FAutoFreeMemorys;
    property AutoFreeMemorysTick: LongWord read FAutoFreeMemorysTick write FAutoFreeMemorysTick;
    property FreeSurfaceTick: LongWord read FFreeSurfaceTick write FFreeSurfaceTick;
    property Appr:Word read FAppr write FAppr;
    property WILType: TWILType read FWILType write FWILType;
  end;

  TWMImages = TWMBaseImages;

  TUIBImages = class(TWMBaseImages)
  private
    FHeader: TDXImage;  //修正支持16图片
    Fbo16bit: Boolean;   //修正支持16图片
    FSearchPath: string;
    FSearchFileExt: string;
    FSearchSubDir: Boolean;
    procedure UiLoadDxImage(pdximg: PTDxImage; sFileName: string);
    function FUiGetImageSurface(F: string):TDXImageTexture;
    function CopyImageDataToTexture(Bitmap: TBitmap; Texture: TDXImageTexture; Width, Height: Word): Boolean;
  public
    m_FileList: TStringList;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Initialize; reintroduce; dynamic;
    procedure Finalize; reintroduce; dynamic;
    procedure ClearCache;
    function UiGetCachedSurface(F: string): PTDxImage;
    property Images[F: string]: TDXImageTexture read FUiGetImageSurface;
    procedure GetUibFileList(Path, ext: string);
    procedure RecurSearchFile(Path, FileType: string);
  //published
    property SearchPath: string read FSearchPath write FSearchPath;
    property SearchFileExt: string read FSearchFileExt write FSearchFileExt;
    property SearchSubDir: Boolean read FSearchSubDir write FSearchSubDir default False;
    property LibType: TLibType read FLibType write FLibType default ltUseCache;
  end;

procedure LineX8_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
procedure LineR5G6B5_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
procedure LineR5G6B5_A8R8G8B8(Source:Word; Alpha:Byte; var Dest: LongWord);
function CreateWMImages(WILType: TWILType): TWMBaseImages;
function ZIPCompress(const InBuf: Pointer; InBytes: Integer; Level: TZIPLevel; out OutBuf: PAnsiChar): Integer;
function ZIPDecompress(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: PAnsiChar): Integer;
function MakeDXImageTexture(nWidth, nHeight: Word; WILColorFormat: TWILColorFormat; DrawCanvas: TDXDrawCanvas = nil): TDXImageTexture;
function WidthBytes(nBit, nWidth: Integer): Integer;
function ExtractFileNameOnly(const FName: string): string;

implementation

uses
  wm521g, wmM2Def, wmM3Def, wmM2Wis, wmMyImage, wmM2Zip, wmM3Zip ;


function ExtractFileNameOnly(const FName: string): string;
var
  extpos                    : Integer;
  ext, fn                   : string;
begin
  ext := ExtractFileExt(FName);
  fn := ExtractFileName(FName);
  if ext <> '' then begin
    extpos := Pos(ext, fn);
    Result := Copy(fn, 1, extpos - 1);
  end else
    Result := fn;
end;

function WidthBytes(nBit, nWidth: Integer): Integer;
begin
  Result := (((nWidth * nBit) + 31) shr 5) * 4;
end;
{
function WidthBytes16(w: Integer): Integer;
begin
  Result := (((w * 16) + 31) shr 5) * 4;
end;  }

function CreateWMImages(WILType: TWILType): TWMBaseImages;
begin
  Result := nil;
  case WILType of
    t_wmM2Def:
      Result := TWMM2DefImages.Create;
    t_wmM2Def16:
      Result := TWMM2DefBit16Images.Create;
    t_wmM2wis:
      Result := TWMM2WisImages.Create;
    t_wmMyImage:
      Result := TWMMyImageImages.Create;
    t_wmM3Def:
      Result := TWMM3DefImages.Create;
    t_wm521g:
      Result := TWM521gDefImages.Create;
    t_wmM2Zip:
      Result := TWMM2ZipImages.Create;
    t_wmM3Zip:
      Result := TWMM3ZipImages.Create;
  end;
  if Assigned(Result) then
    Result.WILType := WILType;
end;

function CCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then begin
    {$IF CompilerVersion >= 33.0}
    raise EZCompressionError.Create('ZIP Error');
    {$ELSE}
    raise ECompressionError.Create('ZIP Error');
    {$IFEND}
  end;
end;

function DCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then begin
    {$IF CompilerVersion >= 33.0}
    raise EZDecompressionError.Create('ZIP Error');
    {$ELSE}
    raise EDecompressionError.Create('ZIP Error');
    {$IFEND}
  end;
end;

function ZIPCompress(const InBuf: Pointer; InBytes: Integer; Level: TZIPLevel; out OutBuf: PAnsiChar): Integer;
var
  strm: TZStreamRec;
  P: Pointer;
begin
  FillChar(strm, sizeof(strm), 0);
  strm.zalloc := zlibAllocMem;
  strm.zfree := zlibFreeMem;
  Result := ((InBytes + (InBytes div 10) + 12) + 255) and not 255;
  GetMem(OutBuf, Result);
  try
    strm.next_in := InBuf;
    strm.avail_in := InBytes;
    {$IF CompilerVersion >= 21.0}
    strm.next_out := PByte(OutBuf);
    {$ELSE}
    strm.next_out := OutBuf;
    {$IFEND}
    strm.avail_out := Result;
    CCheck(deflateInit_(strm, Level, zlib_version, sizeof(strm)));
    try
      while CCheck(deflate(strm, Z_FINISH)) <> Z_STREAM_END do begin
        P := OutBuf;
        Inc(Result, 256);
        ReallocMem(OutBuf, Result);
        {$IF CompilerVersion >= 33.0}
        strm.next_out := PByte(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        {$ELSE}
        strm.next_out := PAnsiChar(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        {$IFEND}
        strm.avail_out := 256;
      end;
    finally
      CCheck(deflateEnd(strm));
    end;
    ReallocMem(OutBuf, strm.total_out);
    Result := strm.total_out;
  except
    FreeMem(OutBuf);
    OutBuf := nil;
  end;
end;

function ZIPDecompress(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: PAnsiChar): Integer;
var
  strm: TZStreamRec;
  P: Pointer;
  BufInc: Integer;
begin
  FillChar(strm, sizeof(strm), 0);
  strm.zalloc := zlibAllocMem;
  strm.zfree := zlibFreeMem;
  BufInc := (InBytes + 255) and not 255;
  if OutEstimate = 0 then
    Result := BufInc
  else
    Result := OutEstimate;
  GetMem(OutBuf, Result);
  try
    strm.next_in := InBuf;
    strm.avail_in := InBytes;
    {$IF CompilerVersion >= 33.0}
    strm.next_out := PByte(OutBuf);
    {$ELSE}
    strm.next_out := OutBuf;
    {$IFEND}
    strm.avail_out := Result;
    DCheck(inflateInit_(strm, zlib_version, sizeof(strm)));
    try
      while DCheck(inflate(strm, Z_NO_FLUSH)) <> Z_STREAM_END do begin
        P := OutBuf;
        Inc(Result, BufInc);
        ReallocMem(OutBuf, Result);
        {$IF CompilerVersion >= 21.0}
        strm.next_out := PByte(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        {$ELSE}
        strm.next_out := PAnsiChar(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        {$IFEND}
        strm.avail_out := BufInc;
      end;
    finally
      DCheck(inflateEnd(strm));
    end;
    ReallocMem(OutBuf, strm.total_out);
    Result := strm.total_out;
  except
    FreeMem(OutBuf);
    OutBuf := nil;
  end;
end;

procedure LineR5G6B5_A8R8G8B8(Source:Word; Alpha:Byte; var Dest: LongWord);
var
  r:Byte;
  g:Byte;
  b:Byte;
begin
  r:= ((Source and $f800) shr 8);
  g:= ((Source and $07e0) shr 3);
  b:= ((Source and $001f) shl 3);
  Dest:= (Alpha shl 24) or (r shl 16) or (g shl 8) or (b);
end;

procedure LineR5G6B5_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
begin
  asm
    push esi
    push edi
    push ebx
    push edx

    mov esi, Source
    mov edi, Dest
    mov ecx, Count
    lea edx, R5G6B5_A1R5G5B5

  @pixloop:
    movzx eax, [esi].Word
    add esi, 2

    shl eax, 1
    mov ax, [edx+eax].word

    mov [edi], ax
    add edi, 2

    dec ecx
    jnz @pixloop

    pop edx
    pop ebx
    pop edi
    pop esi
  end;
end;

procedure LineX8_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
begin
  asm
    push esi
    push edi
    push ebx
    push edx

    mov esi, Source
    mov edi, Dest
    mov ecx, Count
    lea edx, X8_A1R5G5B5

  @pixloop:
    movzx eax, [esi].byte
    add esi, 1

    shl eax, 1
    mov ax, [edx+eax].word

    mov [edi], ax
    add edi, 2

    dec ecx
    jnz @pixloop

    pop edx
    pop ebx
    pop edi
    pop esi
  end;
end;

{ TWMBaseImages }

constructor TWMBaseImages.Create;
begin
  inherited;
  FInitialize := False;
  FImageCount := 0;
  FFileName := '';
  FReadOnly := True;
  FAutoFreeMemorys := False;
  FAutoFreeMemorysTick := 10 * 1000;
  FFreeSurfaceTick := 60 * 1000;
  FAutoFreeMemorysTime := GetTickCount;
  FFileStream := nil;
  FDxTextureArr := nil;
  FIndexList := TList.Create;
  FSurfaceCount := 0;
  FPassword := '';
  FboEncryVer := False;
  FLibType := ltUseCache;
end;

procedure TWMBaseImages.FreeTexture;
var
  i: integer;
begin
  if FDxTextureArr <> nil then
    for I := 0 to High(FDxTextureArr) do begin
      if FDxTextureArr[I].Surface <> nil then begin
        FDxTextureArr[I].Surface.Free;
        FDxTextureArr[I].Surface := nil;
      end;
    end;
  FSurfaceCount := 0;
end;

procedure TWMBaseImages.FreeTextureByTime;
var
  i: integer;
begin
  if FDxTextureArr <> nil then
    for I := 0 to High(FDxTextureArr) do begin
      if (FDxTextureArr[I].Surface <> nil) and (GetTickCount - FDxTextureArr[I].dwLatestTime > FFreeSurfaceTick) then begin
        if FSurfaceCount > 0 then
          Dec(FSurfaceCount);
        FDxTextureArr[I].Surface.Free;
        FDxTextureArr[I].Surface := nil;
      end;
    end;
end;

destructor TWMBaseImages.Destroy;
begin
  Finalize;
  FDxTextureArr := nil;
  FIndexList.Free;
  inherited;
end;
 //读取补丁图片资源 返回HGE的纹理
function TWMBaseImages.GetCachedImage(index: integer; var px, py: integer): TDXImageTexture;
begin
  Result := nil;  //返回NLI
  //如果图片数量小于0 或者 大于 或者等于图片数量 或者读取补丁类型 不等于 或者补丁未初始化
  if (Self = nil) or (index < 0) or (index >= FImageCount) or (FLibType <> ltUseCache) or (not FInitialize) then
    Exit; //结束退出
  //如果图片编号小于图片序号数量并且小于补丁纹理的数据组
  if (index < FIndexList.Count) and (index <= High(FDxTextureArr)) then begin
    //如果纹理数据的纹理未NLI 并且纹理数据组没有读取到
    if (FDxTextureArr[index].Surface = nil) and (not FDxTextureArr[index].boNotRead) then begin
      try
        LoadDxImage(index, Integer(FIndexList[index]), @FDxTextureArr[index]);
        if FDxTextureArr[index].Surface <> nil then
          Inc(FSurfaceCount);
      //如果读取不到图片未NIL 请教微端下载然后写入数据
      except
        FDxTextureArr[index].Surface := nil;  //空纹理
        FDxTextureArr[index].boNotRead := True;//未读取
      end;
    end;
    Result := FDxTextureArr[index].Surface;
    px := FDxTextureArr[index].nPx;
    py := FDxTextureArr[index].nPy;
    FDxTextureArr[index].dwLatestTime := GetTickCount;
  end;
  if AutoFreeMemorys and (GetTickCount > FAutoFreeMemorysTime) then begin
    FAutoFreeMemorysTime := GetTickCount + FAutoFreeMemorysTick;
    FreeTextureByTime;
  end;
end;

function TWMBaseImages.GetDataStream(index: Integer; DataType: TDataType): TMemoryStream;
begin
  Result := nil;
end;

procedure TWMBaseImages.Finalize;
begin
  FInitialize := False;
  FreeTexture;
  FDxTextureArr := nil;
  FSurfaceCount := 0;
  if FFileStream <> nil then
    FFileStream.Free;
  FFileStream := nil;
end;

function TWMBaseImages.GetImageSurface(index: integer): TDXImageTexture;
var
  px, py: Integer;
begin
  Result := GetCachedImage(index, px, py);
end;

function TWMBaseImages.GetMemoryStream(index: integer): TMemoryStream;
begin
  Result := GetStream(index);
end;

function TWMBaseImages.GetStream(index: integer): TMemoryStream;
begin
  Result := nil;
end;

function TWMBaseImages.GetFormatBitLen(AFormat: TWILColorFormat): Byte;
begin
  if AFormat in [WILFMT_A4R4G4B4, WILFMT_A1R5G5B5, WILFMT_R5G6B5] then
    Result := 2
  else
    Result := 4;
end;
 //要检测两个 第一检测是不是初始化 如果已经初始化
 //再检测索引是不是相同 如果不相同再重新初始化

function TWMBaseImages.Initialize: Boolean;
begin
  Result := False;
  if (FFileName = '') or FInitialize or (FFileStream <> nil) or (not FileExists(FFileName)) then
    exit;
  FFileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
  Result := FFileStream <> nil;
  FInitialize := Result;
  if Result then begin
    FreeTexture;
    FDxTextureArr := nil;
    FSurfaceCount := 0;
  end;
end;

function TWMBaseImages.InitializeTexture: Boolean;
begin
  Result := False;
  FDxTextureArr := nil;
  if (not FInitialize) or (FImageCount <= 0) or (LibType <> ltUseCache) then
    exit;
  SetLength(FDxTextureArr, FImageCount);
  FillChar(FDxTextureArr[0], FImageCount * SizeOf(TDXTextureSurface), #0);
  Result := True;
end;

procedure TWMBaseImages.LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface);
begin
  if pDXTexture.Surface <> nil then
    pDXTexture.Surface.Free;
  pDXTexture.Surface := nil;
  pDXTexture.boNotRead := True;
end;

function MakeDXImageTexture(nWidth, nHeight: Word; WILColorFormat: TWILColorFormat; DrawCanvas: TDXDrawCanvas): TDXImageTexture;
begin
  Result := TDXImageTexture.Create;
  with Result do begin
    Size := Point(nWidth, nHeight);
    PatternSize := Point(nWidth, nHeight);
    Format := ColorFormat[WILColorFormat];
    Active := True;
  end;
  if not Result.Active then begin
    Result.Free;
    Result := nil;
  end else begin
    Result.Canvas := DrawCanvas;
  end;
end;

{ TUIBImages }

constructor TUIBImages.Create();
begin
  inherited;
  FSearchPath := '';
  FSearchFileExt := '*.uib';
  FFileName := '';
  FSearchSubDir := False;
  m_FileList := TStringList.Create;
  Fbo16bit := False;
end;

destructor TUIBImages.Destroy;
var
  i                 : Integer;
begin
  for i := 0 to m_FileList.count - 1 do
    FileClose(THandle(m_FileList.Objects[i]));
  m_FileList.Free;
  inherited Destroy;
end;


procedure TUIBImages.GetUibFileList(Path, ext: string);
var
  fhandle: THandle;
  SearchRec: TSearchRec;
  sPath: string;
  PDxImage: PTDxImage;
begin

  if Copy(Path, Length(Path), 1) <> '\' then
    sPath := Path + '\'
  else
    sPath := Path;

  if FindFirst(sPath + ext, faAnyFile, SearchRec) = 0 then begin
    fhandle := FileOpen(sPath + SearchRec.Name, fmOpenRead or fmShareDenyNone);
    New(PDxImage);
    FillChar(PDxImage^, SizeOf(TDxImage), 0);
    PDxImage.nHandle := fhandle;
    m_FileList.AddObject(sPath + SearchRec.Name, TObject(PDxImage));
    while True do begin
      if FindNext(SearchRec) = 0 then begin
        fhandle := FileOpen(sPath + SearchRec.Name, fmOpenRead or fmShareDenyNone);
        New(PDxImage);
        FillChar(PDxImage^, SizeOf(TDxImage), 0);
        PDxImage.nHandle := fhandle;
        m_FileList.AddObject(sPath + SearchRec.Name, TObject(PDxImage));
      end else begin
        System.SysUtils.FindClose(SearchRec);
        Break;
      end;
    end;
  end;
end;

procedure TUIBImages.RecurSearchFile(Path, FileType: string);
var
  sr                : TSearchRec;
  fhandle           : THandle;
  sPath, sFile      : string;
  PDxImage          : PTDxImage;
begin

  if Copy(Path, Length(Path), 1) <> '\' then
    sPath := Path + '\'
  else
    sPath := Path;

  if FindFirst(sPath + '*.*', faAnyFile, sr) = 0 then begin
    repeat
      sFile := Trim(sr.Name);
      if sFile = '.' then Continue;
      if sFile = '..' then Continue;
      sFile := sPath + sr.Name;
      if (sr.Attr and faDirectory) <> 0 then begin
        GetUibFileList(sFile, FileType);
      end else if (sr.Attr and faAnyFile) = sr.Attr then begin
        fhandle := FileOpen(sFile, fmOpenRead or fmShareDenyNone);
        New(PDxImage);
        FillChar(PDxImage^, SizeOf(TDxImage), 0);
        PDxImage.nHandle := fhandle;
        m_FileList.AddObject(sFile, TObject(PDxImage));
      end;
    until FindNext(sr) <> 0;
    System.SysUtils.FindClose(sr);
  end;
end;

procedure TUIBImages.Initialize;
begin
  Fbo16bit := FHeader.ColorCount = $10000; //修正支持16图片
  if DirectoryExists(FSearchPath) then
  begin
    if SearchSubDir then
      RecurSearchFile(FSearchPath, FSearchFileExt)
    else
      GetUibFileList(FSearchPath, FSearchFileExt);
    FImageCount := m_FileList.count;
  end
  else
  begin
    ForceDirectories(FSearchPath);
  end;
end;

procedure TUIBImages.ClearCache;
var
  i                 : Integer;
  pdi               : PTDxImage;
begin
  for i := 0 to m_FileList.count - 1 do begin
    pdi := PTDxImage(m_FileList.Objects[i]);
    pdi.nH := 0;
    pdi.nW := 0;
    if Assigned(pdi.Surface) then
      FreeAndNil(pdi.Surface);
  end;
end;

procedure TUIBImages.Finalize;
var
  i                 : Integer;
  pdi               : PTDxImage;
begin
  ClearCache();
  for i := 0 to m_FileList.count - 1 do begin
    pdi := PTDxImage(m_FileList.Objects[i]);
    Dispose(pdi);
  end;
  m_FileList.Clear;
  FImageCount := 0;
end;

procedure TUIBImages.UiLoadDxImage(pdximg: PTDxImage;  sFileName: string);
var
  Bitmap: TBitmap;
begin
  pdximg.boNotRead := True;
   if FileExists(sFileName) then begin
    Bitmap := TBitmap.Create;
    Try
      Bitmap.LoadFromFile(sFileName);
//      DebugOutStr('AFileName2: ' + sFileName);
      if (Bitmap.Width > 2) and (Bitmap.Height > 2)  then begin
        if (Bitmap.PixelFormat = pf8bit) then  begin  //修正支持16图片
         Fbo16bit := False;
        end else Fbo16bit := True;

        pdximg.Surface := MakeDXImageTexture(Bitmap.Width, Bitmap.Height,WILFMT_A1R5G5B5);
        if pdximg.Surface <> nil then begin
          if not CopyImageDataToTexture(Bitmap, pdximg.Surface, Bitmap.Width, Bitmap.Height) then
          begin
            pdximg.Surface.Free;
            pdximg.Surface := nil;
          end
          else begin
            pdximg.boNotRead := False;
            pdximg.nW := 0;
            pdximg.nH := 0;
          end;
        end;
      end;
    Finally
      Bitmap.Free;
    End;
  end;
end;
function TUIBImages.CopyImageDataToTexture(Bitmap: TBitmap; Texture: TDXImageTexture; Width, Height: Word): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PAnsiChar;
begin
  Result := False;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
     if Fbo16bit then begin   //16位
      FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      WriteBuffer := Pointer(Integer(Access.Bits));
      for Y := 0 to Height - 1 do begin
        ReadBuffer := Bitmap.ScanLine[Y];
        LineR5G6B5_A1R5G5B5(ReadBuffer, WriteBuffer, Width);
        Inc(WriteBuffer, Access.Pitch);
      end;
     end else begin   //8位
      FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      WriteBuffer := Pointer(Integer(Access.Bits));
      for Y := 0 to Height - 1 do begin
        ReadBuffer := Bitmap.ScanLine[Y];
        LineX8_A1R5G5B5(ReadBuffer, WriteBuffer, Width);
        Inc(WriteBuffer, Access.Pitch);
      end;
     end;
      Result := True;
    finally
      Texture.Unlock;
    end;
  end;
end;

function TUIBImages.UiGetCachedSurface(F: string): PTDxImage;
var
  Index: Integer;
  PDxImage: PTDxImage;
begin
  Result := nil;
  try
    Index := m_FileList.IndexOf(F);
    if Index >= 0 then begin
      Result := PTDxImage(m_FileList.Objects[Index]);
      if Result.nHandle <> INVALID_HANDLE_VALUE then begin
        Result.dwLatestTime := GetTickCount;
        if not Assigned(Result.Surface) then begin
          UiLoadDxImage(Result, F);
        end;
      end;
    end else begin
      New(PDxImage);
      FillChar(PDxImage^, SizeOf(TDxImage), 0);
      PDxImage.nHandle := INVALID_HANDLE_VALUE;
      FImageCount := m_FileList.AddObject(F, TObject(PDxImage));
    end;
  except
    Result := nil;
  end;
end;

function TUIBImages.FUiGetImageSurface(F: string): TDXImageTexture;
var
  PDxImage          : PTDxImage;
begin
  PDxImage := UiGetCachedSurface(F);
  if (PDxImage <> nil) and (PDxImage.Surface <> nil) then
    Result := PDxImage.Surface
  else
    Result := nil;
end;

end.

