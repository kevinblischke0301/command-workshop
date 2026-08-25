"""The GUI for the text editor."""

import tkinter as tk
from tkinter import messagebox

from .editor import TextEditor


class Application(tk.Frame):
    """The GUI for the text editor.

    Every button handler talks directly to `self.editor` and `self.clipboard`.
    """

    def __init__(self, master: tk.Tk | None = None) -> None:
        """Initialize the window, receiver, and shared clipboard state.

        `TextEditor` is the receiver: it contains the document logic.
        """
        super().__init__(master)
        self.master = master
        self.master.title("Text Editor")
        self.pack()

        self.editor = TextEditor()  # The receiver.
        self.clipboard: str = ""    # Shared clipboard state.

        self._create_widgets()

    def _create_widgets(self) -> None:
        """Create the application's text field and buttons.

        Each button calls a GUI method directly.
        """
        self.display = tk.Text(self, width=50, height=10, wrap="word")
        self.display.pack(pady=10, padx=10)
        self.display.bind("<<Modified>>", self._on_text_modified)

        button_frame = tk.Frame(self)
        button_frame.pack(pady=5)

        # --- Define buttons ---
        self.copy_button = tk.Button(button_frame, text="Copy", command=self.copy)
        self.copy_button.pack(side="left", padx=5)

        self.cut_button = tk.Button(button_frame, text="Cut", command=self.cut)
        self.cut_button.pack(side="left", padx=5)

        self.paste_button = tk.Button(button_frame, text="Paste", command=self.paste)
        self.paste_button.pack(side="left", padx=5)

        # Disabled on purpose: undoing requires a command history, which
        # does not exist yet in this "before" version.
        self.undo_button = tk.Button(button_frame, text="Undo", state="disabled")
        self.undo_button.pack(side="left", padx=5)

    def _on_text_modified(self, _event: tk.Event) -> None:
        """Keep the editor (receiver) in sync with manual typing in the widget."""
        self.display.edit_modified(False)
        self.editor.set_content(self.display.get("1.0", "end-1c"))

    def _get_selection_indices(self) -> tuple[int, int] | None:
        """Return the (start, end) character offsets of the current selection."""
        try:
            start_count = self.display.count("1.0", "sel.first")
            end_count = self.display.count("1.0", "sel.last")
        except tk.TclError:
            return None
        # tkinter returns None instead of (0,) when the count is zero.
        start = start_count[0] if start_count else 0
        end = end_count[0] if end_count else 0
        return start, end

    def copy(self) -> None:
        """Copy the selected text to the clipboard."""
        indices = self._get_selection_indices()
        if indices is None:
            messagebox.showinfo("Copy", "Please select some text first.")
            return
        start, end = indices
        self.clipboard = self.editor.get_text(start, end)

    def cut(self) -> None:
        """Copy the selected text to the clipboard and remove it from the document."""
        indices = self._get_selection_indices()
        if indices is None:
            messagebox.showinfo("Cut", "Please select some text first.")
            return
        start, end = indices
        self.clipboard = self.editor.delete_text(start, end)
        self._refresh_display()

    def paste(self) -> None:
        """Insert the clipboard content at the current cursor position."""
        position_count = self.display.count("1.0", "insert")
        position = position_count[0] if position_count else 0
        self.editor.insert_text(position, self.clipboard)
        self._refresh_display()

    def _refresh_display(self) -> None:
        """Copy the receiver's content back into the text field.

        Operations such as ``cut`` and ``paste`` first change the
        ``TextEditor`` object. This method then updates the visible GUI without
        losing the current cursor position.
        """
        cursor = self.display.index("insert")
        self.display.delete("1.0", "end")
        self.display.insert("1.0", self.editor.get_content())
        self.display.mark_set("insert", cursor)
        self.display.edit_modified(False)

