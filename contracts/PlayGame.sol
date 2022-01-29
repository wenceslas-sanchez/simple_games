pragma solidity ^0.8.0;

import {TicTacToe} from "./TicTacToe.sol";

contract GameFactory {
    string[] possibleGames = ["tictactoe"];

    function isGameExist(string calldata _name) external returns (bool) {
        bool result = false;
        for (uint8 i = 0; i < possibleGames.length; i++) {
            if (
                keccak256(abi.encodePacked(_name)) ==
                keccak256(abi.encodePacked(possibleGames[i]))
            ) {
                result = true;
                break;
            }
        }
        return result;
    }

    function buildGame(string calldata _name, address _player2)
        external
        returns (address)
    {
        // TODO default, to do in assembly
        if (
            keccak256(abi.encodePacked(_name)) ==
            keccak256(abi.encodePacked("tictactoe"))
        ) {
            return address(new TicTacToe(msg.sender, _player2));
        } else {
            return address(0);
        }
    }
}

contract PlayGame {
    GameFactory gameFactory;
    mapping(string => mapping(address => address)) public pendingInvitations;
    mapping(bytes => address) public pendingGames;

    event SendInvitation(string _name, address _from, address _to);
    event AcceptInvitation(string _name, address _from);

    modifier isInvited(string calldata _name, address _from) {
        require(
            pendingInvitations[_name][_from] == msg.sender,
            "You are not invited by this player."
        );
        _;
    }

    modifier isGameExist(string calldata _name) {
        bool result = gameFactory.isGameExist(_name);
        require(result, "This game is not defined.");
        _;
    }

    function invitePlayer(string calldata _name, address _to)
        external
        isGameExist(_name)
    {
        pendingInvitation[_name][msg.sender] = _to;
        emit SendInvitation(_name, msg.sender, _to);
    }

    function instanceGame(string calldata _name) external isGameExist(_name) {}

    function acceptInvitation(string calldata _name, address _from)
        external
        isGameExist(_name)
        isInvited(_name, _from)
    {
        delete pendingInvitations[_name][_from];
        emit AcceptInvitation(_name, _from);
    }
}
