// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SafeVault {
    IERC20 public _token;

    constructor(address token) {
        _token = IERC20(token);
    }

    function deposit(uint256 amount) external {
        _token.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 amount) external {
        _token.transfer(msg.sender, amount);
    }
}
