-- N-Queens Puzzle (iOS) --
A SwiftUI-based puzzle game where the player solves a variant of the 8-Queens problem by placing queens on a chessboard such that no two queens threaten each other. In this version, the player can select a board size from 4x4 to 16x16. Allowing for more puzzle variation than the traditional 8x8 with 8 queens board.



-- Demo Video --
Available on Google Drive
https://drive.google.com/file/d/18wiIcz70-r9gQsuBfTtElRNcHrD6nArB/view?usp=sharing

Also on YouTube (Be sure to like, comment, subscribe, and SMASH that bell icon to get future notifications!):
https://youtube.com/shorts/R5oPrCHNJSk



-- Getting Started --
- Requirements
iOS 26+
Xcode 26+
A basic knowledge of chess, specifically the queen piece.

- Build & Run
Clone the repository
Open QueensPuzzle.xcodeproj in Xcode
Select a simulator or device
Press Run (⌘R)
* Note: If you're having trouble running the app from Xcode on a simulator, try running it directly from the simulator, and not attached Xcode for debugging. Or disable "Debug executable" by going to Product -> Scheme -> Edit Scheme -> Run -> Info -> Executable -> Debug executable. On a candid note, there was like 4 macOS/iOS/Xcode updates within a few days, and I'm not entirely sure why my computer was having troubles all of the sudden. Maybe you won't struggle like I did. I'm still downloading and installing the new updates (again) at the moment.


- How To Run Internal Tests
Open the project in Xcode.
Select the QueensPuzzle scheme.
Press ⌘U to run tests, or use the Test navigator.



-- Gameplay Overview --
Select a board size. From 4x4 to 16x16.
Tap on the board tiles to place/remove queens.
Press "Show Hints" or "Hide Hints" to show/hide conflicting/threatening positions in real time.
Solve the puzzle by placing all of the queens on the board without any conflicts.
A win screen appears upon completion.



-- Architecture --
The project follows a lightweight MVVM-inspired structure, with clear separation of logic and functions.

- Core Components
Board (Model)
* Responsible for all puzzle logic.
* Tracks queen positions and updates conflicting positions.
* Determines the solved state.

GameViewModel
* Manages game state (timer, win condition, persistence).
* Acts as the bridge between UI and game logic.

Views (SwiftUI)
* BoardSelectionView: Lets the player choose the puzzle size, and displays best completion time for the currently selected size.
* GameView: The main gameplay interface. It also includes puzzle size, queens remaining, and elapsed time. As well as the Show Hints button, and a button to reset the board.
* TileView: Handles visual variations between individual board tiles.
* WinScreen: The win screen! Technically a child view within the GameView. Displays the player's completion time, the current best time, a View Solution button (which dismisses the win screen) and a Menu button (which brings the player back to the main menu).



- Design Decisions
Puzzle logic is fully separated from UI to enable testability and scalability.
Game State is centralized in the GameViewModel.
GeometryReader is used to dynamically size the board to the screen's size.
While the board size/number of queens can't be less than 4, I first assumed that the maximum board size should be 8. But upon review of the assignment directions, it didn't state this. I decided to make 16 the maximum, because any higher numbers caused the tiles to be too small to press on the screen.



-- Testing Strategy --
The project's unit testing focuses on the core game logic, where correctness is most critical, predictable/deterministic.
The majority of tests target the Board model, ensuring that puzzle rules are implemented correctly and remain stable as the UI changes.

- Covered Areas
Board initialization and tile configuration. Including light/dark square layout.
Queen placement and removal.
Conflict/threat detection across rows, columns, and diagonals.
Win condition validation for both valid and invalid board states.
Board resetting behavior.
Best Time persistence logic. Including only saving improved times.

In addition, the GameViewModel is tested to verify key gameplay flows such as win detection, state transitions, and reset behavior. Dependencies like persistence are isolated using in-memory implementations to keep tests deterministic and independent from external state.



-- AI Usage Disclosure -- 
Portions of this project were developed with the assistance of AI tools for education, refinement, the main App Icon, and generally telling me that I did everything wrong and have to start over. All code was reviewed, understood, and adapted to ensure correctness and maintainability.



-- Future Improvements --
* Implement an iCloud sync, rather than UserDefaults, to save best times in the cloud. To sync across different devices.
* Add more personalized animations, and sound effects.
* Multi-lingual implementation. Rather than a Localization file, and helper code, all in-game text is stored in-line. I thought it was somewhat outside the scope of the assignment to add this now.
* Accessibility implementations.
* Better UI! More color! While the game board is colored to match the Chess.com default board, right now most of the UI is black, white, and gray. I did add some beautification in terms of spacing, font size, and using the new GlassEffect. Overall, the UI is pretty lackluster at the moment.
* Moves tracker. Keep track of how many 'moves' the user made, and keep that as a score. Either in addition to, or instead of the timer.
* Visible queen tokens at the top of the board, which can be 'picked up' by the user, and placed down on the board. Also to pick them up and remove them from the board. Note: I did start to add this functionality, but the code nearly doubled in size before I had a working prototype. So, I decided to not include it for the sake of simplicity.
* Explore possible implementation of higher than 16x16 boards by having the user zoom in and out. This might not be practical, or intuitive.



-- Notes for Reviewers --
The core puzzle logic lives in QueensPuzzle/Models/BoardModels.swift.
Conflict detection and win validation are handled independently of UI.
The app is designed to be easily extendable for any additions, or discussion during follow-up.
