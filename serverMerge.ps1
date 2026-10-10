# ---------- Merge sort ----------
function MergeSort([double[]]$a) {
    # Base case: 0 or 1 items is already sorted
    if ($a.Length -le 1) { return ,$a }

    # Split into two halves
    $mid   = [int][math]::Floor($a.Length / 2)
    $left  = [double[]](MergeSort ([double[]]$a[0..($mid-1)]))
    $right = [double[]](MergeSort ([double[]]$a[$mid..($a.Length-1)]))

    # Merge the two sorted halves
    $result = New-Object 'System.Collections.Generic.List[double]'
    $i = 0
    $j = 0
    while ($i -lt $left.Length -and $j -lt $right.Length) {
        if ($left[$i] -le $right[$j]) { $result.Add($left[$i]); $i++ }
        else                          { $result.Add($right[$j]); $j++ }
    }
    while ($i -lt $left.Length)  { $result.Add($left[$i]);  $i++ }
    while ($j -lt $right.Length) { $result.Add($right[$j]); $j++ }

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
$sorted = MergeSort $nums

Write-Host "Sorted with merge sort: $($sorted -join ' ')"
$writer.WriteLine($sorted -join ' ')

$client.Close()
$listener.Stop()