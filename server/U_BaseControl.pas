unit U_BaseControl;

interface

uses
  System.Classes, FireDAC.Comp.Client, System.SysUtils;

type
  TBaseControl = class(TComponent)
  private
    { private declarations }
    FQuery: TFDQuery;
    function GetQuery: TFDQuery;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetLastID: Int64;

    property Query: TFDQuery read GetQuery;
  end;

implementation

{ TBaseControl }

uses U_Conexao;

constructor TBaseControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQuery := TFDQuery.Create(Self);
  FQuery.Connection := TConexao.GetInstance.Conexao;
end;

destructor TBaseControl.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TBaseControl.GetLastID: Int64;
begin
  Result := Int64(TConexao.GetInstance.Conexao.GetLastAutoGenValue(''));
end;

function TBaseControl.GetQuery: TFDQuery;
begin
  Result := FQuery;
end;

end.
