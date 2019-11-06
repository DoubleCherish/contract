pragma solidity 0.5.0;

import "./Operable.sol";

contract BlacklistStore is Operable {

    mapping (address => uint256) public blacklisted;

    /**
     * @dev Checks if account is blacklisted
     * @param _account The address to check
     * @param _status The address status    
     */
    function setBlacklist(address _account, uint256 _status) public onlyOperator {
        blacklisted[_account] = _status;
    }

}