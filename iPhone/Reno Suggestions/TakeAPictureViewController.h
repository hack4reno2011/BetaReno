//
//  TakeAPictureViewController.h
//  ColorPixi
//
//  Created by John Angelo on 4/13/11.
//  Copyright 2011 Apps42, ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "State.h"
#import <QuartzCore/QuartzCore.h>


@interface TakeAPictureViewController : UIViewController 
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    IBOutlet UIToolbar      *myToolbar;
    IBOutlet UIView         *colorView;
    BOOL                    mediaTypeCamera;
    UIImagePickerController *imagePicker;
}



@property (nonatomic, retain) IBOutlet UIToolbar *myToolbar;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIView *colorView;



-(IBAction) cancelButtonpressed;
-(UIColor *) getAverageImageColor:(UIImage *)image;
-(void) setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

@end
