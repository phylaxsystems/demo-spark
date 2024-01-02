// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {Alert} from "phylax-std/Alert.sol";

contract AssetsLiability is Alert {
    address $healthcheckAddress = 0xfda082e00EF89185d9DB7E5DcD8c5505070F5A3B;
    address $DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    uint256 mainnet;
    uint256 immutable PRECISION = 1e18;

    function setUp() public {
        mainnet = enableChain("mainnet");
    }

    address[] unhealthyReserves;

    function test_assetsLiability() public chain(mainnet) {
        address reserve;
        uint256 liabilities;
        uint256 assets;
        IHealthchecks.ReserveAssetLiability[]
            memory assetsAndLiabilities = IHealthchecks($healthcheckAddress)
                .getAllReservesAssetLiability();
        uint256 len = assetsAndLiabilities.length;
        for (uint256 i; i < len; i++) {
            reserve = assetsAndLiabilities[i].reserve;
            liabilities = assetsAndLiabilities[i].liabilities;
            assets = assetsAndLiabilities[i].assets;
            exportData(reserve, liabilities, assets);
            if (reserve == $DAI) {
                if (
                    (liabilities > assets ||
                        assets - liabilities > 300_000 * PRECISION)
                ) {
                    unhealthyReserves.push(reserve);
                }
            } else {
                if (
                    (liabilities > assets ||
                        assets - liabilities > 1_000 * PRECISION)
                ) {
                    unhealthyReserves.push(reserve);
                }
            }
        }
        if (unhealthyReserves.length > 0) {
            string memory reserves = "";
            for (uint256 i; i < unhealthyReserves.length; i++) {
                reserves = string.concat(
                    reserves,
                    "'",
                    vm.toString(unhealthyReserves[i]),
                    "'"
                );
                if (i != unhealthyReserves.length - 1) {
                    reserves = string.concat(reserves, ", ");
                }
            }
            string memory err = string.concat(
                "The reserves [",
                reserves,
                "] are not healthy"
            );
            revert(err);
        }
    }

    function exportData(
        address reserve,
        uint256 liabilities,
        uint256 assets
    ) internal {
        string memory key = string.concat("health-", vm.toString(reserve));
        int256 diff = int256(assets) - int256(liabilities);
        ph.export(key, vm.toString(diff));
    }
}

interface IHealthchecks {
    struct ReserveAssetLiability {
        address reserve;
        uint256 assets;
        uint256 liabilities;
    }

    function getAllReservesAssetLiability()
        external
        view
        returns (ReserveAssetLiability[] memory);
}
