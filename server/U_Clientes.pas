unit U_Clientes;

interface

uses
  U_BaseControl, System.SysUtils, System.Classes;

type
  TCliente = class(TBaseControl)
  private
    Fativo: Boolean;
    Fid: Integer;
    Fsaldo: Double;
    Fnome: String;
    Fcidade: String;
    Fendereco: String;
    Festado: String;
    Ftelefone: String;
    Fcelular: String;
    procedure Setativo(const Value: Boolean);
    procedure Setcelular(const Value: String);
    procedure Setcidade(const Value: String);
    procedure Setendereco(const Value: String);
    procedure Setestado(const Value: String);
    procedure Setnome(const Value: String);
    procedure Setsaldo(const Value: Double);
    procedure Settelefone(const Value: String);
    procedure Setid(const Value: Integer);
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    property id: Integer read Fid write Setid;
    property nome: String read Fnome write Setnome;
    property endereco: String read Fendereco write Setendereco;
    property telefone: String read Ftelefone write Settelefone;
    property celular: String read Fcelular write Setcelular;
    property cidade: String read Fcidade write Setcidade;
    property estado: String read Festado write Setestado;
    property ativo: Boolean read Fativo write Setativo;
    property saldo: Double read Fsaldo write Setsaldo;

    function Incluir(out Err: String): Boolean;
    function Alterar(out Err: String): Boolean;
    function Excluir(out Err: String): Boolean;
    function Buscar(pParams: TStrings; out Err: String): String;
  end;

implementation

{ TCliente }

uses U_Utilitarios;

function TCliente.Incluir(out Err: String): Boolean;
begin
  Result := False;
  Err := '';
  try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('insert into TB_CLIENTES( ');
    Query.SQL.Add('  nome, ');
    Query.SQL.Add('  endereco, ');
    Query.SQL.Add('  telefone, ');
    Query.SQL.Add('  celular, ');
    Query.SQL.Add('  cidade, ');
    Query.SQL.Add('  estado, ');
    Query.SQL.Add('  ativo, ');
    Query.SQL.Add('  saldo) ');
    Query.SQL.Add('values( ');
    Query.SQL.Add(Format('%s, ', [QuotedStr(Fnome)]));
    Query.SQL.Add(Format('%s, ', [QuotedStr(Fendereco)]));
    Query.SQL.Add(Format('%s, ', [QuotedStr(Ftelefone)]));
    Query.SQL.Add(Format('%s, ', [QuotedStr(Fcelular)]));
    Query.SQL.Add(Format('%s, ', [QuotedStr(Fcidade)]));
    Query.SQL.Add(Format('%s, ', [QuotedStr(Festado)]));
    Query.SQL.Add(Format('%d, ', [Integer(Fativo)]));
    Query.SQL.Add(Format('%s);', [FloatToSQL(Fsaldo)]));
    Query.ExecSQL;

    id := GetLastID;

    Result := Query.RowsAffected > 0;

    if not Result then
      Err := 'Não foi possível incluir o cliente. Por favor, tente novamente';
  except on E: Exception do
    Err := Format('Erro ao incluir o cliente: %s', [E.message]);
  end;
end;

function TCliente.Alterar(out Err: String): Boolean;
begin
  Result := False;
  Err := '';
  try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update TB_CLIENTES set ');
    Query.SQL.Add(Format('  nome = %s, ', [QuotedStr(Fnome)]));
    Query.SQL.Add(Format('  endereco = %s, ', [QuotedStr(Fendereco)]));
    Query.SQL.Add(Format('  telefone = %s, ', [QuotedStr(Ftelefone)]));
    Query.SQL.Add(Format('  celular = %s, ', [QuotedStr(Fcelular)]));
    Query.SQL.Add(Format('  cidade = %s, ', [QuotedStr(Fcidade)]));
    Query.SQL.Add(Format('  estado = %s, ', [QuotedStr(Festado)]));
    Query.SQL.Add(Format('  ativo = %d, ', [Integer(Fativo)]));
    Query.SQL.Add(Format('  saldo = %s ', [FloatToSQL(Fsaldo)]));
    Query.SQL.Add(Format('where id = %d;', [Fid]));
    Query.ExecSQL;

    Result := Query.RowsAffected > 0;

    if not Result then
      Err := 'Não foi possível alterar o cliente. Por favor, tente novamente';
  except on E: Exception do
    Err := Format('Erro ao incluir o cliente: %s', [E.message]);
  end;
end;

function TCliente.Excluir(out Err: String): Boolean;
begin
  Result := False;
  Err := '';
  try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('delete from TB_CLIENTES ');
    Query.SQL.Add(Format('where id = %d;', [Fid]));
    Query.ExecSQL;

    Result := Query.RowsAffected > 0;

    if not Result then
      Err := 'Não foi possível excluir o cliente. Por favor, tente novamente';
  except on E: Exception do
    Err := Format('Erro ao incluir o cliente: %s', [E.message]);
  end;
end;

function TCliente.Buscar(pParams: TStrings; out Err: String): String;
var
  s: String;
begin
  Query.Close;
  Query.SQL.Text := 'select * from TB_CLIENTES';

  try
    for s in pParams do
      Query.SQL.Add(s);

    Query.SQL.Add('order by id limit 50');
    Query.Open;

    Result := DatasetToJson(Query);
  except on E: Exception do
    Err := Format('Erro ao buscar o(s) cliente(s): %s', [E.message]);
  end;
end;

procedure TCliente.Setativo(const Value: Boolean);
begin
  Fativo := Value;
end;

procedure TCliente.Setcelular(const Value: String);
begin
  Fcelular := Value;
end;

procedure TCliente.Setcidade(const Value: String);
begin
  Fcidade := Value;
end;

procedure TCliente.Setendereco(const Value: String);
begin
  Fendereco := Value;
end;

procedure TCliente.Setestado(const Value: String);
begin
  Festado := Value;
end;

procedure TCliente.Setid(const Value: Integer);
begin
  Fid := Value;
end;

procedure TCliente.Setnome(const Value: String);
begin
  Fnome := Value;
end;

procedure TCliente.Setsaldo(const Value: Double);
begin
  Fsaldo := Value;
end;

procedure TCliente.Settelefone(const Value: String);
begin
  Ftelefone := Value;
end;

end.
