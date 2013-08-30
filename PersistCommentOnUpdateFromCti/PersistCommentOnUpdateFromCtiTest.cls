@isTest
private class PersistCommentOnUpdateFromCtiTest{
  static testMethod void testPersistCommentOnUpdateFromCti(){     
    String testComments = 'Test Comments';

    Task t = new Task(Description= testComments);
    insert t;

    t.Description= '';
    update t;

    // Verify that the results are as expected.
    t = [SELECT Description, Id 
         FROM Task 
         WHERE Id = :t.Id];
    System.assertEquals(testComments, t.Description);
  }
}

