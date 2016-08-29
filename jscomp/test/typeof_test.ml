



let suites = Mt.[
    "int_type", (fun _ -> Eq(Js.unsafe_typeof 3, "number") );
    "string_type", (fun _ -> Eq(Js.unsafe_typeof "x", "string"));
    "int_gadt_test", (fun _ -> Neq (Js.test 3 Js.Number, Js.null ))    
]

;; Mt.from_pair_suites __FILE__ suites 
