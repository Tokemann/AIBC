// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract CryptoFace is ERC721URIStorage {

using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  address[] ownerAddresses;               // total minted Address
  uint256[] tokenList;                  // total minted Tokens
  mapping(uint256 => string) hashes; 
  mapping(uint256 => address) allowedByTokenHash;                                        	
  mapping(address => uint256) allowedByAddressHash;                                     	
  mapping(uint256 => address) ipfsHash;    
  mapping(uint256=>uint256) tokenPriceHash;                                 	// tokenId=>Price
  
 
constructor() public ERC721("CFACE", "CFACE") {}

    function addRecipient(address recipient) public returns (uint256)
	{
	  require(allowedByAddressHash[recipient]==0, "Not Allowed");	
	  allowedByAddressHash[recipient]=1;	//  0 means not exist in register (so not allowed)
	  return 1;
	}
	function addCryptoFace(address recipient, string memory hash,uint256 price)  public  returns (uint256)
	{
	 
	    require(allowedByAddressHash[recipient]!=0, "Not Allowed");	
		
				if(allowedByAddressHash[recipient]!=0)
				{
				uint256 newItemId = _tokenIds.current();				// get Last Existing Token
				newItemId=newItemId+1;									// increment in our menory not in existing menory
				require(!_exists(newItemId), "nonexistent token");		// if token no exist then terminate
				hashes[newItemId] = hash;									// mapping token=>IPFS Hass code
				_mint(recipient, newItemId);
				_tokenIds.increment();										// my above increment will reflect to existing increament
				_setTokenURI(newItemId, hashes[newItemId]);  			    // toekenId=>IPFS Hash
				tokenPriceHash[newItemId]=price;
				tokenList.push(newItemId);
				ownerAddresses.push(recipient);
				allowedByAddressHash[recipient]=0;
				return newItemId;
				}
				return 0;
		
	}
	function getPrice(uint256 tokenId) public view returns(uint256)
	{
		   require(_exists(tokenId), "nonexistent token");
		   return tokenPriceHash[tokenId];
	}
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
	    return "CryptoFace";
	}
	
	function getToken(uint256 tokenId) private view returns(string memory)
	{
	    require(_exists(tokenId), "nonexistent token");
	    string memory _tokenURI = hashes[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
	}
	
	function getMyToken(uint256 tokenId) public view returns(string memory)
	{
	    require(_exists(tokenId), "nonexistent token");
	    address selfAddress=msg.sender;
	    address ownerAddress=ownerOf(tokenId);
	    require(ownerAddress==selfAddress,"invalid access");
	    return getToken(tokenId);
	    
	} 
	
	
	
	
	
    function getOwnerList() public view returns(address[] memory)
    {
        address[] memory X=ownerAddresses;
        return X;
    }
    
    function getTokenList() public view returns(uint256[] memory)
    {
        uint256[] memory Y=tokenList;
        return Y;
    }
}