public class BlogShowPostController {
    
    public Post__c posts {get;set;}
    
    public BlogShowPostController(){
        String pId = apexpages.currentpage().getparameters().get('postID');
        posts = [SELECT ID,Title__c, CreatedById, Created_Date__c,Imagen__c, Photo__c, Owner__c,Post_body__c,Tag__c, (SELECT Id,Body__c,Owner__c FROM Comments__r) FROM Post__c WHERE ID=:pId];          
    }
    
    public Post__c getPost(){
        return posts;
    } 
    
}