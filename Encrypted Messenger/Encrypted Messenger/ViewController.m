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
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.conversations.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - Private

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
        
        NSDictionary *conversations = [snapshot value];
        for (NSString *string in [self.currentUser objectForKey:@"conversations"]) {
            if ([[[conversations objectForKey:string] objectForKey:@"sender"] isEqualToString:[[FIRAuth auth] currentUser].uid]) {
                [self.conversations addObject:[[conversations objectForKey:string] objectForKey:@"receiver_name"]];
            }else{
                [self.conversations addObject:[[conversations objectForKey:string] objectForKey:@"sender_name"]];
            }
        }
        [self.tableView reloadData];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)viewDidLoad {
    
    
    [self loadCurrentUser];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
