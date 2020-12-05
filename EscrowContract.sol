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
    
    enum paymentStatus {Pending, Completed}
    
    ERC20 public tokens;
    address payable public buyer;
    address payable public seller;
    
    mapping ( address => uint256 ) public balances;
    
    event Purchase(
        uint256 indexed _id,
        address indexed _seller,
        uint256 _amount,
        paymentStatus status
    );
    
    // seller giving arbiter(the smart contract) tokens they want to sell, through approval and deposit
    function sellTokens(uint256 _id, address payable _seller, uint256 _amount) public {
        ERC20(_seller).approve(address(this), uint tokens);
        emit Purchase(_id, _seller, _amount, paymentStatus.Pending);
    }
    
    
    function deposit(uint tokens) public {
        // add the deposited tokens into the existing balance of the smart contract
        balances[msg.sender] += tokens;
    
        // transfer the tokens from the sender to this contract
        ERC20(seller).transferFrom(msg.sender, arbiter, tokens);
    }
    
    function releaseFunds(uint _orderId) external {
        completePayment(_orderId, _buyer, _seller, PaymentStatus.Completed);
    }
    
    
    // when funds are received from buyer, give tokens to buyer and money to seller
    function completePayment(uint _id, address payable _buyer, address payable _seller PaymentStatus _status) private {
        require(_status == PaymentStatus.Pending);
        
        ERC20(address(this)).transfer(_buyer, balances[_buyer]);
        address(this).transfer(_seller, address(this).balance);

        emit Purchase(_id, _seller, _amount, paymentStatus.Completed);
    }
    
}
