public class BlogAdminPostController {
    
    public List<Post__c> posts {get;set;}
    
    
    public BlogAdminPostController(){
        posts = [SELECT ID,Title__c, Created_Date__c, Owner__c FROM Post__c];          
    }
    
    public List<Post__c> getPost(){
        return posts;
    } 
}