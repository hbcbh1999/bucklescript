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

(** This module will  be exported 


    - It does not have any code, all its code will be inlined so that 
       there will be never 
       {[ require('js')]}

    - Its interface should be minimal

*)

(** internal types for FFI, these types are not used by normal users *)
type (-'obj, +'a) meth_callback 
type (-'arg, + 'result) meth
type (-'arg, + 'result) fn (** Js uncurried function *)


(** Types for JS objects *)
type +'a t (** Js object type *)
type + 'a null 
type + 'a undefined
type + 'a null_undefined
type boolean 



external true_ : boolean = "true" [@@bs.val]
external false_ : boolean = "false" [@@bs.val]
external to_bool : boolean -> bool = "js_boolean_to_bool" 

external unsafe_typeof : 'a -> string = "js_typeof"
external log : 'a -> unit = "js_dump"

external unsafe_lt : 'a -> 'a -> boolean = "js_unsafe_lt"
external unsafe_le : 'a -> 'a -> boolean = "js_unsafe_le"
external unsafe_gt : 'a -> 'a -> boolean = "js_unsafe_gt"
external unsafe_ge : 'a -> 'a -> boolean = "js_unsafe_ge"


(* Note [to_opt null] will be [null : 'a opt opt]*)

module Null = struct 
  type + 'a t = 'a null
  external to_opt : 'a t -> 'a option = "js_from_nullable"
  external return : 'a -> 'a t  = "%identity"
  external test : 'a t -> bool = "js_is_nil"
  external empty : 'a t = "null" [@@bs.val]
end

module Undefined = struct 
  type + 'a t = 'a undefined 
  external to_opt : 'a t -> 'a option = "js_from_def"
  external return : 'a -> 'a t = "%identity"
  external test : 'a t -> bool =  "js_is_undef"
  external empty : 'a t = "undefined" [@@bs.val]
end

module Null_undefined = struct
  type + 'a t = 'a null_undefined
  external to_opt : 'a t -> 'a option = "js_from_nullable_def"
  external return : 'a -> 'a t = "%identity"
  external test : 'a t -> bool =  "js_is_nil_undef"
  external empty : 'a t = "undefined" [@@bs.val]
end



module Dict = Js_dict
module Array = Js_array
module String = Js_string
module Re = Js_re


type symbol
(**Js symbol type only available in ES6 *)

type obj_val 
type undefined_val
(** This type has only one value [undefined] *)
type null_val
(** This type has only one value [null] *)
type function_val

type _ js_type = 
  | Undefined :  undefined_val js_type
  | Null : null_val js_type
  | Boolean : boolean js_type
  | Number : float js_type
  | String : string js_type
  | Function : function_val js_type
  | Object : obj_val js_type
  | Symbol : symbol js_type


let typeof (type t) (x : 'a) :  (t js_type * t ) =  
  if unsafe_typeof x = "undefined" then 
    (Obj.magic Undefined, Obj.magic x) else
  if unsafe_typeof x = "null" then 
    (Obj.magic Null, Obj.magic x) else 
  if unsafe_typeof x = "number" then 
    (Obj.magic Number, Obj.magic x ) else 
  if unsafe_typeof x = "string" then 
    (Obj.magic String, Obj.magic x) else 
  if unsafe_typeof x = "boolean" then 
    (Obj.magic Boolean, Obj.magic x) else 
  if unsafe_typeof x = "function" then 
    (Obj.magic Function, Obj.magic x) else 
  if unsafe_typeof x = "object" then 
    (Obj.magic Object, Obj.magic x) 
  else 
    (Obj.magic Symbol, Obj.magic x) 
  (* TODO: may change according to engines ?*)

let null = Null.empty
let undefined = Undefined.empty

let test (type t) (x : 'a) (v : t js_type) : t null =
  match v with 
  | Number 
    -> 
    if unsafe_typeof x = "number" then Obj.magic x else null 
  | Boolean 
    -> 
    if unsafe_typeof x = "boolean" then Obj.magic x else null 
  | Undefined 
    -> 
    if unsafe_typeof x = "undefined" then Obj.magic x else null
  | Null 
    -> 
    if unsafe_typeof x = "null" then Obj.magic x else null
  | String
    -> 
    if unsafe_typeof x = "string" then Obj.magic x else null
  | Function
    -> 
    if unsafe_typeof x = "function" then Obj.magic x else null 
  | Object
    -> 
    if unsafe_typeof x = "object" then Obj.magic x else null 
  | Symbol
    -> 
    if unsafe_typeof x = "symbol" then Obj.magic x else null 
