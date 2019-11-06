pragma solidity 0.5.0;

import "./BurnableToken.sol";
import "./MintableToken.sol";


contract Token is BurnableToken, MintableToken {

    /**
     * contract only can initialized once 
     */
    bool private initialized = false;

    /**
     * @dev sets 0 initials tokens, the owner.
     * this serves as the constructor for the proxy but compiles to the
     * memory model of the Implementation contract.
     * @param _owner The owner to initials
     */
    function initialize(address _owner) public {
        require(!initialized, "already initialized");
        require(_owner != address(0), "Cannot initialize the owner to zero address");
        setOwner(_owner);
        initialized = true;
    }

}