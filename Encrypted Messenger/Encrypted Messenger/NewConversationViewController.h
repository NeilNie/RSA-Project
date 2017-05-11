//
//  NewConversationViewController.h
//  Encrypted Messenger
//
//  Created by Yongyang Nie on 5/5/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSA.h"
#import "BigInteger.h"

@import FirebaseDatabase;
@import FirebaseAuth;

@interface NewConversationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) FIRDatabase *database;
@property (retain, nonatomic) id delegate;
@property (strong, nonatomic) NSDictionary *currentUser;

@end

@protocol NewConversationViewControllerDelegate <NSObject>

-(void)beginConversationWithUser:(NSDictionary *)userid;

@end
