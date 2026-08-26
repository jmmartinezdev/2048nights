# 2048nights

A SwiftUI implementation of the classic [2048](https://en.wikipedia.org/wiki/2048_(video_game)) puzzle game. The app is a single Apple multiplatform target that runs on **iPhone**, **iPad**, and **Mac**.

## Tech stack

- **Language:** Swift 5.0
- **UI framework:** SwiftUI
- **Reactivity:** Combine (`ObservableObject` + `@Published`)
- **Persistence:** `UserDefaults` (high score only)
- **Localization:** `Localizable.xcstrings` (currently English + Spanish)
- **Build system:** Xcode 16 project (`2048nights.xcodeproj`), `objectVersion = 77`
- **Deployment target:** iOS 18.0
- **Targeted device family:** `1,2` (iPhone + iPad) — Mac runs via "Designed for iPad" / Mac Catalyst from the same target
- **Bundle identifier:** `dev.jmmartinez.-048nights`
- **No external dependencies** (no SwiftPM, CocoaPods, or Carthage manifests)

## Repository layout

```
2048nights/
├── 2048nights.xcodeproj/        # Xcode project (uses PBXFileSystemSynchronizedRootGroup, no manual file refs)
├── 2048nights/
│   ├── _048nightsApp.swift      # @main App entry point
│   ├── Models/
│   │   ├── GameModel.swift      # Top-level game state, move logic, win/lose detection
│   │   ├── BoardModel.swift     # 2D grid of cells, random tile spawning
│   │   ├── CellModel.swift      # Per-tile value, merge/newly-added flags, color mapping
│   │   └── ScoreModel.swift     # Current score + high-score persistence
│   ├── Views/
│   │   ├── ContentView.swift           # Root view; wires gestures and keyboard input
│   │   ├── BoardView.swift             # 4x4 grid layout
│   │   ├── CellView.swift              # Tile rendering + merge/spawn animations
│   │   ├── ScoreContainerView.swift    # Score + high score display
│   │   ├── RestartGameView.swift       # "Restart" button
│   │   ├── GameOverMessageView.swift   # Game-over overlay
│   │   ├── WinMessageView.swift        # 2048-reached overlay (with "continue playing")
│   │   └── ArrowButtonsView.swift      # On-screen arrow buttons (currently unused; kept for reference)
│   ├── Assets.xcassets/         # App icon, accent color, and per-tile color sets (cellBackground8 … 2048, Lower, Higher, Empty)
│   ├── Localizable.xcstrings    # String catalog (en, es)
│   └── Preview Content/         # SwiftUI preview assets
├── LICENSE
└── README.md
```

## Architecture

The app follows a lightweight **MVVM-style** structure where the `Models` are also the view-models — they conform to `ObservableObject` and are observed directly by SwiftUI views via `@ObservedObject`.

```
GameModel (ObservableObject)
├── board: BoardModel        ── 2D [[CellModel]] grid
│   └── cells: CellModel     ── value, isMerged, newlyAdded
├── score: ScoreModel        ── score + UserDefaults high score
├── hasWon, gameOver, continuePlaying: Bool
```

### Game loop (in `GameModel.move(direction:)`)

For each swipe / arrow press:

1. `board.prepareForMove()` clears `isMerged` / `newlyAdded` flags from the previous turn.
2. Cells are iterated in an order determined by `getOrderedIndices(direction:)` so tiles always slide toward the move direction.
3. For each non-empty cell, `findFurthestEmptyCell` walks along the direction vector to slide the tile.
4. If the next cell after the slide holds the same value and hasn't already merged this turn, the two tiles are merged (value doubled, `score` incremented, `isMerged` set).
5. If anything moved, `board.addNewRandomValue()` spawns a new tile (90% `2`, 10% `4`), the high score is updated, and `areMovesPossible()` checks for game over.
6. Reaching `2048` flips `hasWon = true`; the player can dismiss the win overlay and keep playing via `continuePlaying`.

### Input handling

`ContentView` supports both input modes simultaneously:

- **Drag gestures** — `DragGesture(minimumDistance: 20)` on the board; `computeGesture` picks the dominant axis. Used on iPhone/iPad touch.
- **Keyboard** — `.onKeyPress(keys: [.upArrow, .downArrow, .leftArrow, .rightArrow])` on a focusable view, with `@FocusState` claiming focus on appear. Used on Mac and iPad with a hardware keyboard.

`ArrowButtonsView` exists but is currently commented out in `ContentView`.

### Theming & assets

Every tile value (2–2048, plus `Lower` for <8 and `Higher` for >2048) has its own named color set in `Assets.xcassets/cellBackgrounds/`. Cell colors are resolved in `CellModel.getBackgroundColor()`. Other named colors (`contentBackground`, `boardLines`, `buttonBackground`, `cellText`, `gameOverBackground`, `winText`, etc.) drive the rest of the UI and have light/dark variants in the asset catalog.

### Localization

User-visible strings (`restart_game`, `empty_cell`, win/lose messages, etc.) live in `Localizable.xcstrings`. Known regions: `en`, `es` (declared in `project.pbxproj` under `knownRegions`). Use string keys directly in `Text(...)` and `String(localized:)` — do not hardcode display strings.

## Build & run

Open the project in Xcode 16+ and run any of the schemes:

```bash
open 2048nights.xcodeproj
```

From the command line:

```bash
# Build for the iOS Simulator
xcodebuild -project 2048nights.xcodeproj -scheme 2048nights \
  -destination 'platform=iOS Simulator,name=iPhone 16' build

# Build for Mac (Designed for iPad)
xcodebuild -project 2048nights.xcodeproj -scheme 2048nights \
  -destination 'platform=macOS,variant=Mac Catalyst' build
```

There are currently **no unit tests, UI tests, linters, or CI configuration** in the repo. `BoardModel` does have a test-only convenience initializer (`init(size:board:)`) and an `exampleBoard` static fixture in a `// MARK: Extension for testing` block, ready for tests to be added.

## Branches

- `main` — release branch
- `develop` — active development branch (default working branch)

## Conventions & tips for changes

- **Models own state.** Views should not mutate game state directly; route through `GameModel` (e.g. `model.move(direction:)`, `model.resetGame()`).
- **New tile values** need a corresponding color set in `Assets.xcassets/cellBackgrounds/` plus a branch in `CellModel.getBackgroundColor()` and possibly `CellView.getFontSize()`.
- **New strings** must be added to `Localizable.xcstrings` for all known regions; reference them via the string-catalog key, not a hardcoded literal.
- **Board size is parameterised** (`GameModel(boardSize:)` / `BoardModel(size:)`), defaulting to `4`. The win condition (`2048`) is hardcoded in `GameModel.move`; if you generalise the board size you may also want to make the win threshold configurable.
- **Animations** for newly-added and merged tiles are driven by `@Published` flags on `CellModel` (`newlyAdded`, `isMerged`) consumed via `.onReceive` in `CellView`. `BoardModel.prepareForMove()` is responsible for resetting them at the start of each move.
- The `print(...)` statements in `GameModel.move` and `BoardModel.addNewRandomValue` are debug logging — feel free to remove or gate behind a debug flag if you touch those files.
