pragma solidity ^0.8.0;

import {BaseTicTacToe} from "./BaseTicTacToe.sol";
import {LinkedListBytes32} from "./LinkedListBytes32.sol";

contract TicTacToe is BaseTicTacToe {
    LinkedListBytes32 keys = new LinkedListBytes32();
    mapping(address => TTTGameInstance) games;

    constructor(address _player1, address _player2) {
        uint8[frameSize][frameSize] memory frame;
        TTTGameInstance _game = TTTGameInstance(
            GameInstance(_player1, _player2, address(0), false, 0),
            frame,
            0
        );
        games[_player1]= _game;
        keys.append(addressToBytes32(_player1));
    }

    modifier cellAlreadyPlayed(address _player1, uint8[2] memory _coord) {
        require(games[_player1].frame[_coord[0]][_coord[1]] == 0,
            "Cell already played.");
        _;
    }

    modifier isPlayerTurn(address _player1) {
        bool _r = false;
        TTTGameInstance _game= games[_player1];
        if (_game.gameInstance.player1 == msg.sender) {
            _r = _isTurn(0);
        } else if (_game.gameInstance.player2 == msg.sender) {
            _r = _isTurn(1);
        } else {
            require(false, "You are not a player of this game.");
        }
        require(_r, "Its not your turn.");
        _;
    }

    modifier gameIsNotOver(address _player1) {
        TTTGameInstance _game= games[_player1];
        require(_game.gameInstance.isGameFinished, "This game is over");
        _;
    }

    function play(address _player1, uint8[2] memory _coord)
        public
        gameIsNotOver(_player1)
        cellAlreadyPlayed(_player1, _coord)
        isPlayerTurn(_player1)

    {
        TTGameInstance _game= games[_player1];
        bool _isWinner = _actionFrame(_game, _coord);
        emit PlayTurn(msg.sender);

        if ((_game.numMove > 8) && !_isWinner) {
            _game.gameInstance.isGameFinished = true;
            emit ExAequo(
                _game.gameInstance.player1,
                _game.gameInstance.player2
            );
        } else if (_isWinner) {
            _game.gameInstance.isGameFinished = true;
            _game.gameInstance.winner = msg.sender;
            emit GameIsWon(msg.sender);
        }
    }

    function _isTurn(uint8 _n) internal returns (bool) {
        return game.gameInstance.turn == _n;
    }
}
