$c = [Net.Sockets.TcpClient]::new('127.0.0.1', 7000)
$stream = $c.GetStream()
$w = [IO.StreamWriter]::new($stream)
$w.AutoFlush = $true
$r = [IO.StreamReader]::new($stream)

$data = '5 3 9 1 22 10 2.5'

Write-Host "Sent   : $data"
$w.WriteLine($data)

$result = $r.ReadLine()
Write-Host "Sorted : $result"

$c.Close()