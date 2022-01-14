// The main aim of the project is to deposit dai token(Real world stable coin.[Here it is dummy]) and give dapp token as interest.
pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    //code starts here
    string public name = "Dapp Token Farm";

    //declare state variables to store the address of dapp token and dai token smart contracts
    address public owner;
    DappToken public dappToken;
    DaiToken public daiToken;

    // stakers array to store the addresses of stakers
    address[] public stakers;

    //mapping is a data structure in solidity (key=>value pair)
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    //constructor to initialize state variables
    // we assign the address to state variables as the function parameters are local variables and we can't use them in other functions in future
    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    //1.Stake tokens(deposit)
    function stakeTokens(uint256 _amount) public {
        // require amount greater than 0
        require(_amount > 0, "amount cannot be less than zero");
        //require is an inbuilt function in solidity
        //the following code of the function gets executed only if the require condition gets true

        // transfer mock dai tokens to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        //update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        // add the staker to the stakers array if they haven't staked already
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // update the staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // 2.Unstake tokens(withdraw)
    function unstakeTokens() public {
        // fetch staking balance
        uint256 balance = stakingBalance[msg.sender];

        // require amount greater than 0
        require(
            balance > 0,
            "staking balance cannot be less than 0(You haven't staked)"
        );

        // transfer mock dai tokens back to this contract for staking
        daiToken.transfer(msg.sender, balance);

        //reset the staking balance of sender to 0
        stakingBalance[msg.sender] = 0;

        // update staking status
        isStaking[msg.sender] = false;
    }

    // 3.Issuing tokens(interest)
    function issueTokens() public {
        // only owners can issue tokens
        require(msg.sender == owner, "only owner can issue tokens");

        // issuing tokens to all the stakers
        for (uint256 i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint256 balance = stakingBalance[recipient];
            if (balance > 0) {
                dappToken.transfer(recipient, balance);
            }
        }
    }
}
