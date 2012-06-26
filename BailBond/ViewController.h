//
//  ViewController.h
//  BailBond
//
//  Created by  on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSData *data;
    PreviewViewController *previewView;
    UIPopoverController *popController;
}

-(IBAction)ChooseGallery:(id)sender;
-(IBAction)CaptureImage:(id)sender;

@end
