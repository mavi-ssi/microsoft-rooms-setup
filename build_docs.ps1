param (
    [switch]$html,
    [switch]$pdf,
    [switch]$light,
    [switch]$dark,
    [switch]$all
)

if ($null -eq $PSBoundParameters.Keys -or $all) {
    $html = $true; $pdf = $true; $light = $true; $dark = $true
}

$pdfDir = "./pdf"
if (!(Test-Path $pdfDir)) { New-Item -ItemType Directory -Path $pdfDir }

# --- HTML SECTION ---
if ($html) {
    Write-Host "`n--- Building HTML Site ---" -ForegroundColor Cyan
    uv run mkdocs build
}

# --- PDF SECTION ---
if ($pdf) {
    if (-not $light -and -not $dark) { $light = $true; $dark = $true }

    # Function to build and clean
    function Export-PDF($configFile, $outputName) {
        Write-Host "--- Generating $outputName ---" -ForegroundColor Yellow
        uv run mkdocs build -f $configFile
        
        if (Test-Path "./site/exports/manual.pdf") {
            # DECOUPLING LOGIC: Remove the site folder if we didn't explicitly ask for HTML
            if (-not $html) {
                Remove-Item "./site" -Recurse -Force
                Write-Host "Cleaned up temporary site files." -ForegroundColor Gray
            }
        }
    }

    if ($light) { Export-PDF "mkdocs-pdf-light.yml" "Manual-Light.pdf" }
    if ($dark)  { Export-PDF "mkdocs-pdf-dark.yml" "Manual-Dark.pdf" }
}

Write-Host "`nBuild Done!" -ForegroundColor Green