"""
ZetCode pyQT5 tutorial
"""

import sys
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton,QToolTip
from PyQt5.QtGui import QIcon, QFont
from PyQt5.QtCore import QCoreApplication
from PyQt5.QtWidgets import QMessageBox, QDesktopWidget

class Example(QWidget):
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
  def initUI(self):
    QToolTip.setFont(QFont('tahoma', 16))
    self.setToolTip('This is a <b>QWidget</b> widget')

    qr = self.frameGeometry()
    print( " qr " , str(qr))
    cp = QDesktopWidget().availableGeometry().center()
    print (" cp ", str(cp))
    qr.moveCenter(cp)
    print( " cp " , str(cp))
    self.move(qr.topLeft())
    btn = QPushButton('Quit', self)
    btn.clicked.connect(QCoreApplication.instance().quit)
    btn.setToolTip('this is a <b>QPushButton</b>')
    btn.resize(btn.sizeHint())

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
