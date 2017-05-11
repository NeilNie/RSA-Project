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

-(void)loadConversations{
    
    [[[[[FIRDatabase database] reference] child:@"conversations"] child:self.conversationID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *messages = [snapshot.value objectForKey:@"messages"];
    }];
}

-(IBAction)sendMessage:(id)sender{
    
    NSMutableArray *content = [self.rsa encryptString:self.textField.text withPublicKey:[self.conversation objectForKey:@"public_key"]];
    
    NSString *messageID = [[NSUUID UUID] UUIDString];
    [[[[[FIRDatabase database] reference] child:@"messages"] child:messageID] setValue:@{@"message_id": messageID,
                                                                                         @"sender_id": [self.user objectForKey:@"UUID"],
                                                                                         @"receiver_id": [self receiverID],
                                                                                         @"concent": content}];
    [self.messages addObject:@{@"message_id": messageID,
                               @"sender_id": [self.user objectForKey:@"UUID"],
                               @"receiver_id": [self receiverID],
                               @"concent": self.textField.text}];
    
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
        self.receiverID = [self.conversation objectForKey:@"receiver"];
    }else{
        self.naviBar.title = [self.conversation objectForKey:@"sender_name"];
        self.receiverID = [self.conversation objectForKey:@"sender"];
    }
    self.rsa = [[RSA alloc] init];
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
