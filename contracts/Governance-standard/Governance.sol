//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "../../openzeppelin-contracts/contracts/governance/Governor.sol";
import "../../openzeppelin-contracts/contracts/governance/compatibility/GovernorCompatibilityBravo.sol";
import "../../openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol";
import "../../openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "../../openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol";

contract Governance is Governor, GovernorCompatibilityBravo, GovernorVotes, GovernorVotesQuorumFraction, GovernorTimelockControl {
	constructor (IVotes _token, TimelockController _timelock, string memory _name, uint Quorum)
		Governor(_name)
		GovernorVotes(_token)
		GovernorVotesQuorumFraction(Quorum)
		GovernorTimelockControl(_timelock)
	{}

	function votingDelay() 
		public 
		pure 
		override 
		returns(uint256)
	{
		return 6575; // 1 day
	}

	function votingPeriod() 
		public 
		pure 
		override 
		returns(uint256)
	{
		return 6575 * 7; // 7 day
	}

	function proposalThreshold() 
		public 
		pure 
		override 
		returns(uint256)
	{
		return 0;
	}

// The following are overrides required by solidity

	function state(uint256 proposalId)
		public
		view
		override(Governor, IGovernor, GovernorTimelockControl)
		returns(ProposalState)
	{
		return super.state(proposalId);
	}

	function propose(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, string memory description)
		public
		override(Governor, GovernorCompatibilityBravo, IGovernor)
		returns(uint256)
	{
		return super.propose(targets, values, calldatas, description);
	}

	function _execute(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
		internal
		override(Governor, GovernorTimelockControl)
	{
		super._execute(proposalId, targets, values, calldatas, descriptionHash);
	}

	function _cancel(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
		internal
		override(Governor, GovernorTimelockControl)
		returns(uint256)
	{
		return super._cancel(targets, values, calldatas, descriptionHash);
	}

	function _executor()
		internal
		view
		override(Governor, GovernorTimelockControl)
		returns(address)
	{
		return super._executor();
	}

	function supportsInterface(bytes4 interfaceId)
		public
		view
		override(Governor, IERC165, GovernorTimelockControl)
		returns(bool)
	{
		return super.supportsInterface(interfaceId);
	}

	function cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) public virtual override(IGovernor, Governor, GovernorCompatibilityBravo) returns (uint256) {
		return super.cancel(targets, values, calldatas, descriptionHash);
    }
} 