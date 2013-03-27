(* Copyright (c) 2013, Zhang Initiative Research Unit,
 * Advance Science Institute, RIKEN
 * 2-1 Hirosawa, Wako, Saitama 351-0198, Japan
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. *)

open Printf

(* localtime is used to date events, _not_ GMT, BEWARE SCIENTIST *)

type log_level =
  | FATAL
  | ERROR
  | WARN
  | INFO
  | DEBUG

(* defaults *)
let level = ref ERROR
let output = ref stderr

let set_log_level l =
  level := l

let set_output o =
  output := o

let int_of_level = function
  | FATAL -> 4
  | ERROR -> 3
  | WARN  -> 2
  | INFO  -> 1
  | DEBUG -> 0

let string_of_level = function
  | FATAL -> "FATAL"
  | ERROR -> "ERROR"
  | WARN  -> "WARN "
  | INFO  -> "INFO "
  | DEBUG -> "DEBUG"

let timestamp_str lvl =
  let ts = Unix.gettimeofday() in
  let tm = Unix.localtime ts in
  let us, _s = modf ts in
  (* example: "2012-01-13 18:26:52.091" *)
  sprintf "%04d-%02d-%02d %02d:%02d:%02d.%03d %s: "
    (1900 + tm.Unix.tm_year)
    (1    + tm.Unix.tm_mon)
    (tm.Unix.tm_mday)
    (tm.Unix.tm_hour)
    (tm.Unix.tm_min)
    (tm.Unix.tm_sec)
    (int_of_float (1_000. *. us))
    (string_of_level lvl)

let short_timestamp_str lvl =
  sprintf "%.3f %s: " (Unix.gettimeofday()) (string_of_level lvl)

let log lvl lazy_msg =
  if int_of_level lvl >= int_of_level !level then
    (* let now = short_timestamp_str lvl in *)
    let now = timestamp_str lvl in
    fprintf !output "%s%s\n%!" now (Lazy.force lazy_msg)
  else ()

let fatal lazy_msg = log FATAL lazy_msg
let error lazy_msg = log ERROR lazy_msg
let warn  lazy_msg = log WARN  lazy_msg
let info  lazy_msg = log INFO  lazy_msg
let debug lazy_msg = log DEBUG lazy_msg
