#!/bin/bash
# 🧪 Teste de Bruteforce com Puzzles de Palavras

echo "🧪 TESTE DE BRUTEFORCE COM PUZZLES DE PALAVRAS"
echo "================================================"
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

echo "📊 Puzzles de Teste (palavra -> número 32-bit -> SHA256)"
echo ""
cat test_puzzles/wordlist_puzzles.txt
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Array de testes
declare -A TESTS

# Adicionar alguns casos de teste (palavra, número, hash)
TESTS["lightning"]="31158699:0x2fcafda3779b1fe109e59eb3b3961d191c6e74b0defe0c345f485dd9338f867f"
TESTS["taproot"]="148329247:0xe4b0b67be6550369cac7976e90c949cb37ddc14e8adfce3d510efee25ff694dc"
TESTS["mining"]="711794821:0xbc59a12dcb578fe983ba7bbf95e09556f5794b8cfcec72a2bcbb6813aa157afd"
TESTS["liquid"]="1108410722:0x7eed405263aae2ec6f4ca6211f64d7e1bef368d7c8ad1397ff20582d508dc26e"

test_count=0
success_count=0

for word in "${!TESTS[@]}"; do
    test_count=$((test_count + 1))
    
    IFS=':' read -r secret hash <<< "${TESTS[$word]}"
    
    echo -e "${BLUE}Teste $test_count: '$word' (secret: $secret)${NC}"
    echo "   Target hash: $hash"
    
    # Calcular range de busca (±10% do número real para economizar tempo)
    margin=$((secret / 10))
    start=$((secret - margin))
    end=$((secret + margin))
    
    if [ $start -lt 0 ]; then
        start=0
    fi
    
    echo "   Range de busca: $start a $end (±10% do secret)"
    echo ""
    
    # Executar bruteforce
    result=$(./target/release/bruteforce -t "$hash" -s "$start" -e "$end" 2>&1)
    
    # Verificar se encontrou
    if echo "$result" | grep -q "✅ ENCONTRADO"; then
        found_secret=$(echo "$result" | grep "Secret:" | awk '{print $2}')
        echo -e "${GREEN}   ✅ SUCESSO! Encontrado: $found_secret${NC}"
        
        if [ "$found_secret" = "$secret" ]; then
            echo -e "${GREEN}   ✅ Secret correto!${NC}"
            success_count=$((success_count + 1))
        else
            echo -e "${RED}   ❌ Secret incorreto! Esperado: $secret${NC}"
        fi
    else
        echo -e "${RED}   ❌ FALHOU - Não encontrado${NC}"
    fi
    
    # Mostrar estatísticas
    echo "$result" | grep -E "(Tentativas|Tempo|Taxa)" | sed 's/^/   /'
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
done

# Resumo final
echo ""
echo "📊 RESUMO DOS TESTES"
echo "===================="
echo "Total de testes: $test_count"
echo -e "${GREEN}Sucessos: $success_count${NC}"
echo -e "${RED}Falhas: $((test_count - success_count))${NC}"

if [ $success_count -eq $test_count ]; then
    echo -e "\n${GREEN}🎉 TODOS OS TESTES PASSARAM!${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Alguns testes falharam${NC}"
    exit 1
fi

