unit wmM2Wis;

interface
uses
  Windows, Classes, Graphics, SysUtils, Direct3D9, HGETextures, HUtil32,Wilpion, WIL;

type
  TWMIndexInfo = packed record
    nIndex: Integer;
    nSize: Integer;
    nUnknown: Integer;
  end;
  pTWMIndexInfo = ^TWMIndexInfo;

  TWMImageInfo = packed record
    nEncrypt: Integer;
    DXInfo: TDXTextureInfo;
  end;
  pTWMImageInfo = ^TWMImageInfo;

  TWMM2WisImages = class(TWMBaseImages)
  private
    FSizeList: TList;
    procedure LoadIndex();
    function DecodeOfbit8Tobit16(Source, Target: Pointer; TargetLen: LongWord): Boolean;
    function CopyImageDataToTexture(Buffer: PAnsiChar; Texture: TDXImageTexture; Width, Height: Word; Decode: Integer): Boolean;
  protected
    procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); override;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Initialize(): Boolean; override;
    procedure Finalize; override;
  end;

implementation

{ TWMM2WisImages }

procedure TWMM2WisImages.LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface);
var
  imginfo: TWMImageInfo;
  Buffer: PAnsiChar;
  ReadSize: Integer;
begin
  pDXTexture.boNotRead := True;
  if FFileStream.Seek(position, 0) = position then begin
    ReadSize := Integer(FSizeList[index]);
    FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;

    GetMem(Buffer, ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        pDXTexture.Surface := MakeDXImageTexture(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight, WILFMT_A1R5G5B5);
        if pDXTexture.Surface <> nil then begin
          if not CopyImageDataToTexture(Buffer, pDXTexture.Surface, imginfo.DXInfo.nWidth, imgInfo.DXInfo.nHeight, imginfo.nEncrypt) then begin
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

function TWMM2WisImages.CopyImageDataToTexture(Buffer: PAnsiChar; Texture: TDXImageTexture; Width, Height: Word; DEcode: Integer): Boolean;
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
      SafeFillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      case DEcode of
        0: begin
            for Y := 0 to Height - 1 do begin
              ReadBuffer := @Buffer[Y * Width];
              WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
              LineX8_A1R5G5B5(ReadBuffer, WriteBuffer, Width);
            end;
            Result := True;
          end;
        1: begin
            DecodeBuffer := AllocMem(Width * Height * 2);
            Try
              Result := DecodeOfbit8Tobit16(Buffer, DecodeBuffer, Width * Height);
              if Result then begin
                for Y := 0 to Height - 1 do begin
                  ReadBuffer := @DecodeBuffer[Y * Width * 2];
                  WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
                  Move(ReadBuffer^, WriteBuffer^, Width * 2);
                end;
              end;
            Finally
              FreeMem(DecodeBuffer);
            End;
        end;
        2: begin
            for Y := 0 to Height - 1 do begin
              ReadBuffer := @Buffer[Y * Width * 2];
              WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
              LineR5G6B5_A1R5G5B5(ReadBuffer, WriteBuffer, Width);
            end;
            Result := True;
          end;
        3: begin

          end;
      end;
    finally
      Texture.Unlock;
    end;
  end;

end;

constructor TWMM2WisImages.Create;
begin
  inherited;
  FReadOnly := True;
  FSizeList := TList.Create;
end;

function TWMM2WisImages.DecodeOfbit8Tobit16(Source, Target: Pointer; TargetLen: LongWord): Boolean;
var
  SourcePtr: PByte;
  TargetPtr: PWord;
  RunLength: Cardinal;
  Counter: Cardinal;
  I: Integer;
  wColor: Word;
begin
  Result := False;
  Counter := 0;
  TargetPtr := Target;
  SourcePtr := Source;
  while Counter < TargetLen do begin
    RunLength := SourcePtr^;
    if RunLength = 0 then begin
      Inc(SourcePtr);
      RunLength := SourcePtr^;
      Inc(SourcePtr);
      for I := 0 to RunLength - 1 do begin
        TargetPtr^ := X8_A1R5G5B5[SourcePtr^];
        Inc(SourcePtr);
        Inc(TargetPtr);
      end;
      Inc(Counter, RunLength);
    end
    else begin
      Inc(SourcePtr);
      Inc(Counter, RunLength);
      wColor := X8_A1R5G5B5[SourcePtr^];
      Inc(SourcePtr);
      for I := 0 to RunLength - 1 do begin
        TargetPtr^ := wColor;
        Inc(TargetPtr);
      end;
    end;
  end;
  if Counter = TargetLen then
    Result := True;
end;

destructor TWMM2WisImages.Destroy;
begin
  FreeAndNil(FSizeList);
  inherited;
end;

procedure TWMM2WisImages.Finalize;
begin
  inherited;
end;

function TWMM2WisImages.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then begin
    LoadIndex();
    InitializeTexture;
  end;
end;

procedure TWMM2WisImages.LoadIndex;
var
  WMIndexInfo: TWMIndexInfo;
  IndexList, SizeList: TList;
  I: Integer;
begin
  FIndexList.Clear;
  FSizeList.Clear;
  IndexList := TList.Create;
  SizeList := TList.Create;
  FImageCount := 0;
  FFileStream.Seek(-SizeOf(WMIndexInfo), soFromEnd);
  while True do begin
    if FFileStream.Read(WMIndexInfo, SizeOf(WMIndexInfo)) = SizeOf(WMIndexInfo) then begin
      IndexList.add(pointer(WMIndexInfo.nIndex));
      SizeList.add(pointer(WMIndexInfo.nSize));
      FFileStream.Seek(- (SizeOf(WMIndexInfo) * 2), soFromCurrent);
      if WMIndexInfo.nIndex = 512 then break;
      
    end
    else
      break;
  end;
  for I := IndexList.Count - 1 downto 0 do begin
    FIndexList.Add(IndexList[I]);
    FSizeList.Add(SizeList[I]);
  end;
  FImageCount := FIndexList.Count;
end;


end.

