pragma solidity ^0.8.0;

import {BaseTicTacToe} from "./BaseTicTacToe.sol";
import {LinkedListBytes32} from "./LinkedListBytes32.sol";

contract TicTacToe is BaseTicTacToe {
    mapping(address => TTTGameInstance) games;

    function startGame(address _player1, address _player2) external {
        uint8[frameSize][frameSize] memory frame;
        TTTGameInstance memory _game = TTTGameInstance(
            GameInstance(_player1, _player2, address(0), false, 0),
            frame,
            0
        );
        games[_player1] = _game;
    }

    modifier cellAlreadyPlayed(address _player1, uint8[2] memory _coord) {
        require(
            games[_player1].frame[_coord[0]][_coord[1]] == 0,
            "Cell already played."
        );
        _;
    }

    modifier isPlayerTurn(address _player1) {
        bool _r = false;
        TTTGameInstance memory _game = games[_player1];
        if (_game.gameInstance.player1 == msg.sender) {
            _r = _isTurn(_game, 0);
        } else if (_game.gameInstance.player2 == msg.sender) {
            _r = _isTurn(_game, 1);
        } else {
            require(false, "You are not a player of this game.");
        }
        require(_r, "Its not your turn.");
        _;
    }

    modifier gameIsNotOver(address _player1) {
        TTTGameInstance memory _game = games[_player1];
        require(_game.gameInstance.isGameFinished, "This game is over");
        _;
    }

    function play(address _player1, uint8[2] memory _coord)
        public
        gameIsNotOver(_player1)
        cellAlreadyPlayed(_player1, _coord)
        isPlayerTurn(_player1)
    {
        bool _isWinner;
        TTTGameInstance memory _game = games[_player1];
        (_isWinner, _game) = _actionFrame(_game, _player1, _coord);
        games[_player1] = _game;
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

    function _isTurn(TTTGameInstance memory _game, uint8 _n)
        internal
        pure
        returns (bool)
    {
        return _game.gameInstance.turn == _n;
    }

    function _actionFrame(
        TTTGameInstance memory _game,
        address _player1,
        uint8[2] memory _coord
    )
        internal
        view
        cellAlreadyPlayed(_player1, _coord)
        isPlayerTurn(_player1)
        returns (bool, TTTGameInstance memory)
    {
        bool _isWinner = false;
        bool _isplayer1 = _game.gameInstance.turn == 0;

        _game.frame[_coord[0]][_coord[1]] = playerNumber[
            _game.gameInstance.turn
        ];
        _game.gameInstance.turn = (_isplayer1 ? 1 : 0);

        if (_game.numMove > 4) {
            _isWinner = _checkWinner(_game.frame, _game.gameInstance.turn);
        }

        return (_isWinner, _game);
    }
}
