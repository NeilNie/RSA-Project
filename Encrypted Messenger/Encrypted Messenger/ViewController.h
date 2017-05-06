//
//  ViewController.h
//  Encrypted Messenger
//
//  Created by Yongyang Nie on 4/28/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationTableViewCell.h"

@import FirebaseDatabase;
@import FirebaseAuth;

@interface ViewController : UIViewController

@property (strong, nonatomic) NSDictionary *currentUser;
@property (strong, nonatomic) NSMutableArray *conversations;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

