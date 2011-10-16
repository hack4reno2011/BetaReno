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
@synthesize whatToDo;
@synthesize whoShouldDoIt;
@synthesize whenToDoIt;
@synthesize whereToDoIt;
@synthesize myNewIdea;
@synthesize beforeImageView;
@synthesize lastLongitude;
@synthesize lastLatitude;



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
    [cancelButton release];
    [cameraButton release];
    [submitButton release];
    [whenToDoIt release];
    [whoShouldDoIt release];
    [whenToDoIt release];
    [whereToDoIt release];
    [myNewIdea release];
    [beforeImageView release];
    [lastLongitude release];
    [lastLatitude release];
}

//capture the text input
#pragma mark - edit the name field
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    return;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [myNewIdea saveIdeaField:textField.text withKey:@"who"];
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - edit the notes field

-(void)textViewDidBeginEditing:(UITextView *)textField
{
    textField.text = @"";
    return;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    if ([textView.text length] > 139) {
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

-(void)textViewDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag == 0) {
        [myNewIdea saveIdeaField:textField.text withKey:@"what"];
    }
    else
    {
        [myNewIdea saveIdeaField:textField.text withKey:@"where"];
    }
    return;
}


//capture the photo
-(IBAction) takeAPictureButtonPressed; {
    
    //sourceType = UIImagePickerControllerSourceTypeCamera;
    if  ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        [self setupImagePicker:UIImagePickerControllerSourceTypeCamera]; 
        //[self showImagePicker:UIImagePickerControllerSourceTypeCamera];
       
    } else
    {
        [self setupImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
        //[self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
   
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    
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

-(UIImage*)useImage:(UIImage *)image;{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
     
     // Create a graphics image context
     CGSize newSize = CGSizeMake(500, 500);
     UIGraphicsBeginImageContext(newSize);
    
     // Tell the old image to draw in this new context, with the desired
     // new size
     [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
     
     // Get the new image from the context
     UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     // End the context
     UIGraphicsEndImageContext();
    
    beforeImageView.image = newImage;
    NSData* newImageData = UIImageJPEGRepresentation(newImage, 0.7);

    [myNewIdea saveIdeaField:newImageData withKey:@"beforeImage"];
    [pool release];
    return newImage;
}


-(IBAction) cancelButtonPressed; {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}
-(IBAction) submitButtonPressed; {
    

    NSLog(@"JJA debug L & L %@, %@",lastLongitude,lastLatitude);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://betareno.cyberhobo.net/wp-admin/admin-ajax.php?action=betareno-add-idea"]];
    [request setPostValue:@"BetaReno4hack4reno" forKey:@"api_key"];
    [request setPostValue:[myNewIdea.idea objectForKey:@"what"] forKey:@"what"];
    [request setPostValue:[myNewIdea.idea objectForKey:@"who"] forKey:@"who"];
    [request setPostValue:lastLatitude forKey:@"latitude"];
    [request setPostValue:lastLongitude forKey:@"longitude"];
    [request setPostValue:@"" forKey:@"when"];
    [request setData:[myNewIdea.idea objectForKey:@"before_photo"] withFileName:@"beforephoto.jpg" andContentType:@"image/jpeg" forKey:@"before_photo"];
    [request setPostValue:@"" forKey:@"after_photo"];
	[request setRequestMethod:@"POST"];

    [request startSynchronous];
    NSString *statusMessage = [request responseStatusMessage];
    NSString *response = [request responseString];
    NSLog ( @"JJA Response: %@", response );
    NSLog(@"JJA POST check response : %@", statusMessage);

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
    //create a new ideas object
    self.navigationController.navigationBarHidden = YES;
    myNewIdea = [[Idea alloc]initIdea];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardDidShow:)
                                                 name: UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector (keyboardDidHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];
    
}

-(void) keyboardDidShow: (NSNotification *)notif 
{
    // If keyboard is visible, return
    if (keyboardVisible) 
    {
        NSLog(@"Keyboard is already visible. Ignoring notification.");
        return;
    }
    
    // Get the size of the keyboard.
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // Save the current location so we can restore
    // when keyboard is dismissed
    offset = scrollview.contentOffset;
    
    // Resize the scroll view to make room for the keyboard
    CGRect viewFrame = scrollview.frame;
    viewFrame.size.height -= keyboardSize.height;
    scrollview.frame = viewFrame;
    
    // Keyboard is now visible
    keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif 
{
    // Is the keyboard already shown
    if (!keyboardVisible) 
    {
        NSLog(@"Keyboard is already hidden. Ignoring notification.");
        return;
    }
    
    // Reset the height of the scroll view to its original value
    scrollview.frame = CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
    
    // Reset the scrollview to previous location
    scrollview.contentOffset = offset;
    
    // Keyboard is no longer visible
    keyboardVisible = NO;	
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
