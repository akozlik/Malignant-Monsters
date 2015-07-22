//
//  DetailViewController.m
//  Hackathon
//
//  Created by Andrew Kozlik on 3/28/15.
//  Copyright (c) 2015 Andrew Kozlik. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImage+animatedGIF.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];

    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
    
    self.imageView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    gesture.minimumPressDuration = 1;
    gesture.numberOfTouchesRequired = 1;

    [self.imageView addGestureRecognizer:gesture];
}

-(void)longPress {
    NSLog(@"Long press");
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *gifURL = [bundle URLForResource:@"The_Director" withExtension:@"gif"];
    
    UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:gifURL];
    self.imageView.image = gifImage;

    
    [self.imageView startAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
