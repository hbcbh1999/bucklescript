



let suites = Mt.[
    "int_type", (fun _ -> Eq(Js.unsafe_typeof 3, "number") );
    "string_type", (fun _ -> Eq(Js.unsafe_typeof "x", "string"));

    "number_gadt_test", (fun _ -> Neq (Js.test 3 Js.Number, Js.null ))  ;  
    "boolean_gadt_test", (fun _ -> Neq (Js.test Js.true_ Js.Boolean, Js.null ))    ;
    "undefined_gadt_test", (fun _ -> Neq (Js.test Js.undefined Js.Undefined, Js.null ))    ;
    "null_gadt_test", (fun _ -> Neq (Js.test Js.null  Js.Null, Js.null ));    
    "string_gadt_test", (fun _ -> Neq (Js.test "3" Js.String, Js.null ));    
    "string_gadt_test_neg", (fun _ -> Eq (Js.test 3 Js.String, Js.null ));    
    "function_gadt_test", (fun _ -> Neq (Js.test (fun  x -> x ) Js.Function, Js.null )) ;
    "object_gadt_test", (fun _ -> Neq (Js.test [%bs.obj{x = 3}] Js.Object, Js.null ))    
]

;; Mt.from_pair_suites __FILE__ suites 
