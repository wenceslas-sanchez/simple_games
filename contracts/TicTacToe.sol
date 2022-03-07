pragma solidity ^0.8.0;

import {BaseTicTacToe} from "./BaseTicTacToe.sol";

contract TicTacToe is BaseTicTacToe {
    TTTGameInstance game;

    constructor(address _player1, address _player2) {
        uint8[frameSize][frameSize] memory frame;
        game = TTTGameInstance(
            GameInstance(_player1, _player2, address(0), false, 0),
            frame,
            0
        );
    }

    modifier cellAlreadyPlayed(uint8[2] memory _coord) {
        require(game.frame[_coord[0]][_coord[1]] == 0, "Cell already played.");
        _;
    }

    modifier isPlayerTurn() {
        bool _r = false;
        if (game.gameInstance.player1 == msg.sender) {
            _r = _isTurn(0);
        } else if (game.gameInstance.player2 == msg.sender) {
            _r = _isTurn(1);
        } else {
            require(false, "You are not a player of this game.");
        }
        require(_r, "Its not your turn.");
        _;
    }

    modifier gameIsNotOver() {
        require(game.gameInstance.isGameFinished, "This game is over");
        _;
    }

    function play(uint8[2] memory _coord) public gameIsNotOver {
        bool _isWinner = _actionFrame(_coord);
        emit PlayTurn(msg.sender);

        if ((game.numMove > 8) && !_isWinner) {
            game.gameInstance.isGameFinished = true;
            emit ExAequo(
                address(this),
                game.gameInstance.player1,
                game.gameInstance.player2
            );
        } else if (_isWinner) {
            game.gameInstance.isGameFinished = true;
            game.gameInstance.winner = msg.sender;
            emit GameIsWon(address(this), msg.sender);
        }
    }

    function _isTurn(uint8 _n) internal returns (bool) {
        return game.gameInstance.turn == _n;
    }

    function _actionFrame(uint8[2] memory _coord)
        internal
        cellAlreadyPlayed(_coord)
        isPlayerTurn
        returns (bool)
    {
        bool _isWinner = false;
        bool _isplayer1 = game.gameInstance.turn == 0;

        game.frame[_coord[0]][_coord[1]] = playerNumber[game.gameInstance.turn];
        game.gameInstance.turn = (_isplayer1 ? 1 : 0);

        if (game.numMove > 4) {
            _isWinner = _checkWinner(game.frame, game.gameInstance.turn);
        }

        return _isWinner;
    }
}
