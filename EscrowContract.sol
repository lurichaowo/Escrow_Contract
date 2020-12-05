// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.7/contracts/token/ERC20/ERC20.sol";
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

    enum paymentStatus {Pending, Completed}
    
    ERC20 public tokens;
    
    event ItemPosted(
        uint256 indexed _id,
        address indexed _seller,
        uint256 _amount,
        paymentStatus status
    );

    event ItemSold(
        uint256 indexed _id,
        address indexed _buyer,
        uint256 _amount,
        paymentStatus status
    );

    struct Item{
        uint256 _id; // unique item number 
        uint256 _amount; // # of tokens
        uint256 _price; // price of each token(s)
        address payable _seller;
    }

    // Global Variables
    Item[] items; // list of items on sale 
    uint256 _id_counter = 0; // for unique item number 


    /** 
    * @dev Seller calls function and sets up shop and deposit tokens onto arbitar 
    * @param _seller address of seller to be stored on item 
    * @param _amount amount of tokens to be sold 
    * @param _sell_price sell price of each token
    */
    function sellTokens(address payable _seller, uint _amount, uint256 _sell_price) public {
        // transfer the tokens from the sender to this contract
        ERC20(_seller).approve(address(this), _amount);
        ERC20(_seller).transferFrom(_seller, address(this), _amount);

        // create new item to be added to list of items[]
        Item memory i = Item(_id_counter, _amount, _sell_price, _seller);
        items.push(i);
        
        // event call 
        emit ItemPosted(_id_counter, _seller, _amount, paymentStatus.Pending);
        
        // increment _id_counter
        _id_counter++;
    }

    /** 
    * @dev Buyer requests to see what is being sold (will be displayed on console)
    */
    function viewItems() public{
        // parse through and print onto console
        if (items.length > 0){
            for (uint i = 0; i < items.length; i++){
                log2(
                    bytes32(items[i]._id),
                    bytes32(items[i]._amount),
                    bytes32(items[i]._price)
                );
            }
        }
    }

    /** 
    * @dev Buyer enters item number of token, they want to buy
    * @param _id number to identify which item they want to buy 
    * @param _buyer address of buyer to transfer ownership of token
    */
    function buyItem(uint256 _id, address payable _buyer) public payable{
        // find tokens associated with _id
        uint index; // index of item
        bool found; // if item actually exists 
        (index, found) = findItem(_id); // function to find item
        require(found == true, "Item is not found"); // check if item actually exits, else error msg
        
        Item memory itemToBeBought = items[index]; // item obj of item to be purchased
        
        require(msg.value >= itemToBeBought._price * itemToBeBought._amount, "Insufficient funds to allow purchase of item"); // check if buyer sent enough ether to buy tokens

        // return the change amount of ether sent
        if (msg.value > itemToBeBought._price * itemToBeBought._amount){
            uint diff = msg.value - itemToBeBought._price * itemToBeBought._amount;
            _buyer.transfer(diff);
        }
        
        // sends tokens to buyer
        ERC20(address(this)).transfer(_buyer, itemToBeBought._amount);

        // send ether to 
        itemToBeBought._seller.transfer(msg.value);
        
        // event call 
        emit ItemSold(_id_counter, _buyer, itemToBeBought._amount, paymentStatus.Completed);
    }

    /** 
    * @dev Seller wants to remove token(s) from list 
    * @param _id number to identify which item they want to remove 
    */
    function removeItem(uint256 _id) public {
        // find tokens associated with _id
        uint index; // index of item
        bool found; // if item actually exists 
        (index, found) = findItem(_id); // function to find item
        require(found == true, "Item is not found"); // check if item actually exits, else error msg
        
        Item memory itemToRemove = items[index]; // item obj to remove

        require(msg.sender == itemToRemove._seller, "Not authorized to remove sale of item"); // check if is actually seller of tokens

        ERC20(address(this)).transfer(itemToRemove._seller, itemToRemove._amount); // transfer tokens back to original seller
        
        // swap and pop item from array of items[]  
        items[index] = items[items.length-1];
        items[items.length-1] = itemToRemove;
        items.pop();
    }
    
    /** 
    * @dev To find and return the index in items[] of the item being looked for through item's _id
    * @param _id number to identify which item they want to find
    */
    function findItem(uint256 _id) public view returns (uint, bool){
        uint itemToFind;
        // find the item 
        for (uint i = 0; i < items.length; i++){
            if (items[i]._id == _id){
                return (itemToFind, true);
            }
        }
        return (0, false);
    }
}