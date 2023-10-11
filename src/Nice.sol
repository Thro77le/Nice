// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.18;

/// @author Throttle
/// @title Nice number formatting library
/// @notice A library that returns number in decimal representation
library Nice {
  bytes16 private constant _SYMBOLS = "0123456789";

  /// @param number Number to be formatted
  /// @return string representation of a number
  function format(uint256 number) internal pure returns (string memory) {
    return _format(number, 1e18, false);
  }

  /// @param number Number to be formatted
  /// @param decimals Number of decimal places
  /// @return string representation of a number
  function format(uint256 number, uint8 decimals) internal pure returns (string memory) {
    uint256 base = 10 ** decimals;
    return _format(number, base, false);
  }

  /// @param number Number to be formatted
  /// @return string representation of a number
  function format(int256 number) internal pure returns (string memory) {
    if (number < 0) {
      return _format(uint256(-number), 1e18, true);
    } else {
      return _format(uint256(number), 1e18, false);
    }
  }

  /// @param number Number to be formatted
  /// @param decimals Number of decimal places
  /// @return string representation of a number
  function format(int256 number, uint8 decimals) internal pure returns (string memory) {
    uint256 base = 10 ** decimals;
    if (number < 0) {
      return _format(uint256(-number), base, true);
    } else {
      return _format(uint256(number), base, false);
    }
  }

  function _format(uint256 number, uint256 base, bool negative) private pure returns (string memory) {
    uint256 integer = number / base;
    uint256 fraction = number % base;
    uint256 fraction_length = _count_fraction(fraction, base);
    uint256 integer_length = _count_integer(integer);

    unchecked {
      if (negative) {
        integer_length++;
      }
      uint256 length = integer_length + fraction_length + 1;
      uint256 ptr = length;

      bytes memory buffer = new bytes(length);
      for (uint256 i = 0; i < length; i++) {
        buffer[i] = "0";
      }
      if (negative) {
        buffer[0] = "-";
      }

      // fraction part
      if (fraction != 0) {
        while (fraction % 10 == 0) {
          fraction /= 10;
        }
        while (fraction != 0) {
          buffer[--ptr] = _SYMBOLS[fraction % 10];
          fraction /= 10;
        }
      }

      buffer[integer_length] = ".";

      // integer part
      ptr = integer_length;
      while (integer != 0) {
        buffer[--ptr] = _SYMBOLS[integer % 10];
        integer /= 10;
      }
      return string(buffer);
    }
  }

  function _count_fraction(uint256 _number, uint256 base) private pure returns (uint256 counter) {
    unchecked {
      if (_number == 0) {
        return 1;
      }

      uint256 number = _number + base;

      while (number % 10 == 0) {
        number /= 10;
      }
      while (number != 0) {
        counter++;
        number /= 10;
      }

      // subtract spot for the base unit
      counter--;
    }
  }

  function _count_integer(uint256 _number) private pure returns (uint256 counter) {
    uint256 number = _number;
    if (number == 0) {
      return 1;
    }
    unchecked {
      while (number != 0) {
        counter++;
        number /= 10;
      }
    }
  }
}
