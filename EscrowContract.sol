// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/token/ERC20/ERC20.sol";

/** 
 * @title Owned
 * @dev Base contract to represent ownership of a contract
 * @dev Sourced from Mastering Ethereum at https://github.com/ethereumbook/ethereumbook
 */
contract Owned {
	address payable public owner;

	// Contract constructor: set owner
	constructor() {
		owner = msg.sender;
	}
	
	// Access control modifier
	modifier onlyOwner {
		require(msg.sender == owner,
		        "Only the contract owner can call this function");
		_;
	}
}


/** 
 * @title Mortal
 * @dev Base contract to allow for construct to be destructed
 * @dev Sourced from Mastering Ethereum at https://github.com/ethereumbook/ethereumbook
 */
contract Mortal is Owned {
	// Contract destructor
	function destroy() public onlyOwner {
		selfdestruct(owner);
	}
}

/** 
 * @title InterfaceTokenEscrowContract
 * @dev acts as abstract contract for the main TokenEscrowContract
 */
interface InterfaceTokenEscrowContract {
    function name() view external returns (string memory);
    function symbol() view external returns (string memory);
    function totalSupply() view external returns (uint256);
    function tokenBalancesOf(address _requester) view external returns (uint256);
    function etherBalancesOf(address _requester) view external returns (uint256);
    function depositTokens(uint256 _tokens) external;
    function depositEther(uint256 _etherAmount) payable external;
    function buyTokens(address _seller, 
        address _buyer, 
        uint256 _tokens, 
        uint256 _etherAmount
    )
        external;
    function withdrawTokens() external;
}
    
    
/** 
 * @title TokenEscrowContract
 * @dev Implements escrow system to serve as middleman between seller and buyer
 */
contract TokenEscrowContract is ERC20, Mortal {
    
    // mapping for tokenBalance nad ether Balance of Buyers and Sellers 
    mapping(address => uint256) private tokenBalances;
    mapping(address => uint256) private etherBalances;
    
    // generates tokens
    constructor() public ERC20("Token", "TKN") {
        _mint(msg.sender, 1000000);
    }

    /** 
    * @param _tokens amount of tokens to deposit 
    * @dev sender deposits tokens to contract 
    */
    function depositTokens(uint256 _tokens) public {
        ERC20.approve(msg.sender, _tokens);
    
        // transfer the tokens from the sender to this contract
        ERC20.transferFrom(
            msg.sender, 
            address(this), 
            _tokens
        );
        
        // add the deposited tokens into existing balance, 
        // records how much the sender has put into the smart contract 
        tokenBalances[msg.sender] += _tokens;
    }
    
    /** 
    * @param _etherAmount amount of ether to deposit 
    * @dev sender will deposit ether into contract 
    */
    function depositEther(uint256 _etherAmount) payable public {
        require(msg.value == _etherAmount);
        etherBalances[msg.sender] += _etherAmount;
    }
    
    
    /**
    * @param _seller seller of token(s)
    * @param _buyer buyer of token(s) 
    * @param _tokens amount of tokens to be bought 
    * @param _etherAmount amount of ether used to purchase tkens 
    * @dev buyer can buy tokens providing the adequate amount of ether
    */
    function buyTokens(
        address _seller, 
        address _buyer, 
        uint256 _tokens, 
        uint256 _etherAmount
    ) 
        public 
    {
        require(etherBalances[_buyer] >= _etherAmount, "Error: Not enough ether balance to buy tokens.");
        etherBalances[_buyer] -= _etherAmount;
        etherBalances[_seller] += _etherAmount;
        
        tokenBalances[_seller] -= _tokens;
        tokenBalances[_buyer] += _tokens;
    }
    
    /**
    * @dev when seller wants to stop selling their tokens, 
    * @dev tokens will be sent back to original wallet 
    */
    function withdrawTokens() public {
        tokenBalances[msg.sender] = 0;
        ERC20.transfer(
            msg.sender, 
            tokenBalances[msg.sender]
        );
    }
    
    /**
    * @param _requester address of balance to be returned 
    * @dev returns balance of tokens associated with an address
    */
    function tokenBalancesOf(address _requester) public view returns (uint256) {
        return tokenBalances[_requester];
    }
    
    /**
    * @param _requester address of balance to be returned 
    * @dev returns balance of ether associated with an address
    */
    function etherBalancesOf(address _requester) public view returns (uint256) {
        return etherBalances[_requester];
    }
  
}
