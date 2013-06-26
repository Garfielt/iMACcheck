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
<!--#include file="config.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=sitename%></title>
<style type="text/css">
<!--
body,td,th {
	font-size: 12px;
}
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>
<frameset framespacing="0" border="0" frameborder="0" rows="68,*">
	<frame name="banner" scrolling="no" noresize target="contents" src="top.asp">
	<frameset cols="150,*">
		<frame name="contents" target="main" src="menu.asp">
		<frame name="main" src="main.asp" scrolling="auto" noresize>
	</frameset>
	<noframes>
	<body>

	<p>此网页使用了框架，但您的浏览器不支持框架。</p>

	</body>
	</noframes>
</frameset>

</html>
