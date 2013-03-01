//
//  OAI_MailManager.m
//  EUS Calculator
//
//  Created by Steve Suranie on 2/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_MailManager.h"

@implementation OAI_MailManager

+(OAI_MailManager *)sharedMailManager {
    
    static OAI_MailManager* sharedMailManager;
    
    @synchronized(self) {
        
        if (!sharedMailManager)
            
            sharedMailManager = [[OAI_MailManager alloc] init];
        
        return sharedMailManager;
        
    }
    
}


- (void) sendMail : (NSMutableDictionary*) mailData {
    
   
       
    

}



@end
