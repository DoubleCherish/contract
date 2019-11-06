pragma solidity 0.5.0;

import "./ERC20StandardToken.sol";
import "./BlacklistableToken.sol";

contract MintableToken is BlacklistableToken {

    event MinterChanged(address indexed newAddress);
    event Mint(address indexed minter, address indexed to, uint256 value);

    address private _minter;

    modifier onlyMinter() {
        require(msg.sender == _minter, "msg.sender should be minter");
        _;
    }

    /**
     * @dev Tells the address of the blacklister
     * @return The address of the blacklister
     */
    function minter() public view returns (address) {
        return _minter;
    }
 
    /**
     * @dev update the minter
     * @param _newMinter The newMinter to update
     */
    function updateMinter(address _newMinter) public onlyOwner {
        require(_newMinter != address(0), "Cannot update the newPauser to the zero address");
        _minter = _newMinter;
        emit MinterChanged(_minter);
    }

    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _value The amount of tokens to mint. Must be less than or equal to the minterAllowance of the caller.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(
        address _to, 
        uint256 _value
    ) public onlyMinter whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_to) returns (bool) {
        require(_to != address(0), "Cannot mint to zero address");
        tokenStore.addTotalSupply(_value);
        tokenStore.addBalance(_to, _value);  
        emit Mint(msg.sender, _to, _value);
        emit Transfer(address(0), _to, _value);
        return true;
    }

}
