pragma solidity >=0.4.22 <0.9.0;

import "./registration.sol";
import "./items.sol";
import "./utils.sol";

contract seeproducerfarmer is registration,items, utils {

   

    
    modifier verifySeedproducer(string memory id) {
       require(msg.sender == transactions[id].sender);
       _;
    }
    modifier verifyFarmer(string memory id) {
       require(msg.sender == transactions[id].reciver);
       _;
    }
    modifier onlyFarmer() {
       require(bytes(Farmer[msg.sender]).length==0);
       _;
    }
    

    function buyItem(string memory ipfs, string memory id, address a) public onlyFarmer {
        if (!(bytes(SeedProducer[a]).length==0)){
            revert("seedproducer dose not exists");

        }
        transactions[id].reciver=msg.sender;
        transactions[id].ipfs=ipfs ;
        transactions[id].sender=a;
    }
    
    function confirmItem(string memory ipfs, string memory id,string memory ipfsS,string memory ipfsR, string[] memory ipfsI, string[] memory code) public verifySeedproducer(id) {
        uint arr_length=code.length;
        for (uint i=0;i<arr_length; i++){
            addItem(ipfsI[i], code[i]);
        }
        updateFarmer(transactions[id].reciver,ipfsR);
        updateSeedproducer(ipfsS);
        transactions[id].ipfs=ipfs; 
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
    }

    function payemntInitiated(string memory id, string memory ipfs) public verifyFarmer(id){
        transactions[id].payHash=ipfs;
    }

    function payeRecived(string memory id, string memory ipfs) public verifySeedproducer(id){
        transactions[id].payHash=ipfs;
    }




}
