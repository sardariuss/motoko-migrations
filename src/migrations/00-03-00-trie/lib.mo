import V0_3_0         "./types";
import V0_2_0         "../00-02-00-add-full-name/types";
import MigrationTypes "../types";

import Array          "mo:base/Array";
import Debug          "mo:base/Debug";
import Trie           "mo:base/Trie";
import Text           "mo:base/Text";
import Buffer         "mo:base/Buffer";

module {

  type Trie<K, V> = Trie.Trie<K, V>;

  type State         = MigrationTypes.State;
  type InitArgs      = V0_3_0.InitArgs;
  type UpgradeArgs   = V0_3_0.UpgradeArgs;
  type DowngradeArgs = V0_3_0.DowngradeArgs;

  public func init(args: InitArgs): State {
    return #v0_3_0({
      var controllers = args.controllers;
      var schoolName = args.schoolName;
      var teachers =  Trie.empty<Text, V0_3_0.Teacher>();
      var students = Trie.empty<Text, V0_3_0.Student>();
    });
  };

  // From 0.2.0 to 0.3.0
  public func upgrade(migration_state: State, args: UpgradeArgs): State {
    // access current state
    let state = switch (migration_state) {
      case (#v0_2_0(state)) state;
      case (_) Debug.trap("Unexpected migration state (v0_2_0 expected)") 
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
      var schoolName = args.schoolName;
      var teachers;
      var students;
    });
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // From 0.3.0 to 0.2.0
  public func downgrade(migration_state: State, args: DowngradeArgs): State {
    // access current state
    let state = switch (migration_state) { 
      case (#v0_3_0(state)) state;
      case (_) Debug.trap("Unexpected migration state (v0_3_0 expected)") 
    };
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