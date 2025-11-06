# 🧪 Testes de Puzzles com Wordlist

## 📋 Metodologia do Teste

Este teste valida que o bruteforce consegue quebrar puzzles onde o secret é derivado de palavras.

### Processo:

1. **Palavra → Número de 32 bits**
   - Pegar uma palavra (ex: "bitcoin")
   - Calcular SHA256 da palavra
   - Extrair primeiros 4 bytes (32 bits) como número decimal
   - Este é o **secret**

2. **Número → Hash Alvo**
   - Converter o número para string
   - Calcular SHA256(numero_string)
   - Este é o **target hash** do puzzle

3. **Bruteforce**
   - Tentar encontrar o número que gera o hash alvo
   - Testar range de ±10% do número real

## 📊 Resultados dos Testes

### ✅ Teste 1: "lightning"
- **Palavra**: lightning
- **Secret derivado**: 31.158.699
- **Hash alvo**: `0x2fcafda3779b1fe109e59eb3b3961d191c6e74b0defe0c345f485dd9338f867f`
- **Range testado**: 28.042.830 a 34.274.568 (±10%)
- **Resultado**: ✅ **ENCONTRADO em 1.49s**
- **Tentativas**: 6.204.078
- **Taxa**: 4.176.921 hash/s

### ✅ Teste 2: "taproot"
- **Palavra**: taproot
- **Secret derivado**: 148.329.247
- **Hash alvo**: `0xe4b0b67be6550369cac7976e90c949cb37ddc14e8adfce3d510efee25ff694dc`
- **Range testado**: 133.496.323 a 163.162.171 (±10%)
- **Resultado**: ✅ **ENCONTRADO em 0.01s**
- **Tentativas**: 42.866
- **Taxa**: 3.564.632 hash/s

### ✅ Teste 3: "mining"
- **Palavra**: mining
- **Secret derivado**: 711.794.821
- **Hash alvo**: `0xbc59a12dcb578fe983ba7bbf95e09556f5794b8cfcec72a2bcbb6813aa157afd`
- **Range testado**: 640.615.339 a 782.974.303 (±10%)
- **Resultado**: ✅ **ENCONTRADO em 34.07s**
- **Tentativas**: 140.017.387
- **Taxa**: 4.110.070 hash/s

### ✅ Teste 4: "liquid"
- **Palavra**: liquid
- **Secret derivado**: 1.108.410.722
- **Hash alvo**: `0x7eed405263aae2ec6f4ca6211f64d7e1bef368d7c8ad1397ff20582d508dc26e`
- **Range testado**: 997.569.650 a 1.219.251.794 (±10%)
- **Resultado**: ✅ **ENCONTRADO em 0.00s**
- **Tentativas**: 7.569
- **Taxa**: 3.054.434 hash/s

## 📈 Estatísticas Globais

- **Total de testes**: 4
- **Sucessos**: 4 (100%)
- **Falhas**: 0
- **Taxa média**: ~3.7 milhões hash/s
- **Tempo total**: ~35.6 segundos

## 🎯 Conclusões

1. ✅ **O bruteforce funciona perfeitamente** para encontrar secrets de 32 bits
2. ✅ **Performance consistente** em ~3-4 milhões hash/s
3. ✅ **Viável para ranges específicos** (±10% encontra em segundos)
4. ✅ **Para 32 bits completo**: 4.3 bilhões ÷ 4M/s = **~18 minutos**

## 📝 Wordlist Completa Gerada

Veja `wordlist_puzzles.txt` para a lista completa de 20 palavras e seus hashes.

### Exemplos da wordlist:

| Palavra | Secret (32-bit) | Hash Alvo |
|---------|-----------------|-----------|
| bitcoin | 1.804.124.295 | 0xfb7bba17dd0728ff... |
| satoshi | 3.660.084.915 | 0x1f9c10d3a53744b9... |
| hodl | 2.008.623.617 | 0xf8752392bd7fc990... |
| moon | 2.658.710.590 | 0xcfb3074bdc1bbc22... |

## 🚀 Como Usar

### Gerar nova wordlist:
```bash
./generate_test_puzzles.sh
```

### Rodar todos os testes:
```bash
./test_wordlist_puzzles.sh
```

### Testar manualmente um puzzle:
```bash
./target/release/bruteforce \
  -t 0x2fcafda3779b1fe109e59eb3b3961d191c6e74b0defe0c345f485dd9338f867f \
  -s 28000000 \
  -e 35000000
```

## 💡 Implicações Práticas

Para um puzzle real de 32 bits:
- **Sem dicas**: ~18 minutos para testar tudo (0 a 2^32-1)
- **Com range**: Segundos a minutos (depende do tamanho)
- **Múltiplas máquinas**: Divide tempo proporcionalmente

**Conclusão**: Puzzles de 32 bits são **sempre viáveis** de quebrar!

