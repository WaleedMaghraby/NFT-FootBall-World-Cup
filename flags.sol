// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Flags is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;

    address public owner;
    address public admin;
    bool public finish;
    string public NFTName = "Country Flags";
    string public NFTDescription = "Flags of countries";
    

    //NFT
    Counters.Counter public tokenIdCounter;
    struct Country {
        string image;
        string name;
    }
    Country[] public countries; 

    struct Guess {
        uint8 index;
        string flag;
        string name;
    }
    Guess[] public guesses;

    constructor() ERC721(NFTName, "FLAG") {
        owner = msg.sender;
        admin = msg.sender;
        finish = false;
        initializeCountries();
        safeMint(msg.sender,1);
    }

    function initializeCountries() internal {
        string[4] memory countryFlags = [
            "https://ipfs.io/ipfs/QmbvybGQkmqGnEUQGmbtdZW9wgGRL8VrbSPwoBPxAdtPPd?filename=Argentina.svg",
            "https://ipfs.io/ipfs/QmTv68Na9mYc4JtWmHeMup1M9iUcgEvUGRC823ghqJNjCu?filename=Brazil.svg",
            "https://ipfs.io/ipfs/QmT3s29cVSXdLNDEN6gGxjAiCS31Q9jBHftV7JFWtdapAB?filename=France.svg",
            "https://ipfs.io/ipfs/QmdkXHvo9Bs3hKfLKE63aMV8HFAkjVyfenLK8PEJ2whQQK?filename=Netherlands.svg"
        ];
        string[4] memory countryNames = [
            "Argentina",
            "Brazil",
            "France",
            "Netherlands"
        ];
        for (uint i=0; i<countryFlags.length; i++) {
            countries.push(Country(countryFlags[i], countryNames[i]));
        }
    }

    function safeMint(address to, uint8 countryId) public notFinish {        
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

    function addCountry (string memory flag, string memory name) public onlyOwner {
        countries.push(Country(flag, name));
    }

    function updateTokenWinner (uint tokenId, uint8 countryId) public onlyAdmin {                
        require( (countryId >= 0) && (countryId < countries.length), "invalid countryId");
        require( tokenId < tokenIdCounter.current(), "invalid tokenId");
        //Require flag, name in countries
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

    function updateTokenWinnerRange (uint start, uint end, uint8 countryId) public onlyAdmin {
        uint tokenLimitId = tokenIdCounter.current();
        require (start < tokenLimitId, "start out of range");
        require (end < tokenLimitId, "end out of range");
        if (end == 0)
            end = tokenLimitId - 1;
        require (end >= start, "invalid start");
        for (uint i=start; i<=end; i++) {
            updateTokenWinner(i, countryId);
        }
    }

    function setAdmin(address _addressAdmin) public onlyOwner {
        admin = _addressAdmin;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    modifier notFinish() {
        require(finish == false);
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
