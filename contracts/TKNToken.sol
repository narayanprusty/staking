//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Stakeable.sol";

contract TKNToken is ERC20, Stakeable, Ownable {

    constructor(uint256 initialSupply) ERC20("TKN Token", "TKN") {
        _mint(msg.sender, initialSupply);
    }

    function stake(uint256 amount) public {
        require(amount <= balanceOf(msg.sender), "insufficient balance to stake");
        _transfer(msg.sender, address(this), amount);
        _stake(amount);
    }

    function distribute(uint256 amount) public onlyOwner {
        require(amount <= balanceOf(msg.sender), "insufficient balance to distribute");
        _transfer(msg.sender, address(this), amount);
        _distribute(amount);
    }

    // function greet() public view returns (string memory) {
    //     uint rewardToDistribute = 153;
    //     uint totalStaked = 1000;
    //     uint S = ((rewardToDistribute*10000/totalStaked) * (100))/100;

    //     uint userStacked = 1000;
    //     uint userReward = (S*userStacked)/10000;
    //     return greeting;
    // }
}
