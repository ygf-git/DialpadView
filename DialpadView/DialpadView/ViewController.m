//
//  ViewController.m
//  DialpadView
//
//  Created by 杨桂福 on 2021/3/27.
//

#import "ViewController.h"
#import "DialpadView.h"
#import "DialpadCallView.h"

@interface ViewController ()<DialpadViewDelegate, DialpadCallViewDelegate>

@property (nonatomic,strong) DialpadView                 *dialpadView;

@property (nonatomic,strong) DialpadCallView             *dialpadCallView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    DialpadCallView *dialpadCallView = [[DialpadCallView alloc] init];
    self.dialpadCallView = dialpadCallView;
    dialpadCallView.delegate = self;
    dialpadCallView.hidden = YES;
    [self.view addSubview:dialpadCallView];

    [self.dialpadCallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(56);
    }];
    
    DialpadView *dialpadView = [[DialpadView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    self.dialpadView = dialpadView;
    dialpadView.delegate = self;
    [dialpadView presentInView:self.view];
    self.dialpadCallView.hidden = NO;
    [self.view insertSubview:self.dialpadCallView aboveSubview:dialpadView];
}

#pragma mark - DialpadViewDelegate
-(void)dialpadView:(DialpadView *)dialpadView searchNumber:(NSString *)number {
   
    
}

- (void)dialpadViewHidden:(DialpadView *)dialpadView {
    self.dialpadCallView.dialpadShow = NO;
    [self.dialpadCallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-24);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(56);
    }];
}

#pragma mark - DialpadCallViewDelegate
- (void)dialpadCallViewShowAction:(DialpadCallView *)dialpadCallView {
    [self.dialpadView presentInView:self.view];
    dialpadCallView.dialpadShow = YES;
    [self.view insertSubview:dialpadCallView aboveSubview:self.dialpadView];
    [self.dialpadCallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(56);
    }];
}

- (void)dialpadCallViewCallAction:(DialpadCallView *)dialpadCallView touchAction:(BOOL)longTouch {

}

@end
