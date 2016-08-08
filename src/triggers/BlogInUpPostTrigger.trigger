trigger BlogInUpPostTrigger on Post__c (after insert, after update) {
    
    Set<Id> postIds = new Set<Id>();
    List<Tag__c> listTagsInsert = new List<Tag__c>();
    Map<Id,List<Tag__c>> mapIdPosListTags = new Map<Id,List<Tag__c>>();
    List<JoPost_Tag__c> listObPostTagInsert = new List<JoPost_Tag__c>();
    Map<Id,List<String>> mapPostListTagNameIn = new Map<Id,List<String>>();
    Map<Id,Set<String>> mapPostListTagNameUp = new Map<Id,Set<String>>();
    
    for(Post__c post : Trigger.New) {
        if(Trigger.isInsert && String.isNotBlank(post.Tag__c)) {
            mapPostListTagNameIn.put(post.Id, post.Tag__c.split(','));
        } 
        if(Trigger.isUpdate) {
            Post__c pOld = Trigger.oldMap.get(post.Id);
            if(String.isBlank(post.Tag__c)){
                //get the ID of the post to remove all relations with TAGS
                //It is not done yet
            }
            if(pOld.Tag__c != post.Tag__c) {
                mapPostListTagNameUp.put(post.Id, new Set<String>(post.Tag__c.split(',')));
            }
        }
    } 
    
    Map<Id,Tag__c> mapTags = new Map<Id,Tag__c>([SELECT ID, Name__c FROM Tag__c]);
    
    if(mapPostListTagNameIn.keySet() != null) {
        Boolean flagExists;
        for(Id postId : mapPostListTagNameIn.keySet()) {
            for(String tagN : mapPostListTagNameIn.get(postId)) {
                flagExists = false;
                for(Tag__c oTags : [SELECT ID, Name__c FROM Tag__c]) {
                    if(tagN == oTags.Name__c) {						
                        flagExists = true;							
                        listObPostTagInsert.add(new JoPost_Tag__c (
                            Post_JoPostTag__c= postId,
                            Tag_joPostTag__c= oTags.Id
                        ));
                        break;
                    }				
                }
                if(flagExists == false) {
                    Tag__c tNew = new Tag__c(Name__c = tagN);
                    listTagsInsert.add(tNew);
                    if(mapIdPosListTags.get(postId) == null) {
                        mapIdPosListTags.put(postId, new List<Tag__c>());
                    }
                    mapIdPosListTags.get(postId).add(tNew);
                }
            }
        }
    }
    
    if(mapPostListTagNameUp.keySet() != null) {
        Set<Id> idPostToDelJo = new Set<Id>();
        Set<Id> idTagsToDelJo = new Set<Id>();
        Map<Id,Set<String>> mapIdPostListNameTags = new Map<Id,Set<String>>();
        
        
        for( JoPost_Tag__c obj : [SELECT Post_JoPostTag__c, Tag_joPostTag__c
                                  FROM JoPost_Tag__c
                                  WHERE Post_JoPostTag__c IN: mapPostListTagNameUp.keySet()] )
            												  
        {
            if(mapIdPostListNameTags.get(obj.Post_JoPostTag__c) == null) {
                mapIdPostListNameTags.put(obj.Post_JoPostTag__c, new Set<String>());
            }
            mapIdPostListNameTags.get(obj.Post_JoPostTag__c).add(mapTags.get(obj.Tag_joPostTag__c).Name__c);
        }
        
        for(Id postId : mapPostListTagNameUp.keySet()) {
            for(String tagUpName : mapPostListTagNameUp.get(postId)) {
                if(!mapIdPostListNameTags.get(postId).contains(tagUpName)) {
                    Tag__c tNew = new Tag__c(Name__c = tagUpName);
                    listTagsInsert.add(tNew);
                    if(mapIdPosListTags.get(postId) == null) {
                        mapIdPosListTags.put(postId, new List<Tag__c>());
                    }
                    mapIdPosListTags.get(postId).add(tNew);
                }
            }
            for(String tagName : mapIdPostListNameTags.get(postId)){
                if(!mapPostListTagNameUp.get(postId).contains(tagName)) {
                    idPostToDelJo.add(postId);
                    idTagsToDelJo.add('lolo');
                }
            }
        }
    }
    
    if(mapIdPosListTags.keySet() != null) {
        insert listTagsInsert; 
        for(Id postId : mapIdPosListTags.keySet()) {
            for(Tag__c tag : mapIdPosListTags.get(postId)) {
                JoPost_Tag__c jo = new JoPost_Tag__c (
                    Post_JoPostTag__c= postId,
                    Tag_joPostTag__c= tag.Id
                );							
                listObPostTagInsert.add(jo);
            }
        }
    }
    
    if(!listObPostTagInsert.isEmpty()) {
        insert listObPostTagInsert;
    }	
}