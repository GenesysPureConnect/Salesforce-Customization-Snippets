public with sharing class MyInteractionsController {

    public static integer PageSize = 10;
        
    private String m_filter = 'CreatedDate = TODAY';
    private integer m_currentOffset = 0;
    private integer m_totalResults;    
    private Task m_task;
    
    //not sure if this is the best option here.  We want the phone and mobile off the who, but when selecting task.who.phone, it returns null.
    public class CallRecord {
        private Task m_task;
        private String m_phone;
        
        public CallRecord(Task task)
        {
            m_task = task;  
            if(task.who.type == 'Contact'){
                Contact c = ((Contact)Database.query('Select Phone, MobilePhone FROM ' + task.who.type + ' WHERE id= \'' + task.who.id + '\'')[0]);
                if(c.phone != null){
                    m_phone = c.phone;
                }
                else{
                    m_phone = c.mobilePhone;
                }
            }
        }
        
        public String getSubject(){
            return String.valueOf(m_task.Subject);
        }
        
        public String getId(){
            return String.valueOf(m_task.id);
        }
        
        public String getRelatedTo(){
            return m_task.what.name;
        }
        
        public String getRelatedToId(){
            return String.valueOf(m_task.what.id);
        }
        
        public String getWhoName(){
            return m_task.who.name;
        }
        
         public String getWhoId(){
            return String.valueOf(m_task.who.id);
        }
        
        public String getReminderTaskId(){
            return m_task.reminderTaskId__c;
        }
        
        public String getPhone(){
            return m_phone;
        }
    }
    
    public MyInteractionsController()
    {
       m_totalResults = Database.countQuery('select count() FROM Task ' + queryStringWhere());
    }

    private static String queryStringWhere(){
        return 'WHERE OwnerId = \'' + UserInfo.getUserId() +'\' and CallObject!= \'\' ';            
     // return 'WHERE ' + m_filter + ' and OwnerId = \'' + UserInfo.getUserId() +'\' and CallObject!= \'\' ;    
    }
    
    private static String queryStringSelect(){
        return 'SELECT Id, WhatId, What.Type, What.Name, what.Id, WhoId, Who.Type, who.name, Subject, Type, CreatedDate, OwnerId, ReminderTaskId__c ';
    }
    
    private static String queryString(){
         return queryStringSelect() + ' FROM Task ' + queryStringWhere() + ' Order By CreatedDate desc';
    }
    
    public List<CallRecord> getMyTasks(){
        String query = queryString() + ' LIMIT ' + PageSize  + ' OFFSET ' + m_currentOffset ;
        List<Task> tasks = Database.query(query);

        List<CallRecord> records = new List<CallRecord>();
        for(Task t: tasks){
            records.add(new CallRecord(t));
        }
        return records;
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

    public String taskForReminder
    {
        get;
        set{
            m_task= getTask(value);
        }
    }
    
    public static Task getTask(String id)
    {
        String query = queryStringSelect() + ' FROM Task WHERE id = \'' + id+ '\'';
        List<Task> tasks = Database.query(query);
        return tasks[0];
    }
    
    //start methods to create/clear the callback
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
             Subject = subject  + ' ' + getLocalDateTime(callbacktime).format('M-d-yyyy h:mm:ss a'),
    
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
    
    //Start methods needed for paging
    public PageReference Beginning() {
      m_currentOffset = 0;
      return null;
    }
 
    public PageReference Previous() {
      m_currentOffset -= PageSize ;
      return null;
    }
 
    public PageReference Next() { 
      m_currentOffset += PageSize ;
      return null;
    }
 
    public PageReference End() {
      m_currentOffset = m_totalResults- math.mod(m_totalResults, PageSize );
      return null;
    }
 
    public Boolean getDisablePrevious() { 
      if (m_currentOffset >0){
          return false;
      }
      else
      {
          return true;
      }
    }
 
    public Boolean getDisableNext() { 
      if (m_currentOffset + PageSize  < m_totalResults){
          return false;
      }
      else
      {
          return true;
      }
    }
   
    public integer getCurrentOffset(){
       return m_currentOffset;
    }
}
