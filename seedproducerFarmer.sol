// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./registration.sol";

import "./utils.sol";
import "./items.sol";

contract seeproducerfarmer is registration,items, utils {

    
    event SeedsPurchaseOrderPlaced(string indexed SeedsPurchaseOrderID,address SeedsPurchaser,address SeedsSeller,string ipfs);
    event SeedsPurchaseOrderConfirmed(string SeedsPurchaseOrderID,status NEWSTatus);
    event SeedsOrderReceived(string SeedsPurchaseOrderID);


    
    modifier verifySeedproducer(string memory id) {
       require(msg.sender == transactions[id].sender);
       _;
    }
    modifier verifyFarmer(string memory id) {
       require(msg.sender == transactions[id].reciver);
       _;
    }
    modifier onlyFarmer() {
       require(!(bytes(Farmer[msg.sender]).length==0));
       _;
    }
    

    function buyItem(string memory ipfs, string memory id, address a) public onlyFarmer {
        if ((bytes(SeedProducer[a]).length==0)){
            revert("seedproducer dose not exists");

        }
        transactions[id].reciver=msg.sender;
        transactions[id].ipfs=ipfs ;
        transactions[id].sender=a;
        emit SeedsPurchaseOrderPlaced( id,msg.sender,a,ipfs);
    }
    
    function confirmItem(string memory ipfs, string memory id,string memory ipfsS,string memory ipfsR, string[] memory ipfsI, string[] memory code) public verifySeedproducer(id) {
        uint arr_length=code.length;
        for (uint i=0;i<arr_length; i++){
            addItem(ipfsI[i], code[i], "seed");
        }
        updateFarmer(transactions[id].reciver,ipfsR);
        updateSeedproducer(ipfsS);
        transactions[id].ipfs=ipfs; 
        emit SeedsPurchaseOrderConfirmed(id,status.Accepted);
    }

    function updateFarmer(address a,string memory ipfs) internal{
        Farmer[a]=ipfs;
    }
    function updateSeedproducer(string memory ipfs) internal{
        SeedProducer[msg.sender]=ipfs;
    }

    function shipingInitiated(string memory id, string memory ipfs) public verifySeedproducer(id) {
        transactions[id].shipStatus=ipfs;
        
    }
    function shipingRecived(string memory id, string memory ipfs) public verifyFarmer(id){
        transactions[id].shipStatus=ipfs;
        emit SeedsOrderReceived(id);
    }

    function payemntInitiated(string memory id, string memory ipfs) public verifyFarmer(id){
        transactions[id].payHash=ipfs;
    }

    function payeRecived(string memory id, string memory ipfs) public verifySeedproducer(id){
        transactions[id].payHash=ipfs;
    }




}