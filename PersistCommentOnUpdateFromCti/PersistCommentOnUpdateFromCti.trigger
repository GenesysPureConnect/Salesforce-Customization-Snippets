trigger PersistCommentOnUpdateFromCti on Task (before update) {
   for (Task t : Trigger.new) {
      List<Task> existingTaskList = [SELECT id, Description FROM Task WHERE id = :t.id];
      if (existingTaskList.size() > 0) {
	if(t.Description == null || t.Description == ''){
	    t.Description = existingTaskList[0].Description;
	}
      }
   }
}

