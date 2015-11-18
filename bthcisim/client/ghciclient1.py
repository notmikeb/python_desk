
# create a gui . input and output data


from tkinter import *
import socket

class App(Frame):
    def say_hi(self, event = None):
      print("hi there, everyone!", self.contents.get())
    def sendall(self, event):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        host = '192.168.99.19'
        port = 8081
        s.connect((host,port))
        s.sendall(self.contents.get().encode('utf-8'))
        data = s.recv(1024)
        if len(data) > 0:
          self.outtext.set(  ''.join(hex(i)[2:] for i in data))
        s.close()
    def createWidget(self):
        self.QUIT = Button(self)
        self.QUIT['text'] = 'QUIT'
        self.QUIT['command'] = root.destroy
        self.QUIT.pack({"side":"left"})

        self.hibtn = Button(self)
        self.hibtn["text"] = 'hello'
        self.hibtn['command'] = self.say_hi
        self.hibtn.pack()

        self.input = Entry()
        self.input.pack()
        self.output = Entry()
        self.output.pack()

        self.contents = StringVar()
        self.contents.set("test")
        self.outtext = StringVar()
        self.outtext.set("")
        self.input["textvar"] = self.contents
        self.input.bind('<Key-Return>', self.sendall)
        self.output['textvar'] = self.outtext
        
    def __init__(self, master= None):
        Frame.__init__(self, master)
        self.pack()
        self.createWidget()

root = Tk()
app = App(master = root)
app.mainloop()

