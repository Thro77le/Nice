// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Nice} from "../src/Nice.sol";

contract NiceTest is Test {
  using Nice for uint256;
  using Nice for int256;

  function setUp() public {}

  function test_uint256() public {
    uint256 x = 1.1e18;
    assertEq(x.format(), "1.1");

    x = 0.1e18;
    assertEq(x.format(), "0.1");

    x = 1.0e18;
    assertEq(x.format(), "1.0");

    x = 1.1234567891234567e18;
    assertEq(x.format(), "1.1234567891234567");

    x = 1.01e18;
    assertEq(x.format(), "1.01");

    x = 1.123456789123e18;
    assertEq(x.format(), "1.123456789123");

    x = 1.123000789000e18;
    assertEq(x.format(), "1.123000789");

    x = 1_234_567.123456789123e18;
    assertEq(x.format(), "1234567.123456789123");
  }

  function test_uint256_custom_decimals() public {
    uint256 x = 1.1e30;
    assertEq(x.format(30), "1.1");
  }

  function test_int256() public {
    int256 x = -1.1e18;
    assertEq(x.format(), "-1.1");

    x = -0.1e18;
    assertEq(x.format(), "-0.1");

    x = -1.0e18;
    assertEq(x.format(), "-1.0");
  }

  function test_int256_custom_decimals() public {
    int256 x = -1.1e30;
    assertEq(x.format(30), "-1.1");
  }
}
