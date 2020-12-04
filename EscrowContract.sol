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

    struct ArbToken{
        address owner; // owner of the tokens
        uint256 amtOfTokens; // amount of tokens 
    }

    // do we want Seller to hold array of tokens?
    struct Seller {
        address account_check; // account to check if item belongs to Seller 
        address payable account; // account of seller to send ether to 
    }

    struct Buyer{
        address account; // buyer account to send tokens to 
    }

    // still not too sure how the item is gonna work
    struct Item{
        uint256 item_number; // unique item number 
        ArbToken token; // token(s) to be put on sale
        uint256 price; // price of the token 
        Seller s; // seller obj (will contain payable addr of seller)
    }

    /** Global Variables */
    Seller[] sellers; // list of sellers 
    Buyer[] buyers; // list of buyers
    Item[] items; // list of items on sale 
    uint256 item_counter; // for unique item number 

    constructor(uint256 item_counter) {
        item_counter = 0; // initializing item counter
    }

    /** 
    * @dev Buyer requests to see what is being sold
    */
    function viewItems() public view returns (string){
        string list;
        if (items.length > 0){
            for (uint i = 0; i < items.length; i++){
                list = list + items[i].item_number;
                list = list + "\t";
                list = list + items[i].price;
                list = list + "\n";
            }
            return list;
        }
        else{
            return list;
        }
    }

    /** 
    * @dev Buyer enters item number of token, they want to buy
    * @param item_num number to identify which item they want to buy 
    * @param buyer address of buyer to transfer ownership of token
    */
    function buyItem(uint256 item_num, address buyer) public payable{
        uint itemNumToBuy;
        // find the item 
        for (uint i = 0; i < items.length; i++){
            if (items[i].item_number == item_num){
                itemNumToBuy = i;
            }
        }

        require(msg.value == items[itemNumToBuy].price, "Insufficient funds to allow purchase of item");

        items[itemNumToBuy].token.owner = buyer;
        items[itemNumToBuy].onSale = false;

        items[itemNumToBuy].s.account.transfer(msg.value);
    }

    /** 
    * @dev Seller wants to remove token(s) from list 
    * @param item_num number to identify which item they want to buy 
    * @param buyer address of buyer to transfer ownership of token
    */
    function removeItem(uint256 item_num, address seller) public {
        uint itemNumToRemove;
        // find the item 
        for (uint i = 0; i < items.length; i++){
            if (items[i].item_number == item_num){
                itemNumToRemove = i;
            }
        }

        require(msg.sender != address(items[itemNumToRemove].s.account_check), "Not authorized to remove sale of item");

        Item memory i = items[itemNumToRemove];
        items[itemNumToRemove] = items[items.length-1];
        items[items.length-1] = i;
        items.pop();
    }


    //EVENTS
    /*event RentPayment(
        address indexed _from,
        bytes32 indexed _id,
        uint256 _value
    );*/
}
