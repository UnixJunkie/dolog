
(* add this line if you upgrade software to dolog >= 4.0.0 *)
module Log = Dolog.Log

let () =
  Log.set_log_level Log.DEBUG;
  Log.color_on();
  Log.fatal "%s" "Look";
  Log.error "%s" "like";
  Log.warn  "%s" "it is";
  Log.info  "%s" "starting";
  Log.debug "%s" "to be useful ! (^-^)";
  Log.color_off()

module L1 = Log.Make(struct let section = "l1" end)
module L2 = Log.Make(struct let section = "---l2---" end)
module L3 = Log.Make(struct let section = "-------- l3" end)

let () =
  Log.color_on();
  L1.debug "%s" "ohoh";
  L2.debug "%s" "hihi";
  L3.debug "%s" "haha"
