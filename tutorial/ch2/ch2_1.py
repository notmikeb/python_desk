"""
ZetCode pyQT5 tutorial
"""

import sys
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton,QToolTip
from PyQt5.QtGui import QIcon, QFont
from PyQt5.QtCore import QCoreApplication
from PyQt5.QtWidgets import QMessageBox, QDesktopWidget, QTextEdit, QMainWindow, QAction

class Example(QMainWindow):
  def __init__(self):
    super().__init__()
    self.initUI()
  def closeEvent(self, event):
    print("try close")
    reply = QMessageBox.question( self, 'Message title', "Are you sure to quit?", QMessageBox.Yes | QMessageBox.No, QMessageBox.No)
    if reply == QMessageBox.Yes:
      QCoreApplication.instance().quit()
      event.accept()
    else:
      event.ignore()
  
  def addMenu(self):
    textEdit = QTextEdit()
    self.setCentralWidget(textEdit)
    # use QMainWindow so we could add it as CentralWidget

    exitAction = QAction(QIcon('exit24.png'), 'Exit', self)
    exitAction.setShortcut('Ctrl+Q')
    exitAction.setStatusTip('Exit application')
    exitAction.triggered.connect(self.close)
    dummyAction = QAction(QIcon('dummy.png'), 'Dummy', self)
    # create a Qaction for menu and toolbar

    self.statusBar()

    menubar = self.menuBar()
    fileMenu = menubar.addMenu('&File')
    fileMenu.addAction(exitAction)
    # add action to menubar which automatically create a menubar

    toolbar = self.addToolBar('Exit')
    toolbar.addAction(exitAction)
    toolbar.addAction(dummyAction)
    # add action to toolbar

  def initUI(self):
    QToolTip.setFont(QFont('tahoma', 16))
    self.setToolTip('This is a <b>QWidget</b> widget')
    self.addMenu()

    qr = self.frameGeometry()
    print( " qr " , str(qr))
    cp = QDesktopWidget().availableGeometry().center()
    print (" cp ", str(cp))
    qr.moveCenter(cp)
    print( " cp " , str(cp))
    self.move(qr.topLeft())

    self.setGeometry(300,300, 300, 220)
    self.setWindowTitle('Icon')
    self.setWindowIcon(QIcon('web.jpg'))
    self.show()



if __name__ == '__main__':
  app = QApplication(sys.argv)
  print ("done app")
  print ("show done")

  ex = Example()
  app.exec_()
