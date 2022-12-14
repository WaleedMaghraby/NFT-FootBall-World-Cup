## Would you like to have an NFT with your guess for the Football World Cup 2022?

Here is the [NFT collection with guesses](https://testnets.opensea.io/collection/football-world-cup-2022-v4)

> Mint a NFT with you guess: who will win the Football Worldcup 2022?

## How to do it

1. You need to have Goerli ETH
   1. [https://goerli-faucet.pk910.de/](https://goerli-faucet.pk910.de/)
   2. [https://goerlifaucet.com/](https://goerlifaucet.com/)
2. Go to the [NFT contract](https://goerli.etherscan.io/address/0x9c7987ea8e16cea36aa0c47051a2b758b6e1440a#writeContract)
3. Connect your wallet
4. SafeMint - Mint your dynamic NFT
Expand SafeMint - parameters:
- **To** - is your wallet, which you will have the NFT
- **countryId** - choose one id from the list bellow
 
1. Country list id (starts on 0)

| id | Country |
| -- | ------- |
| 0 | Argentina |
| 1 | Brazil |
| 2 | Croatia |
| 3 | England |
| 4 | France |
| 5 | Morocco |
| 6 | Netherlands |
| 7 | Portugal |

6. See your NFT on OpenSea collection
[world-cup-2022](https://testnets.opensea.io/collection/football-world-cup-2022-v4)

> It will be updated after the final match using Chainlink AnyAPI :)

## How to create your own version

### Requirements

1. Install a browser wallet, like [Metamask](https://metamask.io/)
2. Selected the Goerli network in theweb wallet.
3. Have some Goerli ETH
4. Go to [Remix](https://remix.ethereum.org/)

### Creating the NFT smart contract

1. Click on the second button on the left side - file explorer
2. Click on the button **create a new file**

File name: **FWC2022NFT.sol**

Copy and paste the smart contract [FWC2022NFT.sol](FWC2022NFT.sol)

### Compile

1. On Remix, on the left side, locate the button: **Solidity Compiler**.
2. It is useful to enable the *Auto compile* option.
3. Or click the button **compile**.

### Deploy on Goerli testnet

1. On Remix, on the left side, locate the button: **Deploy and run transactions**.
2. Under **Environment**, selecte the **Injected provider** option.
3. In the dropbox, choose the contract **FWC2022NFT**.
4. Click the button **Deploy**.

It will open a popup window on the web wallet,
to confirm the transaction set up by Remix to publish the smart contract.

Click **confirm / submit**.

## Mint your first NFT

After the smart contract is published using Remix,
we can see your instance in the left panel, at the bottom of **deploy and run transactions**.

1. Go to the section **deployed contracts**, locate your contract and click the symbol **>** to expand it.

2. Locate the button **SafeMint** and expand it too

3. Fill the parameters:
- **To** - is your wallet, which you will have the NFT
- **countryId** - choose one id from the list bellow

4. Click the button **transact**.

## Smart contract address

Copy the address of your smart contract and save it to use it later.

It is located in the right side of your deployed contract, click the copy icon.

## View your colection on [OpenSea](https://opensea.io/)

Go to [OpenSea Testnets](https://testnets.opensea.io/)

Paste the contract address in the search field and locate it

> You must mint an NFT first, and maybe wait a minute to be sure that OpenSea will index it.

Invite your friends to guess the winner :)


# How to update the winner

The idea is to create a smart contract which will check a Chainlink oracle and update the NFTs.

We will create another smart contract which will update the NFT with the winner, after the final match, using Chainlink AnyAPI to get the result.

I used this [free API](https://github.com/raminmr/free-api-worldcup2022) to get the result.

### Requirements

In addition to the requirements already listed

5. Have some LINK tokens, get it on the [Chainlink Faucet](https://faucets.chain.link/)
6. Add the LINK token on Metamask: address 0x326C977E6efc84E512bB9C30f76E30c160eD06FB

### Creating the *winner update* smart contract

1. Click on the second button on the left side - file explorer.
2. Click on the button **create a new file**.

File name: **UpdateFWC2022Winner.sol**

Copy and paste the smart contract [UpdateFWC2022Winner.sol](UpdateFWC2022Winner.sol)

### Deploy on Goerli testnet

1. On Remix, on the left side, locate the button: **Deploy and run transactions**.
2. Under **Environment**, selecte the **Injected provider** option.
3. In the dropbox, choose the contract **UpdateFWC2022Winner**.
4. Fill the parameter *addressFWC2022NFT*, which is the address of your NFT collection already deployed.
5. Click the button **Deploy**.

### Fund your contract

Send 1 LINK to your *UpdateFWC2022Winner* contract:

1. Go to Metamask
2. Select the LINK token
3. Click Send
4. Paste the address of the *UpdateFWC2022Winner* contract
5. 1 LINK
6. Confirm the transaction

### Allow the *UpdateFWC2022Winner* contract update the NFT.

1. Go to the contract **FWC2022NFT**
2. Call the function SetUpdater
3. Parameter: address of *UpdateFWC2022Winner* contract

### Get the result

1. Go to the *UpdateFWC2022Winner* contract.
2. Call the function RequestGameResult using the parameter 63 (this is the id for the final match).   
3. Wait some seconds to the Chainlink ANYAPI get the result and fill the results for you.
4. Check the results:
- away_score
- away_team
- home_score
- home_team

You can try the results of other matches to test it.

### Update the NFT collection

You can choose to update a NFT range or only one NFT in the collection

- updateWinner
  - parameter tokenId
- updateWinnerRange
  - parameters start (initial tokenId) and end (final tokenId)

## Using Chainlink Automation

To Do: create a new contract using Chainlink Automation to update the winner 1h after the final match ends.

## Some notes

The images are stored on IPFS using [Piñata](https://www.pinata.cloud/).

### Initial Metadata example

This is the initial metadata used to list the NFT on OpenSea, for example, for the guess *Brazil*.

```
{
  "name": "Football World Cup 2022",
  "description": "Football World Cup 2022",
  "image": "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/Brazil.png",
  "attributes": [
    {"trait_type": "Guess", "value": "Brazil" }
  ]
}
```

### Final Metadata

Imagine that you guess Brazil, but Argentina won.

This is the result:

```
{
  "name": "Football World Cup 2022",
  "description": "Football World Cup 2022",
  "image": "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/Brazil.png",
  "attributes": [
    {"trait_type": "Guess", "value": "Brazil" },
    {"trait_type": "Winner", "value": "Argentina"},
    {"trait_type": "Result", "value": "Next time"}
  ]
}
```

But if your guess was Argentina...

```
{
  "name": "Football World Cup 2022",
  "description": "Football World Cup 2022",
  "image": "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/Brazil.png",
  "attributes": [
    {"trait_type": "Guess", "value": "Argentina" },
    {"trait_type": "Winner", "value": "Argentina"},
    {"trait_type": "Result", "value": "Congrats! You are a winner"}
  ]
}
```


