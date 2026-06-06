#!/usr/bin/env python
"""
Launcher script that starts the AW Spam GUI when the game is detected running.
Run this once before launching the game, and it will keep the GUI running.
"""
import subprocess
import os
import sys
import time
from pathlib import Path

# Ensure dependencies are installed before importing
try:
    import psutil
except ImportError:
    print("[GUI Launcher] Installing psutil...")
    subprocess.run([sys.executable, "-m", "pip", "install", "psutil"], check=True)
    import psutil

SCRIPT_DIR = Path(__file__).parent
GUI_SCRIPT = SCRIPT_DIR / "awspam_gui.py"
GAME_PROCESS_NAMES = ("EscapeTheBackrooms.exe", "UE4SS-x64.exe")


def is_game_running():
    """Check if any of the game processes are running."""
    for proc in psutil.process_iter(["name"]):
        try:
            if proc.info["name"] in GAME_PROCESS_NAMES:
                return True
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass
    return False


def main():
    print("[GUI Launcher] Waiting for game to start...")
    gui_process = None

    try:
        while True:
            if is_game_running():
                if gui_process is None or not is_process_alive(gui_process):
                    print("[GUI Launcher] Game detected! Starting GUI...")
                    try:
                        gui_process = subprocess.Popen(
                            [sys.executable, str(GUI_SCRIPT)],
                            cwd=str(SCRIPT_DIR),
                            stdout=subprocess.DEVNULL,
                            stderr=subprocess.DEVNULL,
                        )
                        print(f"[GUI Launcher] GUI started (PID: {gui_process.pid})")
                    except Exception as e:
                        print(f"[GUI Launcher] Failed to start GUI: {e}")
            else:
                if gui_process is not None and is_process_alive(gui_process):
                    print("[GUI Launcher] Game stopped. Closing GUI...")
                    try:
                        gui_process.terminate()
                        gui_process.wait(timeout=5)
                    except Exception as e:
                        print(f"[GUI Launcher] Error closing GUI: {e}")
                    gui_process = None

            time.sleep(1)

    except KeyboardInterrupt:
        print("\n[GUI Launcher] Shutting down...")
        if gui_process is not None:
            try:
                gui_process.terminate()
                gui_process.wait(timeout=5)
            except Exception:
                gui_process.kill()
        sys.exit(0)


def is_process_alive(proc):
    """Check if a process is still alive."""
    try:
        return proc.poll() is None
    except Exception:
        return False


if __name__ == "__main__":
    main()
