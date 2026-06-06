import tkinter as tk
from pathlib import Path
import threading
import subprocess
import sys

# Auto-install keyboard module if missing
try:
    import keyboard
except ImportError:
    print("[AW Spam] Installing keyboard module...")
    subprocess.run([sys.executable, "-m", "pip", "install", "keyboard"], check=True)
    import keyboard


CONFIG_PATH = Path(
    r"D:\SteamLibrary\steamapps\common\EscapeTheBackrooms\EscapeTheBackrooms"
    r"\Binaries\Win64\ue4ss\Mods\DropAlmondWaterSpammer\config.cfg"
)

DEFAULTS = {
    "command": "drop aw",
    "amount": "1",
    "speed_ms": "100",
    "mode": "toggle",
    "key": "F9",
    "enabled": "false",
    "esp_monsters": "false",
    "esp_players": "false",
    "esp_exits": "false",
}

COMMANDS = ["drop", "give"]
COMMAND_PREFIXES = ("drop", "d", "give", "g")
KNOWN_ITEMS = [
    "almondconcentrate",
    "almondwater",
    "bugspray",
    "camera",
    "chainsaw",
    "chainsawfast",
    "crowbar",
    "divinghelmet",
    "energybar",
    "firework",
    "flaregun",
    "glowstick",
    "glowstickblue",
    "glowstickred",
    "glowstickyellow",
    "juice",
    "knife",
    "lidar",
    "liquidpain",
    "mothjelly",
    "rope",
    "thermometer",
    "ticket",
    "toy",
    "walkietalkie",
    "almondbottle",
    "aw",
    "eb",
    "fw",
    "fg",
    "j",
    "lp",
    "jelly",
    "mj",
    "m",
    "r",
    "t",
]

KNOWN_ITEMS = sorted(set(KNOWN_ITEMS))

COLORS = {
    "bg": "#141414",
    "panel": "#1f1f1f",
    "panel2": "#252525",
    "border": "#3c3c3c",
    "text": "#f1f1f1",
    "muted": "#a8a8a8",
    "accent": "#4f8cff",
    "accent_hover": "#6aa0ff",
    "danger": "#d55c5c",
    "off": "#4b4b4b",
    "input": "#101010",
}


def read_config():
    values = DEFAULTS.copy()
    if CONFIG_PATH.exists():
        for line in CONFIG_PATH.read_text(encoding="utf-8").splitlines():
            if "=" in line:
                key, value = line.split("=", 1)
                values[key.strip()] = value.strip()
    return values


class AutocompleteEntry(tk.Entry):
    def __init__(self, master, suggestions, hint_label, *args, **kwargs):
        super().__init__(master, *args, **kwargs)
        self.suggestions = suggestions
        self.hint_label = hint_label
        self.bind("<Tab>", self.complete)
        self.bind("<KeyRelease>", self.update_hint)

    def get_suggestion(self):
        text = self.get().strip()
        parts = text.split()
        if len(parts) == 0:
            return None

        command = parts[0].lower()
        if command not in COMMAND_PREFIXES:
            return None

        item_prefix = "" if len(parts) == 1 else parts[1].lower()
        if item_prefix == "":
            return None

        for item in self.suggestions:
            if item.startswith(item_prefix):
                return item
        return None

    def update_hint(self, event=None):
        suggestion = self.get_suggestion()
        if suggestion:
            self.hint_label.configure(text=f"Press Tab to autocomplete: {suggestion}")
        else:
            self.hint_label.configure(text="Type a command like 'drop aw' or 'give fw' then press Tab.")

    def complete(self, event=None):
        text = self.get().strip()
        parts = text.split()
        if len(parts) == 0:
            self.delete(0, tk.END)
            self.insert(0, "drop ")
            return "break"

        command = parts[0].lower()
        if command not in COMMAND_PREFIXES:
            return "break"

        suggestion = self.get_suggestion()
        if suggestion:
            self.delete(0, tk.END)
            self.insert(0, f"{command} {suggestion}")
        return "break"


def write_config(values):
    CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
    text = "\n".join(f"{key}={values[key]}" for key in DEFAULTS) + "\n"
    CONFIG_PATH.write_text(text, encoding="utf-8")


class ImGuiButton(tk.Label):
    def __init__(self, master, text, command, active=False, width=None):
        super().__init__(
            master,
            text=text,
            fg=COLORS["text"],
            bg=COLORS["accent"] if active else COLORS["panel2"],
            bd=1,
            relief="solid",
            padx=8,
            pady=5,
            width=width,
            cursor="hand2",
        )
        self.command = command
        self.active = active
        self.bind("<Button-1>", lambda _: self.command())
        self.bind("<Enter>", self.on_enter)
        self.bind("<Leave>", self.on_leave)

    def set_active(self, active):
        self.active = active
        self.configure(bg=COLORS["accent"] if active else COLORS["panel2"])

    def on_enter(self, _):
        self.configure(bg=COLORS["accent_hover"] if self.active else COLORS["border"])

    def on_leave(self, _):
        self.configure(bg=COLORS["accent"] if self.active else COLORS["panel2"])


class AwSpamOverlay(tk.Tk):
    def __init__(self):
        super().__init__()
        self.overrideredirect(True)
        self.attributes("-topmost", True)
        self.configure(bg=COLORS["border"])
        self.resizable(False, False)
        self.is_visible = True
        self.hotkey_registered = False

        values = read_config()
        self.enabled = tk.BooleanVar(value=values["enabled"].lower() == "true")
        self.command = tk.StringVar(value=values["command"])
        command_parts = values["command"].split()
        self.command_type = tk.StringVar(value=command_parts[0] if len(command_parts) >= 1 else "drop")
        self.command_item = tk.StringVar(value=command_parts[1] if len(command_parts) >= 2 else "aw")
        self.amount = tk.IntVar(value=int(values["amount"]))
        self.speed = tk.IntVar(value=int(values["speed_ms"]))
        self.mode = tk.StringVar(value=values["mode"])
        self.key = tk.StringVar(value=values["key"])
        self.esp_monsters = tk.BooleanVar(value=values["esp_monsters"].lower() == "true")
        self.esp_players = tk.BooleanVar(value=values["esp_players"].lower() == "true")
        self.esp_exits = tk.BooleanVar(value=values["esp_exits"].lower() == "true")
        self.drag_x = 0
        self.drag_y = 0

        self.build_ui()
        self.place_top_right()
        self.register_insert_hotkey()

    def build_ui(self):
        outer = tk.Frame(self, bg=COLORS["border"], padx=1, pady=1)
        outer.grid()

        self.panel = tk.Frame(outer, bg=COLORS["bg"], padx=10, pady=8)
        self.panel.grid()

        self.header = tk.Frame(self.panel, bg=COLORS["panel2"], padx=8, pady=6)
        self.header.grid(row=0, column=0, sticky="ew", columnspan=2)
        self.header.bind("<ButtonPress-1>", self.start_drag)
        self.header.bind("<B1-Motion>", self.drag)

        self.title = tk.Label(
            self.header,
            text="AW Spam",
            fg=COLORS["text"],
            bg=COLORS["panel2"],
            font=("Segoe UI", 9, "bold"),
        )
        self.title.grid(row=0, column=0, sticky="w")
        self.title.bind("<ButtonPress-1>", self.start_drag)
        self.title.bind("<B1-Motion>", self.drag)

        self.status = tk.Label(
            self.header,
            text="ON" if self.enabled.get() else "OFF",
            fg=COLORS["text"],
            bg=COLORS["accent"] if self.enabled.get() else COLORS["off"],
            padx=7,
            pady=2,
            font=("Segoe UI", 8, "bold"),
        )
        self.status.grid(row=0, column=1, padx=(50, 6))

        close = tk.Label(
            self.header,
            text="x",
            fg=COLORS["muted"],
            bg=COLORS["panel2"],
            padx=5,
            cursor="hand2",
        )
        close.grid(row=0, column=2)
        close.bind("<Button-1>", lambda _: self.destroy())

        self.toggle_btn = ImGuiButton(self.panel, "Toggle Enabled", self.toggle_enabled, active=self.enabled.get())
        self.toggle_btn.grid(row=1, column=0, columnspan=2, sticky="ew", pady=(9, 8))

        self.label("Action", 2)
        action_menu = tk.OptionMenu(self.panel, self.command_type, *COMMANDS, command=lambda *_: self.update_command_from_dropdown())
        action_menu.configure(bg=COLORS["input"], fg=COLORS["text"], activebackground=COLORS["panel2"], activeforeground=COLORS["text"], highlightthickness=0, bd=1)
        action_menu.grid(row=2, column=1, sticky="ew")

        self.label("Item", 3)
        item_menu = tk.OptionMenu(self.panel, self.command_item, *KNOWN_ITEMS, command=lambda *_: self.update_command_from_dropdown())
        item_menu.configure(bg=COLORS["input"], fg=COLORS["text"], activebackground=COLORS["panel2"], activeforeground=COLORS["text"], highlightthickness=0, bd=1)
        item_menu.grid(row=3, column=1, sticky="ew")

        self.label("Command", 4)
        entry = AutocompleteEntry(
            self.panel,
            suggestions=KNOWN_ITEMS,
            hint_label=None,
            textvariable=self.command,
            fg=COLORS["text"],
            bg=COLORS["input"],
            insertbackground=COLORS["text"],
            relief="solid",
            bd=1,
            width=22,
        )
        entry.grid(row=4, column=1, sticky="ew")

        self.command_hint = tk.Label(
            self.panel,
            text="Type a command like 'drop aw' or 'give fw' then press Tab.",
            fg=COLORS["muted"],
            bg=COLORS["bg"],
            font=("Segoe UI", 7),
        )
        self.command_hint.grid(row=5, column=0, columnspan=2, sticky="w", padx=(0, 10), pady=(3, 0))

        entry.hint_label = self.command_hint
        entry.update_hint()

        self.slider("Amount", self.amount, 1, 50, 6)
        self.slider("Speed", self.speed, 10, 2000, 7, suffix=" ms")

        self.label("Mode", 8)
        mode_row = tk.Frame(self.panel, bg=COLORS["bg"])
        mode_row.grid(row=8, column=1, sticky="ew", pady=(7, 0))
        self.toggle_mode_btn = ImGuiButton(mode_row, "toggle", lambda: self.set_mode("toggle"), active=self.mode.get() == "toggle", width=7)
        self.hold_mode_btn = ImGuiButton(mode_row, "hold", lambda: self.set_mode("hold"), active=self.mode.get() == "hold", width=7)
        self.toggle_mode_btn.grid(row=0, column=0, padx=(0, 4))
        self.hold_mode_btn.grid(row=0, column=1)

        self.label("Key", 9)
        key_row = tk.Frame(self.panel, bg=COLORS["bg"])
        key_row.grid(row=9, column=1, sticky="ew", pady=(7, 0))
        for idx, key_name in enumerate(("F5", "F6", "F7", "F8", "F9", "F10")):
            btn = ImGuiButton(key_row, key_name, lambda key_name=key_name: self.set_key(key_name), active=self.key.get() == key_name, width=3)
            btn.grid(row=idx // 3, column=idx % 3, padx=2, pady=2)
            setattr(self, f"key_{key_name}", btn)

        self.label("ESP", 10)
        esp_row = tk.Frame(self.panel, bg=COLORS["bg"])
        esp_row.grid(row=10, column=1, sticky="ew", pady=(7, 0))
        self.monsters_cb = tk.Checkbutton(
            esp_row,
            text="Monsters",
            variable=self.esp_monsters,
            bg=COLORS["bg"],
            fg=COLORS["text"],
            selectcolor=COLORS["bg"],
            activebackground=COLORS["panel2"],
            activeforeground=COLORS["text"],
            command=self.save,
        )
        self.players_cb = tk.Checkbutton(
            esp_row,
            text="Players",
            variable=self.esp_players,
            bg=COLORS["bg"],
            fg=COLORS["text"],
            selectcolor=COLORS["bg"],
            activebackground=COLORS["panel2"],
            activeforeground=COLORS["text"],
            command=self.save,
        )
        self.exits_cb = tk.Checkbutton(
            esp_row,
            text="Exits",
            variable=self.esp_exits,
            bg=COLORS["bg"],
            fg=COLORS["text"],
            selectcolor=COLORS["bg"],
            activebackground=COLORS["panel2"],
            activeforeground=COLORS["text"],
            command=self.save,
        )
        self.monsters_cb.grid(row=0, column=0, padx=(0, 4))
        self.players_cb.grid(row=0, column=1, padx=(0, 4))
        self.exits_cb.grid(row=0, column=2)

        hint = tk.Label(
            self.panel,
            text="Lua mod reloads these settings live",
            fg=COLORS["muted"],
            bg=COLORS["bg"],
            font=("Segoe UI", 8),
        )
        hint.grid(row=11, column=0, columnspan=2, sticky="w", pady=(9, 0))

        self.panel.columnconfigure(1, weight=1)

        self.command.trace_add("write", lambda *_: (self.sync_dropdowns_from_command(), self.save()))
        self.command_type.trace_add("write", lambda *_: self.update_command_from_dropdown())
        self.command_item.trace_add("write", lambda *_: self.update_command_from_dropdown())
        self.amount.trace_add("write", lambda *_: self.save())
        self.speed.trace_add("write", lambda *_: self.save())

    def label(self, text, row):
        tk.Label(
            self.panel,
            text=text,
            fg=COLORS["muted"],
            bg=COLORS["bg"],
            font=("Segoe UI", 8),
        ).grid(row=row, column=0, sticky="w", padx=(0, 10), pady=(7, 0))

    def slider(self, label, variable, minimum, maximum, row, suffix=""):
        self.label(label, row)
        wrap = tk.Frame(self.panel, bg=COLORS["bg"])
        wrap.grid(row=row, column=1, sticky="ew", pady=(7, 0))

        scale = tk.Scale(
            wrap,
            from_=minimum,
            to=maximum,
            orient="horizontal",
            variable=variable,
            showvalue=False,
            resolution=1,
            bg=COLORS["bg"],
            fg=COLORS["text"],
            troughcolor=COLORS["input"],
            activebackground=COLORS["accent_hover"],
            highlightthickness=0,
            bd=0,
            length=145,
        )
        scale.grid(row=0, column=0, sticky="ew")

        value = tk.Label(
            wrap,
            textvariable=variable,
            fg=COLORS["text"],
            bg=COLORS["panel2"],
            width=5,
            padx=3,
        )
        value.grid(row=0, column=1, padx=(6, 0))

        if suffix:
            tk.Label(wrap, text=suffix, fg=COLORS["muted"], bg=COLORS["bg"]).grid(row=0, column=2)

        wrap.columnconfigure(0, weight=1)

    def toggle_enabled(self):
        self.enabled.set(not self.enabled.get())
        self.status.configure(
            text="ON" if self.enabled.get() else "OFF",
            bg=COLORS["accent"] if self.enabled.get() else COLORS["off"],
        )
        self.toggle_btn.set_active(self.enabled.get())
        self.save()

    def set_mode(self, mode):
        self.mode.set(mode)
        self.toggle_mode_btn.set_active(mode == "toggle")
        self.hold_mode_btn.set_active(mode == "hold")
        self.save()

    def set_key(self, key):
        self.key.set(key)
        for key_name in ("F5", "F6", "F7", "F8", "F9", "F10"):
            getattr(self, f"key_{key_name}").set_active(key_name == key)
        self.save()

    def update_command_from_dropdown(self):
        self.command.set(f"{self.command_type.get()} {self.command_item.get()}")
        self.save()

    def sync_dropdowns_from_command(self):
        parts = self.command.get().strip().split()
        if len(parts) >= 1 and parts[0] in COMMANDS:
            self.command_type.set(parts[0])
        if len(parts) >= 2 and parts[1] in KNOWN_ITEMS:
            self.command_item.set(parts[1])

    def save(self):
        values = {
            "command": self.command.get().strip() or "drop aw",
            "amount": str(max(1, min(50, int(self.amount.get())))),
            "speed_ms": str(max(10, min(2000, int(self.speed.get())))),
            "mode": self.mode.get(),
            "key": self.key.get(),
            "enabled": "true" if self.enabled.get() else "false",
            "esp_monsters": "true" if self.esp_monsters.get() else "false",
            "esp_players": "true" if self.esp_players.get() else "false",
            "esp_exits": "true" if self.esp_exits.get() else "false",
        }
        write_config(values)

    def start_drag(self, event):
        self.drag_x = event.x
        self.drag_y = event.y

    def drag(self, event):
        x = self.winfo_x() + event.x - self.drag_x
        y = self.winfo_y() + event.y - self.drag_y
        self.geometry(f"+{x}+{y}")

    def place_top_right(self):
        self.update_idletasks()
        width = self.winfo_width()
        height = self.winfo_height()
        x = self.winfo_screenwidth() - width - 20
        y = 40
        self.geometry(f"{width}x{height}+{x}+{y}")

    def toggle_visibility(self):
        if self.is_visible:
            self.withdraw()
            self.is_visible = False
        else:
            self.deiconify()
            self.is_visible = True

    def register_insert_hotkey(self):
        def hotkey_listener():
            try:
                keyboard.add_hotkey("insert", self.toggle_visibility, suppress=False)
                self.hotkey_registered = True
                print("[AW Spam] Insert key hotkey registered successfully")
            except Exception as e:
                print(f"[AW Spam] Failed to register Insert hotkey: {e}")

        thread = threading.Thread(target=hotkey_listener, daemon=True)
        thread.start()


if __name__ == "__main__":
    AwSpamOverlay().mainloop()
