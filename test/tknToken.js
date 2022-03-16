const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TKNToken", function () {
  
  let tknToken 
  let owner
  let user

  it("check initial balance", async function () {
    const TKNToken = await ethers.getContractFactory("TKNToken");
    tknToken = await TKNToken.deploy(10000);
    await tknToken.deployed();

    const accounts = await ethers.getSigners()
    owner = accounts[0]
    user = accounts[1]
    
    expect(await tknToken.balanceOf(owner.address)).to.equal(10000);
  });

  it("stake tokens", async function () {
    await tknToken.transfer(user.address, 1000);
    await tknToken.connect(user).stake(1000);

    expect(await tknToken.balanceOf(user.address)).to.equal(0);
    expect((await tknToken.stakes(user.address)).amount).to.equal(1000);
  })

  it("distribute and calculate reward", async function () {
    await tknToken.distribute(100);
    expect(await tknToken.calculateReward(user.address)).to.equal(100);
  })

  it("unstake", async function () {
    await tknToken.connect(user).unstake(1050);
    expect((await tknToken.stakes(user.address)).amount).to.equal(50);
  })
});
