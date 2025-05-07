// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getConversionRate(uint256 ethAmt, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (,int256 answer,,,) = priceFeed.latestRoundData();
        uint256 uprice = uint256(answer*10000000000);
        return (ethAmt*uprice)/1e18;
    }
}