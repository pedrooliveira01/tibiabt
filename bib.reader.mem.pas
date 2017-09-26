unit bib.reader.mem;

interface

uses
  Winapi.Windows,bib.vars;

type
  TReaderMem = class

    aHandler: Cardinal;
  public
    // hWND := Handle da janela que voce quer acessar a memoria...

    // Faz a leitura de um determinado endereço como Integer
    function ReadMemInteger(Address: Cardinal): Cardinal;

    // Faz a leitura de um determinado endereço como Byte
    function ReadMemByte(Address: Cardinal): Cardinal;

    // Faz a leitura de um determinado endereço como String
    function ReadMemString(addr, len: dword): string;

    // Faz a escrita de um determinado endereço como Integer
    procedure MWint(Address: Integer; buf: Integer; Length: dword);

    // Faz a escrita de um determinado endereço como String
    procedure MWStr(Address: Integer; buf: String; Length: dword);
    function GetBLPosition(PlayerID:integer): TBLPosition;
  end;

var aReader:TReaderMem;

const
BLStart = $626CD4; // Battlelist Start
Distchar = 160; // Distance between creatures in B.List
BlEnd = $632A94; // Battlelist end
DistX = $20;
DistY = $24;
DistZ = $28;
SelfID = $626C70; //8.22

implementation

{ TReaderMem }

//Faz a leitura de um determinado endereço como Integer
function TReaderMem.ReadMemInteger(Address: Cardinal): Cardinal;
var
ProcId: Cardinal;
tProc: THandle;
NBR: NativeUInt;
value:integer;
begin
    GetWindowThreadProcessId(aHandler, @ProcId);
    tProc := OpenProcess(PROCESS_ALL_ACCESS, False, ProcId);
    ReadProcessMemory(tProc, Pointer(Address), @value, 4, NBR);
    CloseHandle(tProc);
    Result:=value;
end;

//Faz a leitura de um determinado endereço como Byte
function TReaderMem.ReadMemByte(Address: Cardinal): Cardinal;
var
ProcId: Cardinal;
tProc: THandle;
NBR: NativeUInt;
value:byte;
begin
    GetWindowThreadProcessId(aHandler, @ProcId);
    tProc:= OpenProcess(PROCESS_ALL_ACCESS, False, ProcId);
    ReadProcessMemory(tProc, Ptr(Address), @value, 1, NBR);
    CloseHandle(tProc);
    Result:=value;
end;

//Faz a leitura de um determinado endereço como String
function TReaderMem.ReadMemString(addr, len : dword): string;
var
 str : string;
 dwread : NativeUInt;
 IDProc: Integer;
 hHandle: HWND;
begin
  GetWindowThreadProcessId(aHandler, @IdProc);
  hHandle := OpenProcess(PROCESS_VM_READ, False, IdProc);
  setlength(str, len);
  readprocessmemory(hHandle, pointer(addr), @str[1], len, dwread);
  result := str;
end;

//Faz a escrita de um determinado endereço como Integer
procedure TReaderMem.MWint(Address: Integer; buf: Integer; Length: DWORD);
var ProcID, THandle: Integer;
    e: NativeUInt;
begin
   GetWindowThreadProcessId(aHandler, @ProcID);
   THandle := OpenProcess(PROCESS_ALL_ACCESS, False, ProcID);
   WriteProcessMemory(THandle, Ptr(Address), @buf, Length, e);
   CloseHandle(THandle);
end;

//Faz a escrita de um determinado endereço como String
procedure TReaderMem.MWStr(Address: Integer; buf: String; Length: DWORD);
var ProcID: Integer;
    THandle: hWnd;
    e: NativeUInt;
begin
  GetWindowThreadProcessId(aHandler, @ProcID);
  THandle := OpenProcess(PROCESS_ALL_ACCESS, False, ProcID);
  WriteProcessMemory(THandle, Pointer(Address), PChar(buf), Length, e);
  CloseHandle(THandle);
end;

function TReaderMem.GetBLPosition(PlayerID:integer): TBLPosition;
var
BLPosition:integer;
Current,i:integer;
begin
  i:=0;
  Result.Position := -1;
  BLPosition := BLStart;
  Current := ReadMemInteger(blposition-4);
  while (Current <> PlayerID) do
  begin
    inc(i);
    BLPosition := BLPosition+Distchar;
    Current := ReadMemInteger(blposition-4);
    if BLPosition >= BLEnd+BlEnd then
       exit;
  end;
  Result.N:=i;
  Result.Position:= BLPosition;
  Result.X:=ReadMemInteger(BlPosition+DistX);
  Result.Y:=ReadMemInteger(BlPosition+DistY);
  Result.Z:=ReadMemInteger(BlPosition+DistZ);
end;

end.
