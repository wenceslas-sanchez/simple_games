pragma solidity ^0.8.11;

abstract contract Game {
    struct GameInstance {
        address player1;
        address player2;
        address winner;
        bool isGameFinished;
        uint8 turn;
    }
    event PlayTurn(address player);
    event GameIsWon(address winner);
    event ExAequo(address player1, address player2);

    function play() public {}
}
