//
//  AddItemViewController.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "AddItemViewController.h"

#import "ToDoList.h"
#import "ToDoItem.h"

@interface AddItemViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;

@end

@implementation AddItemViewController

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
    
    if (_itemNameTextField.text.length > 0) {
        if ([_list itemExistsWithDescription:_itemNameTextField.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[NSString stringWithFormat:@"An item '%@' already exists.", _itemNameTextField.text] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            bReturn = NO;
        }
    }
    
    return bReturn;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != _doneButton) return;
    
    if (_itemNameTextField.text.length > 0) {
        [ToDoItem createItemWithDescription:_itemNameTextField.text inList:self.list];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
