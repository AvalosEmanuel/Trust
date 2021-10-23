// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

/**
 * @title Trust
 * @dev This is a simple version of a contract to release money to a child at the age of majority.
 * I will keep it basic in this first coding and then it will get more complex and scalable .. 
 */
contract Trust {
    address public kid; //Address of the child who will receive the money.
    uint public maturity; //Control age to receive it (be of legal age).
    
   /**
    * @dev Construction company where we indicate that it is a contract that is going to make a payment.
    * @param _kid creditor child address..
    * @param _timeToMaturity time to collect..
    */
    constructor(address _kid, uint _timeToMaturity) payable {
        kid = _kid;
        maturity = block.timestamp + _timeToMaturity;
    }
    
   /**
    * @dev Function through which we send the funds.
    */
    function withdraw() external {
        require(block.timestamp >= maturity, 'to early');
        require(msg.sender == kid, 'only kid can withdraw');
        payable (msg.sender).transfer(address(this).balance); 
    }
}