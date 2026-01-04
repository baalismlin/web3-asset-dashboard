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

    function test_BalanceOf() public {}

    function test_MintWithoutOwner() public {
        vm.prank(attacker);
        vm.expectRevert();

        token.mint(1000);
    }
}
