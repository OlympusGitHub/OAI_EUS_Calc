//
//  AppDelegate.h
//  OAI_EUS_Calculator
//
//  Created by Steve Suranie on 2/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAI_FileManager.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    //analytics
    NSString* ownerName;
    NSString* signOn;
    NSString* signOff;
    
    OAI_FileManager* fileManager;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@end
