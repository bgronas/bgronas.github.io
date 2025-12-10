# rename-images-and-fix-md.ps1
# Kjører i roten av artikkelmappen: endrer bilde-filer + oppdaterer .md for referanser

param(
  [string] $Root = "."   # Rotmappe; standard: gjeldende mappe
)

# Steg 1: Bytt navn på bildefiler (jpg, jpeg, png, gif) — erstatt mellomrom med bindestrek
Get-ChildItem -Path $Root -Recurse -File -Include *.jpg,*.jpeg,*.png,*.gif | ForEach-Object {
    $old = $_.FullName
    $newName = $_.Name -replace " ", "-"  # erstatt spaces
    if ($newName -ne $_.Name) {
        $new = Join-Path $_.DirectoryName $newName
        Rename-Item -Path $old -NewName $newName
        Write-Host "Renamed file: '$old' -> '$new'"
    }
}

# Steg 2: Oppdater referanser i .md-filer — erstatt gamle filnavn med nye
Get-ChildItem -Path $Root -Recurse -File -Include *.md | ForEach-Object {
    $path = $_.FullName
    (Get-Content $path) |
      ForEach-Object {
        $line = $_
        # finn markdown img eller html img med filnavn med space → erstatt med bindestrek
        $line -replace '(["\(])([^"\)]+) ([^"\)\.]+\.(jpg|jpeg|png|gif))', {
          param($m)
          $prefix = $m.Groups[1].Value
          $before = $m.Groups[2].Value
          $filename = $m.Groups[3].Value
          $fixed = $filename -replace ' ', '-'
          return "$prefix$before $fixed"
        }
      } | Set-Content $path -Encoding UTF8
    Write-Host "Processed markdown: $path"
}

Write-Host "Done — all images renamed, markdown updated."
