# SPHY Windows batch files

These helper files are designed for the upstream [SPHY model](https://github.com/WilcoTerink/SPHY), release 2.2.1. They are intended to be copied into the root of a local SPHY source checkout.

## Prerequisites

SPHY's documentation recommends Anaconda and requires PCRaster. For SPHY 2.2.1, its documentation refers to Python 2.7 and PCRaster 4.1.0. Install a compatible PCRaster version into the `sphy` Conda environment before running the model. PCRaster is a separate prerequisite and is not installed by these batch files.

## Setup

1. Download or clone the upstream SPHY source repository.
2. Copy `Install_SPHY_Windows.bat` and `Run_SPHY_Windows.bat` into the SPHY repository root, next to `setup.py`.
3. Run `Install_SPHY_Windows.bat` from Anaconda Prompt. You can also double-click it; it searches common Anaconda and Miniconda locations and asks for the path to `conda.bat` if it cannot find Conda.
4. Install the matching PCRaster release into the `sphy` environment if it is not already available.

The setup file creates a Conda environment named `sphy` with Python 2.7, an available pip version, NumPy 1.16, and pandas 0.24, then installs this checkout in editable mode. It checks whether PCRaster can be imported.

## Run SPHY

Double-click `Run_SPHY_Windows.bat` and enter the full path to your model configuration file when prompted. You can also run it from a command prompt with a path argument:

```bat
Run_SPHY_Windows.bat "C:\models\basin\SPHY_config.cfg"
```

The run file searches common Anaconda and Miniconda locations or asks for the path to `conda.bat`. It runs `python -m SPHY.main -i <config-file>` inside the `sphy` environment. You must create and edit a valid SPHY configuration and input datasets yourself; the batch files do not provide model inputs.


