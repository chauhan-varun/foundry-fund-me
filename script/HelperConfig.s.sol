// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import { MockV3Aggregator } from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000e8; // 2000.00000000

    struct NetworkConfig {
        address priceFeed;
    }
    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if(block.chainid == 1) {
            activeNetworkConfig = getEthMainnetConfig();
        }
        else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }
    
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if(activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);
        vm.stopBroadcast();
        return NetworkConfig({priceFeed: address(mockV3Aggregator)});
    }

    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
    }
}