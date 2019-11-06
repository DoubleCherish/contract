pragma solidity 0.5.0;

import "./Ownable.sol";
import "./ERC20StandardToken.sol";

contract PausableToken is ERC20StandardToken {

    address private _pauser;
    bool public paused = false;

    event Pause();
    event Unpause();
    event PauserChanged(address indexed newAddress);
    
    /**
     * @dev Tells the address of the pauser
     * @return The address of the pauser
     */
    function pauser() public view returns (address) {
        return _pauser;
    }
    
    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!paused, "state shouldn't be paused");
        _;
    }

    /**
     * @dev throws if called by any account other than the pauser
     */
    modifier onlyPauser() {
        require(msg.sender == _pauser, "msg.sender should be pauser");
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyPauser {
        paused = true;
        emit Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() public onlyPauser {
        paused = false;
        emit Unpause();
    }

    /**
     * @dev update the pauser role
     * @param _newPauser The newPauser to update
     */
    function updatePauser(address _newPauser) public onlyOwner {
        require(_newPauser != address(0), "Cannot update the newPauser to the zero address");
        _pauser = _newPauser;
        emit PauserChanged(_pauser);
    }

    function approve(
        address _spender,
        uint256 _value
    ) public whenNotPaused returns (bool success) {
        return super.approve(_spender, _value);
    }

    function increaseApproval(
        address _spender,
        uint256 _addedValue
    ) public whenNotPaused returns (bool success) {
        return super.increaseApproval(_spender, _addedValue);
    } 

    function decreaseApproval(
        address _spender,
        uint256 _subtractedValue 
    ) public whenNotPaused returns (bool success) {
        return super.decreaseApproval(_spender, _subtractedValue);
    }

    function transferFrom(
        address _from, 
        address _to, 
        uint256 _value
    ) public whenNotPaused returns (bool success) {
        return super.transferFrom(_from, _to, _value);
    } 

    function transfer(
        address _to, 
        uint256 _value
    ) public whenNotPaused returns (bool success) {
        return super.transfer(_to, _value);
    }

}
