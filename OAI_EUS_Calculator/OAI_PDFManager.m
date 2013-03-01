//
//  OAI_PDFManager.m
//  EUS Calculator
//
//  Created by Steve Suranie on 2/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_PDFManager.h"

@implementation OAI_PDFManager {
    
    CGSize pageSize;
}

@synthesize strTableTitle;

+(OAI_PDFManager *)sharedPDFManager {
    
    static OAI_PDFManager* sharedPDFManager;
    
    @synchronized(self) {
        
        if (!sharedPDFManager)
            
            sharedPDFManager = [[OAI_PDFManager alloc] init];
        
        return sharedPDFManager;
        
    }
    
}

-(id)init {
    return [self initWithAppID:nil];
}

-(id)initWithAppID:(id)input {
    if (self = [super init]) {
        
        /* perform your post-initialization logic here */
        colorManager = [[OAI_ColorManager alloc] init];
        stringManager = [[OAI_StringManager alloc] init];
    }
    return self;
}

- (void) makePDF : (NSString*) fileName : (NSDictionary*) results {
    
    pageSize = CGSizeMake(612, 792);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [self generatePdfWithFilePath:pdfFileName:results];
    
}

- (void) generatePdfWithFilePath: (NSString *)thefilePath : (NSDictionary*) results {
    
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
    BOOL done = NO;
    
    do {
        
        //set up a counter for page height
        float objectsH = 0.0;
        
        //set up our font styles
        UIFont* headerFont = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        UIFont* contentFont = [UIFont fontWithName:@"Helvetica" size:13.0];
        UIFont* tableFont = [UIFont fontWithName:@"Helvetica" size:8.0];
        UIFont* tableFontBold = [UIFont fontWithName:@"Helvetica" size:12.0];
        
        //set up a some constraints
        CGSize pageConstraint = CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset);
        
        //set up a color holdr
        UIColor* textColor;
        
        UIImage* imgLogo = [UIImage imageNamed:@"OA_img_logo_pdf.png"];
        
        /*************************COVER PAGE*********************************/
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //add the olympus logo to top of page
        CGRect imgLogoFrame = CGRectMake(312-(imgLogo.size.width/2), (pageSize.height/3), imgLogo.size.width, imgLogo.size.height);
        [self drawImage:imgLogo :imgLogoFrame];
        
        NSString* strPDFTitle = @"EUS Value Calculator Results For FACILITY NAME GOES HERE";
        textColor = [colorManager setColor:8 :16 :123];
        CGSize PDFTitleSize = [strPDFTitle sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect PDFTitleFrame = CGRectMake((pageSize.width/2)-(PDFTitleSize.width/2), imgLogoFrame.origin.y + imgLogoFrame.size.height + 50.0, PDFTitleSize.width, PDFTitleSize.height);
        [self drawText:strPDFTitle :PDFTitleFrame :headerFont :textColor :0];

        
        /*********************PAGE 1****************************************/
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //add some intro text
        NSString* introText = @"Following are the results of the downstream revenue model for FACILITY NAME GOES HERE. For more information on these results and to learn how Olympus can do more for you, please contact NAME GOES HERE at EMAIL GOES HERE or at PHONE GOES HERE";
        CGSize introTextSize = [introText sizeWithFont:contentFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect introTextFrame = CGRectMake(2*kBorderInset-2*kMarginInset, 20.0, introTextSize.width, introTextSize.height);
        textColor = [UIColor blackColor];
        [self drawText:introText :introTextFrame :contentFont:textColor:1];
        
        //add the title bar - give it a color, start point, end point and a width (thickness)
        UIColor* titleBarBGColor = [colorManager setColor:8 :16 :123];
        CGPoint titleBarStartPoint = CGPointMake(kMarginInset + kBorderInset, introTextFrame.origin.y + introTextFrame.size.height + 40.0);
        CGPoint titleBarEndPoint = CGPointMake(pageSize.width - 2*kMarginInset -2*kBorderInset, introTextFrame.origin.y + introTextFrame.size.height + 40.0);
        float lineWidth = kLineWidth*20.0;
        [self drawLine:lineWidth:titleBarBGColor:titleBarStartPoint:titleBarEndPoint];
        
        //add the title
        NSString* pageTitle = @"Downstream Revenue Model";
        CGSize titleSize = [pageTitle sizeWithFont:headerFont];
        CGRect pageTitleFrame = CGRectMake((pageSize.width/2)-(titleSize.width/2), introTextFrame.origin.y + introTextFrame.size.height + 30.0, titleSize.width, titleSize.height);
        textColor = [UIColor whiteColor];
        [self drawText:pageTitle :pageTitleFrame :headerFont:textColor:1];
        
        
        //build the first table
        //table 1 headers
        NSArray* t1Headers = [[NSArray alloc] initWithObjects:@"Department", @"EUS Cases Utilizing Services of Other Departments", @"Average Medicare Reimbursements", nil];
        
        //set a max height for the headers
        float maxt1HeaderH = [self getMaxHeaderHeight:t1Headers :headerFont];
        
        //build the t1 header bar
        UIColor* headerBarTable1Color = [colorManager setColor:186.0 :209.0 :254.0];
        CGPoint headerBarStartPoint = CGPointMake(kMarginInset + kBorderInset, pageTitleFrame.origin.y + pageTitleFrame.size.height+10);
        CGPoint headerBarEndPoint = CGPointMake(pageSize.width - 2*kMarginInset, pageTitleFrame.origin.y + pageTitleFrame.size.height+10);
        lineWidth = kLineWidth*60;
        [self drawLine:lineWidth:headerBarTable1Color:headerBarStartPoint:headerBarEndPoint];
        
        //add the headers
        float headerX = headerBarStartPoint.x + 5.0;
        float headerY = headerBarStartPoint.y-25.0;
        float headerW = 140.0;
        float headerH = maxt1HeaderH;
        
        //set header text
        [self setHeaderText:t1Headers :headerFont :headerX :headerY :headerW :headerH:[UIColor blackColor]];
        
        //get column data for this table
        NSArray* t1RowHeaders = [[NSArray alloc] initWithObjects:@"Pathology", @"Surgery", @"Admissions", @"Oncology", @"Radiology", @"Anesthesia", @"Other", nil];
        
        float rowX = headerBarStartPoint.x;
        float rowY = headerBarEndPoint.y + maxt1HeaderH;
        float endRowX = headerBarEndPoint.x;
        float endRowY = headerBarEndPoint.y + maxt1HeaderH;
        
        [self buildAlternatingTableRows:t1RowHeaders :[colorManager setColor:204.0:204.0:204.0] :[colorManager setColor:219:243:252]:rowX:rowY:endRowX:endRowY:kLineWidth*maxt1HeaderH];
        
        
        //display text
        for(int i=0; i<t1RowHeaders.count; i++) {
        
            if(i>0) {
                rowY = rowY + 40.0;
            }
                    
            //build row cell contents array
            NSMutableArray* rowCellContents = [[NSMutableArray alloc] init];
            [rowCellContents addObject:[t1RowHeaders objectAtIndex:i]];
            
            NSString* strRowPercentage = [NSString stringWithFormat:@"%@ Percentage", [t1RowHeaders objectAtIndex:i]];
            NSString* strRowValue = [NSString stringWithFormat:@"%@ Value", [t1RowHeaders objectAtIndex:i]];
            
            NSString* thisRowPercentage = [results objectForKey:strRowPercentage];
            NSString* thisRowValue = [results objectForKey:strRowValue];
            
            [rowCellContents addObject:thisRowPercentage];
            [rowCellContents addObject:thisRowValue];
            
            //display the row content
            float strX = headerBarStartPoint.x+10.0;
            float strY = rowY;
            float strW = 140.0;
            float strH = 40.0;
            
            [self setRowText:rowCellContents :strX :strY :strW :strH :[UIColor blackColor] :contentFont];
            
            objectsH = rowY+maxt1HeaderH;
            
        }
        
        
        //build the second table
        NSArray* t2Headers = [[NSArray alloc] initWithObjects:@"", @"Number of Cases", @"Total Downstream Revenue Growth", @"Total Downstream Operating Margin", nil];
        float maxT2HeaderH = [self getMaxHeaderHeight:t2Headers :headerFont];
        
        //build the t2 header bar
        UIColor* t2HeaderBarTable1Color = [colorManager setColor:110.0:109.0 :84.0];
        CGPoint t2HeaderBarStartPoint = CGPointMake(kMarginInset + kBorderInset, objectsH+15.0);
        CGPoint t2HeaderBarEndPoint = CGPointMake(pageSize.width - (2*kMarginInset), objectsH+15.0);
        lineWidth = kLineWidth*60;
        [self drawLine:lineWidth:t2HeaderBarTable1Color:t2HeaderBarStartPoint:t2HeaderBarEndPoint];
        
        headerX = t2HeaderBarStartPoint.x + 5.0;
        headerY = t2HeaderBarStartPoint.y-25.0;
        headerW = 80.0;
        headerH = maxT2HeaderH;
        
        [self setHeaderText:t2Headers :headerFont :headerX :headerY :headerW :60.0:[colorManager setColor:193 :192 :151]];
        
        NSArray* t2Columns = [[NSArray alloc] initWithObjects:@"Annual Patients", @"Growth", @"Net Profit Margin Fee", nil];
        NSArray* t2RowHeaders = [[NSArray alloc] initWithObjects:@"Year 1", @"Year 2", @"Year 3", nil];
        
        rowX = t2HeaderBarStartPoint.x;
        rowY = t2HeaderBarEndPoint.y + 40.0;
        endRowX = t2HeaderBarEndPoint.x;
        endRowY = t2HeaderBarEndPoint.y + 40.0;
        
        [self buildAlternatingTableRows:t2RowHeaders :[colorManager setColor:204.0:204.0:204.0] :[colorManager setColor:252:252:202]:rowX:rowY:endRowX:endRowY:40.0];
        
        for(int i=0; i<t2RowHeaders.count; i++) {
            
            if(i>0) {
                rowY = rowY + 40.0;
            }
            
            //build row cell contents array
            NSMutableArray* rowCellContents = [[NSMutableArray alloc] init];
            [rowCellContents addObject:[t2RowHeaders objectAtIndex:i]];
            for (int x=0; x<3; x++) {
                
                NSString* cellValue = [results objectForKey:[NSString stringWithFormat:@"%@ Year %i", [t2Columns objectAtIndex:x], i+1]];
                [rowCellContents addObject:cellValue];
            }
            
        //display the row content
        float strX = t2HeaderBarStartPoint.x+10.0;
        float strY = rowY;
        float strW = 80.0;
        float strH = 40.0;
        
        [self setRowText:rowCellContents :strX :strY :strW :strH :[UIColor blackColor] :contentFont];

        }

        //text below the table
        NSString* tableFootnote = @"30% of Downstream Reimbursement is calculated as Downstream Revenue";
        CGSize footNoteSize = [tableFootnote sizeWithFont:tableFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect footNoteFrame = CGRectMake(t2HeaderBarStartPoint.x, rowY+30.0, footNoteSize.width, footNoteSize.height);
        textColor = [UIColor blackColor];
        [self drawText:tableFootnote :footNoteFrame :tableFont:textColor:1];
        
        /*******************PAGE 2 REVENUE AND EXPENDITURE**********************/
        
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //table 3 title
        NSString* table3Title = strTableTitle;
        float pageObjectCurrentY = kBorderInset+20.0;
        CGRect table3TitleFrame = CGRectMake((pageSize.width/2)-200, pageObjectCurrentY, 400.0, 40.0);
        textColor = [colorManager setColor:8 :16 :123];
        [self drawText:table3Title :table3TitleFrame :headerFont:textColor:1];
        
        //increment the y location
        pageObjectCurrentY = pageObjectCurrentY + table3TitleFrame.size.height + 20.0;
        
        //build the third table
        NSArray* t3Headers = [[NSArray alloc] initWithObjects:@"", @"Year 1", @"Year 2", @"Year 3", nil];
        
        //build the t3 header bar
        UIColor* t3HeaderBarColor = [colorManager setColor:66.0:66.0 :66.0];
        CGPoint t3HeaderBarStartPoint = CGPointMake(kMarginInset + kBorderInset, pageObjectCurrentY);
        CGPoint t3HeaderBarEndPoint = CGPointMake(pageSize.width - 2*kMarginInset, pageObjectCurrentY);
        lineWidth = kLineWidth*30;
        [self drawLine:lineWidth:t3HeaderBarColor:t3HeaderBarStartPoint:t3HeaderBarEndPoint];
        
        //add the t3 headers
        headerX = t3HeaderBarStartPoint.x + 5.0;
        headerY = t3HeaderBarStartPoint.y-10.0;
        headerW = 300.0;
        headerH = 30.0;
        
        for(int h=0; h<t3Headers.count; h++) {
            
            //get the header
            NSString* strThisHeader = [t3Headers objectAtIndex:h];
            
            //set headerX
            if (h>0) {
                
                //change the headerW and headerX
                headerW = (pageSize.width-(kMarginInset+kBorderInset)-240.0)/3;
                headerX = headerX + headerW + 5.0;
                    
            }
            
            //set the text color
            textColor = [UIColor whiteColor];
            
            //set a frame for the text
            CGRect thisHeaderFrame = CGRectMake(headerX, headerY, headerW, headerH);
            
            [self drawText:strThisHeader :thisHeaderFrame :headerFont:textColor:1];
            
        }
        
        //increment page y
        pageObjectCurrentY = pageObjectCurrentY + 30.0;
        
        //add the t3 rows
        NSArray* t3RowHeaders = [[NSArray alloc] initWithObjects:@"Revenue", @"Number of Patients Per Week", @"Number of Patients Per Year", @"Total Facility Fee (without modifiers)", @"Total Physician Fees", @"Total Anesthesia Fees", @"Downstream Operating Margin", @"Annual Operating Margin", @"Expenditure", @"Equipment", @"Labor", @"Service & Maintenance", @"Other Variable Cost", @"Other Fixed Cost", @"Total Cost", @"Annual Operating Margin", @"Net Operating Margin", nil];
                        
        //get our data
        NSArray* weeklyPatientsCellData = [self gatherCellData:results:@"Weekly Patients"];
        NSArray* annualPatientsCellData = [self gatherCellData:results:@"Annual Patients"];
        NSArray* totalFacilityFee = [self gatherCellData:results:@"Facility Fee"];
        NSArray* totalPhysicianFee = [self gatherCellData:results:@"Physician Fee"];
        NSArray* totalAnesthesiaFee = [self gatherCellData:results :@"Anesthesia Fee"];
        NSArray* downstreamMargin = [self gatherCellData:results :@"Growth"];
        NSArray* operatingMargin = [self gatherCellData:results :@"Annual Revenue Operating Margin Fee"];
        NSArray* equipmentFee = [self gatherCellData:results :@"Equipment Total"];
        NSArray* laborFee = [self gatherCellData:results :@"Labor Total"];
        NSArray* serviceFee = [self gatherCellData:results :@"Service Total"];
        NSArray* variableCost = [self gatherCellData:results :@"Variable Cost Per Patient Total"];
        NSArray* fixedCost = [self gatherCellData:results :@"Additional Cost Per Patient Total"];
        NSArray* totalCost = [self gatherCellData:results :@"Total Cost"];
        NSArray* annualOperatingMargin = [self gatherCellData:results :@"Annual Expenditure Operating Margin"];
        NSArray* netOperatingMargin = [self gatherCellData:results :@"Net Operating Margin"];
        
        NSArray* t3CellValues = [[NSArray alloc] initWithObjects:@"Revenue", weeklyPatientsCellData, annualPatientsCellData, totalFacilityFee, totalPhysicianFee, totalAnesthesiaFee, downstreamMargin, operatingMargin, @"Expenditure", equipmentFee, laborFee, serviceFee, variableCost, fixedCost, totalCost, annualOperatingMargin, netOperatingMargin, nil];
        
        
        //loop through the headers
        rowX = t3HeaderBarStartPoint.x+10.0;
        rowY = pageObjectCurrentY;
        for(int h=0; h<t3RowHeaders.count; h++) {
            
            
            if (h>0) {
                rowY = rowY + 30.0;
            }
            
            //get the header string
            NSString* strThisHeader = [t3RowHeaders objectAtIndex:h];
            
            //set the header size
            CGSize rowHeaderSize = [strThisHeader sizeWithFont:tableFont constrainedToSize:CGSizeMake(300.0, 200.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            //set the frame
            CGRect rowHeaderFrame = CGRectMake(rowX, rowY, rowHeaderSize.width, rowHeaderSize.height);
            
            //set the text color
            float barY = rowHeaderFrame.origin.y;
            if (h==0 || h== 8) {
                textColor = [UIColor whiteColor];
                
                //build the t3 header bar
                UIColor* t3DividerBarColor = [colorManager setColor:8 :16 :123];
                CGPoint t3DividerBarStartPoint = CGPointMake(kMarginInset + kBorderInset, barY+5.0);
                CGPoint t3DividerEndPoint = CGPointMake(pageSize.width - 2*kMarginInset, barY+5.0);
                lineWidth = kLineWidth*20;
                [self drawLine:lineWidth:t3DividerBarColor:t3DividerBarStartPoint:t3DividerEndPoint];
                
            } else { 
                textColor = [colorManager setColor:66.0 :66.0 :66.0];
                
                if (h%2==0) {
                    
                    UIColor* t3DividerBarColor = [colorManager setColor:204 :204 :204];
                    CGPoint t3DividerBarStartPoint = CGPointMake(kMarginInset + kBorderInset, barY+5.0);
                    CGPoint t3DividerEndPoint = CGPointMake(pageSize.width - 2*kMarginInset, barY+5.0);
                    lineWidth = kLineWidth*20;
                    [self drawLine:lineWidth:t3DividerBarColor:t3DividerBarStartPoint:t3DividerEndPoint];
                }
            }
            
            [self drawText:strThisHeader :rowHeaderFrame :tableFont :textColor :1];
            
            
            
            if (h!=0 && h!=8) {
                
                //get the cell values
                NSArray* thisRowCellValues = [t3CellValues objectAtIndex:h];
                float rowX = 190.0;
                float rowY = rowHeaderFrame.origin.y;
                float rowW = (pageSize.width - (rowHeaderFrame.origin.x + rowHeaderFrame.size.width) - (kMarginInset + kBorderInset))/3;
                
                for(int r=0; r<thisRowCellValues.count; r++) {
                    
                    if (r>0) {
                        //change the headerW and headerX
                        rowW = (pageSize.width-(kMarginInset+kBorderInset)-240.0)/3;
                        rowX = rowX + rowW + 5.0;
                    }
                    
                    NSString* strThisCellValue = [thisRowCellValues objectAtIndex:r];
                    
                    textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    
                    CGRect rowCellFrame = CGRectMake(rowX, rowY, rowW, 30.0);
                    
                    [self drawText:strThisCellValue :rowCellFrame :tableFont :textColor :0];
                }
                
            }
            
            
            
        }
                             
        /*******************PAGE 3 ASSUMPTIONS**********************/
        
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //header
        NSString* strAssumptionsHeader = @"Assumptions - EUS Value Calculator";
        CGSize assumptionsHeaderSize = [strAssumptionsHeader sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect assumptionsHeaderFrame = CGRectMake(kMarginInset+kBorderInset, kMarginInset+kBorderInset, pageSize.width-(kMarginInset+kBorderInset*2), assumptionsHeaderSize.height);
        textColor = [colorManager setColor:8 :16 :123];
        [self drawText:strAssumptionsHeader:assumptionsHeaderFrame:headerFont:textColor:1];
        
        //intro text
        NSString* strIntroText = @"If your customized analysis used any of the original assumptions from the Input tab, please see below for a reference of how the number was generated.";
        introTextSize = [introText sizeWithFont:tableFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect assumpIntroTextFrame = CGRectMake(kMarginInset+kBorderInset, assumptionsHeaderFrame.origin.y + assumptionsHeaderFrame.size.height + 10.0, introTextSize.width, introTextSize.height);
        textColor = [colorManager setColor:66.0 :66.0 :66.0];
        [self drawText:strIntroText:assumpIntroTextFrame:tableFont:textColor:0];
        
        //build the assumption table header bar
        UIColor* headerBarColor = [colorManager setColor:66.0:66.0 :66.0];
        headerBarStartPoint = CGPointMake(kMarginInset + kBorderInset, assumpIntroTextFrame.origin.y + assumpIntroTextFrame.size.height + 15.0);
        headerBarEndPoint = CGPointMake(pageSize.width - 2*kMarginInset, assumpIntroTextFrame.origin.y + assumpIntroTextFrame.size.height + 15.0);
        lineWidth = kLineWidth*20;
        [self drawLine:lineWidth:headerBarColor:headerBarStartPoint:headerBarEndPoint];
        
        //add the header text and cell dividers
        NSArray* arrAssumptionHeaders = [[NSArray alloc] initWithObjects:@"Question", @"Assumption", @"Source", nil];
        
        
        headerY = assumpIntroTextFrame.origin.y + assumpIntroTextFrame.size.height+10.0;
        NSMutableArray* cellWidths = [[NSMutableArray alloc] init];
        for(int i=0; i<arrAssumptionHeaders.count; i++) {
            
            //increment x
            float startX = kMarginInset + kBorderInset + 5.0;
            if (i==0) {
                headerX = startX;
            } else if (i==1) {
                headerX = startX + 120.0;
            } else if (i==2) {
                headerX = startX + 200.0;
            }
 
            
            //add the header
            NSString* strThisHeader = [arrAssumptionHeaders objectAtIndex:i];
            CGSize headerSize = [strThisHeader sizeWithFont:tableFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
            CGRect headerFrame = CGRectMake(headerX, headerY, headerSize.width+35.0, headerSize.height);
            textColor = [UIColor whiteColor];
            [self drawText:strThisHeader:headerFrame:tableFont:textColor:1];
            
            //store the cell constraints
            CGSize cellConstraint = CGSizeMake(headerSize.width+35.0, 999.0);
            [cellWidths addObject:NSStringFromCGSize(cellConstraint)];
            
            
            //add the divider
            if (i>0) {
                
                UIColor* dividerColor = [UIColor whiteColor];
                CGPoint dividerStartPoint = CGPointMake(headerX,headerY+10.0);
                CGPoint dividerEndPoint = CGPointMake(dividerStartPoint.x+1.0, headerY+10.0);
                lineWidth = kLineWidth*40;
                [self drawLine:lineWidth:dividerColor:dividerStartPoint:dividerEndPoint];
                
            }
            
        }
        
        
        //loop through the table rows and add them
        NSMutableArray* assumptionsArray = stringManager.assumptionsArray;
        
        
        rowY = headerBarStartPoint.y + 40.0;
        CGRect cellFrame;
        float lastYBottom;
        for(int i=0; i<assumptionsArray.count; i++) {
            
            //ignore the first item, it is the headers
            if (i>0) {
                
                //get the row array
                NSArray* thisRow = [assumptionsArray objectAtIndex:i];
                
                if (i>1) {
                    //increment y
                    lastYBottom = cellFrame.origin.y + cellFrame.size.height + 5.0;
                    rowY = lastYBottom;
                }
                
                float cellHeight = 0.0;
                for(int x=0; x<thisRow.count; x++) {
                    
                    NSString* strCellData = [thisRow objectAtIndex:x];
                    CGSize cellSize = [[thisRow objectAtIndex:thisRow.count-1] sizeWithFont:tableFont constrainedToSize:CGSizeMake(350.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    //set rowX
                    float startX = kMarginInset + kBorderInset + 5.0;
                    float startWidth = 120;
                    float cellWidth = 0.0;
                    cellHeight = cellSize.height;
                    if (x==0) {
                        rowX = startX;
                        cellWidth = startWidth;
                    } else if (x==1) {
                        rowX = startX + 130.0;
                        cellWidth = startWidth;
                    } else if (x==2) {
                        rowX = startX + 210.0;
                        cellWidth = cellSize.width;
                    }
                    
                    cellFrame = CGRectMake(rowX, rowY, cellWidth, cellHeight);
                    textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    [self drawText:strCellData:cellFrame:tableFont:textColor:0];
                    
                                        
                }
                
                
            }
            
            
        }
        
        /*******************PAGE 4 REIMBURSEMENTS**********************/
        
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //get the reimbursement data
        NSArray* reimbursementArray = stringManager.reimbursementArray;
        
        //draw the page header
        //header
        NSString* strReimbursementsHeader = @"2012 Reimbursements";
        CGSize reimbursementsHeaderSize = [strReimbursementsHeader sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect reimbursementsHeaderFrame = CGRectMake(kMarginInset, kMarginInset, pageSize.width-(kMarginInset+kBorderInset*2), reimbursementsHeaderSize.height);
        textColor = [colorManager setColor:8 :16 :123];
        [self drawText:strReimbursementsHeader:reimbursementsHeaderFrame:headerFont:textColor:1];
        
        //subtext
        NSString* strReimbursementsSubHeader = @"Medicare Physician, Hospital Outpatient, and ASC Payments";
        CGSize reimbursementsSubHeaderSize = [strReimbursementsSubHeader sizeWithFont:contentFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect reimbursementsSubHeaderFrame = CGRectMake(kMarginInset, reimbursementsHeaderFrame.origin.y+reimbursementsHeaderFrame.size.height+5.0, pageSize.width-(kMarginInset*2), reimbursementsSubHeaderSize.height);
        textColor = [colorManager setColor:8 :16 :123];
        [self drawText:strReimbursementsSubHeader:reimbursementsSubHeaderFrame:contentFont:textColor:1];
        
        float cellY = 0.0;
        for(int i=0; i<reimbursementArray.count; i++) {
            
            NSArray* thisRowData = [reimbursementArray objectAtIndex:i];
            NSString* strThisCellData;
            CGRect thisCellFrame;
            int thisCellAlignment = 1;
            float cellX = 0.0;
            float cellW = 0.0;
            
            if (i<2) {
                
                //add headers
                if (i==0) {
                    
                    //build header bars
                    UIColor* rHeaderBarColor = [colorManager setColor:66.0 :66.0 :66.0];
                    CGPoint rHeaderBar1StartPoint = CGPointMake(kMarginInset,reimbursementsSubHeaderFrame.origin.y+reimbursementsSubHeaderFrame.size.height + 15.0);
                    CGPoint rHeaderBar1EndPoint = CGPointMake(pageSize.width-(kMarginInset), reimbursementsSubHeaderFrame.origin.y+reimbursementsSubHeaderFrame.size.height + 15.0);
                    lineWidth = kLineWidth*20;
                    [self drawLine:lineWidth:rHeaderBarColor:rHeaderBar1StartPoint:rHeaderBar1EndPoint];
                    
                    CGPoint rHeaderBar2StartPoint = CGPointMake(kMarginInset,rHeaderBar1StartPoint.y+31.0);
                    CGPoint rHeaderBar2EndPoint = CGPointMake(pageSize.width-(kMarginInset), rHeaderBar1StartPoint.y+31.0);
                    lineWidth = kLineWidth*40;
                    [self drawLine:lineWidth:rHeaderBarColor:rHeaderBar2StartPoint:rHeaderBar2EndPoint];
                    for(int h=0; h<thisRowData.count; h++) {
                        
                        strThisCellData = [thisRowData objectAtIndex:h];
                            
                        if (h==2) {
                            cellX = pageSize.width-255.0;
                        } else if (h==4)  {
                            cellX = pageSize.width-120.0;
                        }
                       
                        textColor = [UIColor whiteColor];
                        thisCellFrame = CGRectMake(cellX, reimbursementsSubHeaderFrame.origin.y+reimbursementsSubHeaderFrame.size.height + 9.0, 150.0, 30.0);
                        thisCellAlignment = 0;
                            
                        [self drawText:strThisCellData :thisCellFrame :tableFontBold :textColor :thisCellAlignment];
                        
                    }
                } else {
                    
                    for(int h=0; h<thisRowData.count; h++) {
                        
                        strThisCellData = [thisRowData objectAtIndex:h];
                        
                        if (h==0) {
                            cellX = (kMarginInset) + 5.0;
                            cellW = 100.0;
                        } else if (h==1) {
                            cellX = 105.0;
                            cellW = 225.0;
                        } else if (h==2) {
                            cellX = 330.0;
                            cellW = 50.0;
                        } else if (h==3) {
                            cellX = 390.0;
                            cellW = 50.0;
                        } else if (h==4) {
                            cellX = 445.0;
                            cellW = 75.0;
                        } else if (h==5) {
                            cellX = 525.0;
                            cellW = 50.0;
                        }
                        
                        CGSize thisCellConstraint = [strThisCellData sizeWithFont:tableFont constrainedToSize:CGSizeMake(cellW, 30.0) lineBreakMode:NSLineBreakByWordWrapping];
                
                        textColor = [UIColor whiteColor];
                        thisCellFrame = CGRectMake(cellX, reimbursementsSubHeaderFrame.origin.y+reimbursementsSubHeaderFrame.size.height + 27.0, thisCellConstraint.width, 40.0);
                        thisCellAlignment = 0;
                
                        [self drawText:strThisCellData :thisCellFrame :tableFont :textColor :thisCellAlignment];
                        
                        cellY = thisCellFrame.origin.y + thisCellFrame.size.height;
                       
                    }
                }
            
            } else {
                
                for(int c=0; c<thisRowData.count; c++) {
                    
                    NSString* strThisCellData = [thisRowData objectAtIndex:c];
                    
                    CGSize thisCellSize = [strThisCellData sizeWithFont:tableFont constrainedToSize:CGSizeMake(cellW, 40.0) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    
                    if (c==0) {
                        cellX = (kMarginInset) + 5.0;
                        cellW = 100.0;
                        
                        //for dividers
                        if (i==2 || i==6 || i==9) {
                            cellW = pageSize.width-(kMarginInset+kBorderInset*2);
                        }
                        
                        //add a background bar
                        if (i==2 || i==6) {
                            cellY = cellY + 5.0;
                        } else if (i==9) {
                            cellY = cellY + 20.0;
                            
                            //build background rect
                            UIColor* rectColor = [colorManager setColor:204.0 :204.0 :204.0];
                            CGPoint rectStartPoint = CGPointMake(kMarginInset,cellY+60.0);
                            CGPoint rectEndPoint = CGPointMake(pageSize.width-(kMarginInset*2), cellY+60.0);
                            lineWidth = kLineWidth*(thisCellSize.height+100);
                            [self drawLine:lineWidth:rectColor:rectStartPoint:rectEndPoint];
                        }
                        
                    } else if (c==1) {
                        cellX = 105.0;
                        cellW = 220.0;
                    } else if (c==2) {
                        cellX = 330.0;
                        cellW = 50.0;
                    } else if (c==3) {
                        cellX = 390.0;
                        cellW = 50.0;
                    } else if (c==4) {
                        cellX = 445.0;
                        cellW = 75.0;
                    } else if (c==5) {
                        cellX = 525.0;
                        cellW = 50.0;
                    }
                    
                    
                    thisCellFrame = CGRectMake(cellX, cellY, cellW, thisCellSize.height);
                    thisCellAlignment = 0;
                    
                    [self drawText:strThisCellData :thisCellFrame :tableFont :textColor :thisCellAlignment];
                    
                    
                }
            }
            
            if (i>1) {
                cellY = cellY + 35.0;
            }
            
        }
        
        done = YES;
        
    } while (!done);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
}

#pragma mark - Drawing Methods

- (void) drawText : (NSString* ) textToDraw : (CGRect) textFrame : (UIFont*) textFont : (UIColor*) textColor : (int) textAlignment {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(currentContext, textColor.CGColor);
    
    int myTextAlignment = textAlignment;
    
    [textToDraw drawInRect:textFrame withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:myTextAlignment];
}

- (void) drawImage : (UIImage*) imageToDraw : (CGRect) imageFrame  {
    
   [imageToDraw drawInRect:imageFrame];
}

- (void) drawLine : (float) lineWidth : (UIColor*) lineColor : (CGPoint) startPoint : (CGPoint) endPoint  {
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, lineWidth);
    CGContextSetStrokeColorWithColor(currentContext, lineColor.CGColor);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}

#pragma mark - Data Gather

- (float) getStringHeight : (NSString* ) stringToMeasure : (float) widthConstraint : (UIFont*) thisFont {
    
    CGSize stringConstraint = CGSizeMake(widthConstraint, 9999.0);
    CGSize stringSize = [stringToMeasure sizeWithFont:thisFont constrainedToSize:stringConstraint lineBreakMode:NSLineBreakByWordWrapping];
    
    return stringSize.height;
    
}

- (float) getMaxHeaderHeight : (NSArray*) headers : (UIFont*) font {
    
    //set a max height for the headers
    float maxHeaderH = 0.0;
    
    for(int i=0; i<headers.count; i++) {
        
        float thisConstraint;
        
        if (i==0) {
            thisConstraint = 140.0;
        } else {
            thisConstraint = (pageSize.width-(kMarginInset*2))/2;
        }
        
        float thisStringHeight = [self getStringHeight:[headers objectAtIndex:i] :thisConstraint:font];
        
        if (thisStringHeight > maxHeaderH) {
            maxHeaderH = thisStringHeight;
        }
    }
    
    return maxHeaderH;

}

- (void) setHeaderText : (NSArray*) headers : (UIFont*) font : (float) headerX : (float) headerY : (float) headerW : (float) headerH : (UIColor*) textColor {
    
    for(int i=0; i<headers.count; i++) {
        
        NSString* strThisHeader = [headers objectAtIndex:i];
        
        if (i>0) {
            headerX = headerX + headerW + 5.0;
            
            if (headerW == 140.0) { 
                headerW = 200.0;
            } else if (headerW == 80.0) {
                if (i>1) { 
                    headerW = 140.0;
                    headerX = headerX + 15.0;
                }
            } else if (headerW == 240.0) {
                headerW = 124.0;
            }
        }
        
        CGRect thisHeaderFrame = CGRectMake(headerX, headerY, headerW, headerH);
        [self drawText:strThisHeader :thisHeaderFrame :font:textColor:0];
    }
}

- (void) buildAlternatingTableRows : (NSArray*) rowHeaders : (UIColor* ) color1 : (UIColor* ) color2 : (float) rowX : (float) rowY : (float) endRowX : (float) endRowY : (float) lineWidth {
    
    for(int i=0; i<rowHeaders.count; i++) {
    
        //build a row
        UIColor* rowColor;
        if (i%2) {
            rowColor = color1;
        } else {
            rowColor = color2;
        }
    
        if(i>0) {
            rowY = rowY + 40.0;
            endRowY = endRowY + 40.0;
        }
        
        CGPoint rowStartPoint = CGPointMake(rowX, rowY);
        CGPoint rowEndPoint = CGPointMake(endRowX, endRowY);
        [self drawLine:lineWidth:rowColor:rowStartPoint:rowEndPoint];
        
    }

    
}

- (void) setRowText : (NSArray* ) rowCellContents : (float) strX : (float) strY : (float) strW : (float) strH : (UIColor*) textColor : (UIFont*) font {
    
    for(int r=0; r<rowCellContents.count; r++) {
        
        NSString* thisRowItem = [rowCellContents objectAtIndex:r];
        
        if (r>0) {
            
            //increment x
            strX = strX + strW + 5.0;
            
            if (strW == 140) { 
                //change row w
                strW = 200.0;
            } else if (strW == 80 && r>1) {
                strW = 140.0;
                strX = strX + 15.0;
            }
        }
        
        CGRect thisRowCellFrame = CGRectMake(strX, strY, strW, strH);
        [self drawText:thisRowItem :thisRowCellFrame :font:textColor:0];
        
    }

    
}

- (NSArray* ) gatherCellData : (NSDictionary*) theResults : (NSString* ) key {
    
    //set up an array to hold the keys to pul from theResults
    NSMutableArray* keyArray = [[NSMutableArray alloc] init];
    for(int i=0; i<3; i++) {
        [keyArray addObject:[NSString stringWithFormat:@"%@ Year %i", key, i+1]];
    }
    
    
    
    //loop through results
    for(NSString* thisKey in theResults) {
     
        if([thisKey hasPrefix:key]) {
            NSArray* thisRowCellData = [[NSArray alloc] initWithObjects:[theResults objectForKey:[keyArray objectAtIndex:0]], [theResults objectForKey:[keyArray objectAtIndex:1]], [theResults objectForKey:[keyArray objectAtIndex:2]],nil];
            
            return thisRowCellData;
        }
        
    }
    
    
    NSArray* thisRowCellData;
    return thisRowCellData;
    
}

@end
