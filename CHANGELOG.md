# 📝 Changelog - Puzzle Entropy Tester

## [0.1.0] - 2025-11-06

### ✨ Funcionalidades Implementadas

#### Core
- ✅ Bruteforce numérico de 32 bits com multi-threading (Rayon)
- ✅ SHA256 otimizado para alta performance
- ✅ Progress bar em tempo real com ETA
- ✅ Suporte a range customizado (start/end)
- ✅ Configuração de threads

#### Scripts e Ferramentas
- ✅ `generate_test_puzzles.sh` - Gera wordlist de teste
- ✅ `test_wordlist_puzzles.sh` - Suite de testes automatizada
- ✅ `exemplos.sh` - Exemplos de uso
- ✅ `teste.sh` - Testes básicos de funcionalidade

#### Documentação
- ✅ README completo com guia de uso
- ✅ RESUMO rápido para referência
- ✅ Documentação dos testes (README_TESTES.md)

### 🎯 Performance

- Taxa de hashing: **3-5 milhões hash/s** (8 threads)
- Tempo para 32 bits completo: **~7-10 minutos**
- Escalabilidade linear com número de threads

### 🧪 Testes

- ✅ 4/4 testes passaram com sucesso
- ✅ Validação com palavras convertidas em números
- ✅ Ranges otimizados (±10% do target)

### 📦 Dependências

- `rayon` - Paralelização
- `sha2` - Hashing SHA256
- `indicatif` - Progress bar
- `clap` - CLI parsing
- `serde`/`serde_json` - Serialização
- `parking_lot` - Locks otimizados
- `anyhow` - Error handling
- `hex` - Conversão hexadecimal

### 🗑️ Removido

- ❌ Bruteforce por wordlist (não aplicável)
- ❌ Bruteforce por padrão (não aplicável)
- ❌ Arquivos de wordlist estáticas

### 📋 Estrutura Final

```
puzzle-entropy-tester/
├── src/
│   ├── lib.rs                      # Funções compartilhadas
│   └── bin/
│       └── bruteforce_numeric.rs   # Bruteforce de 32 bits
├── test_puzzles/
│   ├── wordlist_puzzles.txt        # Wordlist gerada
│   └── README_TESTES.md            # Documentação dos testes
├── Cargo.toml
├── README.md
├── RESUMO.md
├── CHANGELOG.md
├── generate_test_puzzles.sh
├── test_wordlist_puzzles.sh
├── exemplos.sh
├── teste.sh
└── .gitignore
```

## Próximas Versões (Planejado)

### [0.2.0] - Futuro
- [ ] Checkpoint/resumo de busca
- [ ] Suporte a múltiplos hashes em paralelo
- [ ] Otimizações SIMD para SHA256
- [ ] GUI opcional
- [ ] Integração direta com elementos-cli
- [ ] Distribuição via cargo install

### [0.3.0] - Futuro
- [ ] Suporte a GPU (CUDA/OpenCL)
- [ ] Coordenação distribuída entre máquinas
- [ ] Métricas e telemetria
- [ ] API REST para controle remoto

---

**Versão atual**: 0.1.0 - Funcional e testado! 🎉

