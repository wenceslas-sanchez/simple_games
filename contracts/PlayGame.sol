pragma solidity ^0.8.0;

import {GameFactory} from "./GameFactory.sol";
import {Utils} from "./Utils.sol";
import {LinkedListBytes32} from "./LinkedListBytes32.sol";

contract PlayGame is Utils {
    GameFactory gameFactory = new GameFactory();
    LinkedListBytes32 pendingInvitations = new LinkedListBytes32();
    LinkedListBytes32 gameInstantiated = new LinkedListBytes32();

    event SendInvitation(string _name, address _from, address _to);
    event AcceptInvitation(
        string _name,
        address _from,
        address _to,
        address _game
    );

    modifier isInvited(address _from) {
        bytes32 _to = pendingInvitations.get(addressToBytes32(_from));
        require(!(_to == bytes32(0)), "You are not invited in a game.");
        _;
    }

    modifier isGameExist(string calldata _name) {
        bool _r = gameFactory.isGameExist(_name);
        require(_r, "This game is not defined.");
        _;
    }

    function invitePlayer(string calldata _name, address _to)
        public
        isGameExist(_name)
    {
        pendingInvitations.append(
            addressToBytes32(msg.sender),
            addressToBytes32(_to)
        );
        emit SendInvitation(_name, msg.sender, _to);
    }

    function acceptInvitation(string calldata _name, address _from)
        external
        isGameExist(_name)
        isInvited(_from)
        returns (address _game)
    {
        pendingInvitations.remove(addressToBytes32(_from));
        _game = gameFactory.buildGame(_name, _from);
        gameInstantiated.append(
            _hashBothAddresses(_from, msg.sender),
            addressToBytes32(_game)
        );
        emit AcceptInvitation(_name, _from, msg.sender, _game);
    }

    function getPendingInvitation(address _from) public returns (address) {
        return
            bytes32ToAddress(pendingInvitations.get(addressToBytes32(_from)));
    }

    function getGameInstantiated(address _from, address _to)
        public
        returns (address)
    {
        return
            bytes32ToAddress(
                gameInstantiated.get(_hashBothAddresses(_from, _to))
            );
    }
}
