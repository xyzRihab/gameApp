import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> gameBoard = List.filled(9, '');
  int currentPlayerIndex = 0;
  bool gameOver = false;
  String result = '';
  bool gameStarted = false;
  String player1Name = '';
  String player2Name = '';
  int player1Score = 0;
  int player2Score = 0;

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!gameStarted)
            Center(
              child: ElevatedButton(
                onPressed: _showNameDialog,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                child: Text(
                  'New Game',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          player1Name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '$player1Score',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          player2Name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '$player2Score',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40.0),
                Text(
                  "It's ${currentPlayerIndex == 0 ? player1Name : player2Name}'s turn",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: boardWidth,
                  height: boardWidth,
                  padding: EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    children: List.generate(9, (index) {
                      return InkWell(
                        onTap: gameOver
                            ? null
                            : () {
                                setState(() {
                                  if (gameBoard[index] == '') {
                                    gameBoard[index] =
                                        currentPlayerIndex == 0 ? 'X' : 'O';
                                    currentPlayerIndex =
                                        (currentPlayerIndex + 1) % 2;
                                    _checkGameResult();
                                  }
                                });
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Center(
                            child: Text(
                              gameBoard[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 25.0),
                ElevatedButton.icon(
                  onPressed: repeatGame,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  icon: Icon(Icons.replay, color: Colors.black),
                  label: Text(
                    'Repeat the Game',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                ElevatedButton(
                  onPressed: exitGame,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 176, 63, 55),
                  ),
                  child: Text(
                    'Exit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _checkGameResult() {
    List<List<int>> winningConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winningConditions) {
      if (gameBoard[condition[0]] != '' &&
          gameBoard[condition[0]] == gameBoard[condition[1]] &&
          gameBoard[condition[1]] == gameBoard[condition[2]]) {
        String winnerName = currentPlayerIndex == 0 ? player2Name : player1Name;
        setState(() {
          result = "$winnerName wins!";
          gameOver = true;
          if (currentPlayerIndex == 0) {
            player2Score++;
          } else {
            player1Score++;
          }
        });
        _showResultDialog(result, winnerName);
        return;
      }
    }

    if (!gameBoard.contains('')) {
      setState(() {
        result = "It's a tie!";
        gameOver = true;
      });
      _showResultDialog(result, '');
    }
  }

  void _showNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? enteredPlayer1Name;
        String? enteredPlayer2Name;

        return AlertDialog(
          title: Text('Enter Player Names'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  enteredPlayer1Name = value;
                },
                decoration: InputDecoration(labelText: 'Player 1 Name'),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  enteredPlayer2Name = value;
                },
                decoration: InputDecoration(labelText: 'Player 2 Name'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (enteredPlayer1Name != null && enteredPlayer2Name != null) {
                  setState(() {
                    player1Name = enteredPlayer1Name!;
                    player2Name = enteredPlayer2Name!;
                    gameStarted = true;
                  });
                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('Please enter both player names.'),
                        actions: [
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              child: Text(
                'Start Game',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog(String message, String winnerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                resetGame();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              child: Text(
                'Play Again',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                exitGame();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 176, 63, 55),
              ),
              child: Text(
                'Exit',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void exitGame() {
    setState(() {
      gameBoard = List.filled(9, '');
      currentPlayerIndex = 0;
      gameOver = false;
      result = '';
      gameStarted = false;
      player1Score = 0;
      player2Score = 0;
    });
  }

  void resetGame() {
    setState(() {
      gameBoard = List.filled(9, '');
      currentPlayerIndex = 0;
      gameOver = false;
      result = '';
    });
  }

  void repeatGame() {
    setState(() {
      gameBoard = List.filled(9, '');
      currentPlayerIndex = 0;
      gameOver = false;
      result = '';
      player1Score = 0;
      player2Score = 0;
    });
  }
}
