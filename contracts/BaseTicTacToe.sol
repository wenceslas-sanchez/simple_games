pragma solidity ^0.8.0;

import {Utils} from "./Utils.sol";
import {Game} from "./Game.sol";

contract BaseTicTacToe is Game, Utils {
    uint8 constant frameSize = 3;
    uint8[2] playerNumber = [uint8(1), uint8(4)];
    uint8[2] playerScoreWin = [uint8(3), uint8(12)];
    struct TTTGameInstance {
        GameInstance gameInstance;
        uint8[frameSize][frameSize] frame;
        uint8 numMove;
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

    function _actionFrame(TTGameInstance memory _game, uint8[2] memory _coord)
        internal
        cellAlreadyPlayed(_player1, _coord)
        isPlayerTurn(_player1)
        returns (bool)
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

        return _isWinner;
    }
}
