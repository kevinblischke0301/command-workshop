# Command Pattern Workshop

This repository contains a small Tkinter text editor used to practice the
Command design pattern. The starting application deliberately has a simple
implementation: the GUI calls the text editor directly, and Undo is disabled.
During the workshop, refactor this code so that editor actions are represented
by commands and can be undone through a command history.

## Requirements

- Python 3.12 or newer
- Tkinter, usually included with Python

On Linux, your distribution may provide Tkinter as a separate package (often
called `python3-tk`). No third-party Python dependencies are required.

## Setup

If your system uses `py` or `python` instead of `python3`, use that command
consistently for the virtual environment and pip.

Run these commands from the repository root.

1. Create a virtual environment:

   ```bash
   python3 -m venv .venv
   ```

2. Activate it.

   macOS/Linux:

   ```bash
   source .venv/bin/activate
   ```

   Windows PowerShell:

   ```powershell
   .venv\Scripts\Activate.ps1
   ```

3. Install the project in editable mode:

   ```bash
   python3 -m pip install --editable .
   ```

   Editable installation makes changes in `src/` available immediately while you
   work through the exercise.

## Run the Application

Make sure the virtual environment is active, then run:

```bash
command-pattern
```

You can also start it as a Python module from the repository root:

```bash
python3 -m command_pattern.main
```

The editor opens with an empty document. Type text into the editor and select
text before using **Copy** or **Cut**. Place the cursor where text should be
inserted, then use **Paste**. Manual typing updates the `TextEditor` receiver;
the toolbar actions update the visible text field after changing it.

## Workshop Starting Point

Before making changes, confirm that:

- Copy copies the selected text.
- Cut copies and removes the selected text.
- Paste inserts the clipboard content at the cursor.
- Undo is visible but disabled.

The main files are:

- [`editor.py`](src/command_pattern/editor.py) contains `TextEditor`, the
  receiver that owns the document content.
- [`gui.py`](src/command_pattern/gui.py) contains the Tkinter application and
  the direct action handlers that you will refactor.
- [`main.py`](src/command_pattern/main.py) starts the application.

## Tips

- In python the `ABC` module can be used to create abstract base classes as
  a substitute for interfaces.
- A command history is naturally a stack: append successfully executed
  commands, undo the most recent command, and remove it from the stack.
