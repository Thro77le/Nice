// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.18;

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

/// @author Throttle
/// @title Nice number formatting library
/// @notice A library that returns number in decimal representation
library Nice {
    using Strings for uint256;
    using Strings for int256;

    bytes1 constant ZERO = abi.encodePacked("0")[0];
    bytes1 constant DOT = abi.encodePacked(".")[0];
    bytes1 constant SPACE = abi.encodePacked(" ")[0];
    bytes1 constant MINUS = abi.encodePacked("-")[0];

    /// @param number Number to be formatted
    /// @return string representation of a number
    function format(uint256 number) internal pure returns (string memory) {
        return _format(number, 18);
    }

    /// @param number Number to be formatted
    /// @param decimals Number of decimal places
    /// @return string representation of a number
    function format(uint256 number, uint8 decimals) internal pure returns (string memory) {
        return _format(number, decimals);
    }

    /// @param number Number to be formatted
    /// @return string representation of a number
    function format(int256 number) internal pure returns (string memory) {
        return _format(number, 18);
    }

    /// @param number Number to be formatted
    /// @param decimals Number of decimal places
    /// @return string representation of a number
    function format(int256 number, uint8 decimals) internal pure returns (string memory) {
        return _format(number, decimals);
    }

    function _format(uint256 number, uint8 decimals) private pure returns (string memory) {
        if (number == 0) {
            return "0";
        }
        uint256 base = 10 ** decimals;
        bytes memory s;

        if (number < base) {
            uint256 number_plus_10 = number + 10 * base;
            s = abi.encodePacked(number_plus_10.toString());

            s[0] = ZERO;
            s[1] = DOT;
        } else {
            uint256 decimalPart = number % base;
            uint256 integerPart = (number - decimalPart) * 10; // move integer part 1 to the left for the dot
            s = abi.encodePacked((integerPart + decimalPart).toString());

            uint256 dot_index = s.length - decimals - 1;
            s[dot_index] = DOT;
        }

        return string(cut_trailing_zeros(s, decimals));
    }

    function _format(int256 _number, uint8 decimals) private pure returns (string memory) {
        int256 number = _number;
        if (number == int256(0)) {
            return "0";
        }

        if (number > int256(0)) {
            return _format(uint256(_number), decimals);
        }

        int256 base = -int256(10 ** decimals);
        bytes memory s;

        if (base < number) {
            int256 number_minus_10 = number + 10 * base;
            s = abi.encodePacked(number_minus_10.toString());

            s[1] = ZERO;
            s[2] = DOT;
        } else {
            int256 decimalPart = number % base;
            int256 integerPart = (number - decimalPart) * 10; // move integer part 1 to the left for the dot
            s = abi.encodePacked((integerPart + decimalPart).toString());

            uint256 dot_index = s.length - decimals - 1;
            s[dot_index] = DOT;
        }

        return string(cut_trailing_zeros(s, decimals));
    }

    function cut_trailing_zeros(bytes memory s, uint8 decimals) private pure returns (bytes memory) {
        uint256 count = 0;
        for (uint256 i = s.length - 1; s[i] == ZERO; i--) {
            count++;
        }

        if (count == 0) {
            return s;
        }

        if (count == decimals) {
            count--;
        }

        bytes memory new_s = new bytes(s.length - count);
        for (uint256 i = 0; i < new_s.length; ++i) {
            new_s[i] = s[i];
        }
        return new_s;
    }
}