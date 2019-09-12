object F_Principal: TF_Principal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'REST Client [Reinaldo Silveira]'
  ClientHeight = 637
  ClientWidth = 827
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object edtURL: TEdit
    Left = 24
    Top = 24
    Width = 785
    Height = 24
    TabOrder = 0
    Text = 'http://localhost:8080'
  end
  object cbMethod: TComboBox
    Left = 24
    Top = 208
    Width = 145
    Height = 24
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = 'GET'
    OnChange = cbMethodChange
    Items.Strings = (
      'GET'
      'POST'
      'PUT'
      'DELETE')
  end
  object btnProcessa: TButton
    Left = 192
    Top = 208
    Width = 129
    Height = 25
    Caption = 'Enviar requisi'#231#227'o'
    TabOrder = 3
    OnClick = btnProcessaClick
  end
  object memRetorno: TMemo
    Left = 24
    Top = 248
    Width = 785
    Height = 361
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object memBody: TMemo
    Left = 24
    Top = 57
    Width = 785
    Height = 136
    ScrollBars = ssVertical
    TabOrder = 1
    Visible = False
    WantTabs = True
  end
  object RESTClient1: TRESTClient
    Authenticator = HTTPBasicAuthenticator1
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8080/'
    ContentType = 'application/json'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 80
    Top = 304
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 80
    Top = 368
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    ContentEncoding = 'utf-8'
    Left = 184
    Top = 368
  end
  object HTTPBasicAuthenticator1: THTTPBasicAuthenticator
    Username = 'user'
    Password = 'pass'
    Left = 208
    Top = 304
  end
end
