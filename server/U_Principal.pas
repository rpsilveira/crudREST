unit U_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,System.JSON, IdContext,
  IdCustomHTTPServer, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdHTTPServer, U_Clientes;

type
  TF_Principal = class(TForm)
    lblNome: TLabel;
    lblinfo: TStaticText;
    memLogReq: TMemo;
    Label1: TLabel;
    memLogRes: TMemo;
    Label2: TLabel;
    IdHTTPServer1: TIdHTTPServer;
    btnAtivar: TButton;
    btnParar: TButton;
    procedure btnAtivarClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure IdHTTPServer1CommandOther(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    cli: TCliente;
    procedure LogLastRequest(req: TIdHTTPRequestInfo);
    procedure LogLastResponse(res: TIdHTTPResponseInfo);
    function CheckAuthentication(req: TIdHTTPRequestInfo; res: TIdHTTPResponseInfo): Boolean;

    procedure GetClientes(req: TIdHTTPRequestInfo; res: TIdHTTPResponseInfo);
    procedure InsertCliente(req: TIdHTTPRequestInfo; res: TIdHTTPResponseInfo);
    procedure UpdateCliente(req: TIdHTTPRequestInfo; res: TIdHTTPResponseInfo);
    procedure DeleteCliente(req: TIdHTTPRequestInfo; res: TIdHTTPResponseInfo);
  public
    { Public declarations }
  end;

var
  F_Principal: TF_Principal;

implementation

{$R *.dfm}

uses U_Utilitarios;

{ TF_Principal }

procedure TF_Principal.btnAtivarClick(Sender: TObject);
begin
  IdHTTPServer1.Active := True;
  lblinfo.Caption      := 'Aguardando requisições...';
  btnAtivar.Enabled    := False;
  btnParar.Enabled     := True;
end;

procedure TF_Principal.btnPararClick(Sender: TObject);
begin
  IdHTTPServer1.Active := False;
  lblinfo.Caption      := 'WebService parado.';
  btnAtivar.Enabled    := True;
  btnParar.Enabled     := False;
end;

function TF_Principal.CheckAuthentication(req: TIdHTTPRequestInfo;
  res: TIdHTTPResponseInfo): Boolean;
const
  user = 'user';
  pass = 'pass';
begin
  Result := (req.AuthUsername = user) and (req.AuthPassword = pass);

  if not Result then
  begin
    res.ResponseNo := 401;
    LogLastRequest(req);
    LogLastResponse(res);
    res.AuthRealm := res.ResponseText;
  end;
end;

procedure TF_Principal.FormCreate(Sender: TObject);
begin
  cli := TCliente.Create(Self);
end;

procedure TF_Principal.FormDestroy(Sender: TObject);
begin
  cli.Free;
end;

procedure TF_Principal.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if CheckAuthentication(ARequestInfo, AResponseInfo) then
    if ARequestInfo.CommandType in [hcGET, hcPOST] then
    begin
      LogLastRequest(ARequestInfo);
      case ARequestInfo.CommandType of
        hcGET:
          GetClientes(ARequestInfo, AResponseInfo);
        hcPOST:
          InsertCliente(ARequestInfo, AResponseInfo);
      end;
      LogLastResponse(AResponseInfo);
      AResponseInfo.WriteContent;
    end;
end;

procedure TF_Principal.IdHTTPServer1CommandOther(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if CheckAuthentication(ARequestInfo, AResponseInfo) then
    if ARequestInfo.CommandType in [hcPUT, hcDELETE] then
    begin
      LogLastRequest(ARequestInfo);
      case ARequestInfo.CommandType of
        hcPUT:
          UpdateCliente(ARequestInfo, AResponseInfo);
        hcDELETE:
          DeleteCliente(ARequestInfo, AResponseInfo);
      end;
      LogLastResponse(AResponseInfo);
      AResponseInfo.WriteContent;
    end;
end;

procedure TF_Principal.GetClientes(req: TIdHTTPRequestInfo;
  res: TIdHTTPResponseInfo);
var
  i, id: Integer;
  st: TStrings;
  ret, erro: String;
begin
  st := TStringList.Create;
  try
    if req.Params.Count > 0 then
    begin
      for i := 0 to req.Params.Count -1 do
      begin
        if i = 0 then
          st.Add(Format('where %s = %s', [GetValueBefore(req.Params[i], '='),
                                          QuotedStr(GetValueAfter(req.Params[i], '='))]))
        else
          st.Add(Format('and %s = %s', [GetValueBefore(req.Params[i], '='),
                                        QuotedStr(GetValueAfter(req.Params[i], '='))]))
      end;
    end
    else if req.URI <> '/' then
    begin
      if TryStrToInt(GetValueAfter(req.URI, '/'), id) then
        st.Add(Format('where id = %d', [id]));
    end;

    ret := cli.Buscar(st, erro);

    if erro = EmptyStr then
    begin
      res.ContentText := ret;
      res.ResponseNo  := 200;
    end
    else
    begin
      res.ContentText := erro;
      res.ResponseNo  := 500;
    end;
  finally
    st.Free;
  end;
end;

procedure TF_Principal.InsertCliente(req: TIdHTTPRequestInfo;
  res: TIdHTTPResponseInfo);
var
  st: TStringStream;
  jsObj: TJSONObject;
  erro: String;
begin
  st := TStringStream.Create(EmptyStr, TEncoding.UTF8);
  st.CopyFrom(req.PostStream, req.PostStream.Size);

  jsObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(st.DataString),0) as TJSONObject;

  cli.nome     := GetJsonValue(jsObj, 'nome');
  cli.endereco := GetJsonValue(jsObj, 'endereco');
  cli.telefone := GetJsonValue(jsObj, 'telefone');
  cli.celular  := GetJsonValue(jsObj, 'celular');
  cli.cidade   := GetJsonValue(jsObj, 'cidade');
  cli.estado   := GetJsonValue(jsObj, 'estado');
  cli.ativo    := Boolean(StrToIntDef(GetJsonValue(jsObj, 'ativo'), 0));
  cli.saldo    := StrToFloatDef(GetJsonValue(jsObj, 'saldo'), 0);

  if cli.Incluir(erro) then
  begin
    jsObj.AddPair('id', TJSONNumber.Create(cli.id));
    res.ContentText := jsObj.ToJSON;
    res.ResponseNo  := 201;
  end
  else
  begin
    res.ContentText := erro;
    res.ResponseNo  := 500;
  end;

  st.Free;
  jsObj.Free;
end;

procedure TF_Principal.UpdateCliente(req: TIdHTTPRequestInfo;
  res: TIdHTTPResponseInfo);
var
  st: TStringStream;
  jsObj: TJSONObject;
  erro: String;
  id: Integer;
begin
  if req.URI <> '/' then
  begin
    if TryStrToInt(GetValueAfter(req.URI, '/'), id) then
    begin
      cli.id := id;

      st := TStringStream.Create(EmptyStr, TEncoding.UTF8);
      st.CopyFrom(req.PostStream, req.PostStream.Size);

      jsObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(st.DataString),0) as TJSONObject;

      cli.id       := id;
      cli.nome     := GetJsonValue(jsObj, 'nome');
      cli.endereco := GetJsonValue(jsObj, 'endereco');
      cli.telefone := GetJsonValue(jsObj, 'telefone');
      cli.celular  := GetJsonValue(jsObj, 'celular');
      cli.cidade   := GetJsonValue(jsObj, 'cidade');
      cli.estado   := GetJsonValue(jsObj, 'estado');
      cli.ativo    := Boolean(StrToIntDef(GetJsonValue(jsObj, 'ativo'), 0));
      cli.saldo    := StrToFloatDef(GetJsonValue(jsObj, 'saldo'), 0);

      if cli.Alterar(erro) then
      begin
        jsObj.AddPair('id', TJSONNumber.Create(cli.id));
        res.ContentText := jsObj.ToJSON;
        res.ResponseNo  := 200;
      end
      else
      begin
        res.ContentText := erro;
        res.ResponseNo  := 500;
      end;

      st.Free;
      jsObj.Free;
    end
    else
    begin
      res.ResponseNo  := 403;
      res.ContentText := res.ResponseText;
    end;
  end
  else
  begin
    res.ResponseNo  := 403;
    res.ContentText := res.ResponseText;
  end;
end;

procedure TF_Principal.DeleteCliente(req: TIdHTTPRequestInfo;
  res: TIdHTTPResponseInfo);
var
  id: Integer;
  erro: String;
begin
  if req.URI <> '/' then
  begin
    if TryStrToInt(GetValueAfter(req.URI, '/'), id) then
    begin
      cli.id := id;
      if cli.Excluir(erro) then
        res.ResponseNo := 204
      else
      begin
        res.ContentText := erro;
        res.ResponseNo  := 500;
      end;
    end
    else
    begin
      res.ResponseNo  := 403;
      res.ContentText := res.ResponseText;
    end;
  end
  else
  begin
    res.ResponseNo  := 403;
    res.ContentText := res.ResponseText;
  end;
end;

procedure TF_Principal.LogLastRequest(req: TIdHTTPRequestInfo);
begin
  memLogReq.Lines.Add(Trim(req.UserAgent + sLineBreak +
                           req.RawHTTPCommand));
end;

procedure TF_Principal.LogLastResponse(res: TIdHTTPResponseInfo);
begin
  memLogRes.Lines.Add(Trim('status: '+ res.ResponseNo.ToString +' ('+
                           res.ResponseText +')' + sLineBreak +
                           res.ContentText));
end;

end.
