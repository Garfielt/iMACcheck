<%
'***************************************************************
'author£ºliuwt123
'E-mail:liuwt123@gmail.com  liuweitao@haier.com
'http://blog.iscsky.net
'http://weibo.com/liuwt123
'***************************************************************
%>
<%
dim conn,connstr
on error resume next
connstr="DRIVER={Microsoft Access Driver (*.mdb)};DBQ="&Server.MapPath(DbLocal)
Set conn=Server.CreateObject("ADODB.CONNECTION")
conn.open connstr
%>