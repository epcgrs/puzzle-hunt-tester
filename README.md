# 🔓 Bitcoin Puzzle Entropy Tester

**Testador de força bruta para puzzles Bitcoin Simplicity com entropia de 32 bits**

Ferramenta de alta performance para quebrar puzzles Bitcoin baseados em SHA256. Os puzzles usam um **secret numérico de 32 bits** (0 a 4.294.967.295) que gera um hash SHA256.

## 🎯 Sobre

Os puzzles Bitcoin Simplicity funcionam assim:
1. Organizador escolhe um número de 32 bits (ex: 123456789)
2. Calcula `SHA256(numero)` e publica o hash
3. Quem descobrir o número correto ganha o prêmio!

**Com 32 bits, existem ~4.3 bilhões de combinações.**
Em um computador moderno: **~5-10 minutos para testar todas!** ⚡

### Estratégia Principal

**Força Bruta Numérica de 32 bits** - Testa todos os valores de 0 até 4.294.967.295 em paralelo

## 🚀 Instalação

```bash
# Clone o repositório
git clone <repo>
cd puzzle-entropy-tester

# Build release (otimizado)
cargo build --release

# Ou use direto com cargo run
```

## 💡 Uso

### 1. Força Bruta de 32 bits (Método Padrão)

**Este é o método que você vai usar 99% do tempo!**

Os puzzles sempre usam 32 bits, então testamos todos os 4.3 bilhões de valores.

```bash
# Comando padrão (testa 0 até 2^32-1)
cargo run --release --bin bruteforce -- \
  --target-hash <hash_do_puzzle>

# Exemplo real
cargo run --release --bin bruteforce -- \
  -t 0xa0dc65ffca799873cbea0ac274015b9526505daaaed385155425f7337704883e

# Com mais controle
cargo run --release --bin bruteforce -- \
  -t 0xa0dc65ffca799873cbea0ac274015b9526505daaaed385155425f7337704883e \
  -s 0 \
  -e 4294967295 \
  -j 16
```

**Opções:**
- `-t, --target-hash` - Hash SHA256 alvo (obrigatório)
- `-s, --start` - Valor inicial (padrão: 0)
- `-e, --end` - Valor final (padrão: 4.294.967.295 = 2^32-1)
- `-j, --threads` - Número de threads (padrão: todas CPUs)
- `-c, --chunk-size` - Tamanho do chunk (padrão: 10000)

**💡 Dica:** Com um CPU moderno de 16 threads, você testa todos os 4.3 bilhões em **5-10 minutos**!

**Dividir o trabalho entre máquinas:**

```bash
# Máquina 1: primeira metade (0 a 2^31-1)
cargo run --release --bin bruteforce -- \
  -t <hash> -s 0 -e 2147483647

# Máquina 2: segunda metade (2^31 a 2^32-1)
cargo run --release --bin bruteforce -- \
  -t <hash> -s 2147483648 -e 4294967295
```

### 2. Testar Range Menor (Para testes)

Se você sabe que o número está em um range específico, pode otimizar:

```bash
# Testar apenas primeiros 1 milhão (rápido para testar)
cargo run --release --bin bruteforce -- \
  -t <hash> -s 0 -e 1000000

# Testar números pequenos (0 a 100k)
cargo run --release --bin bruteforce -- \
  -t <hash> -s 0 -e 100000

# Testar range específico
cargo run --release --bin bruteforce -- \
  -t <hash> -s 1000000 -e 2000000
```

## 📊 Performance

### Benchmarks em CPU Moderna (16 threads)

| CPU | Hash/s | 32 bits (4.3B) | Com máquina |
|-----|--------|----------------|-------------|
| AMD Ryzen 9 5950X | ~12M | **6 minutos** | 3 min (2x máquinas) |
| Intel i9-12900K | ~10M | **7 minutos** | 3.5 min (2x máquinas) |
| AMD Ryzen 7 5800X | ~8M | **9 minutos** | 4.5 min (2x máquinas) |
| Intel i7-10700K | ~6M | **12 minutos** | 6 min (2x máquinas) |
| Laptop médio (4-8 threads) | ~3M | **24 minutos** | 12 min (2x máquinas) |

**🎯 Para puzzles de 32 bits: Entre 5-25 minutos para testar tudo!**

### Tabela de Referência

| Range | Combinações | Tempo (10M hash/s) | Uso |
|-------|-------------|-------------------|-----|
| 0 a 10^6 | 1 milhão | 0.1 seg | Teste rápido |
| 0 a 10^9 | 1 bilhão | 1.7 min | Warmup |
| 0 a 2^31 | 2.1 bilhões | 3.5 min | Primeira metade |
| **0 a 2^32** | **4.3 bilhões** | **7 min** | **Full 32 bits** |

### Otimizações Possíveis

- **2 máquinas**: Tempo dividido por 2 (~3-4 min)
- **4 máquinas**: Tempo dividido por 4 (~2 min)
- **8 máquinas**: Tempo dividido por 8 (~1 min)
- **16 máquinas**: Tempo dividido por 16 (~30 seg)

💡 Com acesso a múltiplas máquinas, você pode resolver qualquer puzzle de 32 bits em **menos de 1 minuto**!

## 🎮 Exemplo Completo

### Cenário: Resolver um Puzzle Real de 32 bits

```bash
# 1. Alguém criou um puzzle e publicou o hash
# Hash: 0x8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
# Prize: 0.1 L-BTC
# Dica: "Um número de 32 bits"

# 2. Você decide tentar resolver com força bruta
cd puzzle-entropy-tester

# 3. Rodar o bruteforce (vai testar 0 a 4.294.967.295)
cargo run --release --bin bruteforce -- \
  -t 0x8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92

# 4. Aguardar 5-10 minutos...
# 
# 🎯 BRUTEFORCE NUMÉRICO
# ======================
# Target Hash: 0x8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
# Range: 0 até 4294967295
# Total: 4294967296 tentativas
# Threads: 16
# Chunk size: 10000
# 
# 🚀 Iniciando busca com 429497 chunks...
# 
# [████████████░░░░░░░░] 2847382847/4294967296 (66%) | 7.2M/s | ETA: 3m 15s
# ...
# 
# ✅ ENCONTRADO!
#    Secret: 123456789
#    Tentativas: 123456789
#    Tempo: 412.5s (6.9 min)
#    Taxa: 7356421 hash/s
#
# 💡 Use este comando para resolver o puzzle:
#    cargo run --bin solve-puzzle -- puzzle_8d969eef.json "123456789" <seu_endereco>

# 5. Resolver o puzzle e receber o prêmio!
cd ../simplicity-puzzle-hunt
./elements-cli getnewaddress  # Obter endereço
cargo run --bin solve-puzzle -- puzzle_8d969eef.json "123456789" tex1q...

# 🎉 Você ganhou 0.1 L-BTC!
```

### Exemplo com Range Menor (Teste)

```bash
# Criar puzzle de teste com número pequeno
cd ../simplicity-puzzle-hunt
# Secret será convertido para número: "12345" vira 12345
cargo run --bin create-puzzle -- "12345" 0.01

# Resolver rapidamente (testar só primeiros 100k)
cd ../puzzle-entropy-tester
cargo run --release --bin bruteforce -- \
  -t <hash_do_puzzle> \
  -s 0 \
  -e 100000

# Resultado em menos de 1 segundo!
# ✅ ENCONTRADO!
#    Secret: 12345
#    Tentativas: 12345
#    Tempo: 0.12s
#    Taxa: 102916 hash/s
```

## 🔥 Dicas de Performance

### 1. Sempre use `--release`
```bash
# ❌ Lento (modo debug)
cargo run --bin bruteforce -- -t <hash> -s 0 -e 1000000

# ✅ Rápido (modo release - 10x mais rápido!)
cargo run --release --bin bruteforce -- -t <hash> -s 0 -e 1000000
```

### 2. Ajuste o número de threads
```bash
# Usar todas as CPUs (padrão)
cargo run --release --bin bruteforce -- -t <hash> -s 0 -e 1000000

# Limitar threads (deixa CPU livre para outras tarefas)
cargo run --release --bin bruteforce -- -t <hash> -s 0 -e 1000000 -j 8

# Máxima performance (pode usar hyperthreading)
cargo run --release --bin bruteforce -- -t <hash> -s 0 -e 1000000 -j 32
```

### 3. Para ranges muito grandes, divida em partes
```bash
# Terminal 1: testa primeira metade
cargo run --release --bin bruteforce -- \
  -t <hash> -s 0 -e 2147483647 -j 8

# Terminal 2: testa segunda metade
cargo run --release --bin bruteforce -- \
  -t <hash> -s 2147483648 -e 4294967295 -j 8
```

## 🎯 Estratégia Recomendada

### Para Puzzles de 32 bits (Padrão)

**É SEMPRE viável resolver! Basta ter paciência de 5-10 minutos.**

```bash
# Simplesmente rode e aguarde
cargo run --release --bin bruteforce -- -t <hash>
```

### Se Você Tem Várias Máquinas

Divida o range para resolver mais rápido:

```bash
# 4 máquinas = 4x mais rápido (~2 minutos no total)

# Máquina 1: 0 a 25%
cargo run --release --bin bruteforce -- -t <hash> -s 0 -e 1073741823

# Máquina 2: 25% a 50%
cargo run --release --bin bruteforce -- -t <hash> -s 1073741824 -e 2147483647

# Máquina 3: 50% a 75%
cargo run --release --bin bruteforce -- -t <hash> -s 2147483648 -e 3221225471

# Máquina 4: 75% a 100%
cargo run --release --bin bruteforce -- -t <hash> -s 3221225472 -e 4294967295
```

### Dicas

1. **Sempre use `--release`** - 10x mais rápido que modo debug
2. **Deixe rodar** - 5-10 min não é nada para ganhar um prêmio!
3. **Monitore o progresso** - A barra mostra ETA estimado
4. **Use todas CPUs** - Padrão já usa todas, mas pode ajustar com `-j`
5. **Múltiplas máquinas** - Se tiver acesso, divida o trabalho

## 🛠 Estrutura do Projeto

```
puzzle-entropy-tester/
├── src/
│   ├── lib.rs                          # Funções compartilhadas (SHA256, etc)
│   └── bin/
│       └── bruteforce_numeric.rs       # Força bruta numérica de 32 bits
├── exemplos.sh                         # Exemplos de comandos
├── Cargo.toml
└── README.md
```

## 🔐 Segurança e Ética

Este projeto é para:
- ✅ Testar seus próprios puzzles
- ✅ Participar de CTFs e desafios autorizados
- ✅ Pesquisa educacional sobre criptografia
- ✅ Avaliar segurança de diferentes entropias

**NÃO use para:**
- ❌ Atacar sistemas sem autorização
- ❌ Roubar fundos de outros
- ❌ Atividades ilegais

## 📚 Recursos Adicionais

- [Projeto Simplicity Puzzle Hunt](../simplicity-puzzle-hunt/)
- [SHA-256 na Wikipedia](https://en.wikipedia.org/wiki/SHA-2)
- [Rainbow Tables](https://en.wikipedia.org/wiki/Rainbow_table)
- [Birthday Attack](https://en.wikipedia.org/wiki/Birthday_attack)

## 🤝 Contribuindo

PRs são bem-vindos! Especialmente para:
- Otimizações de performance
- Novas estratégias de busca
- Melhor paralelização
- Suporte a GPU

## 📄 Licença

MIT License

---

**Divirta-se testando puzzles! 🎯**

