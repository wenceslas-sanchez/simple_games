pragma solidity ^0.8.0;

contract LinkedListAddress {
    uint public head;
    uint public __length= 0;

    struct Object {
        bytes32 next;
        bytes32 key;
        address value;
    }

    mapping(bytes32 => Object) objects;

    event Append(bytes32 head, bytes32 next, bytes32 key, address value);

    function append(address _value, bytes32 _key) public {
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
}
