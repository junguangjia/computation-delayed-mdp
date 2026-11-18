#!/bin/sh
set -eu

prop_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$prop_dir"

if [ -n "${Q3_TEX_TREE:-}" ] && [ -d "$Q3_TEX_TREE/texmf" ]; then
  export TEXMFHOME="$Q3_TEX_TREE/texmf"
  export TEXMFVAR="$Q3_TEX_TREE/texmf-var"
  export TEXMFCONFIG="$Q3_TEX_TREE/texmf-config"
elif [ -d "/private/tmp/q3-tex-runtime-20261115/texmf" ]; then
  export TEXMFHOME="/private/tmp/q3-tex-runtime-20261115/texmf"
  export TEXMFVAR="/private/tmp/q3-tex-runtime-20261115/texmf-var"
  export TEXMFCONFIG="/private/tmp/q3-tex-runtime-20261115/texmf-config"
fi

if command -v pdflatex >/dev/null 2>&1; then
  PDFLATEX_BIN=$(command -v pdflatex)
elif [ -n "${HOME:-}" ] && [ -x "$HOME/Library/TinyTeX/bin/universal-darwin/pdflatex" ]; then
  PDFLATEX_BIN="$HOME/Library/TinyTeX/bin/universal-darwin/pdflatex"
elif [ -x "/Library/TeX/texbin/pdflatex" ]; then
  PDFLATEX_BIN="/Library/TeX/texbin/pdflatex"
else
  echo "Error: pdflatex not found." >&2
  exit 1
fi

mkdir -p output/pdf tmp
"$PDFLATEX_BIN" -no-shell-escape -interaction=nonstopmode -halt-on-error \
  -output-directory=output/pdf -jobname=Proposal_Computation_Delayed_MDP main.tex > tmp/build_pass1.log 2>&1
"$PDFLATEX_BIN" -no-shell-escape -interaction=nonstopmode -halt-on-error \
  -output-directory=output/pdf -jobname=Proposal_Computation_Delayed_MDP main.tex > tmp/build_pass2.log 2>&1
"$PDFLATEX_BIN" -no-shell-escape -interaction=nonstopmode -halt-on-error \
  -output-directory=output/pdf -jobname=Proposal_Computation_Delayed_MDP main.tex > tmp/build.log 2>&1

printf '%s\n' 'Compiled output/pdf/Proposal_Computation_Delayed_MDP.pdf'
