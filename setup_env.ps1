$p = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($p -notlike "*C:\src\flutter\bin*") {
    [Environment]::SetEnvironmentVariable('Path', "$p;C:\src\flutter\bin", 'User')
    Write-Host "Added C:\src\flutter\bin to User Path."
} else {
    Write-Host "Path already set."
}
