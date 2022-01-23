pragma solidity ^0.8.11;

import {Game} from "./Game.sol";

contract NoughtsCrosses is Game {
    // 0 if not played yet, 1 for first player, 4 for second player
    uint8 constant frameSize = 3;
    uint8[2] playerNumber = [uint8(1), uint8(4)];
    uint8[2] playerScoreWin = [uint8(3), uint8(12)];
    struct NCGameInstance {
        GameInstance game;
        uint8[frameSize][frameSize] frame;
        uint8 numMove;
    }
    mapping(bytes32 => NCGameInstance) games;

    event NewGameInstance(address _playerOne, address _playerTwo);
    event GameMove(bytes32 _key, uint8 _playerNumber);
    event GameWinner(bytes _key, uint8 _playerNumber);

    modifier turnNumber(uint8 _player) {
        bool r = false;
        for (uint8 i = 0; i < 2; i++) {
            if (i == _player) {
                r = true;
                break;
            }
        }
        require(
            r,
            "The turn number you provided doesn't exist. Possible values between [1, 4]."
        );
        _;
    }

    modifier isGameExists(bytes32 _key) {
        NCGameInstance memory _game = games[_key];
        require(
            (_game.game.playerOne != address(0) &&
                _game.game.playerTwo != address(0)),
            "This game doesn't exist yet."
        );
        _;
    }

    modifier cellAlreadyPlayed(bytes32 _key, uint8[2] memory _coord) {
        NCGameInstance memory _game = games[_key];
        require(_game.frame[_coord[0]][_coord[1]] == 0, "Cell already played.");
        _;
    }

    function _hashBothAddresses(address _one, address _two)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_one, _two));
    }

    function instanceGame(address _playerTwo) public returns (bytes32) {
        uint8[frameSize][frameSize] memory frame;
        bytes32 hashedAddress = _hashBothAddresses(msg.sender, _playerTwo);
        games[hashedAddress] = NCGameInstance(
            GameInstance(msg.sender, _playerTwo, 0),
            frame,
            0
        );
        emit NewGameInstance(msg.sender, _playerTwo);

        return hashedAddress;
    }

    // Given (x, y), set value to frame
    function play(
        uint8[2] memory _coord,
        uint8 _turn,
        address _adversary
    ) public turnNumber(_turn) {
        bytes32 key;
        bool isPlayerOne = _turn == 0;
        key = (
            isPlayerOne
                ? _hashBothAddresses(msg.sender, _adversary)
                : _hashBothAddresses(_adversary, msg.sender)
        );
        _actionFrame(key, _coord, _turn, isPlayerOne);
    }

    function _actionFrame(
        bytes32 _key,
        uint8[2] memory _coord,
        uint8 _turn,
        bool _isPlayerOne
    )
        private
        isGameExists(_key)
        cellAlreadyPlayed(_key, _coord)
        returns (bool)
    {
        NCGameInstance storage _game = games[_key];
        bool isWinner = false;

        require(_game.game.turn == _turn, "It's not your turn. Please wait.");
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

    function _abs8(int8 x) private pure returns (uint8 y) {
        y = (x < 0 ? uint8(-x) : uint8(x));
        return y;
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

    function showGame(address _playerOne, address _playerTwo)
        public
        view
        returns (
            address,
            address,
            uint8[frameSize][frameSize] memory,
            uint8,
            uint8
        )
    {
        bytes32 key = _hashBothAddresses(_playerOne, _playerTwo);
        NCGameInstance memory _game = games[key];

        return (
            _game.game.playerOne,
            _game.game.playerTwo,
            _game.frame,
            _game.numMove,
            _game.game.turn
        );
    }
}
