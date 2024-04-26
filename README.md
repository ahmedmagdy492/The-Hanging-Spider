# Hanging Spider
- in its essence it's similar to the hangman game except that it has a little bit different gameplay.
- the app is divided into 2 apps the server app (which uses nodejs) and client app which is this flutter app.
- the client and the server uses socket.io to open a bi-directional channel for real time communication.
- the game rules are quite simple you just join and wait for another player to join then the game start
- the player turn will be determined automatically by the server and the word will also be picked up randomly from a list of words on the server-side
-then each player gusses a character if it's correct it's added and if it's wrong a new part of the hanging spider will be added upuntil the whole spider picture is compelete then there will be no winner and the game will over
-otherwise if someone got the last character correct he will win


# How to Setup and Run
- open the server directory and open the terminal there, then write `npm install`
- then write `npm start` and hit enter to start the server
- download and install flutter, then open up 2 terminals and on each one write `flutter run`
- it will ask you for the target platform, choose one and let it build
- enjoy :)