# FractionCalculateEngineExample

***This parser calculates more than fraction, and normal expression as well, so you can expand this library to normal calculation，detail illustration will be added in the near future.

Parser Theory : Gradient descent

Parser Process:
<p align="center" >
  <img src="https://github.com/LMsgSendNilSelf/FractionCalculateEngineExample/blob/master/%E7%B4%A0%E6%9D%90/%E6%B5%81%E7%A8%8B.png" alt="解析流程" title="解析流程">
 
For example：1+2*（3-4） parsing process：

1. Tokenizer:
Tokens：1, +,  2, *, (,  3,  -,  4,  ）

2. Interpreter：
  Indicate the vague tokens，such as  '+' means add or positive ，so is 'negative'.
 
3. Parser
<p align="center" >
  <img src="https://github.com/LMsgSendNilSelf/FractionCalculateEngineExample/blob/master/%E7%B4%A0%E6%9D%90/parser" alt="解析数据" title="解析数据">
</p>

AST：
<p align="center" >
  <img src="https://github.com/LMsgSendNilSelf/FractionCalculateEngineExample/blob/master/%E7%B4%A0%E6%9D%90/ast.png" alt="抽象树" title="AST">
</p>

------------------------------------------------------------------------
Tips：

1. adjust number  ,which is  regarded as fraction through process，such as
  
	2 convert to 2/1 ;
	0.2 convert to 2/10;
	0.9998 convert to 9998/10000

2. because of object-c without function operator,we need convert operators,such as @"+", to function name,such as "add"

Todo ：

1 processing，

2 demo，

3 more test
