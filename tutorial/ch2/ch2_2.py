import sys
from PyQt4 import *
from PyQt4 import QtGui

"""
ZetCode PyQt4 tutotrial 
use layoutmanagement

"""

class Example(QtGui.QWidget):
  def __init__(self):
    super(Example, self).__init__()
    self.initUI()

  def initUI(self):
    grid = QtGui.QGridLayout()
    self.setLayout(grid)

    names =  [ 'Cls','Back', '', 'Close', '7', '8', '9', '/', '4','5','6', '*', '3', '2', '1', '-', '0', '.', '=', '+']
    positions = [ (i , j ) for i in range(5) for j in range(4)]
    for position,name in zip(positions, names):
      if name == '':
        continue
      button = QtGui.QPushButton(name)
      print(" ", *position)
      grid.addWidget(button, *position)
      # position is a tuple, *position will extract the tuple and put it as 2 parameters ( first parameter is button, second is position[0], thried is position[1]
    self.move(300,150)
    self.setWindowTitle('Calculator')
    self.show()

def main():
  app = QtGui.QApplication(sys.argv)
  ex = Example()
  sys.exit(app.exec_())

if __name__ == '__main__':
  main()
