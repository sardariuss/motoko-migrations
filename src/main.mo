import WrappedState   "wrappedState";
import MigrationTypes "./migrations/types";
import Migrations     "./migrations";
import Types          "./types";

import Debug          "mo:base/Debug";

shared actor class MotokoMigrations(args: MigrationTypes.Args) {
  let StateTypes = MigrationTypes.Current;

  // you will have only one stable variable
  // move all your stable variable declarations to "migrations/001-initial/types.mo -> State"
  // do not forget to change #v0_1_0 when you are adding a new migration
  stable var migrationState: MigrationTypes.State = Migrations.init(#v0_1_0, args);

  // do not forget to change #v0_1_0 when you are adding a new migration
  // if you use one of previous states in place of #v0_1_0 it will run downgrade methods instead
  migrationState := Migrations.migrate(migrationState, #v0_1_0, args);

  // do not forget to change #v0_1_0 when you are adding a new migration
  let wrapped : WrappedState.WrappedState = switch (migrationState) {
    case (#v0_1_0(state)) { WrappedState.WrappedState(state); };
    case (_) { Debug.trap("Unexpected migration state"); };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public shared func addTeacher(teacher: StateTypes.Teacher): async () {
    wrapped.addTeacher(teacher);
  };

  public shared func addStudent(student: StateTypes.Student): async () {
    wrapped.addStudent(student);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public query func fetchTeachers(): async Types.FetchTeachersResponse {
    wrapped.fetchTeachers();
  };

  public query func fetchStudents(): async Types.FetchStudentsResponse {
    wrapped.fetchStudents();
  };

  public query func getControllers() : async [Principal] {
    switch (migrationState) {
      case (#v0_1_0(state)) { [state.controller]; };
      case (#v0_2_0(state)) { state.controllers; };
      case (#v0_3_0(state)) { state.controllers; };
    };
  };

  public query func getSchoolName() : async Text {
    switch (migrationState) {
      case (#v0_3_0(state)) { state.schoolName; };
      case (_) { Debug.trap("School name does not exist before v0.3.0"); };
    };
  };

};
