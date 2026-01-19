// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test} from "forge-std/Test.sol";
import {FiveoutofnineRewardChecks} from "src/FiveoutofnineRewardChecks.sol";
import {
    IFiveoutofnineRewardChecks
} from "src/interfaces/IFiveoutofnineRewardChecks.sol";

/// @notice Unit tests for {FiveoutofnineRewardChecks}.
contract FiveoutofnineRewardChecksTest is Test {
    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice Address of fiveoutofnine.eth, the contract owner.
    address constant FIVEOUTOFNINE = 0xA85572Cd96f1643458f17340b6f0D6549Af482F5;

    /// @notice Reward amount for each check.
    /// @dev Equivalent to 5.5555555555555⋅10⁻⁵ ETH.
    uint256 constant REWARD_AMOUNT = 0.000_055_555_555_555_555 ether;

    // -------------------------------------------------------------------------
    // Immutable storage
    // -------------------------------------------------------------------------

    /// @notice Address of the recipient.
    address internal immutable recipient;

    /// @notice Address of the owner.
    address internal immutable owner;

    // -------------------------------------------------------------------------
    // Contracts
    // -------------------------------------------------------------------------

    /// @notice The instance of {FiveoutofnineRewardChecks} being tested.
    FiveoutofnineRewardChecks internal rewardChecks;

    // -------------------------------------------------------------------------
    // Setup
    // -------------------------------------------------------------------------

    /// @notice Sets and labels addresses for `recipient` and `owner`.
    constructor() {
        // Set addresses.
        recipient = makeAddr("recipient");
        owner = FIVEOUTOFNINE;
        // Label addresses.
        vm.label(recipient, "Recipient");
        vm.label(owner, "Owner (fiveoutofnine.eth)");
    }

    /// @notice Sets up the test environment by deploying an instance of
    /// {FiveoutofnineRewardChecks} and funding the test addresses.
    function setUp() public {
        // Deploy the contract.
        rewardChecks = new FiveoutofnineRewardChecks();
        vm.label(address(rewardChecks), "`FiveoutofnineRewardChecks`");

        // Fund test addresses.
        vm.deal(recipient, 100 ether);
        vm.deal(owner, 100 ether);
    }

    // -------------------------------------------------------------------------
    // `constructor`
    // -------------------------------------------------------------------------

    /// @notice Tests that the contract is deployed correctly.
    function test_constructor() public view {
        // Test that the contract is deployed correctly.
        assertEq(rewardChecks.owner(), FIVEOUTOFNINE);
        assertEq(rewardChecks.name(), "5/9 Reward Checks");
        assertEq(rewardChecks.symbol(), "5/9");
    }

    // -------------------------------------------------------------------------
    // `mint`
    // -------------------------------------------------------------------------

    /// @notice Tests that the `mint` function reverts when the minter is not
    /// the owner.
    /// @param _minter The address of the minter.
    function test_mint_MinterNotOwner_Reverts(address _minter) public {
        vm.assume(_minter != owner);
        vm.assume(_minter != address(0));
        vm.assume(_minter != address(rewardChecks));

        // Call the mint function as an invalid sender.
        vm.prank(_minter);
        vm.deal(_minter, REWARD_AMOUNT);
        vm.expectRevert("UNAUTHORIZED");
        rewardChecks.mint{value: REWARD_AMOUNT}(recipient);
    }

    /// @notice Tests that the `mint` function reverts when an incorrect amount
    /// of ETH is sent.
    /// @param _amount The amount of ETH sent.
    function test_mint_InsufficientFunds_Reverts(uint256 _amount) public {
        vm.assume(_amount != REWARD_AMOUNT);
        _amount = bound(_amount, 0, owner.balance);

        // Call the mint function with the incorrect amount of ETH.
        vm.prank(owner);
        vm.expectRevert(
            abi.encodeWithSelector(
                IFiveoutofnineRewardChecks.InsufficientFunds.selector
            )
        );
        rewardChecks.mint{value: _amount}(recipient);
    }

    /// @notice Tests that the `mint` function works correctly.
    function test_mint() public {
        uint256 ownerBalanceBefore = owner.balance;
        uint256 recipientBalanceBefore = recipient.balance;
        uint256 recipientNftBalanceBefore = rewardChecks.balanceOf(recipient);

        // Call the mint function.
        vm.prank(owner);
        rewardChecks.mint{value: REWARD_AMOUNT}(recipient);

        // Check storage and balances after.
        unchecked {
            assertEq(rewardChecks.ownerOf(1), recipient);
            assertEq(
                rewardChecks.balanceOf(recipient),
                recipientNftBalanceBefore + 1
            );
            assertEq(owner.balance, ownerBalanceBefore - REWARD_AMOUNT);
            assertEq(recipient.balance, recipientBalanceBefore + REWARD_AMOUNT);
        }
    }

    // -------------------------------------------------------------------------
    // `tokenURI`
    // -------------------------------------------------------------------------

    /// @notice Tests that the `tokenURI` function reverts when the token ID
    /// does not exist.
    /// @param _id The token ID.
    function test_tokenURI_TokenUnminted_Reverts(uint256 _id) public {
        // Call the tokenURI function with the unminted token ID.
        vm.expectRevert(
            abi.encodeWithSelector(
                IFiveoutofnineRewardChecks.TokenUnminted.selector
            )
        );
        rewardChecks.tokenURI(_id);
    }
}
