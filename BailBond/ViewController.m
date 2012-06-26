//
//  ViewController.m
//  BailBond
//
//  Created by  on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    sleep(1);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    if (!previewView) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            previewView = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController_iPhone" bundle:nil] ;
        } else {
            previewView = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController_iPad" bundle:nil] ;
        }
    }
    [super viewWillAppear:YES];
}

-(IBAction)ChooseGallery:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                      (__bridge NSString *) kUTTypeImage,nil];
            imagePicker.allowsEditing = NO;
            
            popController = [[UIPopoverController alloc]
                             initWithContentViewController:imagePicker];
            [popController presentPopoverFromRect:CGRectMake(0, 100, 523, 151) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        } else {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];

        }

                
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"The device does not have photo library" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        [alert release];
    }

    
}

-(IBAction)CaptureImage:(id)sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (__bridge NSString *) kUTTypeImage,nil];
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"The device does not support camera" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        [alert release];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [popController dismissPopoverAnimated:true];
    NSData *imageData =UIImageJPEGRepresentation(image, 1.0);
    previewView.previewData = imageData;
    [picker dismissModalViewControllerAnimated:YES];
    [self.navigationController pushViewController:previewView animated:NO];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return YES;
//    }
    if (interfaceOrientation== UIDeviceOrientationPortrait)
        return YES;
    else
        return NO;

}

-(void)dealloc{
    
    [data release];
    [previewView release];
    [super dealloc];
}

@end
