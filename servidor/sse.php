<?php
declare(strict_types=1);

// evita timeout
set_time_limit(0);

// headers obrigatórios para SSE
header('Content-Type: text/event-stream');
header('Cache-Control: no-cache');           // sem cache
header('Connection: keep-alive');            // mantém conexão
header('X-Accel-Buffering: no');             // para Nginx (desabilita buffering do proxy)

// desativa compressão do PHP (se aplicável)
@ini_set('zlib.output_compression', '0');
@ini_set('output_buffering', '0');

// limpa buffers do PHP para forçar envio
while (ob_get_level() > 0) {
    @ob_end_flush();
}
ob_implicit_flush(true);

// loop de exemplo — envia hora a cada 1s
$lastSent = null;
while (true) {
    // montar payload
    $hora = date('H:i:s');

    // evitar enviar valor repetido (opcional)
    if ($hora !== $lastSent) {
        echo "event: horario\n";
        echo "data: " . $hora . "\n\n";

        // força envio para cliente
        @flush();
        @ob_flush();

        $lastSent = $hora;
    }

    sleep(1);
}
