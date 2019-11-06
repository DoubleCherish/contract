pragma solidity 0.5.0;


interface ERC20Interface {  

    function totalSupply() external view returns (uint256);

    function balanceOf(address holder) external view returns (uint256);

    function allowance(address holder, address spender) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed holder, address indexed spender, uint256 value);

}
