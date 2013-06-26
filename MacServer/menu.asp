<%
'***************************************************************
'author：liuwt123
'E-mail:liuwt123@gmail.com  liuweitao@haier.com
'http://blog.iscsky.net
'http://weibo.com/liuwt123
'***************************************************************
%>
<%
if session("power") <> "admin" then
   Response.Redirect "login.asp"
   Response.end
end If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<!--#include file="config.asp"-->
<base target="main">
<STYLE type="text/css">
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
<!--
a:link       {text-decoration: none; font-family: AdobeSm; color: #000000 }
a:visited    {text-decoration: none; color: #000000 }
A:hover      {COLOR: green; FONT-FAMILY: "宋体,MingLiU"; TEXT-DECORATION: underline}
body         {font-size: 9pt; font-family: 宋体,MingLiU, Arial;color: #000000}
TD           {FONT-SIZE: 9pt; FONT-FAMILY: "宋体,MingLiU, Arial";color: #000000;table-layout:fixed;word-break:break-all}
p            {FONT-SIZE: 9pt; FONT-FAMILY: "宋体,MingLiU, Arial";color: #000000}
input        {FONT-SIZE: 9pt; FONT-FAMILY: "宋体,MingLiU, Arial";color: #000000}
body         {margin-top: 0; margin-bottom: 0;margin-left:0;margin-right:0; color: #000000}
select       {FONT-SIZE: 9PT;}
option       {FONT-SIZE: 9pt;}
textarea     {FONT-SIZE: 9pt;}
-->
</STYLE>
</head>
<!--#include file="config.asp"-->
<!--#include file="conn.asp"-->
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" marginwidth="0" marginheight="0" background="images/bj2.jpg" >
<center>
<table border="0" width="131" id="table1" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center" width="131" colspan="2">
		<img border="0" src="images/nothing.jpg" width="4" height="3"></td>
	</tr>
	<tr>
		<td align="center" height="32" background="images/bj1.jpg" width="36">
		<p>
		<img border="0" src="images/1008.gif" width="23" height="24"></td>
		<td align="left" width="95" height="32" background="images/bj.jpg"><font color="#000000"><a href="main.asp" target="main">批次管理</a></font></td>
	</tr>
	<tr>
		<td align="center" height="32" background="images/bj1.jpg" width="36">
		<p>
		<img border="0" src="images/1015.gif" width="23" height="24"></td>
		<td align="left" width="95" height="32" background="images/bj.jpg"><font color="#000000"><a href="mtype.asp" target="main">类型管理</a></font></td>
	</tr>
	<tr>
		<td align="center" height="32" background="images/bj1.jpg" width="36">
		<p>
		<img border="0" src="images/1009.gif" width="24" height="22"></td>
		<td align="left" width="95" height="32" background="images/bj.jpg"><font color="#FFFFFF">
		<a target="main" href="mrecords.asp">
		<font color="#000000" style="font-size: 9pt">使用记录</font></a></font></td>
	</tr>
	<tr>
		<td align="center" height="32" background="images/bj1.jpg" width="36">
		<p>
		<img border="0" src="images/1016.gif" width="19" height="24"></td>
		<td align="left" width="95" height="32" background="images/bj.jpg"><a href="login.asp?action=out" target="_top">退出登陆</a>		</td>
	</tr>
</table>
</body>

</html>