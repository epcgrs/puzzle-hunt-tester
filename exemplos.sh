#!/bin/bash
# 📚 Exemplos de Uso do Puzzle Entropy Tester

echo "🎯 EXEMPLOS DE USO"
echo "=================="
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}1. TESTE RÁPIDO (100k tentativas - ~0.1 segundo)${NC}"
echo "   Testa números de 0 a 100.000"
echo ""
echo -e "${GREEN}cargo run --release --bin bruteforce -- \\${NC}"
echo -e "${GREEN}  -t 0x5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5 \\${NC}"
echo -e "${GREEN}  -s 0 -e 100000${NC}"
echo ""

echo -e "${BLUE}2. TESTE MÉDIO (1 milhão - ~1 segundo)${NC}"
echo "   Testa números de 0 a 1.000.000"
echo ""
echo -e "${GREEN}cargo run --release --bin bruteforce -- \\${NC}"
echo -e "${GREEN}  -t 0x5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5 \\${NC}"
echo -e "${GREEN}  -s 0 -e 1000000${NC}"
echo ""

echo -e "${BLUE}3. TESTE FULL 32 BITS (4.3 bilhões - ~5-10 minutos)${NC}"
echo "   Testa TODOS os números de 32 bits"
echo ""
echo -e "${GREEN}cargo run --release --bin bruteforce -- \\${NC}"
echo -e "${GREEN}  -t 0x5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5${NC}"
echo ""

echo -e "${BLUE}4. DIVIDIR ENTRE 2 MÁQUINAS${NC}"
echo ""
echo -e "${YELLOW}   # Máquina 1: primeira metade${NC}"
echo -e "${GREEN}   cargo run --release --bin bruteforce -- \\${NC}"
echo -e "${GREEN}     -t <hash> -s 0 -e 2147483647${NC}"
echo ""
echo -e "${YELLOW}   # Máquina 2: segunda metade${NC}"
echo -e "${GREEN}   cargo run --release --bin bruteforce -- \\${NC}"
echo -e "${GREEN}     -t <hash> -s 2147483648 -e 4294967295${NC}"
echo ""

echo -e "${BLUE}5. TESTAR HASH CONHECIDO${NC}"
echo "   Hash do número '123456789'"
echo ""
echo -e "${GREEN}cargo run --release --bin bruteforce -- \\${NC}"
echo -e "${GREEN}  -t 0x8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92 \\${NC}"
echo -e "${GREEN}  -s 0 -e 200000000${NC}"
echo ""

echo "💡 DICA: Sempre use --release para performance 10x melhor!"
echo ""

