"""Command history used for undo support."""

from __future__ import annotations

from .commands import Command


class CommandHistory:
    """A simple stack of executed commands that can be undone."""

    def __init__(self) -> None:
        self._stack: list[Command] = []

    def push(self, command: Command) -> None:
        self._stack.append(command)

    def can_undo(self) -> bool:
        return bool(self._stack)

    def undo_last(self) -> bool:
        if not self._stack:
            return False

        command = self._stack.pop()
        command.undo()
        return True
