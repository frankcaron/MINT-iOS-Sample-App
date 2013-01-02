//
//  CF_SampleViewController.h
//  GetEPGData
//
//  Created by  on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CF_SampleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//Properties
@property (weak, nonatomic) IBOutlet UIButton *getEPGButton;
@property (weak, nonatomic) IBOutlet UITableView *EPGTable;

//Methods
- (IBAction)getEPGData:(id)sender;

@end
