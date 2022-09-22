//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/access/Ownable.sol"
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Roullete is Ownable , ReentrancyGuard{
    event Rolled(uint256 winnerNumber);

    bool public betsClosed;

    uint256[] public lastRolls;
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public lastBet;
    uint256 public players;

    uint256 public constant GREEN=0
    uint256 public constant RED=1
    uint256 public constant BLACK=2

    struct betBoard{
        address [] red;
        address [] black;
        address [] green;
    }

    betBoard public bets;

    function roll() external onlyOwner{

    }

    function deposit(uint256 amount) external payable{
        require(msg.value>=amount, "msg.value<amount");
        _mint(msg.value);
    }

    function withdraw(uint256 amount) external nonReentrant{
        require(balanceOf[msg.sender]>=amount,"Insufficient balance");
        _burn(amount);
        msg.sender.call{value:amount}('');
    }

    function _mint(uint256 _amount) internal{
        balanceOf[msg.sender]+=_amount;
    }

    function _burn(uint256 _amount) internal{
        balanceOf[msg.sender]-=_amount;
    }

    function playColors(uint256 bet, uint256 color) external{
        require(bet>0, "Invalid bet");
        require(color<3, "Invalid color");
        _burn(bet);
        _lastBet[msg.sender] = bet;

    }

    function update(uint256 randomNumber) external{
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
            if(bets.green>0){
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
}
