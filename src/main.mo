import WrappedState   "wrappedState";
import MigrationTypes "./migrations/types";
import Migrations     "./migrations";
import Types          "./types";

import Debug          "mo:base/Debug";

shared actor class MotokoMigrations(args: MigrationTypes.Args) {
  
  let StateTypes = MigrationTypes.Current;

  stable var migrationState: MigrationTypes.State = Migrations.install(args);

  migrationState := Migrations.migrate(migrationState, args);

  // do not forget to change #v0_1_0 when you are adding a new migration
  let wrapped : ?WrappedState.WrappedState = switch (migrationState) {
    case (#v0_1_0(state)) { ?WrappedState.WrappedState(state); };
    case (_) { null; };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public shared func addTeacher(teacher: StateTypes.Teacher): async () {
    getWrappedState().addTeacher(teacher);
  };

  public shared func addStudent(student: StateTypes.Student): async () {
    getWrappedState().addStudent(student);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public query func fetchTeachers(): async Types.FetchTeachersResponse {
    getWrappedState().fetchTeachers();
  };

  public query func fetchStudents(): async Types.FetchStudentsResponse {
    getWrappedState().fetchStudents();
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

  func getWrappedState() : WrappedState.WrappedState {
    switch(wrapped){
      case (?wrappedState) { wrappedState; };
      case (_) { Debug.trap("Wrapped state is null"); };
    };
  };

};
