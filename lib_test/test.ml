let () =
  Log.set_log_level Log.DEBUG;

  Log.color_on();

  Log.fatal (lazy "Is it fatal?");
  Log.error (lazy "Or just an error?");
  Log.warn  (lazy "Maybe only a warning sign?");
  Log.info  (lazy "Is it informative at least?");
  Log.debug (lazy "What? It was an old debugging trace?!");

  Log.color_off();

  Log.fatal (lazy "Is it fatal?");
  Log.error (lazy "Or just an error?");
  Log.warn  (lazy "Maybe only a warning sign?");
  Log.info  (lazy "Is it informative at least?");
  Log.debug (lazy "What? It was an old debugging trace?!")

module L1 = Log.Make(struct let section = "l1" end)
module L2 = Log.Make(struct let section = "---l2---" end)

let () =
  Log.color_on();
  L1.debug (lazy "haha");
  L2.debug (lazy "hoho")
