// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract ZombieFactory {
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna));
        zombieToOwner[zombies.length - 1] = msg.sender;
        ownerZombieCount[msg.sender]++;

        emit NewZombie(zombies.length - 1, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "You already have zombies.");

        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
