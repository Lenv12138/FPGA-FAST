已经完成fast_score的源代码的设计, 紧接着需要完成对连续性判断的验证, 以及DMA接口的设计.

![连续的patch](../asset/20221115170245.png)  
![第一拍计算到的cmr](../asset/20221115170317.png)  

## 各个模块的延迟分析

![threadsholder延迟](../asset/20221115193054.png)  

在第一个时钟沿, 第一个patch的数据刚刚来到阈值(`threadsholder`)模块,因此在该上升沿采样到的数据不是第一个patch的数据, 在第一个时钟沿`#1step`之后, 驱动patch相关的信号变为第一个patch的数据, 即第一个patch的数据进入阈值模块.

在第二个时钟沿, 采样到第一个patch的数据, 并在该时钟沿`#1step`之后计算出`cmr`和`rmc`值并驱动`cmr`和`rmc`信号变化.

在第三个时钟沿, 采样到`cmr`和`rmc`值, 并在该时钟沿`#1step`之后计算`cmrt`和`rmct`值并驱动`cmrt`和`rmct`信号变化.

在第四个时钟沿, 采样到`cmrt`和`rmct`值, 并在该时钟沿`#1step`之后计算`oxd`和`oxb`, `bright`和`dark`, 并驱动这些信号变化.

因此, 从第一个patch的数据来到阈值模块, 到阈值输出正确的信号, 延迟了3个时钟周期.

![compute_score模块](../asset/20221115194445.png)  

在第一个时钟沿, 阈值模块刚刚驱动`oxd`和`oxb`信号输出正确的值, 因此在该时钟沿score值计算模块(`compute_score`)并没有采样到第一个patch所对应的`oxd`和`oxb`信号.

在第二个时钟沿, score值计算模块采样到第一个patch所对应的`oxd`和`oxb`信号, 并在该时钟沿`#1step`之后计算`sxb`和`sxd`的值, 驱动`sxb`和`sxd`信号改变.

在第三个时钟沿, 采样到`sxb`和`sxd`的值, 并在该时钟沿`#1step`之后计算`ssxb`和`ssxd`的值, 驱动`ssxb`和`ssxd`信号改变.

在第四个时钟沿, 采样到`ssxb`和`ssxd`的值, 并在该时钟沿`#1step`之后计算`sssxb`和`sssxd`的值, 驱动`sssxb`和`sssxd`信号改变.

在第五个时钟沿, 采样到`sssxb`和`ssxd`的值, 并在该时钟沿`#1step`之后计算`sum_all_b`和`sum_all_d`的值, 驱动`sum_all_d`和`sum_all_d`信号改变.

在第6个时钟沿, 采样到`sum_all_b`和`sum_all_d`的值, 计算第一个patch所对应的score值, 并驱动`score`信号改变.

因此, 从阈值模块输出第一个patch的`oxd`和`oxb`信号到score计算模块开始, 到score计算模块输出第一个patch所对应的score值, 经过了5个时钟周期的延迟.

综上, 从第一个patch的数据到达阈值模块门口(信号还未传达到模块内部)开始, 到输出第一个patch的score值, 总共经过了8个时钟周期的延迟.

![contig_process](../asset/20221115195918.png)  

连续性判断模块的延迟也为5个时钟周期. 从阈值判断模块驱动`bright`和`dark`信号到达连续性判断模块门口开始, 到连续性判断模块输出第一个patch所对应的连续性标志信号, 经过了5个clk的时钟周期的延迟.

## 对于坐标的延迟

首先对于x坐标的延迟, 由于当实际坐标到达patch的第7列数据时, 该patch对应的是第4列角点的计算, 所以需要延迟3个时钟周期. 又由于从`data_in`到数据进入`fast_fifo`模块内有1个时钟周期的延迟, 所以对于x坐标需要延迟4个时钟周期.

对于y坐标的延迟, 由于当实际坐标到达patch的第7行数据时, 该patch对应的是第4行角点的计算, 所以首先需要**延迟3行(也就是3*640个时钟周期)**, 同时需要将y坐标与x坐标同步, 所以需要再延迟4个时钟周期, 又由于从行结束信号(`EOL`)到`cnt_row`信号存在1个时钟周期的延迟, 所以y坐标在延迟了3行之后, 需要再延迟5个时钟周期才能够与x坐标同步.


## 加入NMS后存在的问题

### NMS会处理无效值

![](asset/20230119205935.png)  

从上面的图可以看出, 在坐标为(77,0)时, FAST的连续判断模块, 判断该角点为连续, 但是很明显这个是不对的, 这是因为当(77,0)这个点输入后, 在patch中的数据, 还保存了每一行最后几个的数据. 

![](asset/20230119210526.png)  

这个图是当中心点为(78,4)(matlab中以1为起点)时, patch中对应存储的数据. 

![](asset/20230119210650.png)  

![](asset/20230119211104.png)  

这个图是当中心点的坐标为(77,0)时patch中的数据, 从图中可以看出, 这个patch中的数据还保存了上面几行末尾的数据. 

目前想到的解决办法是, 在NMS中将数据存储到fifo中时, 进行筛选:

```verilog{.line-numbers}
if (data_in[13] & xy_coord_vld) begin
    ram0[address_write_d]<=data_in; 		// data input to delay buffer 0
    {o_20, o_21, o_22} <= {o_21, o_22, data_in};
end else begin
    ram0[address_write_d]<={data_in[33 -: 20], 14'd0};
    {o_20, o_21, o_22} <= {o_21, o_22, {data_in[33 -: 20], 14'd0}};
end

ram1[address_write_d]<=data_out_0; 	// data input to delay buffer 1

data_out_0<=ram0[address_read_d];  	// read FIFO 0
data_out_1<=ram1[address_read_d];  	// read FIFO 1

{o_00, o_01, o_02} <= {o_01, o_02, data_out_1};
{o_10, o_11, o_12} <= {o_11, o_12, data_out_0};   
```

加入只有当前输入的数据是角点, 并且坐标有效, 才会将对应的score值存入fifo, 否则score值和iscorner都存储0.