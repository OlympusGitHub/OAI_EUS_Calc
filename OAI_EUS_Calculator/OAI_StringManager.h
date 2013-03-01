//
//  OAI_StringManager.h
//  EUS Calculator
//
//  Created by Steve Suranie on 1/9/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAI_StringManager : NSObject {
    
}

@property (nonatomic, retain) NSString* introduction;
@property (nonatomic, retain) NSString* instructions;
@property (nonatomic, retain) NSString* helpCasesPerWeek;
@property (nonatomic, retain) NSString* helpLaborCost;
@property (nonatomic, retain) NSString* helpServiceQuote;
@property (nonatomic, retain) NSString* helpVariableCost;
@property (nonatomic, retain) NSString* helpAdditionalCost;
@property (nonatomic, retain) NSString* helpMedicareReimbursement;
@property (nonatomic, retain) NSString* helpNonMedicareReimbursement;
@property (nonatomic, retain) NSString* helpMedicareFacilityFee;
@property (nonatomic, retain) NSString* helpNonMedicareFacilityFee;
@property (nonatomic, retain) NSString* helpPhysicianFee;
@property (nonatomic, retain) NSString* helpSecondProvider;
@property (nonatomic, retain) NSString* helpAnasthesiaPayment;
@property (nonatomic, retain) NSString* helpPathology;
@property (nonatomic, retain) NSString* helpSurgery;
@property (nonatomic, retain) NSString* helpAdmissions;
@property (nonatomic, retain) NSString* helpOncology;
@property (nonatomic, retain) NSString* helpRadiology;
@property (nonatomic, retain) NSString* helpAnesthesia;
@property (nonatomic, retain) NSString* disclaimer;
@property (nonatomic, retain) NSMutableArray* assumptionsArray;
@property (nonatomic, retain) NSMutableArray* reimbursementArray;

+(OAI_StringManager* )sharedStringManager;



@end
