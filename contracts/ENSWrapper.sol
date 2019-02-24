pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "@ensdomains/ens/contracts/HashRegistrar.sol";
import "@ensdomains/ens/contracts/Deed.sol";

contract ENSWrapper is ERC721Full {
    HashRegistrar private _registrar;

    modifier tokenOwner(bytes32 node) {
        require(_exists(uint256(node)), "name-not-wrapped");
        require(ownerOf(uint256(node)) == msg.sender, "sender-not-owner");
        _;
    }

    constructor(string memory name, string memory symbol, HashRegistrar registrar) public ERC721Full(name, symbol) {
        _registrar = registrar;
    }

    function mint(bytes32 node) public {
        address deedAddress;
        (,deedAddress,,,) = _registrar.entries(node);

        Deed deed = Deed(deedAddress);

        require(deed.owner() == address(this), "wrapper-not-owner");
        require(deed.previousOwner() == msg.sender, "sender-not-previous-name-owner");

        _mint(msg.sender, uint256(node));
    }

    function burn(bytes32 node) public tokenOwner(node) {
        require(ownerOf(uint256(node)) == msg.sender, "sender-not-token-owner");

        _burn(msg.sender, uint256(node));
        _registrar.transfer(node, msg.sender);
    }
}
