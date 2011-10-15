//
//  submitViewController.m
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import "submitViewController.h"


@implementation submitViewController
@synthesize cancelButton;
@synthesize cameraButton;
@synthesize submitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    
}

-(IBAction) takeAPictureButtonPressed; {
    
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    
}

#pragma mark - Pick or click a picture
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self setupImagePicker:sourceType];
    }
}

- (void)photoLibraryAction:(id)sender
{   
	[self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    self->imagePicker.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // user wants to use the camera interface
        imagePicker.allowsEditing = YES;
        mediaTypeCamera = YES;
        imagePicker.showsCameraControls = YES;
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
    } else
    {
        //use the image library
        imagePicker.allowsEditing = YES;
        mediaTypeCamera = NO;
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction) cancelButtonPressed; {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}
-(IBAction) submitButtonPressed; {
    
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
