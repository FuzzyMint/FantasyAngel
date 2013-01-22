//
//  FAStartupDetailController.m
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/19/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import "FAStartupDetailController.h"
#import "FAStartup.h"
#import "FAInvestment.h"
#import "FAResponseObject.h"

@interface FAStartupDetailController ()

@property (nonatomic, strong) UIImageView *startupLogo;

@property (nonatomic, strong) UILabel *startupDescription;

@property (nonatomic, strong) UIButton *investButton;

@property (nonatomic, strong) UITextField *investAmountField;

@end

@implementation FAStartupDetailController

@synthesize startup = _startup, startupDescription = _startupDescription, investAmountField = _investAmountField;

- (id) initWithStartup:(FAStartup *) startup;
{
    self = [super init];
    if (self) {
        self.startup = startup;
    }
    return self;
}
/*
- (void)loadView
{
    CGRect windowrect = [[UIScreen mainScreen] applicationFrame];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, windowrect.size.width, windowrect.size.height-self.navigationController.navigationBar.frame.size.height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    [self.view sizeToFit];
   /*I NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(scrollView);
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:[scrollView]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[scrollView]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    return [NSArray arrayWithArray:result];*/
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self constructUIComponents];
    [self addUIComponentsToView:self.view];
    [self.view addConstraints:[self constraints]];
}

- (void) constructUIComponents
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelInvest)];
    
    self.navigationItem.title = self.startup.name;
    
    self.startupDescription = [[UILabel alloc] init];
    self.startupDescription.text = self.startup.high_concept;
    self.startupDescription.numberOfLines = 0;
    self.startupDescription.preferredMaxLayoutWidth = self.view.frame.size.width - 40;
    self.startupDescription.translatesAutoresizingMaskIntoConstraints = NO;
    //self.startupDescription.backgroundColor = [UIColor lightGrayColor];
    self.startupDescription.textAlignment = NSTextAlignmentCenter;
    
    self.investButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.investButton.tintColor = [UIColor blackColor];
    self.investButton.titleLabel.textColor = [UIColor blackColor];
    self.investButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.investButton setTitle:@"Invest 50k" forState:UIControlStateNormal];
    [self.investButton addTarget:self action:@selector(makeInvestment) forControlEvents:UIControlEventTouchUpInside];

    self.startupLogo = [[UIImageView alloc] init];
    self.startupLogo.translatesAutoresizingMaskIntoConstraints = NO;
    self.startupLogo.contentMode = UIViewContentModeCenter;
    [self.startupLogo setImageWithURL:[NSURL URLWithString:self.startup.thumb_url] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
    self.investAmountField = [[UITextField alloc] init];
    self.investAmountField.placeholder = @"Enter amount";
    self.investAmountField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.investAmountField.delegate = self;
    self.investAmountField.translatesAutoresizingMaskIntoConstraints=NO;
    self.investAmountField.keyboardType = UIKeyboardTypeNumberPad;
    self.investAmountField.borderStyle = UITextBorderStyleRoundedRect;
    
    /*NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.startup.thumb_url]];
    
    [self.startupLogo setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.startupLogo.image = image;
        [self.startupLogo updateConstraints];
    } failure:nil]; */
}

- (void) addUIComponentsToView:(UIView *)paramView{
    [paramView addSubview:self.startupLogo];
    [paramView addSubview:self.startupDescription];
    [paramView addSubview:self.investButton];
    //[paramView addSubview:self.investAmountField];
}

- (NSArray *) constraints{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];

    [result addObjectsFromArray:[self startupLogoConstraints]];
    [result addObjectsFromArray:[self descriptionConstraints]];
    //[result addObjectsFromArray:[self investAmountFieldConstraints]];
    [result addObjectsFromArray:[self investButtonConstraints]];

    
    NSLayoutConstraint *centerXConstraint =
    [NSLayoutConstraint constraintWithItem:self.startupLogo
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0f
                                  constant:0.0f];
    [result addObject:centerXConstraint];

    
    return [NSArray arrayWithArray:result];
    
}

-(void) makeInvestment
{
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[FAResponseObject class]];
    [responseMapping addAttributeMappingsFromArray:@[@"message"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:@"/investments" keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"amount",@"startup_id"]];
    
    // For any object of class Article, serialize into an NSMutableDictionary using the given mapping and nest
    // under the 'article' key path
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[FAInvestment class] rootKeyPath:@"investment"];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost:3000"]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    FAInvestment *investment = [[FAInvestment alloc] init];
    investment.amount = 50000;
    investment.startup_id = [self.startup.id intValue];
    investment.startupname = self.startup.name;
    investment.username = 
    //investment.startupAssociatedWith =  self.startup;
                                
    // POST to create    
    NSString * authtoken = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
   // NSLog(authtoken);/*
    NSDictionary *params = @{@"auth_token" : authtoken};
    
    [manager postObject:investment path:@"/investments" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Success Post");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Fail post");
    }];
                                
}

-(void) cancelInvest
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *) startupLogoConstraints
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(_startupLogo);
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-[_startupLogo(>=50)]-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_startupLogo(>=50)]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    return [NSArray arrayWithArray:result];
}
- (NSArray *) descriptionConstraints
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
    NSDictionaryOfVariableBindings(_investButton);
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-[_investButton]-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_investButton(>=100)]-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    return [NSArray arrayWithArray:result];
}

- (NSArray *) investAmountFieldConstraints
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(_investAmountField, _investButton);
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-[_investAmountField]-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_investAmountField(>=40)]-[_investButton]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    
    return [NSArray arrayWithArray:result];
}

@end
