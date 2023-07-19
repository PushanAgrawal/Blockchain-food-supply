pragma solidity >=0.4.22 <0.9.0;

import "./registration.sol";
import "./items.sol";
import "./utils.sol";

contract distributoretailer is registration, items, utils {

    modifier verifyDistributor(string memory id) {
        require(msg.sender == transactions[id].sender);
        _;
    }

    modifier verifyRetailer(string memory id) {
        require(msg.sender == transactions[id].reciver);
        _;
    }

    modifier onlyRetailer() {
        require(bytes(Retailer[msg.sender]).length == 0);
        _;
    }

    function buyItem(string memory ipfs, string memory id, address a) public onlyRetailer {
        if (!(bytes(Distributor[a]).length == 0)) {
            revert("Distributor does not exist");
        }
        transactions[id].reciver = msg.sender;
        transactions[id].ipfs = ipfs;
        transactions[id].sender = a;
    }

    function confirmItem(
        string memory ipfs,
        string memory id,
        string memory ipfsD,
        string memory ipfsR,
        string[] memory ipfsI,
        string[] memory code
    )
        public
        verifyDistributor(id)
    {
        uint arr_length = code.length;
        for (uint i = 0; i < arr_length; i++) {
            addItem(ipfsI[i], code[i]);
        }
        updateRetailer(transactions[id].reciver, ipfsR);
        updateDistributor(ipfsD);
        transactions[id].ipfs = ipfs;
    }

    function updateRetailer(address a, string memory ipfs) internal {
        Retailer[a] = ipfs;
    }

    function updateDistributor(string memory ipfs) internal {
        Distributor[msg.sender] = ipfs;
    }

    function shippingInitiated(string memory id, string memory ipfs) public verifyDistributor(id) {
        transactions[id].shipStatus = ipfs;
    }

    function shippingReceived(string memory id, string memory ipfs) public verifyRetailer(id) {
        transactions[id].shipStatus = ipfs;
    }

    function paymentInitiated(string memory id, string memory ipfs) public verifyRetailer(id) {
        transactions[id].payHash = ipfs;
    }

    function paymentReceived(string memory id, string memory ipfs) public verifyDistributor(id) {
        transactions[id].payHash = ipfs;
    }

}
