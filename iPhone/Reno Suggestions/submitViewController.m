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
    return newImage;
}


-(IBAction) cancelButtonPressed; {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}
-(IBAction) submitButtonPressed; {
    
    /*
    
    NSString*				json		= [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receipt64];
	NSURL*					url			= [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
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
		int				status	= [[resJSON objectForKey:@"status"] intValue];
		self.receiptIsValid		= status == 0;
		self.transaction		= resStr;
		//NSLog(@"receipt check response : %@", resStr);
	}
     
     */
    
<<<<<<< HEAD
    // - get all data from cyberhobo.net - move this to a singelton?
    
    NSURL*					url			= [NSURL URLWithString:[NSString stringWithFormat:@"http://betareno.cyberhobo.net/wp-admin/admin-ajax.php?action=betareno-get-ideas&lat=39.524435&lng=-119.811745&r=5"]];
    //NSLog(@"JJA get suggestions url = %@",[url absoluteString] );
	NSMutableURLRequest*	request		= [NSMutableURLRequest requestWithURL:url];
	NSError*				err			= nil;
	NSData*					response	= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    
	
	if (err == nil)
	{
		NSString*		respString          = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSArray*        suggestionsArray	= [respString JSONValue];
        NSLog(@"JJA response from cyberhobo = %@",respString);

		for (int i = 0; i < [suggestionsArray count]; i++)
		{
			//pull data into view controller array.  
            NSLog(@"JJA response from cyberhobo = %@",respString);
            NSLog(@"JJA jason parsed as = %@",suggestionsArray);
		}
	}
    else
    {
        NSLog(@"JJA error from cyberhobo = %@",[err localizedDescription]);
    }
     
     

=======
    
>>>>>>> eb5db551dce862c42d55b2b83e15caa3408d4276
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
