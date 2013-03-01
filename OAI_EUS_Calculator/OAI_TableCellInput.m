//
//  OAI_TableCellInput.m
//  EUS Calculator
//
//  Created by Steve Suranie on 1/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_TableCellInput.h"

@implementation OAI_TableCellInput

@synthesize cellID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        
        self.font = [UIFont fontWithName:@"Helvetica" size:20];
        self.textColor = [colorManager setColor:66.0 :66.0:66.0];
        self.backgroundColor = [UIColor whiteColor];
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.userInteractionEnabled = YES;
        
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
