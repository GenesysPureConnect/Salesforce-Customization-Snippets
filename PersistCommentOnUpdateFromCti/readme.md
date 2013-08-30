When a user disconnects a call and then adds Comments for the Task (Not though the softphone, but though the actual Task), the comment is being erased after the call is de-allocated.

For the customer this trigger was written for, they don't use the CTI to edit task comments, rather for their business workflow needs, they edit the task directly.  When the call is removed from the softphone, the value of the Comments box in the softphone is saved to the task, thus overwriting any changes they have made directly in the Task.

On an update this trigger will check if the description (Comments) is empty and if it is, will update it to the existing value.  The case that won't work with this trigger is if someone wanted to actually remove all comments from the description.  It will also not work if they enter any characters into the comments field in the CTI. 
