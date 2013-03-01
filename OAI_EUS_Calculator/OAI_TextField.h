//
//  OAI_TextField.h
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/14/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAI_ColorManager.h"
#import "OAI_FileManager.h"

@interface OAI_TextField : UITextField  {
    
    OAI_ColorManager* colorManager;
    OAI_FileManager* fileManager;
    
}

@property (nonatomic, retain) NSString* elementName;
@property (nonatomic, retain) NSString* elementNumberType;


@end
