unit U_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope,
  Vcl.StdCtrls;

type
  TF_Principal = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    edtURL: TEdit;
    cbMethod: TComboBox;
    btnProcessa: TButton;
    memRetorno: TMemo;
    memBody: TMemo;
    procedure btnProcessaClick(Sender: TObject);
    procedure cbMethodChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Principal: TF_Principal;

implementation

{$R *.dfm}

procedure TF_Principal.btnProcessaClick(Sender: TObject);
begin
  memRetorno.Clear;

  RESTClient1.BaseURL := edtURL.Text;

  try
    case cbMethod.ItemIndex of
      0: RESTRequest1.Method := rmGET;
      1: begin
           RESTRequest1.Method := rmPOST;
           RESTRequest1.AddBody(memBody.Text, ctAPPLICATION_JSON);
         end;
      2: begin
           RESTRequest1.Method := rmPUT;
           RESTRequest1.AddBody(memBody.Text, ctAPPLICATION_JSON);
         end;
      3: RESTRequest1.Method := rmDELETE;
    end;

    RESTRequest1.Execute;
    memRetorno.Lines.Add('stauts: '+ RESTResponse1.StatusCode.ToString +' ('+ RESTResponse1.StatusText +')');
    memRetorno.Lines.Add(RESTResponse1.JSONText);

  except on E: Exception do
    raise Exception.CreateFmt('Erro ao processar a requisição: %s', [E.Message]);
  end;
end;

procedure TF_Principal.cbMethodChange(Sender: TObject);
begin
  memBody.Visible := cbMethod.ItemIndex in [1,2]; //post/put
end;

end.
