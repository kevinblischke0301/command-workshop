"""Start the Tkinter application."""

import tkinter as tk

from . import gui


def main() -> None:
    """Create the Tk main window and start its event loop."""
    root = tk.Tk()
    app = gui.Application(master=root)
    app.mainloop()


if __name__ == "__main__":
    main()