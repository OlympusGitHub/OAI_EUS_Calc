//
//  OAI_StringManager.m
//  EUS Calculator
//
//  Created by Steve Suranie on 1/9/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_StringManager.h"

@implementation OAI_StringManager

@synthesize introduction, instructions, helpCasesPerWeek, helpLaborCost, helpServiceQuote, helpVariableCost, helpAdditionalCost, helpMedicareReimbursement, helpNonMedicareReimbursement, helpMedicareFacilityFee, helpNonMedicareFacilityFee, helpPhysicianFee, helpSecondProvider, helpAnasthesiaPayment, helpPathology, helpSurgery, helpAdmissions, helpOncology, helpRadiology, helpAnesthesia, disclaimer, assumptionsArray, reimbursementArray;


+(OAI_StringManager *)sharedStringManager {
    
    static OAI_StringManager* sharedStringManager;
    
    @synchronized(self) {
        
        if (!sharedStringManager)
            
            sharedStringManager = [[OAI_StringManager alloc] init];
        
        return sharedStringManager;
        
    }
    
}

-(id)init {
    
    if (self = [super init]) {
        
        introduction = @"<div style=\"color: #666; font-family: Helvetica, Arial, sans-serif; font-weight: 200; font-size: 18px;\"><p style\"font-weight: 200; margin: 0 0 10px 0;\">Endoscopic ultrasound (EUS) is widely available in academic facilities, but not well established in the community hospital setting. While the initial cost of capital equipment and reimbursement concerns have been a deterrent for community hospitals considering an EUS program, it is important to note that the financial benefits of EUS extend beyond the GI department alone. The EUS program can often be a powerful downstream revenue generator for a hospital, with the EUS case often serving as the patient's first point of entry into the hospital system. A significant percentage of EUS patients may require additional services from the facility, creating an indirect revenue stream that originated within the GI department but benefits the facility as a whole.</p><p style\"font-weight: 900; margin: 0 0 10px 0;\">About EUS</p><p style\"font-weight: 200; margin: 0 0 10px 0;\">EUS combines endoscopy and ultrasound in order to obtain the most accurate, high-resolution images and information about the digestive tract and the surrounding tissue and organs. By guiding an endoscope with an ultrasound transducer at its tip, sound beyond the range of human hearing is emitted within body cavities and creates images of the targeted areas.</p><p style\"font-weight: 200; margin: 0 0 10px 0;\">EUS allows a minimally invasive, non-surgical evaluation of the internal organs with a high degree of accuracy. The applications for EUS have continued to expand and are now used to assess several types of cancers and disorders:</p><ul><li>Submucosal lesions -- Ultrasound scanning over submucosal nodules in the esophagus or stomach.</li><li>Chronic pancreatitis --  EUS aids in providing detailed information about the pancreas and pancreatic duct.</li><li>Disorders of the bile duct and fecal incontinence.</li></ul></p><p style\"font-weight: 900; margin: 0 0 10px 0;\">What's New</p><p style\"font-weight: 200; margin: 0 0 10px 0;\">The GF-UCT180 features a newly developed curved linear array transducer to deliver higher-quality ultrasound image with greater depth and offers you the power and flexibility you need for straightforward tissue sampling to sophisticated endoscopic ultrasound-guided treatment. A redesigned elevator gives you more reliable control over devices passed through the channel and a detachable ultrasound cable helps facilitate easier handling, reprocessing and storage. The endoscopic image the GF-UCT180 incorporates a high-resolution \"Q\" CCD that delivers sharp, clear images. Narrow Band Imaging (NBI) capability is also supported by the Olympus GF-UCT-180, offering enhanced visualization of mucosal and capillary structures.</p><p style\"font-weight: 900; margin: 0 0 10px 0;\">Clinical Support</p><p style\"font-weight: 200; margin: 0 0 10px 0;\">Olympus Clinical Application Specialists (CAS) offer something others cannot: a team of clinically-skilled people aimed at supporting you with a combined experience level of more than 200 years working in the GI lab. The CAS team specializes in education, procedures and clinical support.</p><p style\"font-weight: 900; margin: 0 0 10px 0;\">Financial Support</p><p style\"font-weight: 200; margin: 0 0 10px 0;\">Having the most advanced endoscopic technology at your fingertips helps ensure the best care possible for your patients. To assist you in meeting your operation's goals, Olympus offers specialized financial options that can be tailored to meet your needs. Please inquire about these options with your salesperson.</p><p style\"font-weight: 900; margin: 0 0 10px 0;\">Focused Attention</p><p style\"font-weight: 200; margin: 0 0 10px 0;\">Olympus has a full support team that includes: Endoscopy Account Managers, Clinical EndoTherapy Specialists, Clinical Application Specialists, Field Service Engineers, Endoscopy Support Specialists, a 24-hour technical assistance center and customer service representatives, all focuses to serve your needs.</p></div>";
    
        instructions = @"To begin, select a section from the tabs above and enter the required information for that section.\n\nYou may click the submit button on each page at anytime to submit your inputs.\n\nThe placeholder values are conservative assumptions calculated by Olympus that are based on industry statistics and feedback. To understand the origin of an assumption, mouse over the question mark icon to the right of the value. If you have detailed information as it relates to your particular facility, simply delete the assumed value and replace with your specific data.";
    
        helpCasesPerWeek = @"This value should be the average number of cases per week over the course of the year. You may begin with a fewer number of cases, but your caseload will ramp up as the year goes on.";
    
        helpLaborCost = @"Nursing labor costs are based on Olympus 2012 Benchmarking Data of an average 3 hour total length of stay for EUS cases, and a 1:1 RN to patient ratio to compensate for other personnel costs (scheduler, tech support, etc.) at a rate of $32/hour. If physician is hospital employed, this figure also includes 1 MD hour/case at a rate of $200/hour.";
    
        helpServiceQuote = @"Request a service quotation from service administration.";
    
        helpVariableCost = @"Variable costs per patient is based on FNA usage in approximately 35% of all cases (Is EUS a financially viable for community based hospital? Gastrointestinal Endoscopy, Volume 69, Issue 2, 2009: Pages S253-S254R. Patel, C. O'loughlin, N. Narahari, A. Leonard, T. Handzel, H. Patterson), and also includes the cost of additional devices, sedation (medication and IV), endoscope reprocessing and PPE.";
    
        helpAdditionalCost = @"This field is intentionally left blank as incremental costs associated with introducing EUS to a facility are captured elsewhere within this Tool. Use this field if a new room is being built for EUS procedures, or if you would like to capture additional overhead costs.";
        
        helpMedicareReimbursement = @"Enter payor mix.";
        
        helpNonMedicareReimbursement = @"Enter payor mix.";
        
        helpMedicareFacilityFee = @"Estimated using 2012 Average HOPPS payment for CPT 43242. NOTE: Reduce reimbursement input if physician practice patterns will not typically include fine needle aspiration.  See reimbursement tab for details.  Source: 2012 Medicare Hospital Outpatient Final Rule.";
        
        helpNonMedicareFacilityFee = @"Non-Medicare Facility Fee per case is an approximation assuming Medicare Facility Fee per case increased  by 10 percent. This amount based on 2012 Medicare Fee Schedule for CPT 43242 ($885*1.1=$973.50). See below for details if using \"other\" CPT code.";
        
        helpPhysicianFee = @"Only applicable if the EUS physician is hospital employed. Adjust with weighted averages as needed. Other CPT codes for reference: CPT 43232 = $265, CPT 43238 = $297. See reimbursement tab for details. Source: 2012 Medicare Physician Final Rule.\n\nWeighted Average:\nMedicare Fee Schedule based on an average of 65% of lowest physician CPT (265*.65=172.25) and 35% of the highest physician CPT code (430*.35=150.50).  Would equal $322.75";
        
        helpSecondProvider = @"Secondary providers include anesthesiologists, CRNAs, etc...";
        
        helpAnasthesiaPayment = @"Average Medicare Reimbursement for anesthesia during endoscopy is based on CPT 00801 (anesthesia code): 5 Base Units and CPT 00810 (anesthesia for lower intestinal endoscopic procedures, endoscope introduced distal to duodenum): 5 Base Units and $21.52 2012 National anesthesia conversion factor = $108 payment. Only applicable if a secondary provider delivers anesthesia during EUS.  Source: 2012 Medicare Physician Final Rule.";
        
        helpPathology = @"Average Medicare Reimbursement for Pathology is estimated based on the 2012 Medicare HOPPS Final Rule payment w/o geographic adjustment for APC343 (CPT 88305-26 Level IV surgical pathology): $37.  Assuming that the pathologist is a hospital employee, the most recent Medicare physician fee schedule for CPT 88305-26 (pathologist's interpretation): $36.  Exclude this amount if the pathologist is not a hospital employee. It is assumed one case will result in two biopsies:  ($37 + $36) x 2 = $146. Source: 2012 Medicare Physician and Hospital Outpatient Final Rules.";
        
        helpSurgery = @"Average Medicare reimbursement for Surgery is based on the 2012 Medicare MS-DRG 328 (Stomach, Esophageal and Duodenal Proc w/o CC/MCC); Weight 1.3848, multiplied by 2012 National Inpatient Prospective Payment System Average Base rate excluding capital add-on ($5,209.74) = Payment $7,214. Source: 2012 Medicare Acute Inpatient PPS Final Rule.  ";
        
        helpAdmissions = @"National average (wage index greater than one) of the most common GI DRG rates is calculated by using the national adjusted full update standardized labor, non-labor and capital amounts. Source: August 18, 2011 Federal Register. Customers are encouraged to enter site-specific estimates based on claims data.";
        
        helpOncology = @"Average Medicare Inpatient Reimbursement for Oncology is estimated based on the 2012 Medicare MS-DRG 484 (Chemotherapy w/o acute leukemia as secondary diagnosis w/o CC/MCC): Weight (1.9939) multiplied by 2012 National Inpatient Prospective Payment System Average Base rate excluding capital add-on ($5,209.74) = Payment $10,388. Source: 2012 Medicare Acute Inpatient PPS Final Rule. ";
        
        helpRadiology = @"Average Medicare Reimbursement for Radiology is estimated based on the average APC 276 (Level I Digestive Radiology) payment - $86.  Source: 2012 Medicare Hospital Outpatient Final Rule";
        
        helpAnesthesia = @"Average Medicare Reimbursement for Anesthesia is estimated based on the 2012 Medicare Physician fee schedule for CPT 00790 (anesthesia for intraperitoneal procedures in upper abdomen incl. laparoscopy). 7 base units multiplied by 2012 National anesthesia conversion factor of $21.52 = Payment of $151.  Source: 2012 Medicare Physician Final Rule";
        
        disclaimer = @"The EUS Calculator is a work tool and it is not a guaranty or representation of results.  Olympus and its employees, consultants, agents, and representatives (collectively, “Olympus”) cannot and do not represent or warrant that you will actually receive the downstream revenue indicated by the EUS Value Calculator.  This model is presented solely as an example based on a number of assumptions, and on a cash basis, for the purpose of demonstrating the potential for creating incremental downstream revenue created by the use of the Olympus Endoscopic Ultrasound Portfolio, which may be a key factor in assessing the value of this technology for your organization.  The model does not utilize accrual or time value methodologies, nor does it take into account depreciation or tax impact (income tax, property tax, sales and use tax), all of which might affect the potential downstream revenue associated with the use of the Olympus Endoscopic Ultrasound products.  Additionally, pricing is provided solely as an example and will vary based on equipment configuration and the list prices and rates in effect at the time of your acquisition.  Actual Medicare reimbursement payments may vary depending on the patient’s insurance and the institution’s specific contractual agreements, and this calculator does not by any means provide any advice, guaranties or representations that the Olympus Endoscopic Ultrasound products (or any other product offered by Olympus) will be entitled to reimbursement (Medicare, Medicaid or otherwise), nor does it suggest how the Olympus Endoscopic Ultrasound products should be reflected on applicable cost reports.\n\nOlympus disclaims all warranties, express or implied, of any kind whatsoever, including, without limitation, any warranties as to merchantability or fitness for a particular purpose.  Under no circumstances shall Olympus be liable for any costs, expenses, losses, claims, liabilities, or other damages (whether direct, indirect, special, incidental, consequential, or otherwise) that may arise from or be incurred in connection with this EUS Value Calculator or any use thereof.\n\nYour Olympus Medical Products Representative and Olympus Financial Services Representative are both on call to provide you with a proposal after discussing your specific needs.";
        
        //assumptions table
        
        assumptionsArray = [[NSMutableArray alloc] init];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Question", @"Assumption", @"Source", nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Labor costs per case", @"$96 (nursing)", @"Nursing labor costs are based on Olympus 2012 Benchmarking Data of an average 3 hour total length of stay for EUS cases, and a 1:1 RN to patient ratio to compensate for other personnel costs (scheduler, tech support, etc.) at a rate of $32/hour. If physician is hospital employed, this figure also includes 1 MD hour/case at a rate of $200/hour.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Variable cost per patient", @"$180 (nursing)", @"Variable costs per patient is based on FNA usage in approximately 35% of all cases (Is EUS a financially viable for community based hospital? Gastrointestinal Endoscopy, Volume 69, Issue 2, 2009: Pages S253-S254R. Patel, C. O'loughlin, N. Narahari, A. Leonard, T. Handzel, H. Patterson), and also includes the cost of additional devices, sedation (medication and IV), endoscope reprocessing and PPE.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Medicare Facility Fee per case (does not include modifiers)", @"$885", @"Estimated using 2012 Average HOPPS payment for CPT 43242. NOTE: Reduce reimbursement input if physician practice patterns will not typically include fine needle aspiration. See reimbursement tab for details. Source: 2012 Medicare Hospital Outpatient Final Rule.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Non-Medicare Facility Fee per case", @"$974", @"Non-Medicare Facility Fee per case is an approximation assuming Medicare Facility Fee per case increased by 10 percent. This amount based on 2012 Medicare Fee Schedule for CPT 43242 ($887*1.1=$975.70). See below for details if using \"other\" CPT code.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Physician Fee per case", @"$430", @"Only applicable if the EUS physician is hospital employed. Adjust with weighted averages as needed. Other CPT codes for reference: CPT 43232 = $265, CPT 43238 = $297. See reimbursement tab for details. Source: 2012 Medicare Physician Final Rule.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Anesthesia Fee per case", @"$108", @"Average Medicare Reimbursement for anesthesia during endoscopy is based on CPT 00801 (anesthesia code): 5 Base Units and CPT 00810 (anesthesia for lower intestinal endoscopic procedures, endoscope introduced distal to duodenum): 5 Base Units and $21.52 2012 National anesthesia conversion factor = $108 payment. Only applicable if a secondary provider delivers anesthesia during EUS. Source: 2012 Medicare Physician Final Rule.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Pathology Reimbursement", @"$146", @"Average Medicare Reimbursement for Pathology is estimated based on the 2012 Medicare HOPPS Final Rule payment w/o geographic adjustment for APC343 (CPT 88305-26 Level IV surgical pathology): $37. Assuming that the pathologist is a hospital employee, the most recent Medicare physician fee schedule for CPT 88305-26 (pathologist's interpretation): $36. Exclude this amount if the pathologist is not a hospital employee. It is assumed one case will result in two biopsies: ($37 + $36) x 2 = $146. Source: 2012 Medicare Physician and Hospital Outpatient Final Rules.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Surgery Reimbursement", @"$7,214", @"Average Medicare reimbursement for Surgery is based on the 2012 Medicare MS-DRG 328 (Stomach, Esophageal and Duodenal Proc w/o CC/MCC); Weight 1.3848, multiplied by 2012 National Inpatient Prospective Payment System Average Base rate excluding capital add-on ($5,209.74) = Payment $7,214. Source: 2012 Medicare Acute Inpatient PPS Final Rule.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Admissions Reimbursement", @"$5,631", @"National average (wage index greater than one) of the most common GI DRG rates is calculated by using the national adjusted full update standardized labor, non-labor and capital amounts. Source: August 18, 2011 Federal Register. Customers are encouraged to enter site-specific estimates based on claims data.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Oncology Reimbursement", @"$10,388", @"Average Medicare Inpatient Reimbursement for Oncology is estimated based on the 2012 Medicare MS-DRG 484 (Chemotherapy w/o acute leukemia as secondary diagnosis w/o CC/MCC): Weight (1.9939) multiplied by 2012 National Inpatient Prospective Payment System Average Base rate excluding capital add-on ($5,209.74) = Payment $10,388. Source: 2012 Medicare Acute Inpatient PPS Final Rule.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Radiology Reimbursment", @"$86", @"Average Medicare Reimbursement for Radiology is estimated based on the average APC 276 (Level I Digestive Radiology) payment - $86. Source: 2012 Medicare Hospital Outpatient Final Rule.",  nil]];
        [assumptionsArray addObject:[[NSArray alloc] initWithObjects:@"Anesthesia - Non Endoscopy Reimbursement", @"$151", @"Average Medicare Reimbursement for Anesthesia is estimated based on the 2012 Medicare Physician fee schedule for CPT 00790 (anesthesia for intraperitoneal procedures in upper abdomen incl. laparoscopy). 7 base units multiplied by 2012 National anesthesia conversion factor of $21.52 = Payment of $151. Source: 2012 Medicare Physician Final Rule.",  nil]];
        
        reimbursementArray = [[NSMutableArray alloc] init];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"", @"", @"Physician", @"", @"Facility", @"", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"CPT® Code", @"Code Description", @"MD Payment In-Office", @"MD Payment In-Facility", @"Hospital Outpatient Payment", @"ASC Facility Payment", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"Upper Gastrointestinal Procedures", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"43232", @"Esophagoscopy, rigid or flexible; with transendoscopic ultrasound-guided intramural or transmural fine needle aspiration/biopsy(s)", @"$265", @"$265", @"$885", @"$511", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"43238", @"Upper gastrointestinal endoscopy with transendoscopic ultrasound-guided intramural or transmural fine needle aspiration/biopsy(s) esophagus (includes endoscopic ultrasound examination limited to the esophagus", @"$297", @"$297", @"$885", @"$511", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"43242", @"Upper gastrointestinal endoscopy with transendoscopic ultrasound-guided intramural or transmural fine needle aspiration/biopsy(s) (includes endoscopic ultrasound examination of the esophagus. Stomach, and either the duodenum and/or jejunum as appropriate)", @"$430", @"$430", @"$885", @"$511", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"Lower Gastrointestinal Procedures", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"45342", @"Sigmoidoscopy, flexible; with transendoscopic ultrasound guided intramural or transmural fine needle aspiration/biopsy(s)", @"$243", @"$243", @"$446", @"$775", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"45392", @"Colonoscopy, flexible; with transendoscopic ultrasound guided intramural or transmural fine needle aspiration/biopsy(s)", @"$386", @"$386", @"$655", @"$655", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"Medicare Hospital Inpatient Payment:\nInpatient payment information not shown because the transendoscopic ultrasound-guided fine needle aspiration procedure will rarely, if ever, be the primary reason for a hospital admission.\n\nNote: Represents National Average Medicare Fees (Without Geographic Adjustment) Last Updated March 2012.  N/A signifies Medicare expects that rarely, if ever, will this procedure be performed in this setting.", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"\n1 Sources:", @"\nCPT & Description: CPT® 2012 American Medical Association. Hospital/ASC rates:  April 2012 Update to Appendix B and Appendix AA, respectively, from the CMS website.  Physician Fees:  Physician fee calculation by Olympus America Inc. and/or its direct or indirect (through one or more intermediaries) parent companies, affiliates, subsidiaries. Physician rates calculated using conversion factor of $34.0376 and RVUs published in the CMS Physician Fee Schedule March 2012 release. CPT Copyright 2011 American Medical Association. All rights reserved. CPT is a registered trademark of the American Medical Association.  All rights reserved. Applicable FARS/DFARS apply to government use.", nil]];
        [reimbursementArray addObject:[[NSArray alloc] initWithObjects:@"\nNotice to Reader:", @"\nThe information presented here is for illustrative purposes only and does not constitute reimbursement or legal advice. The reimbursement information provided by Olympus America Inc. and/or its direct or indirect (through one or more intermediaries) parent companies, affiliates, or subsidiaries (collectively, the \"Olympus Group\") is gathered from third party sources and is subject to change without notice.  Reimbursement rules vary widely by insurer so you should understand and comply with any specific rules that may be set by the patient's insurer. You must also understand and comply with Medicare's complex rules.  It is the provider’s sole responsibility to determine medical necessity and to in turn identify which CPT codes to report and to submit accurate claims.  You should always consult with your local payers regarding reimbursement matters.  Under no circumstances shall the Olympus Group or its employees, consultants, agents or representatives be liable for costs, expenses, losses, claims, liabilities or other damages (whether direct, indirect, special, incidental, consequential or otherwise) that may arise from or be incurred in connection with this information or any use thereof.", nil]];
        
        
        
        
                                     
         
                                    
        
        
    }
    
    
    
    return self;
        
    
}




@end
