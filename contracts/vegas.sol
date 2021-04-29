pragma solidity ^0.7.0;

contract Vegas {
    
    address owner;
    mapping(address => uint) fichaPessoa;
    address[] fichas;
    uint valorDaFicha = 0.1 ether;
    address payable winner;
    
    
    event TotalGanho(address winner);
    event FichaComprada(address comprador, uint quant);
    
    constructor() {
        winner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "Somente o dono do contrato pode executar essa funcao!");
        _;
    }
    
    function retirarPremio() external onlyOwner {
        require(msg.sender == winner);
        winner.transfer(address(this).balance / 2);
    }
    
    function comprarFicha(uint _quant) public payable {
        require(msg.value == _quant * valorDaFicha);
        
        for(uint i = 0; i < _quant; i++) {
            fichas.push(msg.sender);
            fichaPessoa[msg.sender]++;
        }
        emit FichaComprada(msg.sender, _quant);
    }
    
    function totalGanho() public onlyOwner {
        require(fichas.length >= 1);
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % (fichas.length + 1);
        winner == payable(fichas[random]);
        emit TotalGanho(winner);
    }

    function verPremio() public view returns (uint) {
        return fichas.length * valorDaFicha;
    }
    
    function verPrecoFicha() public view returns (uint) {
        return 10000000;
    }
    
    function isOwner() public view returns (bool) {
        if (msg.sender == owner) {
            return true;
        }
        return false;
    }
}