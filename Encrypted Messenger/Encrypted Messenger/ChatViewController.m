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

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView{
    return [self.bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row{
    return [self.bubbleData objectAtIndex:row];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.4 animations:^{
        self.height.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        self.height.constant = 300;
        [self.view layoutIfNeeded];
    }];
}

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
    
    self.bubbleData = [NSMutableArray array];
    
    //add an observer to the message data change. (The power of a real time database.)
    [[[[FIRDatabase database] reference] child:@"messages"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (![snapshot.value isKindOfClass:[NSNull class]] ) {
            
            NSDictionary *dictionary = snapshot.value;
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            
            for (int i = 0; i < dictionary.allKeys.count; i++) {
                
                if ([messages containsObject:[[dictionary allKeys] objectAtIndex:i]]) {
                    
                    NSDictionary *dic = [dictionary objectForKey:[[dictionary allKeys] objectAtIndex:i]];
                    [self.messages addObject:dic];
                    NSDate *date = [[self dateFormatter] dateFromString:[dic objectForKey:@"date"]];
                    
                    //find out who is the sender.
                    if ([[dic objectForKey:@"sender_id"] isEqualToString:[self.user objectForKey:@"UUID"]]) {
                        NSString *text = [self.rsa decryptString:[dic objectForKey:@"sender_content"] withKey:[userdefault objectForKey:@"key"] withN:[userdefault objectForKey:@"n"]];
                        NSBubbleData *bubbleData = [[NSBubbleData alloc] initWithText:text date:date type:BubbleTypeMine];
                        [self.bubbleData addObject:bubbleData];
                    }else{
                        NSString *text = [self.rsa decryptString:[dic objectForKey:@"receiver_content"] withKey:[userdefault objectForKey:@"key"] withN:[userdefault objectForKey:@"n"]];
                        NSBubbleData *bubbleData = [[NSBubbleData alloc] initWithText:text date:date type:BubbleTypeSomeoneElse];
                        [self.bubbleData addObject:bubbleData];
                    }
                }
            }
            [self.tableView reloadData];
        }
    }];
}

-(NSDateFormatter *)dateFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return formatter;
}

-(IBAction)sendMessage:(id)sender{
    
    //encrypt content with RSA. Two copies, one for the sender one for the reciever.
    NSMutableArray *content = [self.rsa encryptString:self.textField.text withPublicKey:[self.receiver objectForKey:@"public_key"] n:[self.receiver objectForKey:@"n"]];
    NSMutableArray *sender_content = [self.rsa encryptString:self.textField.text withPublicKey:[self.user objectForKey:@"public_key"] n:[self.user objectForKey:@"n"]];
    
    NSString *messageID = [[NSUUID UUID] UUIDString];
    
    //create and store the message.
    [[[[[FIRDatabase database] reference]
       child:@"messages"] child:messageID] setValue:@{@"message_id": messageID,
                                                      @"sender_id": [self.user objectForKey:@"UUID"],
                                                      @"receiver_id": [self.receiver objectForKey:@"UUID"],
                                                      @"receiver_content": content,
                                                      @"sender_content": sender_content,
                                                      @"date": [[self dateFormatter] stringFromDate:[NSDate date]]}];
    
    //update the conversation by adding the new message ID.
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
    
    self.bubbleData = [[NSMutableArray alloc] init];
    self.tableView.snapInterval = 100;
    self.tableView.showAvatars = NO;
    
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
