pragma solidity 0.5.0;

import "./Operable.sol";
import "./utils/SafeMath.sol";

contract TokenStore is Operable {

    using SafeMath for uint256;

    uint256 public totalSupply;
    
    string  public name = "XXX";
    string  public symbol = "XXX";
    uint8 public decimals = 18;

    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    function changeTokenName(string memory _name, string memory _symbol) public onlyOperator {
        name = _name;
        symbol = _symbol;
    }

    function addBalance(address _holder, uint256 _value) public onlyOperator {
        balances[_holder] = balances[_holder].add(_value);
    }

    function subBalance(address _holder, uint256 _value) public onlyOperator {
        balances[_holder] = balances[_holder].sub(_value);
    }

    function setBalance(address _holder, uint256 _value) public onlyOperator {
        balances[_holder] = _value;
    }

    function addAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
        allowed[_holder][_spender] = allowed[_holder][_spender].add(_value);
    }

    function subAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
        allowed[_holder][_spender] = allowed[_holder][_spender].sub(_value);
    }

    function setAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
        allowed[_holder][_spender] = _value;
    }

    function addTotalSupply(uint256 _value) public onlyOperator {
        totalSupply = totalSupply.add(_value);
    }

    function subTotalSupply(uint256 _value) public onlyOperator {
        totalSupply = totalSupply.sub(_value);
    }

    function setTotalSupply(uint256 _value) public onlyOperator {
        totalSupply = _value;
    }

}