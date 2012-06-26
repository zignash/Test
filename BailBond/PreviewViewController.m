//
//  PreviewViewController.m
//  BailBond
//
//  Created by  on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PreviewViewController.h"
#define kBorderInset            10.0
#define kBorderWidth            1.0
@interface PreviewViewController ()

@end

@implementation PreviewViewController

@synthesize previewData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    myImage.image = [UIImage imageWithData:previewData];
    [super viewWillAppear:YES];
}

-(IBAction)Convert:(id)sender{
    [self generatePdfWithFilePath];
    NSString *fileName = [NSString stringWithFormat:@"Document.pdf"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:fileName];
    data = [[NSData alloc]initWithContentsOfFile:documentsDirectory];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            [self displayComposerSheet];
        } else {
            [self launchMailAppOnDevice];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Bail Bond" message:@"Email not configured, Please configure it" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

-(void)displayComposerSheet{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc]init];
	picker.mailComposeDelegate = self;
    NSArray *toRecipients = [NSArray arrayWithObject:@"payments@abetteronline.com"];
    [picker setToRecipients:toRecipients];
    [picker setSubject:@"Bail Bond"];
    [picker addAttachmentData:data mimeType:@"application/pdf" fileName:@"Document.pdf"];
    [self presentModalViewController:picker animated:YES];
    
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Email Cancelled" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            break;
        }
        case MFMailComposeResultSaved:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Email Saved" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            break;
        }
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Email Sent" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            break;
        }
        case MFMailComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Email failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            break;
        }
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Email not sent" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            break;
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)launchMailAppOnDevice{
    
    NSString *recipients = @"mailto:payments@abetteronline.com";
    NSString *email = [NSString stringWithFormat:@"%@",recipients];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation== UIDeviceOrientationPortrait)
        return YES;
    else
        return NO;
}

- (void) generatePdfWithFilePath{
    @try {  
        pageSize = CGSizeMake(612, 792);
        NSString *fileName = @"Document.pdf";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *pdfFilename = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        UIGraphicsBeginPDFContextToFile(pdfFilename, CGRectZero, nil);
        
        BOOL done = NO;
        do 
        {
            //Start a new page.
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
            
            //Draw a border for each page.
            [self drawBorder];
            
            //Draw an image
            [self drawImage];
            
            //Draw underline
            //[self drawunderLine];
            done = YES;
        } 
        while (!done);
        
        // Close the PDF context and write the contents out.
        UIGraphicsEndPDFContext();
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
}


#pragma mark - 
#pragma mark - Private Methods
#pragma mark - 

- (void) drawBorder
{
    @try {
        CGContextRef    currentContext = UIGraphicsGetCurrentContext();
        UIColor *borderColor = [UIColor brownColor];
        
       CGRect rectFrame = CGRectMake(kBorderInset, kBorderInset, pageSize.width-kBorderInset*2, pageSize.height-kBorderInset*2);
        
        CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor);
        CGContextSetLineWidth(currentContext, kBorderWidth);
        CGContextStrokeRect(currentContext, rectFrame);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}

- (void) drawImage
{
    @try {
        [myImage.image drawInRect:CGRectMake(kBorderInset, kBorderInset, pageSize.width-kBorderInset*2, pageSize.height-kBorderInset*2)];
        }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}




@end
