//
//  ListViewController.h
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "submitViewController.h"
#import "ShowIdeaViewController.h"
#import "AllIdeas.h"
#import "Idea.h"

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView*            ideasTable;
    UISearchBar*            search;
    UIButton*               mapButton;
    UIButton*               listButton;
    UIButton*               suggestionButton;
    NSString*               currentLongitude;
    NSString*               currentLatitude;
    NSArray*                ideasList;
    
}

@property (nonatomic, retain)   IBOutlet UIButton*      mapButton;
@property (nonatomic, retain)   IBOutlet UIButton*      listButton;
@property (nonatomic, retain)   IBOutlet UIButton*      suggestionButton;
@property (nonatomic, retain)   IBOutlet UISearchBar*   search;
@property (nonatomic, retain)   IBOutlet UITableView*   ideasTable;
@property (nonatomic, retain)   NSString*               currentLongitude;
@property (nonatomic, retain)   NSString*               currentLatitude;


-(IBAction)mapButtonPressed:(id)sender;
-(IBAction)listButtonPressed:(id)sender;
-(IBAction)suggestionButtonPressed:(id)sender;


@end
