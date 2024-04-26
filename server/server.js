const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require('socket.io');
const io = new Server(server);
const words = [
    "TIME",
    "YEAR",
    "PEOPLE",
    "WAY",
    "DAY",
    "MAN",
    "THING",
    "WOMAN",
    "LIFE",
    "CHILD",
    "WORLD",
    "SCHOOL",
    "STATE",
    "FAMILY",
    "STUDENT",
    "GROUP",
    "COUNTRY",
    "PROBLEM",
    "HAND",
    "PART",
    "PLACE",
    "CASE",
    "WEEK",
    "COMPANY",
    "SYSTEM",
    "PROGRAM",
    "QUESTION",
    "WORK",
    "GOVERNMENT",
    "NUMBER",
    "NIGHT",
    "POINT",
    "HOME",
    "WATER",
    "ROOM",
    "MOTHER",
    "AREA",
    "MONEY",
    "STORY",
    "FACT",
    "MONTH",
    "LOT",
    "RIGHT",
    "STUDY",
    "BOOK",
    "EYE",
    "JOB",
    "WORD",
    "BUSINESS",
    "ISSUE"
];

let connectedClients = [];
let currentSelectedWord = words[generateRandNumberBasedOnWordsCount()];
let progressWord = [...currentSelectedWord].map(c => '_').join("");

function generateRandNumberBasedOnWordsCount() {
    return Math.floor(Math.random() * words.length);
}

function getAllIndexesOfAChar(char, str) {
    const indicies = [];

    for (let i = 0; i < str.length; ++i) {
        if (str[i].toLowerCase() == char.toLowerCase()) {
            indicies.push(i);
        }
    }

    return indicies;
}

io.on('connection', (socket) => {
    
    if(connectedClients.length < 2) {
        connectedClients.push(socket);
    }

    socket.on('join', () => {
        if(connectedClients.length < 2)
        {
            io.emit('join', {status: "failed", data: null});
        }
        else 
        {
            for(let s = 0; s < connectedClients.length; ++s) {
                connectedClients[s].emit('join', {status: 'success', data: currentSelectedWord, turn: s+1});
            }
        }
        console.log('join msg sent');
        console.log("connected clients count: " + connectedClients.length);
    });

    socket.on('play-msg', (msg) => {
        console.log(msg);
        if(currentSelectedWord.includes(msg.char)) {
            if(!progressWord.includes(msg.char)) {
                let indices = getAllIndexesOfAChar(msg.char, currentSelectedWord);
                for(let i = 0; i < indices.length; ++i) {
                    progressWord[indices[i]] = msg.char;
                }
                for(let s = 0; s < connectedClients.length; ++s) {
                    if(connectedClients[s] == socket) {
                        connectedClients[s].emit('play-msg', {status: 'success', data: 'correct', char: msg.char, player: "you"});
                    }
                    else {
                        connectedClients[s].emit('play-msg', {status: 'success', data: 'correct', char: msg.char, player: "other"});
                    }
                }
            }
            else {
                for(let s = 0; s < connectedClients.length; ++s) {
                    if(connectedClients[s] == socket) {
                        connectedClients[s].emit('play-msg', {status: 'success', data: 'wrong', char: msg.char, player: "you"});
                    }
                    else {
                        connectedClients[s].emit('play-msg', {status: 'success', data: 'wrong', char: msg.char, player: "other"});
                    }
                }
            }
        }
        else {
            for(let s = 0; s < connectedClients.length; ++s) {
                if(connectedClients[s] == socket) {
                    connectedClients[s].emit('play-msg', {status: 'success', data: 'wrong', char: msg.char, player: "you"});
                }
                else {
                    connectedClients[s].emit('play-msg', {status: 'success', data: 'wrong', char: msg.char, player: "other"});
                }
            }
        }
    });

    socket.on('game-over', (msg) => {
        console.log("game-over sent", msg);
        if(msg == "no-win") {
            for(let s = 0; s < connectedClients.length; ++s) {
                connectedClients[s].emit('game-over', "no-win");
            }
        }
        else if(msg == "i won") {
            for(let s = 0; s < connectedClients.length; ++s) {
                if(connectedClients[s] == socket) {
                    socket.emit('game-over', "you won");
                }
                else {
                    connectedClients[s].emit('game-over', "you lost");
                }
            }
        }
    });

    socket.on('disconnect', () => {
        let clientIndex = connectedClients.indexOf(socket);
        console.log('socket removed index: ' + clientIndex);
        if(clientIndex != -1) {
            connectedClients.splice(clientIndex, 1);
            for(let s = 0; s < connectedClients.length; ++s) {
                connectedClients[s].emit('other-player-disconnect');
            }
        }
        console.log('someone disconnected');
    });
});

server.listen(3000, () => {
    console.log('listening on *:3000');
});