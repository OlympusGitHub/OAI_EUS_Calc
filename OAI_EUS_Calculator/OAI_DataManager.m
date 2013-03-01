//
//  OAI_DataManager.m
//  EUS Calculator
//
//  Created by Steve Suranie on 1/30/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_DataManager.h"

@implementation OAI_DataManager 
    

+(OAI_DataManager *)sharedDataManager {
    
    static OAI_DataManager* sharedDataManager;
    
    @synchronized(self) {
        
        if (!sharedDataManager)
            
            sharedDataManager = [[OAI_DataManager alloc] init];
        
        return sharedDataManager;
        
    }
    
}

- (NSMutableDictionary* ) getDataSources : (UIScrollView*) parentView {
    
    //get all the scroll view pages
    NSArray* scrollViewPages = [parentView subviews];
    NSMutableDictionary* calculatorValues = [[NSMutableDictionary alloc] init];
    
    //loop
    for(int i=0; i<scrollViewPages.count; i++) {
        
        //filter the last page (the calculations display)
        if (i>0 && i<scrollViewPages.count-1) {
            UIView* thisPage = [scrollViewPages objectAtIndex:i];
        
            //get all the objects of this calcsection
            NSArray* thisPageObjects = [thisPage subviews];
            
            //the tables are always in the uivew which is always the second object
            UIView* tableWrapper = [thisPageObjects objectAtIndex:1];
            
            //get all the subviews here
            NSArray* tableElements = [tableWrapper subviews];
            
            //loop
            for(int e=0; e<tableElements.count; e++) {
                
                
                 //filter the header rows
                if (e>0) { 
                    
                    //this is for the net profit
                    NSString* thisTextFieldValue;
                    
                    if ([[tableElements objectAtIndex:e] isMemberOfClass:[UIView class]]) {
                    
                        UIView* thisTableRow = [tableElements objectAtIndex:e];
                        
                        NSArray* thisTableRowObjs = thisTableRow.subviews;
                        
                        for(int o=0; o<thisTableRowObjs.count; o++) {
                            
                            if ([[thisTableRowObjs objectAtIndex:o] isMemberOfClass:[OAI_TextField class]]) {
                                
                                OAI_TextField* thisTextField = (OAI_TextField*)[thisTableRowObjs objectAtIndex:o];
                                
                                NSMutableDictionary* thisTextFieldProps = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        thisTextField.elementName, @"Element Name",
                                        thisTextField.elementNumberType, @"Element Number Type",
                                        thisTextField.text, @"Element Value", 
                                nil];
                                
                                [calculatorValues setObject:thisTextFieldProps forKey:thisTextField.elementName];
                                
                            }
                        }
                        
                    } else {
                        
                        if([[tableElements objectAtIndex:e] isMemberOfClass:[OAI_TextField class]]) {
                            
                            OAI_TextField* thisTextField = (OAI_TextField*)[tableElements objectAtIndex:e];
                            thisTextFieldValue = thisTextField.text;
                            
                            NSMutableDictionary* thisTextFieldProps = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    thisTextField.elementName, @"Element Name",
                                    thisTextField.elementNumberType, @"Element Number Type",
                                    thisTextField.text, @"Element Value",
                                                                       nil];
                            
                            [calculatorValues setObject:thisTextFieldProps forKey:thisTextField.elementName];
                        }
                    }
                
                }
            }
        }
        
    }
    
    return calculatorValues;
}

@end
