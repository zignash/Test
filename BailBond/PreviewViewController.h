//
//  PreviewViewController.h
//  BailBond
//
//  Created by  on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PreviewViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    IBOutlet UIImageView *myImage;
    NSData *data;
    CGSize pageSize;
}

@property (strong, nonatomic) NSData *previewData;

-(IBAction)Convert:(id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
@end
