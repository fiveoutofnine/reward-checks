// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {
    FiveoutofnineRewardChecksArt as Art
} from "../utils/FiveoutofnineRewardChecksArt.sol";

/// @title Interface for {FiveoutofnineRewardChecks}
/// @author fiveoutofnine
interface IFiveoutofnineRewardChecks {
    // -------------------------------------------------------------------------
    // Structs
    // -------------------------------------------------------------------------

    /// @notice A struct containing the metadata for a reward check.
    /// @param theme The color theme of the reward check.
    /// @param recipient The address of the recipient of the reward check.
    /// @param blockNumber The block number the reward check was minted at.
    /// @param memo A memo on the reward check.
    struct Metadata {
        Art.Theme theme;
        address recipient;
        uint256 blockNumber;
        string memo;
    }

    // -------------------------------------------------------------------------
    // Errors
    // -------------------------------------------------------------------------

    /// @notice Emitted when the sender didn't supply enough funds.
    error InsufficientFunds();

    /// @notice Emitted when a token hasn't been minted.
    error TokenUnminted();

    /// @notice Reverts if the sender isn't the owner of the token.
    error Unauthorized();

    // -------------------------------------------------------------------------
    // Storage
    // -------------------------------------------------------------------------

    /// @notice The metadata for a given token ID.
    /// @param _id The token ID.
    /// @return theme The color theme of the reward check.
    /// @return recipient The address of the recipient of the reward check.
    /// @return blockNumber The block number the reward check was minted at.
    /// @return memo A memo on the reward check.
    function getMetadata(
        uint256 _id
    )
        external
        view
        returns (
            Art.Theme theme,
            address recipient,
            uint256 blockNumber,
            string memory memo
        );

    // -------------------------------------------------------------------------
    // Functions
    // -------------------------------------------------------------------------

    /// @notice Mints the next token to `_to`. Only callable by the contract
    /// owner. The owner must provide 5.5555555555555⋅10⁻⁵ ETH, which will be
    /// transferred to `_to`.
    /// @dev The ID of the token MUST automatically increment by 1 every time.
    /// @param _to The address to mint the token to.
    /// @param _memo An optional memo on the reward check.
    function mint(address _to, string memory _memo) external payable;

    // -------------------------------------------------------------------------
    // Metadata
    // -------------------------------------------------------------------------

    /// @notice Returns the contract URI for this contract.
    /// @return The contract URI for this contract.
    function contractURI() external view returns (string memory);
}
