unit Inputer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

    procedure SendKeyDown(FHandler : HWND;Key: Integer);
    procedure SendKeyUp(FHandler : HWND;Key: Integer);

    procedure SendKey(FHandler : HWND;Key: Integer);

    procedure SendKeyChar(FHandler : HWND;Key: Integer);

    procedure SendClick(FHandler : HWND;X, Y: Integer);
    procedure SendClickPoint(FHandler : HWND;Point: TPoint);

    procedure SendRClick(FHandler : HWND;X, Y: Integer);
    procedure SendRClickPoint(FHandler : HWND;Point: TPoint);

    procedure SendScrollUp(FHandler : HWND;X, Y: Integer);

    procedure SendDrag(FHandler : HWND;BaseX, BaseY, TargetX, TargetY: Integer);
    procedure SendDragPoint(FHandler : HWND;BasePoint, TargetPoint: TPoint);

    procedure SendString(FHandler : HWND;Data: String);

    procedure setCursorClient( FHandler:HWND;x,y: integer );


implementation


procedure SendKeyDown(FHandler : HWND;Key: Integer);
begin
  PostMessage( FHandler, WM_KEYDOWN, Key, 0 );
end;

procedure SendKeyUp(FHandler : HWND;Key: Integer);
begin
  PostMessage( FHandler, WM_KEYUP, Key, 0 );
end;

procedure SendKey(FHandler : HWND;Key: Integer);
begin
  PostMessage( FHandler, WM_KEYDOWN, Key, 0 );
end;

procedure SendKeyChar(FHandler : HWND;Key: Integer);
begin
  PostMessage( FHandler, WM_CHAR, Key, 0 );
end;

procedure SendClick(FHandler : HWND;X, Y: Integer);
begin
  PostMessage( FHandler, WM_LBUTTONUP, 0, MakeLParam(0, 0) );

  PostMessage( FHandler, WM_LBUTTONDOWN, 0, MakeLParam(X, Y) );
  //sleep(50);
  PostMessage( FHandler, WM_LBUTTONUP, 0, MakeLParam(X, Y) );
end;

procedure SendClickPoint(FHandler : HWND;Point: TPoint);
begin

  //  if FHandler.WindowState then


  PostMessage( FHandler, WM_LBUTTONUP, 0, MakeLParam(0, 0) );

  //SetCursorClient(point.X,point.Y);
  PostMessage( FHandler, WM_LBUTTONDOWN, 0, MakeLParam(Point.X, Point.Y) );
  //sleep(50);
  PostMessage( FHandler, WM_LBUTTONUP, 0, MakeLParam(Point.X, Point.Y) );
end;

procedure SendRClick(FHandler : HWND;X, Y: Integer);
begin
  PostMessage( FHandler, WM_RBUTTONUP, 0, MakeLParam(0, 0) );

  PostMessage( FHandler, WM_RBUTTONDOWN, 0, MakeLParam(X, Y) );
  //sleep(50);
  PostMessage( FHandler, WM_RBUTTONUP, 0, MakeLParam(X, Y) );
end;

procedure SendRClickPoint(FHandler : HWND;Point: TPoint);
begin
  PostMessage( FHandler, WM_RBUTTONUP, 0, MakeLParam(0, 0) );

  PostMessage( FHandler, WM_RBUTTONDOWN, 0, MakeLParam(Point.X, Point.Y) );
  //sleep(50);
  PostMessage( FHandler, WM_RBUTTONUP, 0, MakeLParam(Point.X, Point.Y) );
end;

procedure SendScrollUp(FHandler : HWND;X, Y: Integer);
begin
  SetCursorClient(FHandler, x,y);
 // WM_MOUSEHOVER
  PostMessage( FHandler, WM_MOUSEHOVER, 0, MakeLParam(X, Y) );
  PostMessage( FHandler, WM_MOUSEMOVE, 0, MakeLParam(x, y) );
  PostMessage( FHandler, WM_MOUSEWHEEL, WHEEL_DELTA, MakeLParam(X, Y) );
end;

procedure SendString(FHandler : HWND;Data: String);
var
  I: Integer;
begin
  for I := 0 to Length(Data) do
  begin
    SendKeyChar(FHandler,Integer(Data[I]));
    sleep(1);
  end;
end;

procedure SendDrag(FHandler : HWND;BaseX, BaseY, TargetX, TargetY: Integer);
begin
  PostMessage( FHandler, WM_LBUTTONUP, 0, MakeLParam(0, 0) );

  PostMessage( FHandler, WM_LBUTTONDOWN, 0, MakeLParam(BaseX, BaseY) );
  //sleep(200);
  PostMessage( FHandler, WM_MOUSEMOVE, 0, MakeLParam(BaseX, BaseY) );
  //sleep(200);
  PostMessage( FHandler, WM_MOUSEMOVE, 0, MakeLParam(TargetX, TargetY) );
  //sleep(200);
  PostMessage( FHandler, WM_LBUTTONUP, 0, MakeLParam(TargetX, TargetY) );
  //sleep(200);
end;

procedure SendDragPoint(FHandler : HWND;BasePoint, TargetPoint: TPoint);
begin
  PostMessage( FHandler, WM_LBUTTONUP, 0, MakeLParam(0, 0) );

  PostMessage( FHandler, WM_LBUTTONDOWN, 0, MakeLParam(BasePoint.X, BasePoint.Y) );
  //sleep(200);
  PostMessage( FHandler, WM_MOUSEMOVE, 0, MakeLParam(BasePoint.X, BasePoint.Y) );
  //sleep(200);
  PostMessage( FHandler, WM_MOUSEMOVE, 0, MakeLParam(TargetPoint.X, TargetPoint.Y) );
  //sleep(200);
  PostMessage( FHandler, WM_LBUTTONUP, 0, MakeLParam(TargetPoint.X, TargetPoint.Y) );
  //sleep(200);
end;


procedure setCursorClient( FHandler:HWND;x,y: integer );
var
  p: Tpoint;
begin
  p.X := x;
  p.y := y;
  Windows.ClientToScreen( FHandler, p );
  SetCursorPos(abs(p.x), abs(p.y));
end;

end.
