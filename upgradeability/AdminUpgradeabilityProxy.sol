pragma solidity 0.5.0;

import "./UpgradeabilityProxy.sol";

/**
 * @title AdminUpgradeabilityProxy
 * @dev This contract combines an upgradeability proxy with an authorization
 * mechanism for administrative tasks.
 * All external functions in this contract must be guarded by the
 * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
 * feature proposal that would enable this to be done automatically.
 */
contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
   
    /**
     * @dev Emitted when the administration has been transferred.
     * @param previousAdmin Address of the previous admin.
     * @param newAdmin Address of the new admin.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
     * validated in the constructor.
     */
    bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
    bytes32 private constant PENDINGADMIN_SLOT = 0x54ac2bd5363dfe95a011c5b5a153968d77d153d212e900afce8624fdad74525c;

    /**
     * @dev Modifier to check whether the `msg.sender` is the admin.
     * If it is, it will run the function. Otherwise, it will delegate the call
     * to the implementation.
     */
    modifier ifAdmin() {
        if (msg.sender == _admin()) {
            _;
        } else {
            _fallback();
        }
    }

    /**
     * @dev Modifier to check whether the `msg.sender` is the pendingAdmin.
     * If it is, it will run the function. Otherwise, it will delegate the call
     * to the implementation.
     */
    modifier ifPendingAdmin() {
        if (msg.sender == _pendingAdmin()) {
            _;
        } else {
            _fallback();
        }
    }

    /**
     * Contract constructor.
     * @param _implementation address of the initial implementation.
     * @param _admin Address of the proxy administrator.
     * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
     * It should include the signature and the parameters of the function to be called, as described in
     * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
     * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
     */
    constructor(
        address payable _implementation, 
        address _admin, 
        bytes memory _data
    ) UpgradeabilityProxy(_implementation, _data) public payable {
        assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
        assert(PENDINGADMIN_SLOT == keccak256("org.zeppelinos.proxy.pendingAdmin"));
        _setAdmin(_admin);
    }

    /**
     * @return The address of the proxy admin.
     */
    function admin() external ifAdmin returns (address) {
        return _admin();
    }

    /**
     * @return The address of the proxy pendingAdmin
     */
    function pendingAdmin() external returns (address) {
        if (msg.sender == _admin() || msg.sender == _pendingAdmin()) {
            return _pendingAdmin();
        } else {
            _fallback();
        }
    }

    /**
     * @return The address of the implementation.
     */
    function implementation() external ifAdmin returns (address) {
        return _implementation();
    }

    /**
     * @dev Changes the admin of the proxy.
     * Only the current admin can call this function.
     * @param _newAdmin Address to transfer proxy administration to.
     */
    function changeAdmin(address _newAdmin) external ifAdmin {
        _setPendingAdmin(_newAdmin);
    }
    
    /**
     * @dev Allows the pendingAdmin address to finalize the transfer. 
     */
    function claimAdmin() external ifPendingAdmin {
        emit AdminChanged(_admin(), _pendingAdmin());
        _setAdmin(_pendingAdmin());
        _setPendingAdmin(address(0));
        
    }  

    /**
     * @dev Upgrade the backing implementation of the proxy.
     * Only the admin can call this function.
     * @param newImplementation Address of the new implementation.
     */
    function upgradeTo(address newImplementation) external ifAdmin {
        _upgradeTo(newImplementation);
    }

    /**
     * @dev Upgrade the backing implementation of the proxy and call a function
     * on the new implementation.
     * This is useful to initialize the proxied contract.
     * @param _newImplementation Address of the new implementation.
     * @param _data Data to send as msg.data in the low level call.
     * It should include the signature and the parameters of the function to be called, as described in
     * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
     */
    function upgradeToAndCall(address _newImplementation, bytes calldata _data) external payable ifAdmin {
        _upgradeTo(_newImplementation);
        (bool success, ) = _newImplementation.delegatecall(_data); 
        require(success);
    }

    /**
     * @return The admin slot.
     */
    function _admin() internal view returns (address adm) {
        bytes32 slot = ADMIN_SLOT;
        assembly {
            adm := sload(slot)
        }
    }

    /**
     * @return The pendingAdmin slot
     */
    function _pendingAdmin() internal view returns (address pendingAdm) {
        bytes32 slot = PENDINGADMIN_SLOT;
        assembly {
            pendingAdm := sload(slot)
        }
    }

    /**
     * @dev Sets the address of the proxy admin.
     * @param _newAdmin Address of the new proxy admin.
     */
    function _setAdmin(address _newAdmin) internal { 
        bytes32 slot = ADMIN_SLOT;
        assembly {
            sstore(slot, _newAdmin)
        }
    }

    /**
     * @dev Sets the address of the proxy pendingAdmin.
     * @param _newAdmin Address of the new proxy pendingAdmin.
     */
    function _setPendingAdmin(address _newAdmin) internal { 
        bytes32 slot = PENDINGADMIN_SLOT;
        assembly {
            sstore(slot, _newAdmin)
        }
    }

    /**
     * @dev Only fall back when the sender is not the admin.
     */
    function _willFallback() internal {
        require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
        super._willFallback();
    }

}