//
//  ForwardList.m
//  AgoraChatCallKit
//
//  Created by 朱继超 on 2023/7/27.
//

#import "ForwardList.h"
#import "ForwardModel.h"
#import "ForwardMessageCell.h"

@interface ForwardList ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <ForwardModel *>*forwards;

@end

@implementation ForwardList

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style models:(NSArray <ForwardModel *>*)models {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.forwards = [NSMutableArray arrayWithArray:models];
            
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.forwards.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.forwards[indexPath.row].contentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForwardMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForwardMessageCell"];
    if (!cell) {
        cell = [[ForwardMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ForwardMessageCell"];
    }
    cell.model = self.forwards[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ForwardModel *model = self.forwards[indexPath.row];
    ForwardMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.selectBlock) {
        self.selectBlock(model,cell);
    }
}

@end
