from __future__ import annotations

import os
import shutil
import subprocess
from pathlib import Path

import streamlit as st

ROOT = Path(__file__).resolve().parent

st.set_page_config(page_title="SPHY Model Runner", page_icon="🌧️", layout="wide")
st.title("SPHY Model Runner")
st.caption("Browser interface for running the SPHY model from this checkout.")
st.warning(
    "SPHY 2.2.1 is legacy software. It requires the matching PCRaster installation and a valid model configuration plus input data. "
    "This page runs the model in the existing Conda environment; it does not install PCRaster or create model inputs."
)

with st.form("run_sphy"):
    config_text = st.text_input("SPHY configuration file", placeholder=r"C:\models\basin\SPHY_config.cfg")
    env_name = st.text_input("Conda environment", value="sphy")
    conda_path = st.text_input("Conda command or full path to conda.bat (optional)", value="conda")
    submitted = st.form_submit_button("Run SPHY", type="primary")

if submitted:
    config = Path(os.path.expandvars(config_text.strip().strip('"'))).expanduser()
    if not config.is_file():
        st.error("Select an existing SPHY configuration file.")
    elif not env_name.strip():
        st.error("Enter the name of the Conda environment containing SPHY and PCRaster.")
    else:
        command = conda_path.strip().strip('"') or shutil.which("conda") or "conda"
        args = [command, "run", "-n", env_name.strip(), "python", "-m", "SPHY.main", "-i", str(config.resolve())]
        # On Windows, Conda is commonly a .bat file and must be launched through cmd.exe.
        if os.name == "nt":
            command_line = subprocess.list2cmdline(args)
            args = [os.environ.get("COMSPEC", "cmd.exe"), "/d", "/s", "/c", "call " + command_line]
        st.code(subprocess.list2cmdline(args), language="powershell")
        log_box = st.empty()
        lines = []
        try:
            with st.status("Running SPHY…", expanded=True) as status:
                process = subprocess.Popen(
                    args,
                    cwd=str(ROOT),
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    errors="replace",
                    bufsize=1,
                )
                assert process.stdout is not None
                for line in process.stdout:
                    lines.append(line.rstrip())
                    log_box.code("\n".join(lines[-300:]) or "SPHY started", language="text")
                exit_code = process.wait()
                if exit_code == 0:
                    status.update(label="SPHY finished successfully", state="complete")
                    st.success("SPHY finished successfully.")
                else:
                    status.update(label=f"SPHY exited with code {exit_code}", state="error")
                    st.error("SPHY did not complete. Check the log and verify PCRaster, config paths, and input datasets.")
        except FileNotFoundError:
            st.error("Could not start Conda. Install Conda or enter the full path to its conda.bat file.")
        except Exception as exc:
            st.exception(exc)

