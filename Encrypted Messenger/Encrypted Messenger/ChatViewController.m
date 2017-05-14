//
//  ChatViewController.m
//  Encrypted Messenger
//
//  Created by Yongyang Nie on 5/4/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        self.height.constant = 300;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bubbleCellid" forIndexPath:indexPath];
    
    NSDictionary *dic = [self.messages objectAtIndex:indexPath.row];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([[dic objectForKey:@"sender_id"] isEqualToString:[self.user objectForKey:@"UUID"]]) {
        cell.content.text = [self.rsa decryptString:[dic objectForKey:@"sender_content"] withKey:[userdefault objectForKey:@"key"] withN:[userdefault objectForKey:@"n"]];
    }else{
        cell.content.text = [self.rsa decryptString:[dic objectForKey:@"receiver_content"] withKey:[userdefault objectForKey:@"key"] withN:[userdefault objectForKey:@"n"]];
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

#pragma mark - Private

-(void)loadReceiver:(NSString *)receiverID{
    
    [[[[[FIRDatabase database] reference] child:@"users"] child:receiverID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.receiver = snapshot.value;
    }];
}

-(void)loadConversations{
    
    [[[[[FIRDatabase database] reference] child:@"conversations"] child:self.conversationID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *messages = [snapshot.value objectForKey:@"messages"];
        [self loadMessages:messages];
    }];
}

-(void)loadMessages:(NSMutableArray *)messages{
    
    [[[[FIRDatabase database] reference] child:@"messages"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (![snapshot.value isKindOfClass:[NSNull class]] ) {
            NSDictionary *dictionary = snapshot.value;
            NSMutableArray *content = [NSMutableArray array];
            for (int i = 0; i < dictionary.allKeys.count; i++) {
                if ([messages containsObject:[[dictionary allKeys] objectAtIndex:i]]) {
                    [content addObject:[dictionary objectForKey:[[dictionary allKeys] objectAtIndex:i]]];
                }
            }
            self.messages = content;
            [self.tableView reloadData];
        }
    }];
}

-(IBAction)sendMessage:(id)sender{
    
    NSMutableArray *content = [self.rsa encryptString:self.textField.text withPublicKey:[self.receiver objectForKey:@"public_key"] n:[self.receiver objectForKey:@"n"]];
    NSMutableArray *sender_content = [self.rsa encryptString:self.textField.text withPublicKey:[self.user objectForKey:@"public_key"] n:[self.user objectForKey:@"n"]];
    
    NSString *messageID = [[NSUUID UUID] UUIDString];
    [[[[[FIRDatabase database] reference]
       child:@"messages"] child:messageID] setValue:@{@"message_id": messageID,
                                                      @"sender_id": [self.user objectForKey:@"UUID"],
                                                      @"receiver_id": [self.receiver objectForKey:@"UUID"],
                                                      @"receiver_content": content,
                                                      @"sender_content": sender_content}];
    
    [[[[[FIRDatabase database] reference] child:@"conversations"] child:self.conversationID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *ms = [snapshot.value objectForKey:@"messages"];
        if (!ms) {
            ms = [NSMutableArray array];
        }
        [ms addObject:messageID];
        [[[[[[FIRDatabase database] reference] child:@"conversations"] child:self.conversationID] child:@"messages"] setValue:ms];
    }];
    
    self.textField.text = @"";
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    if ([[self.conversation objectForKey:@"sender"] isEqualToString:[[FIRAuth auth] currentUser].uid]){
        self.naviBar.title = [self.conversation objectForKey:@"receiver_name"];
        [self loadReceiver:[self.conversation objectForKey:@"receiver"]];
    }else{
        self.naviBar.title = [self.conversation objectForKey:@"sender_name"];
        [self loadReceiver:[self.conversation objectForKey:@"sender"]];
    }
    self.rsa = [[RSA alloc] init];
    [self loadConversations];
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
