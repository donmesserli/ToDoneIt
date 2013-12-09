//
//  AddListViewController.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "AddListViewController.h"

#import "ListManager.h"

@interface AddListViewController ()
@property (weak, nonatomic) IBOutlet UITextField *listNameTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@end

@implementation AddListViewController

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
	// Do any additional setup after loading the view.
    _listNameTextField.delegate = self;
    [_listNameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (sender != _doneButton) return YES;
    
    BOOL bReturn = YES;
    
    if (_listNameTextField.text.length > 0) {
        if ([[ListManager sharedInstance] listExistsWithName:_listNameTextField.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[NSString stringWithFormat:@"A list named '%@' already exists.", _listNameTextField.text] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            bReturn = NO;
        }
    }
    
    return bReturn;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != _doneButton) return;
    
    if (_listNameTextField.text.length > 0) {
        [[ListManager sharedInstance] addList:_listNameTextField.text];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];
    return YES;
}
@end
