//
//  OAI_DataManager.h
//  EUS Calculator
//
//  Created by Steve Suranie on 1/30/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAI_TextField.h"

@interface OAI_DataManager : NSObject {
    
}

+(OAI_DataManager* )sharedDataManager;

- (NSMutableDictionary* ) getDataSources : (UIScrollView*) parentView;

@end
