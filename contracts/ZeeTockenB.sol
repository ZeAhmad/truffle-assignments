//"SPDX-License-Identifier:UNLICENSED"

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ZeeTockenB is  ERC20, ERC20Capped, ERC20Pausable, Ownable {
 using SafeMath for uint;


    uint private tockenPrice = 10000000000000000;
    uint private initialSupply = 1000* 10**decimals();
    uint private releaseTime; 

    
    constructor()  ERC20("Zee Tocken", "Z")     ERC20Capped(initialSupply.mul(4))    {
    
     ERC20._mint(owner(),initialSupply);
     emit Transfer(address(this),owner(),initialSupply);
    
     releaseTime = block.timestamp + 30 days;
     
     }
   
   
    function changeTockenPrice(uint nPrice) public  onlyOwner whenNotPaused  {
        require(msg.sender == owner(), "only authorized can change price");
        require(nPrice > 0,"price must be greater than zero");
        tockenPrice = nPrice;
    }
    
    function buyTocken(uint _tockens) public payable checkReleaseTime {
       
       require(_tockens > 0 && _tockens < balanceOf(owner()), "number of tokens are not valid");
       require(msg.value >= (_tockens*tockenPrice), "amount of ether is not valid");
       
        _transfer(owner(),msg.sender,_tockens);
       emit Transfer(owner(), msg.sender, _tockens);
      }
         
     modifier checkReleaseTime() {
        require(block.timestamp >= releaseTime, "time has not finished yet");
        _;
    }     
        function _mint(address account, uint256 amount) internal virtual override (ERC20,ERC20Capped) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }
         
    function transfer(address recipient, uint256 amount) public checkReleaseTime virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
   
   
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override (ERC20, ERC20Pausable){
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
   
   
   receive() external payable  {
   
   buyTocken(msg.value/tockenPrice);
   }
   
    fallback() external payable {
        buyTocken(msg.value/tockenPrice);
   }

function _stop() public  whenNotPaused {
        _pause();
    }
 function _start() public virtual whenPaused {
        _unpause();
        
            }
}