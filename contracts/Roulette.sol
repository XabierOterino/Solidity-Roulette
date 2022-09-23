//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/access/Ownable.sol"
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./VRFConsumer.sol";
import "@openzeppelin/contracts/utils/Timers.sol";

contract Roulete is VRFv2Consumer  , ReentrancyGuard{
    using Timers for Timers.Timestamp;
    Timers.Timestamp private _deadLine; //timer to manage timespace between rolls
    event Rolled(uint256 winnerNumber);

    uint256[] public lastRolls; //latest roulette results
    mapping(address => uint256) public balanceOf; //deposited money
    mapping(address => uint256) public lastBet; //amount of players' last bet

    // GLOBAL VARIABLES = REFERENCE TO COLORS
    uint256 public constant GREEN=0;
    uint256 public constant RED=1;
    uint256 public constant BLACK=2;

    struct betBoard{
        address [] red;
        address [] black;
        address [] green;
    }

    betBoard  bets; //all the bets before the roll

    constructor(uint64 subscriptionId) VRFv2Consumer(subscriptionId){}

    //Check that bets are open
    function betsOpen() public view returns(bool){
        return _deadLine.isExpired();
    }

    //Roll the roulette
    function roll() external onlyOwner{
        _requestRandomWords();
    }
    // Deposit ETH
    function deposit(uint256 amount) external payable{
        require(msg.value>=amount, "msg.value<amount");
        _mint(msg.value * 997 / 1000); // after 0.03% fees
    }
    // Withdraw ETH
    function withdraw(uint256 amount) external nonReentrant{
        require(balanceOf[msg.sender]>=amount,"Insufficient balance");
        _burn(amount);
        msg.sender.call{value:amount}('');
    }
    // Play choosing a color
     function playColors(uint256 bet, uint256 color) external{
        require(betsOpen(), "Bets closed!");
        require(bet>0, "Invalid bet");
        require(color<3, "Invalid color");
        _burn(bet);
        if(color==1){
            bets.red.push(msg.sender);
        }else if(color==2){
            bets.black.push(msg.sender);
        }else{
            bets.green.push(msg.sender);
        }
        lastBet[msg.sender] = bet;

    }
    
    
    function _mint(uint256 _amount) internal{
        balanceOf[msg.sender]+=_amount;
    }

    function _burn(uint256 _amount) internal{
        balanceOf[msg.sender]-=_amount;
    }

    // Update the balances after picking the winners
    function _update(uint256 randomNumber) internal{
        uint256 winner = randomNumber % 27 -1;
        bool isRed = winner % 2 < 1;
        if(winner!=0 && isRed){
            for(uint256 i=0; i<bets.red.length;){
                    address player = bets.red[i];
                    _mint(lastBet[player] * 2);
            }
            delete bets.green;
        }else if(winner!=0 && !isRed){
            for(uint256 i=0; i<bets.black.length;){
                    address player = bets.red[i];
                    _mint(lastBet[player] * 2);
            }
        }else{
            if(bets.green.length>0){
                for(uint256 i=0; i<bets.green.length;){
                    address player = bets.green[i];
                    _mint(lastBet[player] * 27);
                }
            }
        }
        delete bets.black;
        delete bets.red;
        lastRolls.push(winner);
        emit Rolled(winner);
    }

    //Oracle calls this function after rolling the roulette
    // Updates balances and sets a new deadline
    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal virtual override {
        _update(randomWords[0]);
        _deadLine.setDeadline(uint64(block.timestamp + 3600));
    }



}
