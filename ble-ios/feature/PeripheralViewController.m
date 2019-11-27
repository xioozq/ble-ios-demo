//
//  HomeViewController.m
//  ble-ios
//
//  Created by 肖子琦 on 2019/11/26.
//  Copyright © 2019 yunke. All rights reserved.
//

#import "PeripheralViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBPeripheral.h>
#import <CoreBluetooth/CBPeripheralManager.h>
#import "CentralViewController.h"

@interface PeripheralViewController () <CBPeripheralManagerDelegate, YKButtonDelegate>

@property (nonatomic, strong) YKButton *startBtn;
@property (nonatomic, strong) YKButton *stopBtn;
@property (nonatomic, strong) YKButton *navBtn;
@property (nonatomic, assign) UIEdgeInsets safeAreaInsets;
@property (nonatomic, strong) CBPeripheralManager *phManager;
@property (nonatomic, strong) CBMutableCharacteristic *myCharacteristic;
@property (nonatomic, strong) CBMutableService *myService;

@end

@implementation PeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Peripheral Service"];
    
#ifdef __IPHONE_11_0
    self.safeAreaInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
#else
    self.safeAreaInsets = UIEdgeInsetsZero;
#endif
    
    self.phManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
    self.startBtn = [YKButton primaryButton];
    self.startBtn.disabled = YES;
    self.startBtn.delegate = self;
    [self.startBtn setTitle:@"发送广播" forState:YKButtonStateNormal];
    
    self.stopBtn = [YKButton primaryHollowButton];
    self.stopBtn.disabled = YES;
    self.stopBtn.delegate = self;
    [self.stopBtn setTitle:@"停止广播" forState:YKButtonStateNormal];
    
    self.navBtn = [YKButton primaryButton];
    self.navBtn.delegate = self;
    [self.navBtn setTitle:@"central模式" forState:YKButtonStateNormal];
    
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.stopBtn];
    [self.view addSubview:self.navBtn];
}

- (void)viewDidLayoutSubviews {
    CGFloat viewWidth = self.view.width;
    CGFloat btnLeft = (viewWidth - 200) / 2;
    self.startBtn.frame = CGRectMake(btnLeft,  self.navigationController.navigationBar.height + self.safeAreaInsets.top + 100, 200, 40);
    self.stopBtn.frame = CGRectMake(btnLeft, self.startBtn.bottom + 100, 200, 40);
    self.navBtn.frame = CGRectMake(btnLeft, self.stopBtn.bottom + 100, 200, 40);
}

- (void)button:(YKButton *)button didTouchUpInside:(NSSet<UITouch *> *)touches {
    if ([button isEqual:self.startBtn]) {
        [self handleStartService];
    } else if ([button isEqual:self.stopBtn]) {
        [self handleStopService];
    } else if ([button isEqual:self.navBtn]) {
        CentralViewController *vc = [[CentralViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)handleStartService {
    NSLog(@"广播开启");
    [self.phManager startAdvertising:@{
        CBAdvertisementDataServiceUUIDsKey: @[self.myService.UUID]
    }];
    self.startBtn.disabled = YES;
    self.stopBtn.disabled = NO;
}

- (void)handleStopService {
    NSLog(@"广播停止");
    [self.phManager stopAdvertising];
    self.startBtn.disabled = NO;
    self.stopBtn.disabled = YES;
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    NSLog(@"注册服务");
    if (error) {
        NSLog(@"注册服务失败 %@", error);
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"设备状态: %ld", peripheral.state);
    
    // 状态必须是可用才能后续操作， 否则禁用
    if (peripheral.state == CBManagerStatePoweredOn) {
        self.startBtn.disabled = NO;
        
        CBUUID *ServiceUUID = [CBUUID UUIDWithString:@"71DA3FD1-7E10-41C1-B16F-4430B506CDE7"];
        CBUUID *CharacteristicUUID = [CBUUID UUIDWithString:@"e65ae8ec-cf77-478a-b72f-fd2d6b397874"];
        
        self.myCharacteristic = [[CBMutableCharacteristic alloc] initWithType:CharacteristicUUID properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable ];
        self.myService = [[CBMutableService alloc] initWithType:ServiceUUID primary:YES];
        self.myService.characteristics = @[self.myCharacteristic];
        [self.phManager addService:self.myService];
        
    } else {
        self.startBtn.disabled = YES;
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    
    if (error) {
        NSLog(@"广播开启失败 %@", [error localizedDescription]);
    } else {
        NSLog(@"广播开启成功!");
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"收到读消息");
    [self.phManager respondToRequest:request withResult: CBATTErrorInvalidHandle];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    
    
    for (int i = 0; i < requests.count; i++) {
        CBATTRequest * req = requests[i];
        NSLog(@"收到写消息: %@", req.value);
        [self.phManager respondToRequest:req withResult: CBATTErrorSuccess];
        
    }
}

@end
