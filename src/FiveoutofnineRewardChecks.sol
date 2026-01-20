// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Owned} from "solmate/auth/Owned.sol";
import {Base64} from "solady/utils/Base64.sol";
import {LibString} from "solady/utils/LibString.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";

import {
    IFiveoutofnineRewardChecks
} from "./interfaces/IFiveoutofnineRewardChecks.sol";
import {
    FiveoutofnineRewardChecksArt as Art
} from "./utils/FiveoutofnineRewardChecksArt.sol";

/// @title ⁵⁄₉ Reward Checks
/// @author fiveoutofnine

/// @notice Reward checks of 5̅ ⋅ 10⁻⁵ ETH, awarded by ⁵⁄₉ for finding fixes,
/// errors, or making suggestions to their work.
contract FiveoutofnineRewardChecks is
    IFiveoutofnineRewardChecks,
    ERC721,
    Owned
{
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice Address of fiveoutofnine.eth, the contract owner.
    address constant FIVEOUTOFNINE = 0xA85572Cd96f1643458f17340b6f0D6549Af482F5;

    /// @notice Reward amount for each check.
    /// @dev Equivalent to 5.5555555555555⋅10⁻⁵ ETH.
    uint256 constant REWARD_AMOUNT = 0.000_055_555_555_555_555 ether;

    /// @notice Description of the collection.
    string constant COLLECTION_DESCRIPTION =
        unicode"Reward checks of 5̅ ⋅ 10⁻⁵ ETH, awarded by ⁵⁄₉ for finding fixes"
        unicode", errors, or making suggestions to their work.";

    // -------------------------------------------------------------------------
    // Storage
    // -------------------------------------------------------------------------

    /// @notice The next token ID to be minted.
    uint256 internal _nextTokenId = 1;

    /// @inheritdoc IFiveoutofnineRewardChecks
    mapping(uint256 => Metadata) public override getMetadata;

    // -------------------------------------------------------------------------
    // Constructor + functions
    // -------------------------------------------------------------------------

    constructor() ERC721(unicode"⁵⁄₉ Reward Checks", unicode"⁵⁄₉") Owned(FIVEOUTOFNINE) {}

    /// @inheritdoc IFiveoutofnineRewardChecks
    function mint(
        address _to,
        string memory _memo
    ) external payable override onlyOwner {
        // Revert if the sender didn't supply the correct amount of ETH.
        if (msg.value != REWARD_AMOUNT) revert InsufficientFunds();

        unchecked {
            _mint(_to, _nextTokenId);

            // Set the metadata for the token.
            getMetadata[_nextTokenId] = Metadata({
                theme: Art.Theme.GRAY,
                recipient: _to,
                blockNumber: block.number,
                memo: _memo
            });

            emit UpdateTokenTheme(_nextTokenId, Art.Theme.GRAY);
            emit UpdateTokenMemo(_nextTokenId, _memo);

            // Increment the next token ID.
            _nextTokenId++;
        }

        // Transfer the reward amount to `_to`.
        (bool success, ) = _to.call{value: REWARD_AMOUNT}("");
        require(success);
    }

    /// @inheritdoc IFiveoutofnineRewardChecks
    function setTokenMemo(
        uint256 _id,
        string memory _memo
    ) external override onlyOwner {
        // Revert if the token hasn't been minted.
        if (_ownerOf[_id] == address(0)) revert TokenUnminted();

        getMetadata[_id].memo = _memo;
        emit UpdateTokenMemo(_id, _memo);
    }

    /// @inheritdoc IFiveoutofnineRewardChecks
    function setTokenTheme(uint256 _id, Art.Theme _theme) external override {
        // Revert if the token hasn't been minted.
        if (_ownerOf[_id] == address(0)) revert TokenUnminted();
        // Revert if the sender isn't the owner of the token.
        if (_ownerOf[_id] != msg.sender) revert Unauthorized();

        getMetadata[_id].theme = _theme;
        emit UpdateTokenTheme(_id, _theme);
    }

    // -------------------------------------------------------------------------
    // ERC721Metadata
    // -------------------------------------------------------------------------

    /// @notice Returns the metadata URI for a given token ID.
    /// @dev Reverts if the token ID does not exist.
    /// @param _id The token ID.
    /// @return The metadata URI for the given token ID.
    function tokenURI(
        uint256 _id
    ) public view override returns (string memory) {
        // Revert if the token hasn't been minted.
        if (_ownerOf[_id] == address(0)) revert TokenUnminted();

        Metadata memory metadata = getMetadata[_id];
        (string memory attributes, string memory image) = Art.render({
            _id: _id,
            _theme: metadata.theme,
            _recipient: metadata.recipient,
            _blockNumber: metadata.blockNumber,
            _memo: bytes(metadata.memo).length > 0 ? metadata.memo : "N/A"
        });

        return
            string.concat(
                "data:application/json;base64,",
                Base64.encode(
                    abi.encodePacked(
                        unicode'{"name":"⁵⁄₉ Reward Check #',
                        _id.toString(),
                        '","description":"',
                        COLLECTION_DESCRIPTION,
                        '","image_data":"data:image/svg+xml;charset=utf-8;base64,',
                        Base64.encode(abi.encodePacked(image)),
                        '","attributes":',
                        attributes,
                        "}"
                    )
                )
            );
    }

    // -------------------------------------------------------------------------
    // Contract metadata
    // -------------------------------------------------------------------------

    /// @inheritdoc IFiveoutofnineRewardChecks
    function contractURI() external pure override returns (string memory) {
        return
            string.concat(
                "data:application/json;charset=utf-8;base64,",
                Base64.encode(
                    abi.encodePacked(
                        unicode'{"name":"⁵⁄₉ Reward Checks","description":"',
                        COLLECTION_DESCRIPTION,
                        '"}'
                    )
                )
            );
    }
}
