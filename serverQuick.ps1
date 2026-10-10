# ---------- Quick sort ----------
function QuickSort([double[]]$a) {
    # Base case: 0 or 1 items is already sorted
    if ($a.Length -le 1) { return ,$a }

    # Pick the middle item as the pivot
    $pivot = $a[[int][math]::Floor($a.Length / 2)]

    # Split everything into three groups
    $less    = New-Object 'System.Collections.Generic.List[double]'
    $equal   = New-Object 'System.Collections.Generic.List[double]'
    $greater = New-Object 'System.Collections.Generic.List[double]'

    foreach ($x in $a) {
        if     ($x -lt $pivot) { $less.Add($x) }
        elseif ($x -gt $pivot) { $greater.Add($x) }
        else                   { $equal.Add($x) }
    }

    # Sort the small and big groups, then glue: less + equal + greater
    $l = [double[]](QuickSort ($less.ToArray()))
    $g = [double[]](QuickSort ($greater.ToArray()))

    $result = New-Object 'System.Collections.Generic.List[double]'
    $result.AddRange($l)
    $result.AddRange($equal)
    $result.AddRange($g)

    return ,$result.ToArray()
}

# ---------- Server ----------
$listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Any, 7000)
$listener.Start()
Write-Host "Server is waiting..."

$client = $listener.AcceptTcpClient()
$stream = $client.GetStream()
$reader = [IO.StreamReader]::new($stream)
$writer = [IO.StreamWriter]::new($stream)
$writer.AutoFlush = $true

$line = $reader.ReadLine()
Write-Host "Received (unsorted): $line"

$nums   = [double[]]($line -split '\s+' | Where-Object { $_ -ne '' })
$sorted = QuickSort $nums

Write-Host "Sorted with quick sort: $($sorted -join ' ')"
$writer.WriteLine($sorted -join ' ')

$client.Close()
$listener.Stop()