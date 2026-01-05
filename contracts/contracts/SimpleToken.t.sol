// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SimpleToken} from "./SimpleToken.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

contract SimpleTokenTest is Test {
    SimpleToken token;

    address owner = address(0x1);
    address spender = address(0x2);
    address attacker = address(0x3);
    address spender2 = address(0x4);

    function setUp() public {
        vm.prank(owner);
        token = new SimpleToken();
    }

    function test_Owner() public {
        console.log("owner:");
        console.log(token.getOwner());
        assertEq(owner, token.getOwner());
    }

    function test_TotalSupply() public {
        vm.prank(owner);
        token.mint(1000);

        console.log("total supply:");
        console.log(token.totalSupply());

        assertEq(1000, token.totalSupply());
    }

    function test_MintEmitsEvent() public {
        vm.prank(owner);

        vm.expectEmit(true, false, false, true);
        emit SimpleToken.Minted(owner, 100);

        token.mint(100);
    }

    function testFuzz_MintIncreasesBalance(uint8 x) public {
        vm.assume(x > 0);

        vm.prank(owner);
        token.mint(uint256(x) * 100);

        assertEq(token.balanceOf(owner), uint256(x) * 100);
    }

    function test_ApproveSetsAllowance() public {
        vm.prank(owner);
        token.mint(1000);
        vm.prank(owner);
        token.approve(spender, 100);

        uint256 allowance = token.allowance(owner, spender);
        assertEq(allowance, 100);
    }

    function test_ApproveOverridesPreviousValue() public {
        vm.prank(owner);
        token.mint(1000);
        vm.prank(owner);
        token.approve(spender, 100);

        vm.prank(owner);
        token.approve(spender, 50);

        assertEq(token.allowance(owner, spender), 50);
    }

    function test_ApproveEmitsEvent() public {
        vm.prank(owner);
        token.mint(1000);
        vm.prank(owner);

        vm.expectEmit(true, true, false, true);
        emit IERC20.Approval(owner, spender, 100);

        token.approve(spender, 100);
    }

    function test_Allowance() public {
        vm.prank(owner);
        token.mint(1000);

        vm.prank(owner);
        token.approve(spender, 100);

        vm.prank(owner);
        token.approve(spender2, 200);

        assertEq(200, token.allowance(owner, spender2));
    }

    function test_TransferBalance() public {
        vm.prank(owner);
        token.mint(1000);

        vm.prank(owner);
        token.transfer(spender, 300);

        assertEq(300, token.balanceOf(spender));
        assertEq(700, token.balanceOf(owner));
    }

    function test_TransferEmitsEvent() public {
        vm.prank(owner);
        token.mint(1000);

        vm.prank(owner);
        vm.expectEmit(true, true, false, true);
        emit IERC20.Transfer(owner, spender, 300);

        token.transfer(spender, 300);
    }

    function test_TransferFrom() public {
        vm.prank(owner);
        token.mint(1000);

        vm.prank(owner);
        token.approve(spender, 100);

        vm.prank(spender);
        token.transferFrom(owner, spender2, 100);

        assertEq(100, token.balanceOf(spender2));
        assertEq(900, token.balanceOf(owner));
        assertEq(0, token.allowance(owner, spender));
    }

    function test_TransferFromNotEnoughAllowance() public {
        vm.prank(owner);
        token.mint(1000);

        vm.prank(owner);
        token.approve(spender, 100);

        vm.prank(spender);
        vm.expectRevert();

        token.transferFrom(owner, spender2, 200);
    }

    function test_TransferNotEnoughMoney() public {
        vm.prank(owner);
        token.mint(100);

        vm.prank(owner);
        vm.expectRevert();

        token.transfer(spender, 300);
    }

    function test_MintWithoutOwner() public {
        vm.prank(attacker);
        vm.expectRevert();

        token.mint(1000);
    }
}
