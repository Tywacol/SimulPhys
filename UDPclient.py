import cmd, argparse, socket, time, math

class SimulationShell(cmd.Cmd):
	intro = 'Welcome to the simulation shell.   Type help or ? to list commands.\n'
	prompt = '(Ascenseur) '
	file = None

    # ----- basic simulation commands -----
	def default(self, line):
		sock.sendto(bytes(line, "utf-8"), (UDP_IP, UDP_PORT))
		if line == "stop":
			quitter()


	def do_undo(self, arg):
		'Undo (repeatedly) the last turtle action(s):  UNDO'
	def do_reset(self, arg):
		'Clear the screen and return turtle to center:  RESET'
	def do_quitter(self, arg):
		'Stop recording, close the simulation window, and exit:  BYE'
		print('Thank you for using the Simulation !')
		sock.sendto(bytes("quit", "utf-8"), (UDP_IP, UDP_PORT))
		self.close()
		return True

	# ----- record and playback -----
	def do_record(self, arg):
		'Save future commands to filename:  RECORD script.cmd'
		self.file = open(arg, 'w')
	def do_playback(self, arg):
		'Playback commands from a file:  PLAYBACK script.cmd'
		self.close()
		with open(arg) as f:
			self.cmdqueue.extend(f.read().splitlines())
	def do_wait(self, arg):
		'Wait a certain amount of time before the next command. Useful for playback'
		#utiliser math.cleil si bugsint
		time.sleep(math.ceil(float(arg))+1)
	def precmd(self, line):
		line = line.lower()
		if self.file and 'playback' not in line:
			print(line, file=self.file)
		return line
	def close(self):
		if self.file:
			self.file.close()
			self.file = None

	do_q = do_quitter


if __name__ == '__main__':

	parser = argparse.ArgumentParser(description='Process some integers.')
	parser.add_argument('-i','--ip', dest='UDP_IP', default="127.0.0.1",
		help='Specify UDP target IP. Default is 127.0.0.1')
	parser.add_argument('-p','--port', dest='UDP_PORT', default=4242,
		help='Specify UDP port. Default is 4242')
	
	args = parser.parse_args()

	UDP_IP = args.UDP_IP
	UDP_PORT = int(args.UDP_PORT)

	print("UDP target IP:", UDP_IP)
	print("UDP target port:", UDP_PORT)


	# Client
	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP

	# Lancement du shell
	SimulationShell().cmdloop()
	sock.close()
	print("Fermeture de la commande..")
