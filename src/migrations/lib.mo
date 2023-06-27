import V0_1_0 "./00-01-00-initial";
import V0_2_0 "./00-02-00-add-full-name";
import V0_3_0 "./00-03-00-trie";
import MigrationTypes "./types";

import Debug "mo:base/Debug";
import Nat "mo:base/Nat";

module {

  let inits = [
    V0_1_0.init,
    V0_2_0.init,
    V0_3_0.init,
    // do not forget to add your new migration upgrade method here
  ];

  let upgrades = [
    V0_1_0.upgrade,
    V0_2_0.upgrade,
    V0_3_0.upgrade,
    // do not forget to add your new migration upgrade method here
  ];

  let downgrades = [
    V0_1_0.downgrade,
    V0_2_0.downgrade,
    V0_3_0.downgrade,
    // do not forget to add your new migration downgrade method here
  ];

  func getVersionMigrationId(version: MigrationTypes.Version): Nat {
    switch (version) {
      case (#v0_1_0) 0;
      case (#v0_2_0) 1;
      case (#v0_3_0) 2;
      // do not forget to add your new migration id here 
      // should be increased by 1 as it will be later used as an index to get upgrade/downgrade methods
    };
  };

  func getStateMigrationId(migrationState: MigrationTypes.State): Nat {
    switch (migrationState) {
      case (#v0_1_0(_)) 0;
      case (#v0_2_0(_)) 1;
      case (#v0_3_0(_)) 2;
      // do not forget to add your new migration id here 
      // should be increased by 1 as it will be later used as an index to get upgrade/downgrade methods
    };
  };

  func getInitArgsMigrationId(migrationArgs: MigrationTypes.InitArgs): Nat {
    switch (migrationArgs) {
      case (#v0_1_0(_)) 0;
      case (#v0_2_0(_)) 1;
      case (#v0_3_0(_)) 2;
      // do not forget to add your new migration id here 
      // should be increased by 1 as it will be later used as an index to get upgrade/downgrade methods
    };
  };

  public func init(version: MigrationTypes.Version, args: MigrationTypes.Args) : MigrationTypes.State {
    switch(args){
      case(#init(initArgs)){ 
        let migration_version = getVersionMigrationId(version);
        let args_version = getInitArgsMigrationId(initArgs);
        if (migration_version != args_version) {
          Debug.trap("Migration version and init args are incompatible");
        };
        Debug.print("Initializing version " # Nat.toText(migration_version));
        inits[args_version](initArgs); 
      };
      case(_) { Debug.trap("Expect init arguments"); };
    };
  };

  public func migrate(prevState: MigrationTypes.State, nextVersion: MigrationTypes.Version, args: MigrationTypes.Args): MigrationTypes.State {
    var state = prevState;

    var migrationId = getStateMigrationId(prevState);

    let nextMigrationId = getVersionMigrationId(nextVersion);

    while (migrationId != nextMigrationId) {

      if (nextMigrationId > migrationId) {
        Debug.print("Upgrading from "   # Nat.toText(migrationId) # " to " # Nat.toText(migrationId + 1));
        state := upgrades  [migrationId + 1](state, unwrapUpgradeArgs  (args));
      } else {
        Debug.print("Downgrading from " # Nat.toText(migrationId) # " to " # Nat.toText(migrationId - 1));
        state := downgrades[migrationId - 1](state, unwrapDowngradeArgs(args));
      };

      migrationId := if (nextMigrationId > migrationId) migrationId + 1 else migrationId - 1;

    };

    state;
  };

  func unwrapUpgradeArgs(args: MigrationTypes.Args): [MigrationTypes.UpgradeArgs] {
    switch(args){
      case(#upgrade(upgrade_args)) { upgrade_args; };
      case(_) { Debug.trap("Expect #upgrade args"); };
    };
  };

  func unwrapDowngradeArgs(args: MigrationTypes.Args): [MigrationTypes.DowngradeArgs] {
    switch(args){
      case(#downgrade(downgrade_args)) { downgrade_args; };
      case(_) { Debug.trap("Expect #downgrade args"); };
    };
  };

};