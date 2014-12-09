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

let level_of_string = function
  | "FATAL" | "fatal" -> FATAL
  | "ERROR" | "error" -> ERROR
  | "WARN"  | "warn"  -> WARN
  | "INFO"  | "info"  -> INFO
  | "DEBUG" | "debug" -> DEBUG
  | str -> failwith ("no such log level: " ^ str)

(* defaults *)
let level           = ref ERROR
let output          = ref stderr
let level_to_string = ref string_of_level (* no colors by default *)

let set_log_level l =
  level := l

let get_log_level () =
  !level

let set_output o =
  output := o

(* ANSI terminal colors for UNIX:
   let fg_black   = "\027[30m"
   let fg_red     = "\027[31m"
   let fg_green   = "\027[32m"
   let fg_yellow  = "\027[33m"
   let fg_blue    = "\027[34m"
   let fg_magenta = "\027[35m"
   let fg_cyan    = "\027[36m"
   let fg_white   = "\027[37m"
   let fg_default = "\027[39m"
   let fg_reset   = "\027[0m"
*)
(* default log levels color mapping *)
let colored_string_of_level = function
  | FATAL -> "\027[35mFATAL\027[0m" (* magenta *)
  | ERROR -> "\027[31mERROR\027[0m" (* red *)
  | WARN  -> "\027[33mWARN \027[0m" (* yellow *)
  | INFO  -> "\027[32mINFO \027[0m" (* green *)
  | DEBUG -> "\027[36mDEBUG\027[0m" (* cyan *)

let set_color_mapping f =
  level_to_string := f

let color_on () =
  set_color_mapping colored_string_of_level

let color_off () =
  set_color_mapping string_of_level

let section_width = ref 0

module type S = sig
  val log: log_level -> string Lazy.t -> unit
  val fatal : string Lazy.t -> unit
  val error : string Lazy.t -> unit
  val warn  : string Lazy.t -> unit
  val info  : string Lazy.t -> unit
  val debug : string Lazy.t -> unit

  val logf   : log_level -> ('a, out_channel, unit, unit) format4 -> 'a
  val fatalf : ('a, out_channel, unit, unit) format4 -> 'a
  val errorf : ('a, out_channel, unit, unit) format4 -> 'a
  val warnf  : ('a, out_channel, unit, unit) format4 -> 'a
  val infof  : ('a, out_channel, unit, unit) format4 -> 'a
  val debugf : ('a, out_channel, unit, unit) format4 -> 'a
end

module type SECTION = sig
  val section: string
end

module Make (S: SECTION) = struct

  let () =
    if S.section <> "" then
      section_width := max (String.length S.section) !section_width

  let timestamp_str lvl =
    let section =
      if !section_width = 0 then ""
      else sprintf "%-*s " !section_width S.section
    in
    let ts = Unix.gettimeofday() in
    let tm = Unix.localtime ts in
    let us, _s = modf ts in
    (* example: "2012-01-13 18:26:52.091" *)
    sprintf "%04d-%02d-%02d %02d:%02d:%02d.%03d %s%s: "
      (1900 + tm.Unix.tm_year)
      (1    + tm.Unix.tm_mon)
      tm.Unix.tm_mday
      tm.Unix.tm_hour
      tm.Unix.tm_min
      tm.Unix.tm_sec
      (int_of_float (1_000. *. us))
      section
      (!level_to_string lvl)

  (* example for a shorter timestamp string *)
  let short_timestamp_str lvl =
    sprintf "%.3f %s: " (Unix.gettimeofday()) (string_of_level lvl)

  let log lvl lazy_msg =
    if int_of_level lvl >= int_of_level !level then begin
      let now = timestamp_str lvl in
      fprintf !output "%s%s\n%!" now (Lazy.force lazy_msg)
    end

  let logf lvl fmt =
    if int_of_level lvl >= int_of_level !level then begin
      let now = timestamp_str lvl in
      fprintf !output "%s" now;
      (* there is the risk this log message will interleave with another
         but I don't think it is possible to do otherwise *)
      kfprintf (fun out ->
        fprintf out "\n%!"
      ) !output fmt
    end else
      ifprintf !output fmt

  let fatal lazy_msg = log FATAL lazy_msg
  let error lazy_msg = log ERROR lazy_msg
  let warn  lazy_msg = log WARN  lazy_msg
  let info  lazy_msg = log INFO  lazy_msg
  let debug lazy_msg = log DEBUG lazy_msg

  let fatalf fmt = logf FATAL fmt
  let errorf fmt = logf ERROR fmt
  let warnf  fmt = logf WARN  fmt
  let infof  fmt = logf INFO  fmt
  let debugf fmt = logf DEBUG fmt

end

include Make (struct
  let section = ""
  let width = 0
end)
