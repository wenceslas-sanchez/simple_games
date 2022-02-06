pragma solidity ^0.8.0;

import {Utils} from "./Utils.sol";
import {Game} from "./Game.sol";

contract TicTacToe is Game, Utils {
    uint8 constant frameSize = 3;
    uint8[2] playerNumber = [uint8(1), uint8(4)];
    uint8[2] playerScoreWin = [uint8(3), uint8(12)];
    struct TTTGameInstance {
        GameInstance gameInstance;
        uint8[frameSize][frameSize] frame;
        uint8 numMove;
    }
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

    modifier gameIsOver() {
        require(game.gameInstance.isGameFinished, "This game is over");
        _;
    }

    function play(uint8[2] memory _coord) public gameIsOver {
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

    function _checkWinner(
        uint8[frameSize][frameSize] memory _frame,
        uint8 _player
    ) internal view returns (bool) {
        uint8 h;
        uint8 v;
        uint8 rd_i;
        uint8 ld = 0;
        uint8 rd = 0;
        for (uint8 i = 0; i < frameSize; i++) {
            h = 0;
            v = 0;
            rd_i = _abs8(int8(i) - int8(frameSize) + 1);
            for (uint8 j = 0; j < frameSize; j++) {
                // check horizontal
                h += _frame[i][j];
                // check vertical
                v += _frame[j][i];
            }
            if (h == playerScoreWin[_player] || v == playerScoreWin[_player]) {
                return true;
            }
            // check left diagonal
            ld += _frame[i][i];
            // check right diagonal
            rd += _frame[i][rd_i];

            if (
                ld == playerScoreWin[_player] || rd == playerScoreWin[_player]
            ) {
                return true;
            }
        }
        return false;
    }
}
