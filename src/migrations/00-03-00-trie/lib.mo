import Array "mo:base/Array";
import Debug "mo:base/Debug";
import MigrationTypes "../types";
import V0_2_0 "../00-02-00-add-full-name/types";
import V0_3_0 "./types";

import Trie "mo:base/Trie";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

module {

  type Trie<K, V> = Trie.Trie<K, V>;

  type InitArgs      = MigrationTypes.InitArgs;
  type State         = MigrationTypes.State;
  type UpgradeArgs   = MigrationTypes.UpgradeArgs;
  type DowngradeArgs = MigrationTypes.DowngradeArgs;

  public func init(migrationArgs: InitArgs): State {
    let args = switch (migrationArgs) { case (#v0_3_0(args)) args; case (_) Debug.trap("Unexpected migration arguments (v0_3_0 expected)") };
    return #v0_3_0({
      var controllers = args.controllers;
      var schoolName = args.schoolName;
      var teachers =  Trie.empty<Text, V0_3_0.Teacher>();
      var students = Trie.empty<Text, V0_3_0.Student>();
    });
  };

  // From 0.2.0 to 0.3.0
  public func upgrade(migrationState: State, upgrade_args: [UpgradeArgs]): State {
    // access previous state
    let state = switch (migrationState) { case (#v0_2_0(state)) state; case (_) Debug.trap("Unexpected migration state (v0_2_0 expected)") };
    // get the required upgrade arguments
    let find_function = func(version_args: UpgradeArgs) : Bool {
      switch(version_args){
        case (#v0_3_0(_)) true;
        case (_) false;
      };
    };
    let v3_args = switch(Array.find(upgrade_args, find_function)){
      case(?#v0_3_0(args)) { args; };
      case(_) { Debug.trap("Upgrade requires v0_3_0 arguments") };
    };
    // make any manipulations with previous state to convert it to current migration state type
    var teachers = Trie.empty<Text, V0_3_0.Teacher>();
    for (teacher in Array.vals(state.teachers)){
      teachers := Trie.put(teachers, { key = teacher.fullName; hash = Text.hash(teacher.fullName); }, Text.equal, teacher).0;
    };

    var students = Trie.empty<Text, V0_3_0.Student>();
    for (student in Array.vals(state.students)){
      students := Trie.put(students, { key = student.fullName; hash = Text.hash(student.fullName); }, Text.equal, student).0;
    };

    // return current state
    return #v0_3_0({
      var controllers = state.controllers;
      var schoolName = v3_args.schoolName;
      var teachers;
      var students;
    });
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // From potential 0.4.0 to 0.3.0
  public func downgrade(migrationState: State, args: [DowngradeArgs]): State {
    Debug.trap("v0_3_0 is the most recent version");
  };
};