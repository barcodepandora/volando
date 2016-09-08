//
//  MenuViewController.m TODO: Cambiar por nombre mas significativo
//  volando
//
//  Created by Juan Manuel Moreno on 6/9/16.
//  Copyright © 2016 uzupis. All rights reserved.
//

#import "MenuViewController.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "DownPicker.h"

@interface MenuViewController ()

@property NSMutableArray *piatti; // Restaurantes json TODO: Cambiar por mejor nombre
@property NSDictionary *piatto; // Abstraccion de un restaurante TODO: Cambiar por Place, no es un piatto
@property (strong, nonatomic) DownPicker *downPicker; // Picker para ordenar
@property NSDictionary *filter; // Filtro para ordenar
@property NSString *handy; // Criterio para ordenar

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Agregamos valores a tabla por protocolos
    self.tblMenu.delegate = self;
    self.tblMenu.dataSource = self;
    
    self.piatti = [[NSMutableArray alloc] init]; // Creamos instancia restaurantes
    
    self.filter = @{@"Categoria": @"categorias", @"Precio": @"domicilio", @"Nombre": @"nombre", @"Tiempo Trayecto": @"tiempo_domicilio"}; // Creamos instancia filtros, key = opcion ordenar, value = atributo json
    
    NSURL *jsonUrl = [NSURL URLWithString:@"https://api.myjson.com/bins/1zib8"]; // URL json
    
    // Validamos conectividad con framework cocoapods Reachability
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        NSLog(@"No internet connection");
    } else {
        
        NSURLResponse * response = nil; // Traemos json
        NSError *error=nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:jsonUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15.0]
                                             returningResponse:&response
                                                         error:&error];
        
        if (error) {
            
        } else {
            
            // Pasamos json a contenedor piatti
            NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.piatti = [result mutableCopy];
        }
    }
    
    // Agregamos opciones de reordenar en picker
    NSMutableArray* combo = [[NSMutableArray alloc] init];
    [combo addObject:@"Categoria"];
    [combo addObject:@"Precio"];
    [combo addObject:@"Nombre"];
    [combo addObject:@"Tiempo Trayecto"];
    self.downPicker = [[DownPicker alloc] initWithTextField:self.txtOrder withData:combo];
    [self.downPicker addTarget:self // Asociamos accion de reordenar al escoger una opcion
                            action:@selector(order:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.txtOrder.text = @"Ordenar por ...";
    
    // Agregamos imagen con framework cocoapods SDWebImage para traer imagenes de Internet
    [self.imgCover sd_setImageWithURL:[[NSURL alloc] initWithString:@"https://s-media-cache-ak0.pinimg.com/564x/27/70/ec/2770ec756dca44267b7f378dcbc55362.jpg"]
                      placeholderImage:[UIImage imageNamed:@"full-screen-placeholder"]
                               options:(SDWebImageCacheMemoryOnly | SDWebImageRetryFailed)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.piatti count]; // No. de restaurantes a traves del contenedor
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PiattoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Piatto" forIndexPath:indexPath];
    NSDictionary *piatto = [self.piatti objectAtIndex:indexPath.row]; // Restaurante
    
    cell.txtNombre.text = [piatto objectForKey:@"nombre"]; // Nombre
    
    cell.lblDesc.text = [NSString stringWithFormat:@"Categoria %@ a un precio de $%@ llega en %@ minutos", [piatto objectForKey:@"categorias"], [piatto objectForKey:@"domicilio"], [piatto objectForKey:@"tiempo_domicilio"]]; // Descripcion
    
    [cell.imgPiatto sd_setImageWithURL:[[NSURL alloc] initWithString:[piatto objectForKey:@"logo_path"]]
                      placeholderImage:[UIImage imageNamed:@"logo01"]
                               options:(SDWebImageCacheMemoryOnly | SDWebImageRetryFailed)]; // Imagen. TODO: No esta cargando las imagenes del json
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}
- (IBAction)reorder:(id)sender {
    
}

/*
 
    Reordena los restaurantes por una opcion dada
 */
-(void)order:(id)dp {

    self.handy = [self.filter objectForKey:self.txtOrder.text]; // Filtro para ordenar
    
    // Ordenamos con comparador
    NSMutableArray *sortedResult = [self.piatti sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSDictionary *first = (NSDictionary *) obj1;
        NSDictionary *second = (NSDictionary *) obj2;
        
        if ([self.handy isEqualToString:@"domicilio"] || [self.handy isEqualToString:@"tiempo_domicilio"]) { // Ordenamos numericos
            
            NSString *num1 = [NSString stringWithFormat:[first objectForKey:self.handy]];
            NSString *num2 = [NSString stringWithFormat:[second objectForKey:self.handy]];
            if ( num1.doubleValue < num2.doubleValue ) {
                
                return (NSComparisonResult)NSOrderedAscending;
            } else if ( num1.doubleValue > num2.doubleValue ) {
                
                return (NSComparisonResult)NSOrderedDescending;
            } else {
                
                return (NSComparisonResult)NSOrderedSame;
            }
        } else { // Ordenamos texto
            
            return [[first objectForKey:self.handy] compare:[second objectForKey:self.handy]];
        }
        
    }];
    
    self.piatti = [sortedResult mutableCopy]; // Copiamos a contendor de restaurantes
    [self.tblMenu reloadData]; // Refrescamos tabla
}
@end
