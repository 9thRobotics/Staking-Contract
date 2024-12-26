// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract StakingContract is Ownable, ReentrancyGuard {
    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public stakingRewards;
    mapping(address => uint256) public balanceOf;

    uint256 public rewardRate = 10; // Example: 10% annual rewards

    event TokensStaked(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);
    event RewardRateUpdated(uint256 newRewardRate);

    function stakeTokens(uint256 _amount) external nonReentrant {
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance");
        stakedBalances[msg.sender] += _amount;
        balanceOf[msg.sender] -= _amount;
        emit TokensStaked(msg.sender, _amount);
    }

    function claimStakingRewards() external nonReentrant {
        uint256 reward = (stakedBalances[msg.sender] * rewardRate) / 100;
        stakingRewards[msg.sender] += reward;
        balanceOf[msg.sender] += reward; // Add rewards to user's balance
        emit RewardsClaimed(msg.sender, reward);
    }

    function mintTokens(address _to, uint256 _amount) external onlyOwner {
        balanceOf[_to] += _amount; // Mint tokens for testing
    }

    function updateRewardRate(uint256 _newRate) external onlyOwner {
        rewardRate = _newRate;
        emit RewardRateUpdated(_newRate);
    }
}
