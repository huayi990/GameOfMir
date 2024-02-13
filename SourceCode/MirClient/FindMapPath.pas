unit FindMapPath;

interface

uses
  Windows, Classes, SysUtils, Messages;

type
  //��ͼԪ�ط���
  TTerrainTypes = (ttNormal, ttSand, ttForest, ttRoad, ttObstacle, ttPath);

  TPath = array of TPoint; //·������

  TPathMapCell = record //·��ͼԪ
    Distance: Integer; //�����ľ���
    Direction: Integer;
  end;
  TPathMapArray = array of array of TPathMapCell; // ·��ͼ�洢����

  {TMapHeader = packed record // �����ͼ����ͷ�ṹ 52
    Width: word; //2
    Height: word; //2
    Title: array[1..16] of char; //����      16
    UpdateDate: TDateTime; //8
    Reserved: array[0..23] of char; //����
  end;    }

  TMapPrjInfo = record
    ident: string[16];
    ColCount: Integer;
    RowCount: Integer;
  end;

  TMapMendHeader = packed record
    nWidth, nHeight: Word;
    nCount: Byte;
  end;

  TMapMendInfo = packed record
    nX, nY, nWidth, nHeight: Word;
  end;

  TMapHeader = packed record
    wWidth: Word;
    wHeight: Word;
    sTitle: string[15];
    UpdateDate: TDateTime;
    Reserved: array[0..23] of Char;
  end;



  TOldMapInfo = packed record
    wBkImg: Word;
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: byte; //$80 (��¦), ���� �ĺ� �ε���
    btDoorOffset: byte; //���� ���� �׸��� ��� ��ġ, $80 (����/����(�⺻))
    btAniFrame: byte; //$80(Draw Alpha) +  ������ ��
    btAniTick: byte;
    btArea: byte; //���� ����
    btLight: byte; //0..1..4 ���� ȿ��
  end;
  pTOldMapInfo = ^TOldMapInfo;
  //TMapBuf = array of array of TMapBlock; //�����ͼ�洢����

  TMapInfo = record
    wBkImg: Word;
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: byte; //$80 (��¦), ���� �ĺ� �ε���
    btDoorOffset: byte; //���� ���� �׸��� ��� ��ġ, $80 (����/����(�⺻))
    btAniFrame: byte; //$80(Draw Alpha) +  ������ ��
    btAniTick: byte;
    btArea: byte; //���� ����
    btLight: byte; //0..1..4 ���� ȿ��
    btBkIndex: Byte;
    btSmIndex: Byte;
  end;
  PTMapInfo = ^TMapInfo;

  TENMapHeader = packed record
    Title: string[16];
    Reserved: LongWord;
    Width: Word;
    Not1: Word;
    Height: Word;
    Not2: Word;
    Reserved2: array[0..24] of char;
  end;

  TENMapInfo = packed record
    BkImg: Word;
    BkImgNot: word;
    MidImg: word;
    FrImg: word;
    DoorIndex: byte;
    DoorOffset: byte;
    AniFrame: byte;
    AniTick: byte;
    Area: byte;
    light: byte;
    btNot: byte;
  end;
  PTENMapInfo = ^TENMapInfo;

  TCellParams = record
    TerrainType: Boolean;
    OnPath: Boolean;
  end;
  TMapData = array of array of TCellParams; //��ͼ�洢����(�㷨��ʶ���ʽ)

  TGetCostFunc = function(X, Y, Direction: Integer; PathWidth: Integer = 0): Integer;

  {TMapLoading = class(TThread) //Ѱ·��
  protected
    procedure Execute; override;
  end;   }

  TPathMap = class //Ѱ·��
  public
    PathMapArray: TPathMapArray;
    MapHeight: Integer;
    MapWidth: Integer;
    GetCostFunc: TGetCostFunc;
    PathWidth: Integer;

    constructor Create;
    function FindPath(MapWidthin, MapHeightin: Integer; StartX, StartY, StopX, StopY: Integer; pGetCostFunc: TGetCostFunc): TPath;
    function FindPathOnMap(X, Y: Integer): TPath;
    procedure MakePathMap(MapWidthin, MapHeightin: Integer; StartX, StartY: Integer; pGetCostFunc: TGetCostFunc);

  private
    function DirToDX(Direction: Integer): Integer;
    function DirToDY(Direction: Integer): Integer;

  protected
    function GetCost(X, Y, Direction: Integer): Integer; virtual;
    function FillPathMap(X1, Y1, X2, Y2: Integer): TPathMapArray;
  end;

  TLegendMap = class(TPathMap)
  private
    FPath: TPath;
  public
    MapHeader: TMapHeader;
    MapData: array[0..1000 * 1000 - 1] of TMapInfo;
    MapTerrain: array[0..1000, 0..1000] of Boolean;
    //MapData: TMapData;

    Title: string;
    boNewMap: Boolean;
    //MapLoad: TMapLoading;
    constructor Create;
    destructor Destroy; override;
    property Path: TPath read FPath write FPath;

    //function LoadMap(): Boolean;
    procedure LoadFileData(sFileName: string);
    function TerrainType(nX, nY: Integer): Boolean;
    procedure SetTerrainType(nX, nY: Integer; boFlag: Boolean);
    function FindPath(StartX, StartY, StopX, StopY, PathSpace: Integer): TPath; overload;
    function FindPath(StopX, StopY: Integer): TPath; overload;
    procedure SetStartPos(StartX, StartY, PathSpace: Integer);

  protected
    function GetCost(X, Y, Direction: Integer): Integer; override;
  end;

  TWaveCell = record //·�ߵ�
    X, Y: Integer; //
    Cost: Integer; //
    Direction: Integer;
  end;

  TWave = class //·����
  private
    FData: array of TWaveCell;
    FPos: Integer; //
    FCount: Integer; //
    FMinCost: Integer;
    function GetItem: TWaveCell;
  public
    property Item: TWaveCell read GetItem; //
    property MinCost: Integer read FMinCost; // Cost

    constructor Create;
    destructor Destroy; override;
    procedure Add(NewX, NewY, NewCost, NewDirection: Integer); //
    procedure Clear; //FCount
    function Start: Boolean; //
    function Next: Boolean; //
  end;

const
  TerrainParams: array[Boolean] of Integer = (-1, 4);
  {TerrainParams: array[TTerrainTypes] of TTerrainParam = (
    (CellColor: clWhite; CellLabel: 'ƽ��'; MoveCost: 4),
    (CellColor: clOlive; CellLabel: 'ɳ��'; MoveCost: 6),
    (CellColor: clGreen; CellLabel: '����'; MoveCost: 10),
    (CellColor: clSilver; CellLabel: '��·'; MoveCost: 2),
    (CellColor: clBlack; CellLabel: '�ϰ���'; MoveCost: - 1),
    (CellColor: clRed; CellLabel: '·��'; MoveCost: 0)); }

var
  s2: string[20] = 'ZvDlKYnU6';
  s3: string[20] = 'IoDGmZX';

implementation


constructor TWave.Create;
begin
  Clear; //
end;

destructor TWave.Destroy;
begin
  FData := nil; //
  inherited Destroy;
end;

function TWave.GetItem: TWaveCell;
begin
  Result := FData[FPos]; //
end;

procedure TWave.Add(NewX, NewY, NewCost, NewDirection: Integer);
begin
  if FCount >= Length(FData) then //
    SetLength(FData, Length(FData) + 30); //
  with FData[FCount] do begin
    X := NewX;
    Y := NewY;
    Cost := NewCost;
    Direction := NewDirection;
  end;
  if NewCost < FMinCost then //NewCost
    FMinCost := NewCost;
  Inc(FCount); //
end;

procedure TWave.Clear;
begin
  FPos := 0;
  FCount := 0;
  FMinCost := High(Integer);
end;

function TWave.Start: Boolean;
begin
  FPos := 0; //
  Result := (FCount > 0); //
end;

function TWave.Next: Boolean;
begin
  Inc(FPos); //
  Result := (FPos < FCount); // false,
end;

constructor TPathMap.Create;
begin
  inherited Create();
end;

function TPathMap.FindPath(MapWidthin, MapHeightin: Integer; StartX, StartY,
  StopX, StopY: Integer;
  pGetCostFunc: TGetCostFunc): TPath;
begin
  MapWidth := MapWidthin; //
  MapHeight := MapHeightin; //
  GetCostFunc := pGetCostFunc;
  PathMapArray := FillPathMap(StartX, StartY, StopX, StopY);
  Result := FindPathOnMap(StopX, StopY);
end;

//*************************************************************
//    ��TPathMap���ҳ� TPath
//*************************************************************

function TPathMap.FindPathOnMap(X, Y: Integer): TPath;
var
  Direction: Integer;
begin
  Result := nil;
  if (X >= MapWidth) or (Y >= MapHeight) then Exit;
  if PathMapArray[Y, X].Distance < 0 then Exit;
  SetLength(Result, PathMapArray[Y, X].Distance + 1); //
  while PathMapArray[Y, X].Distance > 0 do begin
    Result[PathMapArray[Y, X].Distance] := Point(X, Y);
    Direction := PathMapArray[Y, X].Direction;
    X := X - DirToDX(Direction);
    Y := Y - DirToDY(Direction);
  end;
  Result[0] := Point(X, Y);
end;

procedure TPathMap.MakePathMap(MapWidthin, MapHeightin: Integer; StartX, StartY:
  Integer;
  pGetCostFunc: TGetCostFunc);
begin
  MapWidth := MapWidthin;
  MapHeight := MapHeightin; //
  GetCostFunc := pGetCostFunc;
  PathMapArray := FillPathMap(StartX, StartY, -1, -1);
end;

//*************************************************************
//    ������תΪX�������
//     7  0  1
//     6  X  2
//     5  4  3
//*************************************************************

function TPathMap.DirToDX(Direction: Integer): Integer;
begin
  case Direction of
    0, 4: Result := 0;
    1..3: Result := 1;
  else
    Result := -1;
  end;
end;

function TPathMap.DirToDY(Direction: Integer): Integer;
begin
  case Direction of
    2, 6: Result := 0;
    3..5: Result := 1;
  else
    Result := -1;
  end;
end;

//*************************************************************
//    Ѱ·�㷨
//    X1,Y1Ϊ·��������㣬X2��Y2Ϊ·�������յ�
//*************************************************************

function TPathMap.FillPathMap(X1, Y1, X2, Y2: Integer): TPathMapArray;
var
  OldWave, NewWave: TWave;
  Finished: Boolean;
  I: TWaveCell;

  procedure PreparePathMap; //��ʼ��PathMapArray
  var
    X, Y: Integer; //
  begin
    SetLength(Result, MapHeight, MapWidth);
    for Y := 0 to (MapHeight - 1) do
      for X := 0 to (MapWidth - 1) do
        Result[Y, X].Distance := -1;
  end;

  //��������8���ڵ��Ȩcost�����Ϸ������NewWave(),��������Сcost
  //�Ϸ�����ָ���ϰ�����Result[X��Y]��δ���ʵĵ�
  procedure TestNeighbours;
  var
    X, Y, C, D: Integer;
  begin
    for D := 0 to 7 do begin
      X := OldWave.Item.X + DirToDX(D);
      Y := OldWave.Item.Y + DirToDY(D);
      C := GetCost(X, Y, D);
      if (C >= 0) and (Result[Y, X].Distance < 0) then
        NewWave.Add(X, Y, C, D); //
    end;
  end;

  procedure ExchangeWaves; //
  var
    W: TWave;
  begin
    W := OldWave;
    OldWave := NewWave;
    NewWave := W;
    NewWave.Clear;
  end;

begin
  PreparePathMap; // ��ʼ��PathMapArray ,Distance:=-1
  OldWave := TWave.Create;
  NewWave := TWave.Create;
  Result[Y1, X1].Distance := 0; // ���Distance:=0
  OldWave.Add(X1, Y1, 0, 0); //��������OldWave
  TestNeighbours; //

  Finished := ((X1 = X2) and (Y1 = Y2)); //�����Ƿ񵽴��յ�
  while not Finished do begin
    ExchangeWaves; //
    if not OldWave.Start then
      Break;
    repeat
      I := OldWave.Item;
      I.Cost := I.Cost - OldWave.MinCost; // �������MinCost
      if I.Cost > 0 then // ����NewWave
        NewWave.Add(I.X, I.Y, I.Cost, I.Direction) //����Cost= cost-MinCost
      else begin //  ������СCOST�ĵ�
        if Result[I.Y, I.X].Distance >= 0 then
          Continue;

        Result[I.Y, I.X].Distance := Result[I.Y - DirToDY(I.Direction), I.X -
          DirToDX(I.Direction)].Distance + 1;
        // �˵� Distance:=��һ����Distance+1

        Result[I.Y, I.X].Direction := I.Direction;
        //
        Finished := ((I.X = X2) and (I.Y = Y2)); //�����Ƿ񵽴��յ�
        if Finished then
          Break;
        TestNeighbours;
      end;
    until not OldWave.Next; //
  end; // OldWave;
  NewWave.Free;
  OldWave.Free;
end;

function TPathMap.GetCost(X, Y, Direction: Integer): Integer;
begin
  Direction := (Direction and 7);
  if (X < 0) or (X >= MapWidth) or (Y < 0) or (Y >= MapHeight) then
    Result := -1
  else
    Result := GetCostFunc(X, Y, Direction, PathWidth);
end;
 {
function TLegendMap.LoadMap(): Boolean;
begin
  Result := True;
  if g_LegendMapRun then exit;
  if g_LegendMapName <> Title then begin
    Title := g_LegendMapName;
    g_LegendMapRun := True;
    MapLoad := TMapLoading.Create(True);
    MapLoad.FreeOnTerminate := True;
    MapLoad.Resume;
  end;
  g_LegendMapName := '';
end;

procedure TMapLoading.Execute;
var
  aMapFile: TFileStream;
  i, j: Integer;
  MapBuf: TMapBlock;
begin
  with g_LegendMap do begin
    aMapFile := TFileStream.Create(Title, fmOpenRead  or fmShareDenyNone);
    try
      aMapFile.Read(MapHeader, sizeof(TMapHeader)); //
      MapWidth := MapHeader.Width;
      MapHeight := MapHeader.Height;
      SetLength(MapData, MapWidth, MapHeight);
      for i := 0 to MapHeader.width - 1 do
        for j := 0 to MapHeader.height - 1 do begin
          aMapFile.Read(MapBuf, sizeof(MapBuf));
          if ((MapBuf.wBkImg and $8000) + (MapBuf.wFrImg and $8000)) = 0 then
            MapData[i, j].TerrainType := True //��ʶΪƽ��
          else
            MapData[i, j].TerrainType := False; //��ʶΪ�ϰ���
        end;
    except
      aMapFile.Free;
    end;
    aMapFile.Free;
  end;
  PostMessage(g_FrmMainWinHandle, WM_USER + 1004, 0, 0);
  inherited;
end;       }

constructor TLegendMap.Create;
begin
  inherited Create();
  Title := '';
  FillChar(MapTerrain[0, 0], SizeOf(MapTerrain), True);
  //Priority := tpLower;
end;

destructor TLegendMap.Destroy;
begin
  FPath := nil;
  //MapData := nil;
  inherited;
end;


function TLegendMap.FindPath(StopX, StopY: Integer): TPath;
begin
  //if g_LegendMapRun then exit;
  Result := FindPathOnMap(StopX, StopY);
end;

function TLegendMap.TerrainType(nX, nY: Integer): Boolean;
begin
  Result := False;
  if (nX > 0) and (nY > 0) and (nX <= 1000) and (nY <= 1000) then begin
    if MapTerrain[nX, nY] then begin
      Result := (MapData[nX * MapHeight + nY].wBkImg and $8000) + (MapData[nX * MapHeight + nY].wFrImg and $8000) = 0;
    end;
  end;
end;

procedure TLegendMap.SetTerrainType(nX, nY: Integer; boFlag: Boolean);
begin
  if (nX > 0) and (nY > 0) and (nX <= 1000) and (nY <= 1000) then begin
    MapTerrain[nX, nY] := boFlag;
  end;
end;

function TLegendMap.FindPath(StartX, StartY, StopX, StopY, PathSpace: Integer): TPath;
begin
  //if g_LegendMapRun then exit;
  PathWidth := PathSpace;
  PathMapArray := FillPathMap(StartX, StartY, StopX, StopY);
  Result := FindPathOnMap(StopX, StopY);
end;

procedure TLegendMap.SetStartPos(StartX, StartY, PathSpace: Integer);
begin
  PathWidth := PathSpace;
  PathMapArray := FillPathMap(StartX, StartY, -1, -1);
end;

function TLegendMap.GetCost(X, Y, Direction: Integer): Integer;
var
  cost: Integer;
  //  sel : Integer;
begin
  Direction := (Direction and 7);
  if (X < 0) or (X >= MapWidth) or (Y < 0) or (Y >= MapHeight) then
    Result := -1
  else begin
    Result := TerrainParams[TerrainType(x, y)];
    if (X < MapWidth - PathWidth) and (X > PathWidth) and
      (Y < MapHeight - PathWidth) and (Y > PathWidth) then begin
      cost := TerrainParams[TerrainType(X - PathWidth, Y)]
        + TerrainParams[TerrainType(X + PathWidth, Y)]
        + TerrainParams[TerrainType(X, Y - PathWidth)]
        + TerrainParams[TerrainType(X, Y + PathWidth)];
      if cost < 4 * TerrainParams[True] then
        Result := -1;
    end;

    if ((Direction and 1) = 1) and (Result > 0) then // �����б����,��COST����
      Result := Result + (Result shr 1); //ӦΪResult*sqt(2),�˴�����Ϊ1.5
  end;

end;

procedure TLegendMap.LoadFileData(sFileName: string);
var
  aMapFile: TFileStream;
  MendHeader: TMapMendHeader;
  MendInfo: TMapMendInfo;
  I, J, Y: Integer;
  ENMapHeader: TENMapHeader;
  boENMap: Boolean;
  ENMapData: array of TENMapInfo;
  OldMapData: array of TOldMapInfo;
  OldMapInfo: TOldMapInfo;
begin
  if FileExists(sFileName) then begin
    aMapFile := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyNone);
    try
      aMapFile.Read(ENMapHeader, Sizeof(TENMapHeader));
      boENMap := (ENMapHeader.Title = 'Map 2010 Ver 1.0');
      boNewMap := False;
      if boENMap then begin
        MapHeader.wWidth := ENMapHeader.Width xor $AA38;
        MapHeader.wHeight := ENMapHeader.Height xor $AA38;
      end else begin
        Move(ENMapHeader, MapHeader, SizeOf(MapHeader));
        if (MapHeader.sTitle[14] = #$D) and (MapHeader.sTitle[15] = #$A) then
          boNewMap := True;
        aMapFile.Seek(SizeOf(MapHeader), 0);
      end;
      MapWidth := MapHeader.wWidth;
      MapHeight := MapHeader.wHeight;


      if (MapWidth <= 1000) and (MapHeight <= 1000) and (MapWidth > 0) and (MapHeight > 0) then begin
        if boENMap then begin
          SetLength(ENMapData, MapWidth * MapHeight);
          aMapFile.Read(ENMapData[0], Length(ENMapData) * SizeOf(TENMapInfo));
          for I := Low(ENMapData) to High(ENMapData) do begin
            MapData[i].wBkImg := ENMapData[i].BkImg xor $AA38;
            if (ENMapData[i].BkImgNot xor $AA38) = $2000 then
              MapData[i].wBkImg := MapData[i].wBkImg or $8000;
            MapData[i].wMidImg := ENMapData[i].MidImg xor $AA38;
            MapData[i].wFrImg := ENMapData[i].FrImg xor $AA38;
            MapData[i].btDoorIndex := ENMapData[i].DoorIndex;
            MapData[i].btDoorOffset := ENMapData[i].DoorOffset;
            MapData[i].btAniFrame := ENMapData[i].AniFrame;
            MapData[i].btAniTick := ENMapData[i].AniTick;
            MapData[i].btArea := ENMapData[i].Area;
            MapData[i].btlight := ENMapData[i].light;
            MapData[i].btBkIndex := 0;
            MapData[i].btSmIndex := 0;
          end;
          ENMapData := nil;
        end else
        if boNewMap then begin
          aMapFile.Read(MapData[0], MapWidth * SizeOf(TMapInfo) * MapHeight);
        end else begin
          SetLength(OldMapData, MapWidth * MapHeight);
          aMapFile.Read(OldMapData[0], MapWidth * SizeOf(TOldMapInfo) * MapHeight);
          for I := Low(OldMapData) to High(OldMapData) do begin
            Move(OldMapData[I], MapData[I], SizeOf(TOldMapInfo));
            MapData[I].btBkIndex := 0;
            MapData[I].btSmIndex := 0;
          end;
          OldMapData := nil;
        end;
      end;
    finally
      aMapFile.Free;
    end;
    sFileName := sFileName + '.mend';
    if FileExists(sFileName) then begin
      aMapFile := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyNone);
      try
        aMapFile.Read(MendHeader, Sizeof(TMapMendHeader));
        if (MendHeader.nWidth = MapWidth) and (MendHeader.nHeight = MapHeight) then begin
          for I := 0 to MendHeader.nCount - 1 do begin
            if aMapFile.Read(MendInfo, Sizeof(TMapMendInfo)) = Sizeof(TMapMendInfo) then begin
              if (MendInfo.nX > 0) and (MendInfo.nY > 0) and (MendInfo.nWidth > 0) and (MendInfo.nHeight > 0) and
                ((MendInfo.nX + MendInfo.nWidth) < MapWidth) and ((MendInfo.nY + MendInfo.nHeight) < MapHeight) then begin
                for J := MendInfo.nX to MendInfo.nX + MendInfo.nWidth do begin
                  for Y := 0 to MendInfo.nHeight - 1 do begin
                    aMapFile.Read(OldMapInfo, Sizeof(TOldMapInfo));
                    Move(OldMapInfo, MapData[J * MapHeight + MendInfo.nY + Y], SizeOf(TOldMapInfo));
                    MapData[J * MapHeight + MendInfo.nY + Y].btBkIndex := 0;
                    MapData[J * MapHeight + MendInfo.nY + Y].btSmIndex := 0;
                  end;
                end;
              end;
            end;
          end;
        end;
      finally
        aMapFile.Free;
      end;
    end;
  end;
end;

{ TMapLoading }



end.
