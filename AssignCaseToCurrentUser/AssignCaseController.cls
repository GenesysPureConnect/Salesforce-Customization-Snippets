public class AssignCaseController{
    private final ApexPages.StandardController m_controller;
    
    public AssignCaseController(ApexPages.StandardController controller){
        m_controller = controller;
    }
    
    //code we will invoke on page load
    public PageReference autoRun(){
        for(Case c:[select id, OwnerId from Case where id =:m_controller.getId()]){
            c.OwnerId = UserInfo.getUserId();
            update c;
        }
        
        return m_controller.view().setRedirect(true);
    }
    
}
