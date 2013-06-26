# -*- coding: gbk -*-
"""
A tool for get TV MAC address,can use to test network for electronic product.

http://blog.iscsky.net/
Copyright (c) 2012, Garfielt <liuwt123@gmail.com>.
License: MIT (see LICENSE.txt for details)
"""

import subprocess
import socket
import time
import wx
import threading
import urllib, urllib2
import json


class BindListening:
    def __init__(self):
        self.ip = "192.168.200.10"
        self.addr = ()
        self.rmac = ""
        self.lastmac = ""
        self.dominio = ''
        
        udps = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        udps.bind(('', 53))
        try:
            while 1:
                try:
                    self.data, self.addr = udps.recvfrom(1024)
                    print self.addr
                    self.DNSQuery()
                    udps.sendto(self.DNSResponse(), self.addr)
                except socket.error:
                    pass
                if self.addr[0] != self.ip:
                    self.DealInfo()
        except KeyboardInterrupt:
            print 'Finalizando'
            udps.close()

    def DealInfo(self):
        global frame
        rmac = self.Ip2Mac()
        rmac = rmac.replace("-", "")
        if rmac[0:4].lower() <> "e0bc":
            print "volid here"
            #return 200
        if rmac == self.lastmac:
            return 200
        else:
            self.lastmac = rmac
        frame.reSetvalue(self.lastmac)
        frame.tip = self.ip
        print "New %s=>%s" % (rmac, self.addr[0])

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
            print "Error DNSQuery!"
    
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

class MainWindow(wx.Frame):

    def __init__(self):
        self.ismac = 0
        self.macsize = 42
        self.tvidsize = 38
        self.twidth = 800
        self.totalnum = 0
        self.tip = ''
        
        
        wx.Frame.__init__(self, None, -1, '整机授权扫描系统 - Power By 新品验证支持平台', 
                size=(960, 500))
        
        menu = wx.Menu()
        simple = menu.Append(-1, "清除授权")
        menu.AppendSeparator()
        exit = menu.Append(-1, "退出")
        self.Bind(wx.EVT_MENU, self.onClearMac, simple)
        self.Bind(wx.EVT_MENU, self.OnExit, exit)
        menuBar = wx.MenuBar()
        menuBar.Append(menu, "附加功能")
        self.SetMenuBar(menuBar)

        
        panel = wx.Panel(self, -1)
        
        hbox = wx.BoxSizer(wx.HORIZONTAL)
        fbox = wx.FlexGridSizer(3, 2,30, 30)

        macLabel = wx.StaticText(panel, -1, 'MAC:',style=wx.TE_CENTER)
        macLabel.SetFont(wx.Font(48, wx.SWISS, wx.NORMAL, wx.BOLD,
              False, 'Tahoma'))
        
        self.macText = wx.TextCtrl(panel, -1, "wait...", 
                size=(self.twidth, -1),style=wx.TE_READONLY)
        self.macText.SetForegroundColour("red")
        self.macText.SetBackgroundColour("yellow")
        font = wx.Font(self.macsize, wx.DEFAULT, wx.NORMAL, wx.BOLD)
        self.macText.SetFont(font)

        idlabel = wx.StaticText(panel, -1, '机编:',style=wx.TE_CENTER)
        idlabel.SetFont(wx.Font(48, wx.SWISS, wx.NORMAL, wx.BOLD,
              False, 'Tahoma'))
        
        self.idText = wx.TextCtrl(panel, -1, "", size=(self.twidth, -1),
                                  style=wx.TE_PROCESS_ENTER)
        self.idText.SetForegroundColour("red")
        self.idText.SetBackgroundColour("blue")
        self.idText.SetMaxLength(24)
        font = wx.Font(self.tvidsize, wx.DEFAULT, wx.NORMAL, wx.BOLD)
        self.idText.SetFont(font)
        
        tslabel = wx.StaticText(panel, -1, '授权:',style=wx.TE_CENTER)
        tslabel.SetFont(wx.Font(48, wx.SWISS, wx.NORMAL, wx.BOLD,
              False, 'Tahoma'))
        
        self.sqlx = wx.StaticText(panel, -1, ' NN ',style=wx.TE_CENTER)
        self.sqlx.SetForegroundColour("red")
        font = wx.Font(self.macsize, wx.DEFAULT, wx.NORMAL, wx.BOLD)
        self.sqlx.SetFont(font)
        
        numlabel = wx.StaticText(panel, -1, '   单班产量:',style=wx.TE_CENTER)
        numlabel.SetFont(wx.Font(48, wx.SWISS, wx.NORMAL, wx.BOLD,
              False, 'Tahoma'))
              
        self.num = wx.TextCtrl(panel, -1, "0", 
                size=(200, -1),style=wx.TE_READONLY)
        self.num.SetForegroundColour("green")
        font = wx.Font(self.macsize, wx.DEFAULT, wx.NORMAL, wx.BOLD)
        self.num.SetFont(font)
        
        xhlabel = wx.StaticText(panel, -1, '型号:',style=wx.TE_CENTER)
        xhlabel.SetFont(wx.Font(48, wx.SWISS, wx.NORMAL, wx.BOLD,
              False, 'Tahoma'))
        
        self.xhxx = wx.StaticText(panel, -1, '',style=wx.TE_CENTER)
        self.xhxx.SetForegroundColour("red")
        font = wx.Font(self.macsize, wx.DEFAULT, wx.NORMAL, wx.BOLD)
        self.xhxx.SetFont(font)
        
        toline = wx.BoxSizer(wx.HORIZONTAL)
        toline.Add(self.sqlx, 0, wx.EXPAND)
        toline.Add(numlabel, 0, wx.EXPAND)
        toline.Add(self.num, 0, wx.EXPAND)
        
        fbox.AddMany([(macLabel), (self.macText, 1, wx.EXPAND),(idlabel), 
                      (self.idText, 1, wx.EXPAND),(tslabel), (toline),(xhlabel),(self.xhxx)])
        hbox.Add(fbox, 1, wx.ALL | wx.EXPAND, 15)
        panel.SetSizer(hbox)

        self.Bind(wx.EVT_TEXT_ENTER, self.onEnter,self.idText)
        self.idText.SetSelection(0,25)
    def onEnter(self,event):
        if self.ismac == 0:
            self.macText.SetValue("Not ready")
            self.idText.SetSelection(0,25)
            return 0
        else:
            t = int(time.time())
            Tid = self.idText.GetValue()
            Tmac = self.macText.GetValue()
            data = urllib.urlencode({'opt':"adddata", 
                                     'mac':Tmac,'sern':Tid,'pline':'dz01'})
            try:
                print "Add TV:%s(Mac:%s)" % (Tid,Tmac),
                rs = urllib2.urlopen('http://192.168.200.10/mac.asp?t=%i' % t, data)
                #print rs.read()
                ds = json.loads(rs.read())
                print " --- %s" % ds['stat']
                if ds['stat'] == "ok":
                    self.sqlx.SetLabel(ds['mtype'])
                    self.sqlx.SetForegroundColour("green")
                    self.xhxx.SetLabel(ds['xh'])
                    self.totalnum = self.totalnum + 1
                    self.num.SetValue(str(self.totalnum))
                else:
                    print "FAIL!"
            except :
                print "Except!!"
            self.tip = ''
            #ds = json.loads(resp.read())
            #print ds['statue']
            self.ismac = 0
            self.macText.SetBackgroundColour("yellow")
            self.macText.SetValue("wait...")
            self.idText.SetSelection(0,25)
    def onClearMac(self,event):
        if self.tip == "":
            self.showMessage("请先等待网络连接完成！")
            return
        dlg = wx.TextEntryDialog(None, "请不要拔掉网线，电视机进工厂菜单，然后扫描确认码完成操作！",
                '清除整机授权！', '清除请输入$next')
        if dlg.ShowModal() == wx.ID_OK:
            if dlg.GetValue()=="$next":
                import telnetlib
                try:
                    tn = telnetlib.Telnet(self.tip)
                    #tn.read_until("#")
                    time.sleep(0.5)
                    tn.write("\n")
                    time.sleep(0.3)
                    tn.write('debug iw da0 s1fa8 d00\n')
                    time.sleep(0.5)
                    tn.write('debug iw da0 s1fa8\n')
                    time.sleep(0.5)
                    tn.write("reboot\n")
                    tn.close()
                except :
                    self.showMessage("连接失败，请确认网络已连接，整机已完成进工厂操作！")
        dlg.Destroy()
        
    def OnExit(self, event):
        self.Close()
    
    def showMessage(self, msg):
        wx.MessageBox(msg)
        
    def reSetvalue(self,value):
        #t = int(time.time())
        #data = urllib.urlencode({'opt':"check",'mac':self.macText.GetValue(),'pline':'dz03'})
        #try:
            #resp = urllib2.urlopen('http://liuwt123.corp.haier.com/check.asp?t=%i' % t, data)
        #except :
            #pass
        #ds = json.loads(resp.read())
        #print ds
        #print "New MAC:%s" % value
        self.macText.SetValue(value)
        self.macText.SetBackgroundColour("green")
        self.ismac = 1
        self.idText.SetSelection(0,24)
        self.sqlx.SetLabel("NN")
        self.sqlx.SetForegroundColour("red")


if __name__ == "__main__":
    app = wx.PySimpleApp()
    frame = MainWindow()
    frame.Show()
    threading.Thread(target = BindListening, args = (), name = 'DNS').start()
    app.MainLoop()
    #threading.Thread(target = loopFrame, args = (), name = 'Frame').start()
