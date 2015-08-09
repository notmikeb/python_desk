"""
ZetCode pyQT5 tutorial
"""

import sys
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton,QToolTip
from PyQt5.QtGui import QIcon, QFont
from PyQt5.QtCore import QCoreApplication

class Example(QWidget):
  def __init__(self):
    super().__init__()
    self.initUI()
  def tryclose(self, *arg, **arglist):
    print("try close")
    QCoreApplication.instance().quit()
  def initUI(self):
    QToolTip.setFont(QFont('tahoma', 16))
    self.setToolTip('This is a <b>QWidget</b> widget')

    btn = QPushButton('Quit', self)
    #btn.clicked.connect(QCoreApplication.instance().quit)
    btn.clicked.connect(self.tryclose)
    btn.setToolTip('this is a <b>QPushButton</b>')
    btn.resize(btn.sizeHint())
    btn.move(50,50)

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
