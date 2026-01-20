// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test} from "forge-std/Test.sol";
import {FiveoutofnineRewardChecks} from "src/FiveoutofnineRewardChecks.sol";
import {
    IFiveoutofnineRewardChecks
} from "src/interfaces/IFiveoutofnineRewardChecks.sol";
import {
    FiveoutofnineRewardChecksArt as Art
} from "src/utils/FiveoutofnineRewardChecksArt.sol";

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
    // Events
    // -------------------------------------------------------------------------

    /// @notice Emitted when a token's memo is updated.
    /// @param id The token ID.
    /// @param memo The new memo.
    event UpdateTokenMemo(uint256 indexed id, string memo);

    /// @notice Emitted when a token's theme is updated.
    /// @param id The token ID.
    /// @param theme The new theme.
    event UpdateTokenTheme(uint256 indexed id, Art.Theme theme);

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
        assertEq(rewardChecks.name(), unicode"⁵⁄₉ Reward Checks");
        assertEq(rewardChecks.symbol(), unicode"⁵⁄₉");
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
        rewardChecks.mint{value: REWARD_AMOUNT}(recipient, "");
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
        rewardChecks.mint{value: _amount}(recipient, "");
    }

    /// @notice Tests that the `mint` function works correctly.
    function test_mint() public {
        uint256 ownerBalanceBefore = owner.balance;
        uint256 recipientBalanceBefore = recipient.balance;
        uint256 recipientNftBalanceBefore = rewardChecks.balanceOf(recipient);

        // Call the mint function and check events.
        vm.expectEmit(true, false, false, true);
        emit UpdateTokenTheme(1, Art.Theme.GRAY);
        vm.expectEmit(true, false, false, true);
        emit UpdateTokenMemo(1, "test memo");
        vm.prank(owner);
        rewardChecks.mint{value: REWARD_AMOUNT}(recipient, "test memo");

        // Check storage and balances after.
        unchecked {
            (
                Art.Theme theme,
                address rewardRecipient,
                uint256 blockNumber,
                string memory memo
            ) = rewardChecks.getMetadata(1);
            assertEq(rewardRecipient, recipient);
            assertEq(uint256(theme), uint256(Art.Theme.GRAY));
            assertEq(blockNumber, block.number);
            assertEq(memo, "test memo");
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
    // `setTokenMemo`
    // -------------------------------------------------------------------------

    /// @notice Tests that the `setTokenMemo` function reverts when the caller
    /// is not the contract owner.
    /// @param _caller The address of the caller.
    function test_setTokenMemo_CallerNotOwner_Reverts(address _caller) public {
        vm.assume(_caller != owner);

        // Mint a token first.
        vm.prank(owner);
        rewardChecks.mint{value: REWARD_AMOUNT}(recipient, "");

        // Call the setTokenMemo function as an invalid sender.
        vm.prank(_caller);
        vm.expectRevert("UNAUTHORIZED");
        rewardChecks.setTokenMemo(1, "new memo");
    }

    /// @notice Tests that the `setTokenMemo` function reverts when the token
    /// hasn't been minted.
    /// @param _id The token ID.
    function test_setTokenMemo_TokenUnminted_Reverts(uint256 _id) public {
        // Call the setTokenMemo function with an unminted token ID.
        vm.prank(owner);
        vm.expectRevert(
            abi.encodeWithSelector(
                IFiveoutofnineRewardChecks.TokenUnminted.selector
            )
        );
        rewardChecks.setTokenMemo(_id, "new memo");
    }

    /// @notice Tests that the `setTokenMemo` function works correctly.
    function test_setTokenMemo() public {
        // Mint a token first.
        vm.prank(owner);
        rewardChecks.mint{value: REWARD_AMOUNT}(recipient, "original memo");

        // Verify original memo.
        (, , , string memory memo) = rewardChecks.getMetadata(1);
        assertEq(memo, "original memo");

        // Set a new memo and check event.
        vm.expectEmit(true, false, false, true);
        emit UpdateTokenMemo(1, "updated memo");
        vm.prank(owner);
        rewardChecks.setTokenMemo(1, "updated memo");

        // Verify the memo was updated.
        (, , , memo) = rewardChecks.getMetadata(1);
        assertEq(memo, "updated memo");
    }

    // -------------------------------------------------------------------------
    // `setTokenTheme`
    // -------------------------------------------------------------------------

    /// @notice Tests that the `setTokenTheme` function reverts when the caller
    /// is not the token owner.
    /// @param _caller The address of the caller.
    function test_setTokenTheme_CallerNotTokenOwner_Reverts(
        address _caller
    ) public {
        vm.assume(_caller != recipient);

        // Mint a token first.
        vm.prank(owner);
        rewardChecks.mint{value: REWARD_AMOUNT}(recipient, "");

        // Call the setTokenTheme function as an invalid sender.
        vm.prank(_caller);
        vm.expectRevert(
            abi.encodeWithSelector(
                IFiveoutofnineRewardChecks.Unauthorized.selector
            )
        );
        rewardChecks.setTokenTheme(1, Art.Theme.BLUE);
    }

    /// @notice Tests that the `setTokenTheme` function reverts when the token
    /// hasn't been minted.
    /// @param _id The token ID.
    function test_setTokenTheme_TokenUnminted_Reverts(uint256 _id) public {
        // Call the setTokenTheme function with an unminted token ID.
        vm.prank(recipient);
        vm.expectRevert(
            abi.encodeWithSelector(
                IFiveoutofnineRewardChecks.TokenUnminted.selector
            )
        );
        rewardChecks.setTokenTheme(_id, Art.Theme.BLUE);
    }

    /// @notice Tests that the `setTokenTheme` function works correctly.
    function test_setTokenTheme() public {
        // Mint a token first.
        vm.prank(owner);
        rewardChecks.mint{value: REWARD_AMOUNT}(recipient, "");

        // Verify original theme.
        (Art.Theme theme, , , ) = rewardChecks.getMetadata(1);
        assertEq(uint256(theme), uint256(Art.Theme.GRAY));

        // Set a new theme and check event.
        vm.expectEmit(true, false, false, true);
        emit UpdateTokenTheme(1, Art.Theme.BLUE);
        vm.prank(recipient);
        rewardChecks.setTokenTheme(1, Art.Theme.BLUE);

        // Verify the theme was updated.
        (theme, , , ) = rewardChecks.getMetadata(1);
        assertEq(uint256(theme), uint256(Art.Theme.BLUE));
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

    // -------------------------------------------------------------------------
    // `contractURI`
    // -------------------------------------------------------------------------

    /// @notice Tests that the `contractURI` function does not revert.
    function test_contractURI() public view {
        rewardChecks.contractURI();
    }
}
