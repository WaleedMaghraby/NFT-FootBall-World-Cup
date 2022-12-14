// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract FWC2022NFT is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;

    address public owner;
    address public updater;
    address public finisher;
    bool public closed;
    bool public finished;
    string public NFTName = "Football World Cup 2022";
    string public NFTDescription = "Football World Cup 2022";    

    //NFT
    Counters.Counter public tokenIdCounter;
    struct Country {
        string image;
        string name;
    }
    Country[] public countries;
    mapping(string => uint) public countryIndex;

    struct Guess {
        uint8 index;
        string flag;
        string name;
    }
    Guess[] public guesses;

    constructor() ERC721(NFTName, "FWC22") {
        owner = msg.sender;
        updater = msg.sender;
        finisher = msg.sender;
        closed = false;
        initializeCountries();
    }

    function initializeCountries() internal {
        string[8] memory countryFlags = [
            "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/Argentina.png",
            "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/Brazil.png",
            "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/Croatia.png",
            "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/England.png",
            "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/France.png",
            "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/Morocco.png",
            "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/Netherlands.png",
            "https://ipfs.io/ipfs/QmT8FC7DeG4GvPBaFENkE4Dc2GU5rZVawzn5ucD31F4nhx/Portugal.png"
        ];
        string[8] memory countryNames = [
            "Argentina",
            "Brazil",
            "Croatia",
            "England",
            "France",
            "Morocco",
            "Netherlands",
            "Portugal"
        ];
        for (uint i=0; i<countryFlags.length; i++) {
            countries.push(Country(countryFlags[i], countryNames[i]));
            countryIndex[countryNames[i]] = i;
        }
    }

    function listCountries() public view returns (Country[] memory) {
        return countries;
    }

    function countTokens() public view returns (uint) {
        return tokenIdCounter.current();
    }


    function safeMint(address to, uint8 countryId) public notClosed {        
        require( (countryId >= 0) && (countryId < countries.length), "invalid countryId");
        //require only 1 per address?        

        guesses.push(Guess(countryId, countries[countryId].image, countries[countryId].name));

        uint256 tokenId = tokenIdCounter.current();
        string memory uri = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "', NFTName,'",',
                        '"description": "', NFTDescription,'",',
                        '"image": "', guesses[tokenId].flag, '",',
                        '"attributes": [',
                          '{',
                            '"trait_type": "Guess", ',
                            '"value": "', guesses[tokenId].name, '" }',
                            ']',
                        '}'
                    )
                )
            )
        );
        // Create token URI
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", uri)
        );
        tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, finalTokenURI);
    }

    function updateWinner (uint tokenId, uint8 countryId) public notFinished onlyUpdater {                
        require( (countryId >= 0) && (countryId < countries.length), "invalid countryId");
        require( tokenId < tokenIdCounter.current(), "invalid tokenId");

        string memory result;
        if (compareStrings(guesses[tokenId].name, countries[countryId].name)) {
            result = "Congrats! You are a winner";
        }           
        else {
            result = "Not this time";
        }            

        string memory uri = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "', NFTName, '",',
                        '"description": "', NFTDescription, '",',
                        '"image": "', countries[countryId].image, '",',
                        '"attributes": [',
                            '{"trait_type": "Guess", ',
                            '"value": "', guesses[tokenId].name, '"},',
                            '{"trait_type": "Winner", ',
                            '"value": "', countries[countryId].name, '"},',
                            '{"trait_type": "Result", ',
                            '"value": "', result, '"}',
                            ']'
                        '}'
                    )
                )
            )
        );
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", uri)
        );
        _setTokenURI(tokenId, finalTokenURI);
    }

    function updateWinnerRange (uint start, uint end, uint8 countryId) public notFinished onlyUpdater{
        uint tokenLimitId = tokenIdCounter.current();
        require (start < tokenLimitId, "start out of range");
        require (end < tokenLimitId, "end out of range");
        if (end == 0)
            end = tokenLimitId - 1;
        require (end >= start, "invalid start");
        for (uint i=start; i<=end; i++) {
            updateWinner(i, countryId);
        }
    }

    //The finisher is the contract which will stop the mint when the match starts
    function close() public onlyFinisher {
        closed = true;
    }

    //Finish all after update winners
    function finish() public onlyOwner {
        finished = true;
    }

    //The updater is the contract which will call Chainlink AnyAPI and get the result
    function setUpdater(address addressUpdater) public onlyOwner {
        updater = addressUpdater;
    }

    //The finisher is the contract which will stop the mint when the match starts
    function setFinisher(address addressFinisher) public onlyOwner {
        finisher = addressFinisher;
    }    

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyUpdater() {
        require(msg.sender == updater);
        _;
    }

    modifier onlyFinisher() {
        require(msg.sender == finisher);
        _;
    }    

    modifier notClosed() {
        require(closed == false);
        _;
    }    

    modifier notFinished() {
        require(finished == false);
        _;
    }

    // helper function to compare strings
    function compareStrings(string memory a, string memory b)
        public
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

}