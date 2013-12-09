//
//  ListsViewController.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "ListsViewController.h"

#import "ListManager.h"
#import "ListTableViewCell.h"
#import "SingleListViewController.h"

@interface ListsViewController ()

@property (nonatomic, strong) ListManager *listManager;
@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation ListsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _listManager = [ListManager sharedInstance];
   // _lists = [[_listManager getLists] mutableCopy];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewList:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Lists"
                                     style: UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     _lists = [[_listManager getLists] mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewList:(id)sender
{
    [self performSegueWithIdentifier:@"AddList" sender:sender];
}

- (IBAction)returned:(UIStoryboardSegue *)segue
{
    _lists = [[_listManager getLists] mutableCopy];
    [self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        // remove the + button
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewList:)];
        self.navigationItem.rightBarButtonItem = addButton;
        
        _lists = [[_listManager getLists] mutableCopy];
        [self.tableView reloadData];
    }
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellIdentifier = @"listCellIdentifier";
 
	ListTableViewCell *cell = (ListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	cell.list = [_lists objectAtIndex:indexPath.row];

	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ToDoList *toDelete = [_lists objectAtIndex:indexPath.row];
        [_lists removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[ListManager sharedInstance] deleteList:toDelete];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showList"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ToDoList *list = [_lists objectAtIndex:indexPath.row];
        
        SingleListViewController *vc = [segue destinationViewController];
        
        [vc setList:list];
    }
}

@end
