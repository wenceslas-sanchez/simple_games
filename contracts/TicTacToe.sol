pragma solidity ^0.8.0;

contract TicTacToe {
    constructor(address _player2) {
        address player1 = msg.sender;
        address player2 = _player2;
    }
}
