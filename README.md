# Smart Contract Security Research & PoC Archive

This repository serves as a structured archive of my smart contract security research, audit contest findings, bug bounty Proof of Concepts (PoCs), and solutions to Web3 security challenges (Ethernaut, Damn Vulnerable DeFi). All exploit simulations and mitigation verifications are developed and tested using Foundry.

## Vulnerability & Exploit Index

| ID  | Vulnerability Category           | Target Contract | Severity | PoC Test                 | Audit Report                              |
| :-- | :------------------------------- | :-------------- | :------- | :----------------------- | :---------------------------------------- |
| 01  | Reentrancy (Exact Balance Drain) | `src/Bank.sol`  | High     | `test/BankExploit.t.sol` | [Report](./reports/01-reentrancy-bank.md) |

## Repository Structure

```text
├── src/        # Vulnerable target contracts and mitigated implementations
├── test/       # Foundry exploit Proof of Concepts (PoCs) and invariant tests
├── reports/    # Formal security audit reports with root cause analysis and mitigations
└── foundry.toml
```

## Setup and Reproduction

To clone the repository and run any Proof of Concept locally:

1. Clone the repository:

   ```bash
   git clone https://github.com/14metehan53/evm-security-research-lab.git
   cd evm-security-research-lab
   ```

2. Install dependencies:

   ```bash
   forge install
   ```

3. Run a specific exploit test:
   ```bash
   forge test --match-contract BankExploitTest -vv
   ```
