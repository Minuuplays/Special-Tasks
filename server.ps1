$listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Any, 7000)
$listener.Start()
Write-Host "Server is waiting..."

$client = $listener.AcceptTcpClient()
$stream = $client.GetStream()
$reader = [IO.StreamReader]::new($stream)
$writer = [IO.StreamWriter]::new($stream)
$writer.AutoFlush = $true

$line = $reader.ReadLine()
Write-Host "Received: $line"
$sorted = $line -split '\s+' | ForEach-Object { [double]$_ } | Sort-Object
$writer.WriteLine($sorted -join ' ')

$client.Close()
$listener.Stop()