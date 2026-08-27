"""Command objects for text editor actions."""

from __future__ import annotations

from abc import ABC, abstractmethod

from .editor import TextEditor


class Command(ABC):
    """Common command interface used by the invoker."""

    @abstractmethod
    def execute(self) -> bool:
        """Run the command.

        Returns True when this command changed application state and can be
        added to history.
        """

    def undo(self) -> None:
        """Undo the command if supported."""


class CopyCommand(Command):
    """Copy selected text into a shared clipboard."""

    def __init__(self, editor: TextEditor, clipboard_ref: list[str], start: int, end: int) -> None:
        self._editor = editor
        self._clipboard_ref = clipboard_ref
        self._start = start
        self._end = end

    def execute(self) -> bool:
        self._clipboard_ref[0] = self._editor.get_text(self._start, self._end)
        return False


class CutCommand(Command):
    """Cut selected text and store enough state for undo."""

    def __init__(self, editor: TextEditor, clipboard_ref: list[str], start: int, end: int) -> None:
        self._editor = editor
        self._clipboard_ref = clipboard_ref
        self._start = start
        self._end = end
        self._cut_text = ""

    def execute(self) -> bool:
        self._cut_text = self._editor.delete_text(self._start, self._end)
        self._clipboard_ref[0] = self._cut_text
        return True

    def undo(self) -> None:
        self._editor.insert_text(self._start, self._cut_text)


class PasteCommand(Command):
    """Paste clipboard content and store enough state for undo."""

    def __init__(self, editor: TextEditor, clipboard_ref: list[str], position: int) -> None:
        self._editor = editor
        self._clipboard_ref = clipboard_ref
        self._position = position
        self._inserted_text = ""

    def execute(self) -> bool:
        self._inserted_text = self._clipboard_ref[0]
        if not self._inserted_text:
            return False

        self._editor.insert_text(self._position, self._inserted_text)
        return True

    def undo(self) -> None:
        end = self._position + len(self._inserted_text)
        self._editor.delete_text(self._position, end)
