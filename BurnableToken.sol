pragma solidity 0.5.0;

import "./BlacklistableToken.sol";

contract BurnableToken is BlacklistableToken {

    event Burn(address indexed burner, uint256 value);
    
    /**
     * @dev holder can burn some of its own tokens
     * amount is less than or equal to the minter's account balance
     * @param _value uint256 the amount of tokens to be burned
    */
    function burn(
        uint256 _value
    ) public whenNotPaused notBlacklisted(msg.sender) returns (bool success) {   
        tokenStore.subBalance(msg.sender, _value);
        tokenStore.subTotalSupply(_value);
        emit Burn(msg.sender, _value);
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }

}