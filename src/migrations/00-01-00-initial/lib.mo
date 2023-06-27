import MigrationTypes "../types";
import V0_1_0 "./types";
import V0_2_0 "../00-02-00-add-full-name/types";

import Debug "mo:base/Debug";
import Array "mo:base/Array";

module {

  type InitArgs      = MigrationTypes.InitArgs;
  type State         = MigrationTypes.State;
  type UpgradeArgs   = MigrationTypes.UpgradeArgs;
  type DowngradeArgs = MigrationTypes.DowngradeArgs;

  public func init(migrationArgs: InitArgs): State {
    let args = switch (migrationArgs) { case (#v0_1_0(args)) args; case (_) Debug.trap("Unexpected migration arguments (v0_1_0 expected)") };

    return #v0_1_0({
      var controller = args.controller;
      var teachers = [];
      var students = [];
    });
  };

  // From nothing to 0.1.0
  public func upgrade(migrationState: State, args: [UpgradeArgs]): State {
    Debug.trap("Cannot upgrade to initial version");
  };

  // From 0.2.0 to 0.1.0
  public func downgrade(migrationState: State, downgrade_args: [DowngradeArgs]): State {
    // access current state
    let state = switch (migrationState) { case (#v0_2_0(state)) state; case (_) Debug.trap("Unexpected migration state (v0_2_0 expected)") };
    // get the required downgrade arguments
    let find_function = func(version_args: DowngradeArgs) : Bool {
      switch(version_args){
        case (#v0_1_0(_)) true;
        case (_) false;
      };
    };
    let v1_args = switch(Array.find(downgrade_args, find_function)){
      case(?#v0_1_0(args)) { args; };
      case(_) { Debug.trap("Downgrade requires v0_1_0 arguments") };
    };

    // make any manipulations with current state to convert it to previous migration state type
    let teachers = Array.map(state.teachers, func (item: V0_2_0.Teacher): V0_1_0.Teacher {
      return {
        firstName = item.firstName;
        lastName = item.lastName;
        subject = item.subject;
      };
    });

    let students = Array.map(state.students, func (item: V0_2_0.Student): V0_1_0.Student {
      return {
        firstName = item.firstName;
        lastName = item.lastName;
        speciality = item.speciality;
      };
    });

    // return previous state
    return #v0_1_0({
      var controller = v1_args.controller;
      var teachers;
      var students;
    });
    
  };

};