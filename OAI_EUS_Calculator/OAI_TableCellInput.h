//
//  OAI_TableCellInput.h
//  EUS Calculator
//
//  Created by Steve Suranie on 1/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"


@interface OAI_TableCellInput : UITextField {
 
    OAI_ColorManager* colorManager;
}

@property(nonatomic, retain) NSString* cellID;

@end
