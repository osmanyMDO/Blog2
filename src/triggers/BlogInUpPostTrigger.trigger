trigger BlogInUpPostTrigger on Post__c (after insert, after update) {

/*	
	Post__c post = Trigger.New[0];
	String postID = post.Id;
	String stringTags = post.Tag__c;
	
	if(stringTags != null) {
		List<String> tagsName = stringTags.split(',');		
		
		if(Trigger.isInsert) {
			List<Tag__c> listTags = [SELECT ID, Name__c FROM Tag__c];
			Boolean exists = false;
			ID idTags;
			List<JoPost_Tag__c> listObPostTagInsert = new List<JoPost_Tag__c> ();
			//List<Tag__c> listTagsInsert = new List<Tag__c>();
			
			for(String tagN : tagsName) {		
				for(Tag__c oTags : listTags) {
					if(tagN == oTags.Name__c) {						
						exists = true;
						JoPost_Tag__c jo = new JoPost_Tag__c (
							Post_JoPostTag__c= post.Id,
							Tag_joPostTag__c= oTags.Id
							);
						//insert jo;
						listObPostTagInsert.add(jo);
						break;
					}				
				}
				if(exists == false) {
	                Tag__c tNew = new Tag__c(Name__c = tagN);
	                //System.debug(tNew);
	                //listTagsInsert.add(tNew);
					insert tNew;
					JoPost_Tag__c jo2 = new JoPost_Tag__c(
						Post_JoPostTag__c = post.Id,
						Tag_joPostTag__c = tNew.Id
						);
					listObPostTagInsert.add(jo2);
					//insert jo2;
				}
			}
			System.debug(listObPostTagInsert);
			if( listObPostTagInsert.size() > 0) {
				System.debug(listObPostTagInsert);
				insert listObPostTagInsert;
			}
		}		
	
	}
*/	
	
	
	//Refactorizando
	
	String postID;
	String stringTags;
	
	List<String> tagsName = new List<String>(); 

	List<Tag__c> listTags = [SELECT ID, Name__c FROM Tag__c];
	
	List<Tag__c> listTagsInsert = new List<Tag__c>();
	List<JoPost_Tag__c> listObPostTagInsert = new List<JoPost_Tag__c> ();
	Map<ID,Tag__c> listTag_IdPost = new Map<ID,Tag__c>();
	
	for(Post__c post : Trigger.New){
		
		postID = post.Id;
		stringTags = post.Tag__c;
		
		if(stringTags != null) {
			tagsName = stringTags.split(',');		
			
			if(Trigger.isInsert) {				
				Boolean exists = false;
				ID idTags;
				
				for(String tagN : tagsName) {		
					for(Tag__c oTags : listTags) {
						if(tagN == oTags.Name__c) {						
							exists = true;
							JoPost_Tag__c jo = new JoPost_Tag__c (
								Post_JoPostTag__c= post.Id,
								Tag_joPostTag__c= oTags.Id
								);							
							listObPostTagInsert.add(jo);
							break;//refactorizar usando un while...
						}				
					}
					if(exists == false) {
		                Tag__c tNew = new Tag__c(Name__c = tagN);
		                listTagsInsert.add(tNew);
		                listTag_IdPost.put(post.Id,tNew);
					}
				}

			}
		}
	}
	if( !listTagsInsert.isEmpty()) {
		insert listTagsInsert;
		Set<ID> idsTags = new Set<ID>(); 
		//recorrer map donde tengo todos los id de los post y el set de id de tag para crear el joPostTags
		
		/*for(Tag__c t : listTagsInsert) {
			//idsTags.add(t.id);
			JoPost_Tag__c jo2 = new JoPost_Tag__c (
					Post_JoPostTag__c = post.Id,
					Tag_joPostTag__c = t.Id
				);
				listObPostTagInsert.add(jo2);
		}*/
		
		/*

		map<id, string=""> myAMap = new map<id, string="">();
		for ( Account a : myAccounts ){
		    myAMap.put(a.ID, a.Name);
		}
		
		for ( ID aID : myAMap.keySet() ){
		    system.debug(loggingLevel.debug, myAMap.get(aID));
		}
		
		
		*/
		
		
	}	

	
	if( listObPostTagInsert.size() > 0) {
		System.debug(listObPostTagInsert);
		insert listObPostTagInsert;
	}	
}

