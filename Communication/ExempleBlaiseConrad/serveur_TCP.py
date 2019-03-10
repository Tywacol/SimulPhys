from Tkinter import *

import tkFileDialog
import tkMessageBox
import threading
import socket

def affMessage(msg):
	tkMessageBox.showinfo("Message",msg)

varServeur = {}

class serveurTCP(threading.Thread) :
	def __init__ (self,port):
		threading.Thread.__init__(self)
		self.port = port
	def run(self):
		data="OK"
		while data!="<STOP>" :
			self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
			print "avant bind"
			self.sock.bind(('', self.port))
			print "avant listen"
			self.sock.listen(2)
			print "avant accept"
			conn, addr = self.sock.accept()
			print 'Connection par',addr
			while True:
				data = conn.recv(1024)
				if not data: break
				if data=="<STOP>" : break
				print "received message:", data
				if '=' in data :
					pos = data.find('=')
					nomVar = data[:pos]
					val = data[pos+1:]
					if nomVar in varServeur :
						varServeur[nomVar].set(val)
						conn.sendall('OK\n')
					else :
						conn.sendall('Err\n')
				else :
					nomVar = data
					if nomVar in varServeur :
						conn.sendall(str(varServeur[nomVar].get())+'\n')
					else :
						conn.sendall('Err\n')
				#if data.isdigit() : self.var.set(int(data))
				#conn.sendall(self.var.get())
			conn.close()
			self.sock.close()
		print "Serveur ferme"
		
	def halt(self):
		print "--> halt"
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		s.connect(("127.0.0.1", self.port))
		s.sendall('<STOP>')
		self.join()
		s.close()
			
class MainFenetre(Tk):
	def __init__(self):
		Tk.__init__(self)

		self.sens = 1
		
		self.Valeur = StringVar()
		self.Valeur.set(50)
		
		# Création d'un widget Scale
		echelle = Scale(self,from_=-100,to=100,resolution=10,orient=HORIZONTAL,
			length=300,width=20,label="Offset",tickinterval=20,variable=self.Valeur,command=self.maj)
		echelle.pack(padx=10,pady=10)
		
		# Création d'un widget Button (bouton +)
		Button(self,text="+",command=self.plus).pack(padx=10,pady=10)
		
		# Création d'un widget Button (bouton -)
		Button(self,text="-",command=self.moins).pack(padx=10,pady=10)

		varServeur['val']=self.Valeur

		self.after(250,self.avanceSimulation)
		self.mainloop()
		
	def maj(self,nouvelleValeur):
		# nouvelle valeur en argument
		print(nouvelleValeur)
		
	def plus(self):
		self.Valeur.set(str(int(self.Valeur.get())+10))
		#print(self.Valeur.get())
	
	def moins(self):
		self.Valeur.set(str(int(self.Valeur.get())-10))
		#print(self.Valeur.get())
		
	def avanceSimulation(self):
		if int(self.Valeur.get())>80 :
			self.sens = -1
		if int(self.Valeur.get())<-80 :
			self.sens = 1
		if self.sens>0 :
			self.plus()
		else :
			self.moins()
		self.after(250,self.avanceSimulation)
		

		
def go():
	MainFenetre()

if __name__=='__main__':
	clientNet = serveurTCP( 5011 )
	clientNet.start()
	go()
	clientNet.halt()
