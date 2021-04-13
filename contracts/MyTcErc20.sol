// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract MyTcErc20 is ERC20PresetFixedSupply {
    constructor()
        ERC20PresetFixedSupply("MYTC", "MYTC", 100000000000000000000000000,msg.sender)
        public
    {

    }
}