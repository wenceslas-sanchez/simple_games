pragma solidity ^0.8.0;

import {ILinkedList} from "./ILinkedList.sol";

contract LinkedListBytes32 is ILinkedList {

    struct Object {
        bytes32 next;
        bytes32 key;
        bytes32 value; // LinkedListBytes32 because value is bytes32
    }

    mapping(bytes32 => Object) objects;

    event Append(bytes32 head, bytes32 next, bytes32 key, bytes32 value);

    function checkKeyNotExist(bytes32 _key) internal view returns (bool) {
        bytes32 _head = head;
        for (uint256 i = 0; i <= __length; i++) {
            Object memory _obj = objects[_head];
            if (_obj.key == _key) {
                return false;
            }
        }
        return true;
    }

    modifier isKeyExist(bytes32 _key) {
        require(checkKeyNotExist(_key), "Key already implemented.");
        _;
    }

    function append(bytes32 _key, bytes32 _value) public isKeyExist(_key) {
        Object memory _obj = Object(head, _key, _value);
        bytes32 _id = keccak256(abi.encodePacked(head, _key, _value, __length));
        objects[_id] = _obj;
        head = _id;
        __length++;

        emit Append(head, _obj.next, _obj.key, _obj.value);
    }

    function remove(bytes32 _key) override public {
        bytes32 _head = head;
        bytes32 _next;
        bool _r;
        for (uint256 i = 0; i <= __length; i++) {
            (_r, _next) = _remove_obj(_head, _key);
            if (_r) {
                if (i == 0) {
                    head = _next;
                }
                break;
            }
            _head = _next;
        }
        if (!_r) {
            emit MissingElement(_key);
        }
    }

    function _remove_obj(bytes32 _head, bytes32 _key)
    private
    returns (bool, bytes32)
    {
        Object memory _obj = objects[_head];
        bytes32 _next = _obj.next;
        if (_obj.key == _key) {
            delete objects[_head];
            __length--;
            emit Remove(_key);

            return (true, _next);
        }

        return (false, _next);
    }

    function get(bytes32 _key) public returns (bytes32) {
        bytes32 _head = head;
        bytes32 _value;
        for (uint256 i = 0; i <= __length; i++) {
            Object memory _obj = objects[_head];
            if (_obj.key == _key) {
                emit Get(_key);
                _value = _obj.value;
            }
            _head = _obj.next;
        }

        return _value;
    }
}
