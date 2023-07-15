// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArtNFT {
    uint256 public constant canvasSize = 10;

    uint256 private _tokenIds = 0;
    mapping (uint256 => address) private _tokenOwners;
    mapping (address => uint256) private _ownedTokensCount;
    mapping (uint256 => uint256[canvasSize][canvasSize]) private _tokenData;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function createArt() public returns (uint256) {
        _tokenIds++;

        uint256 newItemId = _tokenIds;
        _mint(msg.sender, newItemId);

        // Set each pixel to a random color
        for (uint256 i = 0; i < canvasSize; i++) {
            for (uint256 j = 0; j < canvasSize; j++) {
                _tokenData[newItemId][i][j] = _randomColor();
            }
        }

        return newItemId;
    }

    function getPixel(uint256 tokenId, uint256 x, uint256 y) public view returns (uint256) {
        require(_exists(tokenId), "ERC721: URI query for nonexistent token");
        require(x < canvasSize && y < canvasSize, "Pixel out of bounds");

        return _tokenData[tokenId][x][y];
    }

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _tokenOwners[tokenId] = to;
        _ownedTokensCount[to]++;

        emit Transfer(address(0), to, tokenId);
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _tokenOwners[tokenId] != address(0);
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");

        return owner;
    }

    function _randomColor() private view returns (uint256) {
        // This is a very basic way to generate a random color and it's not truly random.
        // For a more secure and reliable way, consider using a verifiable random function (VRF)
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 0xFFFFFF;
    }
}
