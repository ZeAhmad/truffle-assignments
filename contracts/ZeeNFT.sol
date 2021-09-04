// SPDX-License-Identifier: MIT

/*
user can only buy tokens when the sale is started
the sale should be ended within 30 days
the owner can set base URI
the owner can set the price of NFT
NFT minting hard limit is 100
*/ 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
    

contract ZeeNFT is ERC721, Ownable {
    
    bool internal saleStart;
    uint internal saleEndDate;
    uint internal saleStartDate; 
    uint8 internal totalSupply;
    
    mapping(uint256 => uint256)  tockenPrice; // tocken id and tocken price
    
    constructor() ERC721("ZeeNFT","Z") {
       _baseURI();
       saleStart = false;
       totalSupply = 0;
       
    }

function fetchPrice() public payable returns(uint) {
    return msg.value;
}
function  setSale() public  onlyOwner {

     saleStart = true;
     saleStartDate = block.timestamp;
     saleEndDate = saleStartDate + 30 days;

}
function setTockenPrice(uint _tockenid,uint _price) public  {
  require(_exists(_tockenid),"tocken does not exist");
  require(ERC721.ownerOf(_tockenid) == owner(), "ERC721: transfer of token that is not own");
    tockenPrice[_tockenid] = _price;
}
function getTockenPrice(uint _tockenid) public view returns (uint) {
    return tockenPrice[_tockenid];
}
modifier checkSale {
    if (saleStart == true && block.timestamp < saleEndDate) {
        _;
    }
}

modifier checkTotalSupply  {
    if (totalSupply < 100) {
        _;
    }
}

function _baseURI() internal view virtual override onlyOwner returns (string memory) {
        return "https://floydnft.com/token/";
    }

function buyTocken(address to, uint tid) public payable checkSale checkTotalSupply {

    _mint(to,tid);
 
    totalSupply+=1;
    
}
}