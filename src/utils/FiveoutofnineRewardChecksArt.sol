// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {LibString} from "solady/utils/LibString.sol";

library FiveoutofnineRewardChecksArt {
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    string internal constant SVG_START =
        '<svg xmlns="http://www.w3.org/2000/svg" width="555" height="555" viewB'
        'ox="0 0 555 555" fill="none"><path id="f" d="M28.65836 28.65836h497.68'
        '328v497.68328H28.65836z"/><mask id="i"><path d="M0 0h555v555H0z" fill='
        '"#fff"/><use href="#f" fill="#000"/></mask><path d="M0 0h555v555H0z" f'
        'ill="#000"/><use href="#f" fill="#111"/><use href="#f" stroke="#3a3a3a'
        '" stroke-width="4" mask="url(#i)"/><path id="v" d="m85 30 110 55-55 11'
        '0-110-55z" stroke-width="2"/><path id="e" d="M28 85h499" stroke="#3a3a'
        '3a" stroke-dasharray="5 5"/><use href="#e" y="55"/><path id="o" d="M28'
        ' 195h499" stroke="#3a3a3a" stroke-width="2"/><use href="#e" y="165"/><'
        'use href="#e" y="220"/><use href="#o" y="165"/><use href="#e" y="330"/'
        '><use href="#e" y="385"/><path id="u" d="M85 28v499" stroke="#3a3a3a" '
        'stroke-dasharray="5 5"/><use href="#u" x="55"/><path id="t" d="M195 28'
        'v499" stroke="#3a3a3a" stroke-width="2"/><use href="#u" x="165"/><use '
        'href="#u" x="220"/><use href="#t" x="165"/><use href="#u" x="330"/><us'
        'e href="#u" x="385"/><g fill="#222" stroke="#3a3a3a"><use href="#v" x='
        '"110" y="0"/><use href="#v" x="220" y="55"/><use href="#v" x="330" y="'
        '110"/><use href="#v" x="55" y="110"/><use href="#v" x="165" y="165"/><'
        'use href="#v" x="275" y="220"/><use href="#v" x="0" y="220"/><use href'
        '="#v" x="110" y="275"/><use href="#v" x="220" y="330"/></g><g fill=';

    uint256 internal constant C_INDICES_LUT =
        0x10000000022000000035300000048840000059a9500006bddb60007cefec70;

    uint256 internal constant C_VALUES_LUT = 0x4638231c15140f0a0807060504030201;

    // -------------------------------------------------------------------------
    // `render` function
    // -------------------------------------------------------------------------

    /// @notice Renders the SVG for a given token ID.
    /// @param _tokenId The token ID to render.
    /// @return SVG output for the given token ID.
    function render(uint256 _tokenId) internal pure returns (string memory) {
        unchecked {
            int256 i = int256(_tokenId) % 126;
            string memory svg = "";
            uint256 k = 5;

            for (uint256 p; p < 9; ++p) {
                uint256 j = (C_INDICES_LUT >> ((8 + 9 * p - k) << 2)) & 0xF;
                uint256 v = (C_VALUES_LUT >> (j << 3)) & 0xFF;
                int256 c;

                assembly {
                    c := mul(v, lt(add(k, p), 9))
                }

                if (i >= c) {
                    i -= c;
                    (uint256 x, uint256 y) = (p % 3, p / 3);
                    svg = string.concat(
                        svg,
                        '<use href="#v" x="',
                        (55 * (2 + (x << 1) - y)).toString(),
                        '" y="',
                        (55 * (x + (y << 1))).toString(),
                        '"/>'
                    );
                    k--;
                }
            }

            return
                string.concat(
                    SVG_START,
                    '"#0d2847" stroke="#104d87">',
                    svg,
                    "</g></svg>"
                );
        }
    }
}
