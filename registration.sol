pragma solidity =0.8.0;


contract registration{

    mapping(address=>bool) Farmer; 
    mapping(address=>bool) Processor; 
    mapping(address=>bool) Distributor;
    mapping(address=>bool) Retailer; 
    mapping(address=>bool) Consumer; 


    function addFarmer(address a) public {
        require(!Farmer[a],
        "Farmer exists already"
        );
        Farmer[a] = 1;
    }
    function addProcessor(address a) public {
         require(!Processor[a],
        "processor exists already"
        );
        Processor[a] = 1;
    }
    function addDistributor(address a) public {
         require(!Distributor[a],
        "Distributor exists already"
        );
        Distributor[a] = 1;
    }
    function addRetailer(address a) public {
         require(!Retailer[a],
        "Retailer exists already"
        );
        Retailer[a] = 1;
    }
    function addConsumer(address a) public {
         require(!Consumer[a],
        "Consumer exists already"
        );
        Consumer[a] = 1;
    }


    function farmerExists(address a) public returns(bool) {
        return Farmer[a]

    }
    function processorExists(address a) public returns(bool) {
        return Processor[a]

    }
    function distributorExists(address a) public returns(bool) {
        return Distributor[a]

    }
    function retailerExists(address a) public returns(bool) {
        return Retailer[a]

    }
    function consumerExists(address a) public returns(bool) {
        return Consumer[a]

    }
}



