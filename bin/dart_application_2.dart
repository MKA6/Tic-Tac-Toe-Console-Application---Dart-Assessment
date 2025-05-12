import 'dart:io';

void main() {
  print('Welcome to Tic-Tac-Toe!');
  print('Type "exit" at any time to quit the game.\n');

  while (true) {
    // Initialize the game
    final game = TicTacToe();
    game.play();

    // Ask if players want to play again
    print('\nWould you like to play again? (y/n)');
    String? playAgain;
    do {
      playAgain = stdin.readLineSync()?.toLowerCase();
      if (playAgain == 'exit') {
        print('Thanks for playing! Goodbye.');
        exit(0);
      }
      if (playAgain != 'y' && playAgain != 'n') {
        print('Invalid input. Please enter "y", "n", or "exit":');
      }
    } while (playAgain != 'y' && playAgain != 'n');

    if (playAgain == 'n') {
      print('Thanks for playing! Goodbye.');
      break;
    }
  }
}

class TicTacToe {
  late List<String> board;
  late String currentPlayer;
  late bool againstComputer;
  late String humanMarker;
  late String computerMarker;
  TicTacToe() {
    board = List.generate(9, (index) => (index + 1).toString());
    currentPlayer = 'X';

    // The question is do you want to play with the computer or not?
    print('\nDo you want to play against the computer? (y/n)');
    String? input;
    do {
      input = stdin.readLineSync()?.toLowerCase();
      if (input == 'exit') {
        print('Thanks for playing! Goodbye.');
        exit(0);
      }
      if (input != 'y' && input != 'n') {
        print('Invalid input. Please enter "y" or "n" or "exit":');
      }
    } while (input != 'y' && input != 'n');

    againstComputer = input == 'y';

    if (againstComputer) {
      // Choose your own symbol to play with.
      print('\nChoose the appropriate code (X or O):');
      humanMarker = stdin.readLineSync()!.toUpperCase();
      while (humanMarker != 'X' && humanMarker != 'O') {
        if (humanMarker == 'EXIT') {
          print('Thanks for playing! Goodbye.');
          exit(0);
        }
        print('The code is invalid. Please choose one of these codes: X or O:');
        humanMarker = stdin.readLineSync()!.toUpperCase();
      }
      computerMarker = humanMarker == 'X' ? 'O' : 'X';
      currentPlayer = 'X'; //I made X always play first
    }
  }

  void play() {
    print('\nGame started!');
    printBoard();

    while (true) {
      if (againstComputer && currentPlayer == computerMarker) {
        // Computer's turn
        print('\nComputer\'s turn ($computerMarker):');
        makeComputerMove();
      } else {
        // The role of the player (human) against the computer
        print('\nPlayer $currentPlayer\'s turn. Enter position (1-9):');
        int? position;
        do {
          final input = stdin.readLineSync();
          if (input?.toLowerCase() == 'exit') {
            print('Thanks for playing! Goodbye.');
            exit(0);
          }
          position = int.tryParse(input ?? '');

          if (position == null || position < 1 || position > 9) {
            print(
              'You have entered an invalid value. Please enter a number between 1 and 9.',
            );
            continue;
          }

          if (board[position - 1] != position.toString()) {
            print(
              'This place is already booked (there is a code inside it). Please choose another value.',
            );
            position = null; // Force retry
          }
        } while (position == null);

        board[position - 1] = currentPlayer;
      }

      printBoard();

      // Check if there is a winner or we continue the game
      if (checkWinner()) {
        if (againstComputer && currentPlayer == computerMarker) {
          print('The computer\'s artificial intelligence wins!!');
        } else {
          print('Player $currentPlayer wins!');
        }
        break;
      }

      if (isDraw()) {
        print('The game is a draw!');
        break;
      }

      // Switch players
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    }
  }

  void printBoard() {
    print('\n ${board[0]} | ${board[1]} | ${board[2]} ');
    print('-----------');
    print(' ${board[3]} | ${board[4]} | ${board[5]} ');
    print('-----------');
    print(' ${board[6]} | ${board[7]} | ${board[8]} \n');
  }

  bool checkWinner() {
    // Check the winner
    for (int i = 0; i < 9; i += 3) {
      if (board[i] == board[i + 1] && board[i] == board[i + 2]) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[i] == board[i + 3] && board[i] == board[i + 6]) {
        return true;
      }
    }

    // Check diagonals
    if (board[0] == board[4] && board[0] == board[8]) {
      return true;
    }
    if (board[2] == board[4] && board[2] == board[6]) {
      return true;
    }

    return false;
  }

  bool isDraw() {
    return board.every((cell) => cell == 'X' || cell == 'O');
  }

  void makeComputerMove() {
    // Simple AI: first try to win, then block, then choose center, then corners, then random
    int? move;

    //Make an attempt to win
    move = findWinningMove(computerMarker);

    // Try to counter the opponent if there is no winning move.
    if (move == null) {
      move = findWinningMove(humanMarker);
    }

    // Choose center if available
    if (move == null && board[4] == '5') {
      move = 4;
    }

    // Randomly choose the angle if available.
    if (move == null) {
      final corners = [0, 2, 6, 8];
      final availableCorners =
          corners.where((i) => board[i] != 'X' && board[i] != 'O').toList();
      if (availableCorners.isNotEmpty) {
        move = availableCorners.first;
      }
    }

    //Choose random movement if there is no better option.
    if (move == null) {
      final availableMoves =
          board
              .asMap()
              .entries
              .where((e) => e.value != 'X' && e.value != 'O')
              .map((e) => e.key)
              .toList();
      if (availableMoves.isNotEmpty) {
        move = availableMoves.first;
      }
    }

    if (move != null) {
      board[move] = computerMarker;
    }
  }

  int? findWinningMove(String marker) {
    for (int i = 0; i < 9; i++) {
      if (board[i] != 'X' && board[i] != 'O') {
        final originalValue = board[i];
        board[i] = marker;
        if (checkWinner()) {
          board[i] = originalValue; // Undo the test move
          return i;
        }
        board[i] = originalValue; // Undo the test move
      }
    }
    return null;
  }
}
