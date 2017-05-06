//
//  AuthViewController.h
//  Encrypted Messenger
//
//  Created by Yongyang Nie on 5/4/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDTextField.h"

@import FirebaseAuth;
@import FirebaseDatabase;

@interface AuthViewController : UIViewController <MDTextFieldDelegate>

@property (weak, nonatomic) IBOutlet MDTextField *username;
@property (weak, nonatomic) IBOutlet MDTextField *email;
@property (weak, nonatomic) IBOutlet MDTextField *password;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
