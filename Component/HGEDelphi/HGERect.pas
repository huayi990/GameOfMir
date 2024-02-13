unit HGERect;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** hgeRect helper class
**
** Delphi conversion by Erik van Bilsen
*)

interface

(****************************************************************************
 * HGERect.h
 ****************************************************************************)

type
  THGERect = record
    FClean: Boolean;
    X1, Y1, X2, Y2: Single;
    end;
  THGErect2=class
    function Create(const Clean: Boolean):THGERect; overload;
    function Create(const AX1, AY1, AX2, AY2: Single):THGERect; overload;
    function SetRect(const AX1, AY1, AX2, AY2: Single):THGERect;
    function SetRadius(const X, Y, R: Single):THGERect;
    function Encapsulate(const z:THGERect;const X, Y: Single):THGERect;
    function TextPoint(const z:THGERect; const X, Y: Single): Boolean;
    function Intersect(const z:THGERect;const Rect: THGERect): Boolean;
  end;
  PHGERect = ^THGERect;
var hgeRct:THGErect2;
implementation

(****************************************************************************
 * HGERect.h, HGERect.cpp
 ****************************************************************************)

{ THGERect }

function THGERect2.Create(const AX1, AY1, AX2, AY2: Single):THGERect;
begin
  result:=SetRect(AX1,AY1,AX2,AY2);
end;

function THGERect2.Create(const Clean: Boolean):THGERect;
begin
  result:=SetRect(0,0,0,0);
  result.FClean := Clean;
end;

function THGERect2.Encapsulate(const z:THGERect; const X, Y: Single):THGERect;
begin

  with Result do begin
  if (FClean) then begin
    X1 := X;
    X2 := X;
    Y1 := Y;
    Y2 := Y;
    FClean := False;
  end else begin
     result:=z;
    if (X < X1) then
      X1 := X;
    if (X > X2) then
      X2 := X;
    if (Y < Y1) then
      Y1 := Y;
    if (Y > Y2) then
      Y2 := Y;
  end;   end;
end;

function THGERect2.Intersect(const z:THGERect;const Rect: THGERect): Boolean;
begin
  with z do begin
  Result := (Abs(X1 + X2 - Rect.X1 - Rect.X2) < (X2 - X1 + Rect.X2 - Rect.X1))
        and (Abs(Y1 + Y2 - Rect.Y1 - Rect.Y2) < (Y2 - Y1 + Rect.Y2 - Rect.Y1));
end; end;


function THGERect2.SetRadius(const X, Y, R: Single):THGERect;
begin
  with Result do begin
  X1 := X - R;
  X2 := X + R;
  Y1 := Y - R;
  Y2 := Y + R;
  FClean := False;
end; end;

function THGERect2.SetRect(const AX1, AY1, AX2, AY2: Single):THGERect;
begin
  with Result do begin
  X1 := AX1;
  Y1 := AY1;
  X2 := AX2;
  Y2 := AY2;
  FClean := False;  end;
end;

function THGERect2.TextPoint(const z:THGERect;const X, Y: Single): Boolean;
begin
  with z do
  Result := (X >= X1) and (X < X2) and (Y >= Y1) and (Y < Y2);
end;

end.
