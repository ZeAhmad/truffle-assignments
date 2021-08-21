pragma solidity 0.8.0;

contract CryptoBank {
    
    address     private     owner;      // owner address
    uint8       private     counter;    // Counter for number of accounts
    uint        private constant bonus = 1 ether; // constant for bonus value
  
    mapping(address => uint) private accounts;  //mapping to hold accounts and balances 
   
   // This constrctor initialzes the bank with a minimum of 50 ethers and sets the bank owner and counter values
  
    constructor()  payable {
        owner = msg.sender;
        require(msg.value == 50 ether);
    counter = 0;
    }
    
  // This modifier checks if the account is valid or Not
  
    modifier accValidity(address _add) {
        require(_add != address(0) && accounts[_add] > 0, "Not a valid account");
        _;
        
    }
    
  // This function can be called by anyone to open an account 
    function openAccount() public payable {
        
        require(msg.value > 0 && msg.sender != address(0)); // check the account address and amount valditiy
        accounts[msg.sender] =  msg.value; // create an account
    
// Check if the account holder is among first 5 accounts, if yes, transfer bonus

        if(counter <=4) {
            payable(msg.sender).transfer(bonus);
            accounts[msg.sender] += bonus;
            counter++;
        }

    }
    // this function returns the balance of a valid account
    
    function balanceInquiry() public view accValidity(msg.sender) returns (uint) {
        
        return accounts[msg.sender];
        
    }
   
   // this function is used to withdraw an amount for an accounts
    function withdraw() public payable accValidity(msg.sender) {
        
        require(msg.value > 0  && msg.value <= accounts[msg.sender],"Invalid Withdraw amount");
    
      payable(msg.sender).transfer(msg.value);
      
        accounts[msg.sender] -= msg.value;
     
     }
    
    // This function can be used by anyone to depoite any amount to any accounts
    
    function depositeAmount(address _add, uint _amount) public payable  {
        accounts[_add] += _amount;
    }
    
    
    // this function can be used to close an account.
    function closeAccount() public accValidity(msg.sender) {
        
        delete accounts[msg.sender];
    }
    
    // this function can be used by the owner only to close bank.
    function closeBank() external payable  {
        
        require(msg.sender == owner,"only owner can close the bank");
        
        selfdestruct(payable(owner));
        
    }
   
}