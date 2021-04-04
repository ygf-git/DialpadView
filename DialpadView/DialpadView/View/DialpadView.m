//
//  DialpadView.m
//  Linkus
//
//  Created by 杨桂福 on 2021/1/11.
//  Copyright © 2021 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "DialpadView.h"
#import "DialpadViewCell.h"
#import "UIImage+Picture.h"
#import "DialPadTextField.h"

@interface DialpadView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DialpadViewCellDelegate>

@property (nonatomic,strong) NSArray *dialpadTitleArr;

@property (nonatomic,strong) NSArray *dialpadDetailArr;

@property (nonatomic,strong) DialPadTextField *textField;

@property (nonatomic,strong) UILabel          *placeholderLabel;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIButton *backspaceBtn;

@property (nonatomic,strong) UIButton *personAddBtn;

@property (nonatomic,strong) UIButton *dialpadBtn;

//因为第一次不允许有动画效果
@property (nonatomic,assign) BOOL      animation;
//因为第一次不允许有触觉反馈效果
@property (nonatomic,assign) BOOL      feedback;

@end

@implementation DialpadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfigurator];
        [self setupControls];
        self.backgroundColor = BackgroundColor3;
    }
    return self;
}

- (void)setupConfigurator {
    self.dialpadTitleArr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"*", @"0", @"#"];
    self.dialpadDetailArr = @[@" ", @"ABC", @"DEF", @"GHI", @"JKL", @"MNO", @"PQRS", @"TUV", @"WXYZ", @"", @"+", @""];
}

- (void)setupControls {
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel = placeholderLabel;
    placeholderLabel.text = @"Number";
    placeholderLabel.textAlignment = NSTextAlignmentCenter;
    placeholderLabel.textColor = Gray4;
    placeholderLabel.font = FontsizeMedium2;
    [self addSubview:placeholderLabel];
    
    DialPadTextField *textField = [[DialPadTextField alloc] initWithFrame:CGRectZero];
    self.textField = textField;
    textField.tintColor = Blue6;
    textField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat fontSize = 26.f;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.minimumFontSize = (fontSize * 2.f) / 3.f;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingHead;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    textField.defaultTextAttributes = @{NSFontAttributeName:FontsizeMedium1,
                                        NSParagraphStyleAttributeName:paragraphStyle,
                                        NSForegroundColorAttributeName:Blue6};
    [self addSubview:textField];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = BackgroundColor3;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delaysContentTouches = NO;
    [self addSubview:collectionView];
    
    UIButton *backspaceBtn = [[UIButton alloc] init];
    self.backspaceBtn = backspaceBtn;
    [backspaceBtn setBackgroundImage:[UIImage imageNamed:@"Dialpad_Backspace"] forState:UIControlStateNormal];
    [backspaceBtn setBackgroundImage:[UIImage imageByApplyingAlpha:0.7 image:[UIImage imageNamed:@"Dialpad_Backspace"]] forState:UIControlStateHighlighted];
    [backspaceBtn addTarget:self action:@selector(dialpadBackSpaceTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [backspaceBtn addTarget:self action:@selector(dialpadBackSpaceTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:backspaceBtn];
    
    UIButton *personAddBtn = [[UIButton alloc] init];
    self.personAddBtn = personAddBtn;
    [personAddBtn setBackgroundImage:[UIImage imageNamed:@"Navgationbar_Person"] forState:UIControlStateNormal];
    [personAddBtn setBackgroundImage:[UIImage imageByApplyingAlpha:0.7 image:[UIImage imageNamed:@"Navgationbar_Person"]] forState:UIControlStateHighlighted];
    [personAddBtn addTarget:self action:@selector(dialpadPersonNumberAdd) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:personAddBtn];
    
    UIButton *dialpadBtn = [[UIButton alloc] init];
    self.dialpadBtn = dialpadBtn;
    [dialpadBtn setBackgroundImage:[UIImage imageNamed:@"Dialpad_down"] forState:UIControlStateNormal];
    [dialpadBtn setBackgroundImage:[UIImage imageByApplyingAlpha:0.7 image:[UIImage imageNamed:@"Dialpad_down"]] forState:UIControlStateHighlighted];
    [dialpadBtn addTarget:self action:@selector(dialpadHidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dialpadBtn];
    
    @weakify(self)
    [RACObserve(self.textField, text) subscribeNext:^(NSString *x) {
        @strongify(self)
        if (x.length > 0) {
            backspaceBtn.hidden = NO;
            personAddBtn.hidden = NO;
            placeholderLabel.hidden = YES;
        }else{
            backspaceBtn.hidden = YES;
            personAddBtn.hidden = YES;
            placeholderLabel.hidden = NO;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(dialpadView:searchNumber:)]) {
            [self.delegate dialpadView:self searchNumber:self.number];
        }
    }];
    [[[RACObserve(self.textField, text) throttle:0.5] distinctUntilChanged] subscribeNext:^(NSString *x) {
        @strongify(self)
        if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(dialpadView:searchNumber:)]) {
            [self.searchDelegate dialpadView:self searchNumber:self.number];
        }
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backspaceBtn.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-60);
        make.left.mas_equalTo(self.mas_left).offset(60);
    }];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backspaceBtn.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-60);
        make.left.mas_equalTo(self.mas_left).offset(60);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(60);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(256);
        make.left.mas_equalTo(self.mas_left);
    }];
    
    [self.backspaceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.collectionView.mas_top).offset(-20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.personAddBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(24);
        make.left.mas_equalTo(self.mas_left).offset(self.width/6 - 12);
        make.width.height.mas_equalTo(24);
    }];
    
    [self.dialpadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(24);
        make.right.mas_equalTo(self.mas_right).offset(-(self.width/6 - 12));
        make.width.height.mas_equalTo(24);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DialpadViewCell *cell = [DialpadViewCell dequeueCellWithCollectionView:collectionView indexPath:indexPath];
    cell.delegate = self;
    NSString *name = self.dialpadTitleArr[indexPath.row];
    cell.name = name;
    NSString *number = self.dialpadDetailArr[indexPath.row];
    cell.number = number;
    return cell;
}

#pragma mark- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(self.width/3, 64);
    return size;
}

#pragma mark - DialpadViewCellDelegate
- (void)dialpadViewCell:(DialpadViewCell *)dialpadViewCell numberTouch:(NSString *)number {
    [self.textField ys_updateText:number];
}

- (void)dialpadViewCell:(DialpadViewCell *)dialpadViewCell numberUpdate:(NSString *)number {
    NSInteger location = self.textField.ys_selectedRange.location -1;
    self.textField.text = [self.textField.text stringByReplacingCharactersInRange:NSMakeRange(location, 1) withString:number];
    [self.textField setYs_selectedRange:NSMakeRange(location + 1, 0)];
}

#pragma mark - Button Action
- (void)dialpadHidden {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dialpadViewHidden:)]) {
        [self.delegate dialpadViewHidden:self];
    }
    [self dismissAnimated:YES completion:^{}];
}

- (void)dialpadPersonNumberAdd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dialpadView:personNumberAdd:)]) {
        [self.delegate dialpadView:self personNumberAdd:self.number];
    }
}

- (void)dialpadBackSpaceTouchDown:(UIButton *)sender {
    [self.textField ys_updateText:@""];
    [self performSelector:@selector(onLongClick:) withObject:sender afterDelay:.5f];
}

- (void)dialpadBackSpaceTouchUpInside:(UIButton *)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLongClick:) object:sender];
}

- (void)onLongClick:(UIButton *)sender {
    self.textField.text = @"";
}

#pragma mark - 获取号码
- (void)setNumber:(NSString *)number {
    self.textField.text = number;
}

- (NSString *)number {
    return self.textField.text;
}

#pragma mark - HWPanModalPresentable
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 408);
}

- (HWBackgroundConfig *)backgroundConfig {
    HWBackgroundConfig *config = [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorDefault];
    config.backgroundAlpha = 0;
    return config;
}

- (BOOL)showDragIndicator {
    return NO;
}

- (BOOL)shouldRoundTopCorners {
    return YES;
}

- (CGFloat)cornerRadius {
    return 12;
}

- (CGFloat)springDamping {
    return 1;
}

- (BOOL)allowsTouchEventsPassingThroughTransitionView  {
    return YES;
}

- (BOOL)shouldRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer {
    return NO;
}

- (HWPanModalShadow)contentShadow {
    return PanModalShadowMake(ModalShadowColor, 4, CGSizeMake(0, 2), 1);
}

- (BOOL)shouldEnableAppearanceTransition {
    return NO;
}

- (BOOL)isHapticFeedbackEnabled {
    if (!self.feedback) {
        self.feedback = YES;
        [self hw_panModalSetNeedsLayoutUpdate];
        return NO;
    }else{
        return YES;
    }
}

- (NSTimeInterval)transitionDuration {
    if (!self.animation) {
        self.animation = YES;
        [self hw_panModalSetNeedsLayoutUpdate];
        return 0;
    }else{
        return 0.3;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        [self hw_panModalSetNeedsLayoutUpdate];
    }
}

@end
