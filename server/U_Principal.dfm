object F_Principal: TF_Principal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'REST Server [Reinaldo Silveira]'
  ClientHeight = 594
  ClientWidth = 502
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object lblNome: TLabel
    Left = 120
    Top = 24
    Width = 237
    Height = 66
    Alignment = taCenter
    Caption = 'Rest WebService Application'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label1: TLabel
    Left = 21
    Top = 124
    Width = 72
    Height = 16
    Caption = 'Requisi'#231#245'es:'
  end
  object Label2: TLabel
    Left = 21
    Top = 332
    Width = 63
    Height = 16
    Caption = 'Respostas:'
  end
  object lblinfo: TStaticText
    Left = 21
    Top = 101
    Width = 459
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'WebService parado.'
    Color = clMedGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInfoBk
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
  end
  object memLogReq: TMemo
    Left = 21
    Top = 144
    Width = 459
    Height = 177
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object memLogRes: TMemo
    Left = 21
    Top = 354
    Width = 459
    Height = 177
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object btnAtivar: TButton
    Left = 168
    Top = 552
    Width = 85
    Height = 25
    Caption = 'Ativar WS'
    TabOrder = 3
    OnClick = btnAtivarClick
  end
  object btnParar: TButton
    Left = 259
    Top = 552
    Width = 85
    Height = 25
    Caption = 'Parar WS'
    Enabled = False
    TabOrder = 4
    OnClick = btnPararClick
  end
  object IdHTTPServer1: TIdHTTPServer
    Bindings = <>
    DefaultPort = 8080
    OnCommandOther = IdHTTPServer1CommandOther
    OnCommandGet = IdHTTPServer1CommandGet
    Left = 240
    Top = 216
  end
end
