dono: address

struct Investidor :
  sender: address
  value: uint256
Investidores: HashMap[int128, Investidor]
total: uint256

BURN_ADDR: constant(address) = 0x000000000000000000000000000000000000dEaD

contador_investidores: int128

tempoLimite: public(uint256)

objetivo: public(uint256)


@external
def __init__(_dono: address, _meta: uint256, _tempoEmSegundos: uint256):
    self.dono = _dono
    self.tempoLimite = block.timestamp + _tempoEmSegundos
    self.objetivo = _meta


@external
@payable
def investir():
    assert block.timestamp < self.tempoLimite, " Chegou tarde" 

    id_investidor: int128 = self.contador_investidores
    
    #self.total = self.total + msg.value

    self.Investidores[id_investidor] = Investidor({sender: msg.sender, value: msg.value})
    self.contador_investidores = id_investidor


@external
def terminar():
    assert block.timestamp >= self.tempoLimite, "nao acabou ainda"
    assert self.balance >= self.objetivo, "nao temos dinheiro o suficiente "
    
    send(self.dono, self.balance)
    self.dono = BURN_ADDR

@external
def reembolsar(_id: int128):
    assert block.timestamp >= self.tempoLimite and self.balance < self.objetivo, "Ta muito exaltado~" 

    assert self.Investidores[_id].value > 0, "O Investidor nao possui saldo" 
    
    send(self.Investidores[_id].sender, self.Investidores[_id].value)
    
    self.Investidores[_id] = empty(Investidor)
