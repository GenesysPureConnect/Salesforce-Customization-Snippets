@IsTest
private with sharing class CopyCallDurationFromCallTriggerTest{
    public CopyCallDurationFromCallTriggerTest(){}
    private static String s_callId = '1234567890';
    private static String s_callbackId = '9999999999';
    private static integer s_callbackDuration = 200;
    private static integer s_callDuration = 100;

    private static Task createCallback(){
        Task callback = new Task(Subject = 'Callback TEST',
                                ActivityDate = Date.Today(),
                                CallObject=s_callbackId,
                                Type='Callback',
                                CallDurationInSeconds=s_callbackDuration,
                                CallbackAssociatedCallId__c = s_callId
                                 );

        insert callback;

        return callback;
    }

    private static Task createCall(){
        Task call = new Task(Subject = 'Call TEST',
                                ActivityDate = Date.Today(),
                                Type='Call',
                                CallObject=s_callId + '20141022',
                                CallDurationInSeconds=s_callDuration
                                 );

        insert call;

        return call;
    }

    private static testmethod void testCallSavedAfterCallback(){
        Task callback = createCallback();
        callback.Description = 'update description';
        update callback;

        Task call = createCall();
        call.Description = 'update description';
        update call;

        Task newCallback = [Select Id, AssociatedCallTalkTime__c from TASK where id = :callback.Id];
        System.assert(newCallback.AssociatedCallTalkTime__c == call.CallDurationInSeconds);
    }

    private static testmethod void testCallbackSavedAfterCall(){
        Task call = createCall();
        call.Description = 'update description';
        update call;

        Task callback = createCallback();
        callback.Description = 'update description';
        update callback;



        Task newCallback = [Select Id, AssociatedCallTalkTime__c from TASK where id = :callback.Id];
        System.assert(newCallback.AssociatedCallTalkTime__c == call.CallDurationInSeconds);
    }
}​
