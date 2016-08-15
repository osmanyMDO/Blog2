trigger BlogInUpPostTrigger on Post__c (after insert, after update) {
    
    Set<Id> idPostDelJo = new Set<Id>();
    List<Tag__c> listTagsInsert = new List<Tag__c>();
    List<JoPost_Tag__c> listToDelete = new List<JoPost_Tag__c>();
    Map<Id,List<Tag__c>> mapIdPosListTags = new Map<Id,List<Tag__c>>();
    List<JoPost_Tag__c> listObPostTagInsert = new List<JoPost_Tag__c>();
    Map<Id,Set<String>> mapPostListTagNameUp = new Map<Id,Set<String>>();
    Map<Id,List<String>> mapPostListTagNameIn = new Map<Id,List<String>>();
    
    for(Post__c post : Trigger.New) {
        
        if(Trigger.isInsert && String.isNotBlank(post.Tag__c)) {
            mapPostListTagNameIn.put(post.Id, post.Tag__c.split(','));
        } 
        
        if(Trigger.isUpdate) {
            Post__c pOld = Trigger.oldMap.get(post.Id);
            if(pOld.Tag__c != post.Tag__c) {
                if(String.isBlank(post.Tag__c)){
                    //post Id to delete all tags associated
                    idPostDelJo.add(post.Id);
                } else {
                    mapPostListTagNameUp.put(post.Id, new Set<String>(post.Tag__c.split(',')));
                }
            }
        }
    }
    
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
        Map<Id,Tag__c> mapIdTags = new Map<Id,Tag__c>();
        Map<String,Tag__c> mapNameTags = new Map<String,Tag__c>();
        Map<Id,Set<String>> mapIdPostListNameTags = new Map<Id,Set<String>>();

        for(Tag__c ta : [SELECT ID, Name__c FROM Tag__c]){
            mapIdTags.put(ta.Id, ta);
            mapNameTags.put(ta.Name__c, ta);
        }
        
        for( JoPost_Tag__c obj : [SELECT Post_JoPostTag__c, Tag_joPostTag__c
                                  FROM JoPost_Tag__c
                                  WHERE Post_JoPostTag__c IN: mapPostListTagNameUp.keySet()] )
            												  
        {
            if(mapIdPostListNameTags.get(obj.Post_JoPostTag__c) == null) {
                mapIdPostListNameTags.put(obj.Post_JoPostTag__c, new Set<String>());
            }
            //mapa <IdPost, List de tag name asociadas al post>
            mapIdPostListNameTags.get(obj.Post_JoPostTag__c).add(mapIdTags.get(obj.Tag_joPostTag__c).Name__c);
        }
        
        for(Id postId : mapPostListTagNameUp.keySet()) {
            for(String tagUpName : mapPostListTagNameUp.get(postId)) {
                if( mapNameTags.get(tagUpName) == null){//el tags no existe
                    if((mapIdPostListNameTags.get(postId) != null && !mapIdPostListNameTags.get(postId).contains(tagUpName) ) || 
                       //si el mapa no es null y no contiene el tags que viene en la actualización
                       mapIdPostListNameTags.get(postId) == null) { //El post no tiene Tags asociadas
                           Tag__c tNew = new Tag__c(Name__c = tagUpName);
                           listTagsInsert.add(tNew);
                           if(mapIdPosListTags.get(postId) == null) {
                               mapIdPosListTags.put(postId, new List<Tag__c>());
                           }
                           mapIdPosListTags.get(postId).add(tNew);
                       }                     
                } else {
                    if(mapIdPosListTags.get(postId) == null) {
                        mapIdPosListTags.put(postId, new List<Tag__c>());
                    }
                    mapIdPosListTags.get(postId).add(mapNameTags.get(tagUpName));
                }
            }
            if(mapIdPostListNameTags.get(postId) != null) {
                for(String tagName : mapIdPostListNameTags.get(postId)) {
                    if(!mapPostListTagNameUp.get(postId).contains(tagName)) {
                        idPostToDelJo.add(postId);
                        idTagsToDelJo.add(mapNameTags.get(tagName).Id);
                    }
                }                
            }
        }
        listToDelete.addAll([SELECT Post_JoPostTag__c, Tag_joPostTag__c
                             FROM JoPost_Tag__c
                             WHERE Post_JoPostTag__c IN: idPostToDelJo AND Tag_joPostTag__c IN: idTagsToDelJo]);        
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
    
    if(!idPostDelJo.isEmpty()) {
        listToDelete.addAll([SELECT Post_JoPostTag__c, Tag_joPostTag__c
                             FROM JoPost_Tag__c
                             WHERE Post_JoPostTag__c IN: idPostDelJo]); 
    }
    
    if(!listToDelete.isEmpty()) {
        delete listToDelete;
    }
    
    if(!listObPostTagInsert.isEmpty()) {
        insert listObPostTagInsert;
    }	
}