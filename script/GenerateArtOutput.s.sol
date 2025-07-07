// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import {LibString} from "solady/utils/LibString.sol";

import {FiveoutofnineRewardChecksArt} from "src/utils/FiveoutofnineRewardChecksArt.sol";

/// @notice A script to create and write the base64-encoded JSON output of a
/// given token's metadata, directly from the utility library.
/// @dev You must run this script with `--via-ir`.
contract GenerateArtOutputScript is Script {
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    /// @notice Calls the {FiveoutofnineRewardChecksArt} library to generate the
    /// SVG output for a given token ID `i` and writes it `./output/svg/{i}.svg`.
    function run() public {
        for (uint256 i; i < 126; ) {
            vm.writeFile(
                string.concat("./output/svg/", i.toString(), ".svg"),
                FiveoutofnineRewardChecksArt.render({_tokenId: i})
            );

            unchecked {
                ++i;
            }
        }
    }
}
