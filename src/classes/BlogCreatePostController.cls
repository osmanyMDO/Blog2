public class BlogCreatePostController {

    public Post__c postt { get; set; }

    public BlogCreatePostController() {
        this.postt = New Post__c();
        this.postt.Blog_Post__c = 'a0E360000034xpIEAQ';
    }

    public PageReference Save() {
        insert postt;
        return New Pagereference('/'+postt.id);
    } 
}