import Array "mo:base/Array";
import Debug "mo:base/Debug";
import MigrationTypes "../types";
import V0_1_0 "../00-01-00-initial/types";
import V0_2_0 "./types";
import V0_3_0 "../00-03-00-trie/types";

import Trie "mo:base/Trie";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

module {

  type InitArgs      = MigrationTypes.InitArgs;
  type State         = MigrationTypes.State;
  type UpgradeArgs   = MigrationTypes.UpgradeArgs;
  type DowngradeArgs = MigrationTypes.DowngradeArgs;

  public func init(migrationArgs: InitArgs): State {
    let args = switch (migrationArgs) { case (#v0_2_0(args)) args; case (_) Debug.trap("Unexpected migration arguments (v0_2_0 expected)") };

     return #v0_2_0({
      var controllers = args.controllers;
      var teachers = [];
      var students = [];
    });
  };
  
  // From 0.1.0 to 0.2.0
  public func upgrade(migrationState: State, upgrade_args: [UpgradeArgs]): State {
    // access previous state
    let state = switch (migrationState) { case (#v0_1_0(state)) state; case (_) Debug.trap("Unexpected migration state (v0_1_0 expected)") };
    // get the required upgrade arguments
    let find_function = func(version_args: UpgradeArgs) : Bool {
      switch(version_args){
        case (#v0_2_0(_)) true;
        case (_) false;
      };
    };
    let v2_args = switch(Array.find(upgrade_args, find_function)){
      case(?#v0_2_0(args)) { args; };
      case(_) { Debug.trap("Upgrade requires v0_2_0 arguments") };
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
      var controllers = v2_args.controllers;
      var teachers;
      var students;
    });
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // From 0.3.0 to 0.2.0
  public func downgrade(migrationState: State, args: [DowngradeArgs]): State {
    // access current state
    let state = switch (migrationState) { case (#v0_3_0(state)) state; case (_) Debug.trap("Unexpected migration state (v0_3_0 expected)") };

    // make any manipulations with current state to convert it to previous migration state type
    let teachers = Buffer.Buffer<V0_2_0.Teacher>(0);
    for ((_, teacher) in Trie.iter(state.teachers)) {
      teachers.add(teacher);
    };
    
    let students = Buffer.Buffer<V0_2_0.Student>(0);
    for ((_, student) in Trie.iter(state.students)) {
      students.add(student);
    };

    var teachers_array : [V0_2_0.Teacher] = Buffer.toArray(teachers);
    var students_array : [V0_2_0.Student] = Buffer.toArray(students);

    // return previous state
    return #v0_2_0({
      var controllers = state.controllers;
      var teachers = teachers_array;
      var students = students_array;
    });

  };
};