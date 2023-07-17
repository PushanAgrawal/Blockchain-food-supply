// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract items {


    mapping(string=>string) item;
    


    
    function addItem(string memory ipfs, string memory code) public {
        item[code]=ipfs;        
    }

}