"""
this  is comment
"""

import sys
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from PyQt5.QtGui import *

class Button(QPushButton):
  def __init__(self, title, parent):
    super().__init__(title, parent)

  def mouseMoveEvent(self, e):
    if ( e.buttons() != Qt.RightButton):
      return

    mimeData = QMimeData()
    drag = QDrag(self)
    drag.setMimeData(mimeData)
    print ( " pos: ", e.pos(), " rect().topLeft() ", self.rect().topLeft())
    drag.setHotSpot( e.pos() - self.rect().topLeft())
    dropAction = drag.exec_(Qt.MoveAction)

  def mousePressEvent(self, e):
    print ( " mousePressEvent ")
    if( e.button() == Qt.LeftButton):
      print('press')

class Example(QWidget):
  def __init__(self):
    super().__init__()
    self.initUI()

  def initUI(self):
    self.setAcceptDrops(True)
    self.button  = Button('MyButton', self)
    self.button.move(100,50)
    self.setWindowTitle('Click or Move')
    self.setGeometry(300,300,300,150)

  def dragEnterEvent(self, e):
    e.accept()
  def dropEvent(self, e):
    position = e.pos()
    print( "drop at ", e.pos())
    self.button.move(position)
    e.setDropAction(Qt.MoveAction)
    e.accept()

if (__name__ == '__main__'):
   app = QApplication(sys.argv)
   ex  = Example()
   ex.show()
   app.exec_()
