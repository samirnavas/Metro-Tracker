@echo off
echo ========================================
echo Finding Your Computer's IP Address
echo ========================================
echo.

ipconfig | findstr /i "IPv4"

echo.
echo ========================================
echo Copy one of the IP addresses above
echo (usually starts with 192.168.x.x)
echo ========================================
echo.
echo Press any key to exit...
pause > nul
