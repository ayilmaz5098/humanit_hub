async function main() {
  console.log(`Preparing deployment...\n`)
  
  // Fetch contract to deploy


  const Token = await ethers.getContractFactory('Token')
  const Governor = await ethers.getContractFactory('Governor')
  const Treasury = await ethers.getContractFactory('Treasury')
  const Timelock = await ethers.getContractFactory('Timelock')
  // Fetch accounts
 // Fetch accounts

 // Deploy contracts
 const dapp = await Token.deploy('DECENTRALIZED App', 'DAPP', '1000000')
 await dapp.deployed()
 console.log(`DAPP Deployed to: ${dapp.address}`)

 const mETH = await Token.deploy('mETH', 'mETH', '1000000')
 await mETH.deployed()
 console.log(`mETH Deployed to: ${mETH.address}`)

 const mDAI = await Token.deploy('mDAI', 'mDAI', '1000000')
 await mDAI.deployed()
 console.log(`mDAI Deployed to: ${mDAI.address}`)


  const treasury = await Treasury.deploy()
  await treasury.deployed()
  console.log(`Treasuty Deployed to: ${treasury.address}`)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
