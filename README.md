# FundMe Smart Contract

A decentralized crowdfunding platform built with Solidity and Foundry. This project allows users to fund the contract with ETH, with a minimum USD value requirement, and enables the contract owner to withdraw the funds.

## Features

- Accept ETH donations with a minimum USD value requirement (5 USD)
- Chainlink Price Feed integration for real-time ETH/USD conversion
- Owner-only withdrawal functionality
- Track funders and their contribution amounts
- Fallback and receive functions for direct ETH transfers

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Node.js](https://nodejs.org/) (for development)
- An Ethereum wallet with testnet ETH

## Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd fondry-fund-me
```

2. Install dependencies:

```bash
forge install Cyfrin/foundry-devops
forge install foundry-rs/forge-std
forge install smartcontractkit/chainlink-brownie-contracts
```

## Usage

### Build

```bash
forge build
```

### Test

```bash
forge test
```

### Format

```bash
forge fmt
```

### Gas Snapshots

```bash
forge snapshot
```

### Local Development

Start a local Ethereum node:

```bash
anvil
```

### Deploy

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Interact with Contract

Use Cast to interact with the deployed contract:

```bash
cast <subcommand>
```

## Contract Functions

- `fund()`: Send ETH to the contract (minimum 5 USD worth)
- `withdraw()`: Owner can withdraw all funds
- `getFundedAmount(address)`: Get amount funded by a specific address
- `getFunder(uint256)`: Get funder address at specific index
- `getOwner()`: Get contract owner address
- `getVersion()`: Get Chainlink Price Feed version

## Foundry Documentation

For more information about Foundry, visit: https://book.getfoundry.sh/

### Help Commands

```bash
forge --help
anvil --help
cast --help
```
