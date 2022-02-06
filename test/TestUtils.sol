pragma solidity ^0.8.0;

import {Assert} from "truffle/Assert.sol";
import {Utils} from "../contracts/Utils.sol";

contract TestUtils is Utils {
    function testAbs8() public {
        uint8 result = _abs8(int8(1));
        Assert.equal(result, uint8(1), "Result should be : |1| == 1");

        result = _abs8(int8(-1));
        Assert.equal(result, uint8(1), "Result should be : |-1| == 1");

        result = _abs8(int8(0));
        Assert.equal(result, uint8(0), "Result should be : |0| == 0");
    }
}
