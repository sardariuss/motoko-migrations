import Migration001 "./00-01-00-initial/types";
import Migration002 "./00-02-00-add-full-name/types";
import Migration003 "./00-03-00-trie/types";

module {
  // do not forget to change current migration when you add a new one
  // you should use this field to import types from you current migration anywhere in your project
  // instead of importing it from migration folder itself
  public let Current = Migration001;
  public type Args = Migration001.Args;

  public type State = {
    #v0_1_0: Migration001.State;
    #v0_2_0: Migration002.State;
    #v0_3_0: Migration003.State;
    // do not forget to add your new migration data types here
  };

};