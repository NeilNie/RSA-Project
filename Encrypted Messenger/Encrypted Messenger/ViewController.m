//
//  ViewController.m
//  Encrypted Messenger
//
//  Created by Yongyang Nie on 4/28/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conversationCell" forIndexPath:indexPath];
    if ([[[self.conversations objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:[[FIRAuth auth] currentUser].uid]) {
        cell.title.text = [[self.conversations objectAtIndex:indexPath.row] objectForKey:@"receiver_name"];
    }else{
        cell.title.text = [[self.conversations objectAtIndex:indexPath.row] objectForKey:@"sender_name"];
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conversations.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"conversationsegue" sender:nil];
    });
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - Private

-(IBAction)logOut:(id)sender{
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
    }
}

-(void)loadCurrentUser{
    
    [[[FIRDatabase.database.reference child:@"users"] child:[[FIRAuth auth] currentUser].uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.currentUser = snapshot.value;
        NSLog(@"%@", self.currentUser);
        [self loadConversations];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

-(void)loadConversations{
    
    [[FIRDatabase.database.reference child:@"conversations"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.conversationData = [snapshot value];
        if ([self.currentUser objectForKey:@"conversations"] != nil) {
            for (NSString *string in [self.currentUser objectForKey:@"conversations"]) {
                [self.conversations addObject:[self.conversationData objectForKey:string]];
            }
        }
        
        [self.tableView reloadData];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self loadCurrentUser];
    self.conversations = [NSMutableArray array];
    self.conversationData = [NSDictionary dictionary];
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue destinationViewController] isKindOfClass:[ChatViewController class]]) {
        ChatViewController *vc = [segue destinationViewController];
        vc.conversation = [self.conversations objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        vc.conversationID = [[self.currentUser objectForKey:@"conversations"] objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        vc.user = self.currentUser;
    }
}

@end
