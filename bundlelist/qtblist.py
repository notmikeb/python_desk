import sys
import os
from PyQt4 import QtGui, QtCore
from PyQt4.QtGui import *

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

        self.view = TestListView(self)
        self.connect(self.view, QtCore.SIGNAL("dropped"), self.pictureDropped)
        self.setCentralWidget(self.view)
        self.setupMenu()
    def save(self):
      print("save is invoked")
      pass
    def load(self):
      print("load is invoked")
      pass
    def runtest(self):
      print("runcheck is invoked")
      pass

    def setupMenu(self):
      saveAction = QAction(QIcon('save.jpg'), '&save', self)
      saveAction.triggered.connect(self.save)
      loadAction = QAction(QIcon('load.jpg'), '&load', self)
      loadAction.triggered.connect(self.load)
      runtestAction = QAction(QIcon('runtest.jpg'), '&load', self)
      runtestAction.triggered.connect(self.runtest)

      toolBar = self.addToolBar('File')
      toolBar.addAction(saveAction)
      toolBar.addAction(loadAction)
      toolBar.addAction(runtestAction)
      menuBar = self.menuBar()
      fileMenu = menuBar.addMenu('&File')
      fileMenu.addAction(saveAction)
      fileMenu.addAction(loadAction)

    def pictureDropped(self, l):
        for url in l:
            if os.path.exists(url):
                print(url)                
                icon = QtGui.QIcon(url)
                pixmap = icon.pixmap(72, 72)                
                icon = QtGui.QIcon(pixmap)
                item = QtGui.QListWidgetItem(url, self.view)
                item.setIcon(icon)        
                item.setStatusTip(url)        

def main():
    app = QtGui.QApplication(sys.argv)
    form = MainForm()
    form.show()
    app.exec_()

if __name__ == '__main__':
    main()

