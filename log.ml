(* Copyright (C) 2013, Zhang Initiative Research Unit,
 * Advance Science Institute, Riken
 * 2-1 Hirosawa, Wako, Saitama 351-0198, Japan
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License, with
 * the special exception on linking described in file LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. *)

open Core.Std
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

let medium_timestamp_str out ts lvl =
  let tm = Unix.localtime ts in
  let us = Float.Parts.fractional (Float.modf ts) in
    (* example: "2012-01-13 18h26m52.091" *)
    fprintf out "%04d-%02d-%02d %02dh%02dm%02d.%03d %s: "
      (1900 + tm.Unix.tm_year)
      (1    + tm.Unix.tm_mon)
      (tm.Unix.tm_mday)
      (tm.Unix.tm_hour)
      (tm.Unix.tm_min)
      (tm.Unix.tm_sec)
      (Int.of_float (1_000. *. us))
      (string_of_level lvl)

let short_timestamp_str out ts lvl =
  fprintf out "%.3f %s: " ts (string_of_level lvl)

let nl_flush out =
  fprintf out "\n%!"

let log lvl =
  if int_of_level lvl >= int_of_level !level then
    let now = Unix.gettimeofday() in
    let _ = medium_timestamp_str !output now lvl in
    (* let _ = short_timestamp_str !output now lvl in *)
    kfprintf nl_flush !output
  else
    ifprintf !output
