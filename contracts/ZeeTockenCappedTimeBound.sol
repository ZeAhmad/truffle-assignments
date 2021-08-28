//"SPDX-License-Identifier:UNLICENSED"

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract ZeeTockenCappedTimeBound is  ERC20, ERC20Capped {
 
    mapping (address => uint256) private _balances;                           // Like ERC20
    mapping (address => mapping (address => uint256)) private _allowances;   //Like ERC20
    uint256 private _totalSupply;                                            //Like ERC20
    uint256 private tockenPrice = 10000000000000000;                         //Like ERC20
    uint256 private _cap;                                                   // Like ERC20Capped
    address public owner;                                                   // my own declared variable

    constructor() 
    
    ERC20("Zee Tocken", "Z") 
    
    ERC20Capped(1000000000000000) 
    
    {
        owner = msg.sender;
                   
    _totalSupply = 1000000 * 10**decimals();      // decimals; //exponenctial farmola
    
        
        //transfer total supply to owner
        _balances[owner] = _totalSupply;
        
        //fire an event on transfer of tokens
        emit Transfer(address(this),owner,_totalSupply);
     }
     
      /**
     * @dev Returns the cap on the token's total supply.
     */
    function cap() public view virtual  override returns (uint256) {
        return _cap;
    }

    /**
     * @dev See {ERC20-_mint}.
     */
    function _mint(address account, uint256 amount) internal virtual  override (ERC20,ERC20Capped) {
       
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
       
        super._mint(account, amount);
    }
    function changeTockenPrice(uint nPrice) public {
        require(msg.sender == owner, "only owner can change price");
        require(nPrice > 0,"price must be greater than zero");
        tockenPrice = nPrice;
    }
    
 
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        address sender = msg.sender;
        require(sender != address(0), "Not a valid sender address");
        require(recipient != address(0), "Not a valid recipient address");
        require(_balances[sender] > amount,"transfer amount exceeds balance");

        //decrease the balance of token sender account
        _balances[sender] = _balances[sender] - amount;
        
        //increase the balance of token recipient account
        _balances[recipient] = _balances[recipient] + amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address tokenOwner, address spender) public view virtual override returns (uint256) {
        return _allowances[tokenOwner][spender]; //return allowed amount
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address tokenOwner = msg.sender;
        require(tokenOwner != address(0), "BCC1: approve from the zero address");
        require(spender != address(0), "BCC1: approve to the zero address");
        
        _allowances[tokenOwner][spender] = amount;
        
        emit Approval(tokenOwner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address tokenOwner, address recipient, uint256 amount) public virtual override returns (bool) {
        address spender = msg.sender;
        uint256 _allowance = _allowances[tokenOwner][spender]; //how much allowed
        require(_allowance > amount, "BCC1: transfer amount exceeds allowance");
        
        //deducting allowance
        _allowance = _allowance - amount;
        
        //--- start transfer execution -- 
        
        //owner decrease balance
        _balances[tokenOwner] =_balances[tokenOwner] - amount; 
        
        //transfer token to recipient;
        _balances[recipient] = _balances[recipient] + amount;
        
        emit Transfer(tokenOwner, recipient, amount);
        //-- end transfer execution--
        
        //decrease the approval amount;
        _allowances[tokenOwner][spender] = _allowance;
        
        emit Approval(tokenOwner, spender, amount);
        
        return true;
    }
   
   function buyTocken(uint _tockens) public payable returns (bool) {
       
       require(_tockens > 0 && _tockens < _totalSupply, "number of tokens are not valid");
       require(msg.value >= (_tockens*tockenPrice), "amount of ether is not valid");
       
        _balances[owner] = _balances[owner] - _tockens;
        
        //increase the balance of token recipient account
        _balances[msg.sender] = _balances[msg.sender] + _tockens;

        emit Transfer(owner, msg.sender, _tockens);
        return true;

       
         }
         
         
         
   receive() external payable  {
   
  buyTocken(msg.value/tockenPrice);
   }
   
    fallback() external payable {
        buyTocken(msg.value/tockenPrice);
   }

}