// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import { PriceConverter } from "./PriceConvert.sol";

error FundMe__NotOwner();
error FundMe__NotEnoughEth();
error FundMe__CallFailed();
contract FundMe {
    using PriceConverter for uint256;
    mapping(address => uint256) public addressToAmount;
    address[] public funders;
    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;
    AggregatorV3Interface public immutable i_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        i_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        if(msg.value.getConversionRate(i_priceFeed)<MINIMUM_USD) revert FundMe__NotEnoughEth();
        addressToAmount[msg.sender] += msg.value;
            funders.push(msg.sender);
        
    }
    modifier OnlyOwner {
        if(msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function getVersion() public view returns (uint256) {
        return i_priceFeed.version();
    }

    function withdraw() public OnlyOwner {
        for(uint256 i=0; i<funders.length; i++){
            addressToAmount[funders[i]] = 0;
        }
        funders = new address[](0);

        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        if(!success) revert FundMe__CallFailed();
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}


