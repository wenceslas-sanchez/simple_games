pragma solidity ^0.8.0;

contract LinkedListBytes32 {
    bytes32 public head;
    uint public __length= 0;

    struct Object {
        bytes32 next;
        bytes32 key;
        bytes32 value; // LinkedListBytes32 because value is bytes32
    }

    mapping(bytes32 => Object) objects;

    event Append(bytes32 head, bytes32 next, bytes32 key, bytes32 value);
    event Remove(bytes32 key);

    function append(bytes32 _value, bytes32 _key) public {
        Object memory _obj= Object(head, _key, _value);
        bytes32 _id= keccak256(abi.encodePacked(head, _key, _value, __length));
        objects[_id]= _obj;
        head= id;
        __length++;

        emit Append(head, _obj.next, _obj.key, _obj.value);
    }

    function length() public view returns (uint) {

        return __length;
    }

    function remove(bytes32 _key) public {
        bytes32 _head= head;
        bool _r;
        for (uint i= 0; i<= length; i++) {
            Object memory _obj= objects[_head];
            (_r, _next)= _remove_obj(_obj, _key);
            if (_r) {
                if (i == 0) {
                    head= _next;
                }
                break;
            }
        }
    }

    function _remove_obj(bytes32 _head, bytes32 _key) private returns (bool, bytes32) {
        Object memory _obj= objects[_head];
        bytes32 _next= obj.next;
        if (_obj.key == _key) {
            delete objects[_head];
            length--;
            emit Remove(_key);

            return (true, _next);
        }

        return (false, _next);
    }
}
