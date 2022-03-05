pragma solidity ^0.8.0;

contract LinkedListBytes32 {
    bytes32 public head;
    uint256 public __length = 0;

    struct Object {
        bytes32 next;
        bytes32 key;
        bytes32 value; // LinkedListBytes32 because value is bytes32
    }

    mapping(bytes32 => Object) objects;

    event Append(bytes32 head, bytes32 next, bytes32 key, bytes32 value);
    event Remove(bytes32 key);
    event Get(bytes32 _key);
    event MissingElement(bytes32 _key);

    function append(bytes32 _value, bytes32 _key) public {
        Object memory _obj = Object(head, _key, _value);
        bytes32 _id = keccak256(abi.encodePacked(head, _key, _value, __length));
        objects[_id] = _obj;
        head = id;
        __length++;

        emit Append(head, _obj.next, _obj.key, _obj.value);
    }

    function length() public view returns (uint256) {
        return __length;
    }

    function remove(bytes32 _key) public {
        bytes32 _head = head;
        bool _r;
        for (uint256 i = 0; i <= length; i++) {
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
        bytes32 _next = obj.next;
        if (_obj.key == _key) {
            delete objects[_head];
            length--;
            emit Remove(_key);

            return (true, _next);
        }

        return (false, _next);
    }

    function get(bytes32 _key) public view returns (bytes32) {
        bytes32 _head = head;
        bytes32 _value;
        bool _r;
        for (uint256 i = 0; i <= length; i++) {
            Object memory _obj = objects[_head];
            if (_obj.key == _key) {
                emit Get(_key);
                _value = _obj.value;
            }
            _head = _obj.next;
        }
        if (_value == 0) {
            emit MissingElement(_key);
        }

        return _value;
    }

    function _get_obj(
        bytes32 _head,
        bytes32 _next,
        bytes32 _value
    ) private returns (bytes32) {
        Object memory _obj = objects[_head];
        bytes32 _next = obj.next;
        if (_obj.key == _key) {
            emit Get(_key);
            return _obj.value;
        }
        return;
    }
}
