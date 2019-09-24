(* Copyright (c) 2019, Francois Berenger.
 * Copyright (c) 2014, INRIA.
 * Copyright (c) 2013, Zhang Initiative Research Unit,
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

(* add this line if you upgrade software to dolog >= 4.0.0 *)
module Log = Dolog.Log

let main () =

  Log.set_log_level Log.DEBUG;

  Log.set_output stdout;

  Log.fatal "%s" " ===== PRINTF-LIKE MESSAGES ===== ";

  Log.fatal "%s" "Look";
  Log.error "%s" "like";
  Log.warn  "%s" "it is";
  Log.info  "%s" "starting";
  Log.color_on();
  Log.debug "%s" "to be useful ! (^-^)";

  Log.set_prefix " DAFT";
  Log.fatal "%s" "hello";
  Log.error "%s" "hello";
  Log.warn  "%s" "hello";
  Log.clear_prefix ();
  Log.info  "%s" "hello";
  Log.debug "%s" "hello"

let () = main()
