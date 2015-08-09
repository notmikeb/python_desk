"""
ZetCode pyQT5 tutorial
"""

import sys
from PyQt5.QtWidgets import QApplication, QWidget

if __name__ == '__main__':
  app = QApplication(sys.argv)
  print ("done app")
  w = QWidget()
  w.resize(250,150)
  w.move(500,300)
  print ( " move done ")
  w.setWindowTitle('Simple Dalong')
  w.show()
  print ("show done")

  app.exec_()