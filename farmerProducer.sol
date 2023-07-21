// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./registration.sol";
import "./items.sol";
import "./utils.sol";

contract farmerprocessor is registration,items {


    event PurchaseOrderPlaced(string indexed PurchaseOrderID,address Purchaser,address Seller,string ipfs);
    event PurchaseOrderConfirmed(string PurchaseOrderID,status NEWSTatus);
    event OrderReceived(string PurchaseOrderID);

    struct tranc {
        string ipfs;
        address farmer;
        address processor;
        string shipStatus;
        string payHash;
    }

    

    mapping(string=>tranc) transactions;
    
   

    modifier verifyFarmer(string memory id) {
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

    function payemntInitiated(string memory id, string memory ipfs) public verifyprocessor(id){
        transactions[id].payHash=ipfs;
    }

    function payeRecived(string memory id, string memory ipfs) public verifyFarmer(id){
        transactions[id].payHash=ipfs;
    }


    function shipingInitiated(string memory id, string memory ipfs) public verifyFarmer(id) {
        transactions[id].shipStatus=ipfs;
        
    }
    function shipingRecived(string memory id, string memory ipfs) public verifyprocessor(id){
        transactions[id].shipStatus=ipfs;
        emit OrderReceived(id);
    }

    function updateFarmer(string memory ipfs) internal{
        Farmer[msg.sender]=ipfs;
    }
    function updateprocessor(address a,string memory ipfs) internal{
        Processor[a]=ipfs;
    }


    function buyItem(string memory ipfs, string memory id, address a) public onlyprocessor {
        transactions[id].processor=msg.sender;
        transactions[id].ipfs=ipfs ;
        transactions[id].farmer=a;
        emit PurchaseOrderPlaced( id,msg.sender,a,ipfs);
    }
    // function buyRice(string memory ipfs, string memory id, address a) public onlyprocessor {
    //     transactions[id].processor=msg.sender;
    //     transactions[id].ipfs=ipfs ;
    //     transactions[id].farmer=a;
    // }
    // function confirmRice(string memory ipfs, string memory id,string memory ipfsP,string memory ipfsF,string[] memory ipfsR, string[] memory code) public onlyFarmer(id) {
    //     uint arr_length=code.length;
    //     for (uint i=0;i<arr_length; i++){
    //         addRice(ipfsR[i], code[i]);
    //     }
    //     updateFarmer(ipfsF);
    //     updateprocessor(transactions[id].processor, ipfsP);
    //     transactions[id].ipfs= ipfs; 
    
    // }
    function confirmItem(string memory ipfs, string memory id,string memory ipfsP,string memory ipfsF, string[] memory ipfsW, string[] memory code, string memory itemType) public verifyFarmer(id) {
        uint arr_length=code.length;
        for (uint i=0;i<arr_length; i++){
            addItem(ipfsW[i], code[i], itemType);
        }
        updateFarmer(ipfsF);
        updateprocessor(transactions[id].processor, ipfsP);
        transactions[id].ipfs=ipfs; 
        emit PurchaseOrderConfirmed(id,status.Accepted);
    }
}