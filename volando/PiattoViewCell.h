//
//  PiattoViewCell.h TODO: Cambiar nombre por Place
//  volando
//
//  Created by Juan Manuel Moreno on 6/9/16.
//  Copyright © 2016 uzupis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PiattoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtNombre;

// Propiedades de vista
@property (weak, nonatomic) IBOutlet UIImageView *imgPiatto;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

@end
