import MigrationTypes "../types";
import V0_1_0         "./types";

import Debug          "mo:base/Debug";

module {

  type State         = MigrationTypes.State;
  type InitArgs      = V0_1_0.InitArgs;
  type UpgradeArgs   = V0_1_0.UpgradeArgs;
  type DowngradeArgs = V0_1_0.DowngradeArgs;

  public func init(args: InitArgs): State {
    return #v0_1_0({
      var controller = args.controller;
      var teachers = [];
      var students = [];
    });
  };

  // From nothing to 0.1.0
  public func upgrade(migration_state: State, args: UpgradeArgs): State {
    Debug.trap("Cannot upgrade to initial version");
  };

  // From 0.1.0 to nothing
  public func downgrade(migration_state: State, args: DowngradeArgs): State {
    Debug.trap("Cannot downgrade from initial version");
  };

};