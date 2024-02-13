unit wmMyImage;

interface
uses
  System.Classes, System.SysUtils,
  Winapi.Windows,
  Vcl.Graphics,
  HGETextures, WIL, DESEC;

const

  HEADERNAME = 'PACK';
  COPYRIGHTNAME = '4.0 - 361m2';
  CHECKENSTR = '361m2com';
  MYFILEEXT = '.pak';

type

  pTFragmentInfo = ^TFragmentInfo;
  TFragmentInfo = packed record
    nOffset: Integer;
    nSize: Integer;
  end;

  pTWMImageHeader = ^TWMImageHeader;
  TWMImageHeader = packed record
    Title: array[0..3] of AnsiChar;
    CopyRight: array[0..10] of AnsiChar;
    sEnStr: array[0..7] of AnsiChar;
    nVer: Byte;
    ImageCount2: Integer;
    nFragmentOffset: Integer;
    nFragmentCount: Integer;
    IndexOffset1: Integer;
    IndexOffset2: Integer;
    OffsetSize: Integer;
    ImageCount: Integer;
    UpDateTime: TDateTime;
    IndexOffset: Integer;
  end;



  TWMImageInfo = packed record
    DXInfo: TDXTextureInfo;
    nDrawBlend: Cardinal;
    btImageFormat: TWILColorFormat;
    nDataSize: Integer;
    btFileType: Byte;
    boEncrypt: Boolean;
    nPre: Integer;
  end;
  pTWMImageInfo = ^TWMImageInfo;

  TWMMyImageImages = class(TWMBaseImages)
  private
    FHeader: TWMImageHeader;

    function DecodeRLE(const Source, Target: Pointer; Count: Cardinal; bitLength: Byte): Boolean;
    procedure LoadIndex();
    function CopyImageDataToTexture(Buffer: PAnsiChar; Texture: TDXImageTexture; Width, Height: Word; Decode: Boolean; bitLength: Byte): Boolean;
    function GetUpDateTime: TDateTime;
  protected
    procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); override;
    function GetStream(index: integer): TMemoryStream; override;
  public
    FCanEncry: Boolean;
    constructor Create(); override;
    function Initialize(): Boolean; override;
    function GetDataStream(index: Integer; DataType: TDataType): TMemoryStream; override;
    property UpDateTime: TDateTime read GetUpDateTime;
    procedure FormatImageInfo(WMImageInfo: pTWMImageInfo);
    procedure FormatDataBuffer(Buffer: PAnsiChar; BufferLen: Integer);
  end;


  procedure FormatHeader(Header: pTWMImageHeader);

implementation

procedure FormatHeader(Header: pTWMImageHeader);
begin
    Header.IndexOffset := MakeLong(Word(Header.IndexOffset1 shr 16), Word(Header.IndexOffset2 shr 16));
end;

{ TWMMyImageImages }

procedure TWMMyImageImages.LoadDxImage(index, position: integer; pDXTexture: pTDXTextureSurface);
var
  imginfo: TWMImageInfo;
  Buffer: PAnsiChar;
  ReadSize: Integer;
begin
  pDXTexture.boNotRead := True;
  if (position < 10) then Exit;
  if FFileStream.Seek(position, 0) = position then begin
    FFileStream.Read(imginfo, SizeOf(imginfo));
    FormatImageInfo(@imginfo);
    if (imginfo.btFileType <> FILETYPE_IMAGE) or (imginfo.nDataSize <= 0) then
      exit;

    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    ReadSize := imginfo.nDataSize;
    GetMem(Buffer, ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FormatDataBuffer(Buffer, ReadSize);
        pDXTexture.Surface := MakeDXImageTexture(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight, imginfo.btImageFormat);
        if pDXTexture.Surface <> nil then begin
          if not CopyImageDataToTexture(Buffer, pDXTexture.Surface, imginfo.DXInfo.nWidth, imgInfo.DXInfo.nHeight,
            imginfo.boEncrypt, GetFormatBitLen(imginfo.btImageFormat)) then begin
            pDXTexture.Surface.Free;
            pDXTexture.Surface := nil;
          end
          else begin
            pDXTexture.boNotRead := False;
            pDXTexture.nPx := imginfo.DXInfo.px;
            pDXTexture.nPy := imginfo.DXInfo.py;
          end;
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function TWMMyImageImages.CopyImageDataToTexture(Buffer: PAnsiChar; Texture: TDXImageTexture; Width, Height: Word; Decode: Boolean; bitLength: Byte): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer, DecodeBuffer: PAnsiChar;
begin
  Result := False;
  if (Texture.Size.X < Width) or (Texture.Size.Y < Height) then
    exit;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
      FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      if (Texture.Size.X = Width) and (Texture.Size.Y = Height) then begin
        if Decode then begin
          Result := DecodeRLE(Buffer, Access.Bits, Width * Height * bitLength, bitLength);
        end
        else begin
          Move(Buffer^, Access.Bits^, Width * Height * bitLength);
          Result := True;
        end;
      end
      else begin
        if Decode then begin
          DecodeBuffer := AllocMem(Width * Height * bitLength);
          Try
            Result := DecodeRLE(Buffer, DecodeBuffer, Width * Height * bitLength, bitLength);
            if Result then begin
              for Y := 0 to Height - 1 do begin
                ReadBuffer := @DecodeBuffer[Y * Width * bitLength];
                WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
                Move(ReadBuffer^, WriteBuffer^, Width * bitLength);
              end;
            end;
          Finally
            FreeMem(DecodeBuffer);
          End;
        end
        else begin
          for Y := 0 to Height - 1 do begin
            ReadBuffer := @Buffer[Y * Width * bitLength];
            WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
            Move(ReadBuffer^, WriteBuffer^, Width * bitLength);
          end;
          Result := True;
        end;
      end;
    finally
      Texture.Unlock;
    end;
  end;
end;

constructor TWMMyImageImages.Create;
begin
  inherited;
  FCanEncry := False;
end;

function TWMMyImageImages.Initialize: Boolean;
var
  sEnStr: array[0..7] of AnsiChar;
begin
  Result := inherited Initialize;
  if Result then begin
    FFileStream.Read(FHeader, SizeOf(TWMImageHeader));
    FboEncryVer := FHeader.nVer = 1;
    FCanEncry := FboEncryVer and (FPassword <> '');
    if FCanEncry then begin
      DecryBuffer(FPassword, @FHeader.sEnStr[0], @sEnStr[0], 8, 8);
      if sEnStr <> CHECKENSTR then
        FCanEncry := False;
    end;
    FormatHeader(@FHeader);
    FImageCount := FHeader.ImageCount;
    LoadIndex;
    InitializeTexture;
  end;
end;

procedure TWMMyImageImages.LoadIndex;
var
  pvalue, OffsetBuffer: PAnsiChar;
  OffsetSize, ImageCountSize: Integer;
begin
  FIndexList.Clear;
  FImageCount := 0;
  if FHeader.IndexOffset <= 0 then begin
    FHeader.IndexOffset := SizeOf(FHeader);
    exit;
  end;
  OffsetSize := FHeader.OffsetSize;
  if OffsetSize > 1024 * 1024 * 50 then exit;
  if FCanEncry then begin
    if FHeader.ImageCount2 <= 0 then exit;
    FHeader.ImageCount := FHeader.ImageCount2;
  end else if FHeader.ImageCount <= 0 then exit;
  FFileStream.Seek(FHeader.IndexOffset, soFromBeginning);
  ImageCountSize := FHeader.ImageCount * SizeOf(Integer);
  if OffsetSize > 0 then begin
    GetMem(pvalue, OffsetSize);
    Try
      if FFileStream.Read(pvalue^, OffsetSize) = OffsetSize then begin
        ImageCountSize := FHeader.ImageCount * SizeOf(Integer);
        OffsetSize := ZIPDecompress(pvalue, OffsetSize, ImageCountSize, OffsetBuffer);
        if (OffsetBuffer <> nil) then begin
          if OffsetSize = (ImageCountSize + 10 * SizeOf(Integer)) then begin
            FIndexList.Count := FHeader.ImageCount;
             Move(OffsetBuffer[10 * SizeOf(Integer)], Pointer(FIndexList.List)^, ImageCountSize);
            FImageCount := FIndexList.Count;
          end;
          FreeMem(OffsetBuffer);
        end;
      end;
    Finally
      FreeMem(pvalue);
    End;
  end else begin
    GetMem(OffsetBuffer, ImageCountSize);
    Try
      if FFileStream.Read(OffsetBuffer^, ImageCountSize) = ImageCountSize then begin
        FIndexList.Count := FHeader.ImageCount;
        Move(OffsetBuffer^, Pointer(FIndexList.List)^, ImageCountSize);
        FImageCount := FIndexList.Count;
      end;
    Finally
      FreeMem(OffsetBuffer);
    End;
  end;
end;

function TWMMyImageImages.DecodeRLE(const Source, Target: Pointer; Count: Cardinal; bitLength: Byte): Boolean;
var
  I, j: Integer;
  SourcePtr,
  TargetPtr: PByte;
  RunLength: Cardinal;
  Counter: Cardinal;
begin
  Counter := 0;
  TargetPtr := Target;
  SourcePtr := Source;

  while Counter < Count do begin
    RunLength := 1 + (SourcePtr^ and $7F);
    if SourcePtr^ > $7F then begin
      Inc(SourcePtr);
      for I := 0 to RunLength - 1 do begin
        for j := 1 to bitLength - 1 do
        begin
          TargetPtr^ := SourcePtr^;
          Inc(SourcePtr);
          Inc(TargetPtr);
        end;
        TargetPtr^ := SourcePtr^;
        Dec(SourcePtr, bitLength - 1);
        Inc(TargetPtr);
      end;
      Inc(SourcePtr, bitLength);
    end
    else begin
      Inc(SourcePtr);
      Move(SourcePtr^, TargetPtr^, bitLength * RunLength);
      Inc(SourcePtr, bitLength * RunLength);
      Inc(TargetPtr, bitLength * RunLength);
    end;
    Inc(Counter, bitLength * RunLength);
  end;
  Result := Counter = Count;
end;


//位移宽高，进行加密
procedure TWMMyImageImages.FormatImageInfo(WMImageInfo: pTWMImageInfo);
var
  nLen: Integer;
begin
  nLen := SizeOf(TWMImageInfo) div 8 * 8;
    if FCanEncry and (FPassword = '') and (nLen > 0) then
      DecryBuffer(FPassword, PAnsiChar(WMImageInfo), PAnsiChar(WMImageInfo), nLen, nLen);
    WMImageInfo.DXInfo.nWidth := WMImageInfo.DXInfo.nWidth shr 4;
    WMImageInfo.DXInfo.nHeight := WMImageInfo.DXInfo.nHeight shr 4;
end;

procedure TWMMyImageImages.FormatDataBuffer(Buffer: PAnsiChar; BufferLen: Integer);
begin
  if (not FCanEncry) or (BufferLen < 128) or (FPassword = '') then Exit;
   DecryBuffer(FPassword, Buffer, Buffer, 128, 128);
end;


function TWMMyImageImages.GetStream(index: integer): TMemoryStream;
begin
  Result := nil;
end;

function TWMMyImageImages.GetUpDateTime: TDateTime;
begin
  Result := FHeader.UpDateTime;
end;

function TWMMyImageImages.GetDataStream(index: Integer; DataType: TDataType): TMemoryStream;
var
  nPosition, ReadSize: Integer;
  imginfo: TWMImageInfo;
  boRead: Boolean;
  Buffer, DecodeBuffer: PAnsiChar;
begin
  Result := nil;
  if (index < 0) or (index >= FImageCount) then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if (nPosition < 10) or (FFileStream.Seek(nPosition, 0) <> nPosition) then exit;
    FFileStream.Read(imginfo, SizeOf(imginfo));
    FormatImageInfo(@imginfo);
    boRead := False;
    case DataType of
      dtAll: boRead := True;
      dtMusic: boRead := (imginfo.btFileType = FILETYPE_WAVA) or (imginfo.btFileType = FILETYPE_MP3);
      dtData: boRead := imginfo.btFileType = FILETYPE_DATA;
      dtMP3: boRead := imginfo.btFileType = FILETYPE_MP3;
      dtWav: boRead := imginfo.btFileType = FILETYPE_WAVA;
    end;
    if boRead then begin
      ReadSize := imginfo.nDataSize;
      Buffer := AllocMem(ReadSize);
      try
        if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
          FormatDataBuffer(Buffer, ReadSize);
          if imginfo.boEncrypt then begin
            DecodeBuffer := nil;
            ReadSize := ZIPDecompress(Buffer, ReadSize, 0, DecodeBuffer);
            Try
              if (DecodeBuffer <> nil) and (ReadSize > 0) then begin
                Result := TMemoryStream.Create;
                Result.SetSize(ReadSize);
                System.Move(DecodeBuffer^, Result.Memory^, ReadSize);
              end;
            Finally
              if DecodeBuffer <> nil then
                FreeMem(DecodeBuffer);
            End;
          end else begin
            Result := TMemoryStream.Create;
            Result.SetSize(ReadSize);
            System.Move(Buffer^, Result.Memory^, ReadSize);
          end;
        end;
      finally
        FreeMem(Buffer);
      end;
    end;
  end;
end;

end.

