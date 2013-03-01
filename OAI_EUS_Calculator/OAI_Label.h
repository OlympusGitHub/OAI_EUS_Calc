//
//  OAI_Label.h
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/20/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAI_ColorManager.h"

@interface OAI_Label : UILabel {
    
    OAI_ColorManager* colorManager;
}

@property (nonatomic, retain) NSString* labelID;

@end
