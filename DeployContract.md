### 合约部署步骤
* 先部署tokenStore合约
* 部署blanklistStore合约
* 部署token合约
* 部署adminUpgradeability合约
<p>
<p>最后部署adminUpgradeability合约时候参数依次为：token合约地址，admin地址，initcalldata（这个参数是将16进制函数编码结果转为ascii填入）
<p>接下来使用初始化时候的owner通过adminUpgradeability合约代理调用方法setTokenStore()方法将tokenStore合约地址传入，调用setBlanklistStore()将blanklistStore合约地址传入。
<p>紧接着使用初始化时候的owner通过adminUpgradeability合约代理调用方法updateMinter()，设置minter，调用updateBlanklister()方法设置blanklister，调用updatePauser()设置pauser
<p>接下来使用tokenStore合约的owner调用updateOperator()方法将operator设置为adminUpgradeability合约地址，使用blanklistStore合约owner调用updateOperator()方法将operator设置为adminUpgradeability合约地址
