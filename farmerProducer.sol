// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "registration.sol";
import "items.sol";

contract farmerprocessor is registration,items {

    struct tranc {
        string ipfs;
        address farmer;
        address processor;
        string shipStatus;
    }

    mapping(string=>tranc) transactions;
    
   

    modifier onlyFarmer(string memory id) {
       require(msg.sender == transactions[id].farmer);
       _;
    }
    modifier verifyprocessor(string memory id) {
       require(msg.sender == transactions[id].processor);
       _;
    }
    modifier onlyprocessor() {
       require(bytes(Processor[msg.sender]).length==0);
       _;
    }

    function shipingInitiated(string memory id) public onlyFarmer(id) {
        transactions[id].shipStatus="shipping initiated";
        
    }
    function shipingRecived(string memory id) public{
        transactions[id].shipStatus="recived";
    }

    function updateFarmer(string memory ipfs) public{
        Farmer[msg.sender]=ipfs;
    }
    function updateprocessor(address a,string memory ipfs) public{
        Farmer[a]=ipfs;
    }


    function buyWheat(string memory ipfs, string memory id, address a) public onlyprocessor {
        transactions[id].processor=msg.sender;
        transactions[id].ipfs=ipfs ;
        transactions[id].farmer=a;
    }
    function buyRice(string memory ipfs, string memory id, address a) public onlyprocessor {
        transactions[id].processor=msg.sender;
        transactions[id].ipfs=ipfs ;
        transactions[id].farmer=a;
    }
    function confirmRice(string memory ipfs, string memory id,string memory ipfsP,string memory ipfsF,string[] memory ipfsR, string[] memory code) public onlyFarmer(id) {
        uint arr_length=code.length;
        for (uint i=0;i<arr_length; i++){
            addRice(ipfsR[i], code[i]);
        }
        updateFarmer(ipfsF);
        updateprocessor(transactions[id].processor, ipfsP);
        transactions[id].ipfs=ipfs; 
    
    }
    function confirmWheat(string memory ipfs, string memory id,string memory ipfsP,string memory ipfsF, string[] memory ipfsW, string[] memory code) public onlyFarmer(id) {
        uint arr_length=code.length;
        for (uint i=0;i<arr_length; i++){
            addWheat(ipfsW[i], code[i]);
        }
        updateFarmer(ipfsF);
        updateprocessor(transactions[id].processor, ipfsP);
        transactions[id].ipfs=ipfs; 
    }
}