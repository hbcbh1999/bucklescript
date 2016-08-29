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
      "number_gadt_test",
      function () {
        return /* Neq */Block.__(1, [
                  Js.test(3, /* Number */3),
                  Js.$$null
                ]);
      }
    ],
    /* :: */[
      /* tuple */[
        "boolean_gadt_test",
        function () {
          return /* Neq */Block.__(1, [
                    Js.test(true, /* Boolean */2),
                    Js.$$null
                  ]);
        }
      ],
      /* :: */[
        /* tuple */[
          "undefined_gadt_test",
          function () {
            return /* Neq */Block.__(1, [
                      Js.test(Js.$$undefined, /* Undefined */0),
                      Js.$$null
                    ]);
          }
        ],
        /* :: */[
          /* tuple */[
            "null_gadt_test",
            function () {
              return /* Neq */Block.__(1, [
                        Js.test(Js.$$null, /* Null */1),
                        Js.$$null
                      ]);
            }
          ],
          /* :: */[
            /* tuple */[
              "string_gadt_test",
              function () {
                return /* Neq */Block.__(1, [
                          Js.test("3", /* String */4),
                          Js.$$null
                        ]);
              }
            ],
            /* :: */[
              /* tuple */[
                "string_gadt_test_neg",
                function () {
                  return /* Eq */Block.__(0, [
                            Js.test(3, /* String */4),
                            Js.$$null
                          ]);
                }
              ],
              /* :: */[
                /* tuple */[
                  "function_gadt_test",
                  function () {
                    return /* Neq */Block.__(1, [
                              Js.test(function (x) {
                                    return x;
                                  }, /* Function */5),
                              Js.$$null
                            ]);
                  }
                ],
                /* :: */[
                  /* tuple */[
                    "object_gadt_test",
                    function () {
                      return /* Neq */Block.__(1, [
                                Js.test({
                                      x: 3
                                    }, /* Object */6),
                                Js.$$null
                              ]);
                    }
                  ],
                  /* [] */0
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
];

var suites = /* :: */[
  suites_000,
  suites_001
];

Mt.from_pair_suites("typeof_test.ml", suites);

exports.suites = suites;
/*  Not a pure module */
