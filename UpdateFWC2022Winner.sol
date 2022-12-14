//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

interface iFWC2022NFT {
    function closed() external view returns (bool);
    function finished() external view returns (bool);
    function updateWinner (uint tokenId, uint8 countryId) external;
    function updateWinnerRange (uint start, uint end, uint8 countryId) external;
    function countTokens() external view returns (uint);
    function countryIndex(string memory country) external view returns (uint);
}


/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * 
 * PLEASE DO NOT USE THIS CODE IN PRODUCTION.
 */
contract UpdateFWC2022Winner is ChainlinkClient {
  using Chainlink for Chainlink.Request;

  bytes32 private jobId;
  uint256 private fee;

  // multiple params returned in a single oracle response
  uint256 public game_id;   //Final match Game_id = 63  
  uint256 public away_score;
  uint256 public home_score;
  string public away_team;
  string public home_team;
  iFWC2022NFT public FWC2022NFT;

  event RequestWC2022Fulfilled(
    bytes32 indexed requestId,
    uint256 indexed game_id,
    uint256 away_score,
    uint256 home_score,
    string away_team,
    string home_team
  );

    /**
     * @notice Initialize the link token and target oracle
     * @dev The oracle address must be an Operator contract for multiword response
     *
     *
     * Gorli Testnet details:
     * Link Token: 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
     * Oracle: 0xCC79157eb46F5624204f47AB42b3906cAA40eaB7 (Chainlink DevRel)
     * jobId: 0d0e0822a8c64f51aa7924cd1fc5f5f2
     * This Job will be disabled 24h after the final game!
     *
     */
  constructor(address addressFWC2022NFT) {
    setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
    setChainlinkOracle(0xCC79157eb46F5624204f47AB42b3906cAA40eaB7);
    jobId = '0d0e0822a8c64f51aa7924cd1fc5f5f2';
    fee = 0.1 * 10**18; // (Varies by network and job)
    FWC2022NFT = iFWC2022NFT(addressFWC2022NFT);
  }


  /**
   * @notice Request mutiple parameters from the oracle in a single transaction
   */
  function requestGameResult(uint256 id)
    public
  {
    Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillMultipleParameters.selector);
        req.addUint("id", id);
        game_id=id;
        away_score=0;
        home_score=0;
        away_team="";
        home_team="";
        sendChainlinkRequest(req, fee);
  }

  /**
   * @notice Fulfillment function for multiple parameters in a single request
   * @dev This is called by the oracle. recordChainlinkFulfillment must be used.
   */
  function fulfillMultipleParameters(
    bytes32 requestId,
    uint256 _away_score,
    uint256 _home_score,
    string memory _away_team,
    string memory _home_team
  )
    public
    recordChainlinkFulfillment(requestId)
  {
    emit RequestWC2022Fulfilled(requestId, game_id, _away_score, _home_score, _away_team, _home_team);
    away_score=_away_score;
    home_score=_home_score;
    away_team=_away_team;
    home_team=_home_team;
  }

    function countryIndex(string memory country) public view returns (uint) {
        return FWC2022NFT.countryIndex(country);
    }

    function updateWinner(uint tokenId) public {
        string memory winner;
        uint8 winnerId;
        if (away_score > home_score)
            winner = away_team;
        else if (home_score > away_score)
            winner = home_team;
        winnerId = uint8(countryIndex(winner));
        FWC2022NFT.updateWinner(tokenId, winnerId);
    }

    function updateWinnerRange(uint start, uint end) public {

    }

  // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
}