const GovernanceToken = artifacts.require('GovernanceToken');
const Timelock = artifacts.require('Timelock');
const Governance = artifacts.require('Governance');
const Box = artifacts.require('Box');

const DELAY_PERIOD = 3600;
const ADDRESS_ZERO = "0x0000000000000000000000000000000000000000"

module.exports = async(deployer, network, accounts) => {
	/****************First Deployment****************/
	await deployer.deploy(GovernanceToken);
	const governanceToken = await GovernanceToken.deployed();
	
	console.log(accounts[0]);
	
	const tx = await governanceToken.delegate(accounts[0]);
	//await tx.wait();

	
	console.log(`Checkpoints ${await governanceToken.numCheckpoints(accounts[0])}`);


	/****************Second Deployment****************/
	const proposers = [];
	const executors = [];
	await deployer.deploy(Timelock, DELAY_PERIOD, proposers, executors);
	timelock = await Timelock.deployed();


	/****************Third Deployment****************/ 
	await deployer.deploy(Governance, governanceToken.address, timelock.address, "DAO", 100);
	const governor = await Governance.deployed();

	//Granting roles
	const proposerRole = await timelock.PROPOSER_ROLE();
	const executorRole = await timelock.EXECUTOR_ROLE();
	const adminRole = await timelock.TIMELOCK_ADMIN_ROLE();

	const proposerTx = await timelock.grantRole(proposerRole, governor.address);
	const executorTx = await timelock.grantRole(executorRole, ADDRESS_ZERO);
	const revokeTx = await timelock.revokeRole(adminRole, accounts[0]);

	/****************Fourth Deployment****************/
	await deployer.deploy(Box);
	const box = await Box.deployed();

	await box.transferOwnership(timelock.address);

	console.log("YOU DUN IT!!!!!");
}