program CadastroClientesInfo;

uses
  Vcl.Forms,
  uPrincipal in 'Telas\uPrincipal.pas' {FCadastroClientes},
  uBiblioteca in 'Biblioteca\uBiblioteca.pas',
  uViaCep in 'Biblioteca\uViaCep.pas',
  uSMTP in 'Biblioteca\uSMTP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFCadastroClientes, FCadastroClientes);
  Application.Run;
end.
