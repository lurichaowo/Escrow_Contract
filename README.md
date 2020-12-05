# Escrow Contract

## Group members:

-   Kevin: kevin.fncw@gmail.com
-   Jason C: jason.chen53@myhunter.cuny.edu

## Purpose of Contract:

In this contract, we set up an escrow system by making the arbiter the smart contract itself. Tokens are given by the seller to the smart contract to sell. When a buyer wants to purchase these tokens, they send funds directly to the smart contract. When this occurs, it will cause the smart contract to transfer those tokens to the buyer, and also give the recieved funds to the seller.

### [Styling of Interface](https://solidity.readthedocs.io/en/v0.5.13/style-guide.html)

# New stuff

1) seller contacts arbiter 
    -"I want to set up shop"
    -gives payable addr 
    -puts sellable tokens on arbiter

2) buyer contacts arbiter to see what is on sale 
    - info will be displayed (unique id or item #, name, cost)
    - call a function with parameters(unique id # or item number)

3) when arbiter has received funds from buyer
    - event is called to send token associated with unique # to buyer 
    - another event will be called to send the ether to seller 

4) if seller wants to take token off of arbiter
    - if buyer buys at same time seller takes off token from shop
        - seller getting back token gets priority 
        - buyer will receive ether back and an error message
    - else 
        - seller just gets token back 
