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
dealid=trim(request("ID"))


Function HTMLDecode(s)
	If Trim(s)<>"" Then
	's = Replace(s, CHR(13),"<br />") '回车符
	's = Replace(s, CHR(10),"<br />") '换行符
	s = Replace(s, CHR(32)," ") '空格
	s = Replace(s, CHR(9)," ") 'TAB键的空格
	End If
	HTMLDecode = s
End Function

Function doselect(v,vitem,vdes)
	If v=vitem Then
		response.write "<label><input type='radio' name='mtype' id='radio' value='"&vitem&"' checked='checked'/>"&vdes&"</label>"
	else
		response.write "<label><input type='radio' name='mtype' id='radio' value='"&vitem&"'/>"&vdes&"</label>"
	End If
	HTMLDecode = s
End Function

if action="add" then
	
	mdes = trim(request("mdes"))
	mstart = trim(request("mstart"))
	vstart = trim(request("vstart"))
	mend = trim(request("mend"))
	vend = trim(request("vend"))
	mtype = trim(request("mtype"))
	mnum = int(trim(request("mnum")))
	stime = now()
	
	'response.write "insert into [macs] ([mdes],[mstart],[vstart],[mend],[vend],[mtype],[mnum],[matime]) values ('"&mdes&"','"&mstart&"','"&vstart&"','"&mend&"','"&vend&"','"&mtype&"','"&mnum&"','"&stime&"')"
	if len(mdes)>1 then conn.Execute "insert into [macs] ([mdes],[mstart],[vstart],[mend],[vend],[mtype],[mnum],[matime]) values ('"&mdes&"','"&mstart&"','"&vstart&"','"&mend&"','"&vend&"','"&mtype&"','"&mnum&"','"&stime&"')"
end if

if action="update" then
	mdes = trim(request("mdes"))
	mstart = trim(request("mstart"))
	mend = trim(request("mend"))
	mtype = trim(request("mtype"))
	mnum= trim(request("mnum"))
	'response.write "update [macmanage] set mdes='"&mdes&"',mstart='"&mstart&"',vstart='"&vstart&"',mend='"&mend&"',vend='"&vend&"',mtype='"&mtype&"',mnum='"&mnum&"' where ID="&dealid
	conn.Execute "update [macs] set mdes='"&mdes&"',mstart='"&mstart&"',mend='"&mend&"',mtype='"&mtype&"',mnum='"&mnum&"' where ID="&dealid
end if

if action="edit" then
	sql = "select * from [macs] where ID="&dealid
	Set ers = Server.CreateObject("ADODB.RecordSet")
	ers.Open sql,conn,1,1
	emdes = ers("mdes")
	emstart = ers("mstart")
	emend = ers("mend")
	emtype = ers("mtype")
	emnum = ers("mnum")
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
    <td width="130" align="center" background="images/bj3.jpg"><strong>批次备注</strong></td>
    <td align="left" background="images/bj3.jpg"><input name="mdes" type="text" id="mdes" size="60" value="<%=emdes%>" maxlength="200" /></td>
    </tr>
  <tr>
    <td align="center" background="images/bj6.jpg"><label><strong>起始MAC</strong></label></td>
    <td align="left" background="images/bj6.jpg">
      <input name="mstart" type="text" id="mstart" size="20" value="<%=emstart%>" maxlength="15" /></td>
  </tr>
  <tr>
    <td align="center" background="images/bj6.jpg"><strong>结束MAC</strong></td>
    <td align="left" background="images/bj6.jpg">
      <input name="mend" type="text" id="mend" size="20" value="<%=emend%>" maxlength="15" /></td>
  </tr>
  <tr>
    <td align="center" background="images/bj6.jpg"><strong>批次数量</strong></td>
    <td align="left" background="images/bj6.jpg">
      <input name="mnum" type="text" id="stitle7" size="20" value="<%=emnum%>" maxlength="12" /></td>
  </tr>
  <tr>
    <td align="center" background="images/bj6.jpg"><strong>方案数量</strong></td>
    <td align="left" background="images/bj6.jpg">
	<%
	sql = "select * from mtypes order by ID desc"
	Set rs = Server.CreateObject("ADODB.RecordSet")
	rs.Open sql,conn,1,1
	if rs.recordcount<>0 then
		for i=0 to rs.recordcount
			doselect emtype,rs("ID"),rs("mtype")
			rs.movenext
		next
	end if
	%>
</td>
  </tr>
  <tr>
    <td colspan="2" align="left"><p>

    </p>      </td>
  </tr>
  <tr>
    <td colspan="2" align="center" background="images/bj3.jpg"><input type="submit" value="<%=nextcommand%>" name="add"/>
　　　　
  <input type="reset" value="重 置" name="B2" /></td>
  </tr>
  </form>
</table>
<table width="98%" border="1" align="center" cellpadding="3" cellspacing="0" bordercolor="#CCCCCC" id="table2" style="border-collapse: collapse; margin-top:10px;">
	<tr>
		<td width="60" height="25" align="center" background="images/bj5.jpg"><strong><font color="#FFFFFF">ID</font></strong></td>
		<td width="380" align="center" background="images/bj5.jpg"><strong><font color="#FFFFFF">批次备注</font></strong></td>
		<td width="565" height="25" align="center" background="images/bj5.jpg"><strong><font color="#FFFFFF">MAC区段</font></strong></td>
		<td align="center" width="171" background="images/bj5.jpg" height="25"><strong><font color="#FFFFFF">方案(数量)</font></strong></td>
        <td align="center" width="118" background="images/bj5.jpg"><strong><font color="#FFFFFF">操 作</font></strong></td>
	</tr>
<%
sql = "select m.*,t.mtype as type from macs m left join mtypes t on m.mtype=t.ID order by m.ID desc"
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
	    <td align="center"><%=rs("mdes")%></td>
      <td align="center"><%=rs("mstart")%> - <%=rs("mend")%></td>
	  <td width="171" align="center" ><%=rs("type")%>(<%=rs("mnum")%>)</td>
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