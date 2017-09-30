unit unitThread;

interface

uses
  System.Classes, System.Generics.Collections, Winapi.Windows, bib.vars;


type
  TTibiaAddress = class(TThread)
  FHandler : HWND;
  private
    FTerminar: Boolean;
    FPlayerAddress: TDictionary<String,TAddress>;
    FPID : DWORD;
    FPlayer: TPlayer;
    FPlayerStatus : TPlayerStatus;
    FPausar: Boolean;
    { Private declarations }
  protected
    procedure Execute; override;
    procedure AddAddress(aNome:String;aCodigo,aValor:Integer);
    Function ReadAddress(Value:TAddress):String;
    procedure AtualizaVars;
    procedure GetPlayerStatus;
  public
    constructor Create(aHandle:DWORD);
    Destructor Destroy;override;

    property Terminar: Boolean read FTerminar write FTerminar;
    property Pausar: Boolean read FPausar write FPausar;
    property PlayerAddress: TDictionary<String,TAddress> read FPlayerAddress write FPlayerAddress;
    property Player: TPlayer read FPlayer write FPlayer;
    property PlayerStatus: TPlayerStatus read FPlayerStatus write FPlayerStatus;
  end;

var aThread : TTibiaAddress;

implementation

uses
  System.SysUtils, Winapi.Messages;

{ TTibiaAddress }

procedure TTibiaAddress.AddAddress(aNome:String;aCodigo,aValor:Integer);
var aValue:TAddress;
begin
  aValue.Nome := aNome;
  aValue.Valor := aValor.ToString;
  aValue.Codigo := aCodigo;
  FPlayerAddress.Add(aNome,aValue);
end;

procedure TTibiaAddress.AtualizaVars;
   function RetornaValue(aNome:String):Integer;
   var aValue:TAddress;
   Begin
      FPlayerAddress.TryGetValue(aNome,aValue);
      result := aValue.Valor.ToInteger;
   End;
begin
  FPlayer.STATUS               :=  RetornaValue('PLAYER_STATUS');
//  FPlayer.FIST_PERC            :=  RetornaValue('PLAYER_FIST_PERC');
//  FPlayer.CLUB_PERC            :=  RetornaValue('PLAYER_CLUB_PERC');
//  FPlayer.SWORD_PERC           :=  RetornaValue('PLAYER_SWORD_PERC');
//  FPlayer.AXE_PERC             :=  RetornaValue('PLAYER_AXE_PERC');
//  FPlayer.DISTANCE_PERC        :=  RetornaValue('PLAYER_DISTANCE_PERC');
//  FPlayer.SHIELDING_PERC       :=  RetornaValue('PLAYER_SHIELDING_PERC');
//  FPlayer.FISHING_PERC         :=  RetornaValue('PLAYER_FISHING_PERC');
//  FPlayer.FIST                 :=  RetornaValue('PLAYER_FIST');
//  FPlayer.CLUB                 :=  RetornaValue('PLAYER_CLUB');
//  FPlayer.SWORD                :=  RetornaValue('PLAYER_SWORD');
//  FPlayer.AXE                  :=  RetornaValue('PLAYER_AXE');
//  FPlayer.DISTANCE             :=  RetornaValue('PLAYER_DISTANCE');
//  FPlayer.SHIELDING            :=  RetornaValue('PLAYER_SHIELDING');
//  FPlayer.FISHING              :=  RetornaValue('PLAYER_FISHING');
    FPlayer.CAP                  :=  RetornaValue('PLAYER_CAP');
    FPlayer.STAMINIA             :=  RetornaValue('PLAYER_STAMINIA');
    FPlayer.SOULPOINT            :=  RetornaValue('PLAYER_SOULPOINT');
    FPlayer.MANA_MAX             :=  RetornaValue('PLAYER_MANA_MAX');
    FPlayer.MANA                 :=  RetornaValue('PLAYER_MANA');
//  FPlayer.MAGIC_LEVEL_PERC     :=  RetornaValue('PLAYER_MAGIC_LEVEL_PERC');
//  FPlayer.LEVEL_PERC           :=  RetornaValue('PLAYER_LEVEL_PERC');
//  FPlayer.MAGIC_LEVEL          :=  RetornaValue('PLAYER_MAGIC_LEVEL');
    FPlayer.LEVEL                :=  RetornaValue('PLAYER_LEVEL');
//  FPlayer.EXP                  :=  RetornaValue('PLAYER_EXP');
    FPlayer.HP_MAX               :=  RetornaValue('PLAYER_HP_MAX');
    FPlayer.HP                   :=  RetornaValue('PLAYER_HP');
    FPlayer.ID                   :=  RetornaValue('PLAYER_ID');
//  FPlayer.GOTOZ                :=  RetornaValue('PLAYER_GOTOZ');
//  FPlayer.GOTOY                :=  RetornaValue('PLAYER_GOTOY');
//  FPlayer.GOTOX                :=  RetornaValue('PLAYER_GOTOX');
//  FPlayer.HEAD_SLOT            :=  RetornaValue('PLAYER_HEAD_SLOT');
//  FPlayer.NECK_SLOT            :=  RetornaValue('PLAYER_NECK_SLOT');
//  FPlayer.CONTAINER_SLOT       :=  RetornaValue('PLAYER_CONTAINER_SLOT');
//  FPlayer.BODY_SLOT            :=  RetornaValue('PLAYER_BODY_SLOT');
//  FPlayer.LEFT_HAND_SLOT       :=  RetornaValue('PLAYER_LEFT_HAND_SLOT');
//  FPlayer.LEFT_HAND_SLOTCOUNT  :=  RetornaValue('PLAYER_LEFT_HAND_SLOTCOUNT');
//  FPlayer.RIGHT_HAND_SLOT      :=  RetornaValue('PLAYER_RIGHT_HAND_SLOT');
//  FPlayer.RIGHT_HAND_SLOTCOUNT :=  RetornaValue('PLAYER_RIGHT_HAND_SLOTCOUNT');
//  FPlayer.LEGS_SLOT            :=  RetornaValue('PLAYER_LEGS_SLOT');
//  FPlayer.FEET_SLOT            :=  RetornaValue('PLAYER_FEET_SLOT');
//  FPlayer.RING_SLOT            :=  RetornaValue('PLAYER_RING_SLOT');
//  FPlayer.ARROW_SLOT           :=  RetornaValue('PLAYER_ARROW_SLOT');
//  FPlayer.ARROW_SLOTCOUNT      :=  RetornaValue('PLAYER_ARROW_SLOTCOUNT');
//  FPlayer.Z                    :=  RetornaValue('PLAYER_Z');
//  FPlayer.Y                    :=  RetornaValue('PLAYER_Y');
//  FPlayer.X                    :=  RetornaValue('PLAYER_X');
    FPlayer.CONNECT_STATUS       :=  RetornaValue('PLAYER_CONNECT_STATUS');

    GetPlayerStatus;
end;

constructor TTibiaAddress.Create(aHandle:DWORD);
begin
  inherited Create(True);
  FPlayerAddress  := TDictionary<String,TAddress>.Create;
  FTerminar := False;
  FPausar   := True;
  FHandler := aHandle;
  GetWindowThreadProcessId(FHandler,@fPId);

  AddAddress('PLAYER_STATUS'                ,$00605958,0); //< 1 = Poison; 2 = Fire; 4 = Energy; 8 = Drunk; 16 = Manashield; 32 = Paralysis; 64 = Haste; 128 = Battle; 256 = Underwater >
// AddAddress('PLAYER_FIST_PERC'             ,$0060595C,0);
// AddAddress('PLAYER_CLUB_PERC'             ,$00605960,0);
// AddAddress('PLAYER_SWORD_PERC'            ,$00605964,0);
// AddAddress('PLAYER_AXE_PERC'              ,$00605968,0);
// AddAddress('PLAYER_DISTANCE_PERC'         ,$0060596C,0);
// AddAddress('PLAYER_SHIELDING_PERC'        ,$00605970,0);
// AddAddress('PLAYER_FISHING_PERC'          ,$00605974,0);
// AddAddress('PLAYER_FIST'                  ,$00605978,0);
// AddAddress('PLAYER_CLUB'                  ,$0060597C,0);
// AddAddress('PLAYER_SWORD'                 ,$00605980,0);
// AddAddress('PLAYER_AXE'                   ,$00605984,0);
// AddAddress('PLAYER_DISTANCE'              ,$00605988,0);
// AddAddress('PLAYER_SHIELDING'             ,$0060598C,0);
// AddAddress('PLAYER_FISHING'               ,$00605990,0);
  AddAddress('PLAYER_CAP'                   ,$006059A0,0);
  AddAddress('PLAYER_STAMINIA'              ,$006059A4,0);
  AddAddress('PLAYER_SOULPOINT'             ,$006059A8,0);
  AddAddress('PLAYER_MANA_MAX'              ,$006059AC,0);
  AddAddress('PLAYER_MANA'                  ,$006059B0,0);
// AddAddress('PLAYER_MAGIC_LEVEL_PERC'      ,$006059B4,0);
// AddAddress('PLAYER_LEVEL_PERC'            ,$006059B8,0);
// AddAddress('PLAYER_MAGIC_LEVEL'           ,$006059BC,0);
  AddAddress('PLAYER_LEVEL'                 ,$006059C0,0);
// AddAddress('PLAYER_EXP'                   ,$006059C4,0);
  AddAddress('PLAYER_HP_MAX'                ,$006059C8,0);
  AddAddress('PLAYER_HP'                    ,$006059CC,0);
  AddAddress('PLAYER_ID'                    ,$006059D0,0);
// AddAddress('PLAYER_GOTOZ'                 ,$00605A0C,0);//  < To start walking you need to write 1 to your battlelist pos + WALKING distance >
// AddAddress('PLAYER_GOTOY'                 ,$00605A10,0);//  < To start walking you need to write 1 to your battlelist pos + WALKING distance >
// AddAddress('PLAYER_GOTOX'                 ,$00605A14,0);///  < To start walking you need to write 1 to your battlelist pos + WALKING distance >
// AddAddress('PLAYER_HEAD_SLOT'             ,$0060E290,0);
// AddAddress('PLAYER_NECK_SLOT'             ,$0060E2A4,0);
// AddAddress('PLAYER_CONTAINER_SLOT'        ,$0060E2B0,0);
// AddAddress('PLAYER_BODY_SLOT'             ,$0060E2BC,0);
// AddAddress('PLAYER_LEFT_HAND_SLOT'        ,$0060E2C8,0);
// AddAddress('PLAYER_LEFT_HAND_SLOTCOUNT'   ,$0060E2CC,0);
// AddAddress('PLAYER_RIGHT_HAND_SLOT'       ,$0060E2D4,0);
// AddAddress('PLAYER_RIGHT_HAND_SLOTCOUNT'  ,$0060E2D8,0);
// AddAddress('PLAYER_LEGS_SLOT'             ,$0060E2E0,0);
// AddAddress('PLAYER_FEET_SLOT'             ,$0060E2EC,0);
// AddAddress('PLAYER_RING_SLOT'             ,$0060E2F8,0);
// AddAddress('PLAYER_ARROW_SLOT'            ,$0060E304,0);
// AddAddress('PLAYER_ARROW_SLOTCOUNT'       ,$0060E308,0);
// AddAddress('PLAYER_Z'                     ,$00610C20,0);
// AddAddress('PLAYER_Y'                     ,$00610C24,0);
// AddAddress('PLAYER_X'                     ,$00610C28,0);
  AddAddress('PLAYER_CONNECT_STATUS'        ,$0075D3E0,0);// < 0 = Not connected; 4 = Connecting; 8 = Connected >
end;

destructor TTibiaAddress.Destroy;
begin
  FPlayerAddress.Free;
  inherited;
end;

procedure TTibiaAddress.Execute;
var
  Value,aNewValue: TAddress;
begin
  while not FTerminar do
  Begin
    while FPausar and (not FTerminar) do
       sleep(100);
    for Value in FPlayerAddress.Values  do
    Begin
      if FPausar or FTerminar then
         break;
      aNewValue       := Value;
      aNewValue.Valor := ReadAddress(Value);
      FPlayerAddress.AddOrSetValue(aNewValue.Nome,aNewValue);
      sleep(20);
    End;
    AtualizaVars;
  End;
end;

procedure TTibiaAddress.GetPlayerStatus;
  procedure ValidaStatus(var aStatus:Boolean;var aValue:Integer; aParametro:Integer);
  Begin
    if aValue>=aParametro then
    Begin
      aValue := aValue - aParametro;
      aStatus := True;
    End
    else aStatus := False;
  end;
var aValue : Integer;
begin
//1 = Poison; 2 = Fire; 4 = Energy; 8 = Drunk; 16 = Manashield; 32 = Paralysis; 64 = Haste; 128 = Battle; 256 = Underwater >
  aValue := aThread.Player.STATUS;

  ValidaStatus(FPlayerStatus.Underwater,aValue,256);
  ValidaStatus(FPlayerStatus.Battle    ,aValue,128);
  ValidaStatus(FPlayerStatus.Hast      ,aValue,64);
  ValidaStatus(FPlayerStatus.Paralyse  ,aValue,32);
  ValidaStatus(FPlayerStatus.Manashield,aValue,16);
  ValidaStatus(FPlayerStatus.Drunk     ,aValue,8);
  ValidaStatus(FPlayerStatus.Energy    ,aValue,4);
  ValidaStatus(FPlayerStatus.Fire      ,aValue,2);
  ValidaStatus(FPlayerStatus.Poison    ,aValue,1);
end;

function TTibiaAddress.ReadAddress(Value: TAddress):String;
var WinHandle : THandle;  {* variaveis para encontrar a janela *}
    ASize: Integer;
    read: NativeUInt;
    h: DWORD;
begin
  WinHandle  := OpenProcess(PROCESS_ALL_ACCESS, FALSE, FPID);
  Result     := '0';
 if WinHandle <> 0 then
  begin
    h := 0;
    read := 0;
    ASize := 4;

    ReadProcessMemory(WinHandle, Pointer(Value.Codigo), @h, ASize, read);

    Result     := IntToStr(h);
  end;
  CloseHandle(WinHandle);
end;



end.
