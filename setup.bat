@echo off
chcp 65001 > nul
set PGCLIENTENCODING=UTF8

SET ROOT_DIR=%~dp0
SET DATA_DIR=%ROOT_DIR%data
SET SQL_DIR=%ROOT_DIR%sql_binaries\bin
SET NODE_DIR=%ROOT_DIR%node_binaries\node-v24.12.0-win-x64
SET PATH=%NODE_DIR%;%SQL_DIR%;%PATH%

echo Checking environment...
node -v
if %ERRORLEVEL% NEQ 0 (
	echo Error: Local Node binary not found in %NODE_DIR%
	pause
	exit /b
)

if not exist "%DATA_DIR%" (
  echo Initializing database data in UTF8...
  "%SQL_DIR%\initdb.exe" -D "%DATA_DIR%" -U postgres --auth=trust --locale=C -E UTF8
)

echo Starting PostgreSQL server...
"%SQL_DIR%\pg_ctl.exe" -D "%DATA_DIR%" -o "-p 5432" -l "%ROOT_DIR%logfile" start

echo Waiting for server...
:check_server
"%SQL_DIR%\pg_isready.exe" -h 127.0.0.1 -p 5432
if %ERRORLEVEL% NEQ 0 (
	timeout /t 2 /nobreak > nul
	goto check_server
)

if not exist "%ROOT_DIR%node_modules" (
	echo node_modules not found. Installing dependencies...
	call npm install
)

if not exist "%ROOT_DIR%.env" (
	echo .env file missing. Creating from template...
	copy "%ROOT_DIR%.env.example.sh" "%ROOT_DIR%.env"
	echo Close this window and edit your .env file with a password and secret key and start the file again.
	exit
)

echo Seeding...
cd /d "%ROOT_DIR%"
npm start