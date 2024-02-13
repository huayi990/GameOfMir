unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DXDraws, ExtCtrls, StdCtrls, Spin, WIL, WMFile;

type
  TClickPoint = record
    rc: TRect;
    rstr: string;
  end;
  pTClickPoint = ^TClickPoint;

  TForm1 = class(TForm)
    Panel1: TPanel;
    DxDraw: TDXDraw;
    Timer1: TTimer;
    Panel2: TPanel;
    Button1: TButton;
    EditY: TSpinEdit;
    EditX: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    ScrollBar2: TScrollBar;
    ScrollBar1: TScrollBar;
    Label4: TLabel;
    Label3: TLabel;
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DxDrawInitialize(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    NpcTempList: TStringList;
    AutoColorIdx: Byte;
    AutoImgTime: LongWord;
    AutoTick: LongWord;
    RunTime: LongWord;
  public
    procedure BoldTextOut(surface: TDirectDrawSurface; x, y, fcolor, bcolor:
      integer; str: string);
    procedure DMerchantDlgShowText(dsurface: TDirectDrawSurface; Msg,
      SelectStr: string; X, Y: Word; Points: TList; var AddPoints: Boolean);
    function GetRGB(c256: byte): LongWord;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
  end;

var
  Form1: TForm1;
  ChrBuff: PChar;

implementation
uses
  HUtil32;

{$R *.dfm}

function TForm1.GetRGB(c256: byte): LongWord;
begin
  with DXDraw do
    Result := RGB(DefColorTable[c256].rgbRed,
      DefColorTable[c256].rgbGreen,
      DefColorTable[c256].rgbBlue);
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  AutoImgTime := GetTickCount;
end;

procedure TForm1.AppOnIdle(Sender: TObject; var Done: Boolean);
var
  QuestAddPoints: Boolean;
  d: TDirectDrawSurface;
begin
  done := True;
  if GetTickCount < RunTime then Exit;
  RunTime := GetTickCount + 100;
  DxDraw.Surface.Fill($FFFF);
  {if RadioGroup1.ItemIndex <> 0 then
    d := g_WMain99Images.Images[111]
  else
    d := g_WMain99Images.Images[300];
  if d <> nil then
    DxDraw.Surface.Draw(0, 0, d.ClientRect, d, True);   }
  QuestAddPoints := False;
  DMerchantDlgShowText(DxDraw.Surface, Memo1.Lines.GetText, '', EditX.Value,
    EditY.Value,
    nil, QuestAddPoints);
  DxDraw.Flip;
end;

procedure TForm1.BoldTextOut(surface: TDirectDrawSurface; x, y, fcolor, bcolor:
  integer; str: string);
var
  nLen: Integer;
begin
  if str = '' then Exit;
  with surface do begin
    nLen := Length(str);
    Move(str[1], ChrBuff^, nlen);
    Canvas.Font.Color := bcolor;
    TextOut(Canvas.Handle, x - 1, y, ChrBuff, nlen);
    TextOut(Canvas.Handle, x + 1, y, ChrBuff, nlen);
    TextOut(Canvas.Handle, x, y - 1, ChrBuff, nlen);
    TextOut(Canvas.Handle, x, y + 1, ChrBuff, nlen);
    Canvas.Font.Color := fcolor;
    TextOut(Canvas.Handle, x, y, ChrBuff, nlen);
  end;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0 then begin
    EditX.Value := 15;
    EditY.Value := 12;
  end
  else if RadioGroup1.ItemIndex = 1 then begin
    EditX.Value := 20;
    EditY.Value := 20;
  end;

end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  Label3.Color := GetRGB(ScrollBar1.Position);
  Label4.Color := GetRGB(ScrollBar1.Position);
  Label3.Caption :=
    Format('������ɫ���� ABCDEFG abcdefg 1234567890 (F%d,B%d)',
    [ScrollBar2.Position, ScrollBar1.Position]);
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
  Label3.Font.Color := GetRGB(ScrollBar2.Position);
  Label3.Caption :=
    Format('������ɫ���� ABCDEFG abcdefg 1234567890 (F%d,B%d)',
    [ScrollBar2.Position, ScrollBar1.Position]);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //
end;

procedure TForm1.DMerchantDlgShowText(dsurface: TDirectDrawSurface; Msg,
  SelectStr: string; X, Y: Word; Points: TList; var AddPoints: Boolean);
var
  lx, ly, sx, i: integer;
  str, data, fdata, cmdstr, cmdparam, sTemp: string;
  pcp: PTClickPoint;
  d: TDirectDrawSurface;
  boNewPoint: Boolean;

  function ColorText(sStr: string; DefColor: TColor; boDef, boLength: Boolean): string;
  var
    sdata, sfdata, scmdstr, scmdparam, scmdcolor: string;
    ii: Integer;
    mfid, mmid, mx, my, mw, mh, ax, ay, rw, rh: Integer;
    sName, sparam, sMin, sMax: string;
    d: TDirectDrawSurface;
    boMove: Boolean;
    boTransparent: Boolean;
    dc, rc: TRect;
    dwTime: LongWord;
    boReduce: Byte;
    nAlpha: Integer;
    Idx, nMin, nMax: Integer;
    Color: TColor;
    ShowHint: pTShowHint;
    backText: string;
  begin
    backText := '';
    sdata := sStr;
    sfdata := '';
    while (pos('{', sdata) > 0) and (pos('}', sdata) > 0) and (sdata <> '') do begin
      sfdata := '';
      if sdata[1] <> '{' then begin
        sdata := '{' + GetValidStr3(sdata, sfdata, ['{']);
      end;
      scmdparam := '';
      scmdstr := '';
      sdata := ArrestStringEx(sdata, '{', '}', scmdstr);
      if scmdstr <> '' then begin
        scmdparam := GetValidStr3(scmdstr, scmdstr, ['=']);
        scmdcolor := GetValidStr3(scmdparam, scmdparam, ['=']);
      end;
      if sfdata <> '' then begin
        if boLength then begin
          backText := backText + sfdata;
        end
        else begin
          BoldTextOutEx(dsurface, lx + sx, ly, DefColor, $8, sfdata);
          sx := sx + dsurface.Canvas.TextWidth(sfdata);
        end;
        sfdata := '';
      end;
      Color := DefColor;
      if CompareLStr(scmdparam, 'img', length('img')) then begin //new
        boTransparent := True;
        boMove := False;
        mfid := -1;
        mmid := -1;
        mx := 0;
        my := 0;
        mw := 0;
        mh := 0;
        rw := 0;
        dwTime := 100;
        boReduce := 0;
        nAlpha := 125;
        while True do begin
          if scmdstr = '' then
            Break;
          scmdstr := GetValidStr3(scmdstr, stemp, [',']);
          if stemp = '' then
            Break;
          sTemp := LowerCase(stemp);
          sparam := GetValidStr3(stemp, sName, ['.']);
          if (sName <> '') and (sparam <> '') then begin
            case sName[1] of
              'f': begin
                  mfid := StrToIntDef(sparam, -1);
                  if not (mfid in [Images_Begin..Images_End]) then
                    mfid := -1;
                end;
              'i': begin
                  g_TempList.Clear;
                  if ExtractStrings(['+'], [], PChar(sparam), g_TempList) > 0 then begin
                    Idx := 0;
                    while True do begin
                      if Idx >= g_TempList.Count then
                        Break;
                      sTemp := g_TempList[Idx];
                      if pos('-', sTemp) > 0 then begin
                        sMax := GetValidStr3(stemp, sMin, ['-']);
                        nMin := StrToIntDef(sMin, 0);
                        nMax := StrToIntDef(sMax, 0);
                        if nMin = 0 then
                          nMin := nMax;
                        if nMax = 0 then
                          nMax := nMin;
                        if nMin > nMax then
                          nMin := nMax;
                        g_TempList.Delete(Idx);
                        if nMin <> 0 then begin
                          for ii := nMin to nMax do begin
                            g_TempList.Insert(Idx, IntToStr(ii));
                            Inc(idx);
                          end;
                        end;

                      end
                      else
                        Inc(Idx);
                    end;
                    if dwTime > 0 then begin
                      Idx := GetTickCount div dwTime mod LongWord(g_TempList.Count);
                      //Idx := Idx ;
                    end
                    else
                      Idx := 0;
                    mmid := StrToIntDef(g_TempList[Idx], -1);
                  end
                  else
                    mmid := StrToIntDef(sparam, -1);
                end;
              'x': mx := StrToIntDef(sparam, 0);
              'y': my := StrToIntDef(sparam, 0);
              'w': mw := StrToIntDef(sparam, 0);
              'h': mh := StrToIntDef(sparam, 0);
              'l': rw := StrToIntDef(sparam, 0);
              'b': rh := StrToIntDef(sparam, 0);
              'p': boTransparent := (sparam = '1');
              'm': boMove := (sparam = '1');
              't': dwTime := StrToIntDef(sparam, 0);
              'r': boReduce := StrToIntDef(sparam, 0);
              'a': nAlpha := StrToIntDef(sparam, 0);
            end;
          end;
        end;
        if (mfid > -1) and (mmid > -1) and (g_ClientImages[mfid] <> nil) then begin
          d := g_ClientImages[mfid].GetCachedImage(mmid, ax, ay);
          if d <> nil then begin
            if mx = 0 then
              mx := lx + sx;
            if my = 0 then
              my := ly;
            if mw = 0 then
              mw := d.Width;
            if mh = 0 then
              mh := d.Height;
            if boMove then begin
              mx := mx + ax;
              my := my + ay;
            end;
            dsurface.Canvas.Release;
            if boReduce = 1 then begin
              rc.Left := rw;
              rc.Top := rh;
              rc.Right := rc.Left + mw;
              rc.Bottom := rc.Top + mh;
              dsurface.Draw(mx, my, rc, d, boTransparent);
            end
            else if boReduce = 2 then begin
              new(ShowHint);
              ShowHint.Surface := g_ClientImages[mfid];
              ShowHint.Index := mmid;
              ShowHint.Reduce := 2;
              ShowHint.Rect.Top := my;
              ShowHint.Rect.Left := mx;
              ShowHint.boTransparent := boTransparent;
              DrawList.Add(ShowHint);
              //DrawBlend(dSurface, mx, my, d, Integer(boTransparent));
              //dSurface.DrawAdd(rc, d.ClientRect, d, boTransparent, nAlpha);
            end
            else if boReduce = 3 then begin
              new(ShowHint);
              ShowHint.Surface := g_ClientImages[mfid];
              ShowHint.Index := mmid;
              ShowHint.Reduce := 3;
              ShowHint.Rect.Left := mx;
              ShowHint.Rect.Top := my;
              ShowHint.Rect.Right := rc.Left + mw;
              ShowHint.Rect.Bottom := rc.Top + mh;
              ShowHint.boTransparent := boTransparent;
              ShowHint.Alpha := nAlpha;
              DrawList.Add(ShowHint);
              {rc.Left := mx;
              rc.Top := my;
              rc.Right := rc.Left + mw;
              rc.Bottom := rc.Top + mh;    }
              //dSurface.DrawAlpha(rc, d.ClientRect, d, boTransparent, nAlpha);
            end
            else if (mw <> 0) or (mh <> 0) then begin
              dc.Left := mx;
              dc.Top := my;
              dc.Right := dc.Left + mw;
              dc.Bottom := dc.Top + mh;
              rc.Left := 0;
              rc.Top := 0;
              rc.Right := d.ClientRect.Right;
              rc.Bottom := d.ClientRect.Bottom;
              dsurface.StretchDraw(dc, rc, d, boTransparent);
            end
            else begin
              dsurface.Draw(mx, my, d.ClientRect, d, boTransparent);
            end;
            SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
          end;
        end;
        sfdata := '';
        scmdparam := '';
        scmdstr := '';
        Continue;
      end
      else if CompareLStr(scmdparam, 'X', length('X')) then begin //new
        sx := sx + StrToIntDef(scmdstr, 0);
        sfdata := '';
        scmdparam := '';
        scmdstr := '';
        Continue;
      end
      else if CompareLStr(scmdparam, 'Y', length('Y')) then begin //new
        ly := ly + StrToIntDef(scmdstr, 0);
        sfdata := '';
        scmdparam := '';
        scmdstr := '';
        Continue;
      end
      else if CompareText(scmdparam, 'FCO') = 0 then begin
        g_TempList.Clear;
        if ExtractStrings([','], [], PChar(scmdcolor), g_TempList) > 0 then begin
          //Idx := AutoColorIdx mod g_TempList.Count;
          scmdcolor := g_TempList.Strings[0];
        end;
        Color := GetRGB(Lobyte(StrToIntDef(scmdcolor, 255)));
      end;
      if boDef then
        Color := DefColor;
      if boLength then begin
        backText := backText + scmdstr;
      end
      else begin
        BoldTextOutEx(dsurface, lx + sx, ly, Color, $8, scmdstr);
        sx := sx + dsurface.Canvas.TextWidth(scmdstr);
      end;
    end; //end while
    if sdata <> '' then begin
      if boLength then begin
        backText := backText + sdata;
      end
      else begin
        BoldTextOutEx(dsurface, x + sx, ly, DefColor, $8, sdata);
        sx := sx + dsurface.Canvas.TextWidth(sdata);
      end;
    end;
    Result := backText;
  end;

begin
  with DSurface.Canvas do begin
    SetBkMode(Handle, TRANSPARENT);
    for i := 0 to DrawList.count - 1 do
      Dispose(pTShowHint(DrawList[i]));
    DrawList.Clear;
    //SetTextCharacterExtra(Handle, 1);
    lx := x;
    ly := y;
    str := Msg;
    while TRUE do begin
      if str = '' then
        break;
      str := GetValidStr3(str, data, ['\']);
      if data <> '' then begin
        sx := 0;
        while (pos('<', data) > 0) and (pos('>', data) > 0) and (data <> '') do begin
          fdata := '';
          if data[1] <> '<' then begin
            data := '<' + GetValidStr3(data, fdata, ['<']);
          end;
          data := ArrestStringEx(data, '<', '>', cmdstr);
          cmdparam := GetValidStr3(cmdstr, cmdstr, ['/']);
          if fdata <> '' then begin
            ColorText(fdata, clwhite, False, False);
            fdata := '';
          end;
          if Length(cmdstr) > 1 then begin
            boNewPoint := False;
            if cmdstr[1] = '&' then begin
              boNewPoint := True;
              cmdstr := Copy(cmdstr, 2, Length(cmdstr) - 1);
            end;
            if (AddPoints) and (cmdparam <> '') then begin //new
              if boNewPoint then begin
                new(pcp);
                pcp.rc := Rect(lx + sx, ly, lx + sx + DSurface.Width, ly + 20);
                pcp.RStr := cmdparam;
                Points.Add(pcp);
              end else begin
                new(pcp);
                sTemp := ColorText(cmdstr, clRed, False, True);
                pcp.rc := Rect(lx + sx, ly, lx + sx + TextWidth(sTemp), ly + 14);
                pcp.RStr := cmdparam;
                Points.Add(pcp);
              end;
            end;
            if cmdparam = '' then begin
              ColorText(cmdstr, clRed, False, False);
            end
            else begin
              if (lx + sx = SelectRect.Left) and (ly = SelectRect.Top) and (lx + sx <= SelectRect.Right) then begin
                if boNewPoint then begin
                  Release;
                  d := g_WMain99Images.Images[350];
                  if d <> nil then begin
                    DSurface.Draw(lx + sx, ly + 1, d.ClientRect, d, True);
                  end;
                  DrawAlphaOfColor(DSurface, lx + sx + 20, ly, DSurface.Width - 40, 20, 38099, 160);
                  SetBkMode(Handle, TRANSPARENT);
                  Inc(ly, 5);
                  Inc(sx, 26);
                  ColorText(cmdstr, clYellow{DDDADC}, False, False);
                  Inc(ly, 3);
                end else begin
                  Inc(ly);
                  Inc(sx);
                  Font.Style := [fsUnderline];
                  ColorText(cmdstr, clRed, True, False);
                  Font.Style := [];
                  dec(ly);
                  dec(sx);
                end;
              end
              else if (lx + sx = MoveRect.Left) and (ly = MoveRect.Top) and (lx + sx <= MoveRect.Right) then begin
                if boNewPoint then begin
                  Release;
                  d := g_WMain99Images.Images[349];
                  if d <> nil then begin
                    DSurface.Draw(lx + sx, ly + 1, d.ClientRect, d, True);
                  end;
                  DrawAlphaOfColor(DSurface, lx + sx + 20, ly, DSurface.Width - 40, 20, 38099, 200);
                  SetBkMode(Handle, TRANSPARENT);
                  Inc(ly, 4);
                  Inc(sx, 25);
                  ColorText(cmdstr, clYellow{DDDADC}, False, False);
                  Inc(ly, 4);
                end else begin
                  Font.Style := [fsUnderline];
                  ColorText(cmdstr, clYellow, True, False);
                  Font.Style := [];
                end;
              end
              else begin
                if boNewPoint then begin
                  Release;
                  d := g_WMain99Images.Images[348];
                  if d <> nil then begin
                    DSurface.Draw(lx + sx, ly + 1, d.ClientRect, d, True);
                  end;
                  SetBkMode(Handle, TRANSPARENT);
                  Inc(ly, 4);
                  Inc(sx, 25);
                  ColorText(cmdstr, clYellow{DDDADC}, False, False);
                  Inc(ly, 4);
                end else
                  ColorText(cmdstr, clYellow, False, False);
              end;
            end;
          end;
        end;
        if data <> '' then
          ColorText(data, clwhite, False, False);
      end;
      Inc(ly, 16);
    end;
    Release;
  end;
  //Result := ly;
end;

procedure TForm1.DxDrawInitialize(Sender: TObject);
begin
  DxDraw.Surface.Canvas.Font.Name := '����';
  DxDraw.Surface.Canvas.Font.Size := 9;
  InitWMImagesLib(DXDraw);

  DXDraw.DefColorTable := g_WMainImages.MainPalette;

  DXDraw.ColorTable := DXDraw.DefColorTable;
  DXDraw.UpdatePalette;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GetMem(ChrBuff, 2048);
  NpcTempList := TStringList.Create;
  AutoColorIdx := 0;
  AutoTick := GetTickCount;
  Application.OnIdle := AppOnIdle;
  RadioGroup1.ItemIndex := 1;
  Label3.Color := GetRGB(ScrollBar1.Position);
  Label4.Color := GetRGB(ScrollBar1.Position);
  Label3.Font.Color := GetRGB(ScrollBar2.Position);
  Label3.Caption :=
    Format('������ɫ���� ABCDEFG abcdefg 1234567890 (F%d,B%d)',
    [ScrollBar2.Position, ScrollBar1.Position]);
  LoadWMImagesLib(nil);
  RunTime := GetTickCount;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UnLoadWMImagesLib();
  FreeMem(ChrBuff);
  NpcTempList.Free;
end;

end.

