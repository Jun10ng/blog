---
title: Go官网FAQ部分翻译
comment:
  - true
categories:
  - Golang
tags:
  - null
photos:
  - https://s1.ax1x.com/2020/07/19/UWuOoD.jpg
date: 2020-07-19 17:41:02
---

在Go岗位面试中，经常会被问到的一些问题，这些问题其实都在Go的官网的FAQ文章中，本文翻译了部分高频问题，但还是推荐大家去看完整的FAQ。

<!-- more -->


## 翻译说明

本文翻译自[官网FAQ文档](https://golang.org/doc/faq)，并没有全文翻译，而是挑选了个人认为比较高频的问题。忽略了类似“Go起源”这类问题。

## Go还是Golang？

这问语言叫做 Go ，Golang 这个绰号(moniker)是因为语言官方网站链接为`golang.org`而不是`go.org`才传开的。不过很多人使用 Golang 这个外号作为标签还是很方便的。另外，在推特上这门语言的标签是 `#golang`。不管怎样，这门语言的名称就是平平无奇的(plain) Go。

虽然官网logo是两个大写字母组成的，但是实际上，是Go而不是GO。

## Go 的祖先(ancestors)是？

Go是类C语言(基本语法)，此外它还借鉴了`Pascal/Modula/Oberon `这几个项目中的包管理和声明方法，再加上一些`CSP`得来的灵感例如`Newsqueak`和`Limbo`。这门语言是个包容一切的语言，在很多方面我们都按照我们的想法进行设计，让编程变得更有效率很更有趣。

![Go的祖先图](https://s1.ax1x.com/2020/07/05/UpeyrD.png)

## Go的设计原则

当Go被设计时，Java和C++是最常被用于服务端编程的语言，至少在谷歌是这样的。我们认为这些语言有着太多的重复和记录。一些程序员的反应是转向更为动态，更为流畅的语言，例如Python，但却以运行效率和类型安全作为代价。此时，我们认为应该有必要创造一门语言了。

Go试着降低输入重复字词的时间消耗。通过他的设计，我们试着降低了代码的复杂性和混乱性。在Go中没有提前声明(forward declarations)和头文件。任何内容都只声明一次，初始化是富有表达力，自动的，易于使用的。语法也是简单的。通过符号`:=`可以节省大量时间。也许最彻底的改变是没有类型继承，任何类型之间都没有关系。这些简化使得Go易于表达和理解，而不牺牲复杂性。

另一个重要的原则是保持概念正交(concepte orthogonal，就是使用组合的意思)，方法可以被任何类型实现，结构体代表数据，接口代表抽象等等，这样的设计使得我们可以用这些正交（毫不相干）的部分组合出我们想要的东西。这也更易于理解一个“组合而成”的东西。

## Go程序是否可以与C/C++程序连接？

有可能一起使用C和Go，在同一地址空间中，但是这并不是“无缝衔接”的，需要一些特殊接口软件。另外，连接C和Go代码，这相当于放弃了Go提供的内存安全和栈管理。在一些时候，这是绝对有必要使用C Lib去解决这个问题，此外这样做还会引入纯Go语言没有的风险，请小心这么做。

如果你需要使用C和Go，如何处理这个问题取决于Go编译器的实现，Go有三个编译器实现：
* `gc`:默认编译器
* `gccgo`:使用了GCC后端
* `gollvm`:一个不怎么成熟的编译器，使用了LLVM架构

`gc`使用了与C语言不通的调用约定，因此不能**直接**被C语言调用，反之亦然。[Cgo](https://golang.org/cmd/cgo/)提供了能被外部接口调用的机制。允许在Go代码中，调用C语言库。而SWIG则把这个功能扩展到了C++库。

你可以使用`cgo`/`swig`搭配`Gccgo`或者`gollvm`使用，因为他们都使用同一个传统API。最好是在代码层面调用他们。但是，要安全地完成这一任务，需要理解所有相关语言的调用约定，以及从Go调用C或c++时的栈限制。

## Go有 rumtime吗？

Go确实有一个扩展库叫做 `runtime`，它是没一个Go程序的一部分，`runtime`库实现了垃圾回收，并发，栈管理和其他重要的Go语言特性。尽管`runtime`对于Go很重要，但是它类似于C语言中的`libc`。

但是，Go的运行时不包括虚拟机(如Java运行时提供的虚拟机)，理解这一点很重要。Go程序被提前编译为本地机器码(或JavaScript或WebAssembly，对于某些不同的实现)。尽管`runtime`这个词经常被用来描述一个一个程序运行时的虚拟环境，但是在Go中，`runtime`这个词只是一个重要扩展库的名字而已。

## Go为什么没有异常

我们认为把异常耦合到控制结构中，比如“try-catch-finally”，会导致代码难以理解。它还鼓励程序员将许多常规错误标记为异常，比如文件打开失败。

Go使用另一种方式，对于普通的错误处理，Go的多值返回使得它可以很轻松的报告错误，而不用重载函数返回值。[标准错误类型](https://golang.org/doc/articles/error_handling.html)，加上Go的其他特性，使得错误处理很愉快，但与其他语言中的错误处理有很大不同。

Go也有一些内置函数，可以报告/恢复“真正”的异常。恢复机制仅在函数发生错误后关闭状态时执行，这足以处理很多情况，而且不需要额外的控制结构，如果使用得当，可以生成干净的错误处理代码。

更优雅的错误处理，请看[这篇文章](https://blog.golang.org/errors-are-values)，它介绍了Go的“错误也是值”的错误处理思想。

## Go为什么没有断言？

不可否认，它们非常方便，但我们的经验是，程序员使用它们作为一种拐杖，以避免考虑正确的错误处理和报告。正确的错误处理代表着服务器可以在错误发生后可以继续运行而不是奔溃。正确的错误报告意味着错误可以被准确，直接地报告，能节约程序员做“crash trace”的时间。当程序员看到错误而不熟悉代码时，精确的错误尤其重要。

我们理解这是争论的焦点。Go语言和库中有许多东西与现代实践不同，这只是因为我们觉得有时值得尝试不同的方法。

## 为什么选择CSP作为并发构想

随着时间的推移，并发和多线程编程以其困难而闻名。我们认为这是部分因为[pthread](https://en.wikipedia.org/wiki/POSIX_Threads)的设计和部分过于强调底层细节（例如`mutex`，`condition`和内存壁垒）的原因。可以通过高层的接口设计简化代码，即使在幕后仍有互斥锁的存在。

为并发提供高级语言支持的最成功的模型之一来自Hoare的通信顺序进程，简称CSP。Occam和Erlang是起源于CSP的两种众所周知的语言。Go的并发原语并不派生自它家族树。把通道作为第一类对象的强大概念。使用几种早期语言的经验表明，**CSP模型非常适合过程性语言框架。**

## 为什么使用Goroutines代替线程？

Gouroutines（协程）使得是并发易于处理的一部分。这种想法已经存在一段时间了，**它是将独立执行的函数协程多路传输到线程集合上。**当协程阻塞时，比如通过调用阻塞系统调用，`run-time`自动将同一操作系统线程上的其他协程移动到不同的可运行线程，这样它们就不会被阻塞。程序员看不到这些，这才是重点。其结果，我们称之为`goroutines`，它们占用空间很少，只有几Kb。

为了让栈小一些，Go的`run-time`使用可调节大小的，有界的栈。给一个新声明的协程分配几kb，这是完全够用的。如果不够用（或者太大），`run-time`会自动增加/减小协程在内存中的空间，这允许许多协程拥有一个合适的内存占有空间。每个函数调用的CPU开销平均大约有三条廉价指令。在同一个地址空间中创建数十万个goroutines是可行的。如果把协程换成线程的话，那么系统资源不可能同时被这么多线程分享。（线程数会小于协程数）

## 为什么map的操作不定义为原子性？

经过社区长时间的讨论后，我们决定，`map`的典型使用并不是多个goroutines安全访问，在那些需要安全访问的情况下，`map`可能是一些已经处理好同步性的数据结构和计算的一部分。因此，要求所有`map`操作都获取一个互斥锁将会降低大多数程序的速度，并增加少数程序的安全性。所以我们决定不把`map`的操作设置为原子性。

Go并不禁止原子`map`更新操作，在有必要的时候，你可以加上锁来操作`map`。

`map`访问只有在更新发生时才不安全。只要所有goroutines只读取查找映射中的元素，包括使用`for range`循环对其进行迭代，并且不通过分配元素或删除来更改`map`，那么它们可以安全地并发访问映射，而不需要同步。

## 为什么 len() 是内置函数而不是方法

我们对这个问题进行了讨论，但是最后决定吧`len`和它的“朋友们”作为函数会更好一些，并且没有把Go基本类型的接口问题复杂化。（要声明一个包含`len`方法的接口）

## 为什么Go不支持函数/操作符重载？

加入重载会导致代码难读。我们要保持简单。

## 我能把[]T转换成[]interface{}吗？

不能直接转换，因为两个类型在内存中的表达形式并不一样。我们需拷贝把单独的元素拷贝到一个目标切片中，比如下面这个例子，把一个`int`的切片转换成`interface{}`的切片。


```go
t := []int{1, 2, 3, 4}
s := make([]interface{}, len(t))
for i, v := range t {
    s[i] = v
}
```

## 如果T1和T2是同一种底层类型，我能把[]T1转换成[]T2吗 ？


```go
type T1 int
type T2 int
var t1 T1
var x = T2(t1) // OK
var st1 []T1
var sx = ([]T2)(st1) // NOT OK
```
在Go中，类型是和方法紧紧联系在一起的，每个被“命名”的类型都有一个方法集合（可能是空的），通用的规则是你可以转换的类型的名字（也有可能因此改变它的方法集），但是你不能转换一个集合的。Go需要你明确说出类型的转换。

## 为什么我的nil error值不等于nil？

在底层，`interface`接口被分为两个元素实现，类型`T`和值`V`，`V`是一个具体值例如`int`和`struct`或者指针，它不是接口自己本身，T是接口的类型。举个例子，我们存储一个`int`值为3在一个`interface`中，结果是这样的：`T=int,V=3`。`V`的值也被称为`interface`的动态值，因为在程序执行过程中，一个给定的`interface`可能有不同的`V`（但是都是同一个类型`T`）。

只有在`V`和`T`都未设置的情况下（`T=nil`，`V`没有设置），一个`interface`值才为`nil`。在实际过程中，一个`nil`接口的类型将一直是`nil`。如果我们储存一个`*int`类型的`nil`指针给一个`interface`，那么他的内在类型将会是`*int`，尽管这个指针指向`nil`(`T=*int,V=nil`)。这样的一个值将会不会被认为是`nil`，即使内部的`V`指向`nil`。

这种情况可能令人困惑，当nil值存储在接口值(如错误返回值)中时就会出现这种情况

```go
func returnsError() error {
	var p *MyError = nil
	if bad() {
		p = ErrBad
	}
	return p // 这将返回一个非nil值error.
}
```

如果顺利的话会返回一个`nil`值`error`，但是这个`error`是`T=*MyError，V=nil`。如果调用者把它和`nil`相比，那么永远会返回`false`，是的程序永远走向有错误的分支。正确的做法应该直接返回`nil`。
```go
func returnsError() error {
	if bad() {
		return ErrBad
	}
	return nil
}
```

对于返回错误的函数，比起在内部定义一个具体错误类型，在函数签名中标明返回错误类型是一个好办法。它能帮助我们确定返回错误的类型。例如[os.Open](https://golang.org/pkg/os/#Open)，总是返回一个`error`，即使不是`nil`，那么他也会返回一个具体类型`*os.PathError`。

只要使用`interface`，就会出现与这里描述的情况类似的情况。只要记住，如果在`interface`中存储了任何具体的值或类型，它就不会是nil。有关更多信息，请参见[反射定律](https://golang.org/doc/articles/laws_of_reflection.html)。

## 为什么Go不提供隐式类型转换呢？

在`C`中的隐式类型转换带来的阅读困难远大于它带来的便利。它会带来诸如溢出的问题。

此外它还会给编译器带来困难，所以我们为了保障`Go`的语义简单明确，我们并没有加入隐式转换。

与`C`不同的是，在`Go`，即使你的`int`是64位，那么`int`和`int64`也是不同类型的，你需要明确的指示你的类型。

## Go中的常量是如何工作的

尽管`Go`对于不同数值类型的变量之间的转换很严格，但是常量要灵活得多。像`23`，`3.14159`和`math.Pi`这样的常量是给定精度的不会溢出，比如`math.Pi`被声明为63位，而且已经超过了`float64`的存储范围，只有在常量被赋值给一个变量的时候，它才会有具体的类型。

因为常量只是数字而不是类型值，所以常量可以被更自由的使用，因此可以缓解严格的类型转换的尴尬，可以写出这样的代码

```go
sqrt2 := math.Sqrt(2)
```
编译器并不会报错，因为这里的`2`可以被自动转为`float64`精度，然后被`math.Sqrt(x float64)`调用。

_编者注：这里的意思是指`2`这样的无类型数值，本身就是常量，它被声明为许多类型，比如一下这些数值都是`1`：_

```go
1
1.000
1e3-99.0*10-9
'\x01'
'\u0001'
'b' - 'a'
1.0+3i-3.0i

//所以你可以这样用1这个常量
    var f float32 = 1
    var i int = 1.000
    var u uint32 = 1e3 - 99.0*10.0 - 9
    var c float64 = '\x01'
    var p uintptr = '\u0001'
    var r complex64 = 'b' - 'a'
    var b byte = 1.0 + 3i - 3.0i

    fmt.Println(f, i, u, c, p, r, b)
```

## 为什么map不支持slice作为key呢？

`map`查找需要一个相等运算符，这是`slice`没有实现的。之所以没有实现，是因为`slice`的相等涉及到了很多个因素，你如`slice`内还有`slice`，指针，内存等。我们可能会再次讨论这个问题，实现`slice`的相等性不会使任何现有程序无效，但是如果不清楚`slice`的相等性应该意味着什么，那么暂时不考虑它会更简单。

## 函数参数是值传递吗？

和所有类C语言一样，Go也是通过值传递。也就是说一个函数永远只会获得被传递的值的拷贝对象，**就相当于一个赋值语句把值付给函数参数。**举个例子，把一个`int`值传递给一个函数，会制造一个`int`类型的拷贝对象，**而传递一个指针则会传递该指针的拷贝对象，而不是指针指向的数据的拷贝对象。**

`Map`和`Slice`的行为类似指针：他们都是包含指向底层`map`或者`slice`的描述符。拷贝一个`Map`或者`Slice`并不会拷贝它们所指向的底层数据。拷贝一个`interface`会得到储存在`interface`内的值，如果`interface`内有接口体，那么会拷贝内在的结构体，如果`interface`持有一个指针，那么拷贝这个`interface`会得到这个指针的拷贝对象，但是不会得到这个指针指向的数据。

可以通过优化来提升拷贝值的效率。

## 什么时候我需要使用一个指向接口的指针？

大多情况下不需要，**使用指向接口的指针的情况很少**，**包括为延迟求值而伪装接口值的类型。**（disguising an interface value's type for delayed evaluation.）

常见的错误是把指向接口的指针传递给一个需要接口的方法。（_译者注：[见这个问题](https://stackoverflow.com/questions/51530429/type-inode-is-pointer-to-interface-not-interface/)_）这会使得编译器报错而且也会留下疑惑，因为有些时候[一个指针有必要去满足一个接口](https://golang.org/doc/faq#different_method_sets)，事实是一个指向具体类型的指针可以满足一个接口，但是**指向一个接口的指针永远不能满足接口**。

思考以下的变量声明：
函数`Fprintf`的第一个参数需要传入具有`write`方法的类型。

```go
var w io.Writer
fmt.Fprintf(w, "hello, world\n")
fmt.Fprintf(&w, "hello, world\n") // Compile-time error.
```

## 我要把方法接收器设为值还是指针？


```go
func (s *MyStruct) pointerMethod() { } // method on pointer
func (s MyStruct)  valueMethod()   { } // method on value
```

把接受者（receiver）设置为值还是指针，有以下几个方面的考虑：

第一点也是最重要的一点就是，这个方法需不需要修改接受者？如果需要修改它本身的话，那么`receiver`必须设置为指针。

第二点是考虑到运行效率，如果`receiver`过大的话，一个过大的结构体实例的传递会照成资源浪费，这个时候推荐使用指针`receiver`。

第三点是如果该类型的某些方法必须具有指针接收器，则其余的方法也应如此，因此无论如何使用该类型，方法集都是一致的。 有关详细信息，请参见[方法集](https://golang.org/doc/faq#different_method_sets)部分。

## new 和 make有什么区别？

简单的说，`new`会分配内存，而`make`用来初始化`slice，map，channel`。

以下内容来自[effective-go](https://golang.org/doc/effective_go.html#allocation_new)。

Go有两个分配内存原语操作：`new`和`make`。

### new

它是语言内置的用来分配内存的函数，但是不像其他语言中的`new`，Go中的`new`只负责分配内存，而不负责初始化，也就是说使用`new`得到的对象的值都是零值。使用`new(T)`得到的`T`对象，它的所有值都会被设为零值，并返回对象的地址，一个类型为`*T`的对象。用Go术语来说，`new`返回一个`T`类型的零值。

因为通过`new`返回的对象是零值，在不需要进一步设计你的数据结构的时候，`new`是十分方便的操作符。这意味着，使用数据结构的用户可以通过`new`操作获得一个对象并立刻工作。举例来说，`bytes.Buffer`的文档说，`Buffer`的零值是一个空缓存区。同样的，`sync.Mutex`并没有显式的构造器或者`Init`方法，而且`sync.Mutex`的零值被定义为未上锁的互斥量。

零值是可以传递，也就是一个结构体内如果有其他成员，那么这个结构体的零值被定义为这些成员的零值。

### make

内置函数`make(T,args)`的目的与`new(T)`不同，它只能创造一个`slice`,`maps`或者`channels`。并且它但返回一个已经被初始化了的`T`类型值，**之所以和`new`区分开，是因为这三种类型的底层是对数据结构的引用，所以它们在使用前必须要被初始化。**举个例子，一个`slice`，是一个包含着三个子项的描述符（`len`，`cap`，后台数组）,除非这三个子项被初始化了，不然`slice`就是`nil`。对于`slice`，`maps`和`channel`，`make`操作会初始化它们内部的数据结构让它们能被使用，比如：

```go
make([]int, 10, 100)
```

它创建了一个有着`100`个`int`元素的数组，并且创建了一个长度为`10`，容量为`100`的指向最前面`10`个元素的切片。相反如果使用`new([]int)`则会返回一个刚被分配空间，指向`nil`的`slice`。

以下的例说明了`new`和`make`的区别：

```go
var p *[]int = new([]int)       // allocates slice structure; *p == nil; rarely useful
var v  []int = make([]int, 100) // the slice v now refers to a new array of 100 ints

// Unnecessarily complex:
var p *[]int = new([]int)
*p = make([]int, 100, 100)

// Idiomatic:
v := make([]int, 100)
```

