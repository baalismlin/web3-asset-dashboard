// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {
    IERC20Metadata
} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract SimpleToken is IERC20, IERC20Metadata {
    address private _owner;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowance;

    event Minted(address indexed to, uint256 amount);

    constructor() {
        _owner = msg.sender;
        _totalSupply = 0;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender);
        _;
    }

    function getOwner() external view returns (address) {
        return _owner;
    }

    function name() external pure returns (string memory) {
        return "FENG LIN";
    }

    function symbol() external pure returns (string memory) {
        return "FL";
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balance[account];
    }

    function transfer(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {
        return _allowance[owner][spender];
    }

    function approve(address spender, uint256 value) external returns (bool) {
        require(_balance[msg.sender] >= value);

        _allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        require(_allowance[from][msg.sender] >= value);

        _allowance[from][msg.sender] -= value;
        _transfer(from, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(_balance[from] >= value);

        _balance[from] -= value;
        _balance[to] += value;

        emit Transfer(from, to, value);
    }

    function mint(uint256 value) external onlyOwner {
        _totalSupply += value;
        _balance[msg.sender] += value;

        emit Minted(msg.sender, value);
    }
}
