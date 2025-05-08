// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployer;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.2 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        deployer = new DeployFundMe();
        fundMe = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteraction() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withDrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);

    }
}