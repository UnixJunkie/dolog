#!/bin/bash

#set -x

oasis setup
ocaml setup.ml -configure
ocaml setup.ml -build
# ocamldoc -html log.mli
ocaml setup.ml -install
