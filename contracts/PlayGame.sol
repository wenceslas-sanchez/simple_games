pragma solidity ^0.8.0;

import {TicTacToe} from "./TicTacToe.sol";

contract GameFactory {
    string[] possibleGames = ["tictactoe"];

    function isGameExist(string _name) external returns (bool) {
        bool result = false;
        for (uint8 i = 0; i < possibleGames.length; i++) {
            if (_name == possibleGames[i]) {
                result = true;
                break;
            }
        }
        return result;
    }

    function buildGame(
        string _name,
        address _player1,
        address _player2
    ) external returns (address) {
        // TODO default, to do in assembly
        if (_name == "tictactoe") {
            // TODO test it doesnt create a new contract each time its called
            return address(new TicTacToe(_player1, _player2));
        } else {
            return address(0);
        }
    }
}

contract PlayGame {
    GameFactory gameFactory;
    mapping(string => mapping(address => address)) public pendingInvitation;

    event InvitationAccepted(string _name, address _player1);

    modifier isInvited(address _player1) {
        require(
            pendingInvitation[_player1] == msg.sender,
            "You are not invited by this player."
        );
        _;
    }

    modifier isGameExist(string _name) {
        bool result = gameFactory.isGameExist(_name);
        require(result, "This game is not defined.");
        _;
    }

    function startGame(string _name) external isGameExist(_name) {

    }

    function acceptInvitation(string _name, address _player1)
        external
        isGameExist(_name)
        isInvited(_player1)
    {
        delete pendingInvitation[_name][_player1];
        emit InvitationAccepted(_name, _player1);
    }

    function _instanceGame(string _name) private {}
}
