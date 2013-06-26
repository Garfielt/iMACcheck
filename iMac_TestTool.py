# -*- coding: gbk -*-
"""
A tool for get TV MAC address,can use to test network for electronic product.

http://blog.iscsky.net/
Copyright (c) 2012, Garfielt <liuwt123@gmail.com>.
License: MIT (see LICENSE.txt for details)
"""

import os, sys
import subprocess
import socket
import time
import wx
import wx.grid
import threading
import urllib, urllib2
import json
import sqlite3, locale
import types
import telnetlib


idebug = 0
chmacs = ["1","2","3","4","5","6","7","8","9","0"]
PWD = os.path.dirname(os.path.abspath(sys.argv[0]))
today = time.strftime("%Y%m%d",time.localtime())
VERSION = "Final"
ReponseIp = "192.168.20.10"
Msflag = "e0b"

class DBStorage:
    def __init__(self, path):
        self.localcharset = locale.getdefaultlocale()[1]
        self.charset = 'gbk'
        self.path = path
        if type(path) == types.UnicodeType:
            self.path = path.encode(self.charset)
        self.db = sqlite3.connect(self.path)
        self.version = '' 
        
    def close(self):
        self.db.close()
        self.db = None

    def execute(self, sql, autocommit=True):
        self.db.execute(sql)
        if autocommit:
            self.db.commit()

    def execute_param(self, sql, param, autocommit=True):
        self.db.execute(sql, param)
        if autocommit:
            self.db.commit()

    def commit(self):
        self.db.commit()
        
    def rollback(self):
        self.db.rollback()

    def query(self, sql, iszip=True):
        if type(sql) == types.UnicodeType:
            sql = sql.encode(self.charset, 'ignore')
 
        cur = self.db.cursor()
        cur.execute(sql)
 
        res = cur.fetchall()
        ret = []

        if res and iszip:
            des = cur.description
            names = [x[0] for x in des]
 
            for line in res:
                ret.append(dict(zip(names, line))) 
        else:
            ret = res 

        cur.close()
        return ret 

    def query_one(self, sql):
        if type(sql) == types.UnicodeType:
            sql = sql.encode(self.charset, 'ignore')
 
        cur = self.db.cursor()
        cur.execute(sql)
        one = cur.fetchone()
        cur.close()
        
        if one:
            return one[0]
        return None

    def last_insert_id(self):
        sql = "select last_insert_rowid()"
        cur = self.db.cursor()
        cur.execute(sql)
        one = cur.fetchone()
        cur.close()

        return one[0]


class BindDnsListening:
    def __init__(self):
        self.ip = ReponseIp
        self.addr = ''
        self.dominio = ''
        
        udps = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        udps.bind(('', 53))
        try:
            while True:
                try:
                    self.data, self.addr = udps.recvfrom(1024)
                    print self.addr
                    self.DNSQuery()
                    udps.sendto(self.DNSResponse(), self.addr)
                except:
                    print "Socket Error Here!"
                if self.addr[0] != self.ip:
                    self.DealInfo()
        except:
            print "Dns Except!"

    def DealInfo(self):
        global frame
        rmac = self.Ip2Mac()
        #扫描后防止网线未拔重复上传,start
        if rmac in chmacs:
            return 200
        #end
        #chmacs.insert(0, rmac)
        if len(chmacs)>50:
            del chmacs[20:]
        rmac = rmac.replace("-", "")
        if rmac[0:3].lower() != Msflag:
            print "Not Match!"
            #return 200
        
        frame.reSetvalue(rmac)
        idebug and debmsg("New TVset Frmo DNS")
        frame.tip = self.addr[0]
        idebug and debmsg("New %s=>%s" % (rmac, self.addr[0]))

    def Ip2Mac(self):
        cmd = "ping %s -n 2" % self.addr[0]
        subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
        pi = subprocess.Popen("arp -a", shell=True, stdout=subprocess.PIPE)
        output, errors = pi.communicate()
        del errors
        if output is not None :
            arpitems = output.split("\n")
            for i in arpitems:
                if self.addr[0] in i:
                    return i.split()[1]  
        return "00-00-00-00-00-00"

    def DNSQuery(self):
        try:
            tipo = (ord(self.data[2]) >> 3) & 15   # Opcode bits
            if tipo == 0:                     # Standard query
                ini = 12
                lon = ord(self.data[ini])
                while lon != 0:
                    self.dominio += self.data[ini+1:ini+lon+1] + '.'
                    ini += lon + 1
                    lon = ord(self.data[ini])
        except:
            pass
    
    def DNSResponse(self):
        '''Creat the dns response.
        
        Creat the response strings.'''
        packet = ''
        if self.dominio:
            packet += self.data[:2] + "\x81\x80"
            packet += self.data[4:6] + self.data[4:6] + '\x00\x00\x00\x00'   # Questions and Answers Counts
            packet += self.data[12:]                                         # Original Domain Name Question
            packet += '\xc0\x0c'                                             # Pointer to domain name
            packet += '\x00\x01\x00\x01\x00\x00\x00\x3c\x00\x04'             # Response type, ttl and resource data length -> 4 bytes
            packet += str.join('', map(lambda x: chr(int(x)), self.ip.split('.'))) # 4bytes of IP
        return packet


class BindArpListening:
    def __init__(self):
        self.ip = ReponseIp
        self.rmac = ''
        self.nmac = ""
        self.tmacs = []
        
        self.GetArp()
        for i in self.tmacs:
            chmacs.append(i)

        while True:
            try:
                self.GetArp()
                if len(self.tmacs)>1:
                    for onemac in self.tmacs:
                        if onemac in chmacs:
                            pass
                        else:
                            self.nmac = onemac
                            self.DealInfo()
                if len(chmacs)>50:
                    del chmacs[20:]
                time.sleep(1)
            except:
                print "Loop Error Here!"

    def GetArp(self):
        self.tmacs = []
        pi = subprocess.Popen("arp -a", shell=True, stdout=subprocess.PIPE)
        output, errors = pi.communicate()
        del errors

        if output is not None :
            arpitems = output.split("\n")
            if len(arpitems)>4:
                del arpitems[0:3]
                del arpitems[-1]
                for i in arpitems:
                    t = i.split()
                    self.tmacs.append(t[1])

    def DealInfo(self):
        global frame
        chmacs.insert(0, self.rmac)
        self.rmac = self.nmac.replace("-", "")
        if self.rmac[0:3].lower() != Msflag:
            if idebug == 0:
                return 200
        frame.tip = tip = self.Mac2Ip()
        frame.reSetvalue(self.rmac)
        idebug and debmsg("From ARP")
        idebug and debmsg("New %s=>%s" % (self.rmac, tip))

    def Mac2Ip(self):
        pi = subprocess.Popen("arp -a", shell=True, stdout=subprocess.PIPE)
        output, errors = pi.communicate()
        del errors
        if output is not None :
            arpitems = output.split("\n")
            for i in arpitems:
                if self.nmac in i:
                    return i.split()[0]
        return "127.0.0.1"

class MainWindow(wx.Frame):

    def __init__(self):
        self.dmacs = []
        self.totalnum = 0
        self.tip = ''
        self.localflag = 0
        self.doadd = 0
        self.remainrows = 15
        
        wx.Frame.__init__(self, None, -1, '青岛电子整机授权扫描工具   PowerBy:Garfielt http://blog.iscsky.net',  
                size=(960, 750))
        self.SetBackgroundColour('D4D0C8')
        
        menu = wx.Menu()
        simple = menu.Append(-1, "清除授权")
        menuBar = wx.MenuBar()
        menuBar.Append(menu, "附加功能")
        self.SetMenuBar(menuBar)
        
        hbox = wx.BoxSizer(wx.VERTICAL)
        f0box = wx.FlexGridSizer(2, 2, 5, 5)
        f1box = wx.FlexGridSizer(1, 4,10, 10)
        
        #----------------- 青岛电子整机授权扫描工具 ------------------
        ltLabel = wx.StaticText(self, -1, '青岛电子整机授权扫描工具', style=wx.TE_CENTER)
        ltLabel.SetFont(wx.Font(36, wx.SWISS, wx.NORMAL, wx.BOLD, False, 'Tahoma'))
        
        LableFont = wx.Font(48, wx.SWISS, wx.NORMAL, wx.BOLD, False, 'Tahoma')

        macLabel = wx.StaticText(self, -1, 'MAC:',style=wx.TE_CENTER)
        macLabel.SetFont(LableFont)
        
        self.macText = wx.TextCtrl(self, -1, "等待MAC...", size=(620, -1),style=wx.TE_READONLY)
        self.macText.SetForegroundColour("red")
        self.macText.SetBackgroundColour("yellow")
        font = wx.Font(42, wx.DEFAULT, wx.NORMAL, wx.BOLD)
        self.macText.SetFont(font)
        
        self.maccount = wx.StaticText(self, -1, '  0 ',style=wx.TE_CENTER)
        self.maccount.SetForegroundColour("red")
        font = wx.Font(50, wx.DEFAULT, wx.NORMAL, wx.BOLD)
        self.maccount.SetFont(font)
        
        h0box = wx.FlexGridSizer(1, 2, 1, 1)
        h0box.AddMany([(self.macText), (self.maccount)])

        idlabel = wx.StaticText(self, -1, '机编:',style=wx.TE_CENTER)
        idlabel.SetFont(wx.Font(48, wx.SWISS, wx.NORMAL, wx.BOLD, False, 'Tahoma'))
        
        self.idText = wx.TextCtrl(self, -1, "", size=(750, -1),
                                  style=wx.TE_PROCESS_ENTER)
        self.idText.SetForegroundColour("red")
        self.idText.SetBackgroundColour("blue")
        self.idText.SetMaxLength(20)
        font = wx.Font(40, wx.DEFAULT, wx.NORMAL, wx.BOLD)
        self.idText.SetFont(font)
        
        font = wx.Font(48, wx.DEFAULT, wx.NORMAL, wx.BOLD)
        tslabel = wx.StaticText(self, -1, '授权:',style=wx.TE_CENTER)
        tslabel.SetFont(wx.Font(48, wx.SWISS, wx.NORMAL, wx.BOLD,
              False, 'Tahoma'))
        
        self.sqlx = wx.StaticText(self, -1, ' NN ',style=wx.TE_CENTER)
        self.sqlx.SetForegroundColour("red")
        self.sqlx.SetFont(font)
        
        numlabel = wx.StaticText(self, -1, '   单班产量:',style=wx.TE_CENTER)
        numlabel.SetFont(wx.Font(48, wx.SWISS, wx.NORMAL, wx.BOLD,
              False, 'Tahoma'))
        
        self.num = wx.StaticText(self, -1, ' 000 ',style=wx.TE_CENTER)
        self.num.SetForegroundColour("green")
        self.num.SetFont(font)
        
        self.colLabels = ["ID", "型号", "机 编", "MAC", "软件版本"]
        self.grid = wx.grid.Grid(self)
        self.grid.CreateGrid(1, 5)
        self.grid.EnableEditing(False)
        self.grid.SetLabelFont(wx.Font(16, wx.SWISS, wx.NORMAL, wx.BOLD))
        
        for row in range(0, 5):
            self.grid.SetColLabelValue(row, self.colLabels[row]) 
        #self.grid.SetRowLabelValue(0, "")
        #self.grid.SetDefaultColSize(100)
        #self.grid.SetDefaultRowSize(36)
        #self.grid.SetColSize(1, 200)
        self.grid.SetDefaultCellFont(wx.Font(12, wx.SWISS, wx.NORMAL, wx.BOLD))
        self.grid.SetDefaultCellAlignment(wx.ALIGN_CENTRE, wx.ALIGN_CENTRE)
        self.grid.SetRowSize(0, 25)
        self.grid.AutoSizeColumns(True)
        #self.grid.SetRowSize(1, 100)
        self.grid.SetColSize(0, 60)
        self.grid.SetColSize(1, 80)
        self.grid.SetColSize(2, 260)
        self.grid.SetColSize(3, 200)
        self.grid.SetColSize(4, 200)
        
        f0box.AddMany([(macLabel), (h0box), (idlabel), (self.idText)])
        f1box.AddMany([(tslabel), (self.sqlx), (numlabel),(self.num)])
        hbox.Add(ltLabel, 0, wx.ALL | wx.EXPAND, 5)
        hbox.Add(f0box, 0, wx.ALL | wx.EXPAND, 5)
        hbox.Add(f1box, 0, wx.ALL | wx.EXPAND, 5)
        hbox.Add(self.grid, 1, wx.ALL | wx.EXPAND, 5)
        self.SetSizer(hbox)

        self.Bind(wx.EVT_TEXT_ENTER, self.onEnter,self.idText)
        self.idText.SetSelection(0,25)
        self.idText.SetFocus()
        self.Bind(wx.EVT_CLOSE, self.OnCloseWindow)

        
    def onEnter(self, event):
        macnum = len(self.dmacs)
        if macnum == 0:
            self.macText.SetValue("请等待或执行网络升级")
            self.idText.SetSelection(0,24)
            return 0
        else:
            timestamp = int(time.time())
            self.tid = self.idText.GetValue()
            if len(self.tid) == 6:
                self.DIYcmd(Tid)
                return 0
            if len(self.tid) != 20:
                self.showMessage('整机条码位数异常，请重新扫描！')
                self.idText.SetSelection(0,24)
                return 0
            self.tmac = self.macText.GetValue()
            pdata = urllib.urlencode({"mac":self.tmac, "sern":self.tid})
    
            try:
                print 'http://192.168.10.10/cgi/mac/index.php/add/%i' % timestamp
                rs = urllib2.urlopen('http://192.168.10.10/cgi/mac/index.php/add/%i' % timestamp, pdata)
                ds = json.loads(rs.read())
            except :
                print "Http Except!"
                Sqldb  = os.path.join(PWD, "macs.db")
                Creattable = 1
                if os.path.isfile(Sqldb):
                    Creattable = 0
                db = DBStorage(Sqldb)
                if Creattable:
                    db.execute("CREATE TABLE IF NOT EXISTS macrecords (id integer PRIMARY KEY, \
                                mac varchar(15), sern varchar(24), ptime int(10))")
                sql = "select ptime from macrecords where mac='%s'" % self.tmac
                result = db.query(sql)
                if len(result)>0:
                    idebug and debmsg("MAC use Again!")
                    self.showMessage("MAC重复上传！")
                    self.dmacs.pop()
                    self.Disnum()
                    return 0
                sql = "insert into macrecords (mac,sern,ptime) values (?,?,?)"
                db.execute_param(sql,(self.tmac, self.tid, timestamp))
                db.close()
            self.dmacs.pop()
            print ds
            self.totalnum = self.totalnum + 1
            self.num.SetLabel(str(self.totalnum))
            self.sqlx.SetLabel(ds["mtype"])
            self.sqlx.SetForegroundColour("green")
            self.Disnum(ds)
    def Disnum(self, rdata):
        macnum = len(self.dmacs)
        if macnum == 0:
            self.maccount.SetForegroundColour("red")
            self.maccount.SetLabel("  0")
            self.macText.SetBackgroundColour("yellow")
            self.macText.SetValue("等待MAC...")
        else:
            self.maccount.SetForegroundColour("green")
            self.maccount.SetLabel("  " + str(macnum))
            self.macText.SetBackgroundColour("green")
            self.macText.SetValue(self.dmacs[-1])
            self.sqlx.SetForegroundColour("red")
            self.sqlx.SetLabel("NN")
        self.idText.SetSelection(0,24)
        if self.doadd:
            self.grid.InsertRows(0, 1)
        self.grid.SetRowSize(0, 25)
        self.grid.SetCellValue(0, 0, str(self.totalnum))
        self.grid.SetCellValue(0, 1, str(rdata["id"]))
        self.grid.SetCellValue(0, 2, self.tid)
        self.grid.SetCellValue(0, 3, self.tmac)
        self.grid.SetCellValue(0, 4, rdata["soft"])
        self.doadd = 1
        if self.totalnum > self.remainrows and self.totalnum % self.remainrows == 6:
            self.grid.DeleteRows(self.remainrows, 10)
        
    def OnExit(self, event):
        self.Close()

    def OnCloseWindow(self, event):
        print "exit"
        self.Destroy()

    def DIYcmd(self, cmdstr):
        if self.tip == "":
            self.showMessage("还未正常连接电视，请连接后再试！")
            return
        try:
            print self.tip
            tn = telnetlib.Telnet(self.tip)
            tn.read_until("#")
            time.sleep(1)
            tn.write("\n")
            mfile = open(cmdstr + '.txt', 'r')
            for line in mfile.readlines():
                line = line.replace("\n", "")
                time.sleep(1)
                tn.write(line)
            time.sleep(1)
            tn.close()
            self.idText.SetSelection(0,24)
        except:
            self.showMessage("连接失败，请确认网络已连接，整机已完成进工厂操作！")
    
    def showMessage(self, msg):
        mdlg = wx.TextEntryDialog(None, msg, '异常！', '清除请输入$next')
        if mdlg.ShowModal() == wx.ID_OK:
            pass
        mdlg.Destroy()
        
    def reSetvalue(self,value):
        self.dmacs.insert(0, value)
        macnum = len(self.dmacs)
        self.maccount.SetForegroundColour("green")
        self.maccount.SetLabel("  " + str(macnum))
        if macnum == 1:
            self.macText.SetBackgroundColour("green")
            self.macText.SetValue(value)
            self.idText.SetSelection(0,24)
            self.sqlx.SetForegroundColour("red")
            self.sqlx.SetLabel("NN")


if __name__ == "__main__":
    app = wx.PySimpleApp()
    frame = MainWindow()
    frame.Show()
    DNSthread = threading.Thread(target = BindDnsListening, args = (), name = 'DNSthread')
    DNSthread.start()
    try:
        Arpthread = threading.Thread(target = BindArpListening, args = (), name = 'Arpthread')
        Arpthread.start()
    except:
        print "Arpthread Can't Start!"
    app.MainLoop()