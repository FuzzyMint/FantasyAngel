//
//  FALoginViewController.m
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/18/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import "FALoginViewController.h"
#import "FAAppDelegate.h"
#import "FAStartupListViewController.h"
@interface FALoginViewController ()

@property (nonatomic, strong) UITextField *emailField;

@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableData *receivingData;

@end

@implementation FALoginViewController

@synthesize passwordField = _passwordField, emailField = _emailField, loginButton = _loginButton, registerButton = _registerButton;
@synthesize tableView = _tableView;
@synthesize email = _email, password = _password;
@synthesize receivingData=_receivingData;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 100) style:UITableViewStyleGrouped];
    self.tableView.scrollEnabled = NO;
    //self.tableView.rowHeight = 70.0f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_tableView setBackgroundView:nil];
    _tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self constructUIComponents];
    [self addUIComponentsToView:self.view];
    [self.view addConstraints:[self constraints]];
}


- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.accessoryView = self.emailField;
    }
    if (indexPath.row == 1) {
        cell.accessoryView = self.passwordField;
    }
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.passwordField) {
        [theTextField resignFirstResponder];
                [self attemptLogin];
    } else if (theTextField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    }
    return YES;
}

- (void) attemptLogin
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    self.receivingData = [[NSMutableData alloc] init];

    NSString *myParameters = [NSString stringWithFormat:@"email=%@&password=%@",self.emailField.text,self.passwordField.text];
    [request setURL:[NSURL URLWithString:@"http://localhost:3000/tokens.json"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivingData appendData:data];
    //the received data is added to receivingData
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *str = [[NSString alloc] initWithData:self.receivingData encoding:NSUTF8StringEncoding];
    
    if ([str rangeOfString:@"token"].location == NSNotFound) {
        NSLog(@"FAILED AUTH");
    } else {
        NSLog(@"SUCCESS %u", [str rangeOfString:@"token"].location);
        NSString *tokenString = [str substringFromIndex:[str rangeOfString:@"token"].location+8];
        
        NSInteger namePosition = [str rangeOfString:@"name"].location;
        
        
        NSString *tokenString = [str substringFromIndex:[str rangeOfString:@"name"].location+8];

        
        
        tokenString = [tokenString substringToIndex:tokenString.length - 2];
        [[NSUserDefaults standardUserDefaults] setObject: tokenString forKey: @"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject: self.email forKey: @"email"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        NSLog(tokenString);
    }

  
    NSLog(str);
    //We make the data a string
    //receivedData = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\n"]];
    //receivedData now has an array with every line of the request
    //You could do something with the data here, store it, or send it to another function
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    self.email = self.emailField.text;
    self.password = self.passwordField.text;
}


- (void) constructUIComponents
{
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.tintColor = [UIColor blackColor];
    self.registerButton.titleLabel.textColor = [UIColor blackColor];
    self.registerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
    
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
    self.emailField .placeholder = @"Email";
    self.emailField .autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.delegate = self;
    [self.emailField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.delegate = self;
    [self.passwordField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.passwordField setReturnKeyType:UIReturnKeyGo];
}

- (void) addUIComponentsToView:(UIView *)paramView{
    [paramView addSubview:self.registerButton];

    [self.tableView addSubview:self.emailField];
    [self.tableView addSubview:self.passwordField];
}

- (NSArray *) constraints{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [result addObjectsFromArray:[self startupLogoConstraints]];
    //[result addObjectsFromArray:[self descriptionConstraints]];
    //[result addObjectsFromArray:[self investButtonConstraints]];
   
    
    return [NSArray arrayWithArray:result];
    
}

- (NSArray *) startupLogoConstraints
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(_registerButton, _tableView);
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-[_registerButton(>=50)]-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tableView]-[_registerButton(>=50)]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    return [NSArray arrayWithArray:result];
}
/*- (NSArray *) descriptionConstraints
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(_startupDescription, _startupLogo);
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-[_startupDescription]-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_startupLogo]-[_startupDescription]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    return [NSArray arrayWithArray:result];
}
- (NSArray *) investButtonConstraints
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(_investButton, _startupDescription);
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-[_investButton]-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_startupDescription]-[_investButton]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    return [NSArray arrayWithArray:result];
}
*/
@end