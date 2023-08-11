// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./registration.sol";
import "./items.sol";
import "./utils.sol";

contract farmerprocessor is registration, items, utils {

    modifier verifyFarmer(string memory id) {
        require(msg.sender == transactions[id].sender);
        _;
    }

    modifier verifyProcessor(string memory id) {
        require(msg.sender == transactions[id].reciver);
        _;
    }

    modifier onlyProcessor() {
        require(!(bytes(Processor[msg.sender]).length == 0));
        _;
    }

    function buyItem(string memory ipfs, string memory id, address a) public onlyProcessor {
        if ((bytes(Farmer[a]).length == 0)) {
            revert("Farmer does not exist");
        }
        transactions[id].reciver = msg.sender;
        transactions[id].ipfs = ipfs;
        transactions[id].sender = a;
    }

    function confirmItem(
        string memory ipfs,
        string memory id,
        string memory ipfsF,
        string memory ipfsP,
        string[] memory ipfsI,
        string[] memory code,
        string memory itemType
    )
        public
        verifyFarmer(id)
    {
        uint arr_length = code.length;
        for (uint i = 0; i < arr_length; i++) {
            addItem(ipfsI[i], code[i],itemType);
        }
        updateProcessor(transactions[id].reciver, ipfsP);
        updateFarmer(ipfsF);
        transactions[id].ipfs = ipfs;
    }

    function updateProcessor(address a, string memory ipfs) internal {
        Processor[a] = ipfs;
    }

    function updateFarmer(string memory ipfs) internal {
        Farmer[msg.sender] = ipfs;
    }

    function shippingInitiated(string memory id, string memory ipfs) public verifyFarmer(id) {
        transactions[id].shipStatus = ipfs;
    }

    function shippingReceived(string memory id, string memory ipfs) public verifyProcessor(id) {
        transactions[id].shipStatus = ipfs;
    }

    function paymentInitiated(string memory id, string memory ipfs) public verifyProcessor(id) {
        transactions[id].payHash = ipfs;
    }

    function paymentReceived(string memory id, string memory ipfs) public verifyFarmer(id) {
        transactions[id].payHash = ipfs;
    }

}