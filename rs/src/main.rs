extern crate env_logger;
#[macro_use] extern crate log;
extern crate regex;
extern crate walkdir;

use regex::bytes::Regex;

use walkdir::{DirEntry, WalkDir, WalkDirIterator};

use std::fs;
use std::os::unix::ffi::OsStrExt;

fn main() {
    env_logger::init().unwrap();

    let emacs_backup_pattern = Regex::new("^(?:#.*#|.*~)$").unwrap();

    for file in WalkDir::new(".").into_iter().filter_entry(not_git_dir) {
        let file = match file {
            Ok(f) => f,
            Err(e) => {
                warn!("Error while walking directories: {}", e);
                continue;
            }
        };

        debug!("Processing file {:?}", file.path());
        if emacs_backup_pattern.is_match(file.file_name().as_bytes()) {
            debug!("File {:?} is a match.", file.path());
            let result = fs::remove_file(file.path().as_os_str());

            match result {
                Ok(_) => debug!("Deleted {:?} OK", file.path()),
                Err(e) => warn!("Failed to delete {:?}: {}",
                                file.path(), e)
            }
        }
    }
}

fn not_git_dir(entry: &DirEntry) -> bool {
    entry.file_name() != ".git"
}
