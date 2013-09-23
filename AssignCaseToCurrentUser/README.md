**Overview**

This is a salesforce customization to be able to auto assign Salesforce user's to a case.  We can use the Salesforce integrations ability to screen pop Visualforce pages to execute this functionality in a screen pop.

**Example URL:**
https://na5.salesforce.com/apex/assigncasetocurrentuser?id=50070000003ooS4

Where the id the behind the scenes object id for the case (not the case number).   The Apex could easily be changed to use CaseNumber though. 

**Interaction Attributes:**
Below is a list of attributes to assign on the interaction which will cause the case to pop and auto assign to the current Salesforce user in the process.

*SF_URLPop* - URL not including the salesforce domain.  In the example URL that would be apex/assigncasetocurrentuser?id=50070000003ooS4.  For the id=<XXX> portion, XXX needs to be the case id of the case created.

*SF_URLPopLink* - 
The “link” text is shown in the form of a hyperlink that the agent clicks to execute the screen pop. In this example, set it to "Case" 

*SF_URLPopObjectType* - This attribute should contain the name for the Label next to the link shown for the URLPopLink.  In this example, set it to "Case" 
