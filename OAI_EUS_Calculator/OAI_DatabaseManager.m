//
//  OAI_DatabaseManager.m
//  EUS Calculator
//
//  Created by Steve Suranie on 2/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_DatabaseManager.h"

@implementation OAI_DatabaseManager

@synthesize dbData, dbName, dbTable;

- (void) pushData {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:@"http://stevesuranie.com/MirrorBox/index.php?process=push&userID=66&programID=100"];
        NSString *json = [NSString stringWithContentsOfURL:url
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
        
        if(!error) {
            
            NSData *jsonData = [json dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:kNilOptions
                                                                       error:&error];
            
            NSLog(@"%@", jsonDict);
        }
        
    });
    
    
}

- (void) pullData {
    
}

@end
