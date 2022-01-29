pragma solidity ^0.8.11;

abstract contract Game {
    struct GameInstance {
        address player1;
        address player2;
        uint8 turn;
    }
}
