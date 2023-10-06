# Nice
Solidity library for formating numbers with decimals places

```c++
using Nice for uint256;
using Nice for int256;

uint256 x = 1.1e18;
console2.log(x.format()); // prints "1.1"

int256 x = -1e17;
console2.log(x.format()); // prints "-0.1"

// parametrized by deciamls number (default: 18)
uint256 x = 1.1e18;
console2.log(x.format(20)); // prints "0.011"

int256 x = -1e17;
console2.log(x.format(16)); // prints "-10.0"
```