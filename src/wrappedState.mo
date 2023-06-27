import MigrationTypes "./migrations/types";
import Migrations     "./migrations";
import Types          "./types";

import Debug          "mo:base/Debug";
import Trie           "mo:base/Trie";
import Buffer         "mo:base/Buffer";
import Text           "mo:base/Text";

module {

  let StateTypes = MigrationTypes.Current;

  // Compatible with v0-1-0 and v0-2-0
  public class WrappedState(state: StateTypes.State) {
    
    let state_ = state;

    public func addTeacher(teacher: StateTypes.Teacher) {
      Debug.print("addTeacher");
      let buffer = Buffer.fromArray<StateTypes.Teacher>(state_.teachers);
      buffer.add(teacher);
      state_.teachers := Buffer.toArray(buffer);
    };

    public func addStudent(student: StateTypes.Student) {
      Debug.print("addStudent");
      let buffer = Buffer.fromArray<StateTypes.Student>(state_.students);
      buffer.add(student);
      state_.students := Buffer.toArray(buffer);
    };

    public func fetchTeachers(): Types.FetchTeachersResponse {
      Debug.print("fetchTeachers");
      return {
        items = state_.teachers;
        totalCount = state_.teachers.size();
      };
    };

    public func fetchStudents(): Types.FetchStudentsResponse {
      Debug.print("fetchStudents");
      return {
        items = state_.students;
        totalCount = state_.students.size();
      };
    };

  };

//  // Compatible with v0-3-0
//  public class WrappedState(state: StateTypes.State) {
//    
//    let state_ = state;
//
//    public func addTeacher(teacher: StateTypes.Teacher) {
//      Debug.print("addTeacher");
//      state_.teachers := Trie.put(state_.teachers, { key = teacher.fullName; hash = Text.hash(teacher.fullName); }, Text.equal, teacher).0;
//    };
//
//    public func addStudent(student: StateTypes.Student) {
//      Debug.print("addStudent");
//      state_.students := Trie.put(state_.students, { key = student.fullName; hash = Text.hash(student.fullName); }, Text.equal, student).0;
//    };
//
//    public func fetchTeachers(): Types.FetchTeachersResponse {
//      Debug.print("fetchTeachers");
//      let teachers = Buffer.Buffer<StateTypes.Teacher>(0);
//      for ((_, teacher) in Trie.iter(state_.teachers)) {
//        teachers.add(teacher);
//      };
//      let teachers_array : [StateTypes.Teacher] = Buffer.toArray(teachers);
//         return {
//        items = teachers_array;
//        totalCount = teachers_array.size();
//      };
//    };
//
//    public func fetchStudents(): Types.FetchStudentsResponse {
//      Debug.print("fetchStudents");
//      let students = Buffer.Buffer<StateTypes.Student>(0);
//      for ((_, student) in Trie.iter(state_.students)) {
//        students.add(student);
//      };
//         let students_array : [StateTypes.Student] = Buffer.toArray(students);
//         return {
//        items = students_array;
//        totalCount = students_array.size();
//      };
//    };
//
//  };

};