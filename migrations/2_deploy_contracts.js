const DappToken = artifacts.require('DappToken')
const DaiToken = artifacts.require('DaiToken')
const TokenFarm = artifacts.require('TokenFarm')

// deployer-deployer of the smart contract
// accounts - accounts from ganache
//network - smart contract network

module.exports = async function (deployer, network, accounts) {
    // deploy Dummy Dai token smart contract
    await deployer.deploy(DaiToken)
    const daiToken = await DaiToken.deployed()

    // deploy dapp token smart contract
    await deployer.deploy(DappToken)
    const dappToken = await DappToken.deployed()

    //deploy token farm smart contract
    await deployer.deploy(TokenFarm, dappToken.address, daiToken.address)
    const tokenFarm = await TokenFarm.deployed()

    // transfer all the dapp tokens to the token farm smart contract [as the token farm acts like a digital bank and gives away dapp tokens as interest for depositing dai tokens]
    await dappToken.transfer(tokenFarm.address, '1000000000000000000000000')

    //transfer 100 mock dai tokens to an investor [because all the dai tokens are actually deposited into the creator of the smart contract]
    //here we are treating the 2nd account as the investor
    await daiToken.transfer(accounts[1], '100000000000000000000')
}
