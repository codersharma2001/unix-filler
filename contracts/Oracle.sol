// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Oracle {
    address public owner;
    uint256 public lastRequestId;
    mapping(uint256 => bytes) public apiResponses;

    event DataRequested(uint256 indexed requestId);
    event DataProvided(uint256 indexed requestId, bytes data);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function requestData() external onlyOwner returns (uint256) {
        lastRequestId++;
        emit DataRequested(lastRequestId);
        return lastRequestId;
    }

    function provideData(uint256 requestId, bytes calldata data) external onlyOwner {
        apiResponses[requestId] = data;
        emit DataProvided(requestId, data);
    }

    function getUniswapOrder() external view returns (bytes memory) {
        return apiResponses[lastRequestId];
    }
}
