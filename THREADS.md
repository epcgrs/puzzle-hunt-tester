# ⚙️ Guia de Configuração de Threads

## 🎯 Como Funciona

O bruteforce detecta automaticamente o número máximo de threads do seu CPU e permite configurá-los para otimizar performance.

## 💻 Detecção Automática

O programa detecta automaticamente as CPUs disponíveis:

```bash
# Usa todas as threads disponíveis (padrão)
./target/release/bruteforce -t <hash>

# Output mostra:
# Threads: 8 / 8 (usando / máximo)
```

## 🔧 Configuração Manual

### Opção 1: Máxima Performance (Todas CPUs)

```bash
# Usa todos os cores disponíveis
./target/release/bruteforce -t <hash>

# Ou explicitamente:
./target/release/bruteforce -t <hash> -j 8
```

**Quando usar:**
- Máxima velocidade
- Máquina dedicada para bruteforce
- Não precisa usar CPU para outras tarefas

**Performance:** ~4-10M hash/s (dependendo do CPU)

### Opção 2: Usar Metade (Balanceado)

```bash
# Se tem 8 cores, usa 4
./target/release/bruteforce -t <hash> -j 4
```

**Quando usar:**
- Quer usar o PC para outras coisas
- Rodar múltiplos bruteforces em paralelo
- Economizar energia/temperatura

**Performance:** ~50% da máxima

### Opção 3: Single-Thread (Baseline)

```bash
# Usa apenas 1 thread
./target/release/bruteforce -t <hash> -j 1
```

**Quando usar:**
- Testar performance single-thread
- Comparar escalabilidade
- Debug

**Performance:** ~1-2M hash/s

### Opção 4: Número Customizado

```bash
# Qualquer número entre 1 e máximo
./target/release/bruteforce -t <hash> -j 2
./target/release/bruteforce -t <hash> -j 6
./target/release/bruteforce -t <hash> -j 12
```

## ⚠️ Validação Automática

Se você solicitar mais threads do que o sistema suporta:

```bash
./target/release/bruteforce -t <hash> -j 32

# Output:
# ⚠️  AVISO: Solicitado 32 threads, mas sistema suporta apenas 8!
#    Usando 8 threads (máximo disponível)
# Threads: 8 / 8 (usando / máximo)
```

## 📊 Comparação de Performance

### CPU com 8 cores (exemplo):

| Threads | Hash/s | Tempo (32 bits) | Uso CPU | Melhor Para |
|---------|--------|-----------------|---------|-------------|
| 1 | ~1M | 72 min | 12.5% | Baseline / Debug |
| 2 | ~2M | 36 min | 25% | Background task |
| 4 | ~4M | 18 min | 50% | Balanceado |
| 8 | ~8M | 9 min | 100% | Máxima velocidade |

### CPU com 16 cores (exemplo):

| Threads | Hash/s | Tempo (32 bits) | Uso CPU | Melhor Para |
|---------|--------|-----------------|---------|-------------|
| 1 | ~1M | 72 min | 6.25% | Baseline |
| 4 | ~4M | 18 min | 25% | Background |
| 8 | ~8M | 9 min | 50% | Balanceado |
| 16 | ~12M | 6 min | 100% | Máxima velocidade |

## 🚀 Script Interativo

O script `test_full_32bit.sh` permite escolher threads interativamente:

```bash
./test_full_32bit.sh
```

**Menu de opções:**

```
⚙️  CONFIGURAÇÃO DE THREADS
━━━━━━━━━━━━━━━━━━━━━━━━━━

Threads disponíveis: 8

Opções:
  1) Usar todas (8 threads) - Máxima performance
  2) Usar metade (4 threads) - Deixa CPU livre
  3) Usar 1 thread - Teste de performance single-thread
  4) Número customizado

Escolha (1-4) [padrão: 1]:
```

## 💡 Recomendações

### Para Resolver Puzzles Reais

```bash
# Usar todas as threads - máxima velocidade
./target/release/bruteforce -t <hash>
```

### Para Múltiplas Máquinas

Se você tem acesso a várias máquinas, divida o range e use todas threads em cada:

```bash
# Máquina 1 (8 threads)
./target/release/bruteforce -t <hash> -s 0 -e 2147483647 -j 8

# Máquina 2 (8 threads)
./target/release/bruteforce -t <hash> -s 2147483648 -e 4294967295 -j 8
```

### Para Testar Performance

Compare diferentes números de threads:

```bash
# Single-thread baseline
time ./target/release/bruteforce -t <hash> -s 0 -e 1000000 -j 1

# Multi-thread
time ./target/release/bruteforce -t <hash> -s 0 -e 1000000 -j 8
```

## 🔍 Detalhes Técnicos

### Escalabilidade

- **Ideal**: Performance escala linearmente com número de threads
- **Real**: ~80-90% de eficiência devido a:
  - Overhead de sincronização
  - Cache sharing
  - Memory bandwidth

### Rayon ThreadPool

O bruteforce usa **Rayon** para paralelização:
- Work-stealing scheduler
- Divide automaticamente o trabalho
- Balanceia carga dinamicamente

### Chunk Size

Por padrão, cada thread processa chunks de 10.000 valores:

```bash
# Ajustar chunk size (geralmente não necessário)
./target/release/bruteforce -t <hash> -c 50000
```

**Chunk menor:** Melhor balanceamento, mais overhead
**Chunk maior:** Menos overhead, pior balanceamento

## 📝 Exemplos Práticos

### Exemplo 1: Máxima Velocidade

```bash
# Usar todos os cores
./target/release/bruteforce \
  -t 0x5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5

# Threads: 8 / 8 (usando / máximo)
# Taxa: ~8M hash/s
# Tempo estimado: 9 minutos
```

### Exemplo 2: Background Task

```bash
# Usar metade das threads
./target/release/bruteforce \
  -t 0x5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5 \
  -j 4

# Threads: 4 / 8 (usando / máximo)
# Taxa: ~4M hash/s
# Tempo estimado: 18 minutos
```

### Exemplo 3: Benchmark

```bash
# Teste 1: Single-thread
time ./target/release/bruteforce -t <hash> -s 0 -e 10000000 -j 1

# Teste 2: Multi-thread
time ./target/release/bruteforce -t <hash> -s 0 -e 10000000 -j 8

# Calcular speedup: tempo_single / tempo_multi
```

## 🎯 Conclusão

- ✅ **Padrão**: Usa todas threads automaticamente
- ✅ **Customizável**: `-j N` para configurar
- ✅ **Validado**: Avisa se solicitar mais que o máximo
- ✅ **Flexível**: Adapta-se a diferentes cenários

**Para máxima performance em puzzles reais: use todas as threads disponíveis!** 🚀

---

Para mais informações, veja `README.md` e `QUICKSTART.md`.

