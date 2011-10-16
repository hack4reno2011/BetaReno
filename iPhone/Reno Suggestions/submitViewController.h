//
//  submitViewController.h
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "Idea.h"
#import "RSViewController.h"
#import "ASIFormDataRequest.h"

@interface submitViewController : UIViewController 
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, 
    UITextFieldDelegate, UITextViewDelegate>

#define SCROLLVIEW_HEIGHT 460
#define SCROLLVIEW_WIDTH  320

#define SCROLLVIEW_CONTENT_HEIGHT 720
#define SCROLLVIEW_CONTENT_WIDTH  320

{
    Idea*   myNewIdea;
    
    IBOutlet    UITextView*     whatToDo;
    IBOutlet    UITextField*    whenToDoIt;
    IBOutlet    UITextField*    whoShouldDoIt;
    IBOutlet    UITextView*     whereToDoIt;
    IBOutlet    UIImageView*    beforeImageView;
    
    UIButton*                   cancelButton;
    UIButton*                   cameraButton;
    UIButton*                   submitButton;
    
    BOOL                                mediaTypeCamera;
    UIImagePickerController*           imagePicker;
    
    BOOL            keyboardVisible;
    CGPoint         offset;
    UIScrollView    *scrollview;
    
    NSString*       lastlongitude;
    NSString*       lastLatitude;
}

 
@property (nonatomic, retain) IBOutlet UIButton* cancelButton;
@property (nonatomic, retain) IBOutlet UIButton* cameraButton;
@property (nonatomic, retain) IBOutlet UIButton* submitButton;
@property (nonatomic, retain) UITextView*   whatToDo;
@property (nonatomic, retain) UITextField*  whenToDoIt;
@property (nonatomic, retain) UITextField*  whoShouldDoIt;
@property (nonatomic, retain) UITextView*   whereToDoIt;
@property (nonatomic, retain) Idea*         myNewIdea;
@property (nonatomic, retain) UIImageView*  beforeImageView;
@property (nonatomic, retain) NSString* lastLongitude;
@property (nonatomic, retain) NSString* lastLatitude;

-(IBAction) takeAPictureButtonPressed;
-(IBAction) cancelButtonPressed;
-(IBAction) submitButtonPressed;

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType;
- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;
- (void)photoLibraryAction:(id)sender;
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
-(UIImage*)useImage:(UIImage *)image;

@end
