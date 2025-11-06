# 🎯 Resumo Rápido - Puzzle Entropy Tester

## O Que É?

Testador de força bruta para puzzles Bitcoin Simplicity de **32 bits**.

## Por Que Funciona?

- Puzzles usam um número de 0 a 4.294.967.295 (32 bits)
- Em um PC moderno: **5-10 minutos** para testar todos!
- Com múltiplas máquinas: **menos de 1 minuto**

## Instalação

```bash
cd puzzle-entropy-tester
cargo build --release
```

## Uso Básico

```bash
# Resolver qualquer puzzle de 32 bits
cargo run --release --bin bruteforce -- -t <hash_do_puzzle>

# Aguardar 5-10 minutos e ganhar o prêmio! 🎉
```

## Uso Avançado

### Teste Rápido (números pequenos)
```bash
cargo run --release --bin bruteforce -- -t <hash> -s 0 -e 1000000
```

### Dividir Entre 2 Máquinas
```bash
# Máquina 1: primeira metade (0 a 2^31-1)
cargo run --release --bin bruteforce -- -t <hash> -s 0 -e 2147483647

# Máquina 2: segunda metade (2^31 a 2^32-1)
cargo run --release --bin bruteforce -- -t <hash> -s 2147483648 -e 4294967295
```

### Dividir Entre 4 Máquinas (~2 minutos)
```bash
# Máquina 1: 0 a 25%
cargo run --release --bin bruteforce -- -t <hash> -s 0 -e 1073741823

# Máquina 2: 25% a 50%
cargo run --release --bin bruteforce -- -t <hash> -s 1073741824 -e 2147483647

# Máquina 3: 50% a 75%
cargo run --release --bin bruteforce -- -t <hash> -s 2147483648 -e 3221225471

# Máquina 4: 75% a 100%
cargo run --release --bin bruteforce -- -t <hash> -s 3221225472 -e 4294967295
```

## Performance Esperada

| CPU | Hash/s | Tempo Total (32 bits) |
|-----|--------|-----------------------|
| AMD Ryzen 9 5950X | ~12M | 6 minutos |
| Intel i9-12900K | ~10M | 7 minutos |
| AMD Ryzen 7 5800X | ~8M | 9 minutos |
| Intel i7-10700K | ~6M | 12 minutos |
| Laptop médio | ~3M | 24 minutos |

## Dicas Importantes

1. ✅ **SEMPRE use `--release`** (10x mais rápido)
2. ✅ Deixe rodar - 5-10 min vale o prêmio
3. ✅ Use todas as CPUs (padrão)
4. ✅ Múltiplas máquinas = muito mais rápido

## Exemplo Completo

```bash
# 1. Alguém publicou um puzzle:
#    Hash: 0x8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
#    Prize: 0.1 L-BTC

# 2. Você tenta resolver:
cd puzzle-entropy-tester
cargo run --release --bin bruteforce -- \
  -t 0x8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92

# 3. Aguardar 5-10 minutos...
# ✅ ENCONTRADO! Secret: 123456789

# 4. Resolver o puzzle:
cd ../simplicity-puzzle-hunt
cargo run --bin solve-puzzle -- puzzle_*.json "123456789" <seu_endereco>

# 5. 🎉 Você ganhou 0.1 L-BTC!
```

## Comandos Úteis

```bash
# Ver exemplos
./exemplos.sh

# Testar compilação
cargo check

# Build otimizado
cargo build --release

# Executar diretamente (mais rápido)
./target/release/bruteforce -t <hash>
```

---

**Para mais detalhes, veja o [README.md](README.md) completo!**

