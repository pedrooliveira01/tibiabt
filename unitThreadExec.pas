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
    FACOES: TObjectList<TACOES>;
    FTerminar: Boolean;
    FPausar : Boolean;
{ Private declarations }
  protected
    procedure Execute; override;
    procedure ExecutarConfiguracoesPlayerStatus;
  public
    constructor Create(aHandle:DWORD);
    Destructor Destroy;override;
    Procedure SendHotKey(Value:Integer; aShift:Boolean=false;aCtrl:Boolean=false);overload;
    procedure AddAcao(aNome:String;aHotkey:Integer;aShift,aCtrl:Boolean;aVerificaPor:TVerificaPor;aVerificaTipo:TVerificaTipo;aVarificaSinal:TVerificaSinal;aVerificador,aExausted:Integer;aEdit:Integer=-1);
    procedure AddAcao2(Value:TAcoes);
    procedure DeleteAcao(aIndex:Integer);
    property ACOES: TObjectList<TACOES> read FACOES write FACOES;
    property Terminar: Boolean read FTerminar write FTerminar;
    property Pausar: Boolean read FPausar write FPausar;
    property PlayerConfig: TPlayerConfig read FPlayerConfig write FPlayerConfig;

  end;

var aThreadExec : TTibiaExec;

implementation

uses
  System.SysUtils, unitThread, Winapi.Messages, Inputer;

procedure TTibiaExec.AddAcao(aNome: String; aHotkey: Integer; aShift,aCtrl: Boolean; aVerificaPor: TVerificaPor;
  aVerificaTipo: TVerificaTipo;aVarificaSinal:TVerificaSinal; aVerificador,aExausted: Integer;aEdit:Integer);
var Value:TAcoes;
begin
  if aEdit>-1 then
     Value      := ACOES.Items[aEdit]
  else
  Begin
     Value      := TAcoes.Create;
     Value.Nome := aNome;
  End;

  if Assigned(Value) then
  Begin
    Value.Hotkey        := aHotkey;
    Value.Shift         := aShift;
    Value.Ctrl          := aCTRL;
    Value.VerificaPOR   := aVerificaPor;
    Value.VerificaTIPO  := aVerificaTipo;
    Value.VerificaSinal := aVarificaSinal;
    Value.Verificador   := aVerificador;
    Value.TempoUlt      := now;
    Value.Exausted      := aExausted;
  End;

  if aEdit=-1 then
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
  FACOES := TObjectList<TACOES>.Create;
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
                vpTempo:Begin
                           aExecuta := secondsbetween(now,Value.TempoUlt)>=Value.Verificador;
                           if aExecuta then
                              Value.TempoUlt := now;
                        End;
                vpSoul: case Value.VerificaSinal of
                            vsMaior: aExecuta := ((aThread.Player.SOULPOINT * 100) / 250)>=Value.Verificador;
                            vsMenor: aExecuta := ((aThread.Player.SOULPOINT * 100) / 250)<=Value.Verificador;
                        end;
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
                vpTempo:Begin
                           aExecuta := secondsbetween(now,Value.TempoUlt)>=Value.Verificador;
                           if aExecuta then
                              Value.TempoUlt := now;
                        End;
                vpSoul: case Value.VerificaSinal of
                            vsMaior: aExecuta := aThread.Player.SOULPOINT >= Value.Verificador;
                            vsMenor: aExecuta := aThread.Player.SOULPOINT <= Value.Verificador;
                        end;
              end;
            End;
          end;

          if aExecuta then
          Begin
             if Value.Nome[1] = '#' then
             Begin
                SendString(FHandler,copy(Value.Nome,2,length(Value.Nome)));
                SendKeyDown(FHandler,VK_RETURN);
                SendKeyUp(FHandler,VK_RETURN);
             end
             else
                SendHotKey(Integer(Value.Hotkey),Value.Shift,Value.Ctrl);

             sleep(Value.Exausted);
          End
          else sleep(50);

       End;
    End;
  End;

end;

procedure TTibiaExec.SendHotKey(Value: Integer; aShift,aCtrl:Boolean);
begin
  try
    if aShift then
       SendKeyDown(FHandler,VK_SHIFT);

    if aCtrl then
       SendKeyDown(FHandler,VK_CONTROL);

    SendKeyDown(FHandler, Value);

    if aShift then
       SendKeyUp(FHandler,VK_SHIFT);

    if aCtrl then
       SendKeyUp(FHandler,VK_CONTROL);

    SendKeyUp(FHandler, Value);
  finally
  end;
end;

procedure TTibiaExec.ExecutarConfiguracoesPlayerStatus;
var aExecuta:Boolean;
begin
  if PlayerConfig.AutoCure then
  Begin
     if aThread.PlayerStatus.Poison then
     Begin
        SendHotKey(PlayerConfig.HotkeyCure);
        sleep(1000);
     End;
  end;
  if PlayerConfig.AutoManaShield then
  Begin
     if not aThread.PlayerStatus.Manashield then
     Begin
        SendHotKey(PlayerConfig.HotkeyManashield);
        sleep(1000);
     End;
  end;
  if PlayerConfig.AutoAntiParalize then
  Begin
     if aThread.PlayerStatus.Paralyse then
     Begin
        SendHotKey(PlayerConfig.HotkeyAntiParalize);
        sleep(1000);
     End;
  end;
  if PlayerConfig.AutoHaste then
  Begin
     if not aThread.PlayerStatus.Hast then
     Begin
        SendHotKey(PlayerConfig.HotkeyCure);
        sleep(1000);
     End;
  End;
  if PlayerConfig.AutoSoulFull then
  Begin
     if aThread.Player.SOULPOINT=250 then
     Begin
        SendHotKey(PlayerConfig.HotkeySoulfull);
        sleep(1000);
     End;
  End;
  if PlayerConfig.AutoWalk1.Ativo then
  Begin
     aExecuta := MilliSecondsBetween(now,PlayerConfig.AutoWalk1.TempoUlt)>=PlayerConfig.AutoWalk1.Pause;
     if aExecuta then
     Begin
        FPlayerConfig.AutoWalk1.TempoUlt := now;
        if FPlayerConfig.AutoWalk1.Ultimo=dUp then
        Begin
           FPlayerConfig.AutoWalk1.Ultimo:=dDown;
           SendHotKey(VK_DOWN);
        end
        else
        Begin
           FPlayerConfig.AutoWalk1.Ultimo:=dUp;
           SendHotKey(VK_UP);
        End;
     End;
  End;
  if PlayerConfig.AutoWalk2.Ativo then
  Begin
     aExecuta := MilliSecondsBetween(now,PlayerConfig.AutoWalk2.TempoUlt)>=PlayerConfig.AutoWalk2.Pause;
     if aExecuta then
     Begin
        FPlayerConfig.AutoWalk2.TempoUlt := now;
        if FPlayerConfig.AutoWalk2.Ultimo=dLeft then
        Begin
           FPlayerConfig.AutoWalk2.Ultimo:=dRight;
           SendHotKey(VK_RIGHT);
        end
        else
        Begin
           FPlayerConfig.AutoWalk2.Ultimo:=dLeft;
           SendHotKey(VK_LEFT);
        End;
     End;
  End;
end;


end.

