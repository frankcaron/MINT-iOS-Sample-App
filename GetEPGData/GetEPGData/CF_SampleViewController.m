//
//  CF_SampleViewController.m
//  GetEPGData
//
//  Created by  on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CF_SampleViewController.h"
#import "CF_SampleRESTConnector.h"

@interface CF_SampleViewController ()

@end

@implementation CF_SampleViewController {
    
    //Table Data
    NSArray *tableData;
    
    //Connector
    CF_SampleRESTConnector *connector;
}


//---------------------------------------
//Synthesize UI Elements
//---------------------------------------
@synthesize getEPGButton;
@synthesize EPGTable;

//---------------------------------------
//Basic Controller Maintenance
//---------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Configure temp table data
    tableData = nil;
}

- (void)viewDidUnload
{
    [self setGetEPGButton:nil];
    [self setEPGTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

//---------------------------------------
// Table Methods
//---------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *strItem = [[NSString alloc] initWithFormat:@"item%d", indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strItem];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strItem];
    }
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

//---------------------------------------
// Button Actions
//---------------------------------------

// =====================================================================
//
// getEPGData
//
// This function creates an authenticated session with the MINT REST API,
// and then polls for and parses the EPG data available for the current moment.
// 
// =====================================================================

- (IBAction)getEPGData:(id)sender {
    
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ REST Impl ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    //Instantiate REST connector
    connector = [[CF_SampleRESTConnector alloc] init];
    
    // Start REST session with MINT
    [connector createAuthRESTSession];
    			
    // Fetch EPG Data
    NSData* responseData = [connector getRESTEPGData];
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ /REST Impl ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Parsing ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    NSError *error = nil;
    
    //Parse EPG Data 
    NSDictionary *jsonObjectDic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSDictionary *scheduleDic = [jsonObjectDic valueForKey:@"schedules"];
    
    //NSLog(@"scheduleDic has: %@", scheduleDic);
    
    //Get the array of channels
    NSArray *channelArray = [scheduleDic valueForKey:@"channelId"];
    
    //Create a string array from channels
    NSMutableArray *channelStringArray = [[NSMutableArray alloc] init];
    int counter = 0;
        
    for (id __strong channel in channelArray) {
        
        NSString* myNewString = [NSString stringWithFormat:@"Channel %@", channel];
        //NSLog(@"string creation: %@", myNewString);
        
        [channelStringArray insertObject: myNewString atIndex: counter];
        counter = counter + 1;
        
        //NSLog(@"counter: %d", counter);
    } 
    
    //Get the dictionaries of programs
    NSArray *programIdDic = [scheduleDic valueForKey:@"programId"];
    NSDictionary *programObjectDic = [jsonObjectDic valueForKey:@"programs"];
    
    //Do
    //NSLog(@"ProgramObjDic: %@", programObjectDic);
    //NSLog(@"ProgramDic: %@", programIdDic);
    
    //Create two dimensional array of program IDs and Titles
    NSArray *titleAndProgramIdArray = [NSArray arrayWithObjects:[programObjectDic valueForKey:@"title"], [programObjectDic valueForKey:@"id"], nil];
    
    //NSLog(@"Titles: %@", titleAndProgramIdArray);
   
    //Create a string array from programs
    NSMutableArray *programArray = [[NSMutableArray alloc] init];
    counter = 0;
    
    //Loop through array, compare values, pull titles into programArray
    
    //NSNumber *idToCheck = [titleAndProgramIdArray objectAtIndex:1];
    //NSLog(@"Lulz: %@", idToCheck);
    //NSLog(@"Lulz2: %@", programIdDic);
    
    for (int i=0; i<[[titleAndProgramIdArray objectAtIndex:1] count]; i++) {
        
        NSNumber *currentValue = [[titleAndProgramIdArray objectAtIndex:1] objectAtIndex:i];
        //NSLog(@"Looking for show number: %@", currentValue);
        
        //NSLog(@"programIdDic count: %d values: %@", [programIdDic count], programIdDic);
              
        for (int j=0; j<[programIdDic count]; j++) {
            
            //NSLog(@"increment %d", j);
            
            NSNumber *compareValue = [programIdDic objectAtIndex:j];
            
            //NSLog(@"Comparing programId %@ against programId %@", currentValue, compareValue);
            
            if ([currentValue intValue] == [compareValue intValue]) {
                
                //NSLog(@"Match found");
                
                //Capture title
                NSString *temp = [[titleAndProgramIdArray objectAtIndex:0] objectAtIndex:i];
                //
                //NSLog(@"addingToArray: %@", temp);
                //Insert into array
                [programArray insertObject: temp atIndex: counter];
                counter = counter + 1;
                
                break;
            }
        }
        
        //NSLog(@"Looping");
        
    }    

    
    //NSArray *channel
    //NSLog(@"Program Array has: %@", programArray);
    
    //Concatenate the arrays
    counter = 0;
    
    //NSLog(@"%d", [channelArray count]);
    //NSLog(@"%d", [programArray count]);
    
    
    for (id __strong channel in channelArray) {
        
        NSString *programTitle;
        
        if (counter < [programArray count]) {
            programTitle = [programArray objectAtIndex:counter];
        } else {
            programTitle = @"N/A";
        }
            
        
        NSString *channelListing = [NSString stringWithFormat:@"Channel %@ - %@", channel, programTitle];
        
        [channelStringArray replaceObjectAtIndex:counter withObject:channelListing];
        counter = counter + 1;
        
        //NSLog(@"counter: %d", counter);
    } 
     
 

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Display ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    //Refresh Data
   
    tableData = channelStringArray;
    [EPGTable reloadData];
    
    
}

@end
