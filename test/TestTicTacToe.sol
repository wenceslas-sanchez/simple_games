pragma solidity ^0.8.11;

import {Assert} from "truffle/Assert.sol";
import {DeployedAddresses} from "truffle/DeployedAddresses.sol";
import {TicTacToe} from "../contracts/TicTacToe.sol";

contract TestTicTacToe is TicTacToe {
    constructor () TicTacToe(address(this), DeployedAddresses.TicTacToe()) {}

    function coordDoesntExist() public {
        uint8[2] memory coord = [uint8(0), uint8(4)];
        uint8[frameSize][frameSize] memory frame;
        bool r = _actionFrame(coord);
    }

}