//
//  RSViewController.h
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/14/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView*            suggestionsTable;
    UISearchBar*            search;
    UIButton*               cameraButton;
    UIButton*               locationButton;
    UIButton*               suggestionButton;
    
}

@property (nonatomic, retain)   IBOutlet UIButton*      cameraButton;
@property (nonatomic, retain)   IBOutlet UIButton*      locationButton;
@property (nonatomic, retain)   IBOutlet UIButton*      suggestionButton;
@property (nonatomic, retain)   IBOutlet UISearchBar*   search;
@property (nonatomic, retain)   IBOutlet UITableView*   suggestionsTable;


-(IBAction)cameraButtonPressed:(id)sender;
-(IBAction)locationButtonPressed:(id)sender;
-(IBAction)suggestionButtonPressed:(id)sender;


@end
