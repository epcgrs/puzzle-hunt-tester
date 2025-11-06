#!/bin/bash
# 🎲 Gerador de Puzzles de Teste
# Converte palavras em números de 32 bits e gera seus hashes

echo "🎲 GERADOR DE PUZZLES DE TESTE"
echo "==============================="
echo ""
echo "Estratégia:"
echo "  1. Palavra -> SHA256(palavra)"
echo "  2. Primeiros 4 bytes do hash -> Número de 32 bits (0 a 4.294.967.295)"
echo "  3. SHA256(número) -> Hash alvo do puzzle"
echo ""
echo "Gerando wordlist com palavras e seus hashes..."
echo ""

# Criar diretório de teste
mkdir -p test_puzzles

# Arquivo de saída
OUTPUT="test_puzzles/wordlist_puzzles.txt"
> "$OUTPUT"

# Lista de palavras para teste
WORDS=(
    "bitcoin"
    "satoshi"
    "nakamoto"
    "blockchain"
    "hodl"
    "moon"
    "lambo"
    "whale"
    "mining"
    "crypto"
    "puzzle"
    "treasure"
    "simplicity"
    "liquid"
    "elements"
    "taproot"
    "segwit"
    "lightning"
    "halving"
    "genesis"
)

echo "Palavra          | Número 32-bit  | Hash Alvo" >> "$OUTPUT"
echo "-----------------|----------------|------------------------------------------------------------------" >> "$OUTPUT"

for word in "${WORDS[@]}"; do
    # 1. Calcular SHA256 da palavra
    word_hash=$(echo -n "$word" | sha256sum | cut -d' ' -f1)
    
    # 2. Pegar primeiros 8 caracteres hex (4 bytes = 32 bits)
    first_bytes="${word_hash:0:8}"
    
    # 3. Converter hex para decimal (número de 32 bits)
    secret_num=$((16#$first_bytes))
    
    # 4. Calcular SHA256 desse número (string)
    target_hash="0x$(echo -n "$secret_num" | sha256sum | cut -d' ' -f1)"
    
    # Formatar saída
    printf "%-16s | %-14s | %s\n" "$word" "$secret_num" "$target_hash" >> "$OUTPUT"
done

echo ""
cat "$OUTPUT"
echo ""
echo "✅ Arquivo gerado: $OUTPUT"
echo ""

