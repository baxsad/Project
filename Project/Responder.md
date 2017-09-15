#  UIResponder

## 在iOS中不是任何对象都能处理事件，只有继承了UIResponder的对象才能接受并处理事件，我们称之为“响应者对象”。以下都是继承自UIResponder的，所以都能接收并处理事件。

- UIApplication
- UIViewController
- UIView

## UIResponder内部提供了以下方法来处理事件触摸事件

// 一根或者多根手指开始触摸view，系统会自动调用view的下面方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

// 一根或者多根手指在view上移动，系统会自动调用view的下面方法（随着手指的移动，会持续调用该方法）
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

// 一根或者多根手指离开view，系统会自动调用view的下面方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

// 触摸结束前，某个系统事件(例如电话呼入)会打断触摸过程，系统会自动调用view的下面方法
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;


(CGPoint)locationInView:(UIView *)view;
// 返回值表示触摸在view上的位置
// 这里返回的位置是针对view的坐标系的（以view的左上角为原点(0, 0)）
// 调用时传入的view参数为nil的话，返回的是触摸点在UIWindow的位置

(CGPoint)previousLocationInView:(UIView *)view;
// 该方法记录了前一个触摸点的位置

1.首先判断主窗口（keyWindow）自己是否能接受触摸事件
2.判断触摸点是否在自己身上
3.子控件数组中从后往前遍历子控件，重复前面的两个步骤（所谓从后往前遍历子控件，就是首先查找子控件数组中最后一个元素，然后执行1、2步骤）
4.view，比如叫做fitView，那么会把这个事件交给这个fitView，再遍历这个fitView的子控件，直至没有更合适的view为止。
5.如果没有符合条件的子控件，那么就认为自己最合适处理这个事件，也就是自己是最合适的view。

UIView不能接收触摸事件的三种情况：

不允许交互：userInteractionEnabled = NO
隐藏：如果把父控件隐藏，那么子控件也会隐藏，隐藏的控件不能接受事件
透明度：如果设置一个控件的透明度<0.01，会直接影响子控件的透明度。alpha：0.0~0.01为透明。
注 意:默认UIImageView不能接受触摸事件，因为不允许交互，即userInteractionEnabled = NO，所以如果希望UIImageView可以交互，需要userInteractionEnabled = YES。

之所以会采取从后往前遍历子控件的方式寻找最合适的view只是为了做一些循环优化。因为相比较之下，后添加的view在上面，降低循环次数。

