#!/bin/sh
set -e 
## building js 
# ocamlbuild -use-ocamlfind -no-hygiene  -syntax camlp4o -pkgs js_of_ocaml,js_of_ocaml.syntax,js_of_ocaml.toplevel exports.byte
FILE=bin/reason.byte


ocamlbuild -lflags -no-check-prims -use-ocamlfind -I bin -no-hygiene   -pkgs compiler-libs.common -no-links $FILE

# jsoo_mkcmis stdlib
js_of_ocaml -I +compiler-libs   --toplevel +weak.js +toplevel.js  ./polyfill.js _build/$FILE -I ./others/ -I ./runtime/ --file js.cmi:/cmis/js.cmi --file js_unsafe.cmi:/cmis/js_unsafe.cmi --file js_re.cmi:/cmis/js_re.cmi   -o _build/exports.js 

DOCS_DIR=../docs/js-demo

rm -rf $DOCS_DIR/exports.js && cp _build/exports.js  $DOCS_DIR

ocamlbuild -use-ocamlfind -no-hygiene -no-links js_generate_require.byte --
rm -rf  $DOCS_DIR/pre_load.js && cp ./pre_load.js $DOCS_DIR
# TODO: build with amd first 
cp ../lib/amdjs/*.js $DOCS_DIR/stdlib










