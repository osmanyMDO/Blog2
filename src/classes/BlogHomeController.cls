public class BlogHomeController {
    
    public List<Post__c> posts {get;set;}
    
    
    public BlogHomeController(){
        posts = [SELECT ID,Title__c,Description__c, CreatedById, Created_Date__c,Imagen__c, Photo__c, Owner__c FROM Post__c];          
    }    
    public List<Post__c> getPost(){
        return posts;
    } 
}