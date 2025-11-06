use clap::Parser;
use indicatif::{ProgressBar, ProgressStyle};
use puzzle_entropy_tester::{normalize_hash, sha256_hex, BruteforceResult};
use rayon::prelude::*;
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::Arc;
use std::time::Instant;

#[derive(Parser, Debug)]
#[command(name = "bruteforce-numeric")]
#[command(about = "Força bruta numérica para puzzles Bitcoin", long_about = None)]
struct Args {
    /// Hash SHA256 alvo (com ou sem 0x)
    #[arg(short = 't', long)]
    target_hash: String,

    /// Valor inicial (padrão: 0)
    #[arg(short = 's', long, default_value = "0")]
    start: u64,

    /// Valor final (padrão: 2^32 = 4 bilhões)
    /// Para 64 bits use: 18446744073709551615
    #[arg(short = 'e', long, default_value = "4294967295")]
    end: u64,

    /// Número de threads (padrão: CPUs disponíveis)
    #[arg(short = 'j', long)]
    threads: Option<usize>,

    /// Tamanho do chunk por thread (padrão: 10000)
    #[arg(short = 'c', long, default_value = "10000")]
    chunk_size: u64,

    /// Mostrar progresso a cada N chunks
    #[arg(short = 'p', long, default_value = "1000")]
    progress_every: u64,
}

fn main() {
    let args = Args::parse();

    // Detectar número máximo de threads disponíveis
    let max_threads = std::thread::available_parallelism()
        .map(|n| n.get())
        .unwrap_or(1);

    // Configurar número de threads
    let requested_threads = args.threads.unwrap_or(max_threads);
    
    if requested_threads > max_threads {
        eprintln!("⚠️  AVISO: Solicitado {} threads, mas sistema suporta apenas {}!", 
                  requested_threads, max_threads);
        eprintln!("   Usando {} threads (máximo disponível)", max_threads);
        
        rayon::ThreadPoolBuilder::new()
            .num_threads(max_threads)
            .build_global()
            .unwrap();
    } else if let Some(threads) = args.threads {
        rayon::ThreadPoolBuilder::new()
            .num_threads(threads)
            .build_global()
            .unwrap();
    }

    let target_hash = normalize_hash(&args.target_hash);
    let start = args.start;
    let end = args.end;
    let total = end - start + 1;

    let active_threads = rayon::current_num_threads();

    println!("🎯 BRUTEFORCE NUMÉRICO");
    println!("======================");
    println!("Target Hash: {}", target_hash);
    println!("Range: {} até {}", start, end);
    println!("Total: {} tentativas", total);
    println!("Threads: {} / {} (usando / máximo)", active_threads, max_threads);
    println!("Chunk size: {}", args.chunk_size);
    println!();

    // Configurar progress bar
    let pb = ProgressBar::new(total);
    pb.set_style(
        ProgressStyle::default_bar()
            .template("{spinner:.green} [{elapsed_precise}] [{bar:40.cyan/blue}] {pos}/{len} ({percent}%) | {per_sec} | ETA: {eta}")
            .unwrap()
            .progress_chars("#>-"),
    );

    // Contadores atômicos
    let found = Arc::new(AtomicBool::new(false));
    let attempts = Arc::new(AtomicU64::new(0));
    let found_secret = Arc::new(parking_lot::Mutex::new(None));

    let start_time = Instant::now();

    // Dividir range em chunks e processar em paralelo
    let chunk_size = args.chunk_size;
    let ranges: Vec<_> = (start..=end)
        .step_by(chunk_size as usize)
        .map(|chunk_start| {
            let chunk_end = std::cmp::min(chunk_start + chunk_size - 1, end);
            (chunk_start, chunk_end)
        })
        .collect();

    println!("🚀 Iniciando busca com {} chunks...\n", ranges.len());

    ranges.par_iter().for_each(|(chunk_start, chunk_end)| {
        // Se já encontrou, pular este chunk
        if found.load(Ordering::Relaxed) {
            return;
        }

        // Processar cada número no chunk
        for num in *chunk_start..=*chunk_end {
            if found.load(Ordering::Relaxed) {
                break;
            }

            // Testar o número como string
            let secret = num.to_string();
            let hash = sha256_hex(&secret);

            attempts.fetch_add(1, Ordering::Relaxed);

            if hash.eq_ignore_ascii_case(&target_hash) {
                found.store(true, Ordering::Relaxed);
                *found_secret.lock() = Some(secret);
                break;
            }

            // Atualizar progress bar (só no primeiro chunk de cada thread)
            if num % (args.chunk_size * args.progress_every) == 0 {
                pb.set_position(attempts.load(Ordering::Relaxed));
            }
        }

        // Atualizar progresso após completar chunk
        pb.set_position(attempts.load(Ordering::Relaxed));
    });

    pb.finish_with_message("Busca concluída");

    let elapsed = start_time.elapsed();
    let total_attempts = attempts.load(Ordering::Relaxed);

    let result = BruteforceResult {
        found: found.load(Ordering::Relaxed),
        secret: found_secret.lock().clone(),
        attempts: total_attempts,
        elapsed_secs: elapsed.as_secs_f64(),
    };

    println!("\n{}", result);

    if result.found {
        println!("\n💡 Use este comando para resolver o puzzle:");
        println!("   cargo run --bin solve-puzzle -- puzzle_<hash>.json \"{}\" <seu_endereco>", result.secret.unwrap());
        std::process::exit(0);
    } else {
        std::process::exit(1);
    }
}

