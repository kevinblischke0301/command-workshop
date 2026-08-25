"""The receiver of the text editor.

`TextEditor` owns the document text and knows how to change it. It has no
idea that buttons, commands, or an undo history exist.
"""


class TextEditor:
    """A minimal document model built around a single string of text."""

    def __init__(self) -> None:
        """Create an empty document as the receiver for later commands."""
        self._content: str = ""

    def get_content(self) -> str:
        """Return the current text content."""
        return self._content

    def set_content(self, content: str) -> None:
        """Replace the whole text content."""
        self._content = content

    def get_text(self, start: int, end: int) -> str:
        """Return the substring between two character positions."""
        return self._content[start:end]

    def insert_text(self, position: int, text: str) -> None:
        """Insert `text` at `position`."""
        self._content = self._content[:position] + text + self._content[position:]

    def delete_text(self, start: int, end: int) -> str:
        """Delete the text between two positions and return what was removed."""
        removed = self._content[start:end]
        self._content = self._content[:start] + self._content[end:]
        return removed
