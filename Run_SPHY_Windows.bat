@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set "CONDA_CMD="
for /f "delims=" %%C in ('where conda 2^>nul') do if not defined CONDA_CMD set "CONDA_CMD=%%C"
if not defined CONDA_CMD if exist "%USERPROFILE%\anaconda3\condabin\conda.bat" set "CONDA_CMD=%USERPROFILE%\anaconda3\condabin\conda.bat"
if not defined CONDA_CMD if exist "%USERPROFILE%\miniconda3\condabin\conda.bat" set "CONDA_CMD=%USERPROFILE%\miniconda3\condabin\conda.bat"
if not defined CONDA_CMD if exist "%LOCALAPPDATA%\anaconda3\condabin\conda.bat" set "CONDA_CMD=%LOCALAPPDATA%\anaconda3\condabin\conda.bat"
if not defined CONDA_CMD if exist "%LOCALAPPDATA%\miniconda3\condabin\conda.bat" set "CONDA_CMD=%LOCALAPPDATA%\miniconda3\condabin\conda.bat"
if not defined CONDA_CMD if exist "C:\ProgramData\anaconda3\condabin\conda.bat" set "CONDA_CMD=C:\ProgramData\anaconda3\condabin\conda.bat"
if not defined CONDA_CMD if exist "C:\ProgramData\miniconda3\condabin\conda.bat" set "CONDA_CMD=C:\ProgramData\miniconda3\condabin\conda.bat"
if not defined CONDA_CMD set /p "CONDA_CMD=Conda not found. Enter the full path to conda.bat, or press Enter to cancel: "
set "CONDA_CMD=%CONDA_CMD:"=%"
if not defined CONDA_CMD goto :no_conda
if not exist "%CONDA_CMD%" goto :bad_conda

if "%~1"=="" (
    set /p "SPHY_CONFIG=Enter the full path to your SPHY config file: "
) else (
    set "SPHY_CONFIG=%~1"
)
set "SPHY_CONFIG=%SPHY_CONFIG:"=%"

if not exist "%SPHY_CONFIG%" (
    echo ERROR: Configuration file not found: "%SPHY_CONFIG%"
    echo Usage: Run_SPHY_Windows.bat "C:\path\to\SPHY_config.cfg"
    pause
    exit /b 1
)

echo Starting SPHY with config: "%SPHY_CONFIG%"
call "%CONDA_CMD%" run -n sphy python -m SPHY.main -i "%SPHY_CONFIG%"
set "SPHY_EXIT=%ERRORLEVEL%"
if not "%SPHY_EXIT%"=="0" (
    echo.
    echo SPHY stopped with exit code %SPHY_EXIT%.
    echo Confirm that the sphy environment and the required PCRaster version are installed.
    pause
)
exit /b %SPHY_EXIT%

:no_conda
echo ERROR: Conda was not found. Install Anaconda or Miniconda first.
pause
exit /b 1

:bad_conda
echo ERROR: The Conda path is invalid: "%CONDA_CMD%"
pause
exit /b 1

