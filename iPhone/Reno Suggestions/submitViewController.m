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
    [myNewIdea saveIdeaField:textField.text withKey:@"where"];
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
    [myNewIdea saveIdeaField:textField.text withKey:@"what"];
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
    
     [pool release];
    NSData* newImageData = UIImagePNGRepresentation(newImage);

    [myNewIdea saveIdeaField:newImageData withKey:@"beforeImage"];

    return newImage;
}


-(IBAction) cancelButtonPressed; {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}
-(IBAction) submitButtonPressed; {
    NSLog(@"JJA debug - My new Idea  = %@",myNewIdea.idea);
    
    NSString*               newIdeaString = @"what:xyz";
    NSString*				json		= [NSString stringWithFormat:@"{%@}",newIdeaString];
	NSURL*					url			= [NSURL URLWithString:@"http://betareno.cyberhobo.net/wp-admin/admin-ajax.php?action=betareno-add-idea"];
	NSMutableURLRequest*	request		= [NSMutableURLRequest requestWithURL:url];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[NSData dataWithBytes:[json UTF8String] length:[json length]]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [json length]] forHTTPHeaderField:@"Content-Length"];
	
	NSError*				err			= nil;
	NSData*					response	= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
	
	if (response)
	{
		NSString*		resStr	= [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		NSDictionary*	resJSON	= [resStr JSONValue];
		NSLog(@"JJA POST check response : %@", resStr);
	}
     

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
    myNewIdea = [[Idea alloc]initIdea];
    
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
