pragma solidity ^0.8.0;

import {GameFactory} from "./GameFactory.sol";
import {Utils} from "./Utils.sol";

contract PlayGame is Utils {
    GameFactory gameFactory;
    mapping(string => mapping(address => address)) public pendingInvitations;
    mapping(string => mapping(bytes32 => address)) public GameInstantiated;

    event SendInvitation(string _name, address _from, address _to);
    event AcceptInvitation(string _name, address _from, address _to);

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
        pendingInvitations[_name][msg.sender] = _to;
        emit SendInvitation(_name, msg.sender, _to);
    }

    function acceptInvitation(string calldata _name, address _from)
        external
        isGameExist(_name)
        isInvited(_name, _from)
    {
        bytes32 hash= _hashBothAddresses(pendingInvitations[_name][_from], msg.sender);
        GameInstantiated[_name][hash]= gameFactory.buildGame(_name, pendingInvitations[_name][_from]);
        delete pendingInvitations[_name][_from];
        emit AcceptInvitation(_name, _from, msg.sender);
    }
}
