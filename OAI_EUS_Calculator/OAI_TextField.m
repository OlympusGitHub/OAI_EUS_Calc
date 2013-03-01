//
//  OAI_TextField.m
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/14/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import "OAI_TextField.h"

@implementation OAI_TextField

@synthesize elementName, elementNumberType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        fileManager = [[OAI_FileManager alloc] init];
        
        self.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        self.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.backgroundColor = [UIColor whiteColor];
        self.returnKeyType = UIReturnKeyDone;
        //self.delegate = self;
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
