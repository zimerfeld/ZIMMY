# Gera o .exe do Zimmy (export release "Windows Desktop") quando algum arquivo-fonte
# do projeto (.gd/.tscn/.json) for mais novo que o .exe atual. Pula o build se nada
# mudou. Disparado pelo Stop hook em .claude/settings.json.
$ErrorActionPreference = 'Stop'

$proj  = 'C:\GODOT\ZIMMY'
$exe   = Join-Path $proj 'build\ZimmyPet.exe'
$godot = 'C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe'

# Fontes do projeto: .gd/.tscn/.json, ignorando caches/saídas que não definem o app.
$exclude = @('\.godot\', '\build\', '\.claude\', '\OBSIDIAN\')
$files = Get-ChildItem -Path $proj -Recurse -File -Include *.gd, *.tscn, *.json -ErrorAction SilentlyContinue |
  Where-Object { $p = $_.FullName; -not ($exclude | Where-Object { $p -like "*$_*" }) }

$needsBuild = $true
if (Test-Path $exe) {
  $exeTime = (Get-Item $exe).LastWriteTime
  $newer = $files | Where-Object { $_.LastWriteTime -gt $exeTime } | Select-Object -First 1
  if (-not $newer) {
    $needsBuild = $false
    Write-Output 'Build pulado: nenhum .gd/.tscn/.json mudou desde o ultimo ZimmyPet.exe.'
  }
}

if ($needsBuild) {
  Write-Output 'Gerando build/ZimmyPet.exe...'
  & $godot --headless --path $proj --export-release 'Windows Desktop' $exe
  if ($LASTEXITCODE -ne 0) {
    Write-Output "Export FALHOU (exit $LASTEXITCODE)."
    exit 0   # nao bloqueia o Stop do agente; apenas reporta
  }
  Write-Output 'build/ZimmyPet.exe gerado.'
}
