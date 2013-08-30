The My Interactions custom page will let you add a custom page to show the current user's interactions.  The interactions can be filtered by 'Today', 'Yesterday', 'Current Week', and 'Last Week'.  This example will also let you create a callback task 24 hours from now and get a reminder to call the person back.

![My Interactions](https://github.com/InteractiveIntelligence/Salesforce-Customization-Snippets/blob/master/MyInteractions/doc/myinteractions.png?raw=true)

# Setup
1. Create a custom Task Field called ReminderTaskId__c.  This field is used to track the callback task that gets created. 
2. Create a new controller in Setup -> App Setup -> Develop -> Apex Classes.  Paste the contents of MyInteractionsController.cls into the new controller
3. Create a new Visualforce page in Setup -> App Setup -> Develop -> Pages.  Paste the contents of MyInteractions.page into the Visualforce page.


#Creating a tab in the Service Cloud Console
1. Go to Setup -> App Setup -> Customize -> Service Cloud Console -> Custom Console Components
2. Create a new component ![Console Component](https://github.com/InteractiveIntelligence/Salesforce-Customization-Snippets/blob/master/MyInteractions/doc/consolecomponent.png?raw=true)
3. Add the component to your console app Setup -> Create -> Apps -> Select console app
4. Scroll down to "Choose Custom Console Componts" and select the new component. 
