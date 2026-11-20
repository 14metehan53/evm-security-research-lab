# [H-01] Reentrancy Vulnerability in `Bank.withdraw()` Allows Complete Drainage of Funds

## Summary

The `Bank` contract fails to follow the **Checks Effects Interactions (CEI)** pattern in its `withdraw()` function. Because external ETH transfers are executed before updating the caller's internal balance, a malicious contract can recursively re-enter `withdraw()` and drain the entire contract balance down to `0 wei`.

## Vulnerability Details

In `src/Bank.sol`, the `withdraw()` function sends ETH via a low level `.call` prior to setting `balances[msg.sender] = 0`:

```solidity
(bool success, ) = msg.sender.call{value: balance}("");
require(success, "Transfer failed");

balances[msg.sender] = 0; // State updated AFTER external call
```

When an attacker contract receives ETH, its `receive()` fallback function is triggered. Since `balances[msg.sender]` is still non-zero, the attacker can repeatedly invoke `withdraw()` until the bank's ETH balance is depleted. Even fractional ("dust") balances can be completely drained by matching the remaining contract balance in a final deposit and withdraw cycle.

## Impact

**High / Critical:** Any malicious user can steal 100% of the ETH deposited by other users in the `Bank` contract.

## Proof of Concept (PoC)

Run the Foundry test suite to reproduce the exploit:

```bash
forge test --match-contract BankExploitTest -vv
```

### Expected Output:

```text
=== INITIAL STATE ===
Target Bank Balance (wei)  : 10550000000000000000
Attacker Initial Capital   : 1000000000000000000

=== POST-EXPLOIT STATE ===
Target Bank Balance (wei)  : 0
Attacker Final Balance     : 11550000000000000000
Net Profit Extracted (wei) : 10550000000000000000
```

## Recommended Mitigation

Apply the **Checks Effects Interactions (CEI)** pattern by zeroing out the user's balance _before_ transferring ETH, or use OpenZeppelin's `ReentrancyGuard` (`nonReentrant` modifier):

```solidity
function withdraw() external {
    uint256 balance = balances[msg.sender];
    require(balance > 0, "Insufficient balance");

    // Effect: Update state before external interaction
    balances[msg.sender] = 0;

    // Interaction: External call executed last
    (bool success, ) = msg.sender.call{value: balance}("");
    require(success, "Transfer failed");
}
```
