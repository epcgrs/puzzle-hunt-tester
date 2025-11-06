# ⚡ Quick Start - Puzzle Entropy Tester

## 🚀 Início Rápido (5 minutos)

### 1. Compilar o Projeto

```bash
cd puzzle-entropy-tester
cargo build --release
```

**Tempo**: ~20 segundos

### 2. Testar Funcionalidade Básica

```bash
# Teste rápido (hash do número 12345)
./target/release/bruteforce \
  -t 0x5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5 \
  -s 0 -e 20000
```

**Resultado esperado**: Encontra `12345` em menos de 1 segundo!

### 3. Rodar Suite de Testes Completa

```bash
./test_wordlist_puzzles.sh
```

**Resultado esperado**: 4/4 testes passando!

## 🎯 Resolver Um Puzzle Real

### Cenário: Alguém publicou um puzzle

```
Hash: 0x8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
Prize: 0.1 L-BTC
Dica: "Um número de 32 bits"
```

### Passo 1: Rodar o Bruteforce

```bash
./target/release/bruteforce \
  -t 0x8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
```

### Passo 2: Aguardar 5-10 minutos

A barra de progresso mostra:
- Posição atual
- Porcentagem completa
- Hash/s (velocidade)
- ETA (tempo estimado)

### Passo 3: Copiar o Secret Encontrado

Quando encontrar, o output será:

```
✅ ENCONTRADO!
   Secret: 123456789
   Tentativas: 123456789
   Tempo: 412.5s (6.9 min)
   Taxa: 7356421 hash/s

💡 Use este comando para resolver o puzzle:
   cargo run --bin solve-puzzle -- puzzle_*.json "123456789" <seu_endereco>
```

### Passo 4: Resolver o Puzzle no Projeto Original

```bash
cd ../simplicity-puzzle-hunt

# Obter endereço para receber o prêmio
./elements-cli getnewaddress

# Resolver o puzzle com o secret encontrado
cargo run --bin solve-puzzle -- \
  puzzle_8d969eef.json \
  "123456789" \
  tex1q...seu_endereco
```

### Passo 5: 🎉 Ganhar o Prêmio!

## 📊 Casos de Uso

### Caso 1: Teste Rápido (Números Pequenos)

```bash
# Testar primeiros 1 milhão (~1 segundo)
./target/release/bruteforce -t <hash> -s 0 -e 1000000
```

### Caso 2: Full 32 bits (Padrão)

```bash
# Testar todos os 4.3 bilhões (~7-10 minutos)
./target/release/bruteforce -t <hash>
```

### Caso 3: Dividir Entre 2 Máquinas

```bash
# Máquina 1: primeira metade (~3-5 minutos)
./target/release/bruteforce -t <hash> -s 0 -e 2147483647

# Máquina 2: segunda metade (~3-5 minutos)
./target/release/bruteforce -t <hash> -s 2147483648 -e 4294967295
```

### Caso 4: Dividir Entre 4 Máquinas

```bash
# Máquina 1: 0-25% (~2 minutos)
./target/release/bruteforce -t <hash> -s 0 -e 1073741823

# Máquina 2: 25-50% (~2 minutos)
./target/release/bruteforce -t <hash> -s 1073741824 -e 2147483647

# Máquina 3: 50-75% (~2 minutos)
./target/release/bruteforce -t <hash> -s 2147483648 -e 3221225471

# Máquina 4: 75-100% (~2 minutos)
./target/release/bruteforce -t <hash> -s 3221225472 -e 4294967295
```

## 🧪 Testar com Wordlist

### Gerar Nova Wordlist

```bash
./generate_test_puzzles.sh
```

Isso cria `test_puzzles/wordlist_puzzles.txt` com 20 palavras convertidas em números.

### Ver a Wordlist

```bash
cat test_puzzles/wordlist_puzzles.txt
```

### Testar Manualmente um da Lista

```bash
# Exemplo: "lightning" = número 31158699
./target/release/bruteforce \
  -t 0x2fcafda3779b1fe109e59eb3b3961d191c6e74b0defe0c345f485dd9338f867f \
  -s 28000000 \
  -e 35000000
```

## 💡 Dicas

### ✅ Sempre use `--release`

```bash
# ❌ Lento (10x mais lento)
cargo run --bin bruteforce -- -t <hash>

# ✅ Rápido
cargo run --release --bin bruteforce -- -t <hash>

# ⚡ Mais rápido ainda (binário direto)
./target/release/bruteforce -t <hash>
```

### ✅ Ajustar Threads

```bash
# Usar todas CPUs (padrão - recomendado)
./target/release/bruteforce -t <hash>

# Limitar threads (deixar CPU livre)
./target/release/bruteforce -t <hash> -j 4

# Máxima performance
./target/release/bruteforce -t <hash> -j 32
```

### ✅ Monitorar Progresso

A barra de progresso mostra:
```
[████████░░░░░░░░] 2847382847/4294967296 (66%) | 7.2M/s | ETA: 3m 15s
```

- **Posição**: 2.847.382.847 tentativas
- **Percentual**: 66% completo
- **Velocidade**: 7.2 milhões hash/s
- **ETA**: 3 minutos e 15 segundos restantes

## 📚 Documentação Adicional

- `README.md` - Documentação completa
- `RESUMO.md` - Guia rápido de referência
- `CHANGELOG.md` - Histórico de mudanças
- `test_puzzles/README_TESTES.md` - Resultados dos testes

## 🆘 Troubleshooting

### Erro: "bruteforce not found"

```bash
# Compilar novamente
cargo build --release
```

### Performance baixa

```bash
# Verificar se está usando --release
cargo build --release

# Usar binário direto (mais rápido)
./target/release/bruteforce -t <hash>
```

### Não encontra o secret

```bash
# Verificar se o hash está correto
# Verificar se o range inclui o número correto
# Para 32 bits, sempre use range completo (padrão)
./target/release/bruteforce -t <hash>
```

## ✨ Resumo

1. **Compilar**: `cargo build --release`
2. **Testar**: `./test_wordlist_puzzles.sh`
3. **Resolver puzzle**: `./target/release/bruteforce -t <hash>`
4. **Aguardar**: 5-10 minutos
5. **Ganhar**: Use o secret no solve-puzzle! 🎉

---

**Divirta-se quebrando puzzles!** 🚀

