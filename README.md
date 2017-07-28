# FractionCalculateEngineExample
Why write this engine？

The reason is I coded a supercalculator last year in Appstore, which is based on one more completed parser.

This parser is just a simplified prototype. It calculates not only fraction but normal expression, so you can enrich this library in normal calculation. Detail illustration will be added in the near future.

Parser Theory : Gradient descent

Parser Process:
<p align="center" >
  <img src="https://github.com/LMsgSendNilSelf/FractionCalculateEngineExample/blob/master/%E7%B4%A0%E6%9D%90/%E6%B5%81%E7%A8%8B.png" alt="解析流程" title="解析流程">
 
For example：1+2*（3-4） parsing process：

1. Tokenizer:
Tokens：1, +,  2, *, (,  3,  -,  4,  ）

2. Interpreter：
  Specify the vague tokens，i.e '+' means add or positive ，the same as '-'.
 
3. Parser
<p align="center" >
  <img src="https://github.com/LMsgSendNilSelf/FractionCalculateEngineExample/blob/master/%E7%B4%A0%E6%9D%90/parser" alt="解析数据" title="解析数据">
</p>

AST(抽象树)：
<p align="center" >
  <img src="https://github.com/LMsgSendNilSelf/FractionCalculateEngineExample/blob/master/%E7%B4%A0%E6%9D%90/ast.png" alt="抽象树" title="AST">
</p>

In fact, the math expression is parsed into one custom nested cluster in coding，and then resolve sub-expression on each level from inside to outside one.

------------------------------------------------------------------------
Tips：

1. adjust number, which is regarded as fraction through process，such as
  
	2 convert to 2/1 ;
	0.2 convert to 2/10;
	0.9998 convert to 9998/10000

2. because of object-c without function operator,we need to convert operators to function name, i.e @"+" to "add"

Todo ：

1 processing，

2 demo，

3 more test

