// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
import {Alert} from "phylax-std/Alert.sol";

contract UserHealth is Alert {
    address healtChecksAddress = 0xfda082e00EF89185d9DB7E5DcD8c5505070F5A3B;

    function setUp() public {
        enableChan("mainnet");
    }

    function test_userHealth() public chain("mainnet") {
        string userHealth 
    }
}
