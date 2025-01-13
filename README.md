
# FundMe Smart Contract

A simple and efficient smart contract built using **Foundry** that allows users to fund the contract by sending Ether, track the amount funded by each address, and enables the contract owner to withdraw funds. The contract includes a minimum funding requirement in USD and integrates **Chainlink's price feed** to ensure fair and accurate conversion between Ether and USD.

## Features
- **Fund the Contract**: Users can fund the contract by sending Ether. The contract ensures that the funding is above a specified minimum value (in USD).
- **Track Contributions**: The contract tracks the amount funded by each user.
- **Withdraw Funds**: Only the contract owner can withdraw the funds from the contract.
- **Receive Ether**: The contract can also accept Ether via the `receive` or `fallback` function.
- **Minimum Funding Requirement**: A minimum Ether contribution value is required, which is checked using Chainlink’s price feed.
- **Security**: The contract includes a custom error for access control and a modifier to ensure only the owner can perform certain actions.

## Getting Started

### Prerequisites

- **Foundry**: This project uses [Foundry](https://getfoundry.sh/) for smart contract development, testing, and deployment.
- **Solidity**: This contract is written in Solidity version `^0.8.24`.
- **Chainlink Price Feeds**: The contract uses Chainlink's AggregatorV3Interface to get the current price of Ether in USD.

### Clone the Repository

To get started with the contract, clone the repository to your local machine:

```bash
git clone https://github.com/oyewoas/fund-me.git
cd fund-me-contract
```

### Install Foundry

Make sure to install Foundry and its dependencies if you haven't already:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Install Dependencies

Install the necessary dependencies for the project:

```bash
forge install
```

### Available Commands

Here are the commands available via `make`:

#### Clean the Repo

```bash
make clean
```

#### Remove Modules

```bash
make remove
```

#### Install Dependencies

```bash
make install
```

This installs the necessary dependencies for the contract, including:
- `cyfrin/foundry-devops`
- `smartcontractkit/chainlink-brownie-contracts`
- `foundry-rs/forge-std`

#### Update Dependencies

```bash
make update
```

#### Build the Contract

```bash
make build
```

#### Test the Contract

```bash
make test
```

#### Deploy to Local Network

```bash
make deploy
```

To deploy the contract to a local network, use the following command:

```bash
make deploy NETWORK_ARGS="--rpc-url http://localhost:8545 --private-key YOUR_PRIVATE_KEY --broadcast"
```

#### Deploy to Sepolia Network

```bash
make deploy-sepolia
```

#### Deploy to zkSync

```bash
make deploy-zk
```

#### Fund the Contract

```bash
make fund SENDER_ADDRESS="your_senders_address" NETWORK_ARGS="--rpc-url http://localhost:8545 --private-key YOUR_PRIVATE_KEY"
```

#### Withdraw from the Contract

```bash
make withdraw SENDER_ADDRESS="your_senders_address" NETWORK_ARGS="--rpc-url http://localhost:8545 --private-key YOUR_PRIVATE_KEY"
```

### Interacting with the Contract

1. **Funding the Contract**:

   Users can fund the contract with a minimum amount of Ether (set as `5 USD`). To do this, they need to send Ether to the contract by calling the `fund()` function.

   Example:

   ```solidity
   fundMe.fund{value: 1 ether}();
   ```

2. **Withdrawing Funds**:

   Only the contract owner can withdraw funds. The owner can call the `withdraw()` or `cheaperWithdraw()` functions to withdraw the contract balance to their address.

   Example:

   ```solidity
   fundMe.withdraw();
   ```

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
