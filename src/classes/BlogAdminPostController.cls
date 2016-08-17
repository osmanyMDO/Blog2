public class BlogAdminPostController {
    
    public List<Post__c> posts {get;set;}    
    
    public BlogAdminPostController(){
       /* String pId = apexpages.currentpage().getparameters().get('postID');
        if(String.isNotBlank(pId)) {
            DeletePost(pId);
        }*/
        posts = [SELECT ID,Title__c, Created_Date__c, Owner__c FROM Post__c ORDER BY LastModifiedDate DESC NULLS LAST];
    }
    
    public List<Post__c> getPost(){
        return posts;
    } 
    
    /*
    static void DeletePost(String pId){
        List<Post__c> po = new List<Post__c>([SELECT ID,Title__c, Created_Date__c, Owner__c FROM Post__c WHERE ID =: pId]);
        if(po != null) {
            delete po;
        }
    }*/
}