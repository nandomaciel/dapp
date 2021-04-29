pragma solidity ^0.5.0;

import "./Owned.sol";

contract Vegas {
    
    address owner;
    mapping(address => uint) fichaPessoa;
    mapping(address => uint) ganhos;
    mapping(address => uint) percas;
    string situacao;
    uint valorDaFicha = 0.1 ether;
    bool status = false;
    
    event FichaComprada(address comprador, uint quant);
    event FichasApostadas(address apostador, uint quant, string situacao);
    
    
    function comprarFicha(uint _quant) public payable {
        require(msg.value == _quant * valorDaFicha, 'Valor Digitado não corresponde');
        
        fichaPessoa[msg.sender] += _quant;
        ganhos[msg.sender] += fichaPessoa[msg.sender];
        emit FichaComprada(msg.sender, _quant);
    }
    
    function apostarFichas(uint _quant) public returns (uint, uint, uint) {
        require(_quant > 0, 'Aposte um valor positivo maior que zero!');
        require(fichaPessoa[msg.sender] > 0, 'Você não possui fichas');
        require(fichaPessoa[msg.sender] >= _quant, 'Você não possui fichas suficientes');
        
        status = false;
        
        fichaPessoa[msg.sender] = fichaPessoa[msg.sender] - _quant;
        
        uint first_number = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        first_number = first_number % 3;
        
        uint second_number = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
        second_number = second_number % 3;
        
        uint third_number = uint(keccak256(abi.encodePacked(block.timestamp, now)));
        third_number = third_number % 3;
        
        if(first_number == second_number && first_number == third_number){
            ganhouFichas(_quant);
            status = true; // teste
        }else{
            percas[msg.sender] += _quant;
        }
        
        if(status == true){
            situacao = "Ganhou! :)";
        }else{
            situacao = "Perdeu! :(";
        }
        
        emit FichasApostadas(msg.sender, _quant, situacao);
        
        return (first_number, second_number, third_number);
        
    }
    
    function returnBool() public view returns(bool){ // teste
        return status;
    }
    
    function ganhouFichas(uint multiplicador) private {
        ganhos[msg.sender] = ganhos[msg.sender] * 2 * multiplicador;
    }
    
    function verGanhos() public view returns (uint) {
        return ganhos[msg.sender];
    }
    
    function verPercas() public view returns (uint) {
        return percas[msg.sender]; 
    }
    
    function verMinhasFichas() public view returns (uint) {
        return fichaPessoa[msg.sender];
    }
    
    function situacaoAtual() public view returns (uint){
        return (ganhos[msg.sender] - percas[msg.sender]);
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