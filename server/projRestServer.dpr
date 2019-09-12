program projRestServer;

uses
  Vcl.Forms,
  U_Principal in 'U_Principal.pas' {F_Principal},
  U_Conexao in 'U_Conexao.pas',
  U_Utilitarios in 'U_Utilitarios.pas',
  U_Clientes in 'U_Clientes.pas',
  U_BaseControl in 'U_BaseControl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TF_Principal, F_Principal);
  Application.Run;
end.
