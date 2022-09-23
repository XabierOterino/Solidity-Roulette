const hre = require("hardhat");

function toEther(n){
  return hre.ethers.utils.parseUnits(n.toString(), "ether" )
}

async function main() {
 const Roulette = hre.ethers.getContractFactory("Roulette")
 const roulette = await Roulette.deploy(28)
 const [deployer , p1, p2] = await hre.ethers.getSigners()

 const deposits = toEther(0.5)

 setInterval(async()=>{
  const open = await roulette.betsOpen()
  console.log(`UPDATE: Bets ${open?"open":"closed"}`)
  if(!open){
    console.log("Rolling in 3...")
    console.log("Rolling in 2...")
    console.log("Rolling in 1...")
    console.log("Rolling")

  }
 },1000)
 
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
