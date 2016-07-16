public class CreatePostController {

    public Post__c postt {get; set;}

    public CreatePostController(){
        this.postt = New Post__c();
        this.postt.title__c = 'Title of post goes here...' ;
        this.postt.Description__c = 'Short description (optional) goes here...'; 
        this.postt.Post_body__c = 'Your text goes here...';
        this.postt.Tag__c = 'Tags of post goes here comma separated...';        
        
        
        this.postt.Blog_Post__c = 'a0E360000034xpIEAQ';
    }

    public PageReference Save() {
        insert postt;
        return New Pagereference('/'+postt.id);
    } 
    /*public PageReference Cancel() {
        return New Pagereference('/l');
    } */
}