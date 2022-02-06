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

    function buildGame(string calldata _name, address _player1)
        external
        returns (address)
    {
        // TODO default, to do in assembly
        if (
            keccak256(abi.encodePacked(_name)) ==
            keccak256(abi.encodePacked("tictactoe"))
        ) {
            return address(new TicTacToe(_player1, msg.sender));
        } else {
            return address(0);
        }
    }
}
