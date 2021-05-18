// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract GenesisContract is ERC721URIStorage {

using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  

  address[] ownerAddresses;               // total minted Address
  uint256[] tokenList;                  // total minted Tokens
  mapping(uint256 => string) hashes;                                        	// tokenId=>IPFS
  mapping(address => uint256) ownerCap;                                     	// maximum deployed NFT
  mapping(address=>mapping(uint256=>bool)) hashesLayersAllowed;             	// address=>TokenId ==true! false 
  mapping(uint256=>mapping(address=>bool)) hashesLayersAllowedByTokenId;    	// tokenID=>address == true! false
  mapping(uint256=>uint256) tokenPriceHash;                                 	// tokenId=>Price
  mapping(address=>uint[]) hashesLayersAllowedCount;							// address=>TokenId , TOTAL TOKENS
  mapping(uint256=>address[]) hashesLayersAllowedByTokenIdCount;   // TokenID=>Address , TOTAL Viewers
  mapping(uint256=>address) customeErc20;
  mapping(address=>uint[]) mytokens;
  
  
 
constructor() public ERC721("MYTCAIBC", "MYTCAIBC") {}

	function awardItem(address recipient, string memory hash,uint256 _length,uint256 price)  public  returns (uint256)
	{
	  if(ownerCap[recipient]==0) { ownerCap[recipient]=_length; ownerAddresses.push(recipient);  }
	 
		uint256 bal=balanceOf(recipient);
	    uint256 cap=ownerCap[recipient];
		if(cap>bal)
			{
			
				uint256 newItemId = _tokenIds.current();				// get Last Existing Token
				newItemId=newItemId+1;									// increment in our menory not in existing menory
				require(!_exists(newItemId), "nonexistent token");		// if token no exist then terminate
				require(addViewer(recipient,newItemId)==true,"not burnt");	//	add tokenId to Mapping for fetch records (allowed buffer who will see)
				hashes[newItemId] = hash;									// mapping token=>IPFS Hass code
				_mint(recipient, newItemId);
				_tokenIds.increment();										// my above increment will reflect to existing increament
				_setTokenURI(newItemId, hashes[newItemId]);  			    // toekenId=>IPFS Hash
				tokenPriceHash[newItemId]=price;
				tokenList.push(newItemId);
				mytokens[recipient].push(newItemId);
				return newItemId;
			}
		else require(1==0, "Balance Bounced");	
	    return 1;
	}
	function getPrice(uint256 tokenId) public view returns(uint256)
	{
		   require(_exists(tokenId), "nonexistent token");
		   return tokenPriceHash[tokenId];
	}
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
	    return "bebak";
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
	
	function addViewer(address _viewerAddress,uint256 tokenId) private    returns(bool)
	{
	    
	    hashesLayersAllowed[_viewerAddress][tokenId]=true;
		hashesLayersAllowedByTokenId[tokenId][_viewerAddress]=true;
		
		hashesLayersAllowedCount[_viewerAddress].push(tokenId);
		hashesLayersAllowedByTokenIdCount[tokenId].push(_viewerAddress);
		
	    return hashesLayersAllowed[_viewerAddress][tokenId];
	}
	
	function addRequestForView(address _viewerAddress,uint256 tokenId,uint256 price) public payable returns(bool)
	{
		require(_exists(tokenId), "nonexistent token");
	    uint256 priceToken=tokenPriceHash[tokenId];
		require(price==priceToken,"Invalid Price");
		hashesLayersAllowed[_viewerAddress][tokenId]=true;
		hashesLayersAllowedByTokenId[tokenId][_viewerAddress]=true;
		
		hashesLayersAllowedCount[_viewerAddress].push(tokenId);
		hashesLayersAllowedByTokenIdCount[tokenId].push(_viewerAddress);
		
	    return true;
	}
	
	function viewToken(uint256 tokenId) public view returns(string memory)
	{
	    require(_exists(tokenId), "nonexistent token");
	    address selfAddress=msg.sender;
	    require(hashesLayersAllowed[selfAddress][tokenId],"notallowed token");
	   
	    return getToken(tokenId);
	    
	} 
	function getViewers(uint256 tokenId) public view returns( address[] memory)
	{
	    
	    address[] memory memoryArray =hashesLayersAllowedByTokenIdCount[tokenId];
       
        return memoryArray;
	    
	    
	} 
	function getTokens(address _viewerAddress) public view returns(uint256[] memory)
	{
	    
	     uint256[] memory tokenIds =hashesLayersAllowedCount[_viewerAddress];
       
			return tokenIds;
	}
	
	function getTokensOwner(address _viewerAddress) public view returns(uint256[] memory)
	{
	    
	     uint256[] memory tokenIds =mytokens[_viewerAddress];
       
			return tokenIds;
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
    
    function setERC20Address(uint256 tokenId,address erc20Address) public returns (bool)
	{
		 require(_exists(tokenId), "nonexistent token");
		 address selfAddress=msg.sender;
	     address ownerAddress=ownerOf(tokenId);
		 require(ownerAddress==selfAddress,"invalid access");
		 customeErc20[tokenId]=erc20Address; return true;
		 
	}
	
	 function getERC20Address(uint256 tokenId) public returns (address)
	{
		 require(_exists(tokenId), "nonexistent token");
		 return customeErc20[tokenId];
		 
	}
}