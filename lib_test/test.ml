let () =
  Log.set_log_level Log.DEBUG;

  Log.color_on();

  Log.fatal "%s" "Look";
  Log.error "%s" "like";
  Log.warn  "%s" "it is";
  Log.info  "%s" "starting";
  Log.debug "%s" "to be useful ! (^-^)";

  Log.color_off();

module L1 = Log.Make(struct let section = "l1" end)
module L2 = Log.Make(struct let section = "---l2---" end)

let () =
  Log.color_on();
  L2.debug "%s" "hihi";
