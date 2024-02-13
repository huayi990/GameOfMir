unit HGENewFont;

interface

uses
  Windows, Classes, SysUtils, StrUtils, Forms, Graphics, GfxFont, HGECanvas,
  HGEBase;

type
  TImageNewFont = class
  public
    Font_Default: TGfxFont;
    Font_Default_H: TGfxFont;
    StartTime: LongWord;
    I: Integer;
    constructor Create();
    destructor Destroy(); override;
    procedure iniClass();
    function TextWidth(Str: WideString): Integer;
    function TextHeight(Str: WideString): Integer;
    procedure TextOut( x, y: Integer; FColor: Cardinal;Str: WideString);  overload;
    procedure TextOut( x, y: Integer; Str: WideString; FColor: Cardinal); overload;
    procedure TextOut( x, y: Integer; Str: WideString; FColor: Cardinal; BColor: Cardinal); overload;
    procedure DrawFont(Str: WideString; x, y: Integer; HaveBackGround{是否有背景}: Boolean;
                      BackGroundColor{背景颜色}: LongWord; Haveshadow{是否有阴影}: Boolean;Color: LongWord; show: Boolean);
    procedure DrawFont_H(Str: WideString; x, y: Integer; HaveBackGround{是否有背景}: Boolean;
                      BackGroundColor{背景颜色}: LongWord; Haveshadow{是否有阴影}: Boolean;Color: LongWord; show: Boolean);
 end;

implementation

var
  HCanvas: TDXCanvas;

constructor TImageNewFont.Create();
begin
  inherited;
end;

destructor TImageNewFont.Destroy();
begin
  Font_Default.Free;
  Font_Default_H.Free;
  inherited;
end;

procedure TImageNewFont.iniclass();
begin
  Font_Default := TGfxFont.Create('宋体', 12, False, False, False);  //加粗 斜体 锯齿
  Font_Default_H := TGfxFont.Create('华文行楷', 22, true, False, true);
  StartTime := GetTickCount;
  I := 0;
end;

procedure TImageNewFont.TextOut( x, y: Integer; FColor: Cardinal;Str: WideString);
begin
  DrawFont( Str, x, y, false, 0, True, FColor, false);
end;
procedure TImageNewFont.TextOut( x, y: Integer;Str: WideString; FColor: Cardinal);
begin
  DrawFont( Str, x, y, false, 0, false, FColor, false);
end;
procedure TImageNewFont.TextOut( x, y: Integer;Str: WideString; FColor: Cardinal; BColor: Cardinal);
begin
  DrawFont( Str, x, y, True, BColor, false, FColor, false);
end;
procedure TImageNewFont.DrawFont(Str: WideString; x, y: Integer; HaveBackGround: Boolean;
BackGroundColor: LongWord; Haveshadow: Boolean; Color: LongWord; show: Boolean);
var
  OldColor: LongWord;
begin
  Color := DisplaceRB(Color or $FF000000);     
  BackGroundColor := DisplaceRB(BackGroundColor or $FF000000);
  with Font_Default do begin
    OldColor := GetColor();
    str := widestring(str);
    if GetTickCount - StartTime > 150 then begin
      StartTime := GetTickCount;
      Inc(I);
      if I >=  3 then  I :=  0 ;
    end;
    if HaveBackGround then
    begin
       HCanvas.Rectangle( x, y,
                          GetTextSize(PWideChar(str)).cx,
                          GetTextSize(PWideChar(str)).cY,
                          BackGroundColor, True);
    end;
    if show then
    begin
      if Haveshadow then
      begin
          SetColor($FF000000);
          Print(x - 1, y, PWideChar(str));
          Print(x + 1, y, PWideChar(str));
          Print(x, y - 1, PWideChar(str));
          Print(x, y + 1, PWideChar(str));          
          SetColor(Color,I);
          Print(x, y, PWideChar(str));
          SetColor(OldColor);
      end
      else
      begin
          SetColor(Color,I);
          Print(x, y, PWideChar(str) );
          SetColor(OldColor);
      end;
    end
    else
    begin
      if  Haveshadow then
      begin
          SetColor($FF000000);
          Print(x - 1, y, PWideChar(str));
          Print(x + 1, y, PWideChar(str));
          Print(x, y - 1, PWideChar(str));
          Print(x, y + 1, PWideChar(str));   
          SetColor(Color);
          Print(x, y, PWideChar(str) );
          SetColor(OldColor);
      end
      else
      begin
          SetColor(Color);
          Print(x, y, PWideChar(str));
          SetColor(OldColor);
      end;
    end;
  end;
end;

procedure TImageNewFont.DrawFont_H(Str: WideString; x, y: Integer; HaveBackGround: Boolean;
BackGroundColor: LongWord; Haveshadow: Boolean; Color: LongWord; show: Boolean);
var
  OldColor: LongWord;
begin
  with Font_Default_H do begin
    OldColor := GetColor();
    str := widestring(str);
    if GetTickCount - StartTime > 150 then begin
      StartTime := GetTickCount;
      Inc(I);
      if I >=  3 then  I :=  0 ;
    end;
    if HaveBackGround then
    begin
       HCanvas.Rectangle( x - 1, y - 1,
                          GetTextSize(PWideChar(str)).cx + 1,
                          GetTextSize(PWideChar(str)).cY + 1,
                          BackGroundColor, True);
    end;
    if show then
    begin
      if Haveshadow then
      begin
          SetColor($FF000000);
          Print(x - 1, y, PWideChar(str));
          Print(x + 1, y, PWideChar(str));
          Print(x, y - 1, PWideChar(str));
          Print(x, y + 1, PWideChar(str));
          SetColor(Color,I);
          Print(x, y, PWideChar(str));
          SetColor(OldColor);
      end
      else
      begin
          SetColor(Color,I);
          Print(x, y, PWideChar(str) );
          SetColor(OldColor);
      end;
    end
    else
    begin
      if Haveshadow then
      begin
          SetColor($FF000000);
          Print(x - 1, y, PWideChar(str));
          Print(x + 1, y, PWideChar(str));
          Print(x, y - 1, PWideChar(str));
          Print(x, y + 1, PWideChar(str));
          SetColor(Color);
          Print(x, y, PWideChar(str));
          SetColor(OldColor);
      end
      else
      begin
          SetColor(Color);
          Print(x, y, PWideChar(str));
          SetColor(OldColor);
      end;
    end;
  end;
end;

function TImageNewFont.TextWidth(Str: WideString): Integer;
begin
  Result := Font_Default.GetTextSize(PWideChar(str)).cx;
end;

function TImageNewFont.TextHeight(Str: WideString): Integer;
begin
  Result := Font_Default.GetTextSize(PWideChar(str)).cy;
end;

end.

