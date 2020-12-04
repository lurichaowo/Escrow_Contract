// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20.sol";

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
 * @title EscrowContract
 * @dev Implements escrow system to serve as middleman between seller and buyer
 */
contract EscrowContract is Mortal {
    uint256 tokens;
    address public buyer;
    address payable public seller;
    
    mapping ( address => uint256 ) public balances;
    
    event Purchase(
        address _buyer,
        uint256 _amount
    );
    
    constructor(address _buyer, address payable _seller) public {
    buyer = _buyer;
    seller = _seller;
    }
    
    // seller giving arbiter(the smart contract) tokens they want to sell, through approval and deposit
    ERC20(seller).approve(address(this), uint tokens);
    
    deposit(uint tokens) {
    // add the deposited tokens into the existing balance of the smart contract
    balances[msg.sender]+= tokens;

    // transfer the tokens from the sender to this contract
    ERC20(seller).transferFrom(msg.sender, arbiter, tokens);
    }
    
    // when funds are received from buyer, give tokens to buyer and money to seller
    emit Purchase(msg.sender, address(this).balance)
    
    ERC20(arbiter).transfer(msg.sender, balances[msg.sender]);
    seller.transfer(address(this).balance);
    
}
