'use strict';

var Js    = require("../../lib/js/js");
var Mt    = require("./mt");
var Block = require("../../lib/js/block");

var suites_000 = /* tuple */[
  "int_type",
  function () {
    return /* Eq */Block.__(0, [
              "number",
              "number"
            ]);
  }
];

var suites_001 = /* :: */[
  /* tuple */[
    "string_type",
    function () {
      return /* Eq */Block.__(0, [
                "string",
                "string"
              ]);
    }
  ],
  /* :: */[
    /* tuple */[
      "int_gadt_test",
      function () {
        return /* Neq */Block.__(1, [
                  Js.test(3, /* Number */3),
                  Js.$$null
                ]);
      }
    ],
    /* [] */0
  ]
];

var suites = /* :: */[
  suites_000,
  suites_001
];

Mt.from_pair_suites("typeof_test.ml", suites);

exports.suites = suites;
/*  Not a pure module */
