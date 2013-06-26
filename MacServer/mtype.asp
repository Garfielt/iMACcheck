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
<base target="main">
<STYLE type="text/css">
a:link       {text-decoration: none; font-family: AdobeSm; color: #000000 }
a:visited    {text-decoration: none; color: #000000 }
A:hover      {COLOR: green; FONT-FAMILY: "宋体,MingLiU"; TEXT-DECORATION: underline}
body         {font-size: 9pt; font-family: 宋体,MingLiU, Arial;color: #000000}
TD           {FONT-SIZE: 9pt; FONT-FAMILY: "宋体,MingLiU, Arial";color: #000000;table-layout:fixed;word-break:break-all}
p            {FONT-SIZE: 9pt; FONT-FAMILY: "宋体,MingLiU, Arial";color: #000000}
input        {FONT-SIZE: 9pt; FONT-FAMILY: "宋体,MingLiU, Arial";color: #000000}
body         {
	margin-top: 10px;
	margin-bottom: 0;
	margin-left:0;
	margin-right:0;
	color: #000000;
	background-color: #FFFFFF;
}
select       {FONT-SIZE: 9PT;}
option       {FONT-SIZE: 9pt;}
textarea     {FONT-SIZE: 9pt;}
</STYLE>
<script language="javascript">
function CheckForm(){
  if(document.myform.htitle.value==''){
    alert('作业标题不能为空！');
    document.myform.htitle.focus();
    return false;
  }
}
</script>
</head>
<body>
<!--#include file="config.asp"-->
<!--#include file="conn.asp"-->
<%
action=trim(request("action"))
dealid=trim(request("id"))

if action="add" then
	
	mdes = trim(request("mdes"))
	mtype = trim(request("mtype"))
	mmodels = trim(request("mmodels"))
	stime = now()
	
	'response.write "insert into [mtypes] ([mtype],[mdes],[mdate]) values ('"&mtype&"','"&mdes&"','"&stime&"')"
	if len(mtype)>1 then conn.Execute "insert into [mtypes] ([mtype],[mdes],[mmodels],[mdate]) values ('"&mtype&"','"&mdes&"','"&mmodels&"','"&stime&"')"
end if

if action="update" then
	mdes = trim(request("mdes"))
	mtype = trim(request("mtype"))
	mmodels = trim(request("mmodels"))
	'response.write "update [macmanage] set mdes='"&mdes&"',mstart='"&mstart&"',vstart='"&vstart&"',mend='"&mend&"',vend='"&vend&"',mtype='"&mtype&"',mnum='"&mnum&"' where ID="&dealid
	conn.Execute "update [mtypes] set mtype='"&mtype&"',mdes='"&mdes&"',mmodels='"&mmodels&"' where ID="&dealid
end if

if action="edit" then
	sql = "select * from [mtypes] where ID="&dealid
	Set ers = Server.CreateObject("ADODB.RecordSet")
	ers.Open sql,conn,1,1
	emdes = ers("mdes")
	emtype = ers("mtype")
	emmodels = ers("mmodels")
	ers.close
	set ers=nothing
	doedit = 1
end if

if doedit = 1 then
	nextaction = "update"
	nextcommand = "更 新"
else
	nextaction = "add"
	nextcommand = "添 加"
end if
%>
<div align="center">
<table width="98%" border="1" align="center" cellpadding="5" bordercolor="#C0C0C0" id="table3" style="border-collapse: collapse">
<form method="POST" name="myform" id="myform" action="?action=<%=nextaction%>&id=<%=dealid%>">
  <tr>
    <td align="center" background="images/bj6.jpg"><label><strong>方案标识</strong></label></td>
    <td align="left" background="images/bj6.jpg"><input name="mtype" type="text" id="mtype" size="20" value="<%=emtype%>" maxlength="20" /></td>
  </tr>
  <tr>
    <td align="center" background="images/bj6.jpg"><label><strong>方案描述</strong></label></td>
    <td align="left" background="images/bj6.jpg"><input name="mdes" type="text" id="mdes" size="60" value="<%=emdes%>" maxlength="250" /></td>
  </tr>
  <tr>
    <td width="130" align="center"><strong>适用型号</strong></td>
    <td align="left"><textarea name="mmodels" cols="60" rows="4" id="mmodels"><%=emmodels%></textarea></td>
  </tr>
  <tr>
    <td colspan="2" align="center" background="images/bj3.jpg"><input type="submit" value="<%=nextcommand%>" name="add"/>
　　　　
  <input type="reset" value="重 置" name="B2" /></td>
  </tr>
  </form>
</table>
<table width="98%" border="1" align="center" cellpadding="3" cellspacing="0" bordercolor="#CCCCCC" id="table2" style="border-collapse: collapse; margin-top:10px;">
	<tr>
		<td width="31" height="25" align="center" background="images/bj5.jpg"><strong><font color="#FFFFFF">ID</font></strong></td>
		<td width="278" align="center" background="images/bj5.jpg"><strong><font color="#FFFFFF">方案标识</font></strong></td>
		<td width="278" align="center" background="images/bj5.jpg"><strong><font color="#FFFFFF">方案描述</font></strong></td>
		<td width="623" height="25" align="center" background="images/bj5.jpg"><strong><font color="#FFFFFF">适用型号</font></strong></td>
		<td align="center" width="244" background="images/bj5.jpg" height="25"><strong><font color="#FFFFFF">添加时间</font></strong></td>
        <td align="center" width="118" background="images/bj5.jpg"><strong><font color="#FFFFFF">操 作</font></strong></td>
	</tr>
<%
sql = "select * from mtypes order by ID desc"
Set rs = Server.CreateObject("ADODB.RecordSet")
rs.Open sql,conn,1,1

if rs.recordcount<>0 then
	for i=0 to rs.recordcount
		if i mod 2 = 0 then
 			tbgcolor = "#EFEFEF"
		else
			tbgcolor = "#FFFFFF"
		end if
%>
	<tr bgcolor="<%=tbgcolor%>">
		<td align="center">
	  <%=(i+1)%></td>
	  <td align="center"><%=rs("mtype")%></td>
      <td align="center"><%=rs("mdes")%></td>
	  <td align="center"><%=rs("mmodels")%></td>
	  <td width="244" align="center" ><%=rs("mdate")%></td>
      <td width="118" align="center" ><a href="?id=<%=rs("ID")%>&amp;action=edit">修改</a></td>
	</tr>
<%
  rs.movenext
  if rs.eof then exit for
 next
end if
%>
</table>
<%
rs.close
set rs=nothing
conn.close
set conn=nothing
%>
</body>
</html>