// Command Design Pattern — Workshop Introduction
// Based on: https://refactoring.guru/design-patterns/command

#set page(
  paper: "presentation-16-9",
  margin: 0pt,
  fill: rgb("#10141C"),
)

#set text(
  font: "Libertinus Sans",
  fill: rgb("#F4F6F8"),
)

// ---------------------------------------------------------------------------
// Theme
// ---------------------------------------------------------------------------

#let accent = rgb("#6CB6FF")
#let accent2 = rgb("#8BE9A8")
#let muted = rgb("#A9B2C0")
#let card = rgb("#1A202C")
#let card2 = rgb("#222A38")

// ---------------------------------------------------------------------------
// Helper functions
// ---------------------------------------------------------------------------

#let title(content) = [
  #text(
    size: 30pt,
    weight: "bold",
    fill: accent,
  )[
    #content
  ]
]

#let subtitle(content) = [
  #text(
    size: 18pt,
    fill: muted,
  )[
    #content
  ]
]

#let bullet(content, color: rgb("#F4F6F8")) = [
  #box(width: 10pt)[
    #text(
      fill: accent,
      size: 16pt,
    )[•]
  ]
  #h(8pt)
  #text(
    size: 18pt,
    fill: color,
  )[
    #content
  ]
]

#let small(content) = [
  #text(
    size: 11pt,
    fill: muted,
  )[
    #content
  ]
]

// ---------------------------------------------------------------------------
// Slide template
// ---------------------------------------------------------------------------

#let slide(content) = {
  page(
    paper: "presentation-16-9",
    margin: (x: 55pt, y: 42pt),
    fill: rgb("#10141C"),

    header: [
      #box(width: 100%)[
        #align(right)[
          #text(
            size: 9pt,
            fill: rgb("#596273"),
          )[COMMAND PATTERN]
        ]
      ]
    ],

    footer: [
      #box(width: 100%)[
        #line(
          length: 100%,
          stroke: 0.5pt + rgb("#2B3342"),
        )

        #v(5pt)

        #align(right)[
          #text(
            size: 8pt,
            fill: rgb("#596273"),
          )[Workshop introduction]
        ]
      ]
    ],
  )[
    #content
  ]
}

// ===========================================================================
// 1 — Title
// ===========================================================================

#slide[
  #v(70pt)

  #text(
    size: 46pt,
    weight: "bold",
  )[
    The Command Pattern
  ]

  #v(12pt)

  #text(
    size: 23pt,
    fill: accent,
  )[
    Turning requests into objects
  ]

  #v(30pt)

  #text(
    size: 17pt,
    fill: muted,
  )[
    A short conceptual introduction
  ]

  #v(55pt)

  #align(right)[
    #text(
      size: 13pt,
      fill: rgb("#778194"),
    )[
      Design Patterns Workshop
    ]
  ]
]

// ===========================================================================
// 2 — Learning goal
// ===========================================================================

#slide[
  #title[Learning Goal]

  #v(18pt)

  #subtitle[
    By the end of this introduction, you should be able to explain:
  ]

  #v(22pt)

  #bullet[What problem the Command pattern solves]

  #v(12pt)

  #bullet[What a Command actually represents]

  #v(12pt)

  #bullet[The roles: Client, Command, Invoker, Receiver]

  #v(12pt)

  #bullet[Why this reduces coupling]

  #v(12pt)

  #bullet[When the pattern becomes useful]
]

// ===========================================================================
// 3 — The Problem
// ===========================================================================

#slide[
  #title[The Problem]

  #v(15pt)

  #subtitle[
    Imagine a text editor with many ways to trigger the same operation.
  ]

  #v(25pt)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 15pt,

    [
      #box(
        width: 100%,
        inset: 18pt,
        radius: 8pt,
        fill: card,
      )[
        #text(
          size: 20pt,
          weight: "bold",
        )[Toolbar]

        #v(10pt)

        #text(
          size: 14pt,
          fill: muted,
        )[Copy / Cut / Paste]
      ]
    ],

    [
      #box(
        width: 100%,
        inset: 18pt,
        radius: 8pt,
        fill: card,
      )[
        #text(
          size: 20pt,
          weight: "bold",
        )[Context menu]

        #v(10pt)

        #text(
          size: 14pt,
          fill: muted,
        )[Copy / Cut / Paste]
      ]
    ],

    [
      #box(
        width: 100%,
        inset: 18pt,
        radius: 8pt,
        fill: card,
      )[
        #text(
          size: 20pt,
          weight: "bold",
        )[Keyboard]

        #v(10pt)

        #text(
          size: 14pt,
          fill: muted,
        )[Ctrl+C / Ctrl+X / Ctrl+V]
      ]
    ],
  )

  #v(28pt)

  #align(center)[
    #text(
      size: 20pt,
      fill: rgb("#FFB86C"),
    )[
      Where should the actual operation live?
    ]
  ]
]

// ===========================================================================
// 4 — The Naive Solution
// ===========================================================================

#slide[
  #title[The Naive Solution]

  #v(15pt)

  #subtitle[
    Let each UI element know how to perform the operation.
  ]

  #v(35pt)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 20pt,

    [
      #box(
        width: 100%,
        inset: 18pt,
        radius: 8pt,
        fill: card,
      )[
        #align(center)[
          #text(
            size: 20pt,
            weight: "bold",
          )[Button]

          #v(10pt)

          #text(
            size: 17pt,
            fill: accent,
          )[↓]

          #v(10pt)

          #text(size: 17pt)[Editor.copy()]
        ]
      ]
    ],

    [
      #box(
        width: 100%,
        inset: 18pt,
        radius: 8pt,
        fill: card,
      )[
        #align(center)[
          #text(
            size: 20pt,
            weight: "bold",
          )[MenuItem]

          #v(10pt)

          #text(
            size: 17pt,
            fill: accent,
          )[↓]

          #v(10pt)

          #text(size: 17pt)[Editor.copy()]
        ]
      ]
    ],

    [
      #box(
        width: 100%,
        inset: 18pt,
        radius: 8pt,
        fill: card,
      )[
        #align(center)[
          #text(
            size: 20pt,
            weight: "bold",
          )[Shortcut]

          #v(10pt)

          #text(
            size: 17pt,
            fill: accent,
          )[↓]

          #v(10pt)

          #text(size: 17pt)[Editor.copy()]
        ]
      ]
    ],
  )

  #v(28pt)

  #align(center)[
    #text(
      size: 19pt,
      fill: rgb("#FFB86C"),
    )[
      Same operation — duplicated knowledge.
    ]
  ]
]

// ===========================================================================
// 5 — The Key Idea
// ===========================================================================

#slide[
  #title[The Key Idea]

  #v(18pt)

  #subtitle[
    Instead of passing a request directly, turn it into an object.
  ]

  #v(40pt)

  #align(center)[
    #grid(
      columns: (1fr, 0.25fr, 1.2fr, 0.25fr, 1fr),
      align: center,
      gutter: 10pt,

      [
        #box(
          inset: 20pt,
          radius: 10pt,
          fill: card,
        )[
          #text(
            size: 20pt,
            weight: "bold",
          )[Request]

          #v(10pt)

          #text(
            size: 15pt,
            fill: muted,
          )[
            "Copy the selected text"
          ]
        ]
      ],

      [
        #text(
          size: 25pt,
          fill: accent,
        )[→]
      ],

      [
        #box(
          inset: 24pt,
          radius: 10pt,
          stroke: 2pt + accent,
          fill: card2,
        )[
          #text(
            size: 25pt,
            weight: "bold",
            fill: accent,
          )[CopyCommand]

          #v(10pt)

          #text(
            size: 14pt,
            fill: muted,
          )[
            An object representing the request
          ]
        ]
      ],

      [
        #text(
          size: 25pt,
          fill: accent,
        )[→]
      ],

      [
        #box(
          inset: 20pt,
          radius: 10pt,
          fill: card,
        )[
          #text(
            size: 20pt,
            weight: "bold",
          )[execute()]

          #v(10pt)

          #text(
            size: 15pt,
            fill: muted,
          )[
            Perform the request
          ]
        ]
      ],
    )
  ]

  #v(40pt)

  #align(center)[
    #text(
      size: 19pt,
      fill: accent2,
    )[
      The request itself becomes a first-class object.
    ]
  ]
]

// ===========================================================================
// 6 — Commands
// ===========================================================================

#slide[
  #title[Commands]

  #v(18pt)

  #subtitle[
    A Command turns a request into a stand-alone object.
  ]

  #v(25pt)

  #grid(
    columns: (1fr, 1fr),
    gutter: 35pt,

    [
      #text(
        size: 18pt,
        weight: "bold",
        fill: accent,
      )[A request]

      #v(15pt)

      #text(size: 17pt)["Delete these files"]

      #v(8pt)

      #text(size: 17pt)["Send this message"]

      #v(8pt)

      #text(size: 17pt)["Save this document"]
    ],

    [
      #text(
        size: 18pt,
        weight: "bold",
        fill: accent2,
      )[A Command object]

      #v(15pt)

      #text(
        size: 17pt,
      )[
        Contains the information needed
        to execute the request.
      ]

      #v(15pt)

      #text(
        size: 15pt,
        fill: muted,
      )[Typically:]

      #v(8pt)

      #bullet[the receiver]

      #v(5pt)

      #bullet[the operation]

      #v(5pt)

      #bullet[the required parameters]
    ],
  )
]

// ===========================================================================
// 7 — Common Interface
// ===========================================================================

#slide[
  #title[Common Interface]

  #v(18pt)

  #subtitle[
    The caller doesn't need to know which concrete operation it is triggering.
  ]

  #v(35pt)

  #align(center)[
    #grid(
      columns: (1fr, 0.3fr, 1.4fr),
      gutter: 15pt,
      align: center,

      [
        #box(
          inset: 22pt,
          radius: 8pt,
          stroke: 2pt + accent,
          fill: card2,
        )[
          #text(
            size: 24pt,
            weight: "bold",
            fill: accent,
          )[Command]

          #v(10pt)

          #text(size: 18pt)[execute()]
        ]
      ],

      [
        #text(
          size: 25pt,
          fill: accent,
        )[→]
      ],

      [
        #grid(
          columns: (1fr, 1fr, 1fr),
          gutter: 12pt,

          [
            #box(
              inset: 16pt,
              radius: 7pt,
              fill: card,
            )[
              #text(size: 16pt)[CopyCommand]
            ]
          ],

          [
            #box(
              inset: 16pt,
              radius: 7pt,
              fill: card,
            )[
              #text(size: 16pt)[CutCommand]
            ]
          ],

          [
            #box(
              inset: 16pt,
              radius: 7pt,
              fill: card,
            )[
              #text(size: 16pt)[PasteCommand]
            ]
          ],
        )
      ],
    )
  ]

  #v(35pt)

  #align(center)[
    #text(
      size: 18pt,
      fill: muted,
    )[
      Different operations · same interface
    ]
  ]
]

// ===========================================================================
// 8 — The Main Roles
// ===========================================================================

#slide[
  #title[The Main Roles]

  #v(15pt)

  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,

    [
      #box(
        inset: 18pt,
        radius: 8pt,
        fill: card,
      )[
        #text(
          size: 20pt,
          weight: "bold",
          fill: accent,
        )[Client]

        #v(8pt)

        #text(
          size: 14pt,
          fill: muted,
        )[
          Creates and configures commands.
        ]
      ]
    ],

    [
      #box(
        inset: 18pt,
        radius: 8pt,
        fill: card,
      )[
        #text(
          size: 20pt,
          weight: "bold",
          fill: accent,
        )[Invoker]

        #v(8pt)

        #text(
          size: 14pt,
          fill: muted,
        )[
          Triggers a command.
          Does not perform the business operation.
        ]
      ]
    ],

    [
      #box(
        inset: 18pt,
        radius: 8pt,
        fill: card,
      )[
        #text(
          size: 20pt,
          weight: "bold",
          fill: accent2,
        )[Command]

        #v(8pt)

        #text(
          size: 14pt,
          fill: muted,
        )[
          Defines the common execution interface.
        ]
      ]
    ],

    [
      #box(
        inset: 18pt,
        radius: 8pt,
        fill: card,
      )[
        #text(
          size: 20pt,
          weight: "bold",
          fill: accent2,
        )[Receiver]

        #v(8pt)

        #text(
          size: 14pt,
          fill: muted,
        )[
          Contains the actual business logic.
        ]
      ]
    ],
  )
]

// ===========================================================================
// 9 — The Interaction
// ===========================================================================

#slide[
  #title[The Interaction]

  #v(18pt)

  #subtitle[
    Each role has a different responsibility.
  ]

  #v(45pt)

  #align(center)[
    #grid(
      columns: (1fr, 0.3fr, 1fr, 0.3fr, 1fr),
      gutter: 10pt,
      align: center,

      [
        #box(
          inset: 20pt,
          radius: 8pt,
          fill: card,
        )[
          #text(
            size: 21pt,
            weight: "bold",
          )[Invoker]

          #v(10pt)

          #text(
            size: 14pt,
            fill: muted,
          )[
            "Execute this command"
          ]
        ]
      ],

      [
        #text(
          size: 25pt,
          fill: accent,
        )[→]
      ],

      [
        #box(
          inset: 20pt,
          radius: 8pt,
          fill: card2,
        )[
          #text(
            size: 21pt,
            weight: "bold",
            fill: accent,
          )[Command]

          #v(10pt)

          #text(
            size: 14pt,
            fill: muted,
          )[
            Knows what to execute
          ]
        ]
      ],

      [
        #text(
          size: 25pt,
          fill: accent,
        )[→]
      ],

      [
        #box(
          inset: 20pt,
          radius: 8pt,
          fill: card,
        )[
          #text(
            size: 21pt,
            weight: "bold",
            fill: accent2,
          )[Receiver]

          #v(10pt)

          #text(
            size: 14pt,
            fill: muted,
          )[
            Does the actual work
          ]
        ]
      ],
    )
  ]

  #v(40pt)

  #align(center)[
    #text(
      size: 18pt,
      fill: muted,
    )[
      The Invoker doesn't need to know how the operation works.
    ]
  ]
]

// ===========================================================================
// 10 — The Decoupling
// ===========================================================================

#slide[
  #title[The Decoupling]

  #v(20pt)

  #grid(
    columns: (1fr, 1fr),
    gutter: 30pt,

    [
      #text(
        size: 19pt,
        weight: "bold",
        fill: rgb("#FF7B72"),
      )[Before]

      #v(18pt)

      #box(
        inset: 20pt,
        radius: 8pt,
        fill: card,
      )[
        #text(size: 17pt)[UI element]

        #v(8pt)

        #text(
          size: 18pt,
          fill: rgb("#FF7B72"),
        )[↓]

        #v(8pt)

        #text(size: 17pt)[concrete business logic]
      ]

      #v(18pt)

      #text(
        size: 14pt,
        fill: muted,
      )[
        The caller needs to understand the operation.
      ]
    ],

    [
      #text(
        size: 19pt,
        weight: "bold",
        fill: accent2,
      )[After]

      #v(18pt)

      #box(
        inset: 20pt,
        radius: 8pt,
        fill: card,
      )[
        #text(size: 17pt)[UI element]

        #v(8pt)

        #text(
          size: 18pt,
          fill: accent2,
        )[↓]

        #v(8pt)

        #text(
          size: 17pt,
          fill: accent,
        )[Command]

        #v(8pt)

        #text(
          size: 18pt,
          fill: accent2,
        )[↓]

        #v(8pt)

        #text(size: 17pt)[business logic]
      ]

      #v(18pt)

      #text(
        size: 14pt,
        fill: muted,
      )[
        The caller only depends on the Command interface.
      ]
    ],
  )
]

// ===========================================================================
// 11 — The Consequence
// ===========================================================================

#slide[
  #title[The Consequence]

  #v(20pt)

  #text(
    size: 24pt,
    fill: accent,
  )[
    A command can be treated like data.
  ]

  #v(25pt)

  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,

    [
      #bullet[Pass it around]

      #v(10pt)

      #bullet[Store it]

      #v(10pt)

      #bullet[Replace it]
    ],

    [
      #bullet[Queue it]

      #v(10pt)

      #bullet[Delay its execution]

      #v(10pt)

      #bullet[Log or serialize it]
    ],
  )

  #v(30pt)

  #align(center)[
    #text(
      size: 20pt,
      fill: accent2,
    )[
      Execution becomes something we can manage.
    ]
  ]
]

// ===========================================================================
// 12 — Undo & Redo
// ===========================================================================

#slide[
  #title[Undo & Redo]

  #v(18pt)

  #subtitle[
    Commands can represent a history of operations.
  ]

  #v(40pt)

  #align(center)[
    #grid(
      columns: (1fr, 0.25fr, 1fr, 0.25fr, 1fr),
      gutter: 12pt,
      align: center,

      [
        #box(
          inset: 20pt,
          radius: 8pt,
          fill: card,
        )[
          #text(
            size: 20pt,
            weight: "bold",
          )[Command A]
        ]
      ],

      [
        #text(
          size: 22pt,
          fill: accent,
        )[→]
      ],

      [
        #box(
          inset: 20pt,
          radius: 8pt,
          fill: card,
        )[
          #text(
            size: 20pt,
            weight: "bold",
          )[Command B]
        ]
      ],

      [
        #text(
          size: 22pt,
          fill: accent,
        )[→]
      ],

      [
        #box(
          inset: 20pt,
          radius: 8pt,
          fill: card,
        )[
          #text(
            size: 20pt,
            weight: "bold",
          )[Command C]
        ]
      ],
    )
  ]

  #v(35pt)

  #align(center)[
    #text(
      size: 19pt,
      fill: muted,
    )[
      Command history
    ]

    #v(18pt)

    #text(
      size: 24pt,
      fill: accent2,
    )[
      ← undo
    ]

    #v(12pt)

    #text(
      size: 14pt,
      fill: muted,
    )[
      A command may contain enough information to
      restore the previous state or perform an inverse operation.
    ]
  ]
]

// ===========================================================================
// 13 — The Usage
// ===========================================================================

#slide[
  #title[The Usage]

  #v(18pt)

  #bullet[
    You want to parameterize an object with an operation.
  ]

  #v(12pt)

  #bullet[
    Several different UI elements should trigger the same operation.
  ]

  #v(12pt)

  #bullet[
    Operations need to be queued or scheduled.
  ]

  #v(12pt)

  #bullet[
    Operations should be logged, stored, or sent elsewhere.
  ]

  #v(12pt)

  #bullet[
    You need undo / redo or another form of operation history.
  ]
]

// ===========================================================================
// 14 — The Price
// ===========================================================================

#slide[
  #title[The Price]

  #v(20pt)

  #text(
    size: 22pt,
    fill: rgb("#FFB86C"),
  )[
    More indirection.
  ]

  #v(22pt)

  #bullet[
    A simple method call may become several objects.
  ]

  #v(12pt)

  #bullet[
    There are more classes and interfaces to understand.
  ]

  #v(12pt)

  #bullet[
    The pattern can be unnecessary for very simple code.
  ]

  #v(30pt)
]

// ===========================================================================
// 15 — The Mental Model
// ===========================================================================

#slide[
  #title[The Mental Model]

  #v(25pt)

  #align(center)[
    #text(size: 28pt)[Don't ask:]

    #v(10pt)

    #text(
      size: 23pt,
      fill: rgb("#FFB86C"),
    )[
      "How should the button perform this operation?"
    ]

    #v(28pt)

    #text(size: 28pt)[Ask:]

    #v(10pt)

    #text(
      size: 23pt,
      fill: accent2,
    )[
      "What object represents this operation?"
    ]
  ]
]

// ===========================================================================
// 16 — Cheat Sheet
// ===========================================================================

#slide[
  #title[Cheat Sheet]

  #v(25pt)

  #align(center)[
    #grid(
      columns: (1fr, 0.25fr, 1.2fr, 0.25fr, 1fr),
      gutter: 10pt,
      align: center,

      [
        #box(
          inset: 18pt,
          radius: 8pt,
          fill: card,
        )[
          #text(
            size: 21pt,
            weight: "bold",
          )[Client]

          #v(7pt)

          #text(
            size: 14pt,
            fill: muted,
          )[Creates the command]
        ]
      ],

      [
        #text(
          size: 23pt,
          fill: accent,
        )[→]
      ],

      [
        #box(
          inset: 20pt,
          radius: 8pt,
          stroke: 2pt + accent,
          fill: card2,
        )[
          #text(
            size: 22pt,
            weight: "bold",
            fill: accent,
          )[Command]

          #v(7pt)

          #text(
            size: 14pt,
            fill: muted,
          )[Represents the operation]
        ]
      ],

      [
        #text(
          size: 23pt,
          fill: accent,
        )[→]
      ],

      [
        #box(
          inset: 18pt,
          radius: 8pt,
          fill: card,
        )[
          #text(
            size: 21pt,
            weight: "bold",
            fill: accent2,
          )[Receiver]

          #v(7pt)

          #text(
            size: 14pt,
            fill: muted,
          )[Performs the operation]
        ]
      ],
    )
  ]

  #v(30pt)

  #align(center)[
    #box(
      inset: 14pt,
      radius: 8pt,
      fill: card,
    )[
      #text(
        size: 17pt,
        fill: muted,
      )[Invoker]

      #h(14pt)

      #text(
        size: 18pt,
        fill: accent,
      )[execute()]

      #h(14pt)

      #text(
        size: 17pt,
        fill: muted,
      )[
        "I don't need to know what the command does."
      ]
    ]
  ]
]

// ===========================================================================
// 17 — Transition to workshop
// ===========================================================================

#slide[
  #v(45pt)

  #align(center)[
    #text(
      size: 34pt,
      weight: "bold",
      fill: accent,
    )[
      Now let's build one.
    ]

    #v(20pt)

    #text(
      size: 20pt,
      fill: muted,
    )[
      We will start with the problem,
      then introduce the pattern step by step.
    ]

    #v(35pt)

    #box(
      inset: 18pt,
      radius: 8pt,
      fill: card,
    )[
      #text(size: 17pt)[Focus question:]

      #v(8pt)

      #text(
        size: 20pt,
        fill: accent2,
      )[
        "What should know what?"
      ]
    ]
  ]
]

// ===========================================================================
// 18 — Source
// ===========================================================================

#slide[
  #title[Source]

  #v(25pt)

  #text(size: 17pt)[
    Based on the Command pattern overview by Refactoring.Guru.
  ]

  #v(15pt)

  #text(
    size: 14pt,
    fill: muted,
  )[
    Command is described as a behavioral design pattern that
    turns a request into a stand-alone object containing the
    information required for that request.
  ]

  #v(30pt)

  #text(
    size: 13pt,
    fill: muted,
  )[Reference:]

  #v(5pt)

  #text(
    size: 13pt,
    fill: accent,
  )[
    Refactoring.Guru — Design Patterns / Command
  ]
]
