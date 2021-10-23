// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

/**
 * @title TrustOptimized
 * @dev It is an optimized version of a contract to deliver money to children who reach the age of majority, it provides greater security.
 */
contract Trust {

   /**
    *@dev Structure of the young creditor..
    */
    struct Kid {
        uint amount; //Amount to receive.
        uint maturity; 
        bool paid; // If it is already paid.
    }
    
   /**
    *@dev By placing the data in a mapping allows us to have several children entered in it.
    */
    mapping(address => Kid) public kids;
    address public admin; //The only one authorized to enter the beneficiaries.
    
   /**
    *@dev Whoever calls the contract for the first time is assigned as admin.
    */
    constructor() {
        admin = msg.sender;
    }
    
   /**
    *@dev Function that creates the child's struct.
    *@param _kid creditor child address..
    *@param _timeToMaturity time to collect..
    */
    function addKid(address _kid, uint _timeToMaturity) external payable {
        require(msg.sender == admin, 'only admin'); //It requires the caller of the function to be the admin.
        require(kids[msg.sender].amount == 0,'kid already exist'); //It certifies that the entered address has not been created previously.
        kids[_kid] = Kid(msg.value, block.timestamp + _timeToMaturity, false); // We load the values into the child's struct.
    }
    
   /**
    * @dev Function through which we send the funds.
    */
    function withdraw() external {
        Kid storage kid = kids[msg.sender];
        require(kid.maturity <= block.timestamp, 'too early'); //Certifies the age of majority.
        require(kid.amount > 0, 'only kid can withdraw'); //It certifies that the creditor is the one who calls the function.
        require(kid.paid == false, 'paid already'); // Certify that the money has not been previously paid.
        kid.paid = true; // we indicate that payment has been made.
        payable(msg.sender).transfer(kid.amount); // It is paid according to the corresponding amount
    }
}