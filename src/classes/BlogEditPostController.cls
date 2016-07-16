public class BlogEditPostController {

	public Post__c postt {get; set;}
    
    public BlogEditPostController(){
        String pId = apexpages.currentpage().getparameters().get('postID');
        this.postt = [SELECT ID,Title__c, Name, CreatedById,Description__c, Created_Date__c,Imagen__c, Photo__c, Owner__c,Post_body__c,Tag__c FROM Post__c WHERE ID=:pId];          
    }
    
    public Post__c getPost(){
        return postt;
    }         

    public PageReference Save() {
        update postt;
        return New Pagereference('/'+postt.id);
    } 
}