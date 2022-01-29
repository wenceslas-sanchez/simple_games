pragma solidity ^0.8.0;

contract Utils {
    function _abs8(int8 x) private pure returns (uint8 y) {
        y = (x < 0 ? uint8(-x) : uint8(x));
        return y;
    }

    function _hashBothAddresses(address _one, address _two)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_one, _two));
    }
}
