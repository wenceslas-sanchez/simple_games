pragma solidity ^0.8.0;

contract Utils {
    function _abs8(int8 x) internal pure returns (uint8 y) {
        y = (x < 0 ? uint8(-x) : uint8(x));
        return y;
    }

    function _hashBothAddresses(address _one, address _two)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_one, _two));
    }

    function addressToBytes32(address _a) public pure returns (bytes32) {
        return bytes32(uint256(uint160(address(_a))));
    }

    function bytes32ToAddress(bytes32 _b) public pure returns (address) {
        return address(uint160(uint256(bytes32(_b))));
    }
}
