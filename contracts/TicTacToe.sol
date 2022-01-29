pragma solidity ^0.8.0;

import {Utils} from "./Utils.sol";
import {Game} from "./Game.sol";

contract TicTacToe is Game, Utils {
    uint8 constant frameSize = 3;
    uint8[2] constant playerNumber = [uint8(1), uint8(4)];
    uint8[2] constant playerScoreWin = [uint8(3), uint8(12)];
    struct TTTGameInstance {
        GameInstance gameInstance;
        uint8[frameSize][frameSize] frame;
        uint8 numMove;
    }

    constructor(address _player1, address _player2) {
        TTTGameInstance game = NCGameInstance(
            GameInstance(_player1, _player2, 0),
            uint8[frameSize][frameSize],
            0
        );
    }

    modifier cellAlreadyPlayed(uint8[2] memory _coord) {
        require(game.frame[_coord[0]][_coord[1]] == 0, "Cell already played.");
        _;
    }

    modifier isPlayerTurn() {
        bool _r = false;
        if (TTTGameInstance.gameInstance.player1 == msg.sender) {
            _r = _isTurn(1);
        } else if (TTTGameInstance.gameInstance.player2 == msg.sender) {
            _r = _isTurn(2);
        }
        require(_r, "Its not your turn.");
    }

    function _isTurn(uint8 _n) internal returns (bool) {
        return TTTGameInstance.gameInstance.turn == _n;
    }

    function _actionFrame(uint8[2] memory _coord)
        private
        cellAlreadyPlayed(_coord)
        isPlayerTurn
        returns (bool)
    {
        bool isWinner = false;

        if (_isPlayerOne) {
            require(
                _game.game.playerOne == msg.sender,
                "You are not the player one."
            );
        } else {
            require(
                _game.game.playerTwo == msg.sender,
                "You are not the player two."
            );
        }

        _game.frame[_coord[0]][_coord[1]] = playerNumber[_turn];
        _game.numMove++;
        _game.game.turn = (_isPlayerOne ? 1 : 0);
        emit GameMove(_key, _turn);

        if (_game.numMove > 5) {
            isWinner = _checkWinner(_game.frame, _turn);
        }

        return isWinner;
    }

    function _checkWinner(
        uint8[frameSize][frameSize] memory _frame,
        uint8 _player
    ) private view returns (bool) {
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
