pragma solidity ^0.8.0;

abstract contract AbstractLinkedList {
    uint256 public __length = 0;
    bytes32 public head;
    event Remove(bytes32 key);
    event Get(bytes32 _key);
    event MissingElement(bytes32 _key);

    function remove(bytes32 _key) public virtual;

    function length() public view returns (uint256) {
        return __length;
    }
}
