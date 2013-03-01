//
//  OAI_Label.m
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/20/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import "OAI_Label.h"

@implementation OAI_Label

@synthesize labelID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        
        self.font = [UIFont fontWithName:@"Helvetica" size: 20.0];
        self.textColor = [colorManager setColor:08.0 :25.0 :102.0];
        self.backgroundColor = [UIColor clearColor];
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping ;
        
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
