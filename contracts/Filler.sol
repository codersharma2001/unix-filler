// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Oracle.sol"; // Importing Oracle contract

interface IReactor {
    function validateOrder(bytes calldata order) external returns (bool);
    function reactorCallback(bytes calldata order) external;
}

contract SimpleFiller is Ownable {
    IReactor public reactor;
    address public oracle; // Address of the Oracle contract for API interaction

    constructor(address _reactor, address _oracle , address _owner) Ownable(_owner)  {
        reactor = IReactor(_reactor);
        oracle = _oracle;
    }

    function fetchOrderFromAPI() internal view returns (bytes memory) {
        // Use your Oracle contract to interact with the Uniswap API and get the order
        return Oracle(oracle).getUniswapOrder();
    }

    function fillOrder(address tokenIn, uint amountIn, address recipient) external onlyOwner {
        // Fetch order from the Uniswap API
        bytes memory order = fetchOrderFromAPI();

        // Ensure the order is valid
        require(reactor.validateOrder(order), "Invalid order");

        // Transfer the input tokens to this contract
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);

        // Approve the reactor to spend tokens
        IERC20(tokenIn).approve(address(reactor), amountIn);

        // Execute the trade
        reactor.reactorCallback(order);

       
    }
}
