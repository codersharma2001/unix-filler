const hre = require("hardhat");
// const ethers = require("ethers");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log(
      "Deploying contracts with the account:",
      deployer.address
  );
  // const balance = await hre.ethers.provider.getBalance(deployer.address);
  // console.log("Account balance:", hre.ethers.utils.formatUnits(balance.toString()));
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });