unit unitPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  unitThread, Vcl.Buttons, unitThreadExec, Vcl.Menus, Inifiles,bib.reader.mem,
  System.Generics.Collections, System.ImageList, Vcl.ImgList, Vcl.AppEvnts,
  bib.vars;

type
  TTibiaBTClient = class(TForm)
    StatusBar1: TStatusBar;
    gbPersonagens: TGroupBox;
    pMana: TPanel;
    pLevel: TPanel;
    pHealth: TPanel;
    gbAcoes: TGroupBox;
    listAcoes: TListBox;
    PopupMenu1: TPopupMenu;
    Apagar1: TMenuItem;
    Timer1: TTimer;
    pFundo: TPanel;
    Panel2: TPanel;
    Button2: TButton;
    Button3: TButton;
    pCarregamento: TPanel;
    CbbHandler: TComboBox;
    Label8: TLabel;
    Button5: TButton;
    Button6: TButton;
    cbbSaves: TComboBox;
    TrayIcon: TTrayIcon;
    Img: TImageList;
    ApplicationEvents: TApplicationEvents;
    popTray: TPopupMenu;
    Open1: TMenuItem;
    Hide1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    N2: TMenuItem;
    Nome1: TMenuItem;
    gbConfiguracoes: TGroupBox;
    chkAutoCure: TCheckBox;
    chkAutoParalize: TCheckBox;
    chkAutoHaste: TCheckBox;
    cbbautohaste: TComboBox;
    chkAutoManashield: TCheckBox;
    cbbAutoCure: TComboBox;
    cbbAntiParalize: TComboBox;
    cbbAutoManashield: TComboBox;
    Panel1: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    pPoison: TPanel;
    pFire: TPanel;
    pEnergy: TPanel;
    pDrunk: TPanel;
    pParalize: TPanel;
    pUnderwater: TPanel;
    Panel6: TPanel;
    pBattle: TPanel;
    pHast: TPanel;
    pManaShield: TPanel;
    btnStart: TButton;
    gbAddAcoes: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cbbHotkey: TComboBox;
    chkShift: TCheckBox;
    edtTempo: TEdit;
    edtNome: TEdit;
    cbbVerificaPOR: TComboBox;
    cbbVerificaTIPO: TComboBox;
    Button1: TButton;
    cbbVerificaSinal: TComboBox;
    edtExausted: TEdit;
    chkCtrl: TCheckBox;
    chkFullSoul: TCheckBox;
    cbbFullSoul: TComboBox;
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
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Hide1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure listAcoesDblClick(Sender: TObject);
  private
    { Private declarations }
   aHandlerList : TList<HWND>;
   TelaCarregada : Boolean;
   hk1,hk2: Integer;
   aValueEdit : TAcoes;
   function StrTohotkey(Value:String):integer;
   function hotkeyToIndex(Value:integer):integer;
   procedure ListaAcoes;
   procedure configurar;
   procedure salvar_bot(aArq:String);
   procedure carrega_bot(aArq:String);
   procedure carrega_inis;
   procedure gravaini(_chave, _campoini, _valor: String; aArq: String = '');
   function LeIni(_chave, _campoini: String; aDefault: String = ''; aArq: String = ''): String;
   procedure carrega_processos;
   function SoNumero(aValue: String): String;
   procedure Restaurar_Aplicacao;
   Procedure SetNameTibia(hWindow: HWND;aNome:String);

   //HotKeys
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure fecha_tudo;
    procedure esconde_tudo;

  public
    { Public declarations }

  end;

var
  TibiaBTClient: TTibiaBTClient;

implementation

{$R *.dfm}

{ TTibiaBT }

uses System.IOUtils, System.StrUtils, Winapi.TlHelp32;

procedure TTibiaBTClient.Apagar1Click(Sender: TObject);
var aIndex:Integer;
begin
  aIndex := listAcoes.ItemIndex;
  listAcoes.DeleteSelected;
  aThreadExec.DeleteAcao(aIndex);

end;

procedure TTibiaBTClient.ApplicationEventsMinimize(Sender: TObject);
begin
  Hide;
end;

procedure TTibiaBTClient.btnStartClick(Sender: TObject);
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



procedure TTibiaBTClient.Button1Click(Sender: TObject);
var aID:Integer;
begin
  aID := -1;
  try
  if Assigned(aValueEdit) then
  Begin
    aID        := aThreadExec.ACOES.IndexOf(aValueEdit);
  End;

    aThreadExec.AddAcao(edtNome.Text
                       ,StrTohotkey(cbbhotkey.text)
                       ,chkShift.Checked
                       ,chkCtrl.Checked
                       ,TVerificaPor(cbbVerificaPOR.ItemIndex)
                       ,TVerificaTipo(cbbVerificaTIPO.ItemIndex)
                       ,TVerificaSinal(cbbVerificaSinal.ItemIndex)
                       ,strtoint(edtTempo.Text)
                       ,strtoint(edtExausted.Text)
                       ,aID);  // Se tiver desabilitado é pq é uma edicao

    ListaAcoes;
  finally
    aValueEdit := nil;

    edtNome.Enabled := True;
    edtNome.Clear;
    edtTempo.Text := '0';
    chkShift.Checked := False;
    SetFocusedControl(edtNome);
  end;
end;

procedure TTibiaBTClient.Button2Click(Sender: TObject);
begin
  carrega_bot(cbbSaves.text);
end;

procedure TTibiaBTClient.Button3Click(Sender: TObject);
begin
  salvar_bot(cbbSaves.text);
end;

procedure TTibiaBTClient.Button5Click(Sender: TObject);
begin
  if not Assigned(aThread) then
  Begin
    aThread := TTibiaAddress.Create(aHandlerList[CbbHandler.ItemIndex]);
    aThread.FreeOnTerminate := True;
    aThread.Start;
  End
  else
  Begin
    aThread.Pausar   := True;
    aThread.FHandler := aHandlerList[CbbHandler.ItemIndex];
    aThread.Pausar   := False;
  End;

  if not Assigned(aThreadExec) then
  Begin
    aThreadExec := TTibiaExec.Create(aHandlerList[CbbHandler.ItemIndex]);
    aThreadExec.FreeOnTerminate := True;
    aThreadExec.Start;
  End
  else
  begin
    aThreadExec.Pausar   := True;
    aThreadExec.FHandler := aHandlerList[CbbHandler.ItemIndex];
    aThreadExec.Pausar   := False;
  end;

  aThread.Pausar := False;

  pFundo.Enabled := True;

  pCarregamento.Color := clGreen;

  SetNameTibia(aHandlerList[CbbHandler.ItemIndex],InputBox('Digite um nome para ident','','Tibia'));
end;

procedure TTibiaBTClient.Button6Click(Sender: TObject);
begin
  carrega_processos;
end;

procedure TTibiaBTClient.carrega_bot(aArq:String);
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

  chkFullSoul.Checked := LeIni('CONFIG','SOULFULL','0',aArq)='1';
  cbbFullSoul.ItemIndex := StrToInt(LeIni('CONFIG','HTSOULFULL','0',aArq));


  aTotal :=  StrToInt(LeIni('ACAO','TOTAL' ,'0',aArq));
  i := 0;

  for i:=0 to aTotal-1 do
  Begin
    Value               := TAcoes.Create;
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

procedure TTibiaBTClient.carrega_inis;
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

procedure TTibiaBTClient.carrega_processos;
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

procedure TTibiaBTClient.cbbAutoCureChange(Sender: TObject);
begin
  configurar;
end;

procedure TTibiaBTClient.chkAutoCureClick(Sender: TObject);
begin
  configurar;
end;

procedure TTibiaBTClient.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TTibiaBTClient.configurar;
begin
  aThreadExec.FPlayerConfig.AutoCure           := chkAutoCure.Checked;
  aThreadExec.FPlayerConfig.AutoAntiParalize   := chkAutoParalize.Checked;
  aThreadExec.FPlayerConfig.AutoManaShield     := chkAutoManashield.Checked;
  aThreadExec.FPlayerConfig.AutoHaste          := chkAutoHaste.Checked;
  aThreadExec.FPlayerConfig.AutoSoulFull       := chkFullSoul.Checked;

  aThreadExec.FPlayerConfig.HotkeyCure         := StrTohotkey(cbbautohaste.text);
  aThreadExec.FPlayerConfig.HotkeyAntiParalize := StrTohotkey(cbbAntiParalize.text);
  aThreadExec.FPlayerConfig.HotkeyManashield   := StrTohotkey(cbbAutoManashield.text);
  aThreadExec.FPlayerConfig.HotkeyHaste        := StrTohotkey(cbbautohaste.text);
  aThreadExec.FPlayerConfig.HotkeySoulfull     := StrTohotkey(cbbFullSoul.text);
end;

procedure TTibiaBTClient.esconde_tudo;
var
  aHandle: HWND;
  ClassName: array [0..255] of Char;
begin
  aHandle := FindWindow(nil, nil);
  while aHandle <> 0 do
  begin
    GetClassName(aHandle, ClassName, SizeOf(ClassName));
    if ClassName = 'TibiaClient' then
    begin
       ShowWindow(aHandle,SW_HIDE);
    end;
    aHandle := GetWindow(aHandle, GW_HWNDNEXT);
  end;
  CloseHandle(aHandle);


  aHandle := FindWindow(nil, nil);
  while aHandle <> 0 do
  begin
    GetClassName(aHandle, ClassName, SizeOf(ClassName));
    if ClassName = 'TApplication' then
    begin
      ShowWindow(aHandle,SW_HIDE);
    end;
    aHandle := GetWindow(aHandle, GW_HWNDNEXT);
  end;
  CloseHandle(aHandle);

end;

procedure TTibiaBTClient.fecha_tudo;
var
  aHandle: HWND;
  PId, h : DWORD;
  ClassName: array [0..255] of Char;
begin
  aHandle := FindWindow(nil, nil);
  while aHandle <> 0 do
  begin
    GetClassName(aHandle, ClassName, SizeOf(ClassName));
    if ClassName = 'TibiaClient' then
    begin
      GetWindowThreadProcessId(aHandle,@PId);
      h := OpenProcess(PROCESS_TERMINATE, false, PId);
      TerminateProcess(h,0)
    end;
    aHandle := GetWindow(aHandle, GW_HWNDNEXT);
  end;
  CloseHandle(aHandle);


  aHandle := FindWindow(nil, nil);
  while aHandle <> 0 do
  begin
    GetClassName(aHandle, ClassName, SizeOf(ClassName));
    if ClassName = 'TApplication' then
    begin
      GetWindowThreadProcessId(aHandle,@PId);
      h := OpenProcess(PROCESS_TERMINATE, false, PId);
      TerminateProcess(h,0)
    end;
    aHandle := GetWindow(aHandle, GW_HWNDNEXT);
  end;
  CloseHandle(aHandle);

end;

procedure TTibiaBTClient.FormActivate(Sender: TObject);
begin
   if not TelaCarregada then
   Begin
     TelaCarregada := True;
     carrega_processos;
     carrega_inis;
   End;
end;

procedure TTibiaBTClient.FormCreate(Sender: TObject);
const
  MOD_ALT = 1;
  MOD_CONTROL = 2;
  MOD_SHIFT = 4;
  MOD_WIN = 8;
  VK_A = $41;
  VK_R = $52;
  VK_F4 = $73;
begin
  aSistema.PATH := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  aReader       := TReaderMem.Create;
  TelaCarregada := False;
  Nome1.Caption := Caption;

  // Register Hotkey Win + f12
  hk1 := GlobalAddAtom('Hotkey1');
  RegisterHotKey(Handle, hk1, MOD_WIN, vk_f12);

  // Register Hotkey Win + f11
  hk2 := GlobalAddAtom('Hotkey2');
  RegisterHotKey(Handle, hk2, MOD_WIN, vk_f11);

  aValueEdit := nil;

end;

procedure TTibiaBTClient.FormDestroy(Sender: TObject);
begin
  aReader.free;
  aHandlerList.Free;

  UnRegisterHotKey(Handle, hk1);
  GlobalDeleteAtom(hk1);
  UnRegisterHotKey(Handle, hk2);
  GlobalDeleteAtom(hk2);
end;

procedure TTibiaBTClient.gravaini(_chave, _campoini, _valor, aArq: String);
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

procedure TTibiaBTClient.Hide1Click(Sender: TObject);
begin
  if Hide1.Caption = '&Hide Client' then
  begin
    ShowWindow(aHandlerList[CbbHandler.ItemIndex],SW_HIDE);
    Hide1.Caption := '&Show Client';
  end
  else if Hide1.Caption = '&Show Client' then
  begin
    ShowWindow(aHandlerList[CbbHandler.ItemIndex],SW_RESTORE);
    Hide1.Caption := '&Hide Client';
  end;
end;

function TTibiaBTClient.hotkeyToIndex(Value: integer): integer;
begin
  case Value of
     VK_F1  : result := 0;
     VK_F2  : result := 1;
     VK_F3  : result := 2;
     VK_F4  : result := 3;
     VK_F5  : result := 4;
     VK_F6  : result := 5;
     VK_F7  : result := 6;
     VK_F8  : result := 7;
     VK_F9  : result := 8;
     VK_F10 : result := 9;
     VK_F11 : result := 10;
     VK_F12 : result := 11;
  end;
end;

function TTibiaBTClient.LeIni(_chave, _campoini, aDefault , aArq: String): String;
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

procedure TTibiaBTClient.ListaAcoes;
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
            +'][Ver.:'+value.Verificador.ToString
            +'][Hotkey:'+value.Hotkey.ToString
            +'][Exaus.:'+value.Exausted.ToString
           + ']';
     listAcoes.Items.Add(aStr);
  End;
end;

procedure TTibiaBTClient.listAcoesDblClick(Sender: TObject);
begin
  aValueEdit                  := aThreadExec.ACOES.Items[listAcoes.ItemIndex];

  if Assigned(aValueEdit) then
  Begin
    edtNome.Text               := aValueEdit.Nome;
    cbbhotkey.ItemIndex        := hotkeyToIndex(aValueEdit.Hotkey);
    chkShift.Checked           := aValueEdit.Shift;
    chkCtrl.Checked            := aValueEdit.Ctrl;
    cbbVerificaPOR.ItemIndex   := Integer(aValueEdit.VerificaPOR);
    cbbVerificaTIPO.ItemIndex  := Integer(aValueEdit.VerificaTIPO);
    cbbVerificaSinal.ItemIndex := Integer(aValueEdit.VerificaSinal);
    edtTempo.Text              := inttostr(aValueEdit.Verificador);
    edtExausted.Text           := inttostr(aValueEdit.Exausted);
    edtNome.Enabled            := False;
    FocusControl(chkShift);
  End
  else
  Begin
     Showmessage('Nao foi possivel carregar.');
     edtNome.Enabled            := True;
  End;
end;

procedure TTibiaBTClient.Open1Click(Sender: TObject);
begin
  Restaurar_Aplicacao;
end;

procedure TTibiaBTClient.Restaurar_Aplicacao;
var
  hApp: Integer;
begin
  try
    hApp := FindWindow('TApplication', 'TibiaBT');

    if not Application.MainForm.Showing then
       Application.MainForm.Show;

    if IsIconic(Application.Handle) then
      { Minimizado }
       SendMessage(hApp, WM_SYSCOMMAND, SC_RESTORE, 0)
    else
      { Não minimizado }
      SetForegroundWindow(hApp);

    Application.MainForm.WindowState := wsNormal;
    Application.MainForm.BringToFront;
  except

  end;
end;

procedure TTibiaBTClient.salvar_bot(aArq:String);
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
  gravaini('CONFIG','SOULFULL'    ,IfThen(chkFullSoul.Checked,'1','0'),aArq);
  gravaini('CONFIG','HTSOULFULL'  ,cbbFullSoul.ItemIndex.ToString,aArq);

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
     gravaini('ACAO'+inttostr(i),'Exausted'   , inttostr(value.Exausted),aArq);
     inc(i);
  End;
end;

procedure TTibiaBTClient.SetNameTibia(hWindow: HWND; aNome: String);
begin
  setWindowText(hWindow,PChar(aNome));
  Caption       := 'TibiaBT - '+aNome;
  Nome1.Caption := Caption;
  TrayIcon.Hint := Caption;
end;

function TTibiaBTClient.SoNumero(aValue: String): String;
var
  I: Integer;
begin
  for I := 0 to Length(aValue) do
    if CharInSet(aValue[I], ['0' .. '9']) then
      Result := Result + aValue[I];
end;

function TTibiaBTClient.StrTohotkey(Value: String): integer;
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

procedure TTibiaBTClient.Timer1Timer(Sender: TObject);
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

procedure TTibiaBTClient.TrayIconDblClick(Sender: TObject);
begin
  Restaurar_Aplicacao;
end;

procedure TTibiaBTClient.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey = hk1 then
    fecha_tudo
  else if Msg.HotKey = hk2 then
    esconde_tudo;

end;

end.
