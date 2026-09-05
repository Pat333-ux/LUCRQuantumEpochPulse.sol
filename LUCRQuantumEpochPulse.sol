// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LUCRQuantumEpochPulse {
    address public governance;

    struct EpochPulse {
        uint256 blockNum;
        uint256 timestamp;
        bytes32 activatedEpochHash;
        bytes32 pulseHash;
    }

    mapping(uint256 => EpochPulse) public pulses;

    event EpochPulseGenerated(
        uint256 indexed blockNum,
        bytes32 pulseHash,
        uint256 timestamp
    );

    modifier onlyGovernance() {
        require(msg.sender == governance, "Not governance");
        _;
    }

    constructor() {
        governance = msg.sender;
    }

    function generatePulse(bytes32 activatedEpochHash)
        external
        onlyGovernance
        returns (bytes32)
    {
        bytes32 pulseHash = keccak256(
            abi.encodePacked(
                activatedEpochHash,
                block.number,
                block.timestamp,
                blockhash(block.number - 1)
            )
        );

        pulses[block.number] = EpochPulse({
            blockNum: block.number,
            timestamp: block.timestamp,
            activatedEpochHash: activatedEpochHash,
            pulseHash: pulseHash
        });

        emit EpochPulseGenerated(block.number, pulseHash, block.timestamp);
        return pulseHash;
    }
}
