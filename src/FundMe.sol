// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe_NotOwner();

contract FundMe {
    // Get funds from users
    // Withdraw funds
    // Set a minimum funding value in USD
    // all unint256 has access to the functions in the PriceConverter library
    using PriceConverter for uint256;

    mapping(address funder => uint256 amountFunded)
        private s_addressToAmountFunded;
    address[] private s_funders;

    address private immutable i_owner;
    uint256 private constant MINIMUM_USD = 5e18; // constant makes for gas efficiency
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        // Allow users to send USD
        // Have a minimun USD sent
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "didn't send enough eth"
        ); // > 1 ether
        // update senders of transactions to this contract
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function cheaperWithdraw() public onlyOwner {
        // only owner can withdraw
        uint256 fundersLength = s_funders.length;
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);
        // actually withdraw funds
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "send failed"); // revert if not sucesssful
    }

    function withdraw() public onlyOwner {
        // only owner can withdraw

        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // reset the array
        s_funders = new address[](0);
        // actually withdraw funds
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "send failed"); // revert if not sucesssful
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            //custom error
            revert FundMe_NotOwner();
        }
        //execute code;
        _;
    }

    // what happens when someone sends eth to the contract without using fund
    // receive - called when ether is sent and no call data sent
    // fallback - called when ether is sent and call data

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /**
     * View / Pure functions (Getters)
     */

    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getPriceFeed() external view returns (address) {
        return address(s_priceFeed);
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getMinimumUSD() external pure returns (uint256) {
        return MINIMUM_USD;
    }
}
