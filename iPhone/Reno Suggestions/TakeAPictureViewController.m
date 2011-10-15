//
//  TakeAPictureViewController.m
//  ColorPixi
//
//  Created by John Angelo on 4/13/11.
//  Copyright 2011 Apps42, ltd. All rights reserved.
//

#import "TakeAPictureViewController.h"


@implementation TakeAPictureViewController

@synthesize myToolbar, imagePicker, colorView;


- (void)dealloc
{   
    [myToolbar release];
    [colorView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        UIImage *colorPixiTitleImage = [UIImage imageNamed:@"ColorPixi_logo_29.png"];
        CGRect topBarRec = CGRectMake(0,0,90.0,29.0);
        UIImageView *topBar = [[UIImageView alloc]initWithFrame:topBarRec];
        topBar.image = colorPixiTitleImage;
        self.navigationItem.titleView = topBar;
        self.navigationItem.backBarButtonItem.title = @"ColorPixi";
        [topBar release];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"received memory warning in take a picture view controller");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    colorView.backgroundColor  = [UIColor clearColor];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // camera is not on this device, don't show the camera button
        NSMutableArray *toolbarItems = [NSMutableArray arrayWithCapacity:self.myToolbar.items.count];
        [toolbarItems addObjectsFromArray:self.myToolbar.items];
        [toolbarItems removeObjectAtIndex:2];
        [self.myToolbar setItems:toolbarItems animated:NO];
    }
}
#pragma mark - Pick or click a picture
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self setupImagePicker:sourceType];
    }
}

- (IBAction)photoLibraryAction:(id)sender
{   
	[self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)cameraAction:(id)sender
{
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    self.imagePicker.sourceType = sourceType;
    
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

- (void)useImage:(UIImage *)image {
    /*NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Create a graphics image context
    CGSize newSize = CGSizeMake(320, 480);
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    //save the image color to the state variable
    UIColor *newColor = [self getAverageImageColor:newImage];
<<<<<<< HEAD
=======
   // [[State sharedState]setCurrentState:newColor forKey:@"currentColor"];
>>>>>>> 90915c54c40ca85cf306d53395c76f77ff11e6c9
    
    //push this color onto the color stack
    //[State sharedState]insertColorIntoStack:newColor];
    colorView.backgroundColor = newColor;
    
    [pool release];
     */
}

-(UIColor *) getAverageImageColor:(UIImage *)image {
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
	//manipulate the image
	int byteIndex = 0;
	int r = 0;
	int g = 0;
	int b = 0;
	int a = 0;
	float average_r, average_g, average_b, average_a = 0;
	int num_pixels = height * width; 
	
    for (int ii = 0 ; ii < width * height ; ++ii)
    {
		r = r + rawData[byteIndex];
		g = g + rawData[byteIndex+1];
		b = b + rawData[byteIndex+2];
		a = a + rawData[byteIndex+3];
        byteIndex += 4;
    }
	average_r = (r / num_pixels)/255.0f;
	average_g = (g / num_pixels)/255.0f;
	average_b = (b / num_pixels)/255.0f;
	average_a = (a / num_pixels)/255.0f;
    
	free(rawData);
    
    //send the rgb values to color manager to get the hsv values
	UIColor *averageColor = [[UIColor alloc] initWithRed:average_r green:average_g blue:average_b alpha:average_a];
	return [averageColor autorelease];
}

-(IBAction) cancelButtonpressed;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
