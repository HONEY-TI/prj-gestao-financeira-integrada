<#
.SYNOPSIS
    Adiciona qualquer pasta a uma solution (.sln ou .slnx).

.DESCRIPTION
    Varre a pasta informada de forma recursiva e adiciona seus arquivos
    como Solution Folder. Detecta o formato da solution automaticamente
    (.slnx tem prioridade sobre .sln) e cria um backup (.bak) antes de alterar.

.PARAMETER Folder
    Alias: -f. Pasta a ser adicionada (relativa a solution ou absoluta).

.PARAMETER Solution
    Alias: -s. Caminho da solution. Se omitido, usa a da pasta atual.

.PARAMETER Help
    Alias: -h. Mostra a ajuda.

.EXAMPLE
    .\add-folder-to-sln.ps1 -f .devcontainer

.EXAMPLE
    .\add-folder-to-sln.ps1 -f docs -s .\MinhaSolution.slnx
#>
param(
    [Alias('f', 'Pasta')][string]$Folder,
    [Alias('s')][string]$Solution,
    [Alias('h')][switch]$Help
)

$ErrorActionPreference = 'Stop'

function Show-Help {
    Write-Host ""
    Write-Host "add-folder-to-sln.ps1" -ForegroundColor Cyan
    Write-Host "  Adiciona uma pasta a uma solution (.sln ou .slnx)."
    Write-Host ""
    Write-Host "USO" -ForegroundColor Yellow
    Write-Host "  .\add-folder-to-sln.ps1 -f <pasta> [-s <solution>] [-h]"
    Write-Host ""
    Write-Host "PARAMETROS" -ForegroundColor Yellow
    Write-Host "  -f, -Folder    Pasta a adicionar (relativa a solution ou absoluta). Obrigatorio."
    Write-Host "  -s, -Solution  Caminho da solution. Padrao: .slnx/.sln da pasta atual."
    Write-Host "  -h, -Help      Mostra esta ajuda."
    Write-Host ""
    Write-Host "EXEMPLOS" -ForegroundColor Yellow
    Write-Host "  .\add-folder-to-sln.ps1 -f .devcontainer"
    Write-Host "  .\add-folder-to-sln.ps1 -f migrations"
    Write-Host "  .\add-folder-to-sln.ps1 -f scripts -s .\MinhaSolution.slnx"
    Write-Host ""
    Write-Host "OBSERVACOES" -ForegroundColor Yellow
    Write-Host "  - A pasta precisa estar dentro do diretorio da solution."
    Write-Host "  - Evite bin, obj, node_modules e .git."
    Write-Host "  - Um backup (.bak) e criado antes de alterar a solution."
    Write-Host ""
}

# Ajuda
if ($Help) { Show-Help; exit 0 }

# Parametro obrigatorio
if (-not $Folder) {
    Write-Warning "O parametro -f (pasta) e obrigatorio."
    Show-Help
    exit 1
}

# Localiza a solution (.slnx tem prioridade)
if ($Solution) {
    $solutionPath = (Resolve-Path $Solution).Path
}
else {
    $found = Get-ChildItem -Path . -File |
        Where-Object { $_.Extension -in '.slnx', '.sln' } |
        Sort-Object { $_.Extension -ne '.slnx' } |
        Select-Object -First 1
    if (-not $found) { Write-Error "Nenhum .sln ou .slnx encontrado na pasta atual." }
    $solutionPath = $found.FullName
}

$ext         = [IO.Path]::GetExtension($solutionPath)
$format      = if ($ext -eq '.slnx') { 'slnx' } else { 'sln' }
$solutionDir = (Split-Path $solutionPath -Parent).TrimEnd('\', '/')

# Resolve a pasta (relativa a solution ou absoluta)
if ([IO.Path]::IsPathRooted($Folder)) { $pastaPath = $Folder }
else { $pastaPath = Join-Path $solutionDir $Folder }

if (-not (Test-Path $pastaPath -PathType Container)) {
    Write-Error "Pasta nao encontrada: $pastaPath"
}
$pastaPath = (Resolve-Path $pastaPath).Path.TrimEnd('\', '/')

if (-not $pastaPath.StartsWith($solutionDir, [StringComparison]::OrdinalIgnoreCase)) {
    Write-Error "A pasta precisa estar dentro do diretorio da solution: $solutionDir"
}

function Get-Rel([string]$full) {
    return $full.Substring($solutionDir.Length + 1)
}

$files = @(Get-ChildItem -Path $pastaPath -Recurse -File)
if ($files.Count -eq 0) { Write-Error "Nenhum arquivo encontrado em: $pastaPath" }

# Backup
Copy-Item $solutionPath "$solutionPath.bak" -Force

if ($format -eq 'slnx') {

    $xml = New-Object System.Xml.XmlDocument
    $xml.PreserveWhitespace = $true
    $xml.Load($solutionPath)
    $root = $xml.DocumentElement

    foreach ($grupo in ($files | Group-Object DirectoryName)) {
        $relDir = (Get-Rel $grupo.Name).Replace('\', '/')
        $nome   = "/$relDir/"

        if ($root.SelectSingleNode("Folder[@Name='$nome']")) {
            Write-Warning "Folder '$nome' ja existe na solution. Ignorada."
            continue
        }

        $folderNode = $xml.CreateElement('Folder')
        $folderNode.SetAttribute('Name', $nome)

        foreach ($f in $grupo.Group) {
            $relFile = (Get-Rel $f.FullName).Replace('\', '/')
            $node    = $xml.CreateElement('File')
            $node.SetAttribute('Path', $relFile)
            $folderNode.AppendChild($node) | Out-Null
        }

        $root.AppendChild($folderNode) | Out-Null
    }

    $xml.Save($solutionPath)
}
else {

    $nomePasta = Split-Path $pastaPath -Leaf
    $typeGuid  = '{2150E333-8FDC-42A3-9474-1A3956D46DE8}'
    $lines     = New-Object 'System.Collections.Generic.List[string]'
    $lines.AddRange([string[]](Get-Content -Path $solutionPath))

    $prefixo = "Project(`"$typeGuid`") = `"$nomePasta`""
    $existe  = $lines | Where-Object { $_.StartsWith($prefixo) }
    if ($existe) {
        Write-Warning "Solution folder '$nomePasta' ja existe. Nada alterado."
        exit 0
    }

    $novoGuid = [guid]::NewGuid().ToString().ToUpper()
    $guid     = "{$novoGuid}"

    $bloco = New-Object 'System.Collections.Generic.List[string]'
    $bloco.Add("Project(`"$typeGuid`") = `"$nomePasta`", `"$nomePasta`", `"$guid`"")
    $bloco.Add("`tProjectSection(SolutionItems) = preProject")
    foreach ($f in $files) {
        $rel = Get-Rel $f.FullName
        $bloco.Add("`t`t$rel = $rel")
    }
    $bloco.Add("`tEndProjectSection")
    $bloco.Add("EndProject")

    $idx = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -eq 'Global') { $idx = $i; break }
    }
    if ($idx -lt 0) { Write-Error "Marcador 'Global' nao encontrado no .sln." }

    $lines.InsertRange($idx, $bloco)
    Set-Content -Path $solutionPath -Value $lines -Encoding UTF8
}

Write-Host "OK: pasta '$Folder' adicionada (formato: $format)" -ForegroundColor Green
Write-Host "Backup: $solutionPath.bak"
Write-Host "Feche e reabra a solution no Visual Studio."