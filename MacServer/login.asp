<%
'***************************************************************
'author£ºliuwt123
'E-mail:liuwt123@gmail.com  liuweitao@haier.com
'http://blog.iscsky.net
'http://weibo.com/liuwt123
'***************************************************************
%>
<!--#include file = config.asp -->
<%
If request("action")="out" then
	session("in") = false
	session("power")= ""
	session("sid") = ""
End if
if request("pass") = sysadmin then
	session("power") = "admin"
	Response.Redirect "frames.asp"
end if
%>
<html>
<head>
<title>µÇÂ¼ - <%=sitename%></title>
<STYLE type="text/css">
<!--
a:link       {text-decoration: none; font-family: AdobeSm; color: #000000 }
a:visited    {text-decoration: none; color: #000000 }
A:hover      {COLOR: green; FONT-FAMILY: "ËÎÌå,MingLiU"; TEXT-DECORATION: underline}
body         {font-size: 9pt; font-family: ËÎÌå,MingLiU, Arial;color: #000000}
TD           {FONT-SIZE: 9pt; FONT-FAMILY: "ËÎÌå,MingLiU, Arial";color: #000000;table-layout:fixed;word-break:break-all}
p            {FONT-SIZE: 9pt; FONT-FAMILY: "ËÎÌå,MingLiU, Arial";color: #000000}
input        {FONT-SIZE: 9pt; FONT-FAMILY: "ËÎÌå,MingLiU, Arial";color: #000000}
body         {margin-top: 0; margin-bottom: 0;margin-left:0;margin-right:0; color: #000000}
select       {FONT-SIZE: 9PT;}
option       {FONT-SIZE: 9pt;}
textarea     {FONT-SIZE: 9pt;}
-->
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta http-equiv="Content-Language" content="zh-cn">
</head>
		
			
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" marginwidth="0" marginheight="0">

<!--webbot BOT="GeneratedScript" PREVIEW=" " startspan --><script Language="JavaScript" Type="text/javascript"><!--
function FrontPage_Form1_Validator(theForm){
	if (theForm.pass.value == ""){
		alert("ÇëÊäÈëÃÜÂëµÇÂ½£¡");
		theForm.pass.focus();
		return (false);
		}
	return (true);
}
//--></script><form method="POST" action="" target=_top name="FrontPage_Form1" onSubmit="return FrontPage_Form1_Validator(this)" language="JavaScript">
<div align="center">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" id="table9" >
		<tr>
			<td style="font-size: 9pt; font-family: ËÎÌå,MingLiU, Arial; color: #000000; table-layout: fixed; word-break: break-all">
			<div align="center">
				<table border="0" cellpadding="0" cellspacing="0"  background="images/login.jpg" width="563" height="364" id="table10">
					<tr>
						<td valign="top" >
						<div align="center">
							<div align="center">
								<table border="0" cellpadding="0" cellspacing="0" width="100%" id="table11">
									<tr>
										<td height="65" colspan="3" align="center" valign="middle"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                            <td width="18%" height="28">&nbsp;</td>
                                            <td width="82%" style="font-size:22px; font-weight:700;"><%=sitename%></td>
                                          </tr>
                                        </table></td>
						            </tr>
									<tr>
									  <td height="25" colspan="3">&nbsp;</td>
								  </tr>
									<tr>
									  <td height="40" colspan="3">&nbsp;</td>
								  </tr>
									<tr>
										<td width="207" height="111">¡¡</td>
										<td height="111">
										
										<table border="0" cellpadding="5" cellspacing="0" width="319" id="table12">
											<tr>
												<td width="114" align="center">
												ÃÜ¡¡Âë</td>
												<td width="205">
												&nbsp;<!--webbot bot="Validation" s-display-name="ÃÜÂë" b-value-required="TRUE" i-minimum-length="5" i-maximum-length="20" --><input type="password" name="pass" size="24" maxlength="20" style="font-size: 9pt; font-family: ËÎÌå,MingLiU, Arial; color: #000000"></td>
											</tr>
										  </table>										</td>
										<td width="37" height="111" style="font-size: 9pt; font-family: ËÎÌå,MingLiU, Arial; color: #000000; table-layout: fixed; word-break: break-all">¡¡</td>
									</tr>
									<tr>
										<td width="207">¡¡</td>
										<td>¡¡</td>
										<td width="37">¡¡</td>
									</tr>
									<tr>
										<td width="207">¡¡</td>
										<td>
										<p align="center">
											<input type="image" src=images/login001.jpg value="Ìá½»" name="B1">&nbsp;
											<a href="javascript:window.opener=null;window.close()"> 
											<img border="0" src="images/login002.jpg" width="72" height="21"></a></td>
										<td width="37">¡¡</td>
									</tr>
									<tr>
										<td width="207" height="56">¡¡</td>
										<td height="56">¡¡</td>
										<td width="37" height="56">¡¡</td>
									</tr>
									<tr>
										<td width="207">&nbsp;¡¡<font color="#FFBEC6"><%=year(now())&"-"&Month(now())&"-"&day(now())&" "&hour(time())&":"&Minute(now())&":"&Second(now())%></font></td>
										<td>&nbsp;</td>
										<td width="37">¡¡</td>
									</tr>
								</table>
						  </div>
						</div>
						</td>
					</tr>
			  </table>
			</div>
			</td>
		</tr>
	</table>
</div>
</form>

</body>

</html>