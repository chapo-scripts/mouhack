$resourceDir = $PSScriptRoot
$b2cExe = "$resourceDir\..\..\..\..\b2c_lua.exe"

if (-not (Test-Path $b2cExe)) {
    Write-Error "b2c_lua.exe not found at $b2cExe"
    exit 1
}

$fontFiles = @("Regular.ttf", "Medium.ttf", "Bold.ttf")
$entries = @{}

foreach ($fname in $fontFiles) {
    $fullPath = Join-Path $resourceDir $fname
    if (-not (Test-Path $fullPath)) {
        Write-Warning "File $fname not found, skipping"
        continue
    }
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fname)
    $name = (Get-Culture).TextInfo.ToTitleCase($baseName.ToLower())
    Write-Host "Processing $name ..."

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $b2cExe
    $startInfo.Arguments = "-base85 `"$fullPath`" result"
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardOutput = $true
    $startInfo.CreateNoWindow = $true
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    $process.Start() | Out-Null
    $output = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()

    if ($output -match 'result_compressed_data_base85\s*=\s*"([^"]*)"') {
        $data = $matches[1]
    } else {
        Write-Warning "Could not extract data from $fname"
        $data = ""
    }
    $entries[$name] = $data
}

$lines = @()
$lines += "return {"
$keys = $entries.Keys | Sort-Object
$count = $keys.Count
$i = 0
foreach ($key in $keys) {
    $i++
    $comma = if ($i -eq $count) { "" } else { "," }
    $lines += "    $key = `"$($entries[$key])`"$comma"
}
$lines += "}"
$outputFile = Join-Path $resourceDir "fonts.lua"
$lines -join "`r`n" | Out-File -FilePath $outputFile -Encoding utf8
Write-Host "Fonts compiled to $outputFile"
exit 0