//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Stakeable {
    uint256 private totalStaked;
    uint256 private sumOfRewardPercentOverTime;

    struct Stake {
        uint256 amount;
        uint256 since;
        uint256 sumOfRewardPercentOverTimeAtSince;
    }

    mapping (address => Stake) public stakes;

    function _stake(uint256 amount) internal {
        require(stakes[msg.sender].amount == 0, "you have already staked");
        stakes[msg.sender] = Stake(amount, block.timestamp, sumOfRewardPercentOverTime);
        totalStaked = totalStaked + amount;
    }

    function _distribute(uint256 amount) internal {
        require(totalStaked > 0, "there is no staked tokens");

        /**
        * We are finding what percent the reward is out of total staked. 
        * As we cannot store decimals therefore we first multiply then divide
        * So 56.78% becomes 5678
        */
        sumOfRewardPercentOverTime = sumOfRewardPercentOverTime + (((amount*10000/totalStaked) * (100))/100);
    }

    function calculateReward(address user) public view returns (uint256) {
        Stake storage stake = stakes[user];

        /**
        * Calculate the total tokens reward for a user
        */
        return ((sumOfRewardPercentOverTime - stake.sumOfRewardPercentOverTimeAtSince)*stake.amount)/10000;   
    }

    function _unstake(address user) internal returns(uint256) {
        uint256 amountStaked = stakes[user].amount;
        require(amountStaked > 0, "user hasn't staked");

        uint256 reward = calculateReward(user);
        totalStaked = totalStaked - amountStaked;
        stakes[user].amount = 0;

        return amountStaked + reward;
    }
}
