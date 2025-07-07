// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title Interface for {FiveoutofnineRewardChecks}
/// @author fiveoutofnine
interface IFiveoutofnineRewardChecks {
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
    // Functions
    // -------------------------------------------------------------------------

    /// @notice Mints the next token to `_to`. Only callable by the contract
    /// owner. The owner must provide 5.5555555555555⋅10⁻⁵ ETH, which will be
    /// transferred to `_to`.
    /// @dev The ID of the token MUST automatically increment by 1 every time.
    /// @param _to The address to mint the token to.
    function mint(address _to) external payable;

    // -------------------------------------------------------------------------
    // Metadata
    // -------------------------------------------------------------------------

    /// @notice Returns the contract URI for this contract.
    /// @return The contract URI for this contract.
    function contractURI() external view returns (string memory);
}
