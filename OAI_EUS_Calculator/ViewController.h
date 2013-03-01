//
//  ViewController.h
//  OAI_EUS_Calculator
//
//  Created by Steve Suranie on 2/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>


#import "OAI_AlertScreen.h"
#import "OAI_FileManager.h"
#import "OAI_ColorManager.h"
#import "OAI_StringManager.h"
#import "OAI_SplashScreen.h"
#import "OAI_DataManager.h"
#import "OAI_MailManager.h"
#import "OAI_PDFManager.h"

#import "OAI_Label.h"
#import "OAI_TextField.h"
#import "OAI_ScrollView.h"
#import "OAI_TableCellInput.h"
#import "OAI_InfoButton.h"
#import "OAI_DropDownTable.h"


@interface ViewController : UIViewController <UIWebViewDelegate, UITextViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate, DropDownTableDelegate> {
    
    OAI_AlertScreen* alertManager;
    OAI_FileManager* fileManager;
    OAI_ColorManager* colorManager;
    OAI_StringManager* stringManager;
    OAI_DataManager* dataManager;
    OAI_MailManager* mailManager;
    OAI_PDFManager* pdfManager;
    OAI_DropDownTable* dropDownManager;
    
    OAI_SplashScreen* appSplashScreen;
    OAI_ScrollView* svCalculatorScroll;
    
    UIView* vAccount;
    
    UISegmentedControl* scCalculatorSections;
    UIView* vCalculator;
    float needsSplash;
    
    UIView* objectWrapper;
    UIImage* btnSummaryImg;
    UIImage* btnCalculatorImg;
    UIButton* btnCalculate;
    
    UIView* vSummaryScreen;
    UIButton* btnSwitchToCalc;
    
    UIView* vCalculatorScreen;
    UIView* vEquipmentSection;
    OAI_Label* lblCalculatorInstructions;
    NSMutableArray* placedSections;
    NSMutableArray* placedRows;
    NSMutableArray* placedCells;
    NSArray* table1StoredData;
    NSArray* table2StoredData;
    NSArray* table3StoredData;
    UIPopoverController* pvFacilities;
    NSMutableArray* thisCellTableItems;
    NSString* strThisFacility;

    CGRect myKeyboardFrame;
    UITextField* myTextElement;
    CGPoint myScrollViewOrigiOffSet;
    
    UIView* vInstructions;
    
    NSMutableArray* calcElements;
    NSMutableArray* resultsFields;
    NSMutableDictionary* results;
    
    NSDecimalNumberHandler* myDecimalHandler;
    float resultsTable1Height;
    float resultsTable2Height;
    UISegmentedControl* scCalcOptions;
        
    UIView* vMailOptions;
    UITextField* txtName;
    UITextField* txtFacility;
    UISegmentedControl* scPDFOptions;
    CGSize pageSize;
    NSString* pdfTitle;
    
    UIWebView* webNotes;
    CGRect webNotesFrame;
    UIView* webNotesSheet;
    
    UIWebView* webReimbursements;
    CGRect webReimbursementsFrame;
    UIView* webReimbursementsSheet;
    
    UILabel* lblResultType;
    
    BOOL isCashOutlay;
    
   
    
}



/**********************display methods****************/

- (void) showView : (UIButton* ) buttonTouched;

- (void) toggleViews : (UIView*) viewToShow : (UIView*) viewToHide;

- (void) clearDeck;

- (void) animateView : (UIView* ) thisView : (CGRect) thisFrame;

- (NSMutableDictionary*) getSectionProperties : (int) s;

- (void) buildSections : (NSMutableDictionary* ) sectionProperties : (UIView* ) sectionWrapper;

- (float) getTableWidth : (NSArray* ) thisTableData;

- (float) getMaxLabelWidth : (NSArray* ) thisTableData;

- (float) getMaxRowHeight : (NSArray*) thisTableData;

- (CGRect) buildFrameAndRows : (NSArray*) thisTableData : (float) tableWidth : (float) rowX : (float) rowY : (float) col1W : (float) headerRowHeight : (UIView*) sectionWrapper : (NSString*) thisSection : (NSArray*) rowsNeedingInstructions : (NSArray*) instructions;

- (void) setScrollViewHeight : (UIScrollView* ) thisScrollView;

- (float) getMaxResultsCol1Width : (NSArray*) col1Items;

- (NSMutableArray*) addResultsHeaders : (UIView*) headerParent : (NSArray*) headers : (float) maxCol1Width;

- (void) addResultsRows : (UIView*) rowParent : (NSArray*) rowNames : (float) maxCol1Width : (int) colCount : (NSArray*) rowHeaderWidths;

- (float) getTableHeight : (UIView*) thisTable;

- (void) checkKeyboardConflict;

- (void) resizeSegmentedControlSegments;

- (void) scrollToView : (UISegmentedControl*) control;

- (void) showInstructions : (OAI_InfoButton*) btnInfo;

- (void) closeInstructions : (UIButton*) btnClose;

- (void) openHospitalDropDown : (UITextField*) txtOpenDropDown;

- (void) displayValues : (NSMutableDictionary*) results;

- (void) showAssumptions : (UIGestureRecognizer*) theTap;

- (void) closeAssumptions : (UIButton*) btnClose;

- (void) showReimbursements : (UIGestureRecognizer*) theTap;

- (void) closeReimbursements : (UIButton*) btnClose;

- (void) toggleAccount : (UIButton*) btnAccount;


/***************Calculate and Conversion Methods**************************/

- (void) calculate;

- (NSString*) stripNonNumericCharacters : (NSString* ) stringToStrip;

- (NSDecimalNumber*) getProductByPercentage : (NSArray*) itemsToMultiply : (float) annualPatients;

- (NSDecimalNumber*) addNSDecimalNumbers : (NSArray*) itemsToAdd;

- (NSString*) convertToCurrencyString : (NSDecimalNumber*) numberToConvert;

- (NSString*) convertFloatToDisplayString : (float) floatToConvert;

- (void) sendEmail : (UIButton*) btn;

- (void) toggleEmailSetUp;

@end
