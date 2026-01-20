// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {LibString} from "solady/utils/LibString.sol";

import {
    FiveoutofnineRewardChecksArt as Art
} from "src/utils/FiveoutofnineRewardChecksArt.sol";

/// @notice A script to create and write the SVG output of a given token's
/// metadata, directly from the utility library.
contract GenerateArtOutputScript is Script {
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    /// @notice Calls the {FiveoutofnineRewardChecksArt} library to generate the
    /// SVG output for a given token ID `i` and writes it to
    /// `./output/svg/{i}.svg`.
    function run() public {
        for (uint256 i; i < 126; ) {
            Art.Theme theme = [
                Art.Theme.BLUE,
                Art.Theme.GRAY,
                Art.Theme.GREEN,
                Art.Theme.ORANGE,
                Art.Theme.RED,
                Art.Theme.YELLOW
            ][i % 6];

            (string memory attributes, string memory svg) = Art.render({
                _id: i,
                _theme: theme,
                _recipient: 0xA85572Cd96f1643458f17340b6f0D6549Af482F5,
                _blockNumber: 5_555_555,
                _memo: "typo fix"
            });

            vm.writeFile(
                string.concat("./output/attributes/", i.toString(), ".json"),
                attributes
            );
            vm.writeFile(
                string.concat("./output/svg/", i.toString(), ".svg"),
                svg
            );

            unchecked {
                ++i;
            }
        }
    }
}
