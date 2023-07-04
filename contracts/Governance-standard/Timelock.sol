//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "../../openzeppelin-contracts/contracts/governance/TimelockController.sol";


contract Timelock is TimelockController {
  constructor(
    uint256 minDelay,
    address[] memory proposers,
    address[] memory executors
    ) TimelockController(minDelay, proposers, executors, msg.sender){}
}
