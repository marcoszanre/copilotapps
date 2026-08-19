<#
.SYNOPSIS
  Minimal screen recorder used to capture proof that the Sales Studio agents work.

.DESCRIPTION
  Wraps ffmpeg's gdigrab desktop capture. Written because
  C:\Users\marcoszanr\Documents\Dev\custom_recorder was still empty when this
  evidence had to be produced.

.EXAMPLE
  .\Record-Evidence.ps1 -Action Start -OutFile .\evidence\demo.mp4
  .\Record-Evidence.ps1 -Action Stop
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('Start', 'Stop', 'Status')]
    [string]$Action,

    [string]$OutFile = (Join-Path $PSScriptRoot 'evidence.mp4'),

    [int]$Framerate = 12
)

$ErrorActionPreference = 'Stop'
$pidFile = Join-Path $env:TEMP 'sales-studio-recorder.pid'

function Get-FfmpegPath {
    $cmd = Get-Command ffmpeg -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $winget = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\ffmpeg.exe'
    if (Test-Path $winget) { return $winget }
    throw 'ffmpeg not found. Install with: winget install --id Gyan.FFmpeg -e'
}

switch ($Action) {
    'Start' {
        if (Test-Path $pidFile) {
            throw "A recording is already running (pid file $pidFile). Stop it first."
        }

        $ffmpeg = Get-FfmpegPath
        $dir = Split-Path -Parent $OutFile
        if ($dir -and -not (Test-Path $dir)) {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
        }
        if (Test-Path $OutFile) { Remove-Item $OutFile -Force }

        # -nostdin keeps ffmpeg from swallowing the parent shell's input.
        $ffArgs = @(
            '-nostdin', '-y',
            '-f', 'gdigrab',
            '-framerate', "$Framerate",
            '-draw_mouse', '1',
            '-i', 'desktop',
            # Downscale: the desktop spans 3840x1200, which gdigrab cannot
            # encode in real time at full size.
            '-vf', 'scale=1920:-2',
            '-c:v', 'libx264',
            '-preset', 'ultrafast',
            '-crf', '30',
            '-pix_fmt', 'yuv420p',
            # A keyframe every 2s bounds how much of the tail can be lost and
            # forces the fragmented writer to flush regularly.
            '-g', "$($Framerate * 2)",
            # Fragmented MP4 stays playable even when ffmpeg is killed rather
            # than shut down gracefully, so the capture survives a hard stop.
            '-movflags', '+frag_keyframe+empty_moov+default_base_moof',
            $OutFile
        )

        $logFile = [System.IO.Path]::ChangeExtension($OutFile, '.ffmpeg.log')
        $proc = Start-Process -FilePath $ffmpeg -ArgumentList $ffArgs `
            -WindowStyle Hidden -PassThru -RedirectStandardError $logFile
        Set-Content -Path $pidFile -Value "$($proc.Id)|$OutFile"
        Start-Sleep -Seconds 2

        if ($proc.HasExited) {
            Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
            $tail = if (Test-Path $logFile) { Get-Content $logFile -Tail 20 | Out-String } else { '(no log)' }
            throw "ffmpeg exited immediately with code $($proc.ExitCode).`n$tail"
        }
        Write-Output "RECORDING_STARTED pid=$($proc.Id) file=$OutFile"
    }

    'Stop' {
        if (-not (Test-Path $pidFile)) { throw 'No recording in progress.' }
        $recPid, $file = (Get-Content $pidFile -Raw).Trim() -split '\|'

        # 'q' on stdin is the graceful stop, but the process is hidden, so close
        # the input stream instead and let ffmpeg finalise the moov atom.
        $proc = Get-Process -Id $recPid -ErrorAction SilentlyContinue
        if ($proc) {
            Stop-Process -Id $recPid
            $proc.WaitForExit(15000) | Out-Null
        }
        Remove-Item $pidFile -Force -ErrorAction SilentlyContinue

        Start-Sleep -Seconds 1
        if (Test-Path $file) {
            $sizeMb = [Math]::Round((Get-Item $file).Length / 1MB, 2)
            Write-Output "RECORDING_STOPPED file=$file sizeMB=$sizeMb"
        }
        else {
            Write-Output "RECORDING_STOPPED but no file was produced at $file"
        }
    }

    'Status' {
        if (-not (Test-Path $pidFile)) { Write-Output 'IDLE'; break }
        $recPid, $file = (Get-Content $pidFile -Raw).Trim() -split '\|'
        $running = [bool](Get-Process -Id $recPid -ErrorAction SilentlyContinue)
        Write-Output "RUNNING=$running pid=$recPid file=$file"
    }
}
