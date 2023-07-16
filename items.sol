// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract items {


    mapping(string=>string) wheat;
    mapping(string=>string) rice;


    function addWheat(string memory ipfs, string memory code) public {
        wheat[code]=ipfs;        
    }
    function addRice(string memory ipfs, string memory code) public {
        rice[code]=ipfs;        
    }

}