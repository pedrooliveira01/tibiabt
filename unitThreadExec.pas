unit unitThreadExec;

interface

uses
  System.Classes, bib.vars, System.Generics.Collections,System.DateUtils,
  Winapi.Windows;

type
  TTibiaExec = class(TThread)
    FPlayerConfig : TPlayerConfig;
    FHandler : HWND;
  private
    FACOES: TList<TACOES>;
    FTerminar: Boolean;
    FPausar : Boolean;
{ Private declarations }
  protected
    procedure Execute; override;
    procedure ExecutarConfiguracoesPlayerStatus;
  public
    constructor Create(aHandle:DWORD);
    Destructor Destroy;override;
    Procedure SendMensagem(Value:Integer; aShift:Boolean=false;aCtrl:Boolean=false);overload;
    procedure AddAcao(aNome:String;aHotkey:Integer;aShift,aCtrl:Boolean;aVerificaPor:TVerificaPor;aVerificaTipo:TVerificaTipo;aVarificaSinal:TVerificaSinal;aVerificador,aExausted:Integer);
    procedure AddAcao2(Value:TAcoes);
    procedure DeleteAcao(aIndex:Integer);
    property ACOES: TList<TACOES> read FACOES write FACOES;
    property Terminar: Boolean read FTerminar write FTerminar;
    property Pausar: Boolean read FPausar write FPausar;
    property PlayerConfig: TPlayerConfig read FPlayerConfig write FPlayerConfig;

  end;

var aThreadExec : TTibiaExec;

implementation

uses
  System.SysUtils, unitThread, unitPrincipal, Winapi.Messages;

procedure TTibiaExec.AddAcao(aNome: String; aHotkey: Integer; aShift,aCtrl: Boolean; aVerificaPor: TVerificaPor;
  aVerificaTipo: TVerificaTipo;aVarificaSinal:TVerificaSinal; aVerificador,aExausted: Integer);
var Value:TAcoes;
begin
  Value.Nome          := aNome;
  Value.Hotkey        := aHotkey;
  Value.Shift         := aShift;
  Value.Ctrl          := aCTRL;
  Value.VerificaPOR   := aVerificaPor;
  Value.VerificaTIPO  := aVerificaTipo;
  Value.VerificaSinal := aVarificaSinal;
  Value.Verificador   := aVerificador;
  Value.TempoUlt      := now;
  Value.Exausted      := aExausted;
  FACOES.Add(Value);
end;

procedure TTibiaExec.AddAcao2(Value: TAcoes);
begin
  FACOES.Add(Value);
end;

constructor TTibiaExec.Create(aHandle:DWORD);
begin
  inherited Create(True);

  FPausar := True;
  FTerminar := False;
  FACOES := TList<TACOES>.Create;
  FHandler := aHandle;

end;

procedure TTibiaExec.DeleteAcao(aIndex: Integer);
begin
  FACOES.Delete(aIndex);
  FAcoes.TrimExcess;
end;

destructor TTibiaExec.Destroy;
begin
  FACOES.Free;
  inherited;
end;

procedure TTibiaExec.Execute;
var Value:TAcoes;
    aExecuta : Boolean;
    aPlayer : TPlayer;
begin

  while not FTerminar do
  Begin
    // Controle de pause ou terminar
    while FPausar and (not FTerminar) do
       sleep(100);
    if Assigned(ACOES) then
    Begin
        if not (FAcoes.Count>0) then
            ExecutarConfiguracoesPlayerStatus;
       // Varre as acoes definida pelo usuario
       for Value in FACOES do
       Begin
          if FPausar or FTerminar then
             break;

          ExecutarConfiguracoesPlayerStatus;

          aExecuta := False;

          case Value.VerificaTIPO of
            vtPerc:
            Begin
              case Value.VerificaPOR of
                vpMana: case Value.VerificaSinal of
                          vsMaior: aExecuta := ((aThread.Player.MANA * 100) / aThread.Player.MANA_MAX)>=Value.Verificador;
                          vsMenor: aExecuta := ((aThread.Player.MANA * 100) / aThread.Player.MANA_MAX)<=Value.Verificador;
                        end;
                  vpHP: case Value.VerificaSinal of
                            vsMaior: aExecuta := ((aThread.Player.HP * 100) / aThread.Player.HP_MAX)>=Value.Verificador;
                            vsMenor: aExecuta := ((aThread.Player.HP * 100) / aThread.Player.HP_MAX)<=Value.Verificador;
                        end;
                vpTempo: aExecuta := secondsbetween(now,Value.TempoUlt)>=Value.Verificador;
              end;
            End;
            vtValor:
            Begin
              case Value.VerificaPOR of
                vpMana: case Value.VerificaSinal of
                          vsMaior: aExecuta := aThread.Player.MANA >=Value.Verificador;
                          vsMenor: aExecuta := aThread.Player.MANA <=Value.Verificador;
                        end;
                  vpHP: case Value.VerificaSinal of
                            vsMaior: aExecuta := aThread.Player.HP >=Value.Verificador;
                            vsMenor: aExecuta := aThread.Player.HP <=Value.Verificador;
                        end;
                vpTempo: aExecuta := secondsbetween(now,Value.TempoUlt)>=Value.Verificador;
              end;
            End;
          end;

          if aExecuta then
          Begin
             SendMensagem(Integer(Value.Hotkey),Value.Shift,Value.Ctrl);
             sleep(Value.Exausted);
          End
          else sleep(50);

       End;
    End;
  End;

end;

procedure TTibiaExec.SendMensagem(Value: Integer; aShift,aCtrl:Boolean);
begin
  try
    if aShift then
       SendMessage(FHandler, WM_KEYDOWN, VK_SHIFT, 0);

    if aCtrl then
       SendMessage(FHandler, WM_KEYDOWN, VK_CONTROL, 0);

    SendMessage(FHandler, WM_KEYDOWN, Value, 0);

    if aShift then
       SendMessage(FHandler, WM_KEYUP, VK_SHIFT, 0);

    if aCtrl then
       SendMessage(FHandler, WM_KEYUP, VK_CONTROL, 0);

    SendMessage(FHandler, WM_KEYUP, Value, 0);
  finally
  end;
end;

procedure TTibiaExec.ExecutarConfiguracoesPlayerStatus;
begin
  if PlayerConfig.AutoCure then
  Begin
     if aThread.PlayerStatus.Poison then
     Begin
        SendMensagem(PlayerConfig.HotkeyCure);
        sleep(1000);
     End;
  end;
  if PlayerConfig.AutoManaShield then
  Begin
     if not aThread.PlayerStatus.Manashield then
     Begin
        SendMensagem(PlayerConfig.HotkeyManashield);
        sleep(1000);
     End;
  end;
  if PlayerConfig.AutoAntiParalize then
  Begin
     if aThread.PlayerStatus.Paralyse then
     Begin
        SendMensagem(PlayerConfig.HotkeyAntiParalize);
        sleep(1000);
     End;
  end;
  if PlayerConfig.AutoHaste then
  Begin
     if not aThread.PlayerStatus.Hast then
     Begin
        SendMensagem(PlayerConfig.HotkeyCure);
        sleep(1000);
     End;
  End;
end;

{procedure TTibiaExec.SendMensagem(Value: String);
var
  letra: Integer;
  B: Byte;
begin

  try
    for letra := 1 to Length(Value) do
    begin
      B := Byte(Value[letra]);
      SendMessage(FHandler, WM_CHAR, B, 0);
    end;
    SendMessage(FHandler, WM_CHAR, 13, 0);
  finally
  end;

end;  }

end.

