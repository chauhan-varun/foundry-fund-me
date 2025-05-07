// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;
    DeployFundMe deployer;
    function setUp() external {
        deployer = new DeployFundMe();
        fundme = deployer.run();
    }
    function testMinUsd() public view {
       assertEq(fundme.MINIMUM_USD(), 5e18);
    }
    function testOwner() public view {
        console.log(fundme.i_owner());
        console.log(address(this));
        assertEq(fundme.i_owner(), msg.sender);
    }
    function testVersion() public view {
        assertEq(fundme.getVersion(), 4);
    }
}