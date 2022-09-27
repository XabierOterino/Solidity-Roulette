# Solidity Roulette

## Getting real randomness

One of the biggest challenges not only in blockchain but also in traditional programming is getting truly random numbers. In traditional programming, the computer doesn't generate random 100% numbers, that's why they are called "semi-random". That's because compurters processes are deterministic, whereas in real life it is imposible to do the same action in the exact same way twice. In blockchain programming, no source of randomness were implemented, to make it even more deterministic. This helps the consensus work. So, how do we get truly random numbers in blockchain in a decentralised way? The answer is using Chainlink oracles. Oracles connect the on-chain world with the off-chain world. In this way it can provide real random numbers.

## Routette

I made a simple roulette, and in order to make it gas efficient I removed number bets and even and odd bets. Players can only bet for colors. Also the roulette will be spinned auotomatically every x minutes using an admi account that call the contract when needed using a Nodejs script. Players will be charged a little fee when depositing their funds. 

## Getting started
```shell
npx hardhat run scripts/deploy.js
```
