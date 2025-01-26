function SmallerRectSize(aRect: Trect; aFactor: single): Trect;
  //function is a WIP
var
  sSize: TSize;
  tlResult: Tpoint;
  ctrArect: Tpoint;
begin
  ctrArect := aRect.CenterPoint;
  sSize := aRect.Size;
  sSize.cx := longint(sSize.cx * aFactor);
  sSize.cy := longint(sSize.cy * aFactor);
  tlResult.x := ctrArect.x - (sSize.cx div 2);
  tlResult.y := ctrArect.y + (sSize.cy div 2);
  writeln(format('Center of reduced ( %d, %d )', [tlResult.x, tlResult.y]));
  //result.size:= sSize;
end;

{$MODE DELPHI}

//Program moveRectCenter;

//uses Types;

procedure moveRectCenter(var aRect: Trect; aNewCenter: Tpoint); inline;
var
  newX, newY: longint;
  newRect: Trect;
begin
  newX := aNewCenter.x - round((aRect.Width / 2));
  newY := aNewCenter.y - (round(arect.Height / 2));
  newRect.TopLeft := Point(newX, newY);
  newX := aNewCenter.x + round((aRect.Width / 2));
  newY := aNewCenter.y + (round(arect.Height / 2));
  newRect.BottomRight := point(newX, newY);
  aRect := newRect;
end;

procedure writeRect(const aR: Trect);
begin
  writeln('TL: ', aR.topLeft.x, ', ', aR.topLeft.y);
  writeln('BR: ', aR.BottomRight.x, ', ', aR.BottomRight.y);
  writeln('Height : ', aR.Height);
  writeln('Width: ', aR.Width);
  writeln('Center : ', aR.CenterPoint.x, ', ', aR.centerpoint.y);
end;
{
var
aRect : Trect;
aPoint : Tpoint;

Begin

aRect := bounds(0,0,30,30);
aPoint := point(50,50);
writeRect(aRect);
writeln();

moveRectCenter(aRect, aPoint);
writeln('Moved Rect :');
writeRect(aRect);

End.}
