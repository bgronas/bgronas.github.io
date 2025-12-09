# Konverter-til-UTF8.ps1 — konverterer tekstfiler til UTF-8 uten BOM

$extensions = "toml","md","html","css","js","json"

Get-ChildItem -Recurse | Where-Object { $extensions -contains $_.Extension.TrimStart('.') } | ForEach-Object {
    $file = $_.FullName
    Write-Host "Processing $file"
    $content = Get-Content -Raw -Path $file
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [IO.File]::WriteAllLines($file, $content, $utf8)
}
Write-Host "Done."
