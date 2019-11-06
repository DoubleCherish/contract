pragma solidity 0.5.0;

import "./PausableToken.sol";
import "./BlacklistStore.sol";

/**
 * @title BlacklistableToken
 * @dev Allows accounts to be blacklisted by a "blacklister" role
 */
contract BlacklistableToken is PausableToken {

    BlacklistStore public blacklistStore;

    address private _blacklister;

    event BlacklisterChanged(address indexed newBlacklister);
    event BlacklistStoreSet(address indexed blacklistStore);
    event Blacklist(address indexed account, uint256 _status);


    /**
     * @dev Throws if argument account is blacklisted
     * @param _account The address to check
     */
    modifier notBlacklisted(address _account) {
        require(blacklistStore.blacklisted(_account) == 0, "Account not in the blacklist");
        _;
    }

    /**
     * @dev Throws if called by any account other than the blacklister
     */
    modifier onlyBlacklister() {
        require(msg.sender == _blacklister, "msg.sener should be blacklister");
        _;
    }

    /**
     * @dev Tells the address of the blacklister
     * @return The address of the blacklister
     */
    function blacklister() public view returns (address) {
        return _blacklister;
    }
    
    /**
     * @dev Set the blacklistStore
     * @param _blacklistStore The blacklistStore address to set
     */
    function setBlacklistStore(address _blacklistStore) public onlyOwner returns (bool) {
        blacklistStore = BlacklistStore(_blacklistStore);
        emit BlacklistStoreSet(_blacklistStore);
        return true;
    }
    
    /**
     * @dev Update the blacklister 
     * @param _newBlacklister The newBlacklister to update
     */
    function updateBlacklister(address _newBlacklister) public onlyOwner {
        require(_newBlacklister != address(0), "Cannot update the blacklister to the zero address");
        _blacklister = _newBlacklister;
        emit BlacklisterChanged(_blacklister);
    }

    /**
     * @dev Checks if account is blacklisted
     * @param _account The address status to query
     * @return the address status 
     */
    function queryBlacklist(address _account) public view returns (uint256) {
        return blacklistStore.blacklisted(_account);
    }

    /**
     * @dev Adds account to blacklist
     * @param _account The address to blacklist
     * @param _status The address status to change
     */
    function changeBlacklist(address _account, uint256 _status) public onlyBlacklister {
        blacklistStore.setBlacklist(_account, _status);
        emit Blacklist(_account, _status);
    }

    function approve(
        address _spender,
        uint256 _value
    ) public notBlacklisted(msg.sender) notBlacklisted(_spender) returns (bool success) {
        return super.approve(_spender, _value);
    }
    
    function increaseApproval(
        address _spender,
        uint256 _addedValue
    ) public notBlacklisted(msg.sender) notBlacklisted(_spender) returns (bool success) {
        return super.increaseApproval(_spender, _addedValue);
    } 

    function decreaseApproval(
        address _spender,
        uint256 _subtractedValue 
    ) public notBlacklisted(msg.sender) notBlacklisted(_spender) returns (bool success) {
        return super.decreaseApproval(_spender, _subtractedValue);
    }

    function transferFrom(
        address _from, 
        address _to, 
        uint256 _value
    ) public notBlacklisted(_from) notBlacklisted(_to) notBlacklisted(msg.sender) returns (bool success) {
        return super.transferFrom(_from, _to, _value);

    } 

    function transfer(
        address _to, 
        uint256 _value
    ) public notBlacklisted(msg.sender) notBlacklisted(_to) returns (bool success) {
        return super.transfer(_to, _value);
    }

}
