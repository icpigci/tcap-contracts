// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "../ITreasury.sol";
import "./iOVM_CrossDomainMessenger.sol";

/**
 * @title TCAP Optimistic Treasury
 * @author Cryptex.finance
 * @notice This contract will hold the assets generated by the optimism network.
 */
contract OptimisticTreasury is ITreasury {
  /// @notice Address of the optimistic ovmL2CrossDomainMessenger contract.
  iOVM_CrossDomainMessenger public immutable ovmL2CrossDomainMessenger;

  /**
   * @notice Constructor
   * @param _owner the owner of the contract
   * @param _ovmL2CrossDomainMessenger address of the optimism ovmL2CrossDomainMessenger
   */
  constructor(address _owner, address _ovmL2CrossDomainMessenger)
    ITreasury(_owner)
  {
    require(
      _ovmL2CrossDomainMessenger != address(0),
      "OptimisticTreasury::constructor: address can't be zero"
    );
    ovmL2CrossDomainMessenger = iOVM_CrossDomainMessenger(
      _ovmL2CrossDomainMessenger
    );
  }

  // @notice Throws if called by an account different from the owner
  // @dev call needs to come from ovmL2CrossDomainMessenger
  modifier onlyOwner() override {
    require(
      msg.sender == address(ovmL2CrossDomainMessenger) &&
        ovmL2CrossDomainMessenger.xDomainMessageSender() == owner,
      "OptimisticTreasury: caller is not the owner"
    );
    _;
  }
}
