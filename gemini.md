# Análise do Projeto SSE-Client

## Visão Geral

Este projeto consiste em uma aplicação cliente-servidor que demonstra o uso de Server-Sent Events (SSE). O servidor é implementado em PHP e envia a hora atual a cada segundo para o cliente. O cliente é uma aplicação de console Delphi que se conecta ao servidor para receber e exibir esses eventos.

## Estrutura de Arquivos

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

## Análise dos Componentes

### Servidor (PHP)

-   **`servidor/sse.php`**:
    -   **Função**: Atua como a fonte de eventos SSE.
    -   **Implementação**:
        -   Define os cabeçalhos HTTP necessários para uma conexão SSE (`Content-Type: text/event-stream`, `Cache-Control: no-cache`, `Connection: keep-alive`).
        -   Desativa o buffering de saída para garantir que os eventos sejam enviados imediatamente.
        -   Entra em um loop infinito, enviando a hora atual (`HH:MM:SS`) a cada segundo para o cliente.
        -   O evento é nomeado como `horario`.

-   **`servidor/index.php`**:
    -   **Função**: Uma página HTML para testar o servidor SSE diretamente no navegador.
    -   **Implementação**:
        -   Utiliza a API `EventSource` do JavaScript para se conectar ao `sse.php`.
        -   Escuta o evento `horario` e exibe os dados recebidos em um elemento `<output>` na página.

### Cliente (Delphi)

-   **`client/ssecliente.dpr`**:
    -   **Função**: Uma aplicação de console que se conecta ao servidor SSE e exibe os eventos recebidos.
    -   **Implementação**:
        -   Utiliza a biblioteca **Indy** (`TIdHTTP`) para a comunicação HTTP.
        -   **Classe `TIndySSEClient`**:
            -   Encapsula a lógica de conexão e manipulação de eventos SSE.
            -   Usa `TIdSSLIOHandlerSocketOpenSSL` para suportar conexões HTTPS, configurado para TLS 1.2. A verificação do certificado está desabilitada (`VerifyMode := []`), o que é uma prática insegura para produção.
            -   O método `Connect` utiliza `IdHTTP.Get` com um `TIdEventStream` para processar o fluxo de eventos.
            -   O evento `OnWrite` do `TIdEventStream` é usado para processar e exibir os dados recebidos do servidor.
        -   O programa principal cria uma instância de `TIndySSEClient`, conecta-se à URL `https://sse.zambeta.site/sse.php` e aguarda a entrada do usuário para encerrar.
    -   **Dependências**:
        -   **Indy**: Biblioteca de componentes de rede para Delphi.
        -   **OpenSSL**: As DLLs `libeay32.dll` e `ssleay32.dll` são necessárias para o suporte a SSL/TLS.

## Pontos de Melhoria

1.  **Segurança do Cliente Delphi**: A verificação do certificado SSL está desativada no cliente (`SSLHandler.SSLOptions.VerifyMode := []`). Em um ambiente de produção, isso deve ser alterado para verificar a validade do certificado do servidor para evitar ataques man-in-the-middle.
2.  **Tratamento de Erros**: O tratamento de erros pode ser aprimorado tanto no cliente quanto no servidor para lidar com desconexões e outros problemas de rede de forma mais robusta.
3.  **Configuração da URL**: A URL do servidor SSE está hardcoded no cliente Delphi. Seria melhor movê-la para um arquivo de configuração ou passá-la como um argumento de linha de comando.
