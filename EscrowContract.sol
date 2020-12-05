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

    enum paymentStatus {Pending, Completed}
    
    ERC20 public tokens;
    
    event ItemPosted(
        uint256 indexed _id,
        address indexed _seller,
        uint256 _amount,
        paymentStatus status
    );

    event sold(
        uint256 indexed _id,
        address indexed _buyer,
        uint256 _amount,
        paymentStatus status
    );

    struct Item{
        uint256 indexed _id; // unique item number 
        uint256 _amount; // # of tokens
        uint256 _price; // price of the token(s)
        address payable _seller;
    }

    /** Global Variables */
    Item[] items; // list of items on sale 
    uint256 _id_counter; // for unique item number 

    constructor(uint256 _id_counter) {
        _id_counter = 0; // initializing item counter
    }

    /** Set up shop and deposit tokens onto arbitar */
    // seller giving arbiter(the smart contract) tokens they want to sell, through approval and deposit
    /** Called by seller to post tokens */
    function sellTokens(address payable _seller, uint _amount, uint256 _sell_price) public {
        ERC20(_seller).approve(address(this), _amount);
        // transfer the tokens from the sender to this contract
        ERC20(_seller).transferFrom(_seller, address(this), _amount);

        Item memory i = Item(_id_counter, amount, _sell_price);
        items.push(i);

        emit Purchase(_id, _seller, _amount, paymentStatus.Pending);
    }

    /** 
    * @dev Buyer requests to see what is being sold
    */
    function viewItems() public view returns (string){
        string list;
        if (items.length > 0){
            for (uint i = 0; i < items.length; i++){
                list = list + items[i]._id;
                list = list + "\t";
                list = list + items[i].amount;
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
    function buyItem(uint256 _id, address payable buyer) public payable{
        require(msg.value >= items[itemNumToBuy].price, "Insufficient funds to allow purchase of item");

        /** return the change amount of ether sent  */

        ERC20(address(this)).transfer(_buyer, balances[_buyer]);

        /** find token to send to buyer based on _id */
        

        /** get seller address to send ether to */

        items[itemNumToBuy].s.account.transfer(msg.value);
    }

    function findItem(uint256 _id) returns (uint){
        uint itemToFind;
        // find the item 
        for (uint i = 0; i < items.length; i++){
            if (items[i]._id == _id){
                return itemToFind;
            }
        }
        return;
    }


    function releaseFunds(uint _orderId) external {
        completePayment(_orderId, collectionAddress, PaymentStatus.Completed);
    }
    
    
    // when funds are received from buyer, give tokens to buyer and money to seller
    function completePayment(uint _id, address payable _buyer, address payable _seller PaymentStatus _status) private {
        require(_status == PaymentStatus.Pending);
        
        ERC20(address(this)).transfer(_buyer, balances[_buyer]);
        ERC20(address(this)).transfer(_seller, address(this).balance);

        emit Purchase(_id, _seller, _amount, paymentStatus.Completed);
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
