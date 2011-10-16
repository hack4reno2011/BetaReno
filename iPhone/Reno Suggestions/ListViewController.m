//
//  ListViewController.m
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import "ListViewController.h"

@implementation ListViewController

@synthesize mapButton;
@synthesize listButton;
@synthesize suggestionButton;
@synthesize search;
@synthesize ideasTable;
@synthesize currentLongitude;
@synthesize currentLatitude;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc
{
    
}

//actions

-(IBAction)mapButtonPressed:(id)sender;
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(IBAction)listButtonPressed:(id)sender;
{
    return;
}
-(IBAction)suggestionButtonPressed:(id)sender;
{
    submitViewController *vc = [[[submitViewController alloc] initWithNibName:@"submitViewController" bundle:nil] autorelease];
    vc.lastLongitude = currentLongitude;
    vc.lastLatitude = currentLatitude;
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentModalViewController:navController animated:YES];
    
    return;
}

//Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //NSLog(@"JJA debug list count = %i",[ideasList count]);
	return [ideasList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    Idea* thisIdea = [ideasList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    cell.textLabel.text = [thisIdea objectForKey:@"what"];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Idea* thisIdea = [ideasList objectAtIndex:indexPath.row];
    ShowIdeaViewController *vc = [[[ShowIdeaViewController alloc] initWithNibName:@"ShowIdeaViewController" bundle:nil] autorelease];
    
    vc.strURL = [NSString stringWithFormat:@"%@/?p=%@",kSuggestionsBaseURL,[thisIdea objectForKey:@"ID"]];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentModalViewController:navController animated:YES];
    
    return;

    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    ideasTable.rowHeight = kRowHeight;
    ideasList = [[AllIdeas sharedIdeas]getListOfIdeas:currentLongitude withLat:currentLatitude andRadius:kRadius];
    [ideasTable reloadData];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
