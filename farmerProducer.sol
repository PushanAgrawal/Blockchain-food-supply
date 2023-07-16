// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "registration.sol";
import "items.sol";

contract farmerProducer is registration,items {

    mapping(string=>string) transactions;

    function updateFarmer(string memory ipfs) public{
        Farmer[msg.sender]=ipfs;
    }
    function updateProducer(address a,string memory ipfs) public{
        Farmer[a]=ipfs;
    }


    function buyWheat(string memory ipfs, string memory id) public {
        transactions[id]=ipfs; 
    }
    function buyRice(string memory ipfs, string memory id) public {
        transactions[id]=ipfs; 
    }
    function confirmRice(string memory ipfs, string memory id, address a,string memory ipfsP,string memory ipfsF,string memory ipfsR, string memory code) public {
        updateFarmer(ipfsF);
        addRice(ipfsR, code);
        updateProducer(a, ipfsP);
        transactions[id]=ipfs; 
    }
    function confirmWheat(string memory ipfs, string memory id, address a,string memory ipfsP,string memory ipfsF, string memory ipfsW, string memory code) public {
        updateFarmer(ipfsF);
        addRice(ipfsW, code);
        updateProducer(a, ipfsP);
        transactions[id]=ipfs; 
    }
}