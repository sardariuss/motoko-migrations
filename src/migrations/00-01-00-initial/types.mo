// please do not import any types from your project outside migrations folder here
// it can lead to bugs when you change those types later, because migration types should not be changed
// you should also avoid importing these types anywhere in your project directly from here
// use MigrationTypes.Current property instead

module {
  public type Teacher = {
    firstName: Text;
    lastName: Text;
    subject: Text;
  };

  public type Student = {
    firstName: Text;
    lastName: Text;
    speciality: Text;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public type State = {
    // this is the data you previously had as stable variables inside your actor class
    var controller: Principal;
    var teachers: [Teacher];
    var students: [Student];
  };

  public type Args = {
    #init: InitArgs;
    #upgrade: UpgradeArgs;
    #downgrade: DowngradeArgs;
    #none;
  };

  public type InitArgs = {
    controller: Principal;
  };
  public type UpgradeArgs = {
  };
  public type DowngradeArgs = {
  };

};