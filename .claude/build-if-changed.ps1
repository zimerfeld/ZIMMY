# Gera o .exe do Zimmy (export release "Windows Desktop") quando algum arquivo-fonte
# do projeto (.gd/.tscn/.json/.godot/.cfg) for mais novo que o .exe atual. Pula o build
# se nada mudou. Disparado pelo Stop hook em .claude/settings.json.
$ErrorActionPreference = 'Stop'

$proj  = 'C:\GODOT\ZIMMY'
$exe   = Join-Path $proj 'build\ZimmyPet.exe'
$godot = 'C:\GODOT\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe'

# Fontes do projeto: .gd/.tscn/.json + config (project.godot, export_presets.cfg),
# ignorando caches/saídas que não definem o app.
# Nota: o cofre Obsidian foi renomeado de OBSIDIAN\ para ZIMMY\ (nome do projeto).
# Como o projeto raiz tambem e ...\ZIMMY, exclui-se o caminho aninhado \ZIMMY\ZIMMY\
# para nao excluir os fontes do proprio projeto.
$exclude = @('\.godot\', '\build\', '\.claude\', '\ZIMMY\ZIMMY\')
$files = Get-ChildItem -Path $proj -Recurse -File -Include *.gd, *.tscn, *.json, *.godot, *.cfg -ErrorAction SilentlyContinue |
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
  # Fecha qualquer instância em execução antes de exportar, senão o .exe fica
  # "locked by a running instance" e o rename do arquivo temporário falha.
  Get-Process -Name ZimmyPet -ErrorAction SilentlyContinue | Stop-Process -Force
  Start-Sleep -Milliseconds 300
  Remove-Item (Join-Path $proj 'build\ZimmyPet.tmp') -Force -ErrorAction SilentlyContinue

  Write-Output 'Gerando build/ZimmyPet.exe...'
  & $godot --headless --path $proj --export-release 'Windows Desktop' $exe
  if ($LASTEXITCODE -ne 0) {
    Write-Output "Export FALHOU (exit $LASTEXITCODE)."
    exit 0   # nao bloqueia o Stop do agente; apenas reporta
  }
  Write-Output 'build/ZimmyPet.exe gerado.'
}
