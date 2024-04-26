import 'package:flutter/material.dart';
import 'package:hanging_spider/game_over_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'game_over_status.dart';
import 'utils/utils.dart';

enum GameStatus { waiting, yourTurn, otherPlayerTurn, gameOver }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() {
    return _GameScreenState();
  }
}

class _GameScreenState extends State<GameScreen> {
  final String serverUrl = "http://192.168.0.3:3000";
  late io.Socket socket;

  String activeImage = 'assets/images/state_1.png';
  String originalWord = "catastrophic";
  List<String> progressWord = [];
  GameStatus curGameStatus = GameStatus.waiting;
  GameOverStatus curGameOverStatus = GameOverStatus.playing;
  int mistakesCount = 0;
  var alphabet = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  @override
  void initState() {
    super.initState();

    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      socket.emit('join');
    });

    socket.on('join', (data) {
      var jsonData = data as Map<String, dynamic>;
      if (jsonData['status'] == 'success') {
        originalWord = jsonData['data'];
        progressWord = [...originalWord.characters.map((c) => "_")];
        setState(() {
          if (jsonData['turn'] == 1) {
            curGameStatus = GameStatus.yourTurn;
          } else {
            curGameStatus = GameStatus.otherPlayerTurn;
          }
        });
      } else {
        setState(() {
          curGameStatus = GameStatus.waiting;
        });
      }
    });

    socket.on('play-msg', (jsonData) {
      print(jsonData);
      if (jsonData['status'] == 'success') {
        if (jsonData['data'] == 'correct') {
          validateWord(jsonData['char']);
        } else {
          validateWord(jsonData['char']);
          setState(() {
            if (curGameStatus != GameStatus.gameOver) {
              if (jsonData['player'] == 'you') {
                curGameStatus = GameStatus.otherPlayerTurn;
              } else {
                curGameStatus = GameStatus.yourTurn;
              }
            }
          });
        }
      }
    });

    socket.on('game-over', (data) {
      setState(() {
        if (data == "no-win") {
          curGameOverStatus = GameOverStatus.noWin;
        } else if (data == "you won") {
          curGameOverStatus = GameOverStatus.youWon;
        } else if (data == "you lost") {
          curGameOverStatus = GameOverStatus.youLost;
        }
      });
    });

    socket.on('other-player-disconnect', (data) {
      setState(() {
        curGameOverStatus = GameOverStatus.noWin;
      });
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  void validateWord(String char) {
    var charIndicies = Utils.getAllIndexesOfAChar(char, originalWord);
    if (charIndicies.isNotEmpty) {
      setState(() {
        for (var index in charIndicies) {
          if (progressWord[index] == '_') {
            progressWord[index] = char;
          }
        }
        alphabet.remove(char);

        if (curGameStatus == GameStatus.yourTurn &&
            !progressWord.contains("_")) {
          curGameStatus = GameStatus.gameOver;
          socket.emit("game-over", "i won");
        }
      });
    } else {
      setState(() {
        if (mistakesCount < 4) {
          ++mistakesCount;
          activeImage = "assets/images/state_${mistakesCount + 1}.png";
          alphabet.remove(char);
        } else {
          curGameStatus = GameStatus.gameOver;
          if (progressWord.contains("_")) {
            socket.emit("game-over", "no-win");
          } else {
            socket.emit("game-over", "i won");
          }
        }
      });
    }
  }

  void sendCharToServer(String char) {
    socket.emit("play-msg", {"char": char});
  }

  String getMessageAssociatedWithGameStatus() {
    switch (curGameStatus) {
      case GameStatus.otherPlayerTurn:
        return "You can't play it's the other player turn";
      case GameStatus.waiting:
        return "Waiting for another player to join";
      case GameStatus.gameOver:
        return "Game over";
      case GameStatus.yourTurn:
        return "Your Turn";
    }
  }

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w800);

    return curGameOverStatus != GameOverStatus.playing
        ? GameOverScreen(curGameOverStatus)
        : Wrap(children: [
            Center(
              child: Column(
                children: [
                  Text(getMessageAssociatedWithGameStatus(), style: style),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    activeImage,
                    width: 100,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    progressWord.join(" "),
                    style: style,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      for (var char in alphabet)
                        TextButton(
                          onPressed: () {
                            if (curGameStatus == GameStatus.yourTurn) {
                              sendCharToServer(char);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    getMessageAssociatedWithGameStatus(),
                                  ),
                                ),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.all(5),
                          ),
                          child: Text(
                            char,
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
          ]);
  }
}
