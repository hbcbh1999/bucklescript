(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)









(** Mainly used in camlinternalOO
    {[
      let dummy_met : item = obj (Obj.new_block 0 0)
      let obj = Obj.new_block Obj.object_tag table.size
    ]}

    Here we only need generate expression like this 
    {[
      { tag : tag ; length : size }      
    ]}
    we don't need fill fields, since it is not required by GC    
*)
let caml_obj_dup (x : Obj.t) = 
  let len = Js_obj.length x in
  let v = Js_obj.uninitialized_object (Js_obj.tag x ) len in
  for i = 0 to len - 1 do 
    Obj.set_field v i (Obj.field x i)
  done;
  v   

let caml_obj_truncate (x : Obj.t) (new_size : int) = 
  let len = Js_obj.length x in
  if new_size <= 0 || new_size > len then 
    raise (Invalid_argument "Obj.truncate")
  else 
  if len <> new_size  then
    begin 
      for i = new_size  to len - 1  do
        Obj.set_field x  i (Obj.magic 0)
      done;
      Js_obj.set_length x new_size 
    end

     

let caml_lazy_make_forward x = lazy x 

(** TODO: the dummy one should be [{}] *)
let caml_update_dummy x y = 
  let len = Js_obj.length y in
  for i = 0 to len - 1 do  
    Obj.set_field x i (Obj.field y i)
  done  ;
  Obj.set_tag x (Obj.tag y);
  Js_obj.set_length x   (Js_obj.length y)

let caml_int_compare (x : int) (y: int) : int = 
  if  x < y then -1 else if x = y then 0 else  1

let caml_string_compare (x : string) (y: string) : int = 
  if  x < y then -1 else if x = y then 0 else  1

let unsafe_js_compare x y = 
  if x == y then 0 else 
  if Js.to_bool @@ Js.unsafe_lt x y then -1 
  else 1
(** TODO: investigate total 
    [compare x y] returns [0] if [x] is equal to [y], 
    a negative integer if [x] is less than [y], 
    and a positive integer if [x] is greater than [y]. 
    The ordering implemented by compare is compatible with the comparison 
    predicates [=], [<] and [>] defined above, with one difference on the treatment of the float value 
    [nan]. 

    Namely, the comparison predicates treat nan as different from any other float value, 
    including itself; while compare treats [nan] as equal to itself and less than any other float value. 
    This treatment of [nan] ensures that compare defines a total ordering relation.
    compare applied to functional values may raise Invalid_argument. compare applied to cyclic structures 
    may not terminate.

    The compare function can be used as the comparison function required by the [Set.Make] and [Map.Make] functors,
    as well as the [List.sort] and [Array.sort] functions.
*)
let rec caml_compare (a : Obj.t) (b : Obj.t) : int = 
  if Js.unsafe_typeof a = "string" then
    caml_string_compare (Obj.magic a) (Obj.magic b )
  else if Js.unsafe_typeof a = "number" then
    caml_int_compare (Obj.magic a) (Obj.magic b )
  else if Js.unsafe_typeof a = "boolean" 
          || Js.unsafe_typeof a = "null"
          || Js.unsafe_typeof a = "undefined"
  then 
    unsafe_js_compare a b 
  else
  (* if js_is_instance_array a then  *)
  (*   0 *)
  (* else  *)
    let tag_a = Js_obj.tag a in
    let tag_b = Js_obj.tag b in
    (* double_array_tag: 254
       forward_tag:250
    *)
    if tag_a = 250 then
      caml_compare (Obj.field a 0) b
    else if tag_b = 250 then 
      caml_compare a (Obj.field b 0)
    else if tag_a = 248 (* object/exception *)  then
      caml_int_compare (Obj.magic @@ Obj.field a 1) (Obj.magic @@ Obj.field b 1 )       
    else if tag_a = 251 (* abstract_tag *) then 
      raise (Invalid_argument "equal: abstract value")
    else if tag_a <> tag_b then
      if tag_a < tag_b then (-1) else  1
    else
      let len_a = Js_obj.length a in 
      let len_b = Js_obj.length b in 
      if len_a = len_b then 
        aux_same_length a b 0 len_a 
      else if len_a < len_b then 
        aux_length_a_short a b 0 len_a 
      else 
        aux_length_b_short a b 0 len_b
and aux_same_length  (a : Obj.t) (b : Obj.t) i same_length = 
  if i = same_length then
    0
  else 
    let res = caml_compare (Obj.field a i) (Obj.field b i) in
    if res <> 0 then res
    else aux_same_length  a b (i + 1) same_length
and aux_length_a_short (a : Obj.t)  (b : Obj.t)  i short_length    = 
  if i = short_length then -1 
  else 
    let res = caml_compare (Obj.field a i) (Obj.field b i) in
    if res <> 0 then res
    else aux_length_a_short a b (i+1) short_length
and aux_length_b_short (a : Obj.t) (b : Obj.t) i short_length = 
  if i = short_length then 1
  else
    let res = caml_compare (Obj.field a i) (Obj.field b i) in
    if res <> 0 then res
    else aux_length_b_short a b (i+1) short_length      

type eq = Obj.t -> Obj.t -> bool

let rec caml_equal (a : Obj.t) (b : Obj.t) : bool = 
  if Js.unsafe_typeof a = "string" 
  || Js.unsafe_typeof a = "number"
  || Js.unsafe_typeof a = "boolean"
  || Js.unsafe_typeof a = "undefined"
  || Js.unsafe_typeof a = "null"
  then a == b else
    let tag_a = Js_obj.tag a in
    let tag_b = Js_obj.tag b in
    (* double_array_tag: 254
       forward_tag:250
    *)
    if tag_a = 250 then
      caml_equal (Obj.field a 0) b
    else if tag_b = 250 then 
      caml_equal a (Obj.field b 0)
    else if tag_a = 248 (* object/exception *)  then
      (Obj.magic @@ Obj.field a 1) ==  (Obj.magic @@ Obj.field b 1 )       
    else if tag_a = 251 (* abstract_tag *) then 
      raise (Invalid_argument "equal: abstract value")
    else if tag_a <> tag_b then
      false      
    else
      let len_a = Js_obj.length a in 
      let len_b = Js_obj.length b in 
      if len_a = len_b then 
        aux_equal_length a b 0 len_a 
      else false
and aux_equal_length  (a : Obj.t) (b : Obj.t) i same_length = 
  if i = same_length then
    true
  else 
    caml_equal (Obj.field a i) (Obj.field b i) 
    && aux_equal_length  a b (i + 1) same_length

let caml_notequal a  b =  not (caml_equal a  b)

let caml_int32_compare = caml_int_compare
let caml_nativeint_compare = caml_int_compare
let caml_greaterequal a b = caml_compare a b >= 0 

let caml_greaterthan a b = caml_compare a b > 0 

let caml_lessequal a b = caml_compare a b <= 0

let caml_lessthan a b = caml_compare a b < 0



  
