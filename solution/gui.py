"""Tkinter GUI using the Command pattern."""

from __future__ import annotations

import tkinter as tk
from tkinter import messagebox

from .commands import CopyCommand, CutCommand, PasteCommand
from .editor import TextEditor
from .history import CommandHistory


class Application(tk.Frame):
    """GUI that creates and invokes command objects."""

    def __init__(self, master: tk.Tk | None = None) -> None:
        super().__init__(master)
        self.master = master
        self.master.title("Text Editor - Command Pattern")
        self.pack()

        self.editor = TextEditor()
        self.history = CommandHistory()

        # Commands receive this mutable reference and can update index 0.
        self.clipboard_ref: list[str] = [""]

        self._create_widgets()

    def _create_widgets(self) -> None:
        self.display = tk.Text(self, width=50, height=10, wrap="word")
        self.display.pack(pady=10, padx=10)
        self.display.bind("<<Modified>>", self._on_text_modified)

        button_frame = tk.Frame(self)
        button_frame.pack(pady=5)

        self.copy_button = tk.Button(button_frame, text="Copy", command=self.copy)
        self.copy_button.pack(side="left", padx=5)

        self.cut_button = tk.Button(button_frame, text="Cut", command=self.cut)
        self.cut_button.pack(side="left", padx=5)

        self.paste_button = tk.Button(button_frame, text="Paste", command=self.paste)
        self.paste_button.pack(side="left", padx=5)

        self.undo_button = tk.Button(button_frame, text="Undo", command=self.undo, state="disabled")
        self.undo_button.pack(side="left", padx=5)

    def _on_text_modified(self, _event: tk.Event) -> None:
        self.display.edit_modified(False)
        self.editor.set_content(self.display.get("1.0", "end-1c"))

    def _get_selection_indices(self) -> tuple[int, int] | None:
        try:
            start_count = self.display.count("1.0", "sel.first")
            end_count = self.display.count("1.0", "sel.last")
        except tk.TclError:
            return None

        start = start_count[0] if start_count else 0
        end = end_count[0] if end_count else 0
        return start, end

    def _get_insert_position(self) -> int:
        position_count = self.display.count("1.0", "insert")
        return position_count[0] if position_count else 0

    def copy(self) -> None:
        indices = self._get_selection_indices()
        if indices is None:
            messagebox.showinfo("Copy", "Please select some text first.")
            return

        start, end = indices
        command = CopyCommand(self.editor, self.clipboard_ref, start, end)
        command.execute()

    def cut(self) -> None:
        indices = self._get_selection_indices()
        if indices is None:
            messagebox.showinfo("Cut", "Please select some text first.")
            return

        start, end = indices
        command = CutCommand(self.editor, self.clipboard_ref, start, end)
        if command.execute():
            self.history.push(command)
            self._refresh_display()
            self._sync_undo_state()

    def paste(self) -> None:
        position = self._get_insert_position()
        command = PasteCommand(self.editor, self.clipboard_ref, position)
        if command.execute():
            self.history.push(command)
            self._refresh_display()
            self._sync_undo_state()

    def undo(self) -> None:
        if self.history.undo_last():
            self._refresh_display()
        self._sync_undo_state()

    def _sync_undo_state(self) -> None:
        state = "normal" if self.history.can_undo() else "disabled"
        self.undo_button.configure(state=state)

    def _refresh_display(self) -> None:
        cursor = self.display.index("insert")
        self.display.delete("1.0", "end")
        self.display.insert("1.0", self.editor.get_content())
        self.display.mark_set("insert", cursor)
        self.display.edit_modified(False)
