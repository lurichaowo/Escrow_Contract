# Escrow Contract

## Group members:

-   Kevin W: kevin.fncw@gmail.com
-   Jason C: jason.chen53@myhunter.cuny.edu

## Purpose of Contract:

In this contract, we set up an escrow system by making the arbiter the smart contract itself. Tokens are given by the seller to the smart contract to sell. When a buyer wants to purchase these tokens, they send funds directly to the smart contract. When this occurs, it will cause the smart contract to transfer those tokens to the buyer, and also give the recieved funds to the seller.

### Note:

We were not able to include testing for our contract due to a number of reasons.
1) The external package we were using for ERC20 from zeppelin is tailored for solc 0.7.0, while truffle package is still runnning on 0.5.16.
2) When we downgrade the compiler to 0.5.16, it removes the ability to import packages via url (ie - from github)
3) We also tried to import zeppelin through a local package (both the lower version via truffle's dependency or a newer one manually from open-zeppelin's github repo)
   but the former failed due to truffle's lower solc compiler while the latter's import callback functions is not supported possibly due to the same reasons.
   For example , in ERC20.sol, it calls 
   > import "../..GSN/Context.sol";
  
   even though its all in the same local folder, it doesn't work.
   
The contract (from main branch) will have to imported into remix brower IDE to be compiled and deployed.

## Interface:
### Functions

name() returns the name of the token.

symbol() returns the token symbol.

totalSupply() returns the total amount of tokens in circulation.

tokenBalancesOf(address <i>_requester</i>) returns the total balance of tokens for a particular address.

etherBalancesOf(address <i>_requester</i>) returns the total balance of ether(in wei) for a particular address.

depositTokens(uint256 <i>_tokens</i>) uses ERC20 approve and transferFrom functions to deposit tokens into the smart contract and updates the token balance.

depositEther(uint256 <i>_etherAmount</i>) accepts incoming ether payment and updates the ether balance.

buyTokens(address <i>_seller</i>, address <i>_seller</i>, 
        address <i>_buyer</i>, 
        uint256 <i>_tokens</i>, 
        uint256 <i>_etherAmount</i>) allows a buyer to purchase tokens from a seller, updating the token and ether balances of both parties after the transaction.

withdrawTokens() allows a buyer to transfer their entire token balance into their own address.

### [Styling of Interface](https://solidity.readthedocs.io/en/v0.5.13/style-guide.html)
