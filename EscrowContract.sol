// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

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

    struct Seller {
    }

    struct Buyer{}

    struct Item{}

    /** Global Variables */
    Seller[] sellers; // list of sellers 
    Buyer[] buyers; // list of buyers
    Item[] items; // list of items on sale 

    //EVENTS
    /*event RentPayment(
        address indexed _from,
        bytes32 indexed _id,
        uint256 _value
    );*/
}
