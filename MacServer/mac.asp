<!--#include file="config.asp"-->
<!--#include file="json.asp"-->
<%
'***************************************************************
'author：liuwt123
'E-mail:liuwt123@gmail.com  liuweitao@haier.com
'http://blog.iscsky.net
'http://weibo.com/liuwt123
'***************************************************************
%>
<%
Response.Buffer = True 
On Error Resume Next

Dim rstat
Set rstat = jsObject()
imac = trim(request("mac"))
isern = trim(request("sern"))
ipline = trim(request("pline"))
itime = Now()
tsern = Left(isern,11)

'SQL Server stuff
dim Conn,sql,rs
set Conn= Server.CreateObject("ADODB.Connection")
ConnStr = "DRIVER={Microsoft Access Driver (*.mdb)};DBQ="&Server.MapPath(DbLocal)
Conn.open ConnStr

if isauth Then
	'MAC重复查询
	sql = "select count(*) as num from mrecords where mac='"& imac &"' or sern='"& imac &"'"
	Set rs = Server.CreateObject("ADODB.RecordSet")
	rs.Open sql,conn,1,1
	
	if rs.recordcount = 1 Then
		rstat("mtype") = "溢出"
		rstat("xh") = tsern
	'MAC类型查询
	sql = "select mtype from macs where mstart<'"& imac &"' and mend>'"& imac &"'"
	Set rs = Server.CreateObject("ADODB.RecordSet")
	rs.Open sql,conn,1,1

	if rs.recordcount = 1 Then
		tmtype = rs("mtype")
		'TV应使用MAC类型查询
		conn.Execute "insert into [mrecords] ([mac],[sern],[utype],[pline],[addtime]) values ('"&imac&"','"&isern&"','"&tmtype&"','"&ipline&"','"&itime&"')"
	Else
		rstat("mtype") = "溢出"
		rstat("xh") = tsern
	End if
	rs.close
	set rs = Nothing
Else
	rstat("mtype") = "OK"
	rstat("xh") = tsern
End if

'response.write "insert into [macs] ([mac],[sern],[pline],[orderno],[addtime]) values ('"&imac&"','"&isern&"','"&ipline&"','"&iorderno&"','"&itime&"')"

Conn.close
set Conn = Nothing
rstat("stat") = "ok"
rstat.Flush
%>