# Projeto Cliente-Servidor SSE (Server-Sent Events)

Este projeto é uma demonstração de uma aplicação cliente-servidor que utiliza Server-Sent Events (SSE) para comunicação em tempo real. O servidor, implementado em PHP, envia a hora atual a cada segundo para um cliente de console feito em Delphi.

## Visão Geral

-   **Servidor**: Uma aplicação PHP que atua como um *event source*, enviando eventos contínuos para os clientes conectados.
-   **Cliente**: Uma aplicação de console Delphi que se conecta ao servidor para receber e exibir os eventos em tempo real.

## Estrutura do Projeto

```
sse-client/
├───client/
│   ├───libeay32.dll
│   ├───ssecliente.dpr
│   ├───ssecliente.dproj
│   ├───ssecliente.exe
│   └───ssleay32.dll
└───servidor/
    ├───index.php
    └───sse.php
```

## Componentes

### Servidor (PHP)

-   `servidor/sse.php`: O endpoint principal do SSE. Ele envia a hora atual (`HH:MM:SS`) a cada segundo, em um evento chamado `horario`.
-   `servidor/index.php`: Uma página HTML simples para testar o servidor SSE diretamente no navegador. Ela usa a API `EventSource` do JavaScript para se conectar e exibir os eventos.

### Cliente (Delphi)

-   `client/ssecliente.dpr`: O código-fonte da aplicação de console.
-   `client/ssecliente.exe`: O executável pré-compilado do cliente.
-   `client/libeay32.dll` e `ssleay32.dll`: Dependências OpenSSL necessárias para a comunicação HTTPS.

## Como Executar

### 1. Servidor

Para executar o servidor, você precisará de um ambiente com PHP (como XAMPP, Wamp, ou um servidor web com PHP instalado).

1.  Copie o conteúdo da pasta `servidor/` para o diretório raiz do seu servidor web (ex: `htdocs` no XAMPP).
2.  Inicie o seu servidor web (ex: Apache).
3.  O *endpoint* de eventos estará disponível em `http://localhost/sse.php`.
4.  Você pode testar o servidor acessando `http://localhost/index.php` em seu navegador.

### 2. Cliente

O cliente é uma aplicação de console e já está compilado.

1.  Navegue até a pasta `client/`.
2.  Execute o arquivo `ssecliente.exe`.
3.  O console começará a exibir a hora recebida do servidor público `https://sse.zambeta.site/sse.php`.

**Nota**: Para compilar o projeto Delphi (`ssecliente.dpr`), você precisará do Delphi com a biblioteca **Indy** (Internet Direct) instalada.

## Dependências

-   **Servidor**: PHP
-   **Cliente**:
    -   Biblioteca Indy (para compilação)
    -   OpenSSL (as DLLs `libeay32.dll` e `ssleay32.dll` já estão incluídas)

## Pontos de Melhoria

1.  **Segurança do Cliente**: A verificação do certificado SSL está desativada no cliente Delphi por simplicidade. Em um ambiente de produção, isso é inseguro e deve ser corrigido para validar o certificado do servidor.
2.  **Configuração da URL**: A URL do servidor (`https://sse.zambeta.site/sse.php`) está fixa no código do cliente. O ideal seria movê-la para um arquivo de configuração externo.
3.  **Tratamento de Erros**: O tratamento de erros poderia ser mais robusto para lidar com falhas de conexão ou desconexões inesperadas.