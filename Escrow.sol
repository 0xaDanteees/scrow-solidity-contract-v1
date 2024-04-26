// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

contract Escrow {

    address public payer;
    address public payee;
    address public middleman;

    event Approved(uint256);

    constructor(address _middleman, address _payee) payable {
        payee= _payee;
        middleman= _middleman;
        payer=msg.sender;
    }

    modifier onlyMiddleman {
        require(msg.sender==middleman);
        _;
    }

    function approve() external onlyMiddleman {
        uint256 sentBalance = address(this).balance;

        (bool success, )=payee.call{value: address(this).balance}("");
        require(success, "Failed to send funds");

        emit Approved(sentBalance);
    }
}