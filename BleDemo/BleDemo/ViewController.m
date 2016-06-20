//
//  ViewController.m
//  BleDemo
//
//  Created by MacPro on 16/6/7.
//  Copyright © 2016年 MacPro. All rights reserved.
//



#import "ViewController.h"
#import "PeripheralViewController.h"

#import "MBProgressHUD.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate>

@end

@implementation ViewController {
    
//    CBCentralManager *centerManager;
    
    NSMutableArray *peripheralInfo;
    
    NSMutableArray *peripherals;

    NSMutableArray *peripheralAds;
    
    MBProgressHUD *hud;

}

@synthesize deviceTable;

@synthesize centerManager;

@synthesize deviceList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"设 备";
//    self.view.backgroundColor = [UIColor lightGrayColor];
    
    centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    //centerManager.delegate = self;
    
    
    //add search button
    [self addSearchBtton];
    
    //add show table
    [self initDeviceTable];
    
    //初始化 数组
    peripherals = [[NSMutableArray alloc] init];
    peripheralInfo = [[NSMutableArray alloc] init];
    peripheralAds = [[NSMutableArray alloc] init];
    
    //子视图的返回 按钮只有箭头没有文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //启动一个定时任务
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(searchDevice) userInfo:nil repeats:NO];
    

}

#pragma mark - initilization

- (void) addSearchBtton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索  " style:UIBarButtonItemStylePlain target:self action:@selector(searchDevice)];
    
//    //启动一个定时任务
//    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(stopDevice) userInfo:nil repeats:NO];
    
}
     


- (void) initDeviceTable {
    deviceTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    deviceTable.delegate = self;
    
    deviceTable.dataSource = self;
    
//    deviceTable.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.9];
    
    [self.view addSubview:deviceTable];
    
   // deviceList = [[NSMutableArray alloc] init];  //初始化数组
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return peripheralInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"reuseid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
    }
    
    NSMutableDictionary *tmpDic = [peripheralInfo objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tmpDic[@"name"];
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"rssi: %@ \nUUID: %@",tmpDic[@"RSSI"],tmpDic[@"id"]];
    
    NSLog(@"------- %@", cell.textLabel.text);
    
    return cell;
}


#pragma mark - tableview delegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0f;
    
}

//点击测cell后 连接蓝牙设备 获取服务 和 特征

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = NSLocalizedString(@"正在连接设备", @"HUD loading title");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //停止扫描
    [centerManager stopScan];
    NSLog(@"did stop scan!");
    
    
    
    //连接设备 连接成功则跳转  不成功则停在当前页
    CBPeripheral *selectedPeripheral = [peripherals objectAtIndex:indexPath.row];
    [self connect:selectedPeripheral];
    
}

#pragma mark - centerManger delegate

//发现外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
//    if(![_dicoveredPeripherals containsObject:peripheral])
//        [_dicoveredPeripherals addObject:peripheral];
//    
//    NSLog(@"dicoveredPeripherals:%@", _dicoveredPeripherals);
    
    NSLog(@"获取的广播数据（FA+length+cmd+data+AF）：%@",advertisementData);
    NSLog(@"获取的广播： %@", RSSI);
    
    NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] initWithDictionary:advertisementData copyItems:YES];
    if (!peripheral.name) {
        
        [itemDic setObject:@"noname" forKey:@"name"];
        
    } else {
        [itemDic setObject:peripheral.name forKey:@"name"];
    }
    
    [itemDic setObject:RSSI forKey:@"RSSI"];
    
    [itemDic setObject:peripheral.identifier.UUIDString forKey:@"id"];
    
    //判重 没有重复的话 && 并且名字 为 ChildSafetySeat 添加到数组中 刷新列表 && [peripheral.name isEqualToString:@"ChildSafetySeat"]
    if (![peripherals containsObject:peripheral] ) {
        
        [peripherals addObject:peripheral];
        
        [peripheralInfo addObject:itemDic];
        
        [deviceTable reloadData];  //代价比较大 暂时这么做
    }
  
}

//连接指定的设备
-(BOOL)connect:(CBPeripheral *)peripheral
{
    NSLog(@"connect start");
    //_testPeripheral = nil;
    
    [centerManager connectPeripheral:peripheral
                       options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
    //开一个定时器监控连接超时的情况
//    NSTimer *connectTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(connectTimeout:) userInfo:peripheral repeats:NO];
    
    return (YES);
}

//外设 连接上
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"外设连接成功，可进行下部操作");
    
    hud.label.text = @"连接成功";
    //开始跳转 页面
   // PeripheralViewController  *periheralVC = [[PeripheralViewController alloc] init];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    PeripheralViewController  *periheralVC = [story instantiateViewControllerWithIdentifier:@"PeripheralViewController"];
    
    
    periheralVC.selPeripheral = peripheral;
    
    periheralVC.selPeripheral.delegate = periheralVC;
    
    periheralVC.title = peripheral.name;
    
    //====== 获取 服务uuids
    int flag = 0;
    for (int i = 0; i < peripherals.count; i++) {
        if (peripheral == peripherals[i]) {
            flag = i;
            break;
        }
    }
    
    NSDictionary *tmpAds = peripheralInfo[flag];

    NSArray *tmpUUIDArray = tmpAds[@"kCBAdvDataServiceUUIDs"];
    
    periheralVC.UUIDSArray = tmpUUIDArray;
    //===========
    
    [hud hideAnimated:YES afterDelay:0];
    [self.navigationController pushViewController:periheralVC animated:YES];
    
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"外设连接失败，请刷新后重新尝试");
    hud.label.text = @"连接失败";
    [hud hideAnimated:YES afterDelay:1];
    
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
}


#pragma mark - click action

- (void) searchDevice {
    
    for(int i = 0; i < peripherals.count; i++) {
        [centerManager cancelPeripheralConnection:peripherals[i]];
    }
    
    [peripheralInfo removeAllObjects];
    [peripherals removeAllObjects];
    [peripheralAds removeAllObjects];
    [deviceTable reloadData];
 
    [centerManager scanForPeripheralsWithServices:nil options:nil];
    
}

- (void) stopDevice {

    for (int i = 0; i < peripherals.count; i++) {
        [centerManager cancelPeripheralConnection:peripherals[i]];
    }

    [centerManager stopScan];
    
    NSLog(@"did stop scan!");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - life circle
- (void) viewDidAppear:(BOOL)animated {
//     [centerManager scanForPeripheralsWithServices:nil options:nil];
}

//- (void) viewWillAppear:(BOOL)animated {
//    
//     [centerManager scanForPeripheralsWithServices:nil options:nil];
//    
//}





@end
