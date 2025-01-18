cdfunction SmallerRectSize(aRect: Trect; aFactor: single): Trect;
  //function is a WIP
var
  sSize: TSize;
  //tlArect : Tpoint;
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

