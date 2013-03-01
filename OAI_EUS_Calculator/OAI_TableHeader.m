//
//  OAI_TableHeader.m
//  EUS Calculator
//
//  Created by Steve Suranie on 1/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_TableHeader.h"

@implementation OAI_TableHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        
        self.layer.borderColor = [colorManager setColor:66.0 :66.0 :66.0].CGColor;
        self.layer.borderWidth = 1.0;
        self.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.textColor = [colorManager setColor:66.0 :66.0:66.0];
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        
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
