
(* add this line if you upgrade software to dolog >= 4.0.0 *)
module Log = Dolog.Log

let () =
  Log.set_log_level Log.DEBUG;
  Log.color_on();
  Log.fatal "%s" "Look";
  Log.error "%s" "like";
  Log.warn  "%s" "it is";
  Log.info  "%s" "starting";
  Log.debug "%s" "to be useful ! (^-^) w/ colors";
  Log.color_off();
  Log.fatal "%s" "Look";
  Log.error "%s" "like";
  Log.warn  "%s" "it is";
  Log.info  "%s" "starting";
  Log.debug "%s" "to be useful ! (^-^) black and white";
  Log.(set_prefix_builder short_prefix_builder);
  Log.color_on();
  Log.fatal "%s" "Look";
  Log.error "%s" "like";
  Log.warn  "%s" "it is";
  Log.info  "%s" "starting";
  Log.debug "%s" "to be useful ! (^-^) short w/ colors";
  Log.color_off();
  Log.fatal "%s" "Look";
  Log.error "%s" "like";
  Log.warn  "%s" "it is";
  Log.info  "%s" "starting";
  Log.debug "%s" "to be useful ! (^-^) short black and white";
  Unix.sleepf 0.1;
  Log.debug "%s" "0.1s later"
