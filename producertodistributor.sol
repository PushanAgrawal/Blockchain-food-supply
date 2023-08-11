// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./registration.sol";
import "./items.sol";
import "./utils.sol";

contract processordistributor is registration, items, utils {


    event PurchaseOrderPlaced(string indexed PurchaseOrderID,address Purchaser,address Seller,string ipfs);
    event PurchaseOrderConfirmed(string PurchaseOrderID,status NEWSTatus);
    event OrderReceived(string PurchaseOrderID);


    modifier verifyProcessor(string memory id) {
        require(msg.sender == transactions[id].sender);
        _;
    }

    modifier verifyDistributor(string memory id) {
        require(msg.sender == transactions[id].reciver);
        _;
    }

    modifier onlyDistributor() {
        require(!(bytes(Distributor[msg.sender]).length == 0));
        _;
    }

    function buyItem(string memory ipfs, string memory id, address a) public onlyDistributor {
        if ((bytes(Processor[a]).length == 0)) {
            revert("Processor does not exist");
        }
        transactions[id].reciver = msg.sender;
        transactions[id].ipfs = ipfs;
        transactions[id].sender = a;
        emit PurchaseOrderPlaced( id,msg.sender,a,ipfs);
    }

    function confirmItem(
        string memory ipfs,
        string memory id,
        string memory ipfsP,
        string memory ipfsD,
        string[] memory ipfsI,
        string[] memory code,
        string memory itemType
    )
        public
        verifyProcessor(id)
    {
        uint arr_length = code.length;
        for (uint i = 0; i < arr_length; i++) {
            addItem(ipfsI[i], code[i], itemType);
        }
        updateDistributor(transactions[id].reciver, ipfsD);
        updateProcessor(ipfsP);
        transactions[id].ipfs = ipfs;
        emit PurchaseOrderConfirmed(id,status.Accepted);
    }

    function updateDistributor(address a, string memory ipfs) internal {
        Distributor[a] = ipfs;
    }

    function updateProcessor(string memory ipfs) internal {
        Processor[msg.sender] = ipfs;
    }

    function shippingInitiated(string memory id, string memory ipfs) public verifyProcessor(id) {
        transactions[id].shipStatus = ipfs;
    }

    function shippingReceived(string memory id, string memory ipfs) public verifyDistributor(id) {
        transactions[id].shipStatus = ipfs;
        emit OrderReceived(id);
    }

    function paymentInitiated(string memory id, string memory ipfs) public verifyDistributor(id) {
        transactions[id].payHash = ipfs;
    }

    function paymentReceived(string memory id, string memory ipfs) public verifyProcessor(id) {
        transactions[id].payHash = ipfs;
    }

}
