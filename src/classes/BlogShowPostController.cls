public class BlogShowPostController {
    
    public Post__c posts { get;set; }
    public String bodyComment { get;set; }
    public String authorComment { get;set; }
    
    public BlogShowPostController() {
        String pId = apexpages.currentpage().getparameters().get('postID');
        posts = [SELECT ID,Title__c, CreatedById, Created_Date__c, Imagen__c, Photo__c, Owner__c, Post_body__c, Tag__c,
                 (SELECT Id, Body__c, Owner__c, Author__c, LastModifiedDate FROM Comments__r ORDER BY LastModifiedDate ASC NULLS LAST)
                 FROM Post__c 
                 WHERE ID=:pId];          
    }
    
    public Post__c getPost() { return posts; }     
    public String getBodyComment() { return bodyComment; }    
    public String getAuthorComment() { return authorComment; }
    
    public Pagereference postComment() {
        Comment__c co = new Comment__c(
            Author__c = authorComment,
            Body__c = bodyComment,
            Comment_Post__c = posts.Id
        );
        insert co;
        return New Pagereference('/apex/BlogShowPost?postID=' + posts.Id);
    }    
}