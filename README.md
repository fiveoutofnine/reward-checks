# ⁵⁄₉ Reward Checks

[**Reward checks**](https://fiveoutofnine.com/blog/reward-checks) of 5̅ ⋅ 10⁻⁵ ETH, awarded by ⁵⁄₉ for finding fixes, errors, or making suggestions to their work.

$$\texttt{Deploy WIP}$$

> [!NOTE]
> Donald Knuth [did it first](https://en.wikipedia.org/wiki/Knuth_reward_check) with "hexadecimal dollars" (`0x$1.00`). Read more [here](https://fiveoutofnine.com/blog/reward-checks).

![5/9 reward checks](/assets/fiveoutofnine-reward-check.webp)
![Knuth reward checks](/assets/knuth-reward-check.webp)

To submit a fix/suggestion, make a PR on any of [my repos](https://github.com/fiveoutofnine?tab=repositories) or DM me on [𝕏](https://x.com/fiveoutofnine). If you want a ⁵⁄₉ reward check, let me know your Ethereum address :).

## Deployment

The [`FiveoutofnineRewardChecks`](https://github.com/fiveoutofnine/reward-checks/blob/main/src/FiveoutofnineRewardChecks.sol) deployment require the public library [`FiveoutofnineRewardChecksArt`](https://github.com/fiveoutofnine/reward-checks/blob/main/src/utils/FiveoutofnineRewardChecksArt.sol) to be deployed to avoid the [**Spurious Dragon code size limit**](https://github.com/ethereum/EIPs/blob/28ebf81e51136a823eef5044862f946d8de9b723/EIPS/eip-170.md).

Both contracts were compiled with the compiler version `v0.8.21+commit.d9974bed` with `55_555_555` optimizer runs and `via-ir=true`, and they were all deployed on [**Base**](https://base.org) by [`fiveoutofnine.eth`](https://basescan.org/address/0xA85572Cd96f1643458f17340b6f0D6549Af482F5) through the `ImmutableCreate2Factory` at[`0x0000000000FFe8B47B3e2130213B802212439497`](https://basescan.org/address/0x0000000000FFe8B47B3e2130213B802212439497):

### `FiveoutofnineRewardChecks`

`FiveoutofnineRewardChecks` was deployed to [`deploy WIP`](https://basescan.org) with the salt

```
salt WIP
```

and the bytecode

```
bytecode WIP
```

### `FiveoutofnineRewardChecksArt`

`FiveoutofnineRewardChecksArt` was deployed to [`deploy WIP`](https://basescan.org/address) with the salt

```
0x0000000000000000000000000000000000000000000000000000000000000000
```

and the bytecode

```
bytecode WIP
```

## Local development

This project uses [**Foundry**](https://github.com/foundry-rs/foundry) as its development/testing framework.

### Installation

First, make sure you have Foundry installed. Then, run the following commands to clone the repo and install its dependencies:

```sh
git clone https://github.com/fiveoutofnine/reward-checks.git
cd reward-checks
forge install
```

### Testing

To run tests, run the following command:

```sh
forge test
```

To generate and write sample attribute and SVG outputs to `./output/json/{token_id}.json` and `./output/svg/{token_id}.svg`, respectively, follow the instructions in [`GenerateArtOutputScript`](https://github.com/fiveoutofnine/reward-checks/blob/main/script/GenerateArtOutput.s.sol) and run the following command:

```sh
forge script script/GenerateArtOutputScript.s.sol:GenerateArtOutputScript -vvv --via-ir
```

### Deploying and verifying

> [!NOTE]
> The following commands verify the contracts on [**Basescan**](https://basescan.org), so it requires a Basescan API key. You can get one [**here**](https://basescan.org/login).

As mentioned [**above**](https://github.com/fiveoutofnine/reward-checks#deployment), `FiveoutofnineRewardChecks` requires `FiveoutofnineRewardChecksArt` to be deployed as public libraries. The following are the ordered sequence of `forge`/`cast` commands used for the [**deployment** (WIP)](https://basescan.org/address).

1. Grab `FiveoutofnineRewardChecksArt` bytecode.

```sh
forge inspect src/utils/FiveoutofnineRewardChecksArt.sol:FiveoutofnineRewardChecksArt bytecode
```

2. Verify `FiveoutofnineRewardChecksArt`.

```sh
forge verify-contract $FIVEOUTOFNINE_REWARD_CHECKS_ART src/utils/FiveoutofnineRewardChecksArt.sol:FiveoutofnineRewardChecksArt \
    --chain-id 8453 \
    --num-of-optimizations 55555555 \
    --compiler-version "0.8.21+commit.d9974bed" \
    --etherscan-api-key $BASESCAN_API_KEY \
    --verifier-url "https://api.basescan.org/api" \
    --watch
```

3. Grab `FiveoutofnineRewardChecks` bytecode.

```sh
forge inspect src/FiveoutofnineRewardChecks.sol:FiveoutofnineRewardChecks bytecode \
    --libraries "src/utils/FiveoutofnineRewardChecksArt.sol:FiveoutofnineRewardChecksArt:${FIVEOUTOFNINE_REWARD_CHECKS_ART}"
```

4. [Optional] Mine for a `create2` salt.

```sh
cast create2 \
    --deployer 0x0000000000FFe8B47B3e2130213B802212439497 \
    --caller 0xA85572Cd96f1643458f17340b6f0D6549Af482F5 \
    --init-code-hash faf5b882504deb92509835098ba94367043f4ad9493d49965f052da41b26e0e2 \
    --starts-with 55555555
```

> [!TIP]
> I use [**this online tool**](https://emn178.github.io/online-tools/keccak_256.html) to compute the `INIT_CODE_HASH`.

5. Verify `FiveoutofnineRewardChecks`.

```sh
forge verify-contract $FIVEOUTOFNINE_REWARD_CHECKS src/utils/FiveoutofnineRewardChecks.sol:FiveoutofnineRewardChecks \
    --libraries "src/utils/FiveoutofnineRewardChecksArt.sol:FiveoutofnineRewardChecksArt:${FIVEOUTOFNINE_REWARD_CHECKS_ART}" \
    --chain-id 8453 \
    --num-of-optimizations 55555555 \
    --compiler-version "0.8.21+commit.d9974bed" \
    --etherscan-api-key $BASESCAN_API_KEY \
    --verifier-url "https://api.basescan.org/api" \
    --watch
```

## Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._
