//
//  SearchBillViewController.m
//  PlatiDo
//
//  Created by Smart Labs on 11.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "SearchBillViewController.h"
#import "BillingViewController.h"

@interface SearchBillViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UIView *closeView;

@property (strong, nonatomic) NSArray *monthArray;
@property (strong, nonatomic) NSArray *yearArray;

@property (nonatomic, assign) BOOL choiceYear;

@end

@implementation SearchBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pickerView.hidden = YES;
    
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.yearTextField.inputView = dummyView;
    self.monthTextField.inputView = dummyView;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    self.monthArray = @[NSLocalizedString(@" ", nil),
                        [[[df standaloneMonthSymbols] objectAtIndex:0] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:1] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:2] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:3] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:4] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:5] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:6] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:7] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:8] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:9] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:10] capitalizedString],
                        [[[df standaloneMonthSymbols] objectAtIndex:11] capitalizedString]];
    
    
    self.yearArray = @[@" ",@"2012",@"2013",@"2014",@"2015"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSearch)];
    [self.closeView addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapSearch:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Search is unavailable",nil) message:NSLocalizedString(@"Functionality is not working" ,nil)delegate:self cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alert show];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if (self.choiceYear)
    {
        return [self.yearArray count];
    } else {
        return [self.monthArray count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (self.choiceYear)
    {
        return [self.yearArray objectAtIndex:row];
    } else {
        return [self.monthArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.choiceYear)
    {
        self.yearTextField.text = [self.yearArray objectAtIndex:row];
        if ([self.yearTextField.text isEqualToString:@" "]){
            self.yearTextField.text = @"";
        }
    } else {
        self.monthTextField.text = [self.monthArray objectAtIndex:row];
        if ([self.monthTextField.text isEqualToString:@" "]){
            self.monthTextField.text = @"";
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.pickerView.hidden = NO;
    if (textField == self.yearTextField)
    {
        self.choiceYear = YES;
    } else {
        self.choiceYear = NO;
    }
    
    return YES;
}

- (void)hideSearch
{
    if ([self.parentViewController isKindOfClass:[BillingViewController class]])
    {
        BillingViewController *vc = (BillingViewController *)self.parentViewController;
        [vc hideSearchMode];
    }
}

- (void)setChoiceYear:(BOOL)choiceYear
{
    _choiceYear = choiceYear;
    [self.pickerView reloadAllComponents];
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
