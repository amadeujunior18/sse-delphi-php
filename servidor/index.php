<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="utf-8">
  <title>SSE Test</title>
</head>
<body>
  Horário: <output id="sse"></output>

  <script>
    const eventSource = new EventSource('/sse.php');

    eventSource.addEventListener('horario', e => {
      console.log('recebido:', e.data);
      document.getElementById('sse').innerText = e.data;
    });

    eventSource.addEventListener('error', e => {
      console.error('EventSource error', e);
    });
  </script>
</body>
</html>
