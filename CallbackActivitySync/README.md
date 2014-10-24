This trigger can be used with callback interactions and syncing data from the outbound call.  

This requires two custom activity fields AssociatedCallTalkTime__c is going to be the
Call Duration from the call and will be populated on the callback object.

CallbackAssociatedCallId__c is the call id (not call id key) for the outbound call.  This field
needs to be mapped in IA to the interaction attribute EIC_CallbackAssociatedCallId.
