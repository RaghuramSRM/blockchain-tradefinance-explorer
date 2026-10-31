@echo off
title ChainDocs - Web Technologies Lab Review 02
echo =====================================================================
echo   ChainDocs: Trade Finance Blockchain Explorer
echo   Web Technologies Laboratory (U21CS504) - Review 02
echo =====================================================================
echo.
echo Starting ChainDocs Server on http://127.0.0.1:8888 ...
echo Press Ctrl+C to stop the server.
echo.
start http://127.0.0.1:8888
"C:\chaindocs\bin\php\php.exe" -S 127.0.0.1:8888 -t "C:\chaindocs" "C:\chaindocs\router.php"
pause
