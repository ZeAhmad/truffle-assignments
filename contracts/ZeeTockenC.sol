//"SPDX-License-Identifier:UNLICENSED"

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ZeeTockenC is  ERC20, ERC20Capped, ERC20Pausable, Ownable, AccessControl {
 using SafeMath for uint;


    uint private tockenPrice = 10000000000000000;
    uint private initialSupply = 1000* 10**decimals();
    uint private releaseTime; 

    bytes32 public constant TOCKEN_MANAGER=keccak256("TOCKEN_MANAGER");     
  
    constructor()  ERC20("Zee Tocken", "Z")     ERC20Capped(initialSupply.mul(4))    {
    
     ERC20._mint(owner(),initialSupply);
     emit Transfer(address(this),owner(),initialSupply);
    
     releaseTime = block.timestamp + 30 days;
    
    _setupRole(TOCKEN_MANAGER,msg.sender);
    
     }
  
   
    function ZtransferOwnership(address _newowner) public  onlyOwner whenNotPaused {
        transferOwnership(_newowner);
    }
    function assignManager(address _manager) public onlyOwner {
        _setupRole(TOCKEN_MANAGER,_manager);
    }
    function changeTockenPrice(uint nPrice) public  whenNotPaused  {
        require(hasRole(TOCKEN_MANAGER,msg.sender), "only authorized can change price");
        require(nPrice > 0,"price must be greater than zero");
        tockenPrice = nPrice;
    }
    
    function buyTocken(uint _tockens) public payable checkReleaseTime {
       
       require(_tockens > 0 && _tockens < balanceOf(owner()), "number of tokens are not valid");
       require(msg.value >= (_tockens*tockenPrice), "amount of ether is not valid");
       
        _transfer(owner(),msg.sender,_tockens);
       emit Transfer(owner(), msg.sender, _tockens);
      }
         
    function returnTocken(uint _tockens) public payable  {
       
       require(_tockens > 0 && _tockens < balanceOf(msg.sender), "number of tokens are not valid");
       require(msg.value >= (_tockens*tockenPrice), "amount of ether is not valid");
       
        _transfer(msg.sender,owner(),_tockens);
       emit Transfer( msg.sender,owner(), _tockens);
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