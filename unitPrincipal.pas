unit unitPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  unitThread, Vcl.Buttons, unitThreadExec, Vcl.Menus, Inifiles,bib.reader.mem,
  System.Generics.Collections;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    gbPersonagens: TGroupBox;
    pMana: TPanel;
    pLevel: TPanel;
    pHealth: TPanel;
    btnStart: TButton;
    gbAddAcoes: TGroupBox;
    gbAcoes: TGroupBox;
    cbbHotkey: TComboBox;
    chkShift: TCheckBox;
    edtTempo: TEdit;
    edtNome: TEdit;
    cbbVerificaPOR: TComboBox;
    cbbVerificaTIPO: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    listAcoes: TListBox;
    cbbVerificaSinal: TComboBox;
    Label6: TLabel;
    PopupMenu1: TPopupMenu;
    Apagar1: TMenuItem;
    edtExausted: TEdit;
    Label7: TLabel;
    chkCtrl: TCheckBox;
    pUnderwater: TPanel;
    pBattle: TPanel;
    pHast: TPanel;
    pParalize: TPanel;
    pManaShield: TPanel;
    pDrunk: TPanel;
    pEnergy: TPanel;
    pFire: TPanel;
    pPoison: TPanel;
    Timer1: TTimer;
    pFundo: TPanel;
    Panel2: TPanel;
    gbConfiguracoes: TGroupBox;
    chkAutoCure: TCheckBox;
    chkAutoParalize: TCheckBox;
    chkAutoHaste: TCheckBox;
    cbbautohaste: TComboBox;
    chkAutoManashield: TCheckBox;
    cbbAutoCure: TComboBox;
    cbbAntiParalize: TComboBox;
    cbbAutoManashield: TComboBox;
    Button2: TButton;
    Button3: TButton;
    Panel3: TPanel;
    CbbHandler: TComboBox;
    Label8: TLabel;
    Button5: TButton;
    Button6: TButton;
    cbbSaves: TComboBox;
    procedure btnStartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Apagar1Click(Sender: TObject);
    procedure chkAutoCureClick(Sender: TObject);
    procedure cbbAutoCureChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
   aHandlerList : TList<HWND>;
   TelaCarregada : Boolean;
   function StrTohotkey(Value:String):integer;
   procedure ListaAcoes;
   procedure configurar;
   procedure salvar_bot(aArq:String);
   procedure carrega_bot(aArq:String);
   procedure carrega_inis;
   procedure gravaini(_chave, _campoini, _valor: String; aArq: String = '');
   function LeIni(_chave, _campoini: String; aDefault: String = ''; aArq: String = ''): String;
   procedure carrega_processos;
   function SoNumero(aValue: String): String;

  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

uses bib.vars, System.IOUtils, System.StrUtils, Winapi.TlHelp32, unitProccess;

procedure TForm1.Apagar1Click(Sender: TObject);
var aIndex:Integer;
begin
  aIndex := listAcoes.ItemIndex;
  listAcoes.DeleteSelected;
  aThreadExec.DeleteAcao(aIndex);

end;

procedure TForm1.btnStartClick(Sender: TObject);
var aStart:Boolean;
begin
  if btnStart.Caption = 'Start' then
     aStart := True else
     aStart := False;

  if aStart then
     btnStart.Caption := 'Stop' else
     btnStart.Caption := 'Start';

  if aStart then
  Begin
     aThread.pausar := False;
     sleep(100);
     aThreadExec.Pausar := False;
  End
  else
  Begin
     aThreadExec.Pausar := True;
     aThread.pausar := True;
  End;
end;



procedure TForm1.Button1Click(Sender: TObject);
begin
  aThreadExec.AddAcao(edtNome.Text
                     ,StrTohotkey(cbbhotkey.text)
                     ,chkShift.Checked
                     ,chkCtrl.Checked
                     ,TVerificaPor(cbbVerificaPOR.ItemIndex)
                     ,TVerificaTipo(cbbVerificaTIPO.ItemIndex)
                     ,TVerificaSinal(cbbVerificaSinal.ItemIndex)
                     ,strtoint(edtTempo.Text)
                     ,strtoint(edtExausted.Text));

  edtNome.Clear;
  edtTempo.Text := '0';
  chkShift.Checked := False;
  SetFocusedControl(edtNome);

  ListaAcoes;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  carrega_bot(cbbSaves.text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  salvar_bot(cbbSaves.text);
end;

procedure TForm1.Button5Click(Sender: TObject);
var aPID:Integer;
begin
  aPID := StrToInt(SoNumero(copy(CbbHandler.Text,pos('#',CbbHandler.text),length(CbbHandler.text))));

  aThread := TTibiaAddress.Create(aHandlerList[CbbHandler.ItemIndex]);
  aThread.FreeOnTerminate := True;
  aThread.Start;

  aThreadExec := TTibiaExec.Create(aHandlerList[CbbHandler.ItemIndex]);
  aThreadExec.FreeOnTerminate := True;
  aThreadExec.Start;

  aThread.Pausar := False;

  gbConfiguracoes.Visible := True;
  pFundo.Visible := True;

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  carrega_processos;
end;

procedure TForm1.carrega_bot(aArq:String);
var Value:TAcoes;
     i:integer;
     aTotal:Integer;
begin
  aThreadExec.Pausar := true;
  aThreadExec.ACOES.Clear;
  aThreadExec.ACOES.TrimExcess;

  aArq := TPath.Combine(aSistema.PATH,aArq+'xbt.ini');

  listAcoes.Items.Clear;

  chkAutoCure.Checked := LeIni('CONFIG','CURE','0',aArq)='1';
  cbbAutoCure.ItemIndex := StrToInt(LeIni('CONFIG','HTCURE','0',aArq));

  chkAutoHaste.Checked := LeIni('CONFIG','HASTE','0',aArq)='1';
  cbbautohaste.ItemIndex := StrToInt(LeIni('CONFIG','HTHASTE','0',aArq));

  chkAutoParalize.Checked := LeIni('CONFIG','PARALIZE','0',aArq)='1';
  cbbAntiParalize.ItemIndex := StrToInt(LeIni('CONFIG','HTPARALIZE','0',aArq));

  chkAutoManashield.Checked := LeIni('CONFIG','MANASHIELD','0',aArq)='1';
  cbbAutoManashield.ItemIndex := StrToInt(LeIni('CONFIG','HTMANASHIELD','0',aArq));


  aTotal :=  StrToInt(LeIni('ACAO','TOTAL' ,'0',aArq));
  i := 0;

  for i:=0 to aTotal-1 do
  Begin
    Value.Nome          := LeIni('ACAO'+inttostr(i),'NOME'       , i.ToString,aArq);
    Value.Hotkey        := LeIni('ACAO'+inttostr(i),'HOTKEY'     , '0',aArq).ToInteger;
    Value.Shift         := LeIni('ACAO'+inttostr(i),'SHIFT'      , '0',aArq)='1';
    Value.Ctrl          := LeIni('ACAO'+inttostr(i),'CTRL'       , '0',aArq)='1';
    Value.VerificaPOR   := TVerificaPor(strtoint(LeIni('ACAO'+inttostr(i),'POR'        , '0',aArq)));
    Value.VerificaTIPO  := TVerificaTipo(strtoint(LeIni('ACAO'+inttostr(i),'TIPO'       , '0',aArq)));
    Value.VerificaSinal := TVerificaSinal(strtoint(LeIni('ACAO'+inttostr(i),'SINAL'      , '0',aArq)));
    Value.Verificador   := LeIni('ACAO'+inttostr(i),'VERIFICADO' , '0',aArq).ToInteger;
    Value.Exausted      := LeIni('ACAO'+inttostr(i),'Exausted'   , '0',aArq).ToInteger;
    aThreadExec.AddAcao2(Value);
  End;

  ListaAcoes;

  configurar;

end;

procedure TForm1.carrega_inis;
  procedure listararquivos(var aList:TStringList);
  var
    SR: TSearchRec;
    I: integer;
  begin
    aList := TStringList.Create;
    I := FindFirst(aSistema.PATH+'*', faAnyFile, SR);
    while I = 0 do
    begin
      aList.Add(sr.Name);
      I := FindNext(SR);
    end;
  end;
var aArqs:TStringList;
  I: Integer;
begin
   listararquivos(aArqs);
   cbbSaves.Items.Clear;
   for I := 0 to aArqs.Count-1 do
   Begin
      if pos('xbt.ini',aArqs[i])>0 then
      Begin
         cbbSaves.Items.Add(StringReplace(aArqs[i],'xbt.ini','',[]));
      end;
   end;
   if cbbSaves.Items.Count>0 then
      cbbSaves.ItemIndex := 0;
end;

procedure TForm1.carrega_processos;
var
Handle,TibiaHandle: HWND;
ClassName: array [0..255] of Char;
begin
  aHandlerList.Free;
  aHandlerList := TList<HWND>.Create;

  CbbHandler.Items.Clear;

  Handle := FindWindow(nil, nil);
  while Handle <> 0 do
  begin
    GetClassName(Handle, ClassName, SizeOf(ClassName));
    if ClassName = 'TibiaClient' then
    begin
      TibiaHandle := handle;
      aReader.aHandler := Handle;
      CbbHandler.Items.Add('Tibia'+aHandlerList.Count.ToString);
      aHandlerList.Add(TibiaHandle);
    end;
    Handle := GetWindow(Handle, GW_HWNDNEXT);
  end;

  if CbbHandler.Items.Count>0 then
     CbbHandler.ItemIndex := 0;

end;

procedure TForm1.cbbAutoCureChange(Sender: TObject);
begin
  configurar;
end;

procedure TForm1.chkAutoCureClick(Sender: TObject);
begin
  configurar;
end;

procedure TForm1.configurar;
begin
  aThreadExec.FPlayerConfig.AutoCure           := chkAutoCure.Checked;
  aThreadExec.FPlayerConfig.AutoAntiParalize   := chkAutoParalize.Checked;
  aThreadExec.FPlayerConfig.AutoManaShield     := chkAutoManashield.Checked;
  aThreadExec.FPlayerConfig.AutoHaste          := chkAutoHaste.Checked;
  aThreadExec.FPlayerConfig.HotkeyCure         := StrTohotkey(cbbautohaste.text);
  aThreadExec.FPlayerConfig.HotkeyAntiParalize := StrTohotkey(cbbAntiParalize.text);
  aThreadExec.FPlayerConfig.HotkeyManashield   := StrTohotkey(cbbAutoManashield.text);
  aThreadExec.FPlayerConfig.HotkeyHaste        := StrTohotkey(cbbautohaste.text);

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
   if not TelaCarregada then
   Begin
     TelaCarregada := True;
     carrega_processos;
     carrega_inis;
   End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  aSistema.PATH := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  aReader       := TReaderMem.Create;
  TelaCarregada := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  aReader.free;
end;

procedure TForm1.gravaini(_chave, _campoini, _valor, aArq: String);

var
  _INI: TIniFile;
Begin
  _INI := nil;
  try
    if aArq = '' then
      aArq := TPath.Combine(aSistema.PATH, 'tibiabt.ini');

    _INI := TIniFile.Create(aArq);
    _INI.WriteString(_chave, _campoini,  _valor);
    _INI.UpdateFile;

  finally
    _INI.Free;
  end;
end;

function TForm1.LeIni(_chave, _campoini, aDefault , aArq: String): String;
var  _INI: TIniFile;
Begin
  _INI := nil;
  try
    if aArq = '' then
      aArq := TPath.Combine(aSistema.PATH, 'tibiabt.ini');

    _INI := TIniFile.Create(aArq);
    Result   := _INI.ReadString(_chave, _campoini, aDefault);
    _INI.UpdateFile;
  finally
    _INI.Free;
  end;

end;

procedure TForm1.ListaAcoes;
var
  Value: TAcoes;
  aStr : String;
  aPor:String;
begin
  listAcoes.Items.Clear;
  for Value in aThreadExec.ACOES do
  Begin
     case Value.VerificaPOR of
       vpMana: aPor:= 'Mana';
       vpHP:  aPor:= 'HP';
       vpTempo:  aPor:= 'Tempo';
     end;
     aStr := '[Nome:'+Value.Nome
            +'][POR:'+aPor
            +'][Tipo:'+IfThen(Value.VerificaTIPO=vtPerc,'%','Valor')
            +'][Sinal:'+IfThen(Value.VerificaSinal=vsMenor,'<=','>=')
            +'][Verificador:'+value.Verificador.ToString
            +'][Hotkey:'+value.Hotkey.ToString
           + ']';
     listAcoes.Items.Add(aStr);
  End;
end;

procedure TForm1.salvar_bot(aArq:String);
var Value:TAcoes;
     i:integer;
begin
  aArq := TPath.Combine(aSistema.PATH,aArq+'xbt.ini');

  if fileexists(aArq) then
    DeleteFile(aArq);

  gravaini('CONFIG','CURE'        ,IfThen(chkAutoCure.Checked,'1','0'),aArq);
  gravaini('CONFIG','HTCURE'      ,cbbAutoCure.ItemIndex.ToString,aArq);
  gravaini('CONFIG','HASTE'       ,IfThen(chkAutoHaste.Checked,'1','0'),aArq);
  gravaini('CONFIG','HTHASTE'     ,cbbautohaste.ItemIndex.ToString,aArq);
  gravaini('CONFIG','PARALIZE'    ,IfThen(chkAutoParalize.Checked,'1','0'),aArq);
  gravaini('CONFIG','HTPARALIZE'  ,cbbAntiParalize.ItemIndex.ToString,aArq);
  gravaini('CONFIG','MANASHIELD'  ,IfThen(chkAutoManashield.Checked,'1','0'),aArq);
  gravaini('CONFIG','HTMANASHIELD',cbbAutoManashield.ItemIndex.ToString,aArq);

  i := 0;
  gravaini('ACAO','TOTAL'       , aThreadExec.ACOES.Count.ToString,aArq);
  for Value in aThreadExec.ACOES do
  Begin
     gravaini('ACAO'+inttostr(i),'NOME'       , value.Nome,aArq);
     gravaini('ACAO'+inttostr(i),'HOTKEY'     , value.Hotkey.ToString,aArq);
     gravaini('ACAO'+inttostr(i),'SHIFT'      , IfThen(value.Shift,'1','0'),aArq);
     gravaini('ACAO'+inttostr(i),'CTRL'       , IfThen(value.Ctrl,'1','0'),aArq);
     gravaini('ACAO'+inttostr(i),'POR'        , inttostr(Integer(value.VerificaPOR)) ,aArq);
     gravaini('ACAO'+inttostr(i),'TIPO'       , inttostr(Integer(value.VerificaTIPO)) ,aArq);
     gravaini('ACAO'+inttostr(i),'SINAL'      , inttostr(Integer(value.VerificaSinal)) ,aArq);
     gravaini('ACAO'+inttostr(i),'VERIFICADO' , inttostr(value.Verificador),aArq);
     gravaini('ACAO'+inttostr(i),'Exausted'   , inttostr(value.Verificador),aArq);
     inc(i);
  End;
end;

function TForm1.SoNumero(aValue: String): String;
var
  I: Integer;
begin
  for I := 0 to Length(aValue) do
    if CharInSet(aValue[I], ['0' .. '9']) then
      Result := Result + aValue[I];
end;

function TForm1.StrTohotkey(Value: String): integer;
Begin
  if value ='F1' then
  result := VK_F1
  else if value ='F2' then
  result := VK_F2
  else if value ='F3' then
  result := VK_F3
  else if value ='F4' then
  result := VK_F4
  else if value ='F5' then
  result := VK_F5
  else if value ='F6' then
  result := VK_F6
  else if value ='F7' then
  result := VK_F7
  else if value ='F8' then
  result := VK_F8
  else if value ='F9' then
  result := VK_F9
  else if value ='F10' then
  result := VK_F10
  else if value ='F11' then
  result := VK_F11
  else if value ='F12' then
  result := VK_F12;
End;

procedure TForm1.Timer1Timer(Sender: TObject);
  procedure pintaPanelStatus(Sender:TObject;aValue:Boolean);
  Begin
     if aValue then
        TPanel(Sender).Color := clGreen else
        TPanel(Sender).Color := clMaroon;
  End;
begin
  if not Assigned(aThread) then exit;
  
  pMana.Caption := 'Mana: '+ aThread.Player.MANA.ToString+'/'+aThread.Player.MANA_MAX.ToString;
  pHealth.Caption := 'HP: '+ aThread.Player.HP.ToString+'/'+aThread.Player.HP_MAX.ToString;
  pLevel.Caption := 'Level: '+ aThread.Player.LEVEL.ToString;

  pintaPanelStatus(pPoison,aThread.PlayerStatus.Poison);
  pintaPanelStatus(pFire,aThread.PlayerStatus.Fire);
  pintaPanelStatus(pEnergy,aThread.PlayerStatus.Energy);
  pintaPanelStatus(pDrunk,aThread.PlayerStatus.Drunk);
  pintaPanelStatus(pManaShield,aThread.PlayerStatus.Manashield);
  pintaPanelStatus(pParalize,aThread.PlayerStatus.Paralyse);
  pintaPanelStatus(pHast,aThread.PlayerStatus.Hast);
  pintaPanelStatus(pBattle,aThread.PlayerStatus.Battle);
  pintaPanelStatus(pUnderwater,aThread.PlayerStatus.Underwater);


end;

end.
