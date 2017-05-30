//
//  NewConversationViewController.m
//  Encrypted Messenger
//
//  Created by Yongyang Nie on 5/5/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "NewConversationViewController.h"

@interface NewConversationViewController ()

@end

@implementation NewConversationViewController

#pragma mark - UITableView

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"usercell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.users objectAtIndex:indexPath.row] objectForKey:@"username"];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate beginConversationWithUser:[self.users objectAtIndex:indexPath.row]];
    
    NSString *conversationid = [[NSUUID UUID] UUIDString];

    //update other user data
    NSMutableArray *conversations;
    if (![[self.users objectAtIndex:indexPath.row] objectForKey:@"conversations"])
        conversations = [NSMutableArray array];
    else
        conversations = [[self.users objectAtIndex:indexPath.row] objectForKey:@"conversations"];
    [conversations addObject:conversationid];
    
    //update database
    [[[[FIRDatabase.database.reference child:@"users"] child:[[self.users objectAtIndex:indexPath.row] objectForKey:@"UUID"]] child:@"conversations"] setValue:conversations];
    
    //update current user data
    NSMutableArray *userConversations;
    if (![self.currentUser objectForKey:@"conversations"])
        userConversations = [NSMutableArray array];
    else
        userConversations = [self.currentUser objectForKey:@"conversations"];
    [userConversations addObject:conversationid];
    
    //update current user database
    [[[[FIRDatabase.database.reference child:@"users"] child:[self.currentUser objectForKey:@"UUID"]] child:@"conversations"] setValue:userConversations];
    
    //add the conversation
    [[[FIRDatabase.database.reference child:@"conversations"] child:conversationid]
     setValue:@{@"sender": [self.currentUser objectForKey:@"UUID"],
                @"sender_name": [self.currentUser objectForKey:@"username"],
                @"receiver": [[self.users objectAtIndex:indexPath.row] objectForKey:@"UUID"],
                @"receiver_name": [[self.users objectAtIndex:indexPath.row] objectForKey:@"username"],
                @"messages": @[]}];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Created a new conversation" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

#pragma mark - Private

-(NSString *)randomPrime{
    
    return [RSA randomPrime].stringValue;
}

-(void)loadUserData{

    [[FIRDatabase.database.reference child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {

        self.users = [NSMutableArray array];
        for (NSString *string in [[snapshot value] allKeys]) {
            if (! [string isEqualToString:[self.currentUser objectForKey:@"username"]]) {
                [self.users addObject:[[snapshot value] objectForKey:string]];
            }
        }
        [self.tableView reloadData];

    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

-(void)loadCurrentUser{
    
    [[[FIRDatabase.database.reference child:@"users"] child:[[FIRAuth auth] currentUser].uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.currentUser = snapshot.value;
        NSLog(@"%@", self.currentUser);
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)viewDidLoad {
    
    [self loadUserData];
    [self loadCurrentUser];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
