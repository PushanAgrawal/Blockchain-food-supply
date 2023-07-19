pragma solidity >=0.4.22 <0.9.0;


contract utils {

    struct tranc {
        string ipfs;
        address sender;
        address reciver;
        string shipStatus;
        string payHash;
    }
    mapping(string=>tranc) transactions;
}