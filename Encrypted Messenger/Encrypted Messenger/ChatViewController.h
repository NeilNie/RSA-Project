//
//  ChatViewController.h
//  Encrypted Messenger
//
//  Created by Yongyang Nie on 5/4/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBubbleTableViewCell.h"
#import "RSA.h"

@import FirebaseAuth;
@import FirebaseDatabase;

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) RSA *rsa;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSString *conversationID;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSDictionary *conversation;
@property (nonatomic, strong) NSDictionary *receiver;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@end
