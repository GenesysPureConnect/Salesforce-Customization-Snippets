/*
This requires two custom activity fields AssociatedCallTalkTime__c is going to be the
Call Duration from the call and will be populated on the callback object.

CallbackAssociatedCallId__c is the call id (not call id key) for the outbound call.  This field
needs to be mapped in IA to the interaction attribute EIC_CallbackAssociatedCallId
*/

trigger CopyCallDurationFromCallToAssociatedCallback on Task (before update) {
  for(Task t : Trigger.new){
      //sync both when the call task the callback task get updated
      // this way we will always sync regardless of which gets saved first
      if(t.Type == 'Call' && t.CallDurationInSeconds > 0){
          //this is a call being updated, find the callback
          Task[] callbacks = [SELECT Id, AssociatedCallTalkTime__c FROM Task
                                  WHERE ActivityDate = :t.ActivityDate
                                      AND Type='Callback'
                                      AND CallbackAssociatedCallId__c = :t.CallObject.SubString(0,10)];

          for(Task callback : callbacks){
              if(callback.PPS_ININ_AssociatedCallTalkTime__c != t.CallDurationInSeconds){
                  //only update the callback if the time is different
                  callback.PPS_ININ_AssociatedCallTalkTime__c = t.CallDurationInSeconds;
                  UPDATE callback;
              }
          }

      }
      else if(t.Type == 'Callback'){
          //this is a callback, find the call and get the call duration
          Task[] calls = [SELECT Id, CallDurationInSeconds FROM Task
                                  WHERE ActivityDate = :t.ActivityDate
                                      AND Type='Call'
                                      AND CallDurationInSeconds > 0
                                      AND CallObject LIKE :t.CallbackAssociatedCallId__c + '%'];

          for(Task call : calls){
              if(t.AssociatedCallTalkTime__c != call.CallDurationInSeconds){
                  //only update the callback if the time is different
                  t.AssociatedCallTalkTime__c = call.CallDurationInSeconds;

              }
          }

      }
  }
