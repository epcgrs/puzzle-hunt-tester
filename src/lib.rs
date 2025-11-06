use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::fmt;

/// Estrutura do arquivo puzzle JSON
#[derive(Debug, Serialize, Deserialize)]
pub struct PuzzleInfo {
    pub secret_hash: String,
    pub address: String,
    pub amount: f64,
    pub hint: Option<String>,
}

/// Resultado de uma tentativa de bruteforce
#[derive(Debug, Clone)]
pub struct BruteforceResult {
    pub found: bool,
    pub secret: Option<String>,
    pub attempts: u64,
    pub elapsed_secs: f64,
}

impl fmt::Display for BruteforceResult {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.found {
            write!(
                f,
                "✅ ENCONTRADO!\n   Secret: {}\n   Tentativas: {}\n   Tempo: {:.2}s\n   Taxa: {:.0} hash/s",
                self.secret.as_ref().unwrap(),
                self.attempts,
                self.elapsed_secs,
                self.attempts as f64 / self.elapsed_secs
            )
        } else {
            write!(
                f,
                "❌ Não encontrado\n   Tentativas: {}\n   Tempo: {:.2}s\n   Taxa: {:.0} hash/s",
                self.attempts,
                self.elapsed_secs,
                self.attempts as f64 / self.elapsed_secs
            )
        }
    }
}

/// Calcula SHA256 de uma string e retorna em formato hex
pub fn sha256_hex(input: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(input.as_bytes());
    let result = hasher.finalize();
    format!("0x{}", hex::encode(result))
}

/// Calcula SHA256 de bytes e retorna em formato hex
pub fn sha256_hex_bytes(input: &[u8]) -> String {
    let mut hasher = Sha256::new();
    hasher.update(input);
    let result = hasher.finalize();
    format!("0x{}", hex::encode(result))
}

/// Verifica se um hash corresponde ao target
pub fn verify_hash(input: &str, target_hash: &str) -> bool {
    let computed = sha256_hex(input);
    computed.eq_ignore_ascii_case(target_hash)
}

/// Normaliza o hash (adiciona 0x se necessário, converte para lowercase)
pub fn normalize_hash(hash: &str) -> String {
    let normalized = if hash.starts_with("0x") || hash.starts_with("0X") {
        hash.to_lowercase()
    } else {
        format!("0x{}", hash.to_lowercase())
    };
    normalized
}

/// Carrega informações de um puzzle
pub fn load_puzzle(path: &str) -> anyhow::Result<PuzzleInfo> {
    let contents = std::fs::read_to_string(path)?;
    let puzzle: PuzzleInfo = serde_json::from_str(&contents)?;
    Ok(puzzle)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_sha256() {
        let hash = sha256_hex("satoshi");
        assert_eq!(
            hash.to_lowercase(),
            "0xa0dc65ffca799873cbea0ac274015b9526505daaaed385155425f7337704883e"
        );
    }

    #[test]
    fn test_verify_hash() {
        let target = "0xa0dc65ffca799873cbea0ac274015b9526505daaaed385155425f7337704883e";
        assert!(verify_hash("satoshi", target));
        assert!(!verify_hash("bitcoin", target));
    }

    #[test]
    fn test_normalize_hash() {
        assert_eq!(
            normalize_hash("A0DC65FF"),
            "0xa0dc65ff"
        );
        assert_eq!(
            normalize_hash("0xA0DC65FF"),
            "0xa0dc65ff"
        );
    }
}

