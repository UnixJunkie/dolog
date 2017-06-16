#!/bin/bash
\rm -f setup.*
oasis setup
./configure
ocaml setup.ml -configure --prefix `opam conf var prefix`
ocaml setup.ml -build
ocamlfind remove dolog
ocaml setup.ml -install
