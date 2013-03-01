//
//  OAI_MailManager.h
//  EUS Calculator
//
//  Created by Steve Suranie on 2/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface OAI_MailManager : NSObject <MFMailComposeViewControllerDelegate>

+(OAI_MailManager* )sharedMailManager;


- (void) sendMail : (NSMutableDictionary*) mailData;

@end
