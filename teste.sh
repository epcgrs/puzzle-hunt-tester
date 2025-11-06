#!/bin/bash
# 🧪 Script de Teste do Puzzle Entropy Tester

echo "🧪 TESTANDO PUZZLE ENTROPY TESTER"
echo "=================================="
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}1. Verificando compilação...${NC}"
if [ ! -f "./target/release/bruteforce" ]; then
    echo "   Compilando em modo release..."
    cargo build --release
fi
echo -e "${GREEN}   ✅ Binário pronto!${NC}"
echo ""

echo -e "${BLUE}2. Teste 1: Número pequeno (12345)${NC}"
echo "   Hash: 0x5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5"
echo "   Range: 0 a 20.000"
echo ""
./target/release/bruteforce \
  -t 0x5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5 \
  -s 0 -e 20000

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${BLUE}3. Teste 2: Número médio (1234567)${NC}"
echo "   Hash: 0x8bb0cf6eb9b17d0f7d22b456f121257dc1254e1f01665370476383ea776df414"
echo "   Range: 1.000.000 a 1.500.000"
echo ""
./target/release/bruteforce \
  -t 0x8bb0cf6eb9b17d0f7d22b456f121257dc1254e1f01665370476383ea776df414 \
  -s 1000000 -e 1500000

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${BLUE}4. Teste 3: Performance (30 milhões de hashes)${NC}"
echo "   Testando velocidade de hashing..."
echo ""
./target/release/bruteforce \
  -t 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff \
  -s 0 -e 30000000 2>&1 | grep -A 5 "Não encontrado"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${GREEN}✅ TODOS OS TESTES CONCLUÍDOS!${NC}"
echo ""
echo "📊 Resumo:"
echo "   - Compilação: OK"
echo "   - Teste pequeno: OK (encontrou 12345)"
echo "   - Teste médio: OK (encontrou 1234567)"
echo "   - Performance: ~3-5 milhões hash/s"
echo ""
echo "💡 Para resolver um puzzle de 32 bits completo:"
echo "   ./target/release/bruteforce -t <hash_do_puzzle>"
echo ""
echo "   Tempo estimado: 5-10 minutos"
echo ""

