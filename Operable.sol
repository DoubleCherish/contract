pragma solidity 0.5.0;

import "./Ownable.sol";

contract Operable is Ownable {

    address private _operator; 

    event OperatorChanged(address indexed newOperator);

    /**
     * @dev Tells the address of the operator
     * @return the address of the operator
     */
    function operator() external view returns (address) {
        return _operator;
    }
    
    /**
     * @dev Only the operator can operate store
     */
    modifier onlyOperator() {
        require(msg.sender == _operator, "msg.sender should be operator");
        _;
    }

    /**
     * @dev update the storgeOperator
     * @param _newOperator The newOperator to update  
     */
    function updateOperator(address _newOperator) public onlyOwner {
        require(_newOperator != address(0), "Cannot change the newOperator to the zero address");
        _operator = _newOperator;
        emit OperatorChanged(_operator);
    }

}