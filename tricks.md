# Tricks to debug layout issues in iOS

## Tools
There are three view debug tools for Apple's platform.

1. [Reveal](https://revealapp.com/)
2. [Lookin](https://lookin.work/)
3. Builtin view debugger in Xcode
   

They can inspect current view hierarchy and analysis the constraints that effect a view's layout. Some of them may even view the results of changed constraints on the fly  with out rebuilding the whole app.

In this article, I will introduce the tricks for the builtin view debugger.

## Launch the View Debugger
After running the app from Xcode, you can start the view debugger in two approaches:
1. Click "Debug View Hierarchy" button in Xcode's debug tool bar.
   ![4EnR1fS8lyvI5Pw](https://i.loli.net/2021/08/12/4EnR1fS8lyvI5Pw.png)
2. Use menus "Debug -> View Debugging -> Capture View Hierarchy"
![68VHuyg5RkZowOs](https://i.loli.net/2021/08/12/68VHuyg5RkZowOs.png)

The debugger paused the application while it was still in its active state.

## Common Tricks

### Review the View Hierarchy
Getting the view hierarchy is the first step of debugging. By clicking the view's context menu, we can locate the view in the app's view hierarchy. 
![gQ4u6rw159dXYZM](https://i.loli.net/2021/08/12/gQ4u6rw159dXYZM.png)
In the view debugger, it also displays the hierarchy of view controllers. From the screenshot, we know that the red view is a subview in `BaseVC` and the `BaseVC` is pushed by a `UINavigationController`.  

### Inspect Info of Selected View  
On the right pane, we can inspect info related to the layout of selected view.
![NZW5PQBwODKuJCl](https://i.loli.net/2021/08/12/NZW5PQBwODKuJCl.png)  
From the screen shot, we can know the view's frame and constraints. The constraints are separated into horizontal and vertical groups.  
### View Clipped Content
Sometimes, part of content are out of current screen. For example, usually only part of scrollView's content is visible. We can use the "Show Clipped Content" button to make content out of current screen visible.
![clFsuaZJU8wkTQx](https://i.loli.net/2021/08/12/clFsuaZJU8wkTQx.gif)

### Adjust Range of Visible Views
Let's see an example. In the snapshot below, the green view is in front of the yellow view so we can't select the yellow view. We can adjust the range of visible views to be able to select the yellow view.
![uv56WhZgxGJRkLP](https://i.loli.net/2021/08/12/uv56WhZgxGJRkLP.png)

### Get Pointer of Objects
We can just copying the selected objects and use them in LLDB. It has been properly.
![NnsO9rhFXwdgot7](https://i.loli.net/2021/08/12/NnsO9rhFXwdgot7.gif)  
Views, constraints, view controllers all can be selected.

### Update Layout Without Rebuild
After getting access to the object, we can change properties and see the effect in the simulator without building. But we need call a function to see the effect.  
The reason is that we're paused in the debugger, so Core Animation isn't currently applying any view module changes to the screen's frame buffer.
 But we can ask Core Animation to do that for us, just use the expression `[CATransaction Flush]` and that tells Core Animation to update the screen's frame buffer.

 ![J5h21aKBjQvYVXi](https://i.loli.net/2021/08/12/J5h21aKBjQvYVXi.gif)

## Auto Layout

### Constraint Allocation Back Trace
After turning on "Malloc Stack Logging", we can jump to the code that creates a given constraint after selecting it.  
![OLi3yfrHCoVbasY](https://i.loli.net/2021/08/12/OLi3yfrHCoVbasY.png)

![28zno4CA1a6FPYI](https://i.loli.net/2021/08/12/28zno4CA1a6FPYI.gif)

### Add Identifer for Constraint
`NSLayoutConstraint` has a `identifier` property. Debugger can use it to reduce you mental burden while debugging.
```
widthConstraint.identifier = "width from spec"
```

![JeBXxFZwNnU9O3G](https://i.loli.net/2021/08/12/JeBXxFZwNnU9O3G.png)

### Add `accessibilityIdentifier` for view
The constraint would be more readable while debugging.
1. Constraint for view without `accessibilityIdentifier`
     ```
     <NSLayoutConstraint:0x6000035f1770 Demo.DebugView:0x7feda180cba0.centerX == UIView:0x7fed9fc0f9d0.centerX   (active)>
     ```
2. Constraint for view with `accessibilityIdentifier`  
      ```
      <NSLayoutConstraint:0x6000035f2cb0 testView.centerX == UIView:0x7fed9fc0f9d0.centerX   (active, names: testView:0x7feda180c1b0 )>
     ```

If we have multiple instances of button, we can tell the relationship between constraints and buttons.

### Unsatisfiable Constraints
The number of constraints for a given view is unlimited. Some of them may conflict and the system can't satisfy all of them. There would be logs in the console.  
```
[LayoutConstraints] Unable to simultaneously satisfy constraints.
```
We need understand the log and find the root cause. Since we have added `accessibilityIdentifier` to view and `identifier` to the constraints, the log is readable. The `maxYConstraint` and `minYConstraint` constraints conflict.
```
Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600000161680 'maxYConstraint' testView.centerY <= vcRootView.centerY + 10   (active, names: testView:0x7ff7c2d096e0, vcRootView:0x7ff7c2c14e70 )>",
    "<NSLayoutConstraint:0x600000161630 'minYConstraint' testView.centerY >= vcRootView.centerY + 200   (active, names: testView:0x7ff7c2d096e0, vcRootView:0x7ff7c2c14e70 )>"
)
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x6000015b0960 testView.centerY <= vcRootView.centerY + 10   (active, names: testView:0x7feffc60ae20, vcRootView:0x7feffc519580 )>

```
If the layout is pretty complex, there may be hundreds of line. We can use `UIView.constraintsAffectingLayout(for:)` to find constraints that are affecting a given view to narrow down the scope. 

```
// 1 for vertical and 0 for horizontal
(lldb) po [((UIView *)0x7ff7c2d096e0) constraintsAffectingLayoutForAxis:1] 

<__NSArrayI_Transfer 0x600002440160>(
<NSLayoutConstraint:0x6000001615e0 'heigh from spec' testView.height == 100   (active, names: testView:0x7ff7c2d096e0 )>,
<NSLayoutConstraint:0x600000161630 'minYConstraint' testView.centerY >= vcRootView.centerY + 200   (active, names: testView:0x7ff7c2d096e0, vcRootView:0x7ff7c2c14e70 )>,
<NSLayoutConstraint:0x60000010d7c0 'UIView-Encapsulated-Layout-Height' vcRootView.height == 844   (active, names: vcRootView:0x7ff7c2c14e70 )>
)
```

### Resolving Ambiguity  
There may be more than one solution for the constraints.  
For example, if we add there two constraints, the vertical center is ambiguous.
```
   testView.centerYAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor, constant: 10),
   testView.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor, constant: 200),
```  

We can find the view in view debugger easily.  
![Y6clOqiFBQ9Ggex](https://i.loli.net/2021/08/12/Y6clOqiFBQ9Ggex.png)  
Using `exerciseAmbiguityInLayout`, we can make the layout engine switch between the valid solutions.  
![rov9dpKQf3Bagqj](https://i.loli.net/2021/08/12/rov9dpKQf3Bagqj.gif)

## Frame-based layout
Frame-based layout is straight forward. The view's frame is set explicitly by code.
### Override `frame` Property  
```
   override var frame: CGRect {
      get { super.frame }
      set {
         print("new frame is\(newValue)")
         super.frame = newValue
      }
   }
```
Using this approach, we can log all the frame changes.



## Resources
- [Mysteries of Auto Layout, Part 1](https://developer.apple.com/videos/play/wwdc2015/218/)
- [Mysteries of Auto Layout, Part 2](https://developer.apple.com/videos/play/wwdc2015/219/)
- [Advanced Debugging with Xcode and LLDB](https://developer.apple.com/videos/play/wwdc2018/412/)
- [Lookin](https://lookin.work/)
- [Reveal](https://revealapp.com/)
- [Debugging Auto Layout](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/DebuggingTricksandTips.html#//apple_ref/doc/uid/TP40010853-CH21-SW1)