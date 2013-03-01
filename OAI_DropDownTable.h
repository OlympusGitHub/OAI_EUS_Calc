//
//  OAI_DropDownTable.h
//  OAI_EUS_Calculator
//
//  Created by Steve Suranie on 2/15/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownTableDelegate
- (void)itemSelected:(NSString *)itemSelected;
@end

@interface OAI_DropDownTable : UITableViewController {
    
    NSString* itemSelected;
}

@property (nonatomic, retain) NSMutableArray* tableItemList;
@property (nonatomic, assign) id<DropDownTableDelegate> delegate;
@property (nonatomic, retain) UIPopoverController* myPopoverController;


@end
