object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TibiaBT'
  ClientHeight = 468
  ClientWidth = 764
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object StatusBar1: TStatusBar
    Left = 0
    Top = 449
    Width = 764
    Height = 19
    Panels = <
      item
        Text = 'Desenvolvedor: Pedro Oliveira '
        Width = 300
      end
      item
        Text = '1.0.0.2'
        Width = 50
      end>
  end
  object pFundo: TPanel
    Left = 0
    Top = 41
    Width = 764
    Height = 369
    Align = alBottom
    TabOrder = 1
    Visible = False
    object gbPersonagens: TGroupBox
      Left = 610
      Top = 1
      Width = 153
      Height = 367
      Align = alRight
      Caption = 'Personagem'
      TabOrder = 0
      object pMana: TPanel
        Left = 2
        Top = 35
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Vida: 0/0'
        Color = clRed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object pLevel: TPanel
        Left = 2
        Top = 54
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Level: 0'
        Color = clMoneyGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
      object pHealth: TPanel
        Left = 2
        Top = 16
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Mana: 0/0'
        Color = clAqua
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
      end
      object btnStart: TButton
        Left = 3
        Top = 337
        Width = 75
        Height = 25
        Caption = 'Start'
        TabOrder = 3
        OnClick = btnStartClick
      end
      object pUnderwater: TPanel
        Left = 2
        Top = 225
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Underwater'
        Color = clMaroon
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 4
      end
      object pBattle: TPanel
        Left = 2
        Top = 206
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Battle'
        Color = clMaroon
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 5
      end
      object pHast: TPanel
        Left = 2
        Top = 187
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Hast'
        Color = clMaroon
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 6
      end
      object pParalize: TPanel
        Left = 2
        Top = 168
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Paralize'
        Color = clMaroon
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 7
      end
      object pManaShield: TPanel
        Left = 2
        Top = 149
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Manashield'
        Color = clMaroon
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 8
      end
      object pDrunk: TPanel
        Left = 2
        Top = 130
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Drunk'
        Color = clMaroon
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 9
      end
      object pEnergy: TPanel
        Left = 2
        Top = 111
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Energy'
        Color = clMaroon
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 10
      end
      object pFire: TPanel
        Left = 2
        Top = 92
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Fire'
        Color = clMaroon
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 11
      end
      object pPoison: TPanel
        Left = 2
        Top = 73
        Width = 149
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Poison'
        Color = clMaroon
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 12
      end
    end
    object gbAddAcoes: TGroupBox
      Left = 1
      Top = 1
      Width = 144
      Height = 367
      Align = alLeft
      Caption = 'Adicionar acoes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object Label1: TLabel
        Left = 7
        Top = 15
        Width = 76
        Height = 14
        Caption = 'Nome da acao'
      end
      object Label2: TLabel
        Left = 7
        Top = 58
        Width = 38
        Height = 14
        Caption = 'Hotkey'
      end
      object Label3: TLabel
        Left = 7
        Top = 118
        Width = 66
        Height = 14
        Caption = 'Verifica POR'
      end
      object Label4: TLabel
        Left = 7
        Top = 161
        Width = 69
        Height = 14
        Caption = 'Verifica TIPO'
      end
      object Label5: TLabel
        Left = 7
        Top = 247
        Width = 60
        Height = 14
        Caption = 'Verificador'
      end
      object Label6: TLabel
        Left = 7
        Top = 204
        Width = 70
        Height = 14
        Caption = 'Verifica Sinal'
      end
      object Label7: TLabel
        Left = 7
        Top = 287
        Width = 50
        Height = 14
        Caption = 'Exausted'
      end
      object cbbHotkey: TComboBox
        Left = 7
        Top = 90
        Width = 121
        Height = 22
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 3
        Text = 'F1'
        Items.Strings = (
          'F1'
          'F2'
          'F3'
          'F4'
          'F5'
          'F6'
          'F7'
          'F8'
          'F9'
          'F10'
          'F11'
          'F12')
      end
      object chkShift: TCheckBox
        Left = 6
        Top = 72
        Width = 50
        Height = 17
        Caption = 'Shift'
        TabOrder = 1
      end
      object edtTempo: TEdit
        Left = 7
        Top = 262
        Width = 121
        Height = 22
        NumbersOnly = True
        TabOrder = 7
        Text = '0'
      end
      object edtNome: TEdit
        Left = 6
        Top = 29
        Width = 121
        Height = 22
        CharCase = ecUpperCase
        TabOrder = 0
      end
      object cbbVerificaPOR: TComboBox
        Left = 7
        Top = 133
        Width = 121
        Height = 22
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 4
        Text = 'MANA'
        Items.Strings = (
          'MANA'
          'HP'
          'TEMPO')
      end
      object cbbVerificaTIPO: TComboBox
        Left = 7
        Top = 176
        Width = 121
        Height = 22
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 5
        Text = 'PERC'
        Items.Strings = (
          'PERC'
          'VALOR')
      end
      object Button1: TButton
        Left = 3
        Top = 337
        Width = 75
        Height = 25
        Caption = 'Add'
        TabOrder = 9
        OnClick = Button1Click
      end
      object cbbVerificaSinal: TComboBox
        Left = 7
        Top = 219
        Width = 121
        Height = 22
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 6
        Text = 'MENOR'
        Items.Strings = (
          'MENOR'
          'MAIOR')
      end
      object edtExausted: TEdit
        Left = 7
        Top = 302
        Width = 121
        Height = 22
        NumbersOnly = True
        TabOrder = 8
        Text = '1000'
      end
      object chkCtrl: TCheckBox
        Left = 77
        Top = 72
        Width = 50
        Height = 17
        Caption = 'Ctrl'
        TabOrder = 2
      end
    end
    object gbAcoes: TGroupBox
      Left = 145
      Top = 1
      Width = 465
      Height = 367
      Align = alClient
      Caption = 'Acoes'
      TabOrder = 2
      object listAcoes: TListBox
        Left = 2
        Top = 57
        Width = 461
        Height = 308
        Align = alClient
        ItemHeight = 14
        PopupMenu = PopupMenu1
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 2
        Top = 16
        Width = 461
        Height = 41
        Align = alTop
        TabOrder = 1
        object Button2: TButton
          Left = 197
          Top = 10
          Width = 75
          Height = 25
          Caption = 'Carregar'
          TabOrder = 0
          OnClick = Button2Click
        end
        object Button3: TButton
          Left = 278
          Top = 10
          Width = 75
          Height = 25
          Caption = 'Salvar'
          TabOrder = 1
          OnClick = Button3Click
        end
        object cbbSaves: TComboBox
          Left = 4
          Top = 13
          Width = 187
          Height = 22
          TabOrder = 2
        end
      end
    end
  end
  object gbConfiguracoes: TGroupBox
    Left = 0
    Top = 410
    Width = 764
    Height = 39
    Align = alBottom
    Caption = 'Configuracoes'
    TabOrder = 2
    Visible = False
    object chkAutoCure: TCheckBox
      Left = 48
      Top = 16
      Width = 125
      Height = 21
      Align = alLeft
      Caption = 'Auto cure'
      TabOrder = 0
      OnClick = chkAutoCureClick
    end
    object chkAutoParalize: TCheckBox
      Left = 390
      Top = 16
      Width = 125
      Height = 21
      Align = alLeft
      Caption = 'Anti Paralize'
      TabOrder = 1
      OnClick = chkAutoCureClick
    end
    object chkAutoHaste: TCheckBox
      Left = 219
      Top = 16
      Width = 125
      Height = 21
      Align = alLeft
      Caption = 'Auto haste'
      TabOrder = 2
      OnClick = chkAutoCureClick
    end
    object cbbautohaste: TComboBox
      Left = 173
      Top = 16
      Width = 46
      Height = 22
      Align = alLeft
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'F1'
      OnChange = cbbAutoCureChange
      Items.Strings = (
        'F1'
        'F2'
        'F3'
        'F4'
        'F5'
        'F6'
        'F7'
        'F8'
        'F9'
        'F10'
        'F11'
        'F12')
    end
    object chkAutoManashield: TCheckBox
      Left = 561
      Top = 16
      Width = 125
      Height = 21
      Align = alLeft
      Caption = 'Auto manashield'
      TabOrder = 4
      OnClick = chkAutoCureClick
    end
    object cbbAutoCure: TComboBox
      Left = 2
      Top = 16
      Width = 46
      Height = 22
      Align = alLeft
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 5
      Text = 'F1'
      OnChange = cbbAutoCureChange
      Items.Strings = (
        'F1'
        'F2'
        'F3'
        'F4'
        'F5'
        'F6'
        'F7'
        'F8'
        'F9'
        'F10'
        'F11'
        'F12')
    end
    object cbbAntiParalize: TComboBox
      Left = 344
      Top = 16
      Width = 46
      Height = 22
      Align = alLeft
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 6
      Text = 'F1'
      OnChange = cbbAutoCureChange
      Items.Strings = (
        'F1'
        'F2'
        'F3'
        'F4'
        'F5'
        'F6'
        'F7'
        'F8'
        'F9'
        'F10'
        'F11'
        'F12')
    end
    object cbbAutoManashield: TComboBox
      Left = 515
      Top = 16
      Width = 46
      Height = 22
      Align = alLeft
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 7
      Text = 'F1'
      OnChange = cbbAutoCureChange
      Items.Strings = (
        'F1'
        'F2'
        'F3'
        'F4'
        'F5'
        'F6'
        'F7'
        'F8'
        'F9'
        'F10'
        'F11'
        'F12')
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 764
    Height = 41
    Align = alClient
    Color = clBlack
    ParentBackground = False
    TabOrder = 3
    object Label8: TLabel
      Left = 114
      Top = 20
      Width = 53
      Height = 14
      Caption = 'Processo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CbbHandler: TComboBox
      Left = 173
      Top = 13
      Width = 203
      Height = 22
      Style = csDropDownList
      TabOrder = 0
    end
    object Button5: TButton
      Left = 382
      Top = 10
      Width = 125
      Height = 25
      Caption = 'CarregarProcesso'
      TabOrder = 1
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 8
      Top = 10
      Width = 100
      Height = 25
      Caption = 'Atualizar'
      TabOrder = 2
      OnClick = Button6Click
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 344
    Top = 184
    object Apagar1: TMenuItem
      Caption = 'Apagar'
      OnClick = Apagar1Click
    end
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 376
    Top = 200
  end
end
