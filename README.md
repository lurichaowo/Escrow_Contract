# Housing Smart Contract

## Group members:

-   Kevin: kevin.fncw@gmail.com
-   Jason C: jason.chen53@myhunter.cuny.edu

## Purpose of Contract:

With renting a apartments, it is important to ensure that both the renter and rentee keep their ends of the relationship. It is especially important to receive payments in a quick and timely manner when it is due, which is automatically done in this contract by having owners receive payments (monthly rent, security deposits, etc.) from their tenants. This contract has some helpful features for the owner and tenants relationship. For example, The tenants can request to leave, change tenantship, and pay rental fee. Owner can add a tenant, remove a tenant, and requests to pay rental fee. With so many important payments and payment deadlines to be aware of, a smart contract will ensure the security and efficiency in renting apartments/condos.

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
