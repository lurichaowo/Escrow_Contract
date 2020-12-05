# Escrow Smart Contract

## Group members:

-   Kevin: kevin.fncw@gmail.com
-   Jason C: jason.chen53@myhunter.cuny.edu

## Purpose of Contract:

When transacting there is always the inherent risk of failure of one party to comply with the agreed on end of the bargain and the privacy concern with having personal information exposed during such transactions. The seller failing to deliver the promised goods or the buyer failing to properly transfer funds to the seller's account. One such instance is the buying and selling of tokens. 

This contract was created to help alleviate those risks. By having the contract as an arbiter, the seller would deposit their tokens into the contract to list their tokens at a given sell price. Buyers can then view the listings of tokens from various sellers and have choose which ones they want to buy. When a listing is sold, the buyer would have to transfer the right amount to the contract which would then transfer the funds directly to the seller. By acting as the middleman, the contract can transfer the funds and goods to their corresponding owners without them ever knowing who sold or bought the tokens.

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
