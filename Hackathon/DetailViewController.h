//
//  DetailViewController.h
//  Hackathon
//
//  Created by Andrew Kozlik on 3/28/15.
//  Copyright (c) 2015 Andrew Kozlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@end

