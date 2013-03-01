//
//  ViewController.m
//  EUS Calculator
//
//  Created by Steve Suranie on 1/9/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "ViewController.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isCashOutlay = YES;
    
    /***************************
     SET UP THE MANAGERS AND IVARS
     ***************************/
    
    colorManager = [[OAI_ColorManager alloc] init];
    fileManager = [[OAI_FileManager alloc] init];
    alertManager = [[OAI_AlertScreen alloc] init];
    stringManager = [[OAI_StringManager alloc] init];
    dataManager = [[OAI_DataManager alloc] init];
    mailManager = [[OAI_MailManager alloc] init];
    pdfManager = [[OAI_PDFManager alloc] init];
    
    placedSections = [[NSMutableArray alloc] init];
    placedRows = [[NSMutableArray alloc] init];
    placedCells = [[NSMutableArray alloc] init];
    
    calcElements =[[NSMutableArray alloc] init];
    resultsFields =[[NSMutableArray alloc] init];
    
    //set up a decimal number handler
    myDecimalHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
            scale:2
            raiseOnExactness:NO
            raiseOnOverflow:NO
            raiseOnUnderflow:NO
            raiseOnDivideByZero:NO
        ];
    
    //set up the results dictionary
    results = [[NSMutableDictionary alloc] init];
    
    /*************************************
     REGISTER FOR NOTIFICATIONS FOR KEYBOARD
     **************************************/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    /*************************************
     TOP BAR
     *************************************/
    
    UIView* topBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40.0)];
    topBar.backgroundColor = [UIColor blackColor];
    
    //shadow
    topBar.layer.masksToBounds = NO;
    topBar.layer.shadowOffset = CGSizeMake(0, 5);
    topBar.layer.shadowRadius = 5;
    topBar.layer.shadowOpacity = 0.75;
    
    //set olympus logo
    UIImageView* OALogoTopBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OA_logo_black_topbar.png"]];
    
    //position the logo
    CGRect topBarLogoFrame = OALogoTopBar.frame;
    topBarLogoFrame.origin.x = 15.0;
    topBarLogoFrame.origin.y = 8.0;
    OALogoTopBar.frame = topBarLogoFrame;
    
    //add the logo
    [topBar addSubview:OALogoTopBar];
    
    //add the toggle account data button
    UIImage* imgAccount = [UIImage imageNamed:@"btnAccount.png"];
    UIButton* btnAccount = [[UIButton alloc] initWithFrame:CGRectMake(OALogoTopBar.frame.origin.x+OALogoTopBar.frame.size.width + 20.0, 2.0, imgAccount.size.width, imgAccount.size.height)];
    [btnAccount setImage:imgAccount forState:UIControlStateNormal];
    [btnAccount addTarget:self action:@selector(toggleAccount:) forControlEvents:UIControlEventTouchUpInside];
    [btnAccount setBackgroundColor:[UIColor clearColor]];
    [topBar addSubview:btnAccount];
    
    //set the app title
    CGSize titleSize = [@"EUS Value Calculator" sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
    UILabel* appTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - titleSize.width)-20.0, 5.0, titleSize.width+10.0, titleSize.height)];
    appTitle.text = @"EUS Value Calculator";
    appTitle.textColor = [UIColor whiteColor];
    appTitle.backgroundColor = [UIColor clearColor];
    appTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size: 18.0];
    [topBar addSubview:appTitle];
    
    [self.view addSubview:topBar];
    
    
    
    /************************************
     WRAPPER
     ************************************/
    
    //set up a wrapper to hold our basic items
    objectWrapper = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-topBar.frame.size.height)];
    
    
    /*************************************
     TITLE IMAGE
     *************************************/
    
    UIImage* imgTitle = [UIImage imageNamed:@"imgTitle.png"];
    UIImageView* imgTitleView = [[UIImageView alloc] initWithImage:imgTitle];
    //reposition
    CGRect imgTitleFrame = imgTitleView.frame;
    imgTitleFrame.origin.x = (self.view.frame.size.width/2)-(imgTitle.size.width/2);
    imgTitleFrame.origin.y = 300.0;
    imgTitleView.frame = imgTitleFrame;
    [objectWrapper addSubview:imgTitleView];
	
    /*************************************
     NAV BUTTONS
     *************************************/
    
    btnSummaryImg = [UIImage imageNamed:@"btnSummary.png"];
    
    UIButton* btnSummary = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSummary setImage:btnSummaryImg forState:UIControlStateNormal];
    [btnSummary addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    //reset the button frame
    CGRect btnSummaryFrame = btnSummary.frame;
    btnSummaryFrame.origin.x = (self.view.frame.size.width/2)-(btnSummaryImg.size.width+5.0);
    btnSummaryFrame.origin.y = (imgTitleView.frame.origin.y + imgTitleView.frame.size.height) + 20.0;
    btnSummaryFrame.size.width = btnSummaryImg.size.width;
    btnSummaryFrame.size.height = btnSummaryImg.size.height;
    btnSummary.frame = btnSummaryFrame;
    btnSummary.tag = 10;
    
    btnCalculatorImg = [UIImage imageNamed:@"btnCalculator.png"];
    
    UIButton* btnCalculator = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCalculator setImage:btnCalculatorImg forState:UIControlStateNormal];
    [btnCalculator addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    //reset the button frame
    CGRect btnCalculatorFrame = btnCalculator.frame;
    btnCalculatorFrame.origin.x = (self.view.frame.size.width/2);
    btnCalculatorFrame.origin.y = (imgTitleView.frame.origin.y + imgTitleView.frame.size.height) + 20.0;
    btnCalculatorFrame.size.width = btnCalculatorImg.size.width;
    btnCalculatorFrame.size.height = btnCalculatorImg.size.height;
    btnCalculator.frame = btnCalculatorFrame;
    btnCalculator.tag = 11;
    
    
    [objectWrapper addSubview:btnSummary];
    [objectWrapper addSubview:btnCalculator];
    objectWrapper.tag = 101;
    
    [self.view addSubview:objectWrapper];
    
    /*************************************
     SUMMARY SCREEN
     *************************************/
    
    vSummaryScreen = [[UIView alloc] initWithFrame:CGRectMake(0.0-self.view.frame.size.width, topBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - topBar.frame.size.height)];
    vSummaryScreen.tag = 102;
    
    NSString* summaryTitle = @"EUS Value Calculator Summary";
    CGSize summaryTitleSize = [summaryTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
    
    OAI_Label* lblSummaryTitle = [[OAI_Label alloc] initWithFrame:CGRectMake((vSummaryScreen.frame.size.width/2)-(summaryTitleSize.width/2), 30.0, summaryTitleSize.width, summaryTitleSize.height)];
    lblSummaryTitle.text = summaryTitle;
    lblSummaryTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    [vSummaryScreen addSubview:lblSummaryTitle];
    
    UIWebView* webSummary = [[UIWebView alloc] initWithFrame:CGRectMake(20.0, 70.0, self.view.frame.size.width-40.0, 600.0)];
    webSummary.delegate = self;
    webSummary.tag = 420;
    [webSummary loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"introduction" ofType:@"html"]isDirectory:NO]]];
    
    [vSummaryScreen addSubview:webSummary];
    
    //add button to take us to the calculator
    btnSwitchToCalc = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSwitchToCalc setImage:btnCalculatorImg forState:UIControlStateNormal];
    [btnSwitchToCalc addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    //reset the button frame
    CGRect btnSwitchFrame = btnSwitchToCalc.frame;
    btnSwitchFrame.origin.x = (self.view.frame.size.width/2)-(btnCalculatorImg.size.width/2);
    btnSwitchFrame.origin.y = 780.0;
    btnSwitchFrame.size.width = btnCalculatorImg.size.width;
    btnSwitchFrame.size.height = btnCalculatorImg.size.height;
    btnSwitchToCalc.frame = btnSwitchFrame;
    btnSwitchToCalc.tag = 11;
    [vSummaryScreen addSubview:btnSwitchToCalc];
    
    [self.view addSubview:vSummaryScreen];
    
    /*************************************
     CALCULATOR SCREEN
     *************************************/
    
    //set up the sections
    NSArray* sections = [[NSArray alloc] initWithObjects:@"Equipment", @"Expected Case Volume", @"Operating Costs", @"Reimbursement", @"Downstream Revenue",  nil];
    
    vCalculator = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, topBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - topBar.frame.size.height)];
    vCalculator.tag = 103;
    
    //segmented control
    scCalculatorSections = [[UISegmentedControl alloc] initWithItems:sections];
    CGRect scCalculatorFrame = scCalculatorSections.frame;
    scCalculatorFrame.origin.y = 5.0;
    scCalculatorFrame.origin.x = 0.0;
    scCalculatorSections.frame = scCalculatorFrame;
    [scCalculatorSections setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [scCalculatorSections addTarget:self action:@selector(scrollToView:) forControlEvents:UIControlEventValueChanged];
    
    [self resizeSegmentedControlSegments];
    
    [vCalculator addSubview:scCalculatorSections];
    
    //scroll view
    svCalculatorScroll = [[OAI_ScrollView alloc] initWithFrame:CGRectMake(10.0, scCalculatorSections.frame.origin.y + scCalculatorSections.frame.size.height + 5.0, self.view.frame.size.width-20.0, self.view.frame.size.height - scCalculatorSections.frame.size.height)];
    [svCalculatorScroll setPagingEnabled:YES];
    [svCalculatorScroll setShowsVerticalScrollIndicator:NO];
    [svCalculatorScroll setShowsHorizontalScrollIndicator:NO];
    [svCalculatorScroll setDelegate:self];
    [svCalculatorScroll setContentSize:CGSizeMake(self.view.bounds.size.width * (sections.count+1), 1)];
    svCalculatorScroll.scrollEnabled = NO;
    myScrollViewOrigiOffSet = svCalculatorScroll.contentOffset;
    
    float viewX = 0.0;
    float viewY = 0.0;
    float viewW = 768.0;
    float viewH = 1004.0;
    
    //scroll view contents
    for(int i=0; i<sections.count+1; i++) {
        
        if (i>0) {
            viewX = viewX + viewW;
        }
        
        UIView* thisView = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
                
        if (i==0) {
            
            NSString* calculatorTitle = @"EUS Value Calculator";
            CGSize calculatorTitleSize = [calculatorTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
            
            OAI_Label* lblCalculatorTitle = [[OAI_Label alloc] initWithFrame:CGRectMake((thisView.frame.size.width/2)-(calculatorTitleSize.width/2), 30.0, calculatorTitleSize.width, calculatorTitleSize.height)];
            lblCalculatorTitle.text = calculatorTitle;
            lblCalculatorTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
            lblCalculatorTitle.backgroundColor = [UIColor clearColor];
            [thisView addSubview:lblCalculatorTitle];
            
            //instructions
            NSString* strCalculatorInstructions = stringManager.instructions;
            CGSize strCalculatorInstructionsSize = [calculatorTitle sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
            
            lblCalculatorInstructions = [[OAI_Label alloc] initWithFrame:CGRectMake(20.0,lblCalculatorTitle.frame.size.height+40.0, vCalculator.frame.size.width-40.0, strCalculatorInstructionsSize.height*10)];
            lblCalculatorInstructions.text = strCalculatorInstructions;
            lblCalculatorInstructions.textColor = [colorManager setColor:66.0 :66.0 :66.0];
            lblCalculatorInstructions.font = [UIFont fontWithName:@"Helvetica" size: 20.0];
            lblCalculatorInstructions.numberOfLines = 0;
            lblCalculatorInstructions.lineBreakMode = NSLineBreakByWordWrapping;
            [thisView addSubview:lblCalculatorInstructions];            
            
            
        } else if (i>0) {
            
            //set the title of each section
            NSString* thisSectionTitle = [sections objectAtIndex:i-1];
            CGSize thisSectionSize = [thisSectionTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
            
            //set the title
            UILabel* lblThisSection = [[UILabel alloc] initWithFrame:CGRectMake(23.0, 20.0, thisSectionSize.width, thisSectionSize.height)];
            lblThisSection.text = thisSectionTitle;
            lblThisSection.textColor = [colorManager setColor:33.0 :33.0 :33.0];
            lblThisSection.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
            lblThisSection.backgroundColor = [UIColor clearColor];
            [thisView addSubview:lblThisSection];
            
            //get the properties for that section
            NSMutableDictionary* sectionProperties = [self getSectionProperties:i-1];
            
            //set floats for section coords/size
            float sectionY = 55.0;
            
            UIView* sectionWrapper = [[UIView alloc] initWithFrame:CGRectMake(20.0, sectionY, thisView.frame.size.width-40.0, thisView.frame.size.height)];
            [thisView addSubview:sectionWrapper];
            
            //the calculate button
            UIImage* imgCalculate = [[UIImage imageNamed:@"btnCalculate_long_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 10)];
            UIImage* imgCalculateHighlighted = [UIImage imageNamed:@"btnCalculate_long_highlight.png"];
            CGSize imgCalcSize = imgCalculate.size;
            
            btnCalculate = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnCalculate setImage:imgCalculate forState:UIControlStateNormal];
            [btnCalculate setImage:imgCalculateHighlighted forState:UIControlStateHighlighted];
            [btnCalculate addTarget:self action:@selector(calculate) forControlEvents:UIControlEventTouchUpInside];
            //reset the button location
            CGRect btnCalculateFrame = btnCalculate.frame;
            btnCalculateFrame.origin.x = 23.0;
            btnCalculateFrame.origin.y = lblThisSection.frame.origin.y + lblThisSection.frame.size.height + 10.0;
            btnCalculateFrame.size.width = imgCalcSize.width;
            btnCalculateFrame.size.height = imgCalcSize.height;
            btnCalculate.frame = btnCalculateFrame;
            
            [thisView addSubview:btnCalculate];
            
            [self buildSections:sectionProperties:sectionWrapper];
            
            
        }
        
        //add button to open assumptions
        NSString* strAssumptions = @"Notes, Assumptions and References";
        CGSize assumptionsSize = [strAssumptions sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
        
        NSString* strReimbursements = @"Reimbursements";
        CGSize reimbursementsSize = [strReimbursements sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
        
        //add the assumptions disclosure button
        UIButton* btnAssumptions = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        CGRect btnAssumptionsFrame = btnAssumptions.frame;
        btnAssumptionsFrame.origin.x = 20.0;
        btnAssumptionsFrame.origin.y = self.view.frame.size.height-180;
        btnAssumptions.frame = btnAssumptionsFrame;
        [btnAssumptions addTarget:self action:@selector(showAssumptions:) forControlEvents:UIControlEventTouchUpInside];
        [thisView addSubview:btnAssumptions];
        
        //add the assumptions footer
        UILabel* lblAssumptions = [[UILabel alloc] initWithFrame:CGRectMake(55.0, self.view.frame.size.height-170, assumptionsSize.width, assumptionsSize.height)];
        lblAssumptions.text = strAssumptions;
        lblAssumptions.textColor = [colorManager setColor:8 :16 :123];
        lblAssumptions.backgroundColor = [UIColor clearColor];
        lblAssumptions.font = [UIFont fontWithName:@"Helvetica" size:11.0];
        lblAssumptions.userInteractionEnabled = YES;
        //make the ui label clickable
        UITapGestureRecognizer* showAssumptions = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAssumptions:)];
        [lblAssumptions addGestureRecognizer:showAssumptions];
        [thisView addSubview:lblAssumptions];
        
        //add the reimbursements disclosure button
        UIButton* btnReimbursements = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        CGRect btnReimbursementsFrame = btnReimbursements.frame;
        btnReimbursementsFrame.origin.x = 20.0;
        btnReimbursementsFrame.origin.y = btnAssumptions.frame.origin.y + btnAssumptions.frame.size.height + 5.0;
        btnReimbursements.frame = btnReimbursementsFrame;
        [btnReimbursements addTarget:self action:@selector(showReimbursements:) forControlEvents:UIControlEventTouchUpInside];
        [thisView addSubview:btnReimbursements];
        
        //add the reimbursements footer
        UILabel* lblReimbursements = [[UILabel alloc] initWithFrame:CGRectMake(55.0, lblAssumptions.frame.origin.y + lblAssumptions.frame.size.height + 20.0, reimbursementsSize.width, reimbursementsSize.height)];
        lblReimbursements.text = strReimbursements;
        lblReimbursements.textColor = [colorManager setColor:8 :16 :123];
        lblReimbursements.backgroundColor = [UIColor clearColor];
        lblReimbursements.font = [UIFont fontWithName:@"Helvetica" size:11.0];
        lblReimbursements.userInteractionEnabled = YES;
        //make the ui label clickable
        
        UITapGestureRecognizer* showReimbursements = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showReimbursements:)];
        [lblReimbursements addGestureRecognizer:showReimbursements];
        [thisView addSubview:lblReimbursements];
        
        [svCalculatorScroll addSubview:thisView];
    }
    
    
    
    /**************************
     RESULTS
     ***************************/
    
    viewX = viewX + viewW;
    UIScrollView* vResults = [[UIScrollView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    [vResults setDirectionalLockEnabled:YES];
    
    //section title
    UILabel* lblResultsTitle = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, vResults.frame.size.width-40.0, 40.0)];
    lblResultsTitle.text = @"Results";
    lblResultsTitle.textColor = [colorManager setColor:8 :16 :123];
    lblResultsTitle.backgroundColor = [UIColor clearColor];
    lblResultsTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    lblResultsTitle.textAlignment = NSTextAlignmentCenter;
    [vResults addSubview:lblResultsTitle];
    
    //option control
    NSArray* calcOptionItems = [[NSArray alloc] initWithObjects: @"Show Cash Outlay", @"Show Fair Market Lease", nil];
    scCalcOptions = [[UISegmentedControl alloc] initWithItems:calcOptionItems];
    CGRect scCalcOptionsFrame = scCalcOptions.frame;
    scCalcOptionsFrame.origin.x = (vResults.frame.size.width/2)-(scCalcOptionsFrame.size.width/2);
    scCalcOptionsFrame.origin.y = lblResultsTitle.frame.size.height +  lblResultsTitle.frame.origin.y + 10.0;
    scCalcOptions.frame = scCalcOptionsFrame;
    scCalcOptions.selectedSegmentIndex = 0;
    [scCalcOptions addTarget:self action:@selector(changeCalcOption:) forControlEvents:UIControlEventValueChanged];
    [vResults addSubview:scCalcOptions];
    
    //the downstream model table title bar
    UILabel* lblDownstreamModel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, scCalcOptions.frame.origin.y + scCalcOptions.frame.size.height + 20.0, vResults.frame.size.width-40.0, 40.0)];
    lblDownstreamModel.text = @"Downstream Revenue Model";
    lblDownstreamModel.textColor = [UIColor whiteColor];
    lblDownstreamModel.backgroundColor = [colorManager setColor:8 :16 :123];
    lblDownstreamModel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblDownstreamModel.textAlignment = NSTextAlignmentCenter;
    [vResults addSubview:lblDownstreamModel];
    
    //mail button
    //add email button
    UIImage* imgEmail = [UIImage imageNamed:@"btnEmail_Small.png"];
    CGSize imgEmailSize = imgEmail.size;

    UIButton *btnEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEmail setImage:imgEmail forState:UIControlStateNormal];
    [btnEmail setImage:imgEmail forState:UIControlStateHighlighted];
    
    CGRect btnEmailFrame = btnEmail.frame;
    btnEmailFrame.origin.x = (self.view.frame.size.width - imgEmailSize.width)-30.0;
    btnEmailFrame.origin.y = lblDownstreamModel.frame.origin.y + 2.5;
    btnEmailFrame.size.width = imgEmailSize.width;
    btnEmailFrame.size.height = imgEmailSize.height;
    btnEmail.frame = btnEmailFrame;
    
    [btnEmail addTarget:self action:@selector(toggleEmailSetUp) forControlEvents:UIControlEventTouchUpInside];
    btnEmail.tag = 601;
    [vResults addSubview:btnEmail];
    
    //downstream model table data
    NSArray* table1Headers = [[NSArray alloc]initWithObjects:@"Department", @"EUS Cases Utilizing Services of Other Departments", @"Average Medicare Reimbursement", nil];
    NSArray* table1RowNames = [[NSArray alloc] initWithObjects:@"Pathology", @"Surgery", @"Admissions", @"Oncology", @"Radiology", @"Anesthesia - Non Endoscopy", @"Other", nil];
    
    //downstream model table
    UIView* vResultsTable1 = [[UIView alloc] initWithFrame:CGRectMake(20.0, lblDownstreamModel.frame.origin.y + lblDownstreamModel.frame.size.height, (vResults.frame.size.width)-40, 40.0*(table1RowNames.count+1))];
    vResultsTable1.backgroundColor = [colorManager setColor:186.0 :209.0 :254.0];
    vResultsTable1.tag = 101;
    
    //get widest col1 width
    NSMutableArray* col1Items = [[NSMutableArray alloc] init];
    [col1Items addObject:[table1Headers objectAtIndex:0]];
    [col1Items addObjectsFromArray:table1RowNames];
    float maxCol1Width = [self getMaxResultsCol1Width:col1Items];
    
    //add the t1header
    UIView* t1HeaderRow = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, vResultsTable1.frame.size.width, 42.0)];
    t1HeaderRow.tag = 201;
    
    NSMutableArray* table1HeaderWidths = [self addResultsHeaders:t1HeaderRow :table1Headers:maxCol1Width];
    [vResultsTable1 addSubview:t1HeaderRow];
    
    //add the data rows
    [self addResultsRows :vResultsTable1 :table1RowNames:maxCol1Width:table1Headers.count:table1HeaderWidths];
    
    //reset table size
    CGRect resultsTable1Frame = vResultsTable1.frame;
    resultsTable1Frame.size.height = [self getTableHeight:vResultsTable1];
    vResultsTable1.frame = resultsTable1Frame;
    
    //add the table to the results
    [vResults addSubview:vResultsTable1];
    
    /*********************table 2********************/
    
    //set up table 2 data
    NSArray* table2Headers = [[NSArray alloc] initWithObjects:@"", @"Number of Cases", @"Total Downstream GROWTH Revenue", @"Total Downstream Operating Margin ", nil];
    NSArray* table2RowNames = [[NSArray alloc] initWithObjects:@"Year 1", @"Year 2", @"Year 3", nil];
    
    //get widest col1 width for table 2
    maxCol1Width = [self getMaxResultsCol1Width:table2RowNames];
    
    UIView* vResultsTable2 = [[UIView alloc] initWithFrame:CGRectMake(20.0, vResultsTable1.frame.origin.y + vResultsTable1.frame.size.height-2.0, vResults.frame.size.width-40, 40*(table2RowNames.count+1))];
    vResultsTable2.backgroundColor = [colorManager setColor:252.0 :252.0 :212.0];
    vResultsTable2.tag = 102;
    
    //add the t2header
    UIView* t2HeaderRow = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, vResultsTable2.frame.size.width, 42.0)];
    t2HeaderRow.tag = 202;
    
    NSMutableArray* table2HeaderWidths = [self addResultsHeaders:t2HeaderRow :table2Headers:maxCol1Width];
    [vResultsTable2 addSubview:t2HeaderRow];
    
    //add the data rows
    [self addResultsRows :vResultsTable2 :table2RowNames:maxCol1Width:table2Headers.count:table2HeaderWidths];
    
    [vResults addSubview:vResultsTable2];
    
    NSString* tableExplained = [NSString stringWithFormat:@"30%% of Downstream Reimbursement is calculated as Downstream Revenue"];
    CGSize tableExplainedSize = [tableExplained sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    
    UILabel* lblPercentageExplained = [[UILabel alloc] initWithFrame: CGRectMake(20.0, vResultsTable2.frame.origin.y + vResultsTable2.frame.size.height + 5.0, tableExplainedSize.width, tableExplainedSize.height)];
    lblPercentageExplained.text = tableExplained;
    lblPercentageExplained.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblPercentageExplained.backgroundColor = [UIColor clearColor];
    lblPercentageExplained.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    [vResults addSubview:lblPercentageExplained];
    
    /*********************Cash OR Lease********************/
    
    NSString* strResultType = @"Three-Year Projection Assuming Cash Outlay";
    CGSize strResultTypeSize = [strResultType sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
    
    lblResultType = [[UILabel alloc] initWithFrame: CGRectMake((vResults.frame.size.width/2)-(strResultTypeSize.width/2), lblPercentageExplained.frame.origin.y + lblPercentageExplained.frame.size.height + 15.0, strResultTypeSize.width, strResultTypeSize.height)];
    lblResultType.text = strResultType;
    lblResultType.textColor = [colorManager setColor:8 :16 :123];
    lblResultType.backgroundColor = [UIColor clearColor];
    lblResultType.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    [vResults addSubview:lblResultType];
    
    /*********************table 3********************/
    
    NSArray* table3Headers = [[NSArray alloc] initWithObjects:@"", @"Year 1", @"Year 2", @"Year 3", nil];
    NSArray* table3RowNames = [[NSArray alloc] initWithObjects:@"Revenue", @"Number of patients per week", @"Number of patients per year", @"Total Facility Fees (without modifiers)", @"Total Physician Fees", @"Total Anesthesia Fees", @"Downstream Operating Margin", @"Annual Operating Margin ", @" ",@"Expenditure", @"Equipment", @"Labor", @"Service & Maintenance", @"Other variable costs", @"Other fixed costs", @"Total Cost", @"Annual Operating Margin", @"Net Operating Margin",nil];
    
    maxCol1Width = [self getMaxResultsCol1Width:table3RowNames];
    
    UIView* vResultsTable3 = [[UIView alloc] initWithFrame:CGRectMake(20.0, lblResultType.frame.origin.y + lblResultType.frame.size.height + 10.0, vResults.frame.size.width-40, 40*(table3RowNames.count+1))];
    vResultsTable3.backgroundColor = [colorManager setColor:204.0:204.0:204.0];
    vResultsTable3.tag = 103;
    
    //add the t3header
    UIView* t3HeaderRow = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, vResultsTable3.frame.size.width, 42.0)];
    t3HeaderRow.tag = 203;
    
    NSMutableArray* table3HeaderWidths = [self addResultsHeaders:t3HeaderRow :table3Headers:maxCol1Width];
    [vResultsTable3 addSubview:t3HeaderRow];
    
    //add the data rows
    [self addResultsRows :vResultsTable3 :table3RowNames:maxCol1Width:table3Headers.count:table3HeaderWidths];
    
    CGRect resultsTable3Frame = vResultsTable3.frame;
    resultsTable3Frame.size.height = [self getTableHeight:vResultsTable3];
    vResultsTable3.frame = resultsTable3Frame;
    
    [vResults addSubview:vResultsTable3];
    
    /********************DISCLAIMER******************/
    
    CGSize maximumLabelSize = CGSizeMake(vResults.frame.size.width-40.0,9999);
    CGSize disclaimerSize = [stringManager.disclaimer sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel* lblDisclaimer = [[UILabel alloc] initWithFrame:CGRectMake(20.0, vResultsTable3.frame.origin.y + vResultsTable3.frame.size.height, vResults.frame.size.width-40.0, disclaimerSize.height+100.0)];
    lblDisclaimer.text = stringManager.disclaimer;
    lblDisclaimer.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblDisclaimer.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    lblDisclaimer.backgroundColor = [UIColor clearColor];
    lblDisclaimer.numberOfLines = 0;
    lblDisclaimer.lineBreakMode = NSLineBreakByWordWrapping;
    [vResults addSubview:lblDisclaimer];
    
    //set the scroll view height
    [self setScrollViewHeight:vResults];
    
    [svCalculatorScroll addSubview:vResults];
    
    /***************************************
     INSTRUCTIONS
     ***************************************/
    
    vInstructions = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-250.0, 300.0, 500.0, 500.0)];
    vInstructions.backgroundColor = [colorManager setColor:233.0:178.0:38.0];
    [vInstructions.layer setShadowColor:[UIColor blackColor].CGColor];
    [vInstructions.layer setShadowOpacity:0.8];
    [vInstructions.layer setShadowRadius:3.0];
    [vInstructions.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    vInstructions.alpha = 0.0;
    [vCalculator addSubview:vInstructions];
    
    
    //set the scroll view height
    //[self setScrollViewHeight:svCalculatorScroll];
    
    //add the scroll view to the vCal
    [vCalculator addSubview:svCalculatorScroll];
    
    [self.view addSubview:vCalculator];
    
    /*************************************
     ALERT SCREEN
     *************************************/
    alertManager = [[OAI_AlertScreen alloc] init];
    
    //set alert view
    CGRect alertFrame = alertManager.frame;
    alertFrame.origin.x = (self.view.frame.size.width/2)-250.0;
    alertFrame.origin.y = 250.0;
    alertFrame.size.width = 500.0;
    alertFrame.size.height = 400.0;
    alertManager.frame = alertFrame;
    
    alertManager.backgroundColor = [UIColor whiteColor];
    alertManager.alpha = 0.0;
    
    [self.view addSubview:alertManager];
    
    /*************************************
     SPLASH SCREEN
     *************************************/
    
    //check to see if we need to display the splash screen
    needsSplash = YES;
    
    if (needsSplash) {
        CGRect myBounds = self.view.bounds;
        appSplashScreen = [[OAI_SplashScreen alloc] initWithFrame:CGRectMake(myBounds.origin.x, myBounds.origin.y, myBounds.size.width, myBounds.size.height)];
        [self.view addSubview:appSplashScreen];
        [appSplashScreen runSplashScreenAnimation];
    }
    
    /*************************************
     EMAIL SETUP SCREEN
     *************************************/
    
    vMailOptions = [[UIView alloc] initWithFrame:CGRectMake(0.0, -400.0, self.view.frame.size.width, 400.0)];
    vMailOptions.backgroundColor = [UIColor whiteColor];
    [vMailOptions.layer setShadowColor:[UIColor blackColor].CGColor];
    [vMailOptions.layer setShadowOpacity:0.8];
    [vMailOptions.layer setShadowRadius:3.0];
    [vMailOptions.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    //title bar
    UIView* vLblBG = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, vMailOptions.frame.size.width, 40.0)];
    vLblBG.backgroundColor = [colorManager setColor:8 :16 :123];
    
    NSString* strEmailOptionsTitle=  @"Email Options";
    CGSize emailOptionsTitleSize = [strEmailOptionsTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
    
    OAI_Label* lblEmailOptions = [[OAI_Label alloc] initWithFrame:CGRectMake((vMailOptions.frame.size.width/2)-(emailOptionsTitleSize.width/2), 10.0, emailOptionsTitleSize.width, 30.0)];
    lblEmailOptions.text = strEmailOptionsTitle;
    lblEmailOptions.textColor = [UIColor whiteColor];
    lblEmailOptions.backgroundColor = [UIColor clearColor];
    lblEmailOptions.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    [vLblBG addSubview:lblEmailOptions];
    
    [vMailOptions addSubview:vLblBG];
    
    //recipient name
    NSString* strName=  @"Recipeint Name";
    
    txtName = [[UITextField alloc] initWithFrame:CGRectMake((vMailOptions.frame.size.width/2)-250.0, vLblBG.frame.origin.y + vLblBG.frame.size.height + 30.0, 500.0, 40.0)];
    txtName.textColor = [colorManager setColor:66.0:66.0:66.];
    txtName.backgroundColor = [UIColor whiteColor];
    txtName.borderStyle = UITextBorderStyleRoundedRect;
    txtName.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    txtName.placeholder = strName;
    [vMailOptions addSubview:txtName];
    
    //company name
    NSString* strFacility = @"Company/Facility Name";
    
    txtFacility = [[UITextField alloc] initWithFrame:CGRectMake((vMailOptions.frame.size.width/2)-250.0, txtName.frame.origin.y + txtName.frame.size.height + 20.0, 500.0, 40.0)];
    txtFacility.textColor = [colorManager setColor:66.0:66.0:66.];
    txtFacility.backgroundColor = [UIColor whiteColor];
    txtFacility.borderStyle = UITextBorderStyleRoundedRect;
    txtFacility.placeholder = strFacility;
    txtFacility.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    [vMailOptions addSubview:txtFacility];
    
    NSString* strPDFOption=  @"Attach PDF?";
    CGSize PDFOptionSize = [strPDFOption sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
    
    //pdf options label
    OAI_Label* lblPDFOption = [[OAI_Label alloc] initWithFrame:CGRectMake((vMailOptions.frame.size.width/2)-(PDFOptionSize.width/2), txtFacility.frame.origin.y + txtFacility.frame.size.height, PDFOptionSize.width, 60.0)];
    lblPDFOption.text = strPDFOption;
    lblPDFOption.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblPDFOption.backgroundColor = [UIColor clearColor];
    [vMailOptions addSubview:lblPDFOption];
    
    //our sc butttons
    NSArray* segmentedControlItems = [[NSArray alloc] initWithObjects:@"Yes", @"No", nil];
    
    //pdf  options
    scPDFOptions = [[UISegmentedControl alloc] initWithItems:segmentedControlItems];
    //reset
    CGRect scPDFOptionsFrame = scPDFOptions.frame;
    scPDFOptionsFrame.origin.x = ((vMailOptions.frame.size.width/2)-(scPDFOptionsFrame.size.width/2));
    scPDFOptionsFrame.origin.y = lblPDFOption.frame.origin.y + lblPDFOption.frame.size.height + 5.0;
    scPDFOptions.frame = scPDFOptionsFrame;
    scPDFOptions.selectedSegmentIndex = 0;
    
    [vMailOptions addSubview:scPDFOptions];
    
    //buttons
    //submit images
    UIImage* imgSubmitNormal = [UIImage imageNamed:@"btnSubmitNormal.png"];
    UIImage* imgSubmitHighlight = [UIImage imageNamed:@"btnSubmitHighlight.png"];
    
    //get the image sizes
    CGSize imgSubmitNormalSize = imgSubmitNormal.size;
    
    UIButton* btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setImage:imgSubmitNormal forState:UIControlStateNormal];
    [btnSubmit setImage:imgSubmitHighlight forState:UIControlStateHighlighted];
    
    //reset the button frame
    CGRect btnSubmitFrame = btnSubmit.frame;
    btnSubmitFrame.origin.x = (vMailOptions.frame.size.width/2)-(imgSubmitNormalSize.width+5);
    btnSubmitFrame.origin.y = (scPDFOptions.frame.origin.y + scPDFOptions.frame.size.height) + 30.0;
    btnSubmitFrame.size.width = imgSubmitNormalSize.width;
    btnSubmitFrame.size.height = imgSubmitNormalSize.height;
    btnSubmit.frame = btnSubmitFrame;
    
    //add the action
    [btnSubmit addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    //a tag so we can identify it
    btnSubmit.tag = 101;
    [vMailOptions addSubview:btnSubmit];
    
    //submit images
    UIImage* imgCancelNormal = [UIImage imageNamed:@"btnCancelNormal.png"];
    UIImage* imgCancelHighlight = [UIImage imageNamed:@"btnCancelHighlight.png"];
    
    UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setImage:imgCancelNormal forState:UIControlStateNormal];
    [btnCancel setImage:imgCancelHighlight forState:UIControlStateHighlighted];
    
    //reset the button frame
    CGRect btnCancelFrame = btnCancel.frame;
    btnCancelFrame.origin.x = (vMailOptions.frame.size.width/2);
    btnCancelFrame.origin.y = (scPDFOptions.frame.origin.y + scPDFOptions.frame.size.height) + 30.0;
    btnCancelFrame.size.width = imgSubmitNormalSize.width;
    btnCancelFrame.size.height = imgSubmitNormalSize.height;
    btnCancel.frame = btnCancelFrame;
    
    //add the action
    [btnCancel addTarget:self action:@selector(toggleEmailSetUp) forControlEvents:UIControlEventTouchUpInside];
    //a tag so we can identify it
    btnCancel.tag = 102;
    [vMailOptions addSubview:btnCancel];
    
    UIView* vMailBand = [[UIView alloc] initWithFrame:CGRectMake(0.0, vMailOptions.frame.size.height-20.0, vMailOptions.frame.size.width, 20.0)];
    vMailBand.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"mailBand.png"]];
    [vMailOptions addSubview:vMailBand];
    
    [self.view addSubview:vMailOptions];
    
    /***************************
     NOTES
     ***************************/
    
    webNotesSheet = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0.0, 600.0, 1000.0)];
    [webNotesSheet.layer setShadowColor:[UIColor blackColor].CGColor];
    [webNotesSheet.layer setShadowOpacity:0.8];
    [webNotesSheet.layer setShadowRadius:3.0];
    [webNotesSheet.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    webNotesSheet.backgroundColor = [UIColor whiteColor];
    webNotesSheet.alpha = .9;
    
    OAI_Label* lblWebNotesSheet = [[OAI_Label alloc] initWithFrame:CGRectMake(20.0, 20.0, webNotesSheet.frame.size.width-40.0, 30.0)];
    lblWebNotesSheet.text = @"Notes, Assumptions and References";
    lblWebNotesSheet.textColor = [colorManager setColor:8 :16 :123];
    lblWebNotesSheet.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    lblWebNotesSheet.backgroundColor = [UIColor clearColor];
    [webNotesSheet addSubview:lblWebNotesSheet];
    
    webNotes = [[UIWebView alloc] initWithFrame:CGRectMake(20.0, 70.0, webNotesSheet.frame.size.width-40.0, webNotesSheet.frame.size.height-240.0)];
    webNotes.backgroundColor = [UIColor whiteColor];
    [webNotes loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"assumptions" ofType:@"html"]isDirectory:NO]]];
    webNotes.tag = 422;
    webNotes.layer.borderWidth = 1.0;
    [webNotesSheet addSubview:webNotes];
    
    UIImage* imgCloseWinNormal = [UIImage imageNamed:@"btnCloseNormal.png"];
    UIImage* imgCloseWinHightlight = [UIImage imageNamed:@"btnCloseHighlight.png"];
    CGSize btnImgSize = imgCloseWinNormal.size;
    
    UIButton* btnCloseSheet = [[UIButton alloc] initWithFrame:CGRectMake((webNotesSheet.frame.size.width/2)-(btnImgSize.width/2), webNotes.frame.origin.y + webNotes.frame.size.height + 10, btnImgSize.width, btnImgSize.height)];
    [btnCloseSheet setImage:imgCloseWinNormal forState:UIControlStateNormal];
    [btnCloseSheet setImage:imgCloseWinHightlight forState:UIControlStateHighlighted];
    [btnCloseSheet addTarget:self action:@selector(closeAssumptions:) forControlEvents:UIControlEventTouchUpInside];
    [webNotesSheet addSubview:btnCloseSheet];
    
    [self.view addSubview:webNotesSheet];
    
    /*********************************
     REIMBURSEMENTS
    ********************************/
    
    webReimbursementsSheet = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0.0, 600.0, 1000.0)];
    [webReimbursementsSheet.layer setShadowColor:[UIColor blackColor].CGColor];
    [webReimbursementsSheet.layer setShadowOpacity:0.8];
    [webReimbursementsSheet.layer setShadowRadius:3.0];
    [webReimbursementsSheet.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    webReimbursementsSheet.backgroundColor = [UIColor whiteColor];
    webReimbursementsSheet.alpha = .9;
    
    OAI_Label* lblWebReimbursementSheet = [[OAI_Label alloc] initWithFrame:CGRectMake(20.0, 20.0, webReimbursementsSheet.frame.size.width-40.0, 30.0)];
    lblWebReimbursementSheet.text = @"Reimbursements";
    lblWebReimbursementSheet.textColor = [colorManager setColor:8 :16 :123];
    lblWebNotesSheet.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    lblWebReimbursementSheet.backgroundColor = [UIColor clearColor];
    [webReimbursementsSheet addSubview:lblWebReimbursementSheet];
    
    webReimbursements = [[UIWebView alloc] initWithFrame:CGRectMake(20.0, 70.0, webReimbursementsSheet.frame.size.width-40.0, webReimbursementsSheet.frame.size.height-240.0)];
    webReimbursements.backgroundColor = [UIColor whiteColor];
    [webReimbursements loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"reimbursements" ofType:@"html"]isDirectory:NO]]];
    webReimbursements.tag = 422;
    webReimbursements.layer.borderWidth = 1.0;
    [webReimbursementsSheet addSubview:webReimbursements];
    
    btnCloseSheet = [[UIButton alloc] initWithFrame:CGRectMake((webReimbursementsSheet.frame.size.width/2)-(btnImgSize.width/2), webReimbursements.frame.origin.y + webReimbursements.frame.size.height + 10, btnImgSize.width, btnImgSize.height)];
    [btnCloseSheet setImage:imgCloseWinNormal forState:UIControlStateNormal];
    [btnCloseSheet setImage:imgCloseWinHightlight forState:UIControlStateHighlighted];
    [btnCloseSheet addTarget:self action:@selector(closeReimbursements:) forControlEvents:UIControlEventTouchUpInside];
    [webReimbursementsSheet addSubview:btnCloseSheet];
    
    [self.view addSubview:webReimbursementsSheet];
    
    /*******************************
     USER ACCOUNT INFO
     **********************************/
    
    vAccount = [[UIView alloc] initWithFrame:CGRectMake(100.0, -350.0, 300.0, 350.0)];
    vAccount.backgroundColor = [UIColor whiteColor];
    vAccount.layer.shadowColor = [UIColor blackColor].CGColor;
    vAccount.layer.shadowRadius = 5.0;
    vAccount.layer.shadowOpacity = 0.75;
    
    
    //title and instructions
    NSString* strAccountInfo = @"Account Info";
    CGSize accountInfoSize = [strAccountInfo sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    UILabel* lblAcountInfo = [[UILabel alloc] initWithFrame:CGRectMake((vAccount.frame.size.width/2)-(accountInfoSize.width/2), 20.0, accountInfoSize.width, accountInfoSize.height)];
    lblAcountInfo.text = strAccountInfo;
    lblAcountInfo.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblAcountInfo.backgroundColor = [UIColor clearColor];
    lblAcountInfo.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [vAccount addSubview:lblAcountInfo];
    
    NSString* strAccountInst = @"Enter your account info below. This will be stored and used when emailing results.";
    CGSize accountInstSize = [strAccountInst sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0] constrainedToSize:CGSizeMake(vAccount.frame.size.width-40.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel* lblAcountInst = [[UILabel alloc] initWithFrame:CGRectMake((vAccount.frame.size.width/2)-(accountInstSize.width/2), lblAcountInfo.frame.origin.y + lblAcountInfo.frame.size.height + 5.0, accountInstSize.width, accountInstSize.height)];
    lblAcountInst.text = strAccountInst;
    lblAcountInst.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblAcountInst.backgroundColor = [UIColor clearColor];
    lblAcountInst.numberOfLines = 0;
    lblAcountInst.lineBreakMode = NSLineBreakByWordWrapping;
    lblAcountInst.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    [vAccount addSubview:lblAcountInst];
    
    
    //form elements
    UITextField* txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(20.0, lblAcountInst.frame.origin.y + lblAcountInst.frame.size.height + 35.0, vAccount.frame.size.width-40.0, 30.0)];
    txtUserName.placeholder = @"Name";
    txtUserName.font = [UIFont fontWithName:@"Helvetica" size: 16.0];
    txtUserName.borderStyle = UITextBorderStyleRoundedRect;
    txtUserName.backgroundColor = [UIColor whiteColor];
    txtUserName.delegate = self;
    txtUserName.tag = 601;
    [vAccount addSubview:txtUserName];
    
    UITextField* txtUserTitle = [[UITextField alloc] initWithFrame:CGRectMake(20.0, txtUserName.frame.origin.y + txtUserName.frame.size.height + 15.0, vAccount.frame.size.width-40.0, 30.0)];
    txtUserTitle.placeholder = @"Title";
    txtUserTitle.font = [UIFont fontWithName:@"Helvetica" size: 16.0];
    txtUserTitle.borderStyle = UITextBorderStyleRoundedRect;
    txtUserTitle.backgroundColor = [UIColor whiteColor];
    txtUserTitle.delegate = self;
    txtUserTitle.tag = 602;
    [vAccount addSubview:txtUserTitle];
    
    UITextField* txtUserEmail = [[UITextField alloc] initWithFrame:CGRectMake(20.0, txtUserTitle.frame.origin.y + txtUserTitle.frame.size.height + 10.0, vAccount.frame.size.width-40.0, 30.0)];
    txtUserEmail.placeholder = @"Olympus Email Address";
    txtUserEmail.font = [UIFont fontWithName:@"Helvetica" size: 16.0];
    txtUserEmail.borderStyle = UITextBorderStyleRoundedRect;
    txtUserEmail.backgroundColor = [UIColor whiteColor];
    txtUserEmail.delegate = self;
    txtUserEmail.tag = 603;
    [vAccount addSubview:txtUserEmail];
    
    UITextField* txtUserPhone = [[UITextField alloc] initWithFrame:CGRectMake(20.0, txtUserEmail.frame.origin.y + txtUserEmail.frame.size.height + 10.0, vAccount.frame.size.width-40.0, 30.0)];
    txtUserPhone.placeholder = @"Phone Number";
    txtUserPhone.font = [UIFont fontWithName:@"Helvetica" size: 16.0];
    txtUserPhone.borderStyle = UITextBorderStyleRoundedRect;
    txtUserPhone.backgroundColor = [UIColor whiteColor];
    txtUserPhone.delegate = self;
    txtUserPhone.tag = 604;
    [vAccount addSubview:txtUserPhone];
    
    //add the toggle account data button
    UIImage* imgCloseX = [UIImage imageNamed:@"btnCloseX.png"];
    UIButton* btnCloseX = [[UIButton alloc] initWithFrame:CGRectMake(vAccount.frame.size.width-(imgCloseX.size.width+10.0), vAccount.frame.size.height-(imgCloseX.size.height+10.0), imgCloseX.size.width, imgCloseX.size.height)];
    [btnCloseX setImage:imgCloseX forState:UIControlStateNormal];
    [btnCloseX addTarget:self action:@selector(toggleAccount:) forControlEvents:UIControlEventTouchUpInside];
    [btnCloseX setBackgroundColor:[UIColor clearColor]];
    [vAccount addSubview:btnCloseX];
    
    [self.view addSubview:vAccount];
    [self.view bringSubviewToFront:topBar];
    
}

#pragma mark - Build Section
- (NSMutableDictionary*) getSectionProperties : (int) s {
    
    NSMutableDictionary* thisSectionProperties = [[NSMutableDictionary alloc] init];
    NSMutableArray* table1Data = [[NSMutableArray alloc] init];
    NSMutableArray* table2Data = [[NSMutableArray alloc] init];
    NSMutableArray* table3Data = [[NSMutableArray alloc] init];
    
    if (s==0) {
        
        //there are two separate tables for equipment, so we need two tableHeader arrays and two table contents dictionaries
        
        //add the table count and section title
        [thisSectionProperties setObject:@"3" forKey:@"Table Count"];
        [thisSectionProperties setObject:@"Equipment" forKey:@"Section Title"];
        
        //add the table headers
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Prcoessors", @"Quanity", @"Price/Per", nil]];
        [table2Data addObject:[[NSArray alloc] initWithObjects: @"Endoscopes", @"Quanity", @"Price/Per", nil]];
        [table3Data addObject:[[NSArray alloc] initWithObjects: @"Additional Equipment", nil]];
        
        
        //add the table rows
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"EU-ME1", @"1", @"$0", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"SSD-Alpha 5", @"1", @"$0", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"SSD-Alpha 10", @"1", @"$0", nil]];
        
        [table2Data addObject:[[NSArray alloc] initWithObjects: @"GF-UC140P-AL5", @"1", @"$0", nil]];
        [table2Data addObject:[[NSArray alloc] initWithObjects: @"GF-UCT140-AL5", @"1", @"$0", nil]];
        [table2Data addObject:[[NSArray alloc] initWithObjects: @"GF-UE160-AL5", @"1", @"$0", nil]];
        [table2Data addObject:[[NSArray alloc] initWithObjects: @"GF-UCT180", @"1", @"$0", nil]];
        
        [table3Data addObject:[[NSArray alloc] initWithObjects: @"Additional Equipment", @"1", @"$0", nil]];
        
        [thisSectionProperties setObject:table1Data forKey:@"Table 1"];
        [thisSectionProperties setObject:table2Data forKey:@"Table 2"];
        [thisSectionProperties setObject:table3Data forKey:@"Table 3"];
        
        //add table data to elements array
        [calcElements addObject:@"EU-ME1"];
        [calcElements addObject:@"SSD-Alpha 5"];
        [calcElements addObject:@"SSD-Alpha 10"];
        [calcElements addObject:@"GF-UC140P-AL5"];
        [calcElements addObject:@"GF-UCT140-AL5"];
        [calcElements addObject:@"GF-UE160-AL5"];
        [calcElements addObject:@"GF-UCT180"];
        [calcElements addObject:@"Additional Equipment"];
        
        
    } else if (s==1) {
        
        [thisSectionProperties setObject:@"1" forKey:@"Table Count"];
        [thisSectionProperties setObject:@"Expected Case Volume" forKey:@"Section Title"];
        [thisSectionProperties setObject:@"2" forKey:@"Rows Needing Instructions"];
        
        NSArray* myInstructions = [[NSArray alloc] initWithObjects: stringManager.helpCasesPerWeek, nil];
        [thisSectionProperties setObject:myInstructions forKey:@"Instructions"];
        
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"", @"", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Facility Type", @"Government/VA", @"Teaching Hospital", @"Community Hospital", @"ASC", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Total number of EUS patients anticipated per week", @"2", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Number of working days per year", @"240", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Anticipated annual increase in EUS caseload", @"10%", nil]];
        
        [thisSectionProperties setObject:table1Data forKey:@"Table 1"];
        
        //add table data to elements array
        [calcElements addObject:@"Facility Type"];
        [calcElements addObject:@"Total number of EUS patients anticipated per week"];
        [calcElements addObject:@"Number of working days per year"];
        [calcElements addObject:@"Anticipated annual increase in EUS caseload"];
        
    } else if (s==2) {
        
        [thisSectionProperties setObject:@"1" forKey:@"Table Count"];
        [thisSectionProperties setObject:@"Operating Cost" forKey:@"Section Title"];
        [thisSectionProperties setObject:@"2, 3, 4, 5" forKey:@"Rows Needing Instructions"];
        
        NSArray* myInstructions = [[NSArray alloc] initWithObjects: stringManager.helpLaborCost, stringManager.helpServiceQuote, stringManager.helpVariableCost, stringManager.helpAdditionalCost, nil];
        [thisSectionProperties setObject:myInstructions forKey:@"Instructions"];
        
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"", @"", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Will the physician performing EUS be facility employed?", @"YES", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Labor costs per case", @"$296", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Annual service cost", @"$15,000", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Variable cost per patient", @"$117", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Additional fixed cost per patient", @"$0", nil]];
        
        [thisSectionProperties setObject:table1Data forKey:@"Table 1"];
        
        //add table data to elements array
        [calcElements addObject:@"Will the physician performing EUS be facility employed?"];
        [calcElements addObject:@"Labor costs per case"];
        [calcElements addObject:@"Annual service cost"];
        [calcElements addObject:@"Variable cost per patient"];
        [calcElements addObject:@"Additional fixed cost per patient"];
        
        
    } else if (s==3) {
        
        [thisSectionProperties setObject:@"1" forKey:@"Table Count"];
        [thisSectionProperties setObject:@"Reimbursement" forKey:@"Section Title"];
        [thisSectionProperties setObject:@"1, 2, 3, 4, 5, 6, 7" forKey:@"Rows Needing Instructions"];
        
        NSArray* myInstructions = [[NSArray alloc] initWithObjects:stringManager.helpMedicareReimbursement, stringManager.helpNonMedicareReimbursement, stringManager.helpMedicareFacilityFee, stringManager.helpNonMedicareFacilityFee, stringManager.helpPhysicianFee, stringManager.helpSecondProvider, stringManager.helpAnasthesiaPayment, nil];
        [thisSectionProperties setObject:myInstructions forKey:@"Instructions"];
        
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"", @"", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Percentage of cases reimbursed through Medicare", @"30%", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Percentage of cases reimbursed through non-Medicare payers", @"70%", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Medicare Facility Fee per case (does not include modifiers)", @"$885", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Non-Medicare Facility Fee per case", @"$974", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Physician Fee per case ", @"$430", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Will a secondary provider deliver anesthesia during EUS cases?", @"YES", nil]];
        
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Anesthesia reimbursement per case (Facility Fee)", @"$108", nil]];
        
        [thisSectionProperties setObject:table1Data forKey:@"Table 1"];
        
        //add table data to elements array
        [calcElements addObject:@"Percentage of cases reimbursed through Medicare"];
        [calcElements addObject:@"Percentage of cases reimbursed through non-Medicare payers"];
        [calcElements addObject:@"Medicare Facility Fee per case (does not include modifiers)"];
        [calcElements addObject:@"Non-Medicare Facility Fee per case"];
        [calcElements addObject:@"Physician Fee per case"];
        [calcElements addObject:@"Will a secondary provider deliver anesthesia during EUS cases?"];
        [calcElements addObject:@"Anesthesia reimbursement per case (Facility Fee)"];
        
    } else if (s==4) {
        
        [thisSectionProperties setObject:@"1" forKey:@"Table Count"];
        [thisSectionProperties setObject:@"Downstream Revenue Model" forKey:@"Section Title"];
        [thisSectionProperties setObject:@"Downstream, or indirect, revenue is revenue that may be generated when a patient requires additional hospital services beyond their initial presentation into the healthcare system. In this case, the EUS procedure is considered the patient’s first point of entry into the hospital. A significant percentage of EUS patients may likely require additional services from the facility, creating an indirect revenue stream that originated within the GI department but benefits the facility as a whole." forKey:@"Section Blurb"];
        [thisSectionProperties setObject:@"1, 2, 3, 4, 5, 6" forKey:@"Rows Needing Instructions"];
        
        NSArray* myInstructions = [[NSArray alloc] initWithObjects:stringManager.helpPathology, stringManager.helpSurgery, stringManager.helpAdmissions, stringManager.helpOncology, stringManager.helpRadiology, stringManager.helpAnesthesia, nil];
        [thisSectionProperties setObject:myInstructions forKey:@"Instructions"];
        
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Department", @"Percent of EUS Cases Utilizing Services of Other Departments", @"Average Medicare Reimbursement", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Pathology", @"35%", @"$146", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Surgery", @"2%", @"$7,214", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Admissions", @"8%", @"$5,631", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Oncology", @"2%", @"$10,388", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Radiology", @"5%", @"$86", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Anesthesia - Non Endoscopy", @"2%", @"$151", nil]];
        [table1Data addObject:[[NSArray alloc] initWithObjects: @"Other", @"0%", @"$0", nil]];
        [thisSectionProperties setObject:table1Data forKey:@"Table 1"];
        
        
        [table2Data addObject:[[NSArray alloc] initWithObjects: @"", @"", nil]];
        [table2Data addObject:[[NSArray alloc] initWithObjects: @"Net profit margin generated from downstream cases", @"30%", nil]];
        //[thisSectionProperties setObject:table2Data forKey:@"Table 2"];
        
        //add table data to elements array
        [calcElements addObject:@"Pathology"];
        [calcElements addObject:@"Surgery"];
        [calcElements addObject:@"Admissions"];
        [calcElements addObject:@"Oncology"];
        [calcElements addObject:@"Radiology"];
        [calcElements addObject:@"Anesthesia - Non Endoscopy"];
        [calcElements addObject:@"Other"];
        [calcElements addObject:@"Net profit margin generated from downstream cases"];
        
    }
    
    return thisSectionProperties;
}

- (void) buildSections : (NSMutableDictionary* ) sectionProperties : (UIView* ) sectionWrapper {
    
    //get section title
    NSString* sectionTitle = [sectionProperties objectForKey:@"Section Title"];
    NSArray* rowsNeedingInstructions = [[sectionProperties objectForKey:@"Rows Needing Instructions"] componentsSeparatedByString: @","];
    NSArray* instructions = [sectionProperties objectForKey:@"Instructions"];
    
    //build the background rows
    CGRect lastTableFrame;
    float rowX = 10.0;
    float rowY = 40.0;
    float maxTableWidth = 0.0;
    float maxLabelWidth = 0.0;
    float thisHeaderRowMaxHeight = 40.0;
    
    //get sectionY
    if ([sectionTitle isEqualToString:@"Equipment"]) {
        
        NSMutableArray* allTables = [[NSMutableArray alloc] init];
        
        //get the table data
        table1StoredData = [sectionProperties objectForKey:@"Table 1"];
        table2StoredData = [sectionProperties objectForKey:@"Table 2"];
        table3StoredData = [sectionProperties objectForKey:@"Table 3"];
        
        [allTables addObject:table1StoredData];
        [allTables addObject:table2StoredData];
        [allTables addObject:table3StoredData];
        
        //get the max table width
        for(int t=0; t<allTables.count; t++) {
            
            NSArray* thisTableData = [allTables objectAtIndex:t];
            
            float tableWidth = [self getTableWidth:thisTableData];
            float thisTableMaxLabelWidth = [self getMaxLabelWidth:thisTableData];
            thisHeaderRowMaxHeight = [self getMaxRowHeight:thisTableData];
            
            if (tableWidth > maxTableWidth) {
                maxTableWidth = tableWidth;
            }
            
            if (thisTableMaxLabelWidth > maxLabelWidth) {
                maxLabelWidth = thisTableMaxLabelWidth;
            }
            
            
        }
        
        //build the table
        for(int t=0; t<allTables.count;t++) {
            
            if (t==0) {
                //get the tablewidth
                lastTableFrame = [self buildFrameAndRows:table1StoredData:maxTableWidth:rowX:rowY:maxLabelWidth:thisHeaderRowMaxHeight:sectionWrapper:sectionTitle:rowsNeedingInstructions:instructions];
                
            } else  {
                
                NSArray* thisTableData = [allTables objectAtIndex:t];
                
                //get the tablewidth
                rowY = lastTableFrame.origin.y + lastTableFrame.size.height + 20.0;
                
                lastTableFrame = [self buildFrameAndRows:thisTableData:maxTableWidth:rowX:rowY:maxLabelWidth:thisHeaderRowMaxHeight:sectionWrapper:sectionTitle:rowsNeedingInstructions:instructions];
            }
        }
        
        if ([sectionTitle isEqualToString:@"Equipment"]) {
            
            UITextView* tvAdditionalEquip = [[UITextView alloc] initWithFrame:CGRectMake(10.0, lastTableFrame.origin.y + lastTableFrame.size.height + 50.0, maxTableWidth, 90.0)];
            tvAdditionalEquip.layer.borderWidth = 1.0;
            tvAdditionalEquip.layer.borderColor = [colorManager setColor:66.0 :66.0 :66.0].CGColor;
            tvAdditionalEquip.layer.cornerRadius = 4.0f;
            tvAdditionalEquip.text = @"Please describe the additional equipment";
            tvAdditionalEquip.textColor = [colorManager setColor:66.0 :66.0 :66.0];
            tvAdditionalEquip.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            tvAdditionalEquip.delegate = self;
            [sectionWrapper addSubview:tvAdditionalEquip];
            
        }
        
    } else {
        
        //get the table data
        table1StoredData = [sectionProperties objectForKey:@"Table 1"];
        
        float tableWidth = [self getTableWidth:table1StoredData];
        float thisTableMaxLabelWidth = [self getMaxLabelWidth:table1StoredData];
        thisHeaderRowMaxHeight = [self getMaxRowHeight:table1StoredData];
        
        
        if (tableWidth > maxTableWidth) {
            maxTableWidth = tableWidth;
        }
        
        if (maxTableWidth > 650.0) {
            maxTableWidth = 650.0;
        }
        
        if (thisTableMaxLabelWidth > maxLabelWidth) {
            maxLabelWidth = thisTableMaxLabelWidth;
        }
        
        rowY=40.0;
        
        lastTableFrame = [self buildFrameAndRows:table1StoredData:maxTableWidth:rowX:rowY:maxLabelWidth:thisHeaderRowMaxHeight:sectionWrapper:sectionTitle:rowsNeedingInstructions:instructions];
        
    }//end sectiontitle check
    
}

#pragma mark - Getting Table Dimensions
- (float) getTableWidth : (NSArray* ) thisTableData {
    
    //set up a starting width;
    float tableWidth = 0.0;
    
    //loop through
    for(int r=0; r<thisTableData.count; r++) {
        
        //get each row
        NSArray* thisTableRowData = [thisTableData objectAtIndex:r];
        
        //set a hold for the row width
        float totalRowWidth = 0.0;
        
        for(int x=0; x<thisTableRowData.count; x++) {
            
            //get the row contents
            NSString* thisRowItem = [thisTableRowData objectAtIndex:x];
            
            //get its size
            CGSize thisRowItemSize = [thisRowItem sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
            
            if (thisRowItemSize.width < 100.0) {
                thisRowItemSize.width = 140.0;
            }
            
            //add it to trw
            totalRowWidth = totalRowWidth + thisRowItemSize.width;
        }
        
        //check to see if the trw > tableWidth
        if (totalRowWidth > tableWidth) {
            tableWidth = totalRowWidth;
        }
        
        //reset totalRowWidth
        totalRowWidth = 0.0;
    }
    
    return tableWidth+20.0;//the 20 is for padding
    
}

- (float) getMaxLabelWidth : (NSArray* ) thisTableData {
    
    float maxWidth = 0.0;
    
    //loop through the table and get each row
    for(int r=0; r<thisTableData.count; r++) {
        
        NSArray* thisRow = [thisTableData objectAtIndex:r];
        
        //loop through the row
        for(int c=0; c<thisRow.count; c++) {
            
            if (c==0) {
                
                NSString* thisCellValue = [thisRow objectAtIndex:c];
                //get the size
                CGSize maximumLabelSize = CGSizeMake(300.0, 9999.0);
                CGSize thisCellValueSize = [thisCellValue sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
                
                if(maxWidth < thisCellValueSize.width) {
                    maxWidth = thisCellValueSize.width;
                }
                
            }
        }
    }
    
    //limit the width to 200.0;
    if (maxWidth > 300.0) {
        maxWidth = 300.0;
    }
    
    return maxWidth;
}

- (float) getMaxRowHeight : (NSArray*) thisTableData {
    
    float maxHeight = 40.0;
    
    for(int r=0; r<thisTableData.count; r++) {
        
        if (r==0) {
            
            NSArray* thisRow = [thisTableData objectAtIndex:r];
            
            for(int c=0; c<thisRow.count; c++) {
                
                NSString* headerLabel = [thisRow objectAtIndex:c];
                //get the size for the wrapped header
                CGSize maximumLabelSize = CGSizeMake(200.0, 9999.0);
                CGSize thisHeaderStrSize = [headerLabel sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
                
                if (thisHeaderStrSize.height > maxHeight) {
                    maxHeight = thisHeaderStrSize.height;
                }
            }
        }
        
    }
    
    return maxHeight;
}

- (CGRect) buildFrameAndRows : (NSArray*) thisTableData : (float) tableWidth : (float) rowX : (float) rowY : (float) col1W : (float) thisHeaderRowMaxHeight : (UIView*) sectionWrapper : (NSString*) thisSection : (NSArray*) rowsNeedingInstructions : (NSArray*) instructions {
    
    //set up some ivars
    float rowW = tableWidth;
    float rowH;
    //these are for returning a table frame
    float tableX;
    float tableY;
    float tableW = tableWidth;
    float tableH = 0.0;
    NSMutableArray* placedHeaders = [[NSMutableArray alloc] init];
    NSMutableArray* placedDataRows = [[NSMutableArray alloc] init];
    NSMutableArray* placedElements = [[NSMutableArray alloc] init];
    UIView* vHeaderRow;
    BOOL needsInstructions;
    int myIndex;
    NSString* myInstructions;
    
    //loop through each row in the table data
    for(int r=0; r<thisTableData.count; r++) {
        
        if (instructions.count > 0) {
            
            for(int i=0; i<rowsNeedingInstructions.count; i++) {
                
                int thisRow = [[rowsNeedingInstructions objectAtIndex:i] intValue];
                
                if (thisRow == r) {
                    
                    myIndex = i;
                    myInstructions = [instructions objectAtIndex:myIndex];
                    needsInstructions = YES;
                }
            }
        } else {
            
            needsInstructions = NO;
        }
        
        //headers
        if (r==0) {
            
            //reset the size of the headerRow to the max height (for word wraps in headers)
            rowH = thisHeaderRowMaxHeight + 4.0;
            
            //set the x/y of the table
            tableX = rowX;
            tableY = rowY;
            
            //increment the tableH
            tableH = tableH + rowH;
            
            //create the header
            vHeaderRow = [[UIView alloc] initWithFrame:CGRectMake(rowX, rowY+40.0, rowW, rowH)];
            vHeaderRow.backgroundColor = [colorManager setColor:8 :16 :123];
            
            //get the headers
            NSArray* headers = [thisTableData objectAtIndex:r];
            
            for(int h=0; h<headers.count; h++) {
                
                //coord vars
                float headerX;
                float headerY = 0.0;
                float headerW;
                float headerH = thisHeaderRowMaxHeight+4.0;//to account for 2 pixels padding top and bottom;
                
                //the header text
                NSString* thisHeaderStr = [headers objectAtIndex:h];
                
                if (![thisHeaderStr isEqualToString:@""]) {
                    
                    if (h==0) {
                        headerX = 5.0;
                        headerW = col1W; //col1W;//to match the widest col1 width of content
                    } else {
                        
                        UILabel* lastHeader = [placedHeaders objectAtIndex:placedHeaders.count-1];
                        headerX = lastHeader.frame.origin.x + lastHeader.frame.size.width + 5.0;
                        
                        //figure out the headerW
                        headerW = (tableWidth - col1W)/(headers.count-1);
                    }
                    
                    UILabel* thisHeader = [[UILabel alloc] initWithFrame:CGRectMake(headerX, headerY, headerW, headerH)];
                    thisHeader.text = thisHeaderStr;
                    thisHeader.textColor = [UIColor whiteColor];
                    thisHeader.backgroundColor = [UIColor clearColor];
                    thisHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
                    
                    //word wrap for cols2 or 3 headers
                    thisHeader.numberOfLines = 0;
                    //[thisHeader sizeToFit];
                    thisHeader.lineBreakMode = NSLineBreakByWordWrapping;
                    
                    [vHeaderRow addSubview:thisHeader];
                    [placedHeaders addObject:thisHeader];
                    
                }
            }
            
            //add the header to the sectionWrapper
            [sectionWrapper addSubview:vHeaderRow];
            
        } else {
            
            //set the rowH
            rowH = 50.0;
            
            //set the rowY
            if (r==1) {
                rowY = vHeaderRow.frame.origin.y + vHeaderRow.frame.size.height;
            } else {
                UIView* lastRow = [placedDataRows objectAtIndex:placedDataRows.count-1];
                rowY = lastRow.frame.origin.y + lastRow.frame.size.height;
            }
            
            //add the next row
            UIView* vDataRow = [[UIView alloc] initWithFrame:CGRectMake(rowX, rowY, rowW, rowH)];
            vDataRow.layer.borderWidth = 1.0;
            vDataRow.layer.borderColor = [colorManager setColor:181 :181 :181].CGColor;
            
            //add the background colors
            if (r%2) {
                vDataRow.backgroundColor = [colorManager setColor: 225:242:249];
            } else {
                vDataRow.backgroundColor = [colorManager setColor: 204:204:204];
            }
            
            //add the row data
            NSArray* thisRowData = [thisTableData objectAtIndex:r];
            
            for(int d=0; d<thisRowData.count; d++) {
                
                //get the data for the cell
                NSString* thisCellData = [thisRowData objectAtIndex:d];
                
                //get the size
                CGSize maximumLabelSize = CGSizeMake(300.0, 9999.0);
                CGSize cellDataSize = [thisCellData sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
                
                //increase row height if text wraps
                if (vDataRow.frame.size.height < cellDataSize.height) {
                    
                    CGRect dataRowFrame = vDataRow.frame;
                    dataRowFrame.size.height = cellDataSize.height + 5.0;
                    
                }
                
                //vars
                float dataX;
                float dataY;
                
                //adjust for line wraps
                if (cellDataSize.height > 22.0) {
                    dataY = 5.0;
                } else {
                    dataY = 10.0;
                }
                
                float dataW;
                float dataH = cellDataSize.height;
                
                //set the x and w
                if (d==0) {
                    dataX = 5.0;
                    dataW = col1W;
                } else {
                    
                    //determine how much room we have for the text field
                    float tableSpaceRemaining = tableW-(col1W-30.0);
                    dataW = tableSpaceRemaining/(thisRowData.count-1)-40;
                    
                    if (dataW > 240.0) {
                        dataW = 240.0;
                    }
                    
                    //set the x location
                    if (d==1) {
                        UILabel* cellLabel = [placedElements objectAtIndex:placedElements.count-1];
                        dataX = cellLabel.frame.origin.x + cellLabel.frame.size.width + 15.0;
                        
                    } else {
                        
                        //need to determine the class of the element
                        UITextField* cellInput = [placedElements objectAtIndex:placedElements.count-1];
                        dataX = cellInput.frame.origin.x + cellInput.frame.size.width + 15.0;
                    }
                    
                    dataH = 35.0;
                    
                }
                
                NSString* thisCellLabel;
                OAI_TextField* txtCellInput;
                
                if (d==0) {
                    
                    //add the row label
                    UILabel* lblCellData = [[UILabel alloc] initWithFrame:CGRectMake(dataX, dataY, dataW, dataH)];
                    lblCellData.text = thisCellData;
                    lblCellData.textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    lblCellData.backgroundColor = [UIColor clearColor];
                    lblCellData.font = [UIFont fontWithName:@"Helvetica" size: 18.0];
                    lblCellData.numberOfLines = 0;
                    lblCellData.lineBreakMode = NSLineBreakByWordWrapping;
                    [vDataRow addSubview:lblCellData];
                    
                    [placedElements addObject:lblCellData];
                    
                } else {
                    
                    thisCellLabel = [thisRowData objectAtIndex:0];
                        
                    txtCellInput = [[OAI_TextField alloc] initWithFrame:CGRectMake(dataX, dataY, dataW, dataH)];
                    txtCellInput.borderStyle = UITextBorderStyleRoundedRect;
                    txtCellInput.text = thisCellData;
                    txtCellInput.backgroundColor = [UIColor whiteColor];
                    txtCellInput.textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    txtCellInput.delegate = self;
                    
                    //get the label for this element row
                    if (d==1) {
                        UILabel*  lblRowLabel = [placedElements objectAtIndex:placedElements.count-1];
                        NSString* myRowLabel = lblRowLabel.text;
                        txtCellInput.elementName = [NSString stringWithFormat:@"%@_1", myRowLabel];
                    } else {
                        UILabel* lblRowLabel = [placedElements objectAtIndex:placedElements.count-2];
                        NSString* myRowLabel = lblRowLabel.text;
                        txtCellInput.elementName = [NSString stringWithFormat:@"%@_2", myRowLabel];
                    }
                    
                    //check to see if the initial textfield requires a number type of $ or % or just a string - we need this for display and validation purposes
                    NSRange dollarSignCheck = [thisCellData rangeOfString:@"$"];
                    if (dollarSignCheck.location != NSNotFound) {
                        txtCellInput.elementNumberType = @"Dollar";
                    }
                    
                    NSRange percentSignCheck = [thisCellData rangeOfString:@"%"];
                    if (percentSignCheck.location !=NSNotFound) {
                        txtCellInput.elementNumberType = @"Percentage";
                    }
                    
                    //set up special cases where the number is just a number
                    if ([thisSection isEqualToString:@"Equipment"]) {
                        
                        if (!txtCellInput.elementNumberType) {
                            txtCellInput.elementNumberType = @"Number";
                        }
                            
                    } else if ([thisSection isEqualToString:@"Expected Case Volume"]) {
                        
                        if (r>1 && r<thisTableData.count-1) {
                            txtCellInput.elementNumberType = @"Number";
                        }
                    }
                    
                    //assign string to everything else
                    if (!txtCellInput.elementNumberType) {
                        txtCellInput.elementNumberType = @"String";
                    }
                    
                                        
                    [vDataRow addSubview:txtCellInput];
                    
                    [placedElements addObject:txtCellInput];
                        
                    }
                
                if ([thisCellLabel isEqualToString:@"Facility Type"]) {
                    
                    //this is the array for the table in the popovercontroller
                    thisCellTableItems = [[NSMutableArray alloc] init];
                    for(int x=1; x<thisRowData.count; x++) {
                        [thisCellTableItems addObject:[thisRowData objectAtIndex:x]];
                    }
                    
                    txtCellInput.tag = 300;
                    
                    //add an action on editing to open the popovercontroller
                    //[txtCellInput addTarget:self action:@selector(openHospitalDropDown:) forControlEvents:UIControlEventEditingDidBegin];
                    
                    //wipe out the content
                    txtCellInput.text = @"";
                    
                    //add a placeholder
                    txtCellInput.placeholder = @"Click to select a facility.";
                    
                    //reset the width
                    CGRect txtCellInputFrame = txtCellInput.frame;
                    txtCellInputFrame.size.width = 240.0;
                    txtCellInput.frame = txtCellInputFrame;
                    
                    //break out of the array loop, the other items are the contents of the table in the popovercontroller, which we collected above.
                    break;

                }
                
                //set instruction button
                if (needsInstructions == YES) {
                    
                    UIImage* imgInfoLight = [UIImage imageNamed:@"infoBtnLight.png"];
                    UIImage* imgInfoRed = [UIImage imageNamed:@"btnInfoRed.png"];
                    
                    //OAI_InfoButton* btnInfo = [OAI_InfoButton buttonWithType:UIButtonTypeInfoDark];
                    OAI_InfoButton* btnInfo = [[OAI_InfoButton alloc] init];
                    [btnInfo setImage:imgInfoLight forState:UIControlStateNormal];
                    [btnInfo setImage:imgInfoRed forState:UIControlStateHighlighted];
                    [btnInfo addTarget:self action:@selector(showInstructions:) forControlEvents:UIControlEventTouchUpInside];
                    
                    btnInfo.strInfo = myInstructions;
                    
                    CGRect btnInfoFrame = btnInfo.frame;
                    btnInfoFrame.origin.x = tableW + 10.0;
                    btnInfoFrame.origin.y = rowY + 5.0;
                    btnInfoFrame.size.width = 30.0;
                    btnInfoFrame.size.height = 30.0;
                    btnInfo.frame = btnInfoFrame;
                    
                    [sectionWrapper addSubview:btnInfo];
                    
                }
                
                
            }
            
            //add the net profit entry on the downstream model section
            if(r==thisTableData.count-1) {
                
                if ([thisSection isEqualToString:@"Downstream Revenue Model"]) {
                    
                    float objX = 0.0;
                    float objY = vDataRow.frame.origin.y + vDataRow.frame.size.height + 10.0;
                    
                    NSString* strProfitMargin = @"Net profit margin generated from downstream cases:";
                    CGSize strProfitMarginSize = [strProfitMargin sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
                    
                    UILabel* lblProfitMargin = [[UILabel alloc] initWithFrame:CGRectMake(objX, objY, strProfitMarginSize.width, strProfitMarginSize.height)];
                    lblProfitMargin.text = strProfitMargin;
                    lblProfitMargin.textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    lblProfitMargin.backgroundColor = [UIColor clearColor];
                    lblProfitMargin.font = [UIFont fontWithName:@"Helvetica" size:18.0];
                    
                    [sectionWrapper addSubview:lblProfitMargin];
                    
                    OAI_TextField* txtProfitMargin = [[OAI_TextField alloc] initWithFrame:CGRectMake(lblProfitMargin.frame.origin.x + lblProfitMargin.frame.size.width + 20, lblProfitMargin.frame.origin.y, 100.0, 30.0)];
                    txtProfitMargin.text = @"30%";
                    txtProfitMargin.elementName = @"Net profit margin generated from downstream cases_1";
                    txtProfitMargin.elementNumberType = @"Percent";
                    
                    [sectionWrapper addSubview:txtProfitMargin];
                    
                    
                }
            }
            
            
            //increment the tableH
            tableH = tableH + rowH;
            
            //add this row to placedDataRows array
            [placedDataRows addObject:vDataRow];
            
            //add the header to the sectionWrapper
            [sectionWrapper addSubview:vDataRow];
            
            //reset needsInstructions
            needsInstructions = NO;
            
        }
    }
    
    
    CGRect lastTableFrame = CGRectMake(tableX, tableY, tableW, tableH);
    return lastTableFrame;
    
}

- (float) getMaxResultsCol1Width : (NSArray*) col1Items {
    
    float maxWidth = 0.0;
    
    for(int i=0; i<col1Items.count; i++) {
        
        NSString* thisItem = [col1Items objectAtIndex:i];
        
        CGSize maximumLabelSize = CGSizeMake(300,9999);
        CGSize thisItemSize = [thisItem sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        
        if (thisItemSize.width > maxWidth) {
            maxWidth = thisItemSize.width;
        }
    }
    
    if (maxWidth < 180.0) {
        maxWidth = 180.0;
    }
    
    return maxWidth;
}

- (NSMutableArray*) addResultsHeaders : (UIView*) headerParent : (NSArray*) headers : (float) maxCol1Width {
    
    //build the headers
    float headerX = 1.0;
    float headerY = 0.0;
    float headerW = maxCol1Width + .5;
    float headerH = 0.0;
    
    NSMutableArray* placedHeaders = [[NSMutableArray alloc] init];
    NSMutableArray* rowHeadersWidth = [[NSMutableArray alloc] init];
    
    //place the table1Headers
    for (int h=0; h<headers.count; h++) {
        
        NSString* strHeader = [headers objectAtIndex:h];
        
        CGSize maximumLabelSize = CGSizeMake(60,9999);
        CGSize strHeaderSize = [strHeader sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        
        headerH = strHeaderSize.height;
        
        if (h>0) {
            
            float remainingWidth = (headerParent.frame.size.width - maxCol1Width);
            
            headerW = (remainingWidth/(headers.count-1));
            
            UILabel* lastHeader = [placedHeaders objectAtIndex:placedHeaders.count-1];
            headerX = lastHeader.frame.origin.x + lastHeader.frame.size.width;
            
        }
        
        UILabel* lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(headerX, headerY, headerW, 40.0)];
        lblHeader.text = strHeader;
        lblHeader.layer.borderWidth = 1.0;
        
        lblHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        
        if (headerParent.tag == 201) {
            lblHeader.backgroundColor = [colorManager setColor:186.0 :209.0 :254.0];
            lblHeader.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        } else if (headerParent.tag == 202) {
            lblHeader.backgroundColor = [colorManager setColor:110.0 :107.0 :88.0];
            lblHeader.textColor = [UIColor whiteColor];
        } else if (headerParent.tag == 203) {
            lblHeader.backgroundColor = [colorManager setColor:99.0 :99.0 :99.0];
            lblHeader.textColor = [UIColor whiteColor];
        }
        
        lblHeader.textAlignment = NSTextAlignmentCenter;
        lblHeader.numberOfLines = 0;
        lblHeader.lineBreakMode = NSLineBreakByWordWrapping;
        
        [placedHeaders addObject:lblHeader];
        
        [headerParent addSubview:lblHeader];
        
        [rowHeadersWidth addObject:[NSString stringWithFormat:@"%f", lblHeader.frame.size.width]];
        
    }
    
    return rowHeadersWidth;
    
}

- (void) addResultsRows : (UIView*) rowParent : (NSArray*) rowNames : (float) maxCol1Width : (int) colCount : (NSArray*) rowHeaderWidths {
    
    float rowX = 1.0;
    float rowY = 40.0;
    float rowW = rowParent.frame.size.width;
    float rowH = 40.0;
    
    NSMutableArray* placedResultRows = [[NSMutableArray alloc] init];
    NSMutableArray* placedRowItem = [[NSMutableArray alloc] init];
    
    for(int r=0; r<rowNames.count; r++) {
        
        NSString* strRowName = [rowNames objectAtIndex:r];
        //set the row height
        CGSize maximumLabelSize = CGSizeMake(maxCol1Width,9999);
        CGSize szLabel = [strRowName sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20]
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:NSLineBreakByWordWrapping
                          ];
        
        if (szLabel.height > rowH) {
            rowH = szLabel.height;
        }
        
        //get the last row added
        if (r>0) {
            
            UIView* lastRow = [placedResultRows objectAtIndex:placedResultRows.count-1];
            rowY = lastRow.frame.origin.y + lastRow.frame.size.height;
        }
        
        //add the row
        UIView* thisRow = [[UIView alloc] initWithFrame:CGRectMake(rowX, rowY, rowW, rowH)];
        
        //add a background color
        if (r%2) {
            thisRow.backgroundColor = [colorManager setColor: 204.0:204.0:204.0];
        } else {
            if (rowParent.tag == 101) {
                thisRow.backgroundColor = [colorManager setColor:219 :243 :252];
            } else if (rowParent.tag == 102) {
                thisRow.backgroundColor = [colorManager setColor:252.0 :252.0 :212.0];
            } else {
                thisRow.backgroundColor = [UIColor whiteColor];
            }
        }
        
        
        //add the row to the placedRows array
        [placedResultRows addObject:thisRow];
        
        //set up coords for columns
        float colX = 0.0;
        float colY = 0.0;
        float colW = 0.0;
        float colH = rowH;
        
        //loop through colCount
        for(int c=0; c<colCount; c++) {
            
            //set up the x/y w/h for each col
            if (c==0) {
                colW = maxCol1Width+1;
            } else {
                
                UIView* lastWrapper = [placedRowItem objectAtIndex:placedRowItem.count-1];
                
                //tweaking the col widths - this is hack but I don't have time to mess with it
                colX = lastWrapper.frame.origin.x + lastWrapper.frame.size.width;
                if (c==1) { 
                    colW = [[rowHeaderWidths objectAtIndex:1] floatValue]-1.0;
                } else {
                    colW = [[rowHeaderWidths objectAtIndex:1] floatValue]+1.0;
                }
                    
            }
            
            //build a column wrapper
            UIView* colWrapper = [[UIView alloc] initWithFrame:CGRectMake(colX, colY, colW, colH)];
            colWrapper.layer.borderWidth = 1.0;
            
            //set the width of the data
            float dataW = 0.0;
            if (c==0) {
                dataW = 100.0;
            } else {
                dataW = colW;
            }
            
            //add a label to hold the data
            
            
            OAI_Label* lblColData = [[OAI_Label alloc] initWithFrame:CGRectMake(5.0, 0.0, 180.0, rowH)];
            
            if (c==0) {
                lblColData.labelID = [NSString stringWithFormat:@"%@_Col1", strRowName];
            } else {
                lblColData.labelID = [NSString stringWithFormat:@"%@_Col%i", strRowName, c+1];
            }
            
            //display 1st row text, add the other labels to the resultsFields array
            if (c==0) {
                
                //add the row title
                lblColData.text = strRowName;
                
                //add background color to the divider row
                if ([allTrim(strRowName) length] == 0 ) {
                    
                    //reset the frame
                    CGRect lblColFrame = lblColData.frame;
                    lblColFrame.origin.x = 0.0;
                    lblColFrame.size.width = maxCol1Width;
                    lblColData.frame = lblColFrame;
                    
                    lblColData.backgroundColor = [colorManager setColor:99.0 :99.0 :99.0];
                }
                
            } else {
                
                
                //if the row header is blank, it's the divider and we are going to add Year 1, 2, 3 to the adjacent cells
                if ([allTrim(strRowName) length] == 0 ) {
                    
                    //reset the frame
                    CGRect lblColFrame = lblColData.frame;
                    lblColFrame.origin.x = 0.0;
                    lblColData.frame = lblColFrame;
                    
                    NSString* thisCellLabel = [NSString stringWithFormat:@"Year %i", c];
                    lblColData.text = [NSString stringWithFormat:@" %@", thisCellLabel];
                    lblColData.backgroundColor = [colorManager setColor:99.0 :99.0 :99.0];
                    lblColData.textColor = [UIColor whiteColor];
                    
                }
                
                
                [resultsFields addObject:lblColData];
                
            }
            
            lblColData.textColor = [colorManager setColor:66.0 :66.0 :66.0];
            
            if ([strRowName isEqualToString:@"Revenue"] || [strRowName isEqualToString:@"Expenditure"]) {
                lblColData.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
                lblColData.textColor = [colorManager setColor:8 :16 :123];
            } else {
                lblColData.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            }
            
            [colWrapper addSubview:lblColData];
            
            [thisRow addSubview:colWrapper];
            [placedRowItem addObject:colWrapper];
            
        }
        
        //add the row to the parent view
        [rowParent addSubview:thisRow];
        
    }
    
}

- (float) getTableHeight : (UIView*) thisTable {
    
    NSArray* tableSubViews = thisTable.subviews;
    float totalHeight = 0.0;
    
    for(int i=0; i<tableSubViews.count; i++) {
        
        UIView* thisView = [tableSubViews objectAtIndex:i];
        CGRect thisViewFrame = thisView.frame;
        float thisViewHeight = thisViewFrame.size.height;
        totalHeight = totalHeight + thisViewHeight;
    }
    
    return totalHeight;
}


#pragma mark - Show Views
- (void) showView : (UIButton* ) buttonTouched {
    
    [self clearDeck];
    
    UIView* viewToShow;
    UIView* viewToHide;
    
    if (buttonTouched.tag == 10) {
        viewToShow = vSummaryScreen;
        viewToHide = vCalculator;
    } else {
        viewToShow = vCalculator;
        viewToHide = vSummaryScreen;
    }
    
    
    [self toggleViews:viewToShow:viewToHide];
    
}

- (void) showInstructions : (OAI_InfoButton*) btnInfo  {
    
    //set a float for the view height
    float viewH = 0.0;
    
    //get the instructions and their size
    NSString* theseInstructions = btnInfo.strInfo;
    CGSize theseInstSize = [theseInstructions sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
    
    //build a label to hold them
    UILabel* lblInstructions = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, vInstructions.frame.size.width-20.0, theseInstSize.height + 10.0)];
    lblInstructions.text = btnInfo.strInfo;
    lblInstructions.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblInstructions.backgroundColor = [UIColor clearColor];
    lblInstructions.numberOfLines = 0;
    lblInstructions.lineBreakMode = NSLineBreakByWordWrapping;
    [lblInstructions sizeToFit];
    [vInstructions addSubview:lblInstructions];
    
    viewH = viewH + lblInstructions.frame.origin.y + lblInstructions.frame.size.height;
    
    //add a close button
    UIImage* imgCloseNormal = [UIImage imageNamed:@"btnCloseNormal.png"];
    UIImage* imgCloseHightlight = [UIImage imageNamed:@"btnCloseHighlight.png"];
    CGSize imgCloseSize = imgCloseNormal.size;
    
    UIButton* btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect btnCloseFrame = btnClose.frame;
    btnCloseFrame.origin.x = (vInstructions.frame.size.width/2)-(imgCloseSize.width/2);
    btnCloseFrame.origin.y = lblInstructions.frame.origin.y + lblInstructions.frame.size.height + 10.0;
    btnCloseFrame.size.width = imgCloseSize.width;
    btnCloseFrame.size.height = imgCloseSize.height;
    btnClose.frame = btnCloseFrame;
    
    [btnClose setImage:imgCloseNormal forState:UIControlStateNormal];
    [btnClose setImage:imgCloseHightlight forState:UIControlStateHighlighted];
    [btnClose addTarget:self action:@selector(closeInstructions:) forControlEvents:UIControlEventTouchUpInside];
    
    [vInstructions addSubview:btnClose];
    
    //increment height of frame
    viewH = viewH + btnClose.frame.origin.y + btnClose.frame.size.height;
    
    //reset vInstructions frame
    CGRect vInstructionsFrame = vInstructions.frame;
    vInstructionsFrame.size.height = viewH-20.0;
    vInstructions.frame = vInstructionsFrame;
    
    //bring to front
    [vCalculator bringSubviewToFront:vInstructions];
    
    //fade in
    [UIView animateWithDuration:.05 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         vInstructions.alpha = 1.0;
                     }
     
                     completion:^ (BOOL finished) {
                         nil;
                     }
     ];
    
    
}

- (void) closeInstructions : (UIButton*) btnClose {
    
    //fade out
    [UIView animateWithDuration:.05 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         vInstructions.alpha = 0.0;
                     }
     
                     completion:^ (BOOL finished) {
                         
                         //remove the subviews
                         NSArray* vInstructionsSubs = vInstructions.subviews;
                         
                         for(int v=0; v<vInstructionsSubs.count; v++) {
                             
                             UIView* thisView = [vInstructionsSubs objectAtIndex:v];
                             [thisView removeFromSuperview];
                         }
                         
                         //send view to back
                         [vCalculator sendSubviewToBack:vInstructions];
                     }
     ];
    
    
}

- (void) openHospitalDropDown : (UITextField*) txtOpenDropDown {
    
    if (dropDownManager == nil) {
        
        dropDownManager = [[OAI_DropDownTable alloc] initWithStyle:UITableViewStylePlain];
        dropDownManager.delegate = self;
        dropDownManager.tableItemList = thisCellTableItems;
        pvFacilities = [[UIPopoverController alloc] initWithContentViewController:dropDownManager];
        dropDownManager.myPopoverController = pvFacilities;
    }
    
    CGRect popOverLauncher = txtOpenDropDown.frame;
    [pvFacilities presentPopoverFromRect:popOverLauncher inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void)itemSelected:(NSString *)thisItem {
    
    strThisFacility = thisItem;
    myTextElement.text = strThisFacility;
}



#pragma mark - Toggle Views
- (void) toggleViews : (UIView*) viewToShow : (UIView*) viewToHide {
    
    CGRect viewToShowFrame = viewToShow.frame;
    CGRect viewToHideFrame = viewToHide.frame;
    
    if (viewToShow.tag == 102) {
        
        if (viewToShowFrame.origin.x < 0.0) {
            viewToShowFrame.origin.x = 0.0;
        }
        
        if (viewToHideFrame.origin.x == 0.0) {
            viewToHideFrame.origin.x = self.view.frame.size.width;
        }
        
    } else if (viewToShow.tag == 103) {
        
        if (viewToShowFrame.origin.x >= self.view.frame.size.width) {
            viewToShowFrame.origin.x = 0.0;
        }
        
        if (viewToHideFrame.origin.x == 0.0) {
            viewToHideFrame.origin.x = 0.0-viewToHideFrame.size.width;
        }
        
    }
    
    [self animateView:viewToHide :viewToHideFrame];
    [self animateView:viewToShow :viewToShowFrame];
    
}

- (void) toggleAccount : (UIButton*) btnAccount {
    
    BOOL isShowing = NO;
    
    //reset the frame
    CGRect vAccountFrame = vAccount.frame;
    if (vAccountFrame.origin.y < 0) {
        vAccountFrame.origin.y = 39.0;
        isShowing = YES;
    } else {
        vAccountFrame.origin.y = -350.0;
        isShowing = NO;
    }
    
    //if being displayed get the stored data and display it
    if (isShowing) {
       
        NSString* strAccountPlist = @"UserAccount.plist";
        NSDictionary* dictAccountData = [fileManager readPlist:strAccountPlist];
        
        //set strings to the data
        NSString* strUserName = [dictAccountData objectForKey:@"User Name"];
        NSString* strUserTitle = [dictAccountData objectForKey:@"User Title"];
        NSString* strUserEmail = [dictAccountData objectForKey:@"User Email"];
        NSString* strUserPhone = [dictAccountData objectForKey:@"User Phone"];
        
        //get the subviews
        NSArray* vAccountSubs = vAccount.subviews;
        
        //loop
        for(int i=0; i<vAccountSubs.count; i++) {
            
            //sniff for text fields
            if ([[vAccountSubs objectAtIndex:i] isMemberOfClass:[UITextField class]]) {
                
                //cast
                UITextField* thisTextField = (UITextField*)[vAccountSubs objectAtIndex:i];
                
                //set contents of text field
                if (thisTextField.tag == 601) {
                    thisTextField.text = strUserName;
                } else if (thisTextField.tag == 602) {
                    thisTextField.text = strUserTitle;
                } else if (thisTextField.tag == 603) {
                    thisTextField.text = strUserEmail;
                } else if (thisTextField.tag == 604) {
                    thisTextField.text = strUserPhone;
                }
                
            }
        }
        
    }
    
    [self animateView:vAccount :vAccountFrame];
}

- (void) clearDeck {
    
    //get all the subviews
    NSArray* mySubViews = self.view.subviews;
    
    //loop
    for(UIView* thisSubView in mySubViews) {
        
        //find the objectWrapper and set alpha to 0.0
        if (thisSubView.tag == 101) {
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
             
                             animations:^{
                                 thisSubView.alpha = 0.0;
                             }
             
                             completion:^ (BOOL finished) {
                             }
             ];
        }
    }
}

- (void) animateView : (UIView* ) thisView : (CGRect) thisFrame {
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         thisView.frame = thisFrame;
                     }
     
                     completion:^ (BOOL finished) {
                         
                         if (thisView.tag == 102) {
                             
                             NSArray* thisViewSubViews = thisView.subviews;
                             
                             for(int v=0; v<thisViewSubViews.count; v++) {
                                 
                                 if([[thisViewSubViews objectAtIndex:v] isMemberOfClass:[UITextView class]]) {
                                     
                                     UITextView* thisTextView = (UITextView*)[thisViewSubViews objectAtIndex:v];
                                     CGRect textViewFrame = thisTextView.frame;
                                     textViewFrame.size.height = textViewFrame.size.height + 1.0;
                                     thisTextView.frame = textViewFrame;
                                     
                                 }
                             }
                             
                         }
                     }
     ];
    
}

#pragma mark - ScrollView Methods
- (void) setScrollViewHeight : (UIScrollView* ) thisScrollView {
    
    CGFloat scrollViewHeight = 0.0f;
    thisScrollView.showsHorizontalScrollIndicator = NO;
    thisScrollView.showsVerticalScrollIndicator = NO;
    
    for (UIView* view in thisScrollView.subviews) {
        
        if (!view.hidden) {
            CGFloat y = view.frame.origin.y;
            CGFloat h = view.frame.size.height;
            if (y + h > scrollViewHeight)
            {
                scrollViewHeight = h + y;
            }
        }
    }
    thisScrollView.showsHorizontalScrollIndicator = YES;
    thisScrollView.showsVerticalScrollIndicator = YES;
    
    [thisScrollView setContentSize:(CGSizeMake(thisScrollView.frame.size.width, scrollViewHeight))];
}

- (void) scrollToView : (UISegmentedControl*) control {
    
    //get the selected index from the segemented control
    int selectedIndex = control.selectedSegmentIndex + 1;
    
    //set up a point
    float pageX = selectedIndex * 768.0;
    float pageY = 0.0;
    CGPoint scrollOffset = CGPointMake(pageX, pageY);
    
    //reset the my origi offset (so when keyboard is dismissed scroll remains on page)
    myScrollViewOrigiOffSet = scrollOffset;
    
    //move the scroll offset to that point
    [svCalculatorScroll setContentOffset:scrollOffset animated:YES];
    
}

#pragma mark - Text View/Field Delegate Methods


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    myTextElement = textField;
    
    if (textField.tag == 300) {
        [textField resignFirstResponder];
        [self openHospitalDropDown:textField];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //trapping for account info text fields
    if (textField.tag > 600 && textField.tag < 605) {
    
        //set some ivars
        NSString* strAccountPlist = @"UserAccount.plist";
        NSMutableDictionary* dictAccountData = [[NSMutableDictionary alloc] init];
        
        //get all the text fields
        NSArray* arrAccountSubviews = vAccount.subviews;
        
        //loop through elements of vAccount
        for(int i=0; i<arrAccountSubviews.count; i++) {
            
            //sniff for textfields
            if ([[arrAccountSubviews objectAtIndex:i] isMemberOfClass:[UITextField class]]) {
                
                //cast to textfield
                UITextField* thisTextField = (UITextField*)[arrAccountSubviews objectAtIndex:i];
                
                //check which textfield we captured and then dump data into dictionary
                if (thisTextField.text != nil) {
                    if (thisTextField.tag == 601) {
                        [dictAccountData setObject:thisTextField.text forKey:@"User Name"];
                    } else if (thisTextField.tag == 602) {
                        [dictAccountData setObject:thisTextField.text forKey:@"User Title"];
                    } else if (thisTextField.tag == 603) {
                        [dictAccountData setObject:thisTextField.text forKey:@"User Email"];
                    } else if (thisTextField.tag == 604) {
                        [dictAccountData setObject:thisTextField.text forKey:@"User Phone"];
                    }
                }
            }
        }
        
        //create the plist if we need to
        [fileManager createPlist:strAccountPlist];
        
        [fileManager writeToPlist:strAccountPlist :dictAccountData];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    return YES;
}

#pragma mark - Keyboard Methods
- (void) keyboardDidShow:(NSNotification*)notification {
    
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
    
    myKeyboardFrame = keyboardFrameConverted;
    
    [self checkKeyboardConflict];
}

-(void)keyboardWillHide:(NSNotification*)notification{
    
    [svCalculatorScroll setContentOffset:myScrollViewOrigiOffSet animated:YES];
}

- (void) checkKeyboardConflict {
    
    CGPoint checkPoint = [myTextElement.superview convertPoint:myTextElement.frame.origin toView:nil];
    
    if (checkPoint.y > myKeyboardFrame.origin.y) {
        
        //get the difference between the two origins
        float objDiff = (myTextElement.frame.origin.y - myKeyboardFrame.origin.y) + (myTextElement.frame.size.height + 150.0);
        
        //scroll view frame
        CGPoint svOffSet = CGPointMake(myScrollViewOrigiOffSet.x, 0+objDiff);
        
        [svCalculatorScroll setContentOffset:svOffSet animated:YES];
    }
}

#pragma mark - Segmented Control Methods
- (void) resizeSegmentedControlSegments {
    
    NSArray* segments = scCalculatorSections.subviews;
    
    //loop
    for(int i=0; i<segments.count; i++) {
        
        //get the segment
        UIView* aSegment = [segments objectAtIndex:i];
        //get the segment subviews
        NSArray* aSegmentSubviews = aSegment.subviews;
        
        //loop
        for(UILabel* segmentLabel in aSegmentSubviews) {
            
            //make sure it is a UILabel
            if ([segmentLabel isKindOfClass:[UILabel class]]) {
                
                //get the text value
                NSString* segmentText = segmentLabel.text;
                
                CGSize segmentTextSize = [segmentText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
                
                [scCalculatorSections setWidth:segmentTextSize.width-5.0 forSegmentAtIndex:i];
                
            }
        }
        
    }
    
}

#pragma mark - Calculator Methods

- (void) calculate {
    
    /*****************************
     GATHER DATA
     *****************************/
    
    //validate data
    BOOL isValidData = YES;
    NSMutableString* strErrorMsg = [[NSMutableString alloc] init];
    
    NSMutableDictionary* dataElements = [dataManager getDataSources:svCalculatorScroll];
    
    //get the dynamic variables
    
    if ([scCalcOptions selectedSegmentIndex] == 1) {
        isCashOutlay = NO;
    }
        
    //check to see if the user selected a facility
    if (!strThisFacility) {
        isValidData = NO;
        [strErrorMsg appendFormat:@"You did not select a facility."];
    }
            
    //loop through all the elements
    for(NSString* thisKey in dataElements) {
        
        NSDictionary* thisDataSet = [dataElements objectForKey:thisKey];
        
        //get the number type and the value
        NSString* thisElementType = [thisDataSet objectForKey:@"Element Number Type"];
        NSString* thisElementValue = [thisDataSet objectForKey:@"Element Value"];
        
        //check value against number type
        if (![thisElementType isEqualToString:@"String"]) {
            
            //strip away $ and % signs
            NSString * thisElementCleanedValue = [thisElementValue stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [thisElementValue length])];
            NSNumberFormatter *myNumberFormatter = [[NSNumberFormatter alloc] init];
            
            //check to make sure we the required entry
            if ([myNumberFormatter numberFromString:thisElementCleanedValue] == nil) {
                isValidData = NO;
                [strErrorMsg appendString:[NSString stringWithFormat:@"You must enter a %@ value for this entry: %@\n\n", [thisElementType lowercaseString], [thisKey substringWithRange:NSMakeRange(0, [thisKey rangeOfString:@"_"].location)]]];
                
            }
            
        } else {
            
            if([thisElementValue isEqualToString:@""]) {
                isValidData = NO;
                [strErrorMsg appendString:[NSString stringWithFormat:@"You must provide an answer for %@\n\n", [thisKey substringWithRange:NSMakeRange(0, [thisKey rangeOfString:@"_"].location)]]];
            }
            
        }
        
    }
    
    if(!isValidData) {
        
        alertManager.closeAction = @"Do Nothing";
        [alertManager showAlert:strErrorMsg];
        
    } else {
        
                
        //*********get number of patients per week***************//
        NSDictionary* dataSet_EstimatedPatients = [dataElements objectForKey:@"Total number of EUS patients anticipated per week_1"];
        float patientsPerWeekYear1 = [[dataSet_EstimatedPatients objectForKey:@"Element Value"] floatValue];
        float patientsPerWeekYear2 = patientsPerWeekYear1 + (patientsPerWeekYear1*.10);
        float patientsPerWeekYear3 = patientsPerWeekYear2 + (patientsPerWeekYear2*.10);
        
        //convert to string
        NSString* strPatientsPerWeekYear1 = [self convertFloatToDisplayString:patientsPerWeekYear1];
        NSString* strPatientsPerWeekYear2 = [self convertFloatToDisplayString:patientsPerWeekYear2];
        NSString* strPatientsPerWeekYear3 = [self convertFloatToDisplayString:patientsPerWeekYear3];
        
        //add to results dictionary
        [results setObject:[NSString stringWithFormat:@"%@", strPatientsPerWeekYear1] forKey:@"Weekly Patients Year 1"];
        [results setObject:[NSString stringWithFormat:@"%@", strPatientsPerWeekYear2] forKey:@"Weekly Patients Year 2"];
        [results setObject:[NSString stringWithFormat:@"%@", strPatientsPerWeekYear3] forKey:@"Weekly Patients Year 3"];
        
        //*********get the number of patients per year***************//
        NSDictionary* dataSet_WorkingDays = [dataElements objectForKey:@"Number of working days per year_1"];
        float workingDays = [[dataSet_WorkingDays objectForKey:@"Element Value"] floatValue];
        
        float patientsAnnualYear1 = roundf(patientsPerWeekYear1 * (workingDays/5));
        float patientsAnnualYear2 = roundf(patientsPerWeekYear2 * (workingDays/5));
        float patientsAnnualYear3 = roundf(patientsPerWeekYear3 * (workingDays/5));
        
        NSString* strPatientsAnnualYear1 = [self convertFloatToDisplayString:patientsAnnualYear1];
        NSString* strPatientsAnnualYear2 = [self convertFloatToDisplayString:patientsAnnualYear2];
        NSString* strPatientsAnnualYear3 = [self convertFloatToDisplayString:patientsAnnualYear3];
        
        //add to results dictionary
        [results setObject:[NSString stringWithFormat:@"%@", strPatientsAnnualYear1] forKey:@"Annual Patients Year 1"];
        [results setObject:[NSString stringWithFormat:@"%@", strPatientsAnnualYear2] forKey:@"Annual Patients Year 2"];
        [results setObject:[NSString stringWithFormat:@"%@", strPatientsAnnualYear3] forKey:@"Annual Patients Year 3"];
        
        //*********get department percentages and values**********//
        
        /*********************Pathology*************************/
        
        NSDictionary* dataSet_PathologyPercentage = [dataElements objectForKey:@"Pathology_1"];
        NSDictionary* dataSet_PathologyValue = [dataElements objectForKey:@"Pathology_2"];
        
        //clean up symbols
        NSString* strPathologyPercentage = [self stripNonNumericCharacters:[dataSet_PathologyPercentage objectForKey:@"Element Value"]];
        NSString* strPathologyValue = [self stripNonNumericCharacters:[dataSet_PathologyValue objectForKey:@"Element Value"]];
        
        NSArray* pathologyMultipliers = [[NSArray alloc] initWithObjects:strPathologyPercentage, strPathologyValue, nil];
        NSDecimalNumber* decPathologyCostYear1 = [self getProductByPercentage:pathologyMultipliers:patientsAnnualYear1];
        NSDecimalNumber* decPathologyCostYear2 = [self getProductByPercentage:pathologyMultipliers:patientsAnnualYear2];
        NSDecimalNumber* decPathologyCostYear3 = [self getProductByPercentage:pathologyMultipliers:patientsAnnualYear3];
        
        //add to results dictionary
        [results setObject:[dataSet_PathologyPercentage objectForKey:@"Element Value"] forKey:@"Pathology Percentage"];
        [results setObject:[dataSet_PathologyValue objectForKey:@"Element Value"] forKey:@"Pathology Value"];
        
        /***************************Surgery*************************************/
        
        NSDictionary* dataSet_SurgeryPercentage = [dataElements objectForKey:@"Surgery_1"];
        NSDictionary* dataSet_SurgeryValue = [dataElements objectForKey:@"Surgery_2"];
        
        //clean up symbols
        NSString* strSurgeryPercentage = [self stripNonNumericCharacters:[dataSet_SurgeryPercentage objectForKey:@"Element Value"]];
        NSString* strSurgeryValue = [self stripNonNumericCharacters:[dataSet_SurgeryValue objectForKey:@"Element Value"]];
        
        NSArray* surgeryMultipliers = [[NSArray alloc] initWithObjects:strSurgeryPercentage, strSurgeryValue, nil];
        NSDecimalNumber* decSurgeryCostYear1 = [self getProductByPercentage:surgeryMultipliers:patientsAnnualYear1];
        NSDecimalNumber* decSurgeryCostYear2 = [self getProductByPercentage:surgeryMultipliers:patientsAnnualYear2];
        NSDecimalNumber* decSurgeryCostYear3 = [self getProductByPercentage:surgeryMultipliers:patientsAnnualYear3];
        
        //add to results dictionary
        [results setObject:[dataSet_SurgeryPercentage objectForKey:@"Element Value"] forKey:@"Surgery Percentage"];
        [results setObject:[dataSet_SurgeryValue objectForKey:@"Element Value"] forKey:@"Surgery Value"];
        
        /***************************Admissions*************************************/
        
        NSDictionary* dataSet_AdmissionsPercentage = [dataElements objectForKey:@"Admissions_1"];
        NSDictionary* dataSet_AdmissionsValue = [dataElements objectForKey:@"Admissions_2"];
        
        //clean up symbols
        NSString* strAdmissionsPercentage = [self stripNonNumericCharacters:[dataSet_AdmissionsPercentage objectForKey:@"Element Value"]];
        NSString* strAdmissionsValue = [self stripNonNumericCharacters:[dataSet_AdmissionsValue objectForKey:@"Element Value"]];
        
        NSArray* admissionsMultipliers = [[NSArray alloc] initWithObjects:strAdmissionsPercentage, strAdmissionsValue, nil];
        NSDecimalNumber* decAdmissionsCostYear1 = [self getProductByPercentage:admissionsMultipliers:patientsAnnualYear1];
        NSDecimalNumber* decAdmissionsCostYear2 = [self getProductByPercentage:admissionsMultipliers:patientsAnnualYear2];
        NSDecimalNumber* decAdmissionsCostYear3 = [self getProductByPercentage:admissionsMultipliers:patientsAnnualYear3];
        
        //add to results dictionary
        [results setObject:[dataSet_AdmissionsPercentage objectForKey:@"Element Value"] forKey:@"Admissions Percentage"];
        [results setObject:[dataSet_AdmissionsValue objectForKey:@"Element Value"] forKey:@"Admissions Value"];
        
        /***************************Oncology*************************************/
        
        NSDictionary* dataSet_OncologyPercentage = [dataElements objectForKey:@"Oncology_1"];
        NSDictionary* dataSet_OncologyValue = [dataElements objectForKey:@"Oncology_2"];
        
        //clean up symbols
        NSString* strOncologyPercentage = [self stripNonNumericCharacters:[dataSet_OncologyPercentage objectForKey:@"Element Value"]];
        NSString* strOncologyValue = [self stripNonNumericCharacters:[dataSet_OncologyValue objectForKey:@"Element Value"]];
        
        NSArray* oncologyMultipliers = [[NSArray alloc] initWithObjects:strOncologyPercentage, strOncologyValue, nil];
        NSDecimalNumber* decOncologyCostYear1 = [self getProductByPercentage:oncologyMultipliers:patientsAnnualYear1];
        NSDecimalNumber* decOncologyCostYear2 = [self getProductByPercentage:oncologyMultipliers:patientsAnnualYear2];
        NSDecimalNumber* decOncologyCostYear3 = [self getProductByPercentage:oncologyMultipliers:patientsAnnualYear3];
        
        //add to results dictionary
        [results setObject:[dataSet_OncologyPercentage objectForKey:@"Element Value"] forKey:@"Oncology Percentage"];
        [results setObject:[dataSet_OncologyValue objectForKey:@"Element Value"] forKey:@"Oncology Value"];
        
        /***************************Radiology*************************************/
        
        NSDictionary* dataSet_RadiologyPercentage = [dataElements objectForKey:@"Radiology_1"];
        NSDictionary* dataSet_RadiologyValue = [dataElements objectForKey:@"Radiology_2"];
        
        //clean up symbols
        NSString* strRadiologyPercentage = [self stripNonNumericCharacters:[dataSet_RadiologyPercentage objectForKey:@"Element Value"]];
        NSString* strRadiologyValue = [self stripNonNumericCharacters:[dataSet_RadiologyValue objectForKey:@"Element Value"]];
        
        NSArray* radiologyMultipliers = [[NSArray alloc] initWithObjects:strRadiologyPercentage, strRadiologyValue, nil];
        NSDecimalNumber* decRadiologyCostYear1 = [self getProductByPercentage:radiologyMultipliers:patientsAnnualYear1];
        NSDecimalNumber* decRadiologyCostYear2 = [self getProductByPercentage:radiologyMultipliers:patientsAnnualYear2];
        NSDecimalNumber* decRadiologyCostYear3 = [self getProductByPercentage:radiologyMultipliers:patientsAnnualYear3];
        
        //add to results dictionary
        [results setObject:[dataSet_RadiologyPercentage objectForKey:@"Element Value"] forKey:@"Radiology Percentage"];
        [results setObject:[dataSet_RadiologyValue objectForKey:@"Element Value"] forKey:@"Radiology Value"];
        
        /***************************Radiology*************************************/
        
        NSDictionary* dataSet_AnesthesiaPercentage = [dataElements objectForKey:@"Anesthesia - Non Endoscopy_1"];
        NSDictionary* dataSet_AnesthesiaValue = [dataElements objectForKey:@"Anesthesia - Non Endoscopy_2"];
        
        //clean up symbols
        NSString* strAnesthesiaPercentage = [self stripNonNumericCharacters:[dataSet_AnesthesiaPercentage objectForKey:@"Element Value"]];
        NSString* strAnesthesiaValue = [self stripNonNumericCharacters:[dataSet_AnesthesiaValue objectForKey:@"Element Value"]];
        
        NSArray* anesthesiaMultipliers = [[NSArray alloc] initWithObjects:strAnesthesiaPercentage, strAnesthesiaValue, nil];
        NSDecimalNumber* decAnesthesiaCostYear1 = [self getProductByPercentage:anesthesiaMultipliers:patientsAnnualYear1];
        NSDecimalNumber* decAnesthesiaCostYear2 = [self getProductByPercentage:anesthesiaMultipliers:patientsAnnualYear2];
        NSDecimalNumber* decAnesthesiaCostYear3 = [self getProductByPercentage:anesthesiaMultipliers:patientsAnnualYear3];
        
        //add to results dictionary
        [results setObject:[dataSet_AnesthesiaPercentage objectForKey:@"Element Value"] forKey:@"Anesthesia Percentage"];
        [results setObject:[dataSet_AnesthesiaValue objectForKey:@"Element Value"] forKey:@"Anesthesia Value"];
        
        /***************************Other*************************************/
        
        NSDictionary* dataSet_OtherPercentage = [dataElements objectForKey:@"Other_1"];
        NSDictionary* dataSet_OtherValue = [dataElements objectForKey:@"Other_2"];
        
        //clean up symbols
        NSString* strOtherPercentage = [self stripNonNumericCharacters:[dataSet_OtherPercentage objectForKey:@"Element Value"]];
        NSString* strOtherValue = [self stripNonNumericCharacters:[dataSet_OtherValue objectForKey:@"Element Value"]];
        
        NSArray* otherMultipliers = [[NSArray alloc] initWithObjects:strOtherPercentage, strOtherValue, nil];
        NSDecimalNumber* decOtherCostYear1 = [self getProductByPercentage:otherMultipliers:patientsAnnualYear1];
        NSDecimalNumber* decOtherCostYear2 = [self getProductByPercentage:otherMultipliers:patientsAnnualYear2];
        NSDecimalNumber* decOtherCostYear3 = [self getProductByPercentage:otherMultipliers:patientsAnnualYear3];
        
        //add to results dictionary
        [results setObject:[dataSet_OtherPercentage objectForKey:@"Element Value"] forKey:@"Other Percentage"];
        [results setObject:[dataSet_OtherValue objectForKey:@"Element Value"] forKey:@"Other Value"];
        
        /***************************GET ANNUAL REVENUE*****************************/
        
        NSArray* costItemsYear1 = [[NSArray alloc] initWithObjects:decPathologyCostYear1, decSurgeryCostYear1, decAdmissionsCostYear1, decOncologyCostYear1, decRadiologyCostYear1, decAnesthesiaCostYear1, decOtherCostYear1, nil];
        
        NSArray* costItemsYear2 = [[NSArray alloc] initWithObjects:decPathologyCostYear2, decSurgeryCostYear2, decAdmissionsCostYear2, decOncologyCostYear2, decRadiologyCostYear2, decAnesthesiaCostYear2, decOtherCostYear2, nil];
        
        NSArray* costItemsYear3 = [[NSArray alloc] initWithObjects:decPathologyCostYear3, decSurgeryCostYear3, decAdmissionsCostYear3, decOncologyCostYear3, decRadiologyCostYear3, decAnesthesiaCostYear3, decOtherCostYear3, nil];
        
        //get the totals as a decimal number
        NSDecimalNumber* decYear1DownstreamGrowth = [self addNSDecimalNumbers:costItemsYear1];
        NSDecimalNumber* decYear2DownstreamGrowth = [self addNSDecimalNumbers:costItemsYear2];
        NSDecimalNumber* decYear3DownstreamGrowth = [self addNSDecimalNumbers:costItemsYear3];
        
        //convert totals to displayable currency string
        NSString* strYear1DownstreamGrowth = [self convertToCurrencyString:decYear1DownstreamGrowth];
        NSString* strYear2DownstreamGrowth = [self convertToCurrencyString:decYear2DownstreamGrowth];
        NSString* strYear3DownstreamGrowth = [self convertToCurrencyString:decYear3DownstreamGrowth];
        
        //add to results dictionary
        [results setObject:strYear1DownstreamGrowth forKey:@"Growth Year 1"];
        [results setObject:strYear2DownstreamGrowth forKey:@"Growth Year 2"];
        [results setObject:strYear3DownstreamGrowth forKey:@"Growth Year 3"];
        
        /******************************GET ANNUAL MARGIN***************************/
        
        //convert to percentage
        float percentOfDownstreamReimburseent = 30/100.0;
        
        //convert float to decimal number
        NSDecimalNumber* decPercentOfDownStreamReimbursement = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", percentOfDownstreamReimburseent]];
        
        //get margins
        NSDecimalNumber* decMarginsYear1 = [decYear1DownstreamGrowth decimalNumberByMultiplyingBy:decPercentOfDownStreamReimbursement withBehavior:myDecimalHandler];
        
        NSDecimalNumber* decMarginsYear2 = [decYear2DownstreamGrowth decimalNumberByMultiplyingBy:decPercentOfDownStreamReimbursement withBehavior:myDecimalHandler];
        
        NSDecimalNumber* decMarginsYear3 = [decYear3DownstreamGrowth decimalNumberByMultiplyingBy:decPercentOfDownStreamReimbursement withBehavior:myDecimalHandler];
        
        //convert to currency strings
        NSString* strMarginsYear1 = [self convertToCurrencyString:decMarginsYear1];
        NSString* strMarginsYear2 = [self convertToCurrencyString:decMarginsYear2];
        NSString* strMarginsYear3 = [self convertToCurrencyString:decMarginsYear3];
        
        //add to results dictionary
        [results setObject:strMarginsYear1 forKey:@"Margins Year 1"];
        [results setObject:strMarginsYear2 forKey:@"Margins Year 2"];
        [results setObject:strMarginsYear3 forKey:@"Margins Year 3"];
        
        /***********************************FACILITY FEES**********************************/
        
        //medicare reimbursement percentage
        NSDictionary* dataSet_MedicareReimbursement = [dataElements objectForKey:@"Percentage of cases reimbursed through Medicare_1"];
        NSString* strMedicareReimbursementValue = [dataSet_MedicareReimbursement objectForKey:@"Element Value"];
        //clean and convert to percentage
        float medicareReimbursementPercentage = [[self stripNonNumericCharacters:strMedicareReimbursementValue] floatValue]/100;
        
        //facility medicare fee per case
        NSDictionary* dataSet_MedicareFacilityFee = [dataElements objectForKey:@"Medicare Facility Fee per case (does not include modifiers)_1"];
        NSString* strMedicareFacilityFeeValue = [dataSet_MedicareFacilityFee objectForKey:@"Element Value"];
        //clean and convert
        float medicareFacilityFee = [[self stripNonNumericCharacters:strMedicareFacilityFeeValue] floatValue];
        
        //non medicare reimbursement percentage
        NSDictionary* dataSet_NonMedicareReimbursement = [dataElements objectForKey:@"Percentage of cases reimbursed through non-Medicare payers_1"];
        NSString* strNonMedicareReimbursementValue = [dataSet_NonMedicareReimbursement objectForKey:@"Element Value"];
        //clean and convert to percentage
        float nonMedicareReimbursementPercentage = [[self stripNonNumericCharacters:strNonMedicareReimbursementValue] floatValue]/100;
        
        //facility medicare fee per case
        NSDictionary* dataSet_NonMedicareFacilityFee = [dataElements objectForKey:@"Non-Medicare Facility Fee per case_1"];
        NSString* strNonMedicareFacilityFeeValue = [dataSet_NonMedicareFacilityFee objectForKey:@"Element Value"];
        //clean and convert
        float nonMedicareFacilityFee = [[self stripNonNumericCharacters:strNonMedicareFacilityFeeValue] floatValue];
        
        //formula
        float facilityFeeYear1 = patientsAnnualYear1*(medicareReimbursementPercentage*medicareFacilityFee) + patientsAnnualYear1*(nonMedicareReimbursementPercentage*nonMedicareFacilityFee);
        float facilityFeeYear2 = patientsAnnualYear2*(medicareReimbursementPercentage*medicareFacilityFee) + patientsAnnualYear2*(nonMedicareReimbursementPercentage*nonMedicareFacilityFee);
        float facilityFeeYear3 = patientsAnnualYear3*(medicareReimbursementPercentage*medicareFacilityFee) + patientsAnnualYear3*(nonMedicareReimbursementPercentage*nonMedicareFacilityFee);
        
        //convert to currency
        NSDecimalNumber* decFacilityFeeYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", facilityFeeYear1]];
        NSString* strFacilityFeeYear1 = [self convertToCurrencyString:decFacilityFeeYear1];
        
        NSDecimalNumber* decFacilityFeeYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", facilityFeeYear2]];
        NSString* strFacilityFeeYear2 = [self convertToCurrencyString:decFacilityFeeYear2];
        
        NSDecimalNumber* decFacilityFeeYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", facilityFeeYear3]];
        NSString* strFacilityFeeYear3 = [self convertToCurrencyString:decFacilityFeeYear3];
        
        //add to results dictionary
        [results setObject:strFacilityFeeYear1 forKey:@"Facility Fee Year 1"];
        [results setObject:strFacilityFeeYear2 forKey:@"Facility Fee Year 2"];
        [results setObject:strFacilityFeeYear3 forKey:@"Facility Fee Year 3"];
        
        /***********************************PHYSICIAN FEES**********************************/
        
        NSDictionary* dataSet_PhysicianEmployment = [dataElements objectForKey:@"Will the physician performing EUS be facility employed?_1"];
        NSDictionary* dataSet_PhysicianFee = [dataElements objectForKey:@"Physician Fee per case _1"];
        
        //get whether physician is facility employed or not
        NSString* strPhysicianEmployment = [dataSet_PhysicianEmployment objectForKey:@"Element Value"];
        
        NSString* strPhysicianFeeYear1;
        NSString* strPhysicianFeeYear2;
        NSString* strPhysicianFeeYear3;
        float physicianFeeYear1 = 0.0;
        float physicianFeeYear2 = 0.0;
        float physicianFeeYear3 = 0.0;
        
        if([strPhysicianEmployment isEqualToString:@"YES"]) {
            
            //get the fee, clean and convert it to float
            float physicianFee = [[self stripNonNumericCharacters:[dataSet_PhysicianFee objectForKey:@"Element Value"]] floatValue];
            
            //formula
            physicianFeeYear1 = patientsAnnualYear1*physicianFee;
            physicianFeeYear2 = patientsAnnualYear2*physicianFee;
            physicianFeeYear3 = patientsAnnualYear3*physicianFee;
            
            //convert to currency string
            NSDecimalNumber* decPhysicianFeeYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", physicianFeeYear1]];
            strPhysicianFeeYear1 = [self convertToCurrencyString:decPhysicianFeeYear1];
            
            NSDecimalNumber* decPhysicianFeeYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", physicianFeeYear2]];
            strPhysicianFeeYear2 = [self convertToCurrencyString:decPhysicianFeeYear2];
            
            
            NSDecimalNumber* decPhysicianFeeYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", physicianFeeYear3]];
            strPhysicianFeeYear3 = [self convertToCurrencyString:decPhysicianFeeYear3];
            
        } else {
            
            NSDecimalNumber* decPhysicianFee = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", 0.0]];
            strPhysicianFeeYear1 = [self convertToCurrencyString:decPhysicianFee];
            strPhysicianFeeYear2 = [self convertToCurrencyString:decPhysicianFee];
            strPhysicianFeeYear3 = [self convertToCurrencyString:decPhysicianFee];
        }
        
        //add to results dictionary
        [results setObject:strPhysicianFeeYear1 forKey:@"Physician Fee Year 1"];
        [results setObject:strPhysicianFeeYear2 forKey:@"Physician Fee Year 2"];
        [results setObject:strPhysicianFeeYear3 forKey:@"Physician Fee Year 3"];
        
        /***********************************ANESTHESIA FEES**********************************/
        
        
        NSDictionary* dataSet_Anesthesia = [dataElements objectForKey:@"Will a secondary provider deliver anesthesia during EUS cases?_1"];
        NSDictionary* dataSet_AnesthesiaFee = [dataElements objectForKey:@"Anesthesia reimbursement per case (Facility Fee)_1"];
        
        //get whether physician is facility employed or not
        NSString* strAnesthesia = [dataSet_Anesthesia objectForKey:@"Element Value"];
        
        NSString* strAnesthesiaFeeYear1;
        NSString* strAnesthesiaFeeYear2;
        NSString* strAnesthesiaFeeYear3;
        
        float anesthesiaFeeYear1 = 0.0;
        float anesthesiaFeeYear2 = 0.0;
        float anesthesiaFeeYear3 = 0.0;
        
        if([strAnesthesia isEqualToString:@"Yes"] || [strAnesthesia isEqualToString:@"YES"]) {
            
            //get the fee, clean and convert it to float
            float anesthesiaFee = [[self stripNonNumericCharacters:[dataSet_AnesthesiaFee objectForKey:@"Element Value"]] floatValue];
            
            //formula
            anesthesiaFeeYear1 = patientsAnnualYear1*anesthesiaFee;
            anesthesiaFeeYear2 = patientsAnnualYear2*anesthesiaFee;
            anesthesiaFeeYear3 = patientsAnnualYear3*anesthesiaFee;
            
            //convert to currency string
            NSDecimalNumber* decAnesthesiaFeeYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", anesthesiaFeeYear1]];
            strAnesthesiaFeeYear1 = [self convertToCurrencyString:decAnesthesiaFeeYear1];
            
            NSDecimalNumber* decAnesthesiaFeeYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", anesthesiaFeeYear2]];
            strAnesthesiaFeeYear2 = [self convertToCurrencyString:decAnesthesiaFeeYear2];
            
            NSDecimalNumber* decAnesthesiaFeeYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", anesthesiaFeeYear3]];
            strAnesthesiaFeeYear3 = [self convertToCurrencyString:decAnesthesiaFeeYear3];
            
        } else {
            
            NSDecimalNumber* decAnesthesiaFee = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", 0.0]];
            strAnesthesiaFeeYear1 = [self convertToCurrencyString:decAnesthesiaFee];
            strAnesthesiaFeeYear2 = [self convertToCurrencyString:decAnesthesiaFee];
            strAnesthesiaFeeYear3 = [self convertToCurrencyString:decAnesthesiaFee];
            
        }
        
        //add to results dictionary
        [results setObject:strAnesthesiaFeeYear1 forKey:@"Anesthesia Fee Year 1"];
        [results setObject:strAnesthesiaFeeYear2 forKey:@"Anesthesia Fee Year 2"];
        [results setObject:strAnesthesiaFeeYear3 forKey:@"Anesthesia Fee Year 3"];
        
        /*******************Downstream Margin*********************/
        
        NSDictionary* dataSet_NetProfitMargin = [dataElements objectForKey:@"Net profit margin generated from downstream cases_1"];
        
        //get value and convert to percentage
        //clean and convert to percentage
        NSString* strNetProfitMarginPercent = [dataSet_NetProfitMargin objectForKey:@"Element Value"];
        float netProfitMarginPercent = [[self stripNonNumericCharacters: strNetProfitMarginPercent]floatValue]/100;
        
        //get the float values
        float downstreamOperatingMarginYear1 = [decYear1DownstreamGrowth floatValue]*netProfitMarginPercent;
        float downstreamOperatingMarginYear2 = [decYear2DownstreamGrowth floatValue]*netProfitMarginPercent;
        float downstreamOperatingMarginYear3 = [decYear3DownstreamGrowth floatValue]*netProfitMarginPercent;
        
        //convert to decimalNumbers
        NSDecimalNumber* decNetProfitMarginYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", downstreamOperatingMarginYear1]];
        NSDecimalNumber* decNetProfitMarginYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", downstreamOperatingMarginYear2]];
        NSDecimalNumber* decNetProfitMarginYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", downstreamOperatingMarginYear3]];
        
        //convert to currency
        NSString* strNetProfitMarginYear1 = [self convertToCurrencyString:decNetProfitMarginYear1];
        NSString* strNetProfitMarginYear2 = [self convertToCurrencyString:decNetProfitMarginYear2];
        NSString* strNetProfitMarginYear3 = [self convertToCurrencyString:decNetProfitMarginYear3];
        
        //add to results dictionary
        [results setObject:strNetProfitMarginYear1 forKey:@"Net Profit Margin Fee Year 1"];
        [results setObject:strNetProfitMarginYear2 forKey:@"Net Profit Margin Fee Year 2"];
        [results setObject:strNetProfitMarginYear3 forKey:@"Net Profit Margin Fee Year 3"];
        
        /*******************Annual Operating Margin*********************/
        
        //get float values
        float annualRevenueOperatingMarginYear1 = facilityFeeYear1 + physicianFeeYear1 + anesthesiaFeeYear1 + downstreamOperatingMarginYear1;
        float annualRevenueOperatingMarginYear2 = facilityFeeYear2 + physicianFeeYear2 + anesthesiaFeeYear2 + downstreamOperatingMarginYear2;
        float annualRevenueOperatingMarginYear3 = facilityFeeYear3 + physicianFeeYear3 + anesthesiaFeeYear3 + downstreamOperatingMarginYear3;
        
        //convert to decimalNumbers
        NSDecimalNumber* decAnnualRevenueOperatingMarginYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", annualRevenueOperatingMarginYear1]];
        NSDecimalNumber* decAnnualRevenueOperatingMarginYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", annualRevenueOperatingMarginYear2]];
        NSDecimalNumber* decAnnualRevenueOperatingMarginYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", annualRevenueOperatingMarginYear3]];
        
        //convert to currency
        NSString* strAnnualRevneuOperatingMarginYear1 = [self convertToCurrencyString:decAnnualRevenueOperatingMarginYear1];
        NSString* strAnnualRevneuOperatingMarginYear2 = [self convertToCurrencyString:decAnnualRevenueOperatingMarginYear2];
        NSString* strAnnualRevneuOperatingMarginYear3 = [self convertToCurrencyString:decAnnualRevenueOperatingMarginYear3];
        
        //add to results dictionary
        [results setObject:strAnnualRevneuOperatingMarginYear1 forKey:@"Annual Revenue Operating Margin Fee Year 1"];
        [results setObject:strAnnualRevneuOperatingMarginYear2 forKey:@"Annual Revenue Operating Margin Fee Year 2"];
        [results setObject:strAnnualRevneuOperatingMarginYear3 forKey:@"Annual Revenue Operating Margin Fee Year 3"];
        
        /******************EXPENDITURES********************/
        
        /***********Equipment*****************************/
        
        //EU-ME1
        NSDictionary* dataSet_EUME1_Quantity = [dataElements objectForKey:@"EU-ME1_1"];
        NSDictionary* dataSet_EUME1_Value = [dataElements objectForKey:@"EU-ME1_2"];
        
        int EUME1_Quantity = [[dataSet_EUME1_Quantity objectForKey:@"Element Value"] intValue];
        float EUME1_Value = [[dataSet_EUME1_Value objectForKey:@"Element Value"] floatValue];
        float EUME1_Total = EUME1_Quantity * EUME1_Value;
        
        //GF-UC140P-AL5
        NSDictionary* dataSet_GFUC140PAL5_Quantity = [dataElements objectForKey:@"GF-UC140P-AL5_1"];
        NSDictionary* dataSet_GFUC140PAL5_Value = [dataElements objectForKey:@"GF-UC140P-AL5_2"];
        
        int GFUC140PAL5_Quantity = [[dataSet_GFUC140PAL5_Quantity objectForKey:@"Element Value"] intValue];
        float GFUC140PAL5_Value = [[dataSet_GFUC140PAL5_Value objectForKey:@"Element Value"] floatValue];
        float GFUC140PAL5_Total = GFUC140PAL5_Quantity * GFUC140PAL5_Value;
        
        //GF-UCT140-AL5
        NSDictionary* dataSet_GFUCT140PAL5_Quantity = [dataElements objectForKey:@"GF-UCT140-AL5_1"];
        NSDictionary* dataSet_GFUCT140PAL5_Value = [dataElements objectForKey:@"GF-UCT140P-AL5_2"];
        
        int GFUCT140PAL5_Quantity = [[dataSet_GFUCT140PAL5_Quantity objectForKey:@"Element Value"] intValue];
        float GFUCT140PAL5_Value = [[dataSet_GFUCT140PAL5_Value objectForKey:@"Element Value"] floatValue];
        float GFUCT140PAL5_Total = GFUCT140PAL5_Quantity * GFUCT140PAL5_Value;
        
        //GF-UCT140-AL5
        NSDictionary* dataSet_GFUCT180_Quantity = [dataElements objectForKey:@"GF-UCT180_1"];
        NSDictionary* dataSet_GFUCT180_Value = [dataElements objectForKey:@"GF-UCT180_2"];
        
        int GFUCT180_Quantity = [[dataSet_GFUCT180_Quantity objectForKey:@"Element Value"] intValue];
        float GFUCT180_Value = [[dataSet_GFUCT180_Value objectForKey:@"Element Value"] floatValue];
        float GFUCT180_Total = GFUCT180_Quantity * GFUCT180_Value;
        
        //GF-UE160-AL5
        NSDictionary* dataSet_GFUE160_Quantity = [dataElements objectForKey:@"GF-UE160-AL5_1"];
        NSDictionary* dataSet_GFUE160_Value = [dataElements objectForKey:@"GF-UE160-AL5_2"];
        
        int GFUE160_Quantity = [[dataSet_GFUE160_Quantity objectForKey:@"Element Value"] intValue];
        float GFUE160_Value = [[dataSet_GFUE160_Value objectForKey:@"Element Value"] floatValue];
        float GFUE160_Total = GFUE160_Quantity * GFUE160_Value;
        
        //SSD-Alpha 10
        NSDictionary* dataSet_SSDAlpha10_Quantity = [dataElements objectForKey:@"SSD-Alpha 10_1"];
        NSDictionary* dataSet_SSDAlpha10_Value = [dataElements objectForKey:@"SSD-Alpha 10_2"];
        
        int SSDAlpha10_Quantity = [[dataSet_SSDAlpha10_Quantity objectForKey:@"Element Value"] intValue];
        float SSDAlpha10_Value = [[dataSet_SSDAlpha10_Value objectForKey:@"Element Value"] floatValue];
        float SSDAlpha10_Total = SSDAlpha10_Quantity * SSDAlpha10_Value;
        
        //SSD-Alpha 5
        NSDictionary* dataSet_SSDAlpha5_Quantity = [dataElements objectForKey:@"SSD-Alpha 5_1"];
        NSDictionary* dataSet_SSDAlpha5_Value = [dataElements objectForKey:@"SSD-Alpha 5_2"];
        
        int SSDAlpha5_Quantity = [[dataSet_SSDAlpha5_Quantity objectForKey:@"Element Value"] intValue];
        float SSDAlpha5_Value = [[dataSet_SSDAlpha5_Value objectForKey:@"Element Value"] floatValue];
        float SSDAlpha5_Total = SSDAlpha5_Quantity * SSDAlpha5_Value;
        
        //add all equipment totals
        float equipmentTotal = EUME1_Total + GFUC140PAL5_Total + GFUCT140PAL5_Total + GFUCT180_Total + GFUE160_Total + SSDAlpha10_Total + SSDAlpha5_Total;
        float equipmentLease = equipmentTotal/3;
        
        //convert to NSecimal Number
        NSDecimalNumber* decEquipmentTotal = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", equipmentTotal]];
        
        NSDecimalNumber* decEquipmentLease = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", equipmentLease]];
        
        NSDecimalNumber* zero = [NSDecimalNumber zero];
        
        //convert to currency string
        NSString* strEquipmentTotalYear1;
        NSString* strEquipmentTotalYear2;
        NSString* strEquipmentTotalYear3;
        
        if(isCashOutlay) {
            
            strEquipmentTotalYear1 = [self convertToCurrencyString:decEquipmentTotal];
            strEquipmentTotalYear2 = [self convertToCurrencyString:zero];
            strEquipmentTotalYear3 = [self convertToCurrencyString:zero];
            
            //change the table header
            lblResultType.text = @"Three-Year Projection Assuming Cash Outlay";
        } else {
            strEquipmentTotalYear1 = [self convertToCurrencyString:decEquipmentLease];
            strEquipmentTotalYear2 = [self convertToCurrencyString:decEquipmentLease];
            strEquipmentTotalYear3 = [self convertToCurrencyString:decEquipmentLease];
            
            //change the table header
            lblResultType.text = @"Three-Year Projection Assuming Fair Market Value Lease";
        }
        
        //resize the table header
        CGSize tableHeaderSize = [lblResultType.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
        CGRect tableHeaderFrame = lblResultType.frame;
        UIView* tableHeaderParent = lblResultType.superview;
        tableHeaderFrame.origin.x = (tableHeaderParent.frame.size.width/2)-(tableHeaderSize.width/2);
        tableHeaderFrame.size.width = tableHeaderSize.width;
        lblResultType.frame = tableHeaderFrame;
        
        //add to results dictionary
        [results setObject:strEquipmentTotalYear1 forKey:@"Equipment Total Year 1"];
        [results setObject:strEquipmentTotalYear2 forKey:@"Equipment Total Year 2"];
        [results setObject:strEquipmentTotalYear3 forKey:@"Equipment Total Year 3"];
        
        /*****************************LABOR*************************/
        
        float laborCost;
        if([strPhysicianEmployment isEqualToString:@"YES"]) {
            laborCost = 296.0;
        } else {
            laborCost = 96.0;
        }
        
        float totalLaborCostYear1 = patientsAnnualYear1*laborCost;
        float totalLaborCostYear2 = patientsAnnualYear2*laborCost;
        float totalLaborCostYear3 = patientsAnnualYear3*laborCost;
        
        //conver to decimal number
        NSDecimalNumber* decTotalLaborCostYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", totalLaborCostYear1]];
        NSDecimalNumber* decTotalLaborCostYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", totalLaborCostYear2]];
        NSDecimalNumber* decTotalLaborCostYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", totalLaborCostYear3]];
        
        //convert to currency string
        NSString* strTotalLaborCostYear1 = [self convertToCurrencyString:decTotalLaborCostYear1];
        NSString* strTotalLaborCostYear2 = [self convertToCurrencyString:decTotalLaborCostYear2];
        NSString* strTotalLaborCostYear3 = [self convertToCurrencyString:decTotalLaborCostYear3];
        
        //add to results dictionary
        [results setObject:strTotalLaborCostYear1 forKey:@"Labor Total Year 1"];
        [results setObject:strTotalLaborCostYear2 forKey:@"Labor Total Year 2"];
        [results setObject:strTotalLaborCostYear3 forKey:@"Labor Total Year 3"];
        
        
        /*****************************SERVICE AND MAINTENANCE*************************/
        
        NSDictionary* dataSet_ServiceCost = [dataElements objectForKey:@"Annual service cost_1"];
        
        //get service cost
        float serviceCost = [[self stripNonNumericCharacters:[dataSet_ServiceCost objectForKey:@"Element Value"]] floatValue];
        
        //convert to decimal number
        NSDecimalNumber* decServiceCostYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", serviceCost]];
        NSDecimalNumber* decServiceCostYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", serviceCost]];
        NSDecimalNumber* decServiceCostYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", serviceCost]];
        
        //convert to currency string
        NSString* strServiceCostYear1 = [self convertToCurrencyString:decServiceCostYear1];
        NSString* strServiceCostYear2 = [self convertToCurrencyString:decServiceCostYear2];
        NSString* strServiceCostYear3 = [self convertToCurrencyString:decServiceCostYear3];
        
        //add to results dictionary
        [results setObject:strServiceCostYear1 forKey:@"Service Total Year 1"];
        [results setObject:strServiceCostYear2 forKey:@"Service Total Year 2"];
        [results setObject:strServiceCostYear3 forKey:@"Service Total Year 3"];
        
        /*****************************VARIABLE COST*************************/
        
        NSDictionary* dataSet_VariableCostPerPatient = [dataElements objectForKey:@"Variable cost per patient_1"];
        
        //get the cost
        float variableCostPerPatient = [[self stripNonNumericCharacters:[dataSet_VariableCostPerPatient objectForKey:@"Element Value"]] floatValue];
        
        float variableCostPerPatientYear1 = patientsAnnualYear1*variableCostPerPatient;
        float variableCostPerPatientYear2 = patientsAnnualYear2*variableCostPerPatient;
        float variableCostPerPatientYear3 = patientsAnnualYear3*variableCostPerPatient;
        
        //convert to decimal number
        NSDecimalNumber* decVariableCostPerPatientYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", variableCostPerPatientYear1]];
        NSDecimalNumber* decVariableCostPerPatientYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", variableCostPerPatientYear2]];
        NSDecimalNumber* decVariableCostPerPatientYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", variableCostPerPatientYear3]];
        
        //convert to currency string
        NSString* strVariableCostPerPatientYear1 = [self convertToCurrencyString:decVariableCostPerPatientYear1];
        NSString* strVariableCostPerPatientYear2 = [self convertToCurrencyString:decVariableCostPerPatientYear2];
        NSString* strVariableCostPerPatientYear3 = [self convertToCurrencyString:decVariableCostPerPatientYear3];
        
        //add to results dictionary
        [results setObject:strVariableCostPerPatientYear1 forKey:@"Variable Cost Per Patient Total Year 1"];
        [results setObject:strVariableCostPerPatientYear2 forKey:@"Variable Cost Per Patient Total Year 2"];
        [results setObject:strVariableCostPerPatientYear3 forKey:@"Variable Cost Per Patient Total Year 3"];
        
        /*****************************FIXED COST*************************/
        
        NSDictionary* dataSet_AdditionalCostPerPatient = [dataElements objectForKey:@"Additional fixed cost per patient_1"];
        
        //get the cost
        float additionalCostPerPatient = [[self stripNonNumericCharacters:[dataSet_AdditionalCostPerPatient objectForKey:@"Element Value"]] floatValue];
        
        float additionalCostPerPatientYear1 = patientsAnnualYear1*additionalCostPerPatient;
        float additionalCostPerPatientYear2 = patientsAnnualYear2*additionalCostPerPatient;
        float additionalCostPerPatientYear3 = patientsAnnualYear3*additionalCostPerPatient;
        
        //convert to decimal number
        NSDecimalNumber* decAdditionalCostPerPatientYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", additionalCostPerPatientYear1]];
        NSDecimalNumber* decAdditionalCostPerPatientYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", additionalCostPerPatientYear2]];
        NSDecimalNumber* decAdditionalCostPerPatientYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", additionalCostPerPatientYear3]];
        
        //convert to currency string
        NSString* strAdditionalCostPerPatientYear1 = [self convertToCurrencyString:decAdditionalCostPerPatientYear1];
        NSString* strAdditionalCostPerPatientYear2 = [self convertToCurrencyString:decAdditionalCostPerPatientYear2];
        NSString* strAdditionalCostPerPatientYear3 = [self convertToCurrencyString:decAdditionalCostPerPatientYear3];
        
        //add to results dictionary
        [results setObject:strAdditionalCostPerPatientYear1 forKey:@"Additional Cost Per Patient Total Year 1"];
        [results setObject:strAdditionalCostPerPatientYear2 forKey:@"Additional Cost Per Patient Total Year 2"];
        [results setObject:strAdditionalCostPerPatientYear3 forKey:@"Additional Cost Per Patient Total Year 3"];
        
        /*****************************TOTAL COST*************************/
        
        float totalCostYear1 = equipmentTotal + totalLaborCostYear1 + serviceCost + variableCostPerPatientYear1 + additionalCostPerPatientYear1;
        float totalCostYear2 = equipmentTotal + totalLaborCostYear2 + serviceCost + variableCostPerPatientYear2 + additionalCostPerPatientYear2;
        float totalCostYear3 = equipmentTotal + totalLaborCostYear3 + serviceCost + variableCostPerPatientYear3 + additionalCostPerPatientYear3;
        
        //convert to decimal number
        NSDecimalNumber* decTotalCostYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", totalCostYear1]];
        //convert to decimal number
        NSDecimalNumber* decTotalCostYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", totalCostYear2]];
        //convert to decimal number
        NSDecimalNumber* decTotalCostYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", totalCostYear3]];
        
        //convert to currency string
        NSString* strTotalCostYear1 = [self convertToCurrencyString:decTotalCostYear1];
        NSString* strTotalCostYear2 = [self convertToCurrencyString:decTotalCostYear2];
        NSString* strTotalCostYear3 = [self convertToCurrencyString:decTotalCostYear3];
        
        //add to results dictionary
        [results setObject:strTotalCostYear1 forKey:@"Total Cost Year 1"];
        [results setObject:strTotalCostYear2 forKey:@"Total Cost Year 2"];
        [results setObject:strTotalCostYear3 forKey:@"Total Cost Year 3"];
        
        /*****************************ANNUAL OPERATING MARGIN*************************/
        
        float annualExpenditureOperatingMarginYear1 = annualRevenueOperatingMarginYear1 - totalCostYear1;
        float annualExpenditureOperatingMarginYear2 = annualRevenueOperatingMarginYear2 - totalCostYear1;
        float annualExpenditureOperatingMarginYear3 = annualRevenueOperatingMarginYear3 - totalCostYear1;
        
        //convert to decimal number
        NSDecimalNumber* decAnnualExpenditureOperatingMarginYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", annualExpenditureOperatingMarginYear1]];
        NSDecimalNumber* decAnnualExpenditureOperatingMarginYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", annualExpenditureOperatingMarginYear2]];
        NSDecimalNumber* decAnnualExpenditureOperatingMarginYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", annualExpenditureOperatingMarginYear3]];
        
        //convert to currency string
        NSString* strAnnualExpenditureOperatingMarginYear1 = [self convertToCurrencyString:decAnnualExpenditureOperatingMarginYear1];
        NSString* strAnnualExpenditureOperatingMarginYear2 = [self convertToCurrencyString:decAnnualExpenditureOperatingMarginYear2];
        NSString* strAnnualExpenditureOperatingMarginYear3 = [self convertToCurrencyString:decAnnualExpenditureOperatingMarginYear3];
        
        //add to results dictionary
        [results setObject:strAnnualExpenditureOperatingMarginYear1 forKey:@"Annual Expenditure Operating Margin Year 1"];
        [results setObject:strAnnualExpenditureOperatingMarginYear2 forKey:@"Annual Expenditure Operating Margin Year 2"];
        [results setObject:strAnnualExpenditureOperatingMarginYear3 forKey:@"Annual Expenditure Operating Margin Year 3"];
        
        /*****************************NET OPERATING MARGIN*************************/
        
        float netOperatingMarginYear1 = 0.0;
        float netOperatingMarginYear2 = annualExpenditureOperatingMarginYear1 + annualExpenditureOperatingMarginYear2;
        float netOperatingMarginYear3 = annualExpenditureOperatingMarginYear2 + annualExpenditureOperatingMarginYear3;
        
        //convert to decimal number
        NSDecimalNumber* decNetOperatingMarginYear1 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", netOperatingMarginYear1]];
        NSDecimalNumber* decNetOperatingMarginYear2 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", netOperatingMarginYear2]];
        NSDecimalNumber* decNetOperatingMarginYear3 = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", netOperatingMarginYear3]];
        
        //convert to currency string
        NSString* strNetOperatingMarginYear1 = [self convertToCurrencyString:decNetOperatingMarginYear1];
        NSString* strNetOperatingMarginYear2 = [self convertToCurrencyString:decNetOperatingMarginYear2];
        NSString* strNetOperatingMarginYear3 = [self convertToCurrencyString:decNetOperatingMarginYear3];
        
        //add to results dictionary
        [results setObject:strNetOperatingMarginYear1 forKey:@"Net Operating Margin Year 1"];
        [results setObject:strNetOperatingMarginYear2 forKey:@"Net Operating Margin Year 2"];
        [results setObject:strNetOperatingMarginYear3 forKey:@"Net Operating Margin Year 3"];
        
        //display the values
        [self displayValues:results];
        
        //set up a point
        float pageX = 6 * 768.0;
        float pageY = 0.0;
        CGPoint scrollOffset = CGPointMake(pageX, pageY);
        
        //reset the my offset (so when keyboard is dismissed scroll remains on page)
        myScrollViewOrigiOffSet = scrollOffset;
        
        //move the scroll offset to that point
        [svCalculatorScroll setContentOffset:scrollOffset animated:YES];
        
    }
    
    
    
}

- (void) changeCalcOption : (UISegmentedControl*) theSCCalcOptions {
    
    
    if (theSCCalcOptions.selectedSegmentIndex == 0) {
        isCashOutlay = YES;
    } else {
        isCashOutlay = NO;
    }
    
    [self calculate];
}

#pragma mark - Display Results

- (void) displayValues : (NSMutableDictionary*) theResults {
    
    for(int f=0; f<resultsFields.count; f++) {
        
        OAI_Label* thisField = (OAI_Label*)[resultsFields objectAtIndex:f];
        NSString* thisFieldID = thisField.labelID;
        
        if ([thisFieldID isEqualToString:@"Pathology_Col2"]) {
            thisField.text = [theResults objectForKey:@"Pathology Percentage"];
        } else if ([thisFieldID isEqualToString:@"Pathology_Col3"]) {
            thisField.text = [theResults objectForKey:@"Pathology Value"];
        } else if ([thisFieldID isEqualToString:@"Surgery_Col2"]) {
            thisField.text = [theResults objectForKey:@"Surgery Percentage"];
        } else if ([thisFieldID isEqualToString:@"Surgery_Col3"]) {
            thisField.text = [theResults objectForKey:@"Surgery Value"];
        } else if ([thisFieldID isEqualToString:@"Admissions_Col2"]) {
            thisField.text = [theResults objectForKey:@"Admissions Percentage"];
        } else if ([thisFieldID isEqualToString:@"Admissions_Col3"]) {
            thisField.text = [theResults objectForKey:@"Admissions Value"];
        } else if ([thisFieldID isEqualToString:@"Oncology_Col2"]) {
            thisField.text = [theResults objectForKey:@"Oncology Percentage"];
        } else if ([thisFieldID isEqualToString:@"Oncology_Col3"]) {
            thisField.text = [theResults objectForKey:@"Oncology Value"];
        } else if ([thisFieldID isEqualToString:@"Radiology_Col2"]) {
            thisField.text = [theResults objectForKey:@"Radiology Percentage"];
        } else if ([thisFieldID isEqualToString:@"Radiology_Col3"]) {
            thisField.text = [theResults objectForKey:@"Radiology Value"];
        } else if ([thisFieldID isEqualToString:@"Anesthesia - Non Endoscopy_Col2"]) {
            thisField.text = [theResults objectForKey:@"Anesthesia Percentage"];
        } else if ([thisFieldID isEqualToString:@"Anesthesia - Non Endoscopy_Col3"]) {
            thisField.text = [theResults objectForKey:@"Anesthesia Value"];
        } else if ([thisFieldID isEqualToString:@"Other_Col2"]) {
            thisField.text = [theResults objectForKey:@"Other Percentage"];
        } else if ([thisFieldID isEqualToString:@"Other_Col3"]) {
            thisField.text = [theResults objectForKey:@"Other Value"];
            
            /*************************GROWTH AND MARGINS*********************/
            
        } else if ([thisFieldID isEqualToString:@"Year 1_Col2"]) {
            thisField.text = [theResults objectForKey:@"Annual Patients Year 1"];
        } else if ([thisFieldID isEqualToString:@"Year 1_Col3"]) {
            thisField.text = [theResults objectForKey:@"Growth Year 1"];
        } else if ([thisFieldID isEqualToString:@"Year 1_Col4"]) {
            thisField.text = [theResults objectForKey:@"Margins Year 1"];
        } else if ([thisFieldID isEqualToString:@"Year 2_Col2"]) {
            thisField.text = [theResults objectForKey:@"Annual Patients Year 2"];
        } else if ([thisFieldID isEqualToString:@"Year 2_Col3"]) {
            thisField.text = [theResults objectForKey:@"Growth Year 2"];
        } else if ([thisFieldID isEqualToString:@"Year 2_Col4"]) {
            thisField.text = [theResults objectForKey:@"Margins Year 2"];
        } else if ([thisFieldID isEqualToString:@"Year 3_Col2"]) {
            thisField.text = [theResults objectForKey:@"Annual Patients Year 3"];
        } else if ([thisFieldID isEqualToString:@"Year 3_Col3"]) {
            thisField.text = [theResults objectForKey:@"Growth Year 3"];
        } else if ([thisFieldID isEqualToString:@"Year 3_Col4"]) {
            thisField.text = [theResults objectForKey:@"Margins Year 3"];
            
            /**********************THREE YEAR PROJECTION : CASH OUTLAYS********************/
            
        } else if ([thisFieldID isEqualToString:@"Number of patients per week_Col2"]) {
            thisField.text = [theResults objectForKey:@"Weekly Patients Year 1"];
        } else if ([thisFieldID isEqualToString:@"Number of patients per week_Col3"]) {
            thisField.text = [theResults objectForKey:@"Weekly Patients Year 2"];
        } else if ([thisFieldID isEqualToString:@"Number of patients per week_Col4"]) {
            thisField.text = [theResults objectForKey:@"Weekly Patients Year 3"];
        } else if ([thisFieldID isEqualToString:@"Number of patients per year_Col2"]) {
            thisField.text = [theResults objectForKey:@"Annual Patients Year 1"];
        } else if ([thisFieldID isEqualToString:@"Number of patients per year_Col3"]) {
            thisField.text = [theResults objectForKey:@"Annual Patients Year 2"];
        } else if ([thisFieldID isEqualToString:@"Number of patients per year_Col4"]) {
            thisField.text = [theResults objectForKey:@"Annual Patients Year 3"];
            
            /******Facility Fee********/
        } else if ([thisFieldID isEqualToString:@"Total Facility Fees (without modifiers)_Col2"]) {
            thisField.text = [theResults objectForKey:@"Facility Fee Year 1"];
        } else if ([thisFieldID isEqualToString:@"Total Facility Fees (without modifiers)_Col3"]) {
            thisField.text = [theResults objectForKey:@"Facility Fee Year 2"];
        } else if ([thisFieldID isEqualToString:@"Total Facility Fees (without modifiers)_Col4"]) {
            thisField.text = [theResults objectForKey:@"Facility Fee Year 3"];
            
            /******Physician Fees*********/
            
        } else if ([thisFieldID isEqualToString:@"Total Physician Fees_Col2"]) {
            thisField.text = [theResults objectForKey:@"Physician Fee Year 1"];
        } else if ([thisFieldID isEqualToString:@"Total Physician Fees_Col3"]) {
            thisField.text = [theResults objectForKey:@"Physician Fee Year 2"];
        } else if ([thisFieldID isEqualToString:@"Total Physician Fees_Col4"]) {
            thisField.text = [theResults objectForKey:@"Physician Fee Year 3"];
            
            /******Anesthesia************/
            
        } else if ([thisFieldID isEqualToString:@"Total Anesthesia Fees_Col2"]) {
            thisField.text = [theResults objectForKey:@"Anesthesia Fee Year 1"];
        } else if ([thisFieldID isEqualToString:@"Total Anesthesia Fees_Col3"]) {
            thisField.text = [theResults objectForKey:@"Anesthesia Fee Year 2"];
        } else if ([thisFieldID isEqualToString:@"Total Anesthesia Fees_Col4"]) {
            thisField.text = [theResults objectForKey:@"Anesthesia Fee Year 3"];
            
            /***********Downstream Operating Margin******************/
            
        } else if ([thisFieldID isEqualToString:@"Downstream Operating Margin_Col2"]) {
            thisField.text = [theResults objectForKey:@"Net Profit Margin Fee Year 1"];
        } else if ([thisFieldID isEqualToString:@"Downstream Operating Margin_Col3"]) {
            thisField.text = [theResults objectForKey:@"Net Profit Margin Fee Year 2"];
        } else if ([thisFieldID isEqualToString:@"Downstream Operating Margin_Col4"]) {
            thisField.text = [theResults objectForKey:@"Net Profit Margin Fee Year 3"];
            
            /***********Annual Operating Margin******************/
            
        } else if ([thisFieldID isEqualToString:@"Annual Operating Margin _Col2"]) {
            thisField.text = [theResults objectForKey:@"Annual Revenue Operating Margin Fee Year 1"];
        } else if ([thisFieldID isEqualToString:@"Annual Operating Margin _Col3"]) {
            thisField.text = [theResults objectForKey:@"Annual Revenue Operating Margin Fee Year 2"];
        } else if ([thisFieldID isEqualToString:@"Annual Operating Margin _Col4"]) {
            thisField.text = [theResults objectForKey:@"Annual Revenue Operating Margin Fee Year 3"];
            
            /******************EXPENDITURES********************/
            
            /***********Equipment*****************************/
            
        } else if ([thisFieldID isEqualToString:@"Equipment_Col2"]) {
            thisField.text = [theResults objectForKey:@"Equipment Total Year 1"];
        } else if ([thisFieldID isEqualToString:@"Equipment_Col3"]) {
            thisField.text = [theResults objectForKey:@"Equipment Total Year 2"];
        } else if ([thisFieldID isEqualToString:@"Equipment_Col4"]) {
            thisField.text = [theResults objectForKey:@"Equipment Total Year 3"];
            
            /***********Labor*****************************/
            
        } else if ([thisFieldID isEqualToString:@"Labor_Col2"]) {
            thisField.text = [theResults objectForKey:@"Labor Total Year 1"];
        } else if ([thisFieldID isEqualToString:@"Labor_Col3"]) {
            thisField.text = [theResults objectForKey:@"Labor Total Year 2"];
        } else if ([thisFieldID isEqualToString:@"Labor_Col4"]) {
            thisField.text = [theResults objectForKey:@"Labor Total Year 3"];
            
            /***********Service and Maintenance*****************************/
            
        } else if ([thisFieldID isEqualToString:@"Service & Maintenance_Col2"]) {
            thisField.text = [theResults objectForKey:@"Service Total Year 1"];
        } else if ([thisFieldID isEqualToString:@"Service & Maintenance_Col3"]) {
            thisField.text = [theResults objectForKey:@"Service Total Year 2"];
        } else if ([thisFieldID isEqualToString:@"Service & Maintenance_Col4"]) {
            thisField.text = [theResults objectForKey:@"Service Total Year 3"];
            
            /***********Variable Cost Per Patient*************************/
        } else if ([thisFieldID isEqualToString:@"Other variable costs_Col2"]) {
            thisField.text = [theResults objectForKey:@"Variable Cost Per Patient Total Year 1"];
        } else if ([thisFieldID isEqualToString:@"Other variable costs_Col3"]) {
            thisField.text = [theResults objectForKey:@"Variable Cost Per Patient Total Year 2"];
        } else if ([thisFieldID isEqualToString:@"Other variable costs_Col4"]) {
            thisField.text = [theResults objectForKey:@"Variable Cost Per Patient Total Year 3"];
            
            /***********Fixed Cost Per Patient*************************/
        } else if ([thisFieldID isEqualToString:@"Other fixed costs_Col2"]) {
            thisField.text = [theResults objectForKey:@"Additional Cost Per Patient Total Year 1"];
        } else if ([thisFieldID isEqualToString:@"Other fixed costs_Col3"]) {
            thisField.text = [theResults objectForKey:@"Additional Cost Per Patient Total Year 2"];
        } else if ([thisFieldID isEqualToString:@"Other fixed costs_Col4"]) {
            thisField.text = [theResults objectForKey:@"Additional Cost Per Patient Total Year 3"];
            
            /***********Total Cost *************************/
        } else if ([thisFieldID isEqualToString:@"Total Cost_Col2"]) {
            thisField.text = [theResults objectForKey:@"Total Cost Year 1"];
        } else if ([thisFieldID isEqualToString:@"Total Cost_Col3"]) {
            thisField.text = [theResults objectForKey:@"Total Cost Year 2"];
        } else if ([thisFieldID isEqualToString:@"Total Cost_Col4"]) {
            thisField.text = [theResults objectForKey:@"Total Cost Year 3"];
            
            /***********Expenditure Operating Margin  *************************/
            
        } else if ([thisFieldID isEqualToString:@"Annual Operating Margin_Col2"]) {
            thisField.text = [theResults objectForKey:@"Annual Expenditure Operating Margin Year 1"];
        } else if ([thisFieldID isEqualToString:@"Annual Operating Margin_Col3"]) {
            thisField.text = [theResults objectForKey:@"Annual Expenditure Operating Margin Year 2"];
        } else if ([thisFieldID isEqualToString:@"Annual Operating Margin_Col4"]) {
            thisField.text = [theResults objectForKey:@"Annual Expenditure Operating Margin Year 3"];
            
            /***********Net Operating Margin  *************************/
            
        } else if ([thisFieldID isEqualToString:@"Net Operating Margin_Col2"]) {
            thisField.text = [theResults objectForKey:@"Net Operating Margin Year 1"];
        } else if ([thisFieldID isEqualToString:@"Net Operating Margin_Col3"]) {
            thisField.text = [theResults objectForKey:@"Net Operating Margin Year 2"];
        } else if ([thisFieldID isEqualToString:@"Net Operating Margin_Col4"]) {
            thisField.text = [theResults objectForKey:@"Net Operating Margin Year 3"];
            
        }
    }
}


#pragma mark - Conversion Methods

- (NSString*) stripNonNumericCharacters : (NSString* ) stringToStrip  {
    
    //strip away $ and % signs
    NSString * thisCleanedString = [stringToStrip stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [stringToStrip length])];
    
    return thisCleanedString;
}

- (NSDecimalNumber*) getProductByPercentage : (NSArray*) itemsToMultiply : (float) annualPatients {
    
    //get items from array
    NSString* percentage = [itemsToMultiply objectAtIndex:0];
    NSString* value = [itemsToMultiply objectAtIndex:1];
    
    //convert to percentage
    float thisPercentage = [percentage floatValue]/100.0;
    
    //convert to NSDecimal
    NSDecimalNumber* decPercentage = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f",  thisPercentage]];
    NSDecimalNumber* decAvgReimbursement = [[NSDecimalNumber alloc] initWithString: value];
    NSDecimalNumber* decAnnualPatients = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", annualPatients]];
    
    
    //get our results
    NSDecimalNumber* decAvgCost = [decAvgReimbursement decimalNumberByMultiplyingBy:decPercentage
                                                                       withBehavior:myDecimalHandler];
    NSDecimalNumber* decAnnualCost = [decAvgCost decimalNumberByMultiplyingBy:decAnnualPatients withBehavior:myDecimalHandler];
    
    return decAnnualCost;
    
}

- (NSDecimalNumber*) addNSDecimalNumbers : (NSArray*) itemsToAdd {
    
    float baseNumber = 0;
    
    for(int i=0; i<itemsToAdd.count; i++) {
        baseNumber =  baseNumber + [[itemsToAdd objectAtIndex:i] floatValue];
    }
    
    NSDecimalNumber* newNumber = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", baseNumber]];
    NSDecimalNumber* zero = [NSDecimalNumber zero];
    return [newNumber decimalNumberByAdding:zero withBehavior:myDecimalHandler];
    
}

- (NSString*) convertToCurrencyString : (NSDecimalNumber*) numberToConvert {
    
    //convert to string
    NSString* currencyString = [NSNumberFormatter localizedStringFromNumber:numberToConvert numberStyle:NSNumberFormatterCurrencyStyle];
    
    return currencyString;
}

- (NSString*) convertFloatToDisplayString : (float) floatToConvert {
    
    //convert to NSDecimalNumber
    NSDecimalNumber* thisDecimalNumber = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", floatToConvert]];
    NSDecimalNumber* zero = [NSDecimalNumber zero];
    NSDecimalNumber* truncatedDecimalNumber = [thisDecimalNumber decimalNumberByAdding:zero withBehavior:myDecimalHandler];
    
    return truncatedDecimalNumber.stringValue;
    
}


#pragma mark - Email Methods

- (void) toggleEmailSetUp {
    
    CGRect vMailOptionsFrame = vMailOptions.frame;
    
    if (vMailOptionsFrame.origin.y == 0.0) {
        vMailOptionsFrame.origin.y = -400.0;
    } else {
        
        txtName.text = @"";
        txtFacility.text = @"";
        vMailOptionsFrame.origin.y = 0.0;
    }
    
    [self animateView:vMailOptions :vMailOptionsFrame];
    
}



- (void) sendEmail : (UIButton*) btn {
    
    //validate email entries
    
    BOOL isValid = YES;
    NSMutableString* errMsg = [[NSMutableString alloc] initWithString:@"There was a problem with your email setup.\n\n"];
    
    NSString* emailReicpient = txtName.text;
    NSString* recipientFacility = txtFacility.text;
    BOOL isPDF;
    int selectedPDFIndex= scPDFOptions.selectedSegmentIndex;
    
    if (selectedPDFIndex == 0) {
        isPDF = YES;
    } else {
        isPDF = NO;
    }
    
    if ([emailReicpient isEqualToString:@""] || emailReicpient == NULL) {
        isValid = NO;
        [errMsg appendString:@"You must enter a recipient.\n\n"];
    }
    
    if ([recipientFacility isEqualToString:@""] || recipientFacility == NULL) {
        isValid = NO;
        [errMsg appendString:@"You must enter a facility name.\n\n"];
    }
    
    /*if (!isValid) {
     alertManager.closeAction = @"Do Nothing";
     alertManager.titleBarText = @"Email Setup Error!";
     [alertManager showAlert:errMsg];
     } else {*/
    [self toggleEmailSetUp];
    
    NSMutableDictionary* mailData = [[NSMutableDictionary alloc] init];
    [mailData setObject:emailReicpient forKey:@"Email Recipient"];
    [mailData setObject:recipientFacility forKey:@"Recipient Facility"];
    [mailData setObject:results forKey:@"Calculation Results"];
    
    NSMutableString* emailBody = [[NSMutableString alloc] init];
    
    NSString* recipientName = [mailData objectForKey:@"Email Recipient"];
    NSString* facilityName = [mailData objectForKey:@"Recipient Facility"];
    
    //set the subject
    NSString* emailSubject = [NSString stringWithFormat:@"Olympus EUS Calculation Results for %@",facilityName];
    
    [emailBody appendString:@"<div>Below are the results of the EUS Value Calculator to determine potential downstream revenue from EUS patients.</div>"];
    
    [emailBody appendString:@"<div style=\"margin-top: 30px;\"><table style=\"border-top:1px solid #e5eff8; border-right:1px solid #e5eff8;\"><thead><tr><th colspan=\"3\" style=\"background:#08107B; text-align:center; color:#fff; font-family: Helvetica, Arial, sans-serif; font-weight: 900; font-size: 18px;\">Downstream Revenue Model</th></tr><tr style=\"background:#bbceff;\"><th style=\"width: 200px; padding:2px\">Department</th><th style=\"width:300px; padding:2px\">EUS Cases Utilizing Services of Other Departments</th><th style=\"padding:2px\">Average Medicare Reimbursement</th></tr></thead>"];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ddf3fd;\"><td style=\"padding:2px\">Pathology</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Pathology Percentage"], [results objectForKey:@"Pathology Value"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Surgery</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Surgery Percentage"], [results objectForKey:@"Surgery Value"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ddf3fd;\"><td style=\"padding:2px\">Admissions</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Admissions Percentage"], [results objectForKey:@"Admissions Value"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Oncology</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Oncology Percentage"], [results objectForKey:@"Oncology Value"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ddf3fd;\"><td style=\"padding:2px\">Radiology</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Radiology Percentage"], [results objectForKey:@"Radiology Value"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Anesthesia</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Anesthesia Percentage"], [results objectForKey:@"Anesthesia Value"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ddf3fd;\"><td style=\"padding:2px\">Other</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Other Percentage"], [results objectForKey:@"Other Value"]]];
    
    [emailBody appendString:@"</tbody><tbody></table></div>"];
    
    /******************************Margins Table**********************/
    
    [emailBody appendString:@"<div><table style=\"border-top:1px solid #e5eff8; border-right:1px solid #e5eff8;\"><thead><tr style=\"background:#6e6c56; color:#c1be9b;\"><th style=\"width:100px;\">&nbsp;</th><th>Number of Cases</th><th style=\"font-size:20px;\">Total Downstream Growth Revenue</th><th>Total Downstream Operating Margin</th></tr></thead><tbody>"];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#fcfed0;\"><td style=\"padding:2px\">Year 1</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Annual Patients Year 1"], [results objectForKey:@"Growth Year 1"], [results objectForKey:@"Margins Year 1"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Year 2</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Annual Patients Year 2"], [results objectForKey:@"Growth Year 2"], [results objectForKey:@"Margins Year 2"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#fcfed0;\"><td style=\"padding:2px\">Year 3</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Annual Patients Year 3"], [results objectForKey:@"Growth Year 3"], [results objectForKey:@"Margins Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"</tbody></table></div><p style=\"font-size:12px; color:#666;\">30 percent of Downstream Reimbursement is calculated as Downstream Revenue</p>"]];
    
    NSString* strTableTitle;
    if (isCashOutlay) {
        strTableTitle = @"Three-Year Projection Assuming Cash Outlay";
    } else {
        strTableTitle = @"Three-Year Projection Assuming Fair Market Lease";
    }
    [emailBody appendString:[NSString stringWithFormat:@"<p style=\"width:100%%; text-align: center; font-weight:900; font-size: 18px; font-family: Helvetica, Arial, sans-serif; color:#08107B;\">%@</p>", strTableTitle]];
    
    /******************************Cash Outlay Table**********************/
    
    [emailBody appendString:@"<div><table style=\"width: 90%;border-top:1px solid #e5eff8; border-right:1px solid #e5eff8;\"><thead><tr style=\"background:#666; height: 30px;\"><th></th><th style=\"color:#eee;\">Year 1</th><th style=\"color:#eee;\">Year 2</th><th style=\"color:#eee;\">Year 3</th></tr></thead><tbody>"];
    
    [emailBody appendString:@"<tr><td style=\"padding:2px\"><span style=\"font-weight: 900; color:#08107B;\">Revenue</span></td><td style=\"padding:2px\"></td><td style=\"padding:2px\"></td><td style=\"padding:2px\"></td></tr>"];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Number of Patients Per Week</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Weekly Patients Year 1"], [results objectForKey:@"Weekly Patients Year 2"], [results objectForKey:@"Weekly Patients Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"padding:2px\">Number of Patients Per Year</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Annual Patients Year 1"], [results objectForKey:@"Annual Patients Year 2"], [results objectForKey:@"Annual Patients Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Total Facility Fee <br />(without modifiers)</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Facility Fee Year 1"], [results objectForKey:@"Facility Fee Year 2"], [results objectForKey:@"Facility Fee Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"padding:2px\">Total Physician Fees</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Physician Fee Year 1"], [results objectForKey:@"Physician Fee Year 2"], [results objectForKey:@"Physician Fee Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Total Anesthesia Fees</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Anesthesia Fee Year 1"], [results objectForKey:@"Anesthesia Fee Year 2"], [results objectForKey:@"Anesthesia Fee Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"padding:2px\">Downstream Operating Margin</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Growth Year 1"], [results objectForKey:@"Growth Year 2"], [results objectForKey:@"Growth Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"padding:2px\">Annual Operating Margin</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Annual Revenue Operating Margin Fee Year 1"], [results objectForKey:@"Annual Revenue Operating Margin Fee Year 1"], [results objectForKey:@"Annual Revenue Operating Margin Fee Year 1"]]];
    
    [emailBody appendString:@"<tr><td colspan=\"4\">&nbsp;</td></tr>"];
    
    [emailBody appendString:@"<tr><td style=\"padding:2px\"><span style=\"font-weight: 900; color:#08107B;\">Expenditure</span></td><td style=\"padding:2px\"></td><td style=\"padding:2px\"></td><td style=\"padding:2px\"></td></tr>"];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Equipment</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Equipment Total Year 1"], [results objectForKey:@"Equipment Total Year 2"], [results objectForKey:@"Equipment Total Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"padding:2px\">Labor</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Labor Total Year 1"], [results objectForKey:@"Labor Total Year 2"], [results objectForKey:@"Labor Total Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Service & Maintenance</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Service Total Year 1"], [results objectForKey:@"Service Total Year 2"], [results objectForKey:@"Service Total Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"padding:2px\">Other Variable Cost</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Variable Cost Per Patient Total Year 1"], [results objectForKey:@"Variable Cost Per Patient Total Year 2"], [results objectForKey:@"Variable Cost Per Patient Total Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Other Fixed Cost</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Additional Cost Per Patient Total Year 1"], [results objectForKey:@"Additional Cost Per Patient Total Year 2"], [results objectForKey:@"Additional Cost Per Patient Total Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"padding:2px\">Total Cost</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Total Cost Year 1"], [results objectForKey:@"Total Cost Year 2"], [results objectForKey:@"Total Cost Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr style=\"background:#ccc;\"><td style=\"padding:2px\">Annual Operating Margin</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Annual Expenditure Operating Margin Year 1"], [results objectForKey:@"Annual Expenditure Operating Margin Year 2"], [results objectForKey:@"Annual Expenditure Operating Margin Year 3"]]];
    
    [emailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"padding:2px\">Net Operating Margin</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td><td style=\"padding:2px\">%@</td></tr>", [results objectForKey:@"Net Operating Margin Year 1"], [results objectForKey:@"Net Operating Margin Year 2"], [results objectForKey:@"Net Operating Margin Year 3"]]];
    
    [emailBody appendString:@"</tbody></table></div>"];
    
    
    if (isPDF) {
        
        pdfTitle = [NSString stringWithFormat:@"eusValueResults_%@.pdf", facilityName];
        if (isCashOutlay) {
            pdfManager.strTableTitle = @"Three-Year Projection Assuming Cash Outlay";
        } else {
            pdfManager.strTableTitle = @"Three-Year Projection Assuming Fair Market Value Lease";
        }
        [pdfManager makePDF:pdfTitle:results];
    }
    
    //check to make sure the app can send email
    if ([MFMailComposeViewController canSendMail]) {
        
        //init a mail view controller
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        
        NSArray* bccRecipients = [[NSArray alloc] initWithObjects:@"steve.suranie@olympus.com", nil];
        
        [mailViewController setBccRecipients:bccRecipients];
        
        //set delegate
        mailViewController.mailComposeDelegate = self;
        
        [mailViewController setSubject:emailSubject];
        
        [mailViewController setMessageBody:emailBody isHTML:YES];
        
        if (isPDF) {
            
            //get path to pdf file
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* pdfFilePath = [documentsDirectory stringByAppendingPathComponent:pdfTitle];
            
            //convert pdf file to NSData
            NSData* pdfData = [NSData dataWithContentsOfFile:pdfFilePath];
            
            //attach the pdf file
            [mailViewController addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfTitle];
            
        }
        
        [self presentViewController:mailViewController animated:YES completion:NULL];
        
    } else {
        
        NSLog(@"Device is unable to send email in its current state.");
        
    }
    
    
    
    //}
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result){
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email was sent");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
            
        default:
            NSLog(@"Mail not sent");
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Web Views

- (void) showAssumptions : (UIGestureRecognizer*) theTap {
    
    webNotesFrame = webNotesSheet.frame;
    webNotesFrame.origin.x = self.view.frame.size.width-600.0;
    
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
        animations:^{
            webNotesSheet.frame = webNotesFrame;
        }
     
        completion:^ (BOOL finished) {

        }
     ];
    
}

- (void) closeAssumptions : (UIButton*) btnClose {
    
    webNotesFrame = webNotesSheet.frame;
    webNotesFrame.origin.x = self.view.frame.size.width;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
            animations:^{
                webNotesSheet.frame = webNotesFrame;
            }
     
            completion:^ (BOOL finished) {
            }
     ];
    
}

- (void) showReimbursements : (UIGestureRecognizer*) theTap {
    
    webReimbursementsFrame = webReimbursementsSheet.frame;
    webReimbursementsFrame.origin.x = self.view.frame.size.width-600.0;
    
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         webReimbursementsSheet.frame = webReimbursementsFrame;
                     }
     
                     completion:^ (BOOL finished) {
                         
                     }
     ];
    
}

- (void) closeReimbursements : (UIButton*) btnClose {
    
    webReimbursementsFrame = webReimbursementsSheet.frame;
    webReimbursementsFrame.origin.x = self.view.frame.size.width;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         webReimbursementsSheet.frame = webReimbursementsFrame;
                     }
     
                     completion:^ (BOOL finished) {
                     }
     ];
    
}


#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
