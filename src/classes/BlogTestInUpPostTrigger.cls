@isTest
private class BlogTestInUpPostTrigger {

    @isTest static void TestInUpPostTrigger() {
        // Test data setup
        // crear un objeto post
        Post__c post = new Post__c(/*poner los datos del post*/);
        insert post;
        
        // crear los tags e insertarlos
        //insert tag;
        // crear el objeto de la relacion e insertarlo
        // insert obj
        
        // Perform test
        Test.startTest();
        //Database.DeleteResult result = Database.delete(acct, false);
        Test.stopTest();

        // Verify 
        // In this case the deletion should have been stopped by the trigger,
        // so verify that we got back an error.
        //System.assert(!result.isSuccess());
        //System.assert(result.getErrors().size() > 0);
        /*System.assertEquals('Cannot delete account with related opportunities.',
                             result.getErrors()[0].getMessage());*/
                             
                             
         /*Tambien puedo insertar un post y luego comprobar que haya una tag relacionada con el...*/                    
    }
    
}