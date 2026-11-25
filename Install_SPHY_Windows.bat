@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo SPHY Windows environment setup

echo.
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

call "%CONDA_CMD%" --version
if errorlevel 1 goto :bad_conda

echo Creating the SPHY environment with Python 2.7...
call "%CONDA_CMD%" create -y -n sphy python=2.7 pip numpy=1.16 pandas=0.24
if errorlevel 1 (
    echo ERROR: Conda could not create the environment.
    echo Check your Conda channels and internet connection.
    pause
    exit /b 1
)

echo Installing SPHY from this source folder...
call "%CONDA_CMD%" run -n sphy python -m pip install --no-deps --editable .
if errorlevel 1 (
    echo ERROR: SPHY installation failed.
    pause
    exit /b 1
)

echo.
echo Checking for PCRaster...
call "%CONDA_CMD%" run -n sphy python -c "import pcraster; import pcraster.framework"
if errorlevel 1 (
    echo.
    echo SPHY was installed, but PCRaster is not available in the sphy environment.
    echo Install the PCRaster version required by your SPHY release, then rerun this check.
    echo SPHY 2.2.1 documentation specifies PCRaster 4.1.0.
    pause
    exit /b 2
)

echo.
echo Setup complete. Run Run_SPHY_Windows.bat and provide your SPHY configuration file.
pause
exit /b 0

:no_conda
echo ERROR: Conda was not found.
echo Install Anaconda or Miniconda, or run this file from Anaconda Prompt.
pause
exit /b 1

:bad_conda
echo ERROR: The Conda path is invalid or Conda could not start: "%CONDA_CMD%"
echo Run this file from Anaconda Prompt or enter the full path to conda.bat.
pause
exit /b 1


