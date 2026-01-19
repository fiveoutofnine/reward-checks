// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {LibString} from "solady/utils/LibString.sol";

/// @title {FiveoutofnineRewardChecks} visual art
/// @author fiveoutofnine
/// @notice A library for generating art for {FiveoutofnineRewardChecks}.
library FiveoutofnineRewardChecksArt {
    using LibString for address;
    using LibString for string;
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice The starting string for the SVG.
    string internal constant SVG_START =
        '<svg xmlns="http://www.w3.org/2000/svg" width="550" height="550" viewB'
        'ox="0 0 550 550"><style>@font-face{font-family:f;src:url(data:font/wof'
        "f2;utf-8;base64,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"
        "MSyH06UMmz5n1U/0/63Rw=)}@font-face{font-family:i;src:url(data:font/wof"
        "f2;utf-8;base64,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)}text,tspan{dominan"
        "t-baseline:central}.v{font-family:f;letter-spacing:-.05em}.e{font-fami"
        "ly:i}.o{font-size:16px}.u{font-size:12px}.t{fill:#";

    /// @notice The starting string for the inner central element's SVG.
    string internal constant INNER_SVG_START =
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

    /// @notice A look-up table of binomial combinations for $n = 8$ to indices
    /// to lookup the corresponding value in the `C_VALUES_LUT`.
    /// @dev Bit-packed as 4-bit values.
    uint256 internal constant C_INDICES_LUT =
        0x10000000022000000035300000048840000059a9500006bddb60007cefec70;

    /// @notice A look-up table of binomial coefficient values bitpacked as
    /// 8-bit values.
    uint256 internal constant C_VALUES_LUT = 0x4638231c15140f0a0807060504030201;

    // -------------------------------------------------------------------------
    // Enums
    // -------------------------------------------------------------------------

    /// @notice The color palette for the art.
    enum ColorPalette {
        BLUE,
        GRAY,
        GREEN,
        ORANGE,
        RED,
        YELLOW
    }

    // -------------------------------------------------------------------------
    // Art
    // -------------------------------------------------------------------------

    /// @notice Renders the SVG for a given token ID.
    /// @param _id The token ID to render.
    /// @param _colorPalette The color palette to use for the art.
    /// @param _recipient The address of the recipient of the reward check.
    /// @param _blockNumber The block number the reward check was minted at.
    /// @param _memo A memo on the reward check.
    /// @return The attributes metadata for the given token ID.
    /// @return The SVG output for the given token ID.
    function render(
        uint256 _id,
        ColorPalette _colorPalette,
        address _recipient,
        uint256 _blockNumber,
        string memory _memo
    ) external pure returns (string memory, string memory) {
        // Render the central element.
        (string memory innerSVG, uint256 pattern) = _renderInner(_id);

        // Render the token's attributes.
        string memory attributes;
        {
            attributes = string.concat(
                '[{"trait_type":"Recipient","value":"',
                _recipient.toHexStringChecksummed(),
                '"},{"trait_type":"Pattern","value":"',
                (pattern >> 8) & 1 == 1 ? "1" : "0",
                (pattern >> 7) & 1 == 1 ? "1" : "0",
                (pattern >> 6) & 1 == 1 ? "1" : "0",
                (pattern >> 5) & 1 == 1 ? "1" : "0",
                (pattern >> 4) & 1 == 1 ? "1" : "0",
                (pattern >> 3) & 1 == 1 ? "1" : "0",
                (pattern >> 2) & 1 == 1 ? "1" : "0",
                (pattern >> 1) & 1 == 1 ? "1" : "0",
                (pattern) & 1 == 1 ? "1" : "0",
                '"}]'
            );
        }

        // Generate the token's image.
        string memory image;
        {
            uint256 colors = _getColorPaletteHexValues(_colorPalette);
            image = string.concat(
                SVG_START,
                (colors & 0xFFFFFF).toHexStringNoPrefix(3), // Background
                "}.O{fill:#",
                ((colors >> 96) & 0xFFFFFF).toHexStringNoPrefix(3), // Primary text
                "}.F{fill:#",
                ((colors >> 72) & 0xFFFFFF).toHexStringNoPrefix(3), // Secondary text
                "}.n{fill:#",
                ((colors >> 48) & 0xFFFFFF).toHexStringNoPrefix(3), // Border
                "}.I{fill:#",
                ((colors >> 24) & 0xFFFFFF).toHexStringNoPrefix(3), // Card background
                "}.N{fill:none;stroke-width:1.333333;stroke-linejoin:round;stro"
                "ke-linecap:round;stroke:#",
                ((colors >> 72) & 0xFFFFFF).toHexStringNoPrefix(3), // Secondary text (icons)
                '}</style><mask id="E"><rect width="555" height="555" rx="10.27'
                '8" fill="#fff"/></mask><path class="t" d="M0 0h550v550H0z"/><r'
                'ect class="n" x="143" y="69" width="264" height="412" rx="8"/>'
                '<rect class="I" x="147" y="73" width="256" height="404" rx="4"'
                '/><text class="v O" x="163" y="101" font-size="20">Reward Chec'
                "k #"
            );
        }
        {
            image = string.concat(
                image,
                _id.toString(),
                '</text><text x="163" y="121"><tspan class="e u F">Bank of </ts'
                'pan><tspan class="v u O">5/9</tspan></text><rect class="n" x="'
                '163" y="137" width="224" height="224" rx="8"/><g transform="tr'
                'anslate(167 141)scale(.38919)" mask="url(#E)">',
                innerSVG,
                '</g><path class="N" d="M176.988 387.483A5 5 0 0 0 173 385.5a5 '
                "5 0 0 0-3.988 1.983m7.975 0a6 6 0 1 0-7.975 0m7.975 0A5.98 5.9"
                "8 0 0 1 173 389a5.98 5.98 0 0 1-3.988-1.517M175 381.5a2 2 0 1 "
                '1-4 0 2 2 0 0 1 4 0"/><text class="v o O" x="187" y="383">',
                _formatValueAsAddress(uint160(_recipient) >> 132), // Deposit address
                unicode'</text><text class="e u F" x="187" y="403">Deposit to</'
                unicode'text><path class="N" d="m285 382.333 4-6 4 6-4 2zm8 2.3'
                unicode'34-4 5-4-5 4 2z"/><text class="v o O" x="303" y="383">5'
                unicode'.5̅ ⋅ 10⁻⁵</text><text class="e u F" x="303" y="403">Amo'
                unicode'unt</text><path class="N" d="M179 430.333a1.33 1.33 0 0'
                unicode" 0-.667-1.153l-4.666-2.667a1.33 1.33 0 0 0-1.334 0l-4.6"
                unicode"66 2.667a1.33 1.33 0 0 0-.667 1.153v5.334a1.33 1.33 0 0"
                unicode" 0 .667 1.153l4.666 2.667a1.33 1.33 0 0 0 1.334 0l4.666"
                unicode'-2.667a1.33 1.33 0 0 0 .667-1.153Z"/><path class="N" d='
                unicode'"M167.2 429.667 173 433l5.8-3.333m-5.8 10V433"/><text c'
                unicode'lass="v o O" x="187" y="433">',
                _blockNumber.toString(), // Block number
                '</text><text class="e u F" x="187" y="453">Block</text><path c'
                'lass="N" d="M295 431a1.6 1.6 0 0 0-.47-1.137l-2.393-2.392A1.6 '
                "1.6 0 0 0 291 427h-6.667a1.333 1.333 0 0 0-1.333 1.333v9.334a1"
                ".333 1.333 0 0 0 1.333 1.333h9.334a1.333 1.333 0 0 0 1.333-1.3"
                '33z"/><path class="N" d="M291 427v3.333a.667.667 0 0 0 .667.66'
                '7H295"/><text class="v o O" x="303" y="433">',
                _memo, // Memo
                '</text><text class="e u F" x="303" y="453">Memo</text></svg>'
            );
        }

        return (attributes, image);
    }

    /// @notice Renders the central element for a given token ID as an SVG.
    /// @param _id The token ID to render.
    /// @return The SVG output for the given token ID's central element.
    /// @return The pattern of squares filled inside the central element.
    function _renderInner(
        uint256 _id
    ) internal pure returns (string memory, uint256) {
        unchecked {
            // Casting to `int256` is safe because `_id` is positive.
            // forge-lint: disable-next-line(unsafe-typecast)
            int256 i = int256(_id) % 126;
            string memory svg = "";
            uint256 k = 5;
            uint256 pattern;

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
                    pattern |= 1 << p;
                    k--;
                }
            }

            return (
                string.concat(
                    INNER_SVG_START,
                    '"#0d2847" stroke="#104d87">',
                    svg,
                    "</g></svg>"
                ),
                pattern
            );
        }
    }

    /// @notice Helper function to retrieve the hex values of a given color
    /// palette.
    /// @dev The color scale follows the [Radix Colors](https://www.radix-ui.com/colors)
    /// color system.
    /// @param _colorPalette The color palette.
    /// @param colors A bitpacked element containing the hex values of `color1`
    /// (background), `color2` (subtle background), `color6` (border), `color11`
    /// (secondary text), and `color12` (primary text) as 24-bit words (LSB).
    function _getColorPaletteHexValues(
        ColorPalette _colorPalette
    ) internal pure returns (uint256 colors) {
        if (_colorPalette == ColorPalette.BLUE) {
            colors = 0xC2E6FF70B8FF104D871119270D1520;
        } else if (_colorPalette == ColorPalette.GRAY) {
            colors = 0xEEEEEEB4B4B43A3A3A191919111111;
        } else if (_colorPalette == ColorPalette.GREEN) {
            colors = 0xB1F1CB3DD68C20573E121B170E1512;
        } else if (_colorPalette == ColorPalette.ORANGE) {
            colors = 0xFFE0C2FFA05766350C1E160F17120E;
        } else if (_colorPalette == ColorPalette.RED) {
            colors = 0xFFD1D9FF959272232D201314191111;
        } else if (_colorPalette == ColorPalette.YELLOW) {
            colors = 0xF6EEB4F5E1475242021B180F14120B;
        }
    }

    /// @notice Helper function to format the last 28 bits of a value as a
    /// hexstring of length 7. If the value is less than 24 bits, it is padded
    /// with leading zeros.
    /// @param _value The value to format.
    /// @return string memory The formatted string.
    function _formatValueAsAddress(
        uint256 _value
    ) internal pure returns (string memory) {
        return
            string.concat(
                string(
                    abi.encodePacked(
                        // We directly use the `bytes32` value.
                        // forge-lint: disable-next-line(unsafe-typecast)
                        bytes32("0123456789ABCDEF")[(_value >> 24) & 0xF]
                    )
                ),
                (_value & 0xFFFFFF).toHexStringNoPrefix(3).toCase(true)
            );
    }
}
