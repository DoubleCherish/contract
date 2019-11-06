pragma solidity 0.5.0;

import "./TokenStore.sol";
import "./ERC20Interface.sol";
import "./Ownable.sol";

contract ERC20StandardToken is ERC20Interface, Ownable {


    TokenStore public tokenStore;
    
    event TokenStoreSet(address indexed tokenStore);
    event ChangeTokenName(string newName, string newSymbol);

    /**
     * @dev ownership of the TokenStore contract
     * @param _tokenStore The address to of the TokenStore to set.
     */
    function setTokenStore(address _tokenStore) public onlyOwner returns (bool) {
        tokenStore = TokenStore(_tokenStore);
        emit TokenStoreSet(_tokenStore);
        return true;
    }
    
    function changeTokenName(string memory _name, string memory _symbol) public onlyOwner {
        tokenStore.changeTokenName(_name, _symbol);
        emit ChangeTokenName(_name, _symbol);
    }

    function totalSupply() public view returns (uint256) {
        return tokenStore.totalSupply();
    }

    function balanceOf(address _holder) public view returns (uint256) {
        return tokenStore.balances(_holder);
    }

    function allowance(address _holder, address _spender) public view returns (uint256) {
        return tokenStore.allowed(_holder, _spender);
    }
    
    function name() public view returns (string memory) {
        return tokenStore.name();
    }
    
    function symbol() public view returns (string memory) {
        return tokenStore.symbol();
    }
    
    function decimals() public view returns (uint8) {
        return tokenStore.decimals();
    }
    
    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        require (_spender != address(0), "Cannot approve to the zero address");       
        tokenStore.setAllowance(msg.sender, _spender, _value);
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    /**
     * @dev Increase the amount of tokens that an holder allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to increase the allowance by.
     */
    function increaseApproval(
        address _spender,
        uint256 _addedValue
    ) public returns (bool success) {
        require (_spender != address(0), "Cannot increaseApproval to the zero address");      
        tokenStore.addAllowance(msg.sender, _spender, _addedValue);
        emit Approval(msg.sender, _spender, tokenStore.allowed(msg.sender, _spender));
        return true;
    }
    
    /**
     * @dev Decrease the amount of tokens that an holder allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseApproval(
        address _spender,
        uint256 _subtractedValue 
    ) public returns (bool success) {
        require (_spender != address(0), "Cannot decreaseApproval to the zero address");       
        tokenStore.subAllowance(msg.sender, _spender, _subtractedValue);
        emit Approval(msg.sender, _spender, tokenStore.allowed(msg.sender, _spender));
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(
        address _from, 
        address _to, 
        uint256 _value
    ) public returns (bool success) {
        require(_to != address(0), "Cannot transfer to zero address"); 
        tokenStore.subAllowance(_from, msg.sender, _value);          
        tokenStore.subBalance(_from, _value);
        tokenStore.addBalance(_to, _value);
        emit Transfer(_from, _to, _value);
        return true;

    } 

    /**
     * @dev Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */
    function transfer(
        address _to, 
        uint256 _value
    ) public returns (bool success) {
        require (_to != address(0), "Cannot transfer to zero address");    
        tokenStore.subBalance(msg.sender, _value);
        tokenStore.addBalance(_to, _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

}
