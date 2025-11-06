#!/bin/bash
# 🎲 Teste de Força Bruta Full 32-bit com Números Aleatórios
# Gera 3 números aleatórios e tenta encontrá-los no range completo (0 a 2^32-1)

echo "🎲 TESTE FULL 32-BIT COM ENTROPIA ALEATÓRIA"
echo "============================================="
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar se bruteforce existe
if [ ! -f "./target/release/bruteforce" ]; then
    echo "❌ Binário não encontrado. Compilando..."
    cargo build --release
fi

# Criar diretório de teste
mkdir -p test_puzzles

OUTPUT="test_puzzles/random_32bit_puzzles.txt"
> "$OUTPUT"

echo "📊 Gerando 3 números aleatórios de 32 bits..."
echo ""

# Gerar 3 números aleatórios
declare -a SECRETS
declare -a HASHES
declare -a POSITIONS

for i in {1..3}; do
    # Gerar número aleatório de 32 bits (0 a 4294967295)
    SECRET=$((RANDOM * RANDOM % 4294967296))
    
    # Calcular hash SHA256 desse número
    HASH="0x$(echo -n "$SECRET" | sha256sum | cut -d' ' -f1)"
    
    # Calcular posição percentual
    POSITION=$(awk "BEGIN {printf \"%.2f\", ($SECRET / 4294967295) * 100}")
    
    SECRETS[$i]=$SECRET
    HASHES[$i]=$HASH
    POSITIONS[$i]=$POSITION
    
    echo "Puzzle $i:" >> "$OUTPUT"
    echo "  Secret: $SECRET" >> "$OUTPUT"
    echo "  Hash:   $HASH" >> "$OUTPUT"
    echo "  Posição: $POSITION% do range" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    
    echo -e "${BLUE}Puzzle $i gerado:${NC}"
    echo "  Secret: $SECRET"
    echo "  Hash: $HASH"
    echo "  Posição: $POSITION% do range (quanto mais próximo de 100%, mais tempo leva)"
    echo ""
done

cat "$OUTPUT"
echo "✅ Puzzles salvos em: $OUTPUT"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Perguntar se quer rodar os testes
echo -e "${YELLOW}⚠️  ATENÇÃO: Os testes rodam no range COMPLETO (0 a 4.294.967.295)${NC}"
echo -e "${YELLOW}   Tempo estimado: 5-25 minutos POR TESTE (depende da posição)${NC}"
echo -e "${YELLOW}   Total estimado: 15-75 minutos para os 3 testes${NC}"
echo ""
read -p "Deseja executar os testes agora? (s/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo ""
    echo "✅ Puzzles gerados mas testes não executados."
    echo ""
    echo "Para testar manualmente:"
    for i in {1..3}; do
        echo "  # Puzzle $i (${POSITIONS[$i]}% do range)"
        echo "  ./target/release/bruteforce -t ${HASHES[$i]}"
        echo ""
    done
    exit 0
fi

echo ""
echo "🚀 INICIANDO TESTES FULL 32-BIT"
echo "================================"
echo ""

# Arrays para resultados
declare -a TIMES
declare -a ATTEMPTS
declare -a RATES

for i in {1..3}; do
    SECRET=${SECRETS[$i]}
    HASH=${HASHES[$i]}
    POSITION=${POSITIONS[$i]}
    
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Teste $i/3: Buscando secret $SECRET${NC}"
    echo -e "${BLUE}Hash: $HASH${NC}"
    echo -e "${BLUE}Posição: $POSITION% do range${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Capturar tempo de início
    START_TIME=$(date +%s)
    
    # Executar bruteforce
    OUTPUT_RESULT=$(./target/release/bruteforce -t "$HASH" 2>&1)
    EXIT_CODE=$?
    
    # Capturar tempo de fim
    END_TIME=$(date +%s)
    ELAPSED=$((END_TIME - START_TIME))
    
    echo "$OUTPUT_RESULT"
    echo ""
    
    # Verificar se encontrou
    if echo "$OUTPUT_RESULT" | grep -q "✅ ENCONTRADO"; then
        FOUND_SECRET=$(echo "$OUTPUT_RESULT" | grep "Secret:" | awk '{print $2}')
        TENTATIVAS=$(echo "$OUTPUT_RESULT" | grep "Tentativas:" | awk '{print $2}')
        TEMPO=$(echo "$OUTPUT_RESULT" | grep "Tempo:" | awk '{print $2}')
        TAXA=$(echo "$OUTPUT_RESULT" | grep "Taxa:" | awk '{print $2}')
        
        TIMES[$i]=$TEMPO
        ATTEMPTS[$i]=$TENTATIVAS
        RATES[$i]=$TAXA
        
        if [ "$FOUND_SECRET" = "$SECRET" ]; then
            echo -e "${GREEN}✅ SUCESSO! Secret correto encontrado!${NC}"
            echo -e "${GREEN}   Tentativas: $TENTATIVAS${NC}"
            echo -e "${GREEN}   Tempo: $TEMPO (${ELAPSED}s real)${NC}"
            echo -e "${GREEN}   Taxa: $TAXA hash/s${NC}"
        else
            echo -e "${RED}❌ Secret incorreto! Esperado: $SECRET, Encontrado: $FOUND_SECRET${NC}"
        fi
    else
        echo -e "${RED}❌ FALHOU - Não encontrado${NC}"
        TIMES[$i]="N/A"
        ATTEMPTS[$i]="N/A"
        RATES[$i]="N/A"
    fi
    
    echo ""
done

# Resumo final
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${BLUE}📊 RESUMO DOS TESTES FULL 32-BIT${NC}"
echo "================================="
echo ""

for i in {1..3}; do
    echo "Teste $i:"
    echo "  Secret:     ${SECRETS[$i]}"
    echo "  Posição:    ${POSITIONS[$i]}% do range"
    echo "  Tentativas: ${ATTEMPTS[$i]}"
    echo "  Tempo:      ${TIMES[$i]}"
    echo "  Taxa:       ${RATES[$i]} hash/s"
    echo ""
done

# Calcular média (se disponível)
if [ "${RATES[1]}" != "N/A" ]; then
    echo "💡 Análise:"
    echo "   - Quanto mais próximo de 100% o secret, mais tentativas necessárias"
    echo "   - Taxa média de hashing: ~${RATES[1]} hash/s (pode variar)"
    echo "   - Para 32 bits completo: 4.294.967.296 ÷ taxa = tempo estimado"
    echo ""
fi

echo "✅ Testes completos!"
echo ""

