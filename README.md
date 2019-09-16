# crudREST
Restful desenvolvido em Delphi usando os principais verbos HTTP (POST, GET, PUT, DELETE)

Utiliza banco de dados SQLite local para realizar as operações

Desenvolvido no Delphi 10.3 Rio Community Edition (não há garantia de compatibilidade com versões anteriores do Delphi)

Para o server, utiliza o componente TIdHTTPServer (Indy), nativo do Delphi

Para o client, utiliza os componentes TRESTClient, TRESTRequest e TRESTResponse, também nativos do Delphi (a partir da versão XE5, se não me engano)

Utiliza modelo de autenticação básica (user+pass)

*depois de coompilados os projetos (client e server), basta executar o server e clicar no botão "iniciar", que o client já conseguirá comunicação*
