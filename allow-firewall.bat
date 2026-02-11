@echo off
echo ========================================
echo Metro Tracker - Firewall Configuration
echo ========================================
echo.
echo This will add a firewall rule to allow
echo connections to port 8080 (Metro Tracker Server)
echo.
echo You need to run this as Administrator!
echo.
echo Press any key to continue...
pause > nul

echo.
echo Adding firewall rule...
netsh advfirewall firewall delete rule name="Metro Tracker Server" > nul 2>&1
netsh advfirewall firewall add rule name="Metro Tracker Server" dir=in action=allow protocol=TCP localport=8080

if %errorlevel% == 0 (
    echo.
    echo ========================================
    echo SUCCESS! Firewall rule added.
    echo Port 8080 is now accessible from your network.
    echo ========================================
) else (
    echo.
    echo ========================================
    echo FAILED! You need to run this as Administrator.
    echo ========================================
    echo Right-click this file and select "Run as administrator"
    echo ========================================
)

echo.
pause
