//
//  MenuViewController.h TODO: Cambiar por nombre mas significativo
//  volando
//
//  Created by Juan Manuel Moreno on 6/9/16.
//  Copyright © 2016 uzupis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PiattoViewCell.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// Propiedades vista
@property (weak, nonatomic) IBOutlet UITableView *tblMenu;
- (IBAction)reorder:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblHola;
@property (weak, nonatomic) IBOutlet UITextField *txtOrder;
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;

@end
