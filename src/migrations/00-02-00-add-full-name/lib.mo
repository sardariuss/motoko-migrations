import V0_2_0         "./types";
import V0_1_0         "../00-01-00-initial/types";
import MigrationTypes "../types";

import Array          "mo:base/Array";
import Debug          "mo:base/Debug";

module {

  type State         = MigrationTypes.State;
  type InitArgs      = V0_2_0.InitArgs;
  type UpgradeArgs   = V0_2_0.UpgradeArgs;
  type DowngradeArgs = V0_2_0.DowngradeArgs;

  // From nothing to 0.2.0
  public func init(args: InitArgs): State {
    return #v0_2_0({
      var controllers = args.controllers;
      var teachers = [];
      var students = [];
    });
  };
  
  // From 0.1.0 to 0.2.0
  public func upgrade(migration_state: State, args: UpgradeArgs): State {
    // access current state
    let state = switch (migration_state) {
      case (#v0_1_0(state)) state;
      case (_) Debug.trap("Unexpected migration state (v0_1_0 expected)") 
    };
    // make any manipulations with previous state to convert it to current migration state type
    let teachers = Array.map(state.teachers, func (item: V0_1_0.Teacher): V0_2_0.Teacher {
      return {
        firstName = item.firstName;
        lastName = item.lastName;
        fullName = item.firstName # " " # item.lastName;
        subject = item.subject;
      };
    });

    let students = Array.map(state.students, func (item: V0_1_0.Student): V0_2_0.Student {
      return {
        firstName = item.firstName;
        lastName = item.lastName;
        fullName = item.firstName # " " # item.lastName;
        speciality = item.speciality;
      };
    });

    // return current state
    return #v0_2_0({
      var controllers = args.controllers;
      var teachers;
      var students;
    });
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // From 0.2.0 to 0.1.0
  public func downgrade(migration_state: State, args: DowngradeArgs): State {
    // access previous state
    let state = switch (migration_state) {
      case (#v0_2_0(state)) state;
      case (_) Debug.trap("Unexpected migration state (v0_2_0 expected)") 
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
      var controller = args.controller;
      var teachers;
      var students;
    });

  };
};