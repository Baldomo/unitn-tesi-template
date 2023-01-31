#!/usr/bin/env bash
# Scarica sempre makesh in caso la repo sia stata clonata senza --recursive
git submodule update --remote --init makesh >/dev/null

makesh_lib_dir="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"/makesh
source "$makesh_lib_dir/lib.sh"
source "$makesh_lib_dir/message.sh"

shopt -s extglob nullglob globstar

sources=(
    # src/*.tex
    # src/*.bib
    src/chapters/*
    src/sections/*
)
bin_dir="$makesh_script_dir/bin"
pdf_dir="build/default"

tectonic="$bin_dir/tectonic"
[[ "$(uname -s)" =~ MINGW*|MSYS*|CYGWIN*|Windows_NT ]] && tectonic="$tectonic.exe"

#:(bindir) Crea la directory "bin" se non presente
make::bindir() {
    lib::check_dir "$bin_dir"
    mkdir -p "$bin_dir"
}

# Prova a utilizzare vari downloader per scaricare un file
downloader() {
    if command -v curl > /dev/null 2>&1; then
        curl --silent --show-error --fail --location "$1" --output "$2"
        return
    fi
    if command -v wget > /dev/null 2>&1; then
        wget "$1" -O "$2"
        return
    fi
    msg::die "Nessun downloader installato (curl o wget sono necessari)"
}

#:(download_tectonic) Scarica il compilatore LaTeX Tectonic
make::download_tectonic() {
    lib::requires bindir
    lib::check_file "$tectonic"

    local installer="$bin_dir/installer.sh"
    pushd "$bin_dir" >/dev/null || msg::die "Cannot access %s" "$bin_dir"
    downloader https://drop-sh.fullyjustified.net "$installer"
    msg::msg "Installer Tectonic scaricato in: ./${installer#"$makesh_script_dir/"}"
    chmod +x "$installer"
    "$installer"
    popd >/dev/null || msg::die "Cannot popd"
}

#:(pdf) Compila il progetto in un file PDF, di default "build/default/default.pdf"
make::pdf() {
    # lib::needs_changes "${sources[@]}"
    "$tectonic" -X build --keep-logs
}

#:(watch) Avvia Tectonic in modalità "continua": compila il PDF ogni volta che
#:(watch) i file vengono modificati
make::watch() {
    "$tectonic" -X watch
}

#:(all) Scarica Tectonic e compila il progetto
make::all() {
    lib::requires download_tectonic
    lib::requires pdf
}

#:(clean) Cancella i file compilati e la cartella "bin"
make::clean() {
    rm -rf "$bin_dir" "$pdf_dir"
}

source "$makesh_lib_dir/runtime.sh"
