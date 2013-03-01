//
//  OAI_DatabaseManager.h
//  EUS Calculator
//
//  Created by Steve Suranie on 2/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAI_DatabaseManager : NSObject

@property (nonatomic, retain) NSString* dbName;
@property (nonatomic, retain) NSString* dbTable;
@property (nonatomic, retain) NSMutableDictionary* dbData;

- (void) pushData;

- (void) pullData;

@end
