//
//  CategoriesViewController.h
//  iMojiMaker
//
//  Created by Lucky on 5/3/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoriesViewControllerDelegate;

@interface CategoriesViewController : UIViewController

@property (nonatomic, weak) id<CategoriesViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)selectRow:(NSInteger)row animated:(BOOL)animated;
- (void)configureWithProducts:(NSArray<Product *> *)products;
- (void)reloadContentDataWithUsedCategories:(NSArray *)usedCategories;

@end

@protocol CategoriesViewControllerDelegate <NSObject>

- (void)categoriesViewController:(CategoriesViewController *)controller didSelectCategoryAtIndex:(NSInteger)index;

@end
