//
//  CustomElementView.h
//  CultureAssistant
//


#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface CustomElementView : UIView

@end

#pragma mark- 城市
@interface CityHeaderView : UICollectionReusableView
-(void)title:(NSString *)title;
@end


@interface CitySquareCell : UICollectionViewCell
-(void)title:(NSString *)title;
@end

@interface CityItemCell : UICollectionViewCell
-(void)cityItem:(CityModel *)item;
@property(nonatomic,strong)NSIndexPath* indexPath;
@property(nonatomic,copy)void(^seletctCityHandle)(CityModel * city,NSIndexPath* indexPath);
@property(nonatomic,copy)void(^showLibraryHandle)(CityModel * city);
@end

#pragma mark- 场馆
@interface LibraryCell : UITableViewCell
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,assign)BOOL choosed;
@end

#pragma mark- 资讯
@interface InfoTableViewCell : UITableViewCell
- (void)setContent:(ArticleItem *)item;
+ (CGFloat)heightForCell:(ArticleItem *)item;
@end

//一个图+一个标题
@interface InfoCommonCell : InfoTableViewCell

+ (CGFloat)heightForCell;
@end


//多张图片
@interface InfoImagesCell : InfoTableViewCell

@end


//一张广告图片
@interface InfoADImageCell : InfoTableViewCell

@end

//纯文字
@interface InfoTextCell : InfoTableViewCell

@end

//顶部循环滚动头图
@interface InfoTopImageCell : UITableViewCell

@property(nonatomic,strong)NSArray* imagesArray;
@property(nonatomic,copy)void(^gotoArticleDetail)(BannerItem *model);
@end

#pragma mark- 注册

@interface RegisterTableHead : UIView
@property(nonatomic,strong)UILabel* titleLable;
@end

//第一页的Cell
@interface RegisterTableCell : UITableViewCell

@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UITextField* textField;

@property(nonatomic,assign)BOOL showStar;//是否显示星号
@property(nonatomic,assign)BOOL showSelectBtn;//是否显示选择按钮

@end

@interface RegisterSkillItem : UICollectionViewCell
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* boxBtn;
@end

@interface RegisterButtonCell : UITableViewCell

@end


@interface RegisterSkillCell : UITableViewCell
@property(nonatomic,strong)NSArray *specialitys;
@property(nonatomic,copy)void(^selectedSkillHandler)(BOOL selected,NSString * skillId);
+ (CGFloat)heightForRegisterSkillCell;
@end

//第二页的cell
@interface RegisterBoxCell : UITableViewCell

@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* boxBtn;
@end

#pragma mark- 招募
@interface RecruitTextView : UIView
@property(nonatomic,strong)UILabel* topLabel;
@property(nonatomic,strong)UILabel* bottomLabel;
@end

@interface RecruitSmallView : UIView

- (void)setImage:(NSString *)imgName text:(NSString *)text;
@end

@interface RecruitViewCell : UICollectionViewCell

@property(nonatomic,strong)ArticleItem* recruitItem;
@property(nonatomic,strong)MyEnrollModel* myEnroll;
@end

//岗位描述
@interface RecruitPostDescCell : UICollectionViewCell
@property(nonatomic,strong)UIButton* enrollBtn;
@property(nonatomic,strong)RecruitPost* recruitPost;

+(CGSize)SizeForRecruitPostDescCell:(RecruitPost *)recruitPost;
@end

//招募查询
@interface RecruitConditonHead : UIView
@property(nonatomic,strong)UILabel* titleLabel;
@end

@interface RecruitConditonItem : UICollectionViewCell
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,assign)BOOL choosed;
@end

@interface RecruitConditonCell : UITableViewCell
@property(nonatomic,strong)NSArray* dataArray;
@property(nonatomic,strong)NSIndexPath* indexPath;

@property(nonatomic,copy)void(^selecteInitData)(NSString* dataId,NSString* dataType);
@end

//动态 报名人员
@interface RecruitApplyIcon : UICollectionViewCell
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* label;
@end

//问卷的选项
@interface QuestionSingleCell : UITableViewCell
@property(nonatomic,strong)UIButton* choiceBtn;
@property(nonatomic,strong)UILabel* contentLabel;
@end

@interface QuestionBoxCell : UITableViewCell
@property(nonatomic,strong)UIButton* choiceBtn;
@property(nonatomic,strong)UILabel* contentLabel;
@end


#pragma mark- 个人中心
@interface SettingCellView : UIView
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIImageView* arrowView;
@property(nonatomic,strong)UIView* lineView;
@end



//服务记录
@interface ServiceRecordHead : UIView

@end

@interface ServiceRecordCell : UITableViewCell

@property(nonatomic,strong)ServiceRecord* serviceRecord;
@end

//星级
@interface StarLevelCell : UICollectionViewCell

@property(nonatomic,strong)StarRecord* starRecord;
@end

//无内容时的提示
@interface BlankContentView : UIView

@end


