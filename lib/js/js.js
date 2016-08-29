'use strict';


var Null = /* module */[];

var Undefined = /* module */[];

var Null_undefined = /* module */[];

function $$typeof(x) {
  if (typeof x === "undefined") {
    return /* tuple */[
            /* Undefined */0,
            x
          ];
  }
  else if (typeof x === "null") {
    return /* tuple */[
            /* Null */1,
            x
          ];
  }
  else if (typeof x === "number") {
    return /* tuple */[
            /* Number */3,
            x
          ];
  }
  else if (typeof x === "string") {
    return /* tuple */[
            /* String */4,
            x
          ];
  }
  else if (typeof x === "boolean") {
    return /* tuple */[
            /* Boolean */2,
            x
          ];
  }
  else if (typeof x === "function") {
    return /* tuple */[
            /* Function */5,
            x
          ];
  }
  else if (typeof x === "object") {
    return /* tuple */[
            /* Object */6,
            x
          ];
  }
  else {
    return /* tuple */[
            /* Symbol */7,
            x
          ];
  }
}

var $$null = null;

var $$undefined = undefined;

function test(x, v) {
  switch (v) {
    case 0 : 
        if (typeof x === "undefined") {
          return x;
        }
        else {
          return $$null;
        }
    case 1 : 
        if (typeof x === "null") {
          return x;
        }
        else {
          return $$null;
        }
    case 2 : 
        if (typeof x === "boolean") {
          return x;
        }
        else {
          return $$null;
        }
    case 3 : 
        if (typeof x === "number") {
          return x;
        }
        else {
          return $$null;
        }
    case 4 : 
        if (typeof x === "string") {
          return x;
        }
        else {
          return $$null;
        }
    case 5 : 
        if (typeof x === "function") {
          return x;
        }
        else {
          return $$null;
        }
    case 6 : 
        if (typeof x === "object") {
          return x;
        }
        else {
          return $$null;
        }
    case 7 : 
        if (typeof x === "symbol") {
          return x;
        }
        else {
          return $$null;
        }
    
  }
}

var Dict = 0;

var $$Array = 0;

var $$String = 0;

var Re = 0;

exports.Null           = Null;
exports.Undefined      = Undefined;
exports.Null_undefined = Null_undefined;
exports.Dict           = Dict;
exports.$$Array        = $$Array;
exports.$$String       = $$String;
exports.Re             = Re;
exports.$$typeof       = $$typeof;
exports.$$null         = $$null;
exports.$$undefined    = $$undefined;
exports.test           = test;
/* null Not a pure module */
