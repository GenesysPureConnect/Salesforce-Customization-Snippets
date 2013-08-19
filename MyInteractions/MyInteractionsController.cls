public with sharing class MyInteractionsController {
    String m_filter = 'CreatedDate = TODAY';
    
    public List<Task> getMyTasks(){
       String query = 'SELECT Id, WhatId, What.Type, What.Name, what.Id, WhoId, Who.Type, Who.Name, Subject, Type, CreatedDate, OwnerId, ReminderTaskId__c FROM Task WHERE ' + m_filter + ' AND OwnerId = \'' + UserInfo.getUserId() +'\' and CallObject!= \'\'  Order By CreatedDate desc LIMIT 15';
       List<Task> tasks = Database.query(query);
       return tasks;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('CreatedDate = TODAY','Today'));
        options.add(new SelectOption('CreatedDate = YESTERDAY','Yesterday'));
        options.add(new SelectOption('CreatedDate = THIS_WEEK','Current Week'));
        options.add(new SelectOption('CreatedDate = LAST_WEEK','Last Week'));
        return options;
    }
    
    public String getFilter() {
        return m_filter ;
    }
        
    public void setFilter(String filter) {
       this.m_filter= filter ;
    }  

      private Task m_task;
    public String taskForReminder
    {
        get;
        set{
            m_task= getTask(value);
        }
    }
    
    private Task getTask(String id)
    {
        String query = 'SELECT Id, OwnerId, WhatId,WhoId,What.Name, Who.Name, ReminderTaskId__c  FROM Task WHERE id = \'' + id+ '\'';
        List<Task> tasks = Database.query(query);
        return tasks[0];
    }
    
    public PageReference processClearReminderClick(){
        Task reminderTask = getTask(m_task.ReminderTaskId__c);
        reminderTask.Status = 'Completed';
        update reminderTask;

        m_task.ReminderTaskId__c = '';
        update m_task;
        return null;
    }
    
    public PageReference processCreateReminderClick(){
         DateTime callbacktime = DateTime.now().addHours(24);
         
         String subject = 'Call Reminder: ';
         
         if(m_task.What != null)
         {
             subject += ' ' + m_task.What.Name;
         }
         
         if(m_task.Who!= null)
         {
             subject += ' (' + m_task.Who.Name + ')';
         }
         
         Task newTask = new Task(
             OwnerId = m_task.OwnerId,
             WhatId = m_task.WhatId,
             WhoId = m_task.WhoId,
             Subject = subject  + ' ' + getLocalDateTime(callbacktime) ,
    
             Priority = 'Normal',
             IsReminderSet = true,
             ReminderDateTime = System.now() + 1
         );
         insert newTask;
         
         m_task.ReminderTaskId__c = newTask.id;
         update m_task;
         return null;
    }
    
    public static Datetime getLocalDateTime(Datetime z)
    {    
        Datetime l = z.Date();
        l = l.addHours(z.hour());
        l = l.addMinutes(z.minute());
        l = l.addSeconds(z.second());
        
        return l;
    }
}