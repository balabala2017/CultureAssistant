//
//  SearchView.h
//  CultureAssistant
//


#import <UIKit/UIKit.h>

@interface SearchView : UIView

@property(nonatomic,weak)id delegate;
@property(nonatomic,assign)BOOL isShowSearchNewsList;
@property(nonatomic,strong)UITableView *tableV;
@property(nonatomic,strong)NSString *searchType;//记录搜索类型
@property(nonatomic,strong)NSString *searchKey;

-(void)showHotNewsWithData:(NSArray *)array;
-(void)showTypeAndHotKeyWithData:(NSDictionary *) typeAndKeys withSortArray:(NSArray *)sortArr;
-(void)showHistoryNewsWithData:(NSArray *) newsList;
-(void)showSearchNewsWithData:(ArticleList *) listModel;
@end

@interface TypeView : UIView

@property(nonatomic,weak)id delegate;
@property(nonatomic,assign)BOOL isShow;

-(void)show;
-(void)hidden;

@end
