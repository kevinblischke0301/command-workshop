"""Receiver implementation for the sample solution."""


class TextEditor:
    """A minimal document model built around a single string of text."""

    def __init__(self) -> None:
        self._content: str = ""

    def get_content(self) -> str:
        return self._content

    def set_content(self, content: str) -> None:
        self._content = content

    def get_text(self, start: int, end: int) -> str:
        return self._content[start:end]

    def insert_text(self, position: int, text: str) -> None:
        self._content = self._content[:position] + text + self._content[position:]

    def delete_text(self, start: int, end: int) -> str:
        removed = self._content[start:end]
        self._content = self._content[:start] + self._content[end:]
        return removed
