---
title: Go返回一个不可变，只读，不可写的对象
comment:
  - false
categories:
  - golang
tags:
  - go-tricks
photos:
  - https://s1.ax1x.com/2020/07/01/NH8ZXd.jpg
date: 2020-07-01 23:04:28
---

在工作中，可能会遇到这样的需要：某个函数返回一个私有的列表`Alist`，这就相当于对外界暴露了这个列表，而列表本身的一些方法，比如Java中的`add`和大多语言中的按下标取值赋值`Alist[i]=new_data`，这就导致列表和原列表都被外部代码恶意篡改了。所以我们需要返回一个**不会影响原列表**或者**可读不可写**的对象。
<!-- more -->
下文我们以`Slice`举例。

## Slice的指针

`Slice`是一个特殊的结构体，它的一个指针指向了包含数据的数组。结构定义如下：

```go
// runtime/slice.go
type slice struct {
    array unsafe.Pointer	// 8 bytes
    len   int				// 8 bytes
    cap   int				// 8 bytes
}

```

如果把一个`slice`赋值给了一个结构体内的`slice`成员，那么对前者进行改动，那么后者的切片数据也会被影响。

比如下方这个例子：无论是修改原有的列表修改函数返回的列表，都会发现结构体内的列表被修改了。

```go
package main

import "fmt"

type Person struct {
	nums []int
}

func (p *Person) SetNum(num []int) {
	p.nums = num
}

func (p Person) GetNum() []int {
	return p.nums
}

func main() {
	// 初始化
	p := Person{}
	num := []int{1, 2, 3}
	p.SetNum(num)

	// 修改传入的列表
	num[2] = 5
	// 查看是否结构体内的列表也被修改
	fmt.Println(p)

	// 通过Get返回列表，再修改，查看
	getNum := p.GetNum()
	getNum[2] = 4
	fmt.Println(p)

}

// output
{[1 2 5]}
{[1 2 4]}
```

## 深拷贝

最简单的方法就是通过返回深拷贝的列表来实现“隔离”的效果，**但是，这个并没有达到我们要求的可读不可写**。

```go
package main

import "fmt"

type Person struct {
	nums []int
}

func (p *Person) SetNum(num []int) {
	var num_cpy = make([]int, len(num))
	copy(num_cpy, num)
	p.nums = num_cpy
}

func (p Person) GetNum() []int {
	cpy := make([]int, len(p.nums))
	copy(cpy, p.nums)
	return cpy
}

func main() {
	p := Person{}
	num := []int{1, 2, 3}
	p.SetNum(num)

	num[2] = 5
	fmt.Println(p)

	getNum := p.GetNum()
	getNum[2] = 4
	fmt.Println(p)

}

```

## 封装到结构体内

把传入的切片用深拷贝赋值给结构体内参数，**把函数返回的列表封装到结构体内，设有私有，提供`range`方法**。这是一个我想到最好的方法了。


```go
package main

import (
	"fmt"
	"sync"
)

type Person struct {
	nums []int
}

func (p *Person) SetNum(num []int) {
	var num_cpy = make([]int, len(num))
	copy(num_cpy, num)
	p.nums = num_cpy
}

func (p Person) GetNum() rtnlist {
	return rtnlist{
		s: p.nums,
	}
}


// 新增的封装列表的结构体
type rtnlist struct {
	s []int
}

func (r rtnlist) Iter() chan int {
	var wg sync.WaitGroup
	wg.Add(len(r.s))

	c := make(chan int, len(r.s))
	go func() {
		for _, num := range r.s {
			wg.Done()
			c <- num
		}
	}()
	go func() {
		wg.Wait()
		close(c)

	}()
	return c
}

func main() {
	// 初始化
	p := Person{}
	num := []int{1, 2, 3}
	p.SetNum(num)

	// 修改传入的列表
	num[2] = 5
	// 获取函数返回的参数
	r := p.GetNum()
	for num := range r.Iter() {
		fmt.Print(num)
	}

}

```