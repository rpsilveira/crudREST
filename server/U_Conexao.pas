unit U_Conexao;

interface

uses System.Classes, Vcl.Forms, System.SysUtils, FireDAC.Comp.Client,
  FireDAC.Stan.Def, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI;

type
  TConexao = class(TComponent)
  private
    { private declarations }
    FConexao: TFDConnection;
    class var FInstance: TConexao;
    function GetConexao: TFDConnection;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(AWoner: TComponent); override;
    destructor Destroy; override;

    property Conexao: TFDConnection read GetConexao;

    class function GetInstance: TConexao;
  end;

implementation

{ TConexao }

constructor TConexao.Create(AWoner: TComponent);
begin
  inherited Create(AWoner);
  FConexao := TFDConnection.Create(Self);
  try
    FConexao.LoginPrompt     := False;
    FConexao.DriverName      := 'SQLite';
    FConexao.Params.Database := 'database.db';
    FConexao.Connected := True;
  except on E: Exception do
    raise Exception.CreateFmt('Erro ao conectar com o banco de dados: %s', [E.Message]);
  end;
end;

destructor TConexao.Destroy;
begin
  FConexao.Free;
  inherited;
end;

function TConexao.GetConexao: TFDConnection;
begin
  Result := FConexao;
end;

class function TConexao.GetInstance: TConexao;
begin
  if not Assigned(FInstance) then
    FInstance := TConexao.Create(Application);
  Result := FInstance;
end;

end.
