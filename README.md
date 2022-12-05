# nft-football-worldcup-2022

## NFT Country Flags

> Mint a NFT with you guess: who will win the Football Worldcup 2022?

[Flags collection with guesses](https://testnets.opensea.io/collection/country-flags-9xogkhmxcl)

### Initial Metadata example

´´´
{
  "name": "Country Flags",
  "description": "Flags of countries",
  "image": "https://ipfs.io/ipfs/QmTv68Na9mYc4JtWmHeMup1M9iUcgEvUGRC823ghqJNjCu?filename=Brazil.svg",
  "attributes": [
    {"trait_type": "Guess", "value": "Brazil" }
  ]
}
´´´

### Update Winners

Create a smart contract which will check a Chainlink oracle and update the NFTs.

### Final Metadata

´´´
{
  "name": "Country Flags",
  "description": "Flags of countries",
  "image": "https://ipfs.io/ipfs/QmTv68Na9mYc4JtWmHeMup1M9iUcgEvUGRC823ghqJNjCu?filename=Brazil.svg",
  "attributes": [
    {"trait_type": "Guess", "value": "Brazil" },
    {"trait_type": "Winner", "value": "Brazil"},
    {"trait_type": "Result", "value": "Congrats! You are a winner"}
  ]
}
´´´

