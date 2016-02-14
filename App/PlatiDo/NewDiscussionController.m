//
//  NewDiscussionController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 25.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "NewDiscussionController.h"
#import "UIPlaceHolderTextView.h"
#import "PhotoCollectionViewDataSource.h"
#import "FormHelper.h"
#import "DiscussionAPI.h"
#import "MBProgressHUD.h"

@interface NewDiscussionController() <PhotoCollectionViewDataSourceProtocol, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHconstrait;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)  PhotoCollectionViewDataSource *photoDataSource;
@property (nonatomic, strong)  FormHelper *formHelper;
@end

@implementation NewDiscussionController

- (void)viewDidLoad{
    self.photoDataSource = [[PhotoCollectionViewDataSource alloc] initWithDelegate:self];
    self.collectionView.delegate   =  self.photoDataSource;
    self.collectionView.dataSource =  self.photoDataSource;
    self.textView.placeholder      = NSLocalizedString(@"Desussion text", @"Текст Обсуждения");
    self.textView.delegate = self;
    [self collectionViewSetVisible:NO];
    
    self.formHelper = [[FormHelper alloc] init];
    [self.formHelper setScrollView:self.textView];
    [self.formHelper setScrollContentView:self.textView];
    [self.formHelper setRootView:self.view];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)createDiscussPressed:(id)sender {
    [self.textView resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DiscussionAPI createDiscussion:self.textView.text images:self.photoDataSource.attachmentImages comBlock:^(BOOL sucess, NSError *error) {
        if (sucess){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.formHelper registerMe];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.formHelper registerMe];
}


- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)addImageBtnPressed:(id)sender {
    [self.photoDataSource showPhotoFrom:self PickerwithComblock:^(UIImage *image) {
        NSLog(@"photo %@", image);
    }];
}

- (void)collectionViewSetVisible:(BOOL)isVisible{
    self.collectionViewHconstrait.constant = isVisible? 60:0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
}
@end
