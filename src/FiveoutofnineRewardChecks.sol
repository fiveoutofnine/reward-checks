// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { Owned } from "solmate/auth/Owned.sol";
import { Base64 } from "solady/utils/Base64.sol";
import { LibString } from "solady/utils/LibString.sol";
import { ERC721 } from "solmate/tokens/ERC721.sol";

import { IFiveoutofnineRewardChecks } from "./interfaces/IFiveoutofnineRewardChecks.sol";
import { FiveoutofnineRewardChecksArt } from "./utils/FiveoutofnineRewardChecksArt.sol";

/// @title 5/9 Reward Checks
/// @author fiveoutofnine
/// @notice Checks awarded by 5/9 for finding technical, typographical, or
/// historical errors, or making substantial suggestions for his publications.
contract FiveoutofnineRewardChecks is IFiveoutofnineRewardChecks, ERC721, Owned {
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice Address of fiveoutofnine.eth, the contract owner.
    address constant FIVEOUTOFNINE = 0xA85572Cd96f1643458f17340b6f0D6549Af482F5;

    /// @notice Reward amount for each check.
    /// @dev Equivalent to 5.5555555555555⋅10⁻⁵ ETH.
    uint256 constant REWARD_AMOUNT = 0.000055555555555555 ether;

    /// @notice Description of the collection.
    string constant COLLECTION_DESCRIPTION =
        "Checks awarded by 5/9 for finding technical, typographical, or histori"
        "cal errors, or making substantial suggestions for his publications.";

    // -------------------------------------------------------------------------
    // Storage
    // -------------------------------------------------------------------------

    /// @notice The next token ID to be minted.
    uint256 internal _nextTokenId = 1;

    // -------------------------------------------------------------------------
    // Constructor + functions
    // -------------------------------------------------------------------------

    constructor() ERC721("5/9 Reward Checks", "5/9") Owned(FIVEOUTOFNINE) { }

    /// @inheritdoc IFiveoutofnineRewardChecks
    function mint(address _to) external payable override onlyOwner {
        // Revert if the sender didn't supply the correct amount of ETH.
        if (msg.value != REWARD_AMOUNT) revert InsufficientFunds();

        unchecked {
            // Mint and increment the next token ID.
            _mint(_to, _nextTokenId++);
        }

        // Transfer the reward amount to `_to`.
        (bool success,) = _to.call{ value: REWARD_AMOUNT }("");
        require(success);
    }

    // -------------------------------------------------------------------------
    // ERC721Metadata
    // -------------------------------------------------------------------------

    /// @notice Returns the metadata URI for a given token ID.
    /// @dev Reverts if the token ID does not exist.
    /// @param _id The token ID.
    /// @return The metadata URI for the given token ID.
    function tokenURI(uint256 _id) public view override returns (string memory) {
        // Revert if the token hasn't been minted.
        if (_ownerOf[_id] == address(0)) revert TokenUnminted();

        (string memory svg, uint256 pattern) = FiveoutofnineRewardChecksArt.render({ _id: _id });

        return string.concat(
            "data:application/json;base64,",
            Base64.encode(
                abi.encodePacked(
                    '{"name":"5/9 Reward Check #',
                    _id.toString(),
                    '","description":"',
                    COLLECTION_DESCRIPTION,
                    '","image_data":"data:image/svg+xml;charset=utf-8;base64,',
                    Base64.encode(abi.encodePacked(svg)),
                    '","attributes":[{"trait_type":"Pattern","value":"',
                    (pattern >> 8) & 1 == 1 ? "1" : "0",
                    (pattern >> 7) & 1 == 1 ? "1" : "0",
                    (pattern >> 6) & 1 == 1 ? "1" : "0",
                    (pattern >> 5) & 1 == 1 ? "1" : "0",
                    (pattern >> 4) & 1 == 1 ? "1" : "0",
                    (pattern >> 3) & 1 == 1 ? "1" : "0",
                    (pattern >> 2) & 1 == 1 ? "1" : "0",
                    (pattern >> 1) & 1 == 1 ? "1" : "0",
                    (pattern) & 1 == 1 ? "1" : "0",
                    '"}]}'
                )
            )
        );
    }

    // -------------------------------------------------------------------------
    // Contract metadata
    // -------------------------------------------------------------------------

    /// @inheritdoc IFiveoutofnineRewardChecks
    function contractURI() external pure override returns (string memory) {
        return string.concat(
            "data:application/json;charset=utf-8;base64,",
            Base64.encode(
                abi.encodePacked(
                    '{"name":"5/9 Reward Checks","description":"', COLLECTION_DESCRIPTION, '"}'
                )
            )
        );
    }
}
