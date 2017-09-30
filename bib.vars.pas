unit bib.vars;

interface

type TVerificaPor = (vpMana,vpHP,vpTempo);
type TVerificaTipo = (vtPerc,vtValor);
type TVerificaSinal = (vsMenor,vsMaior);


Type TAddress = record
     Valor  : String;
     Codigo : Integer;
     Nome   : String;
end;

Type TPlayer = record
     STATUS              :Integer;
     FIST_PERC           :Integer;
     CLUB_PERC           :Integer;
     SWORD_PERC          :Integer;
     AXE_PERC            :Integer;
     DISTANCE_PERC       :Integer;
     SHIELDING_PERC      :Integer;
     FISHING_PERC        :Integer;
     FIST                :Integer;
     CLUB                :Integer;
     SWORD               :Integer;
     AXE                 :Integer;
     DISTANCE            :Integer;
     SHIELDING           :Integer;
     FISHING             :Integer;
     CAP                 :Integer;
     STAMINIA            :Integer;
     SOULPOINT           :Integer;
     MANA_MAX            :Integer;
     MANA                :Integer;
     MAGIC_LEVEL_PERC    :Integer;
     LEVEL_PERC          :Integer;
     MAGIC_LEVEL         :Integer;
     LEVEL               :Integer;
     EXP                 :Integer;
     HP_MAX              :Integer;
     HP                  :Integer;
     ID                  :Integer;
     GOTOZ               :Integer;
     GOTOY               :Integer;
     GOTOX               :Integer;
     HEAD_SLOT           :Integer;
     NECK_SLOT           :Integer;
     CONTAINER_SLOT      :Integer;
     BODY_SLOT           :Integer;
     LEFT_HAND_SLOT      :Integer;
     LEFT_HAND_SLOTCOUNT :Integer;
     RIGHT_HAND_SLOT     :Integer;
     RIGHT_HAND_SLOTCOUNT:Integer;
     LEGS_SLOT           :Integer;
     FEET_SLOT           :Integer;
     RING_SLOT           :Integer;
     ARROW_SLOT          :Integer;
     ARROW_SLOTCOUNT     :Integer;
     Z                   :Integer;
     Y                   :Integer;
     X                   :Integer;
     CONNECT_STATUS      :Integer;
end;

type TPlayerStatus = record
  //1 = Poison; 2 = Fire; 4 = Energy; 8 = Drunk; 16 = Manashield; 32 = Paralysis; 64 = Haste; 128 = Battle; 256 = Underwater >
    Poison     : Boolean;
    Fire       : Boolean;
    Energy     : Boolean;
    Drunk      : Boolean;
    Manashield : Boolean;
    Paralyse   : Boolean;
    Hast       : Boolean;
    Battle     : Boolean;
    Underwater : Boolean;
end;


type TAcoes = class
     Nome : String;
     Hotkey : Integer;
     Shift : Boolean;
     Ctrl  : Boolean;
     VerificaPOR: TVerificaPor;
     VerificaTIPO : TVerificaTipo;
     VerificaSinal : TVerificaSinal;
     Verificador : Integer;
     TempoUlt : TDatetime;
     Exausted : Integer;
end;

type TPlayerConfig = record
     AutoCure : Boolean;
     HotkeyCure : Integer;
     AutoManaShield : Boolean;
     HotkeyManashield : Integer;
     AutoAntiParalize : Boolean;
     HotkeyAntiParalize : Integer;
     AutoHaste : Boolean;
     HotkeyHaste : Integer;
     AutoSoulFull : Boolean;
     HotkeySoulfull : Integer;
end;

type
TBLPosition = record
Position:integer;
N:integer;
X:Integer;
Y:Integer;
Z:Integer;
end;

type TSistema = record
     PATH : String;

end;


var aSistema : TSistema;

implementation



end.
