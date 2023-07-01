import V0_1_0         "./00-01-00-initial";
import V0_2_0         "./00-02-00-add-full-name";
import V0_3_0         "./00-03-00-trie";
import MigrationTypes "./types";

import Debug          "mo:base/Debug";

module {

  // do not forget to change current migration when you add a new one
  let { init; upgrade; downgrade; } = V0_1_0;

  public func install(args: MigrationTypes.Args) : MigrationTypes.State {
    switch(args){
      case(#init(init_args)){ 
        init(init_args);
      };
      case(_){
        Debug.trap("Unexpected install args: only #init args are supported"); 
      };
    };
  };

  public func migrate(prevState: MigrationTypes.State, args: MigrationTypes.Args): MigrationTypes.State {
    var state = prevState;

    switch(args){
      case(#upgrade(upgrade_args)){ 
        Debug.print("Upgrading state to next version");
        state := upgrade(state, upgrade_args); 
      };
      case(#downgrade(downgrade_args)){ 
        Debug.print("Downgrading state to previous version");
        state := downgrade(state, downgrade_args); 
      };
      case(_){ 
        Debug.print("Migration ignored: use #upgrade and #downgrade args to migrate state");
      };
    };

    state;
  };

};