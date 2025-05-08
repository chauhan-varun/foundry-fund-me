// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;
    DeployFundMe deployer;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.2 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        deployer = new DeployFundMe();
        fundme = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    modifier funded {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        _;
    }

    function testMinUsd() public view {
       assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwner() public view {
        assertEq(fundme.getOwner(), msg.sender);
    }

    function testVersion() public view {
        assertEq(fundme.getVersion(), 4);
    }

    function testFundFailedWithoutEnoughEth() public {
        
        vm.expectRevert();
        fundme.fund{value: 0 ether}();
    }

    function testFundUpdateAmountData() public funded {
        assertEq(fundme.getFundedAmount(USER), SEND_VALUE);
    }

    function testFunderArray() public funded {
        assertEq(fundme.getFunder(0),USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();
    }

    function testWithdrawWithASingleFunder() public {
        //Arrange
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        //Act
        vm.prank(fundme.getOwner());
        fundme.withdraw();

        //assert
        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundMeBalance = address(fundme).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingFundMeBalance+startingOwnerBalance);
    }

    function testWithdrawWithMultipleOwner() public funded {
        for(uint160 i = 1; i<10; i++){
            hoax(address(i),STARTING_BALANCE); //hoax == vm.prank new USER + vm.deal(USER, STARTING_BALANCE)
            fundme.fund{value: SEND_VALUE}();
        }

        //arrange
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        //act 
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        // assert
        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundMeBalance = address(fundme).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingFundMeBalance+startingOwnerBalance);

    }
}