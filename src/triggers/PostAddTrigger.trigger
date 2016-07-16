trigger PostAddTrigger on Post__c (after insert, after update) {
	
	Post__c post = Trigger.New[0];
	String postID = post.Id;

	String stringTags = post.Tag__c;	
	List<String> tagsName = stringTags.split(',');

	if(Trigger.isInsert){

		List<Tag__c> listTags = [SELECT ID, Name__c FROM Tag__c];

		Boolean exists = false;
		ID idTags;
		
		for(String tagN : tagsName){		
			for(Tag__c oTags : listTags){
				if(tagN == oTags.Name__c){						
					exists = true;
					JoPost_Tag__c jo = new JoPost_Tag__c(
						Post_JoPostTag__c= post.Id,
						Tag_joPostTag__c= oTags.Id
						);
					insert jo;
					break;
				}				
			}
			if(exists == false){
				System.debug('no existe');
                Tag__c tNew = new Tag__c(Name__c = tagN);
                System.debug(tNew);
				insert tNew;
                System.debug('inserte tag');
				JoPost_Tag__c jo2 = new JoPost_Tag__c(
					Post_JoPostTag__c = post.Id,
					Tag_joPostTag__c = tNew.Id
					);
				insert jo2;
			}
		}
	}
}



/*


DUDA


trigger SoqlTriggerNotBulk on Account(after update) {   
    for(Account a : Trigger.New) {
        Opportunity[] opps = [SELECT Id,Name,CloseDate 
                             FROM Opportunity WHERE AccountId=:a.Id];
                // Do some other processing
    }
} 

trigger SoqlTriggerBulk on Account(after update) {  
    for(Opportunity opp : [SELECT Id,Name,CloseDate FROM Opportunity
        WHERE AccountId IN :Trigger.New]) {
          // Do some other processing
    }
}

 */