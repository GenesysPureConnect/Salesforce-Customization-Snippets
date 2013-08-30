@isTest
public class MyInteractionsControllerTests{
  static testMethod void testCallRecord(){   
    String firstName = 'first'; 
    String lastName = 'last';
    Contact c = new Contact(firstname = firstName, lastname = lastName);
    insert c;
    
    String accountName = 'account name';
    Account a = new Account(Name = accountName);
    insert a;
    
    String taskSubject = 'subject';
    String reminderId = '23sdfasdf;lkj';
    
    Task t = new Task(whoid = c.id, whatid=a.id, subject = taskSubject, reminderTaskId__c=reminderId);
    insert t;
    
    t = MyInteractionsController.getTask(t.id);


    MyInteractionsController.CallRecord record = new MyInteractionsController.CallRecord(t);
    System.assertEquals(taskSubject, record.getSubject());
    System.assertEquals(String.valueOf(t.id), record.getId());
    System.assertEquals(String.valueOf(a.id), record.getRelatedToId());
    System.assertEquals(String.valueOf(c.id), record.getWhoId());        
    System.assertEquals(firstName + ' ' + lastName, record.getWhoName());
    System.assertEquals(accountName, record.getRelatedTo());
    System.assertEquals(reminderId, record.getReminderTaskId());
                
  }
  
  static testMethod void testCallRecordPhone(){   
    String phone = '2222222'; 
    String firstName = 'first'; 
    String lastName = 'last';
    Contact c = new Contact(firstname = firstName, lastname = lastName, phone = phone);
    insert c;
    
    Task t = new Task(whoid = c.id);
    insert t;
    
    t = MyInteractionsController.getTask(t.id);

    MyInteractionsController.CallRecord record = new MyInteractionsController.CallRecord(t);
    System.assertEquals(phone, record.getPhone());
  }
  
  static testMethod void testCallRecordMobilePhone(){   
    String phone = '2222222'; 
    String firstName = 'first'; 
    String lastName = 'last';
    Contact c = new Contact(firstname = firstName, lastname = lastName, mobilephone = phone);
    insert c;
    
    Task t = new Task(whoid = c.id);
    insert t;
    
    t = MyInteractionsController.getTask(t.id);

    MyInteractionsController.CallRecord record = new MyInteractionsController.CallRecord(t);
    System.assertEquals(phone, record.getPhone());
  }
  
  static testMethod void testFilterItems(){   
    MyInteractionsController controller = new MyInteractionsController();
    System.assert( controller.getItems().size() > 0);
    System.assert(controller.getFilter() != null);
    
    String afterFilter = 'sdfasfsadflakjfa';  
    controller.setFilter(afterFilter);
    System.assertEquals(afterFilter, controller.getFilter());
  }
  
  static testMethod void testProcessClearReminderClick(){   
    Task reminder = new Task();
    System.assertNotEquals('Completed', reminder.Status);
    insert reminder;
    
    Task t = new Task(reminderTaskId__c = reminder.id);
    insert t;
    
    MyInteractionsController controller = new MyInteractionsController();
    controller.taskForReminder = String.valueOf(t.id);
    controller.processClearReminderClick();
        
    reminder = [Select id, status from task where id=:reminder.id][0];
    System.assertEquals('Completed', reminder.Status);
    
    t  = [Select id, reminderTaskId__c from task where id=:t.id][0];
    System.assertEquals(null,t.reminderTaskId__c);
   
  }
  
  static testMethod void testProcessCreateReminderClick(){   
    
    Task t = new Task();
    insert t;
    
    MyInteractionsController controller = new MyInteractionsController();
    controller.taskForReminder = String.valueOf(t.id);
    controller.processCreateReminderClick();

    t  = [Select id, reminderTaskId__c from task where id=:t.id][0];
    System.assertNotEquals('',t.reminderTaskId__c);
    
    List<Task> reminders = [Select id, status from task where id=:t.reminderTaskId__c];
    System.assert(reminders.size() > 0);
       
  }
  
  static testMethod void testPaging(){
    //make sure we have enough tasks for multiple pages
    for(integer count = 0; count < 40; count++)
    {
      Task t = new Task(OwnerId = UserInfo.getUserId(), CallObject = 'dsaflkj');
      insert t;
    }
  
     
    MyInteractionsController controller = new MyInteractionsController();
    
    System.assert(controller.getMyTasks().size() > 0);
    
    System.assertEquals(0,controller.getCurrentOffset());
    System.assert(controller.getDisablePrevious());
    System.assert(!controller.getDisableNext());
            
    controller.Next();
    System.assertNotEquals(0,controller.getCurrentOffset());
    System.assert(!controller.getDisablePrevious());
    System.assert(!controller.getDisableNext());
      
    controller.Previous();
    System.assertEquals(0,controller.getCurrentOffset());
    System.assert(controller.getDisablePrevious());
    System.assert(!controller.getDisableNext());
      
    controller.End();
    System.assert(!controller.getDisablePrevious());
    System.assert(controller.getDisableNext());
  }
}
