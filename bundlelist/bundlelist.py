import sys
import os
from PyQt4 import QtGui, QtCore
from PyQt4.QtGui import *
from PyQt4.QtGui import QInputDialog
from PyQt4.QtCore import *

import shutil

# article http://stackoverflow.com/questions/4151637/pyqt4-drag-and-drop-files-into-qlistwidget

class TestListView(QtGui.QListWidget):
    def __init__(self, type, parent=None):
        super(TestListView, self).__init__(parent)
        self.setAcceptDrops(True)
        self.setIconSize(QtCore.QSize(72, 72))

    def dragEnterEvent(self, event):
        if event.mimeData().hasUrls:
            event.accept()
        else:
            event.ignore()

    def dragMoveEvent(self, event):
        if event.mimeData().hasUrls:
            event.setDropAction(QtCore.Qt.CopyAction)
            event.accept()
        else:
            event.ignore()

    def dropEvent(self, event):
        if event.mimeData().hasUrls:
            event.setDropAction(QtCore.Qt.CopyAction)
            event.accept()
            links = []
            for url in event.mimeData().urls():
              links.append(str(url.toLocalFile()))
              print("links ", str(url.toLocalFile()))
            self.emit(QtCore.SIGNAL("dropped"), links)
            print("emit done")
        else:
            event.ignore()

class MainForm(QtGui.QMainWindow):
    def __init__(self, parent=None):
        super(MainForm, self).__init__(parent)
        wicon = QtGui.QIcon()
        wicon.addFile('bundlelist256.png', QtCore.QSize(256,256))
        wicon.addFile('bundlelist.png', QtCore.QSize(16,16))
        wicon.addFile('bundlelist.png', QtCore.QSize(24,24))
        wicon.addFile('bundlelist32.png', QtCore.QSize(32,32))
        wicon.addFile('bundlelist48.png', QtCore.QSize(48,48))
        wicon.addFile('bundlelist.png')
        self.setWindowIcon(wicon)

        self.view = TestListView(self)
        self.connect(self.view, QtCore.SIGNAL("dropped"), self.pictureDropped)
        self.setCentralWidget(self.view)
        self.setToolTip( self.getHelp())
        self.setWindowTitle("BundleList tool")
        self.setupMenu()
    def save(self):
      print("save is invoked")
      with open("list.txt", 'w') as f:
        for i in range(self.view.count()):
          f.write(self.view.item(i).text())
          f.write("\n")
      pass
    def load(self):
      print("load is invoked")
      with open("list.txt") as f:
        self.view.clear()
        list = f.read()
        lines = list.split('\n')
        for line in lines:
           if line != '':
             item = QtGui.QListWidgetItem(line, self.view)
             item.setStatusTip(line)
      pass
    def runtest(self):
      print("runcheck is invoked")
      print( "-" * 10 , " Start " , "-" * 10)
      content = ""
      if self.view.count() < 1:
        QMessageBox().question(self, 'No file', "No file or folder to clear", QtGui.QMessageBox.Yes, QtGui.QMessageBox.Yes)
        return
      for i in range(self.view.count()):
        filepath = self.view.item(i).text()
        data =  "Exist:" + str(os.path.exists(filepath)) + "  " + filepath
        content = content + "\n" + data
        print(data)
      print( "-" * 10 , " END " , "-" * 10)
      ret = QMessageBox().question(self, 'Message', content, QtGui.QMessageBox.Yes, QtGui.QMessageBox.Yes)
      pass
    def deleteFolder(self):
      if self.view.count() < 1:
        QMessageBox().question(self, 'No file', "please drag file or folder to this window before press delete", QtGui.QMessageBox.Yes, QtGui.QMessageBox.Yes)
        return
      text, ok = QInputDialog.getText(self, "Input 'del' to del all files", "Enter 'del' to delete all folders")
      if ok:
        print("okay ~ start to delete all files")
        for i in range(self.view.count()):
          if len(self.view.item(i).text()) > 3:
            # avoid to delete all files in
            shutil.rmtree(self.view.item(i).text(), ignore_errors=True)
          else:
            print("ignore to delete ", self.view.item(i).text())
      else:
        print("abort the deletion")
    def showHelp(self):
        text = "<h1>A drag-and-drop tool to delete folds in one button</h1>" 
        text = text + self.getHelp() + " email: notmikeb at gmail.com "
        QMessageBox().question(self, 'Help', text)

    def setupMenu(self):
      saveAction = QAction(QIcon('save.jpg'), '&save', self)
      saveAction.triggered.connect(self.save)
      loadAction = QAction(QIcon('load.jpg'), '&load', self)
      loadAction.triggered.connect(self.load)
      runtestAction = QAction(QIcon('runtest.jpg'), '&Runtest', self)
      runtestAction.triggered.connect(self.runtest)
      clearAction = QAction(QIcon('clear.jpg'), "&Clear", self)
      clearAction.triggered.connect(self.view.clear)
      delAction = QAction(QIcon('delete.jpg'), "&Delete", self)
      delAction.triggered.connect(self.deleteFolder)
      helpAction = QAction(QIcon('help.jpg'), "&Help", self)
      helpAction.triggered.connect(self.showHelp)

      toolBar = self.addToolBar('File')
      toolBar.addAction(saveAction)
      toolBar.addAction(loadAction)
      toolBar.addAction(runtestAction)
      toolBar.addAction(clearAction)
      toolBar.addAction(delAction)
      toolBar.addAction(helpAction)
      menuBar = self.menuBar()
      fileMenu = menuBar.addMenu('&File')
      fileMenu.addAction(saveAction)
      fileMenu.addAction(loadAction)
      fileMenu.addAction(helpAction)

      if os.path.exists('list.txt'):
        self.load()
    def getHelp(self):
      return "<h1><b> drag file or folder to this window and press 'Delete' Button to delete all files </b></h1> "

    def pictureDropped(self, l):
        for url in l:
            if os.path.exists(url):
                print(url)                
                print (type(url))
                icon = QtGui.QIcon(url)
                pixmap = icon.pixmap(72, 72)                
                icon = QtGui.QIcon(pixmap)
                item = QtGui.QListWidgetItem(url, self.view)
                item.setIcon(icon)        
                item.setStatusTip(url)        
                print("after url")

def main():
    app = QtGui.QApplication(sys.argv)
    form = MainForm()
    app.setWindowIcon(QIcon('bundlelist.png'))
    form.show()
    app.exec_()

if __name__ == '__main__':
    main()

