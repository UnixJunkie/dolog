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

(** {2 Logger} *)

(** {4 Log levels} *)

type log_level = FATAL | ERROR | WARN | INFO | DEBUG

(** {4 Setup} *)

val set_log_level : log_level -> unit
val get_log_level : unit -> log_level
val set_output : out_channel -> unit

(** {4 Logging primitives} *)

module type S = sig

  (** Signature for logging primitives. *)

  (** {4 Lazy parameters} *)

  val log: log_level -> string Lazy.t -> unit

  val fatal : string Lazy.t -> unit
  val error : string Lazy.t -> unit
  val warn : string Lazy.t -> unit
  val info : string Lazy.t -> unit
  val debug : string Lazy.t -> unit

  (** {4 printf-like parameters} *)

  val logf: log_level -> ('a, out_channel, unit, unit) format4 -> 'a

  val fatalf : ('a, out_channel, unit, unit) format4 -> 'a
  val errorf : ('a, out_channel, unit, unit) format4 -> 'a
  val warnf: ('a, out_channel, unit, unit) format4 -> 'a
  val infof : ('a, out_channel, unit, unit) format4 -> 'a
  val debugf : ('a, out_channel, unit, unit) format4 -> 'a

end

include S

(** {4 Coloring of log levels (optional)} *)

val color_on  : unit -> unit
val color_off : unit -> unit
val set_color_mapping : (log_level -> string) -> unit

(** {4 Functor interface (optional)} *)

module type SECTION = sig

  (** Signature for the functor parameters. *)

  val section: string
  (** Section name. *)

end

module Make (Section: SECTION): S
(**
   This module aims to be used on the first line of each module:

   {| module Log = Log.Make(struct let section = "module-name" end) |}

*)
