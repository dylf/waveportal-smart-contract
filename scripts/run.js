const { ethers } = require('hardhat');

async function main() {
  const [owner, randoPerson] = await ethers.getSigners();
  const waveContractFactory = await ethers.getContractFactory('WavePortal');
  const waveContract = await waveContractFactory.deploy({value: hre.ethers.utils.parseEther("0.1")});
  await waveContract.deployed();

  console.log("Contract address:", waveContract.address);
  
  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

  console.log('Contract deployed to:', waveContract.address);
  console.log('Contract deployed by:', owner.address);

  let waveCount;
  waveCount = await waveContract.getTotalWaves();

  let waveTxn = await waveContract.wave('Hello');
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();

  waveTxn = await waveContract.connect(randoPerson).wave('You did it');
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
