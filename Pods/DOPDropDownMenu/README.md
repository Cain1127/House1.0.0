# DOPDropDownMenu

[![CI Status](http://img.shields.io/travis/ysmeng/DOPDropDownMenu.svg?style=flat)](https://travis-ci.org/ysmeng/DOPDropDownMenu)
[![Version](https://img.shields.io/cocoapods/v/DOPDropDownMenu.svg?style=flat)](http://cocoapods.org/pods/DOPDropDownMenu)
[![License](https://img.shields.io/cocoapods/l/DOPDropDownMenu.svg?style=flat)](http://cocoapods.org/pods/DOPDropDownMenu)
[![Platform](https://img.shields.io/cocoapods/p/DOPDropDownMenu.svg?style=flat)](http://cocoapods.org/pods/DOPDropDownMenu)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DOPDropDownMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

DOPDropDownMenu 添加双列表 优化版 （double tableView, The optimization version ）

首先 感谢 DOPDropDownMenu 作者的无私奉献和允许, https://github.com/dopcn/DOPDropDownMenu/https://github.com/12207480/DOPDropDownMenu-Enhanced

由于作者的原库不上传到cocoaPod的spec中，所以我这里添加这个支持，以便使用更方便！

我在此基础上美化来了界面，添加了双列表的应用，优化了代码，增强了稳定性，希望大家喜欢

First, I would like to thank the author of the DOPDropDownMenu for their selfless dedication.

This enhanced version includes beautiful improvements to the interface, double tableview capability, optimized code, and improved stability. Enjoy!

## 用法
#pragma mark - data source protocol
@class DOPDropDownMenu;

@protocol DOPDropDownMenuDataSource <NSObject>

@required

/**
*  返回 menu 第column列有多少行
*/
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column;

/**
*  返回 menu 第column列 每行title
*/
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath;

@optional
/**
*  返回 menu 有多少列 ，默认1列
*/
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu;


/** 新增
*  当有column列 row 行 返回有多少个item ，如果>0，说明有二级列表 ，=0 没有二级列表
*  如果都没有可以不实现该协议
*/
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column;

/** 新增
*  当有column列 row 行 item项 title
*  如果都没有可以不实现该协议
*/
- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath;
@end

#pragma mark - delegate
@protocol DOPDropDownMenuDelegate <NSObject>
@optional
/**
*  点击代理，点击了第column 第row 或者item项，如果 item >=0
*/
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath;
@end

```ruby
pod "DOPDropDownMenu"
```

## Author

ysmeng, 49427823@163.com

## License

DOPDropDownMenu is available under the MIT license. See the LICENSE file for more info.
