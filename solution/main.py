"""Entry point for the sample solution application."""

import tkinter as tk

from .gui import Application


def main() -> None:
    root = tk.Tk()
    app = Application(master=root)
    app.mainloop()


if __name__ == "__main__":
    main()
