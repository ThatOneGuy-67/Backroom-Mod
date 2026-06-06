#!/usr/bin/env python
"""
Simple GUI launcher - runs the GUI directly.
Place a shortcut to this file on your desktop or in startup folder.
"""
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
GUI_SCRIPT = SCRIPT_DIR / "awspam_gui.py"

if __name__ == "__main__":
    try:
        print("[GUI] Starting AW Spam GUI...")
        subprocess.Popen(
            [sys.executable, str(GUI_SCRIPT)],
            cwd=str(SCRIPT_DIR),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        print("[GUI] GUI started successfully")
    except Exception as e:
        print(f"[GUI] Error: {e}")
        input("Press Enter to continue...")
