// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;

    event NewWave(address indexed from, uint256 timestamp, string message);

    constructor() payable {
        console.log("WavePortal constructed!");
    }

    /**
        Add a wave.
     */
    function wave(string memory _msg) public {
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30 seconds between waves!"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s waved with message %s", msg.sender, _msg);
        waves.push(Wave(msg.sender, _msg, block.timestamp));
        emit NewWave(msg.sender, block.timestamp, _msg);

        // Generate a PSEUDO random number in the range 100.
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) %
            100;
        console.log("Random # generated %s", randomNumber);

        // Set the generated random number as the seed for the next wave.
        seed = randomNumber;

        if (randomNumber < 10) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has"
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract");
        }
    }

    /**
        Gets the total amount of waves in the contract.
     */
    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves", totalWaves);
        return totalWaves;
    }

    /**
        Gets all the waves in the contract.
     */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
}
